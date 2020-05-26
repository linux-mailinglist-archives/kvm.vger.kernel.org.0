Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D88199FC8
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 22:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgCaUKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 16:10:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727720AbgCaUKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 16:10:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585685403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9tiFegyAVmmAr1Blf/zEd5Ozn4gaTM1GAemIQes9+TA=;
        b=MoDl2nTOr+jbsLEszC8VV16bROOGjp4feAM5qKrXjEvwA4oaDV+mZ9OM8uXxRssu3GwiHh
        fHPKlPDZODFgS0i3rfjL5aUBNnlcVXssHnB41EbbWuKwlq7vTx4fq+Hgbw14Nxu7Y/t2UC
        oZtKdYxunbCQkewBYsVFIBNa9rSf55I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-1tFIgNMfN5aGcZnHSE4dlg-1; Tue, 31 Mar 2020 15:40:27 -0400
X-MC-Unique: 1tFIgNMfN5aGcZnHSE4dlg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2260DB6F;
        Tue, 31 Mar 2020 19:40:26 +0000 (UTC)
Received: from horse.redhat.com (ovpn-118-184.phx2.redhat.com [10.3.118.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3339160BE0;
        Tue, 31 Mar 2020 19:40:21 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 595FB220291; Tue, 31 Mar 2020 15:40:20 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, vgoyal@redhat.com, aarcange@redhat.com,
        dhildenb@redhat.com
Subject: [RFC PATCH 0/4] kvm,x86,async_pf: Add capability to return page fault error 
Date:   Tue, 31 Mar 2020 15:40:07 -0400
Message-Id: <20200331194011.24834-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current page fault logic in kvm seems to assume that host will always
be able to successfully resolve page fault soon or later. There does not
seem to be any mechanism for hypervisor to return an error say -EFAULT
to guest.

We are writing DAX support for virtiofs filesystem. This will allow
directly mapping host page cache page into guest user space process.

This mechanism now needs additional support from kvm where a page
fault error needs to be propagated back into guest. For example, say
guest process mmaped a file (and this did an mmap of portion of file
on host into qemu address space). Now file gets truncated and guest
process tries to access mapped region. It will generate page fault
in host and it will try to map the file page. But page is not there
any more so it will get back -EFAULT. But there is no mechanism to
send this information back to guest and currently host sends PAGE_READY
to guest, guest retries and fault happens again and host tries to
resolve page fault again and this becomes an infinite loop.

This is an RFC patch series which tries to extend async page fault
mechanism to also be able to communicate back that an error occurred
while resolving the page fault. Then guest can send SIGBUS to guest
process accessing the truncated portion of file. Or if access happened
in guest kernel, then it can try to fixup the exception and jump
to error handling portion if there is one. =20

This patch series tries to solve it only for x86 architecture on intel
vmx only. Also it does not solve the problem for nested virtualization.

Is extending async page fault mechanism to report error back to
guest is right thing to do? Or there needs to be another way.

Any feedback or comments are welcome.=20

Thanks
Vivek

Vivek Goyal (4):
  kvm: Add capability to be able to report async pf error to guest
  kvm: async_pf: Send faulting gva address in case of error
  kvm: Always get async page notifications
  kvm,x86,async_pf: Search exception tables in case of error

 Documentation/virt/kvm/cpuid.rst     |  4 ++
 Documentation/virt/kvm/msr.rst       | 11 +++--
 arch/x86/include/asm/kvm_host.h      | 17 ++++++-
 arch/x86/include/asm/kvm_para.h      | 13 +++---
 arch/x86/include/asm/vmx.h           |  2 +
 arch/x86/include/uapi/asm/kvm_para.h | 12 ++++-
 arch/x86/kernel/kvm.c                | 69 ++++++++++++++++++++++------
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/mmu/mmu.c               | 12 +++--
 arch/x86/kvm/vmx/nested.c            |  2 +-
 arch/x86/kvm/vmx/vmx.c               | 11 ++++-
 arch/x86/kvm/x86.c                   | 37 +++++++++++----
 include/linux/kvm_host.h             |  1 +
 virt/kvm/async_pf.c                  |  6 ++-
 14 files changed, 156 insertions(+), 44 deletions(-)

--=20
2.25.1

