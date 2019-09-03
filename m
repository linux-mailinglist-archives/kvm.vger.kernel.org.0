Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE69A6B7B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 16:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfICOaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 10:30:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:18802 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729566AbfICOaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 10:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567521013; x=1599057013;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=i7AwnRT7NByHxBFu3Yt3euqrSCjx8giqctEq9HJ4eH4=;
  b=vqN/bJgq4L9WJFBj02CMxNcQyUGDI0JuwEtR9PufXzUoBg/taNC95kuT
   S+Lwgfzh2oF6b46J2lCsQBspTUeDQTX9MLRs/r4RZTGWiMWYDF1j6XI2Y
   zP1Fcpsdy4N1dbyx+nC31P3youJMEYRy75YIZNkyz1iZJnHy+IAkXrVLX
   c=;
X-IronPort-AV: E=Sophos;i="5.64,463,1559520000"; 
   d="scan'208";a="700284570"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 03 Sep 2019 14:30:06 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 9E72FA22D3;
        Tue,  3 Sep 2019 14:30:05 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 3 Sep 2019 14:30:05 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.242) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 3 Sep 2019 14:30:01 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] KVM: Only use posted interrupts for Fixes/LowPrio MSIs
Date:   Tue, 3 Sep 2019 16:29:52 +0200
Message-ID: <20190903142954.3429-1-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.242]
X-ClientProxiedBy: EX13D27UWA002.ant.amazon.com (10.43.160.30) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MSI-X descriptor has a "delivery mode" field which can be set to
various different targets, such as "Fixed" (default), SMI, NMI or INIT.

Usually when we pass devices into guests, we only ever see this MSI-X
descriptor configured as Fixed, so nobody realized that the other modes
were broken when using posted interrupts.

With posted interrupts, we end up configuring these special modes just
the same as a Fixed interrupt. That means instead of generating an SMI,
we inject a normal GSI into the guest.

Of course, that if completely broken. These two patches attempt to fix
the situation for x86 systems. If anyone has a great idea how to generalize
the filtering though, I'm all ears.


Alex

Alexander Graf (2):
  KVM: VMX: Disable posted interrupts for odd IRQs
  KVM: SVM: Disable posted interrupts for odd IRQs

 arch/x86/kvm/svm.c     | 16 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++++
 2 files changed, 38 insertions(+)

-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



