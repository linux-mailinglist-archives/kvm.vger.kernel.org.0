Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D085259FD2
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 22:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgIAUQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 16:16:27 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:54271 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbgIAUPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 16:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598991351; x=1630527351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Ph/A67bIhyw6DFbl4Ir4VqjT1J/KB7CX/pltexmW3mY=;
  b=G6jPiXec93zy+9eWo+qGeebesm4CkoLRplQ5s5G7txqJAUIxhHQBY2Ur
   /4A4FKb6nUbW+NaCzXheZqphX/VQJdXzHXuSIJ3z/ufwMSfqnNqiQ68Gn
   1L4Em0bvSTTMM/hh4T9cvyQHnmAFVIceSA8R0OBzBc0vMy4r+SdAv92EN
   w=;
X-IronPort-AV: E=Sophos;i="5.76,380,1592870400"; 
   d="scan'208";a="72781470"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 01 Sep 2020 20:15:46 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id A56CAA1887;
        Tue,  1 Sep 2020 20:15:42 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Sep 2020 20:15:41 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.160.229) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Sep 2020 20:15:38 +0000
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
Subject: [PATCH v6 4/7] KVM: x86: SVM: Prevent MSR passthrough when MSR access is denied
Date:   Tue, 1 Sep 2020 22:15:14 +0200
Message-ID: <20200901201517.29086-5-graf@amazon.com>
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

We will introduce the concept of MSRs that may not be handled in kernel
space soon. Some MSRs are directly passed through to the guest, effectively
making them handled by KVM from user space's point of view.

This patch introduces all logic required to ensure that MSRs that
user space wants trapped are not marked as direct access for guests.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/kvm/svm/svm.c | 78 +++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h |  7 ++++
 2 files changed, 77 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb673b59f7b7..6a3f4017dd98 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -91,7 +91,7 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
 static const struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is always on */
-} direct_access_msrs[] = {
+} direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
 	{ .index = MSR_STAR,				.always = true  },
 	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
 #ifdef CONFIG_X86_64
@@ -553,15 +553,40 @@ static int svm_cpu_init(int cpu)
 
 }
 
-static bool valid_msr_intercept(u32 index)
+static int direct_access_msr_idx(u32 msr)
 {
-	int i;
+	u32 i;
 
 	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
-		if (direct_access_msrs[i].index == index)
-			return true;
+		if (direct_access_msrs[i].index == msr)
+			return i;
 
-	return false;
+	return -EINVAL;
+}
+
+static void set_shadow_msr_intercept(struct vcpu_svm *svm, u32 msr, int read,
+				     int write)
+{
+	int idx = direct_access_msr_idx(msr);
+
+	if (idx == -EINVAL)
+		return;
+
+	/* Set the shadow bitmaps to the desired intercept states */
+	if (read)
+		set_bit(idx, svm->shadow_msr_intercept.read);
+	else
+		clear_bit(idx, svm->shadow_msr_intercept.read);
+
+	if (write)
+		set_bit(idx, svm->shadow_msr_intercept.write);
+	else
+		clear_bit(idx, svm->shadow_msr_intercept.write);
+}
+
+static bool valid_msr_intercept(u32 index)
+{
+	return direct_access_msr_idx(index) != -EINVAL;
 }
 
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
@@ -583,8 +608,8 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
-static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
-				 int write)
+static void set_msr_interception_nosync(struct kvm_vcpu *vcpu, u32 msr,
+					int read, int write)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 *msrpm = svm->msrpm;
@@ -598,6 +623,13 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
 	 */
 	WARN_ON(!valid_msr_intercept(msr));
 
+	/* Enforce non allowed MSRs to trap */
+	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_ALLOW_READ))
+		read = 0;
+
+	if (write && !kvm_msr_allowed(vcpu, msr, KVM_MSR_ALLOW_WRITE))
+		write = 0;
+
 	offset    = svm_msrpm_offset(msr);
 	bit_read  = 2 * (msr & 0x0f);
 	bit_write = 2 * (msr & 0x0f) + 1;
@@ -611,6 +643,15 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
 	msrpm[offset] = tmp;
 }
 
+static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
+				 int write)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	set_shadow_msr_intercept(svm, msr, read, write);
+	set_msr_interception_nosync(vcpu, msr, read, write);
+}
+
 static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 {
 	int i;
@@ -625,6 +666,25 @@ static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 	}
 }
 
+static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 i;
+
+	/*
+	 * Set intercept permissions for all direct access MSRs again. They
+	 * will automatically get filtered through the MSR filter, so we are
+	 * back in sync after this.
+	 */
+	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
+		u32 msr = direct_access_msrs[i].index;
+		u32 read = test_bit(i, svm->shadow_msr_intercept.read);
+		u32 write = test_bit(i, svm->shadow_msr_intercept.write);
+
+		set_msr_interception_nosync(vcpu, msr, read, write);
+	}
+}
+
 static void add_msr_offset(u32 offset)
 {
 	int i;
@@ -4088,6 +4148,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.msr_filter_changed = svm_msr_filter_changed,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..4c387470c27f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -31,6 +31,7 @@ static const u32 host_save_user_msrs[] = {
 
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
+#define MAX_DIRECT_ACCESS_MSRS	15
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -161,6 +162,12 @@ struct vcpu_svm {
 
 	/* which host CPU was used for running this vcpu */
 	unsigned int last_cpu;
+
+	/* Save desired MSR intercept (read: pass-through) state */
+	struct {
+		DECLARE_BITMAP(read, MAX_DIRECT_ACCESS_MSRS);
+		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
+	} shadow_msr_intercept;
 };
 
 struct svm_cpu_data {
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



