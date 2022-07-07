Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F5556A881
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 18:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiGGQpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 12:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiGGQp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 12:45:29 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949B830565
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 09:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1657212329; x=1688748329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xgpw/Sy6Um+KApzZqS/Ey+N5SJTHZpa34u3Pgmh6/Wg=;
  b=pQKNJmULa90xz3PdlbqNcpUyMbMa9ZCHzDOPhZthb0a0ZKrRF6BIxjZg
   i7dPmSnxMHfwd0y0WrpvWSuKSaJmiFTTWHEMibSD37k9LcyOcHh8hDFVX
   oQT+5mZWhnZpu7LHxLwrB+0yld6KQOpUOfPbs0T3SS2IWXFWBcu9M8HBc
   E=;
X-IronPort-AV: E=Sophos;i="5.92,253,1650931200"; 
   d="scan'208";a="235877807"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 07 Jul 2022 16:45:13 +0000
Received: from EX13D18EUC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com (Postfix) with ESMTPS id CCDCAE2AB3;
        Thu,  7 Jul 2022 16:45:09 +0000 (UTC)
Received: from uff0320b8bd5a51.ant.amazon.com (10.43.161.187) by
 EX13D18EUC002.ant.amazon.com (10.43.164.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 7 Jul 2022 16:45:04 +0000
From:   Simon Veith <sveith@amazon.de>
To:     <dwmw2@infradead.org>
CC:     <dff@amazon.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <oupton@google.com>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <sveith@amazon.de>, <tglx@linutronix.de>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>
Subject: [PATCH 2/2] KVM: x86: add KVM_VCPU_TSC_VALUE attribute
Date:   Thu, 7 Jul 2022 18:43:26 +0200
Message-ID: <20220707164326.394601-2-sveith@amazon.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707164326.394601-1-sveith@amazon.de>
References: <0e2a26715dc3c1fb383af2f4ced6c9e1cf40b95b.camel@infradead.org>
 <20220707164326.394601-1-sveith@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.187]
X-ClientProxiedBy: EX13D46UWC001.ant.amazon.com (10.43.162.126) To
 EX13D18EUC002.ant.amazon.com (10.43.164.50)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the previous commit having added a KVM clock time reference to
kvm_synchronize_tsc(), this patch adds a new TSC attribute
KVM_VCPU_TSC_VALUE that allows for setting the TSC value in a way that
is unaffected by scheduling delays.

Userspace provides a struct kvm_vcpu_tsc_value consisting of a matched
pair of ( guest TSC value, KVM clock value ). The TSC value that will
ultimately be written is adjusted to account for the time which has
elapsed since the given KVM clock time point.

In order to allow userspace to retrieve an accurate time reference
atomically, without being affected by scheduling delays between
KVM_GET_CLOCK and KVM_GET_MSRS, the KVM_GET_DEVICE_ATTR implementation
for this attribute uses get_kvmclock() internally and returns a struct
kvm_vcpu_tsc_value with both values in one go. If get_kvmclock()
supports the KVM_CLOCK_HOST_TSC flag, the two will be based on one and
the same host TSC reading.

Signed-off-by: Simon Veith <sveith@amazon.de>
---
 Documentation/virt/kvm/devices/vcpu.rst | 22 +++++++++++++
 arch/x86/include/uapi/asm/kvm.h         |  7 +++++
 arch/x86/kvm/x86.c                      | 41 +++++++++++++++++++++++++
 tools/arch/x86/include/uapi/asm/kvm.h   |  7 +++++
 4 files changed, 77 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 716aa3edae14..a9506d902b0a 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -263,3 +263,25 @@ From the destination VMM process:
 
 7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
    respective value derived in the previous step.
+
+4.2 ATTRIBUTE: KVM_VCPU_TSC_VALUE
+
+:Parameters: kvm_device_attr.addr points to a struct kvm_vcpu_tsc_value
+
+Returns:
+
+	 ======= ======================================
+	 -EFAULT Error reading/writing the provided
+		 parameter address.
+	 -ENXIO  Attribute not supported
+	 ======= ======================================
+
+Gets or sets a matched pair of guest TSC value and KVM clock time point.
+
+When setting the TSC value through this attribute, a corresponding KVM clock
+reference time point (as retrieved by KVM_GET_CLOCK in the clock field) must be
+provided.
+
+The actual TSC value written will be adjusted based on the time that has
+elapsed since the provided reference time point, taking TSC scaling into
+account.
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 21614807a2cb..79de9e34cfa8 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -525,5 +525,12 @@ struct kvm_pmu_event_filter {
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
+#define   KVM_VCPU_TSC_VALUE 1 /* attribute for the TSC value */
+
+/* for KVM_VCPU_TSC_VALUE */
+struct kvm_vcpu_tsc_value {
+	__u64 tsc_val;
+	__u64 kvm_ns;
+};
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a44d083f1bf9..ed8c2729eae2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5169,6 +5169,7 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET:
+	case KVM_VCPU_TSC_VALUE:
 		r = 0;
 		break;
 	default:
@@ -5194,6 +5195,32 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
 			break;
 		r = 0;
 		break;
+	case KVM_VCPU_TSC_VALUE: {
+		struct kvm_vcpu_tsc_value __user *tsc_value_arg;
+		struct kvm_vcpu_tsc_value tsc_value;
+		struct kvm_clock_data kvm_clock;
+		u64 host_tsc, guest_tsc, ratio, offset;
+
+		get_kvmclock(vcpu->kvm, &kvm_clock);
+		if (kvm_clock.flags & KVM_CLOCK_HOST_TSC)
+			host_tsc = kvm_clock.host_tsc;
+		else
+			host_tsc = rdtsc();
+
+		ratio = vcpu->arch.l1_tsc_scaling_ratio;
+		offset = vcpu->arch.l1_tsc_offset;
+		guest_tsc = kvm_scale_tsc(host_tsc, ratio) + offset;
+
+		tsc_value.kvm_ns = kvm_clock.clock;
+		tsc_value.tsc_val = guest_tsc;
+
+		tsc_value_arg = (struct kvm_vcpu_tsc_value __user *)uaddr;
+		r = -EFAULT;
+		if (copy_to_user(tsc_value_arg, &tsc_value, sizeof(tsc_value)))
+			break;
+		r = 0;
+		break;
+	}
 	default:
 		r = -ENXIO;
 	}
@@ -5236,6 +5263,20 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 		r = 0;
 		break;
 	}
+	case KVM_VCPU_TSC_VALUE: {
+		struct kvm_vcpu_tsc_value __user *tsc_value_arg;
+		struct kvm_vcpu_tsc_value tsc_value;
+
+		tsc_value_arg = (struct kvm_vcpu_tsc_value __user *)uaddr;
+		r = -EFAULT;
+		if (copy_from_user(&tsc_value, tsc_value_arg, sizeof(tsc_value)))
+			break;
+
+		kvm_synchronize_tsc(vcpu, tsc_value.tsc_val, &tsc_value.kvm_ns);
+
+		r = 0;
+		break;
+	}
 	default:
 		r = -ENXIO;
 	}
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 21614807a2cb..79de9e34cfa8 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -525,5 +525,12 @@ struct kvm_pmu_event_filter {
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
+#define   KVM_VCPU_TSC_VALUE 1 /* attribute for the TSC value */
+
+/* for KVM_VCPU_TSC_VALUE */
+struct kvm_vcpu_tsc_value {
+	__u64 tsc_val;
+	__u64 kvm_ns;
+};
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.25.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



