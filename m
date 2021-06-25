Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546FC3B4145
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 12:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhFYKRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 06:17:50 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:6083 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhFYKRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 06:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1624616129; x=1656152129;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=AYMLO7ZOEMoAsELuu/au8tDMGQQPAkqWORPBg71AvnQ=;
  b=om+PzfrBq2FrcOv3K6vG9ILdDfWwaWs/ZcCQyuCY4nfJNPNZVzW3SCBl
   ovN6zLmUecWpu2y34/2p3r80LY4iqo5tmpc2oJbPrrWMFG2pcvS5X74GS
   Ho+NXPXYYvNo5LlgloWoiduW0h3HmW1nIJBEX/Sxq4E2h8X4W8+3CGJdC
   M=;
X-IronPort-AV: E=Sophos;i="5.83,298,1616457600"; 
   d="scan'208";a="121286456"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 25 Jun 2021 10:15:22 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id B184DA1F48;
        Fri, 25 Jun 2021 10:15:21 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.69) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 25 Jun 2021 10:15:16 +0000
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
Subject: [PATCH v2 0/6] Handle hypercall code overlay page in userspace
Date:   Fri, 25 Jun 2021 12:14:35 +0200
Message-ID: <cover.1624615713.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D14UWC004.ant.amazon.com (10.43.162.99) To
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

v1 -> v2:
  - Don't allow hypercall page set when guest_os_id is not set.
  - Address Alex's comments:
      - Move filtering logic to 6/6 so we don't break bisection.
      - Reword comment on filters
      - Provide a default RDMSR handler
      - Set run->msr.error = 1 to retain existing behaviour

Siddharth Chandrasekaran (6):
  hyper-v: Overlay abstraction for synic event and msg pages
  hyper-v: Use -1 as invalid overlay address
  kvm/i386: Stop using cpu->kvm_msr_buf in kvm_put_one_msr()
  kvm/i386: Avoid multiple calls to check_extension(KVM_CAP_HYPERV)
  kvm/i386: Add support for user space MSR filtering
  hyper-v: Handle hypercall code page as an overlay page

 hw/hyperv/hyperv.c         | 116 +++++++++++++++++++--------------
 include/hw/hyperv/hyperv.h |  15 +++++
 target/i386/kvm/hyperv.c   | 101 +++++++++++++++++++++++++++--
 target/i386/kvm/hyperv.h   |   4 ++
 target/i386/kvm/kvm.c      | 128 +++++++++++++++++++++++++++++++++++--
 target/i386/kvm/kvm_i386.h |   1 +
 6 files changed, 305 insertions(+), 60 deletions(-)

-- 
2.17.1



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



