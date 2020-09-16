Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F5326CBAB
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgIPUbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:31:47 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:48597 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgIPUaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 16:30:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600288220; x=1631824220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P0IBE7TL/mWCI5D+guRqkFps7trYYwoY98JMxqfXMfQ=;
  b=FjjZharj8Y3ikAvL4oA9GNGTE4cakehamMWgWxCzIZuTbv8+upYMqOJn
   SQ+qhdC0JrfDHf7MSHzLkHraAakXL/La/ddF/e0JYLjSGMaP6Cf/7VtFR
   YJ8NmQqyGRWZA7vh9TxLWKlm8c0/zQYHgaJzfMgibDGz49J7lKV/mdkSi
   o=;
X-IronPort-AV: E=Sophos;i="5.76,434,1592870400"; 
   d="scan'208";a="54452067"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 16 Sep 2020 20:30:18 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 9E7A5A0755;
        Wed, 16 Sep 2020 20:30:16 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:30:16 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.35) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:30:12 +0000
From:   Alexander Graf <graf@amazon.com>
To:     kvm list <kvm@vger.kernel.org>
CC:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 4/7] KVM: x86: SVM: Prevent MSR passthrough when MSR access is denied
Date:   Wed, 16 Sep 2020 22:29:48 +0200
Message-ID: <20200916202951.23760-5-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200916202951.23760-1-graf@amazon.com>
References: <20200916202951.23760-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.35]
X-ClientProxiedBy: EX13D42UWA002.ant.amazon.com (10.43.160.16) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
 arch/x86/kvm/svm/svm.c | 77 +++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h |  7 ++++
 2 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 41aaee666751..fd2875932189 100644
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
@@ -553,15 +553,41 @@ static int svm_cpu_init(int cpu)
 
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
+static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
+				     int write)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
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
@@ -583,8 +609,8 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
-static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
-				 int read, int write)
+static void set_msr_interception_nosync(struct kvm_vcpu *vcpu, u32 *msrpm,
+					u32 msr, int read, int write)
 {
 	u8 bit_read, bit_write;
 	unsigned long tmp;
@@ -596,6 +622,13 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
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
@@ -609,6 +642,13 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 	msrpm[offset] = tmp;
 }
 
+static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
+				 int read, int write)
+{
+	set_shadow_msr_intercept(vcpu, msr, read, write);
+	set_msr_interception_nosync(vcpu, msrpm, msr, read, write);
+}
+
 static u32 *svm_vcpu_alloc_msrpm(void)
 {
 	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
@@ -639,6 +679,25 @@ static void svm_vcpu_free_msrpm(u32 *msrpm)
 	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
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
+		set_msr_interception_nosync(vcpu, svm->msrpm, msr, read, write);
+	}
+}
+
 static void add_msr_offset(u32 offset)
 {
 	int i;
@@ -4212,6 +4271,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.msr_filter_changed = svm_msr_filter_changed,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 45496775f0db..07bec0d5aad4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -31,6 +31,7 @@ static const u32 host_save_user_msrs[] = {
 
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
+#define MAX_DIRECT_ACCESS_MSRS	15
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -157,6 +158,12 @@ struct vcpu_svm {
 	 */
 	struct list_head ir_list;
 	spinlock_t ir_list_lock;
+
+	/* Save desired MSR intercept (read: pass-through) state */
+	struct {
+		DECLARE_BITMAP(read, MAX_DIRECT_ACCESS_MSRS);
+		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
+	} shadow_msr_intercept;
 };
 
 struct svm_cpu_data {
-- 
2.28.0.394.ge197136389




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



