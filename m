Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CA656A880
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 18:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbiGGQpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 12:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbiGGQpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 12:45:00 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F723BC7
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 09:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1657212298; x=1688748298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n5aFrbgZVOv9YibM8gxKX0A6aIY0of/HyM6iRyJ+n0M=;
  b=V4BTNX7DbE4T9NAk25D4SN+3An4yF5f3wxpEEn6CaYyVr77vTBIaUtY0
   Ehu8ddFWKo+TzN0DtpP02jyWte5uOqEhmyEaJvmr5mFtmWa0Bp7GcOQmx
   HQGUti1S16OUjU6LknDKOItNPMtOpecagEJ1DkwCt6qklwY5jgKGfRvIT
   0=;
X-IronPort-AV: E=Sophos;i="5.92,253,1650931200"; 
   d="scan'208";a="105919799"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 07 Jul 2022 16:44:38 +0000
Received: from EX13D18EUC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 2C5AAC0298;
        Thu,  7 Jul 2022 16:44:35 +0000 (UTC)
Received: from uff0320b8bd5a51.ant.amazon.com (10.43.161.187) by
 EX13D18EUC002.ant.amazon.com (10.43.164.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 7 Jul 2022 16:44:29 +0000
From:   Simon Veith <sveith@amazon.de>
To:     <dwmw2@infradead.org>
CC:     <dff@amazon.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <oupton@google.com>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <sveith@amazon.de>, <tglx@linutronix.de>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 1/2] KVM: x86: add KVM clock time reference arg to kvm_write_tsc()
Date:   Thu, 7 Jul 2022 18:43:25 +0200
Message-ID: <20220707164326.394601-1-sveith@amazon.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0e2a26715dc3c1fb383af2f4ced6c9e1cf40b95b.camel@infradead.org>
References: <0e2a26715dc3c1fb383af2f4ced6c9e1cf40b95b.camel@infradead.org>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.187]
X-ClientProxiedBy: EX13D46UWC001.ant.amazon.com (10.43.162.126) To
 EX13D18EUC002.ant.amazon.com (10.43.164.50)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Time Stamp Counter (TSC) value register can be set to an absolute
value using the KVM_SET_MSRS ioctl, which calls kvm_synchronize_tsc()
internally.

Since this is a per-vCPU register, and vCPUs are often managed by
separate threads, setting a uniform TSC value across all vCPUs is
challenging: After live migration, for example, the TSC value may need
to be adjusted to account for the migration downtime. Ideally, we would
want each vCPU to be adjusted by the same offset; but if we compute the
offset centrally, the TSC value may become out of date due to scheduling
delays by the time that each vCPU thread gets around to issuing
KVM_SET_MSRS.

In preparation for the next patch, this change adds an optional, KVM
clock based time reference argument to kvm_synchronize_tsc(). This
argument, if present, is understood to mean "the TSC value being written
was valid at this corresponding KVM clock time point".

kvm_synchronize_tsc() will then use this clock reference to adjust the
TSC value being written for any delays that have been incurred since the
provided TSC value was valid.

Co-developed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Simon Veith <sveith@amazon.de>
---
 arch/x86/kvm/x86.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1910e1e78b15..a44d083f1bf9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2629,7 +2629,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm_track_tsc_matching(vcpu);
 }
 
-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, u64 *kvm_ns)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
@@ -2638,12 +2638,24 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	bool synchronizing = false;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-	offset = kvm_compute_l1_tsc_offset(vcpu, data);
 	ns = get_kvmclock_base_ns();
+
+	if (kvm_ns) {
+		/*
+		 * We have been provided a KVM clock reference time point at
+		 * which this TSC value was correct.
+		 * Use this time point to compensate for any delays that were
+		 * incurred since that TSC value was valid.
+		 */
+		s64 delta_ns = ns + vcpu->kvm->arch.kvmclock_offset - *kvm_ns;
+		data += nsec_to_cycles(vcpu, (u64)delta_ns);
+	}
+
+	offset = kvm_compute_l1_tsc_offset(vcpu, data);
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
-		if (data == 0) {
+		if (data == 0 && !kvm_ns) {
 			/*
 			 * detection of vcpu initialization -- need to sync
 			 * with other vCPUs. This particularly helps to keep
@@ -3581,7 +3593,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, data, NULL);
 		} else {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
@@ -11392,7 +11404,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, 0, NULL);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */
-- 
2.25.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



