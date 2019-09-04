Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E8BA8492
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 15:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbfIDNfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 09:35:30 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:59068 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfIDNf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 09:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567604129; x=1599140129;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=2h7LEOemSqSqyfSBSe/LZjqqJl3VgwAeehys9LlM7oE=;
  b=XLoNF5QqxEgRypynV+ebSm212vVvmCQtgtNi1sf1nTDVO8CtalqbUS/5
   FkESBMNfWIwdHikqviRhLifswCSySA/BoxBWneE0IqAHdxlg4y7LAEbqG
   OzRhgj7TJHWbhtGZjnBWouogL/DYRbLdGAqv43pjsOMnZ8WudRLYA21eF
   s=;
X-IronPort-AV: E=Sophos;i="5.64,467,1559520000"; 
   d="scan'208";a="748980393"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Sep 2019 13:35:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id A6DB3A2BBA;
        Wed,  4 Sep 2019 13:35:22 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 13:35:22 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.160.160) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 13:35:18 +0000
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
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 0/2] KVM: Only use posted interrupts for Fixed/LowPrio MSIs
Date:   Wed, 4 Sep 2019 15:35:09 +0200
Message-ID: <20190904133511.17540-1-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D31UWA002.ant.amazon.com (10.43.160.82) To
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

---

v1 -> v2:

  - Make error message more unique
  - Update commit message to point to __apic_accept_irq()

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



