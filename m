Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD1E25AB96
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 15:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgIBNAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 09:00:20 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:52785 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbgIBNAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 09:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599051607; x=1630587607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Ha37pneV5eOVZUeuWC7QqFvJ7Q9pmzplIGAkkuelCw=;
  b=GvCD086USmpxj/EscsuTR0DYmiVSpdsfml9HZXH30QJwgCJL4EbHuHo7
   7VyLpKt9LRiKugaXtIUpOpwYYd0AobOKig28yCw8h40xOAh66KUkjakiM
   +wRBd9gARgkH+FFL24qH7a33AjYQJMlZj2Z3ZFTDApg5iebtjNS292TQX
   I=;
X-IronPort-AV: E=Sophos;i="5.76,383,1592870400"; 
   d="scan'208";a="64794681"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 02 Sep 2020 12:59:55 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 73480A25F4;
        Wed,  2 Sep 2020 12:59:53 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 12:59:53 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.145) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 12:59:49 +0000
From:   Alexander Graf <graf@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 2/7] KVM: x86: Add infrastructure for MSR filtering
Date:   Wed, 2 Sep 2020 14:59:30 +0200
Message-ID: <20200902125935.20646-3-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200902125935.20646-1-graf@amazon.com>
References: <20200902125935.20646-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D08UWB004.ant.amazon.com (10.43.161.232) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the following commits we will add pieces of MSR filtering.
To ensure that code compiles even with the feature half-merged, let's add
a few stubs and struct definitions before the real patches start.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/include/uapi/asm/kvm.h | 2 ++
 arch/x86/kvm/x86.c              | 6 ++++++
 arch/x86/kvm/x86.h              | 1 +
 4 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6608c8efbfa1..a9e3cc13bca6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1272,6 +1272,7 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0780f97c1850..50650cfd235a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -192,6 +192,8 @@ struct kvm_msr_list {
 	__u32 indices[0];
 };
 
+#define KVM_MSR_ALLOW_READ  (1 << 0)
+#define KVM_MSR_ALLOW_WRITE (1 << 1)
 
 struct kvm_cpuid_entry {
 	__u32 function;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4d285bf054fb..6024d1cdea5a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1472,6 +1472,12 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
+bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
+{
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_msr_allowed);
+
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific fault
  * checks are bypassed if @host_initiated is %true.
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6eb62e97e59f..1d67d9168b8c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -365,5 +365,6 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
+bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 
 #endif
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



