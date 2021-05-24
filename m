Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595AB38F3E2
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhEXT4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:56:55 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:26576 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhEXT4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 15:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1621886126; x=1653422126;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=RnjgERzwsTvZMNSKxKoybCX6U1tec5pVi0tZHHfXmPE=;
  b=ksG/h/qDHgt9gT7MqwtwjZNSRtnafvg0QnSzILS2sOcjRXwJQa1+1n8Y
   i9YMdbx4zBHeEk5YV1wWyMRVUx0WfDBEVcKv0ADv0QLkKbzrydrBzDEDK
   XvZNtk28v7vtnA6+JSDXjr8Jh/16kn4LaxPCTS87DtcOym9VSRtmUkWUL
   M=;
X-IronPort-AV: E=Sophos;i="5.82,325,1613433600"; 
   d="scan'208";a="111398490"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 24 May 2021 19:55:19 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id CF734A22AC;
        Mon, 24 May 2021 19:55:18 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.253) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 24 May 2021 19:55:14 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH 0/6] Handle hypercall code overlay page in userspace
Date:   Mon, 24 May 2021 21:54:03 +0200
Message-ID: <cover.1621885749.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyprcall code page is specified in the Hyper-V TLFS to be an overlay
page, ie., guest chooses a GPA and the host _places_ a page at that
location, making it visible to the guest and the existing page becomes
inaccessible. Similarly when disabled, the host should _remove_ the
overlay and the old page should become visible to the guest.

Now, KVM directly patches the instructions into the guest chosen GPA for
the hypercall code page. Strictly speaking this is guest memory
corruption as the hyper-v TLFS specifies that the underlying page should
be preserved. Since the guest seldom moves the hypercall code page
around, it didn't see any problems till now. When trying to implement
VSM API, we are seeing some exotic use of overlay pages which start
expecting the underlying page to be intact. To handle those cases, we
need a more generic approach handling these primitives.

This patchset tries build an infrastructure for handling overlay pages
in general by using the new user space MSR filtering feature of KVM to
filter out writes to overlay MSRs, handle them in user space and then
forward those writes back to KVM so it gets an opportunity to write
contents into the page that was overlaid here. Additionally it does some
housekeeping here and there.

P.S. This is a follow up to the my initial approach of handling this in
kernel, see [1] for discussions.

~ Sid.

[1]: https://lore.kernel.org/kvm/20210423090333.21910-1-sidcha@amazon.de/

Siddharth Chandrasekaran (6):
  hyper-v: Overlay abstraction for synic event and msg pages
  hyper-v: Use -1 as invalid overlay address
  kvm/i386: Stop using cpu->kvm_msr_buf in kvm_put_one_msr()
  kvm/i386: Avoid multiple calls to check_extension(KVM_CAP_HYPERV)
  kvm/i386: Add support for user space MSR filtering
  hyper-v: Handle hypercall code page as an overlay page

 hw/hyperv/hyperv.c         | 116 +++++++++++++++++++++----------------
 include/hw/hyperv/hyperv.h |  15 +++++
 target/i386/kvm/hyperv.c   |  94 ++++++++++++++++++++++++++++--
 target/i386/kvm/hyperv.h   |   4 ++
 target/i386/kvm/kvm.c      | 113 ++++++++++++++++++++++++++++++++++--
 target/i386/kvm/kvm_i386.h |   1 +
 6 files changed, 282 insertions(+), 61 deletions(-)

-- 
2.17.1



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



