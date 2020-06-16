Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E18B1FC12A
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 23:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgFPVtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 17:49:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35136 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726311AbgFPVtQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 17:49:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592344154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uv780jpNQSYzquFkmBB1m3mWJ1oYSVcoXMxNLu+Q8MQ=;
        b=Rg9C1Stka9T5KHBzH1e0vJi5ep0klrGSWjHxzpapBn87iQ9N8k8n2bMPbhU+LgNxfUSBlS
        ++ZiA61XnjsCNWNwh/KLiqYSusbLc/mDg75JC1H/L6+S2cNi15/p9OrTVcxCJZapxnAraF
        0XakA0vcFblYcZRNGnqOaAXrjPuzqik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-E7zfeKlANEm4BKAq4l_3xQ-1; Tue, 16 Jun 2020 17:49:11 -0400
X-MC-Unique: E7zfeKlANEm4BKAq4l_3xQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7A0C872FF2;
        Tue, 16 Jun 2020 21:49:09 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-132.rdu2.redhat.com [10.10.114.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E62360BE2;
        Tue, 16 Jun 2020 21:49:03 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C17E522363A; Tue, 16 Jun 2020 17:49:02 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, vgoyal@redhat.com, vkuznets@redhat.com,
        pbonzini@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com
Subject: [RFC PATCH 0/3] kvm,x86: Improve kvm page fault error handling
Date:   Tue, 16 Jun 2020 17:48:44 -0400
Message-Id: <20200616214847.24482-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is an RFC patch series to improve error handling. Compiled and
tested only on x86. Have not tested or thought about nested
configuration yet.

This is built on top of Vitaly's patches sending "page ready" events
using interrupts. But it has not been rebased on top of recent
interrupt rework yet. Patches are also available here.

https://github.com/rhvgoyal/linux/commits/asyncpf-error-v1

Problem
=======
Currently kvm page fault error handling seems very unpredictable. If
a page fault fails and kvm decided not to do async page fault, then
upon error, we exit to user space and qemu prints
"error: kvm run failed Bad address" and associated cpu state and VM
freezes.

But if kvm decided to async page fault, then async_pf_execute() simply
ignores the error code (-EFAULT) returned by get_user_pages_remote()
and injects "page ready" event into guest. Guest retries the faulting
instruction and takes exit again and kvm again retries async page
fault and this cycle continues and forms an infinite loop.

I can reproduce this -EFAULT situation easily. Created a file
(nvdimm.img) and exported it to guest as nvdimm device. Inside the guest
created ext4 filesystem on device and mounted with dax enabled. Now mmap a
file (/mnt/pmem0/foo.txt) and load from it one page at a time. Also
truncate nvdimm.img on host. So when guest tries to load from nvdimm,
its not mapped in page tables anymore (due to truncation) and we take
exit and try to fault in the page. Now we either exit to user space
with bad address or and get into infinite loop depending on state of
filesystem in guest whether at the time of exit we were in kernel mode
or user space mode.

I am implementing DAX support in virtiofs (which is very close to what
nvdimm will do) and I have scenarios where a DAX mapped file in guest
can get truncated on host and page fault errors can happen. I need to
do better error handling instead of guest and host spinning infinitely.
It otherwise sort of creates an attack vector where a kata container
has to mount virtiofs using DAX, mmap a file, and then truncate that
file on host and then access it inside guest and we can hog kvm on
host in this infinite loop of trying to fault in page.

Proposed Solution
=================
So first idea is that how about we make the error behavior uniform. That
is when an error is encountered, we exit to qemu which prints the
error message and VM freezes. That will end the discrepancy in the
behavior of sync/async page fault. First patch of the series does
that.

Second idea is that if we are doing async page fault and if guest is
in a state so that we can inject "page not present" and "page ready"
events, then instead of exiting to user space, send error back to
guest as part of "page ready" event. This will allow guest to do
finer grained error handling. For example, send SIGBUS to offending
process. And whole of the VM does not have to go down. Second patch
implemented it.

Third idea is that find a way to inject error even when async page
fault can't be injected. Now if we disabled any kind of async page
fault delivery if guest is in kernel mode because this was racy.
Once we figure out a race free way  to be able to inject page
fault in guest (using #VE?), then use that to report errors back
to guest even when it is in kernel mode. And that will allow
guest to call fixup_exception() and possibly recover from situation
otherwise panic(). This can only be implemented once we have a
way race free way to inject an async page event into guest. So this
is a future TBD item. For now, if we took exit and guest is in kernel
mode and error happened, we will vcpu_run() will fail and exit
to user space.  

I have only compiled and tested this series on x86. Before I refine
it further, wanted to post it for some feedback and see if this
the right direction or not.

Any feedback or comments are welcome.

Thanks
Vivek 

Vivek Goyal (3):
  kvm,x86: Force sync fault if previous attempts failed
  kvm: Add capability to be able to report async pf error to guest
  kvm, async_pf: Use FOLL_WRITE only for write faults

 Documentation/virt/kvm/cpuid.rst     |  4 +++
 Documentation/virt/kvm/msr.rst       | 10 +++---
 arch/x86/include/asm/kvm_host.h      |  4 +++
 arch/x86/include/asm/kvm_para.h      |  8 ++---
 arch/x86/include/uapi/asm/kvm_para.h | 10 ++++--
 arch/x86/kernel/kvm.c                | 34 +++++++++++++++----
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/mmu.h                   |  2 +-
 arch/x86/kvm/mmu/mmu.c               | 11 ++++---
 arch/x86/kvm/x86.c                   | 49 +++++++++++++++++++++++-----
 include/linux/kvm_host.h             |  5 ++-
 virt/kvm/async_pf.c                  | 15 +++++++--
 12 files changed, 119 insertions(+), 36 deletions(-)

-- 
2.25.4

