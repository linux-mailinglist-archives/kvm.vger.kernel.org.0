Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D66259FCA
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 22:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgIAUP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 16:15:57 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:5552 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbgIAUPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 16:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598991351; x=1630527351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=VYPzQ7D+jLbCQnGNcQsVhw02s7DcBHMB0lYxDbNXIBs=;
  b=suJs/KuRg+H0mvdxI9liVrpL9AVF2ySrgdEIN1q9qJh6MdLMMx/Ep4L0
   lvlVvkIfFR9uBLcMllWAFQ5dCZWoM8+9v8DRfsDC3afwJ1ypl/B3y/VC9
   8vGU8kUdpP0QoFSYtGX8rKO+HI7IhjjR+3X2JTUy0X7LCK1D3lyhBCFKm
   c=;
X-IronPort-AV: E=Sophos;i="5.76,380,1592870400"; 
   d="scan'208";a="64602816"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Sep 2020 20:15:36 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 9773DA1C7D;
        Tue,  1 Sep 2020 20:15:35 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Sep 2020 20:15:35 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.160.229) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Sep 2020 20:15:31 +0000
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
Date:   Tue, 1 Sep 2020 22:15:12 +0200
Message-ID: <20200901201517.29086-3-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901201517.29086-1-graf@amazon.com>
References: <20200901201517.29086-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D18UWC001.ant.amazon.com (10.43.162.105) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
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
 arch/x86/kvm/x86.c              | 5 +++++
 arch/x86/kvm/x86.h              | 1 +
 4 files changed, 9 insertions(+)

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
index 4d285bf054fb..6a921145754b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1472,6 +1472,11 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
+bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
+{
+	return true;
+}
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



