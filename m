Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439473B942B
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 17:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhGAPnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 11:43:43 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51806 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbhGAPnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 11:43:41 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DE7C22290A;
        Thu,  1 Jul 2021 15:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EtpyeY2LWzLpUtmvOyclkqbU6bQLiiAIoIZDjZfdMyA=;
        b=BLyNKjT8T9o+8E3veyF+Ju4FmC9jvp/rK+mPprEg4pvXf1TTbamzNR/zf/twQOoemJSw3v
        shX6i2iyZuAGMjiUIpGWNJujh+nEMOICpvs2cfDS5LUVHHoQINPP/vmawyAEhDOIMAFxZn
        mpQjJcpbEgGYwO4wih8ceuoQJoUAOtU=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 78EE211CD5;
        Thu,  1 Jul 2021 15:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EtpyeY2LWzLpUtmvOyclkqbU6bQLiiAIoIZDjZfdMyA=;
        b=BLyNKjT8T9o+8E3veyF+Ju4FmC9jvp/rK+mPprEg4pvXf1TTbamzNR/zf/twQOoemJSw3v
        shX6i2iyZuAGMjiUIpGWNJujh+nEMOICpvs2cfDS5LUVHHoQINPP/vmawyAEhDOIMAFxZn
        mpQjJcpbEgGYwO4wih8ceuoQJoUAOtU=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id UA9wHBXi3WAOFwAALh3uQQ
        (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:09 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/6] x86/kvm: add boot parameter for maximum vcpu-id
Date:   Thu,  1 Jul 2021 17:41:02 +0200
Message-Id: <20210701154105.23215-4-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Today the maximum vcpu-id of a kvm guest's vcpu on x86 systems is set
via a #define in a header file.

In order to support higher vcpu-ids without generally increasing the
memory consumption of guests on the host (some guest structures contain
arrays sized by KVM_MAX_VCPU_ID) add a boot parameter for selecting the
maximum vcpu-id. Per default it will still be the current value of
1023, but it can be set manually to higher or lower values.

This requires to allocate the arrays using KVM_MAX_VCPU_ID as the size
dynamically.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
 arch/x86/include/asm/kvm_host.h                 |  5 ++++-
 arch/x86/kvm/ioapic.c                           | 12 +++++++++++-
 arch/x86/kvm/ioapic.h                           |  4 ++--
 arch/x86/kvm/x86.c                              |  3 +++
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cb89dbdedc46..99bfa53a2bbd 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2365,6 +2365,14 @@
 			feature (tagged TLBs) on capable Intel chips.
 			Default is 1 (enabled)
 
+	kvm.max_vcpu_id=
+			[KVM,X86] Set the maximum allowed vcpu-id of a guest.
+			Some memory structure sizes depend on this value, so it
+			shouldn't be set too high. Note that each vcpu of a
+			guests needs to have a unique vcpu-id, so a single
+			guest can't have more vcpus than the set value + 1.
+			Default: 1023
+
 	l1tf=           [X86] Control mitigation of the L1TF vulnerability on
 			      affected CPUs
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c7ced0e3171..88b1ff898fb9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -39,7 +39,8 @@
 
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
-#define KVM_MAX_VCPU_ID 1023
+#define KVM_DEFAULT_MAX_VCPU_ID 1023
+#define KVM_MAX_VCPU_ID max_vcpu_id
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
 
@@ -1511,6 +1512,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
 extern u64  kvm_default_tsc_scaling_ratio;
 /* bus lock detection supported? */
 extern bool kvm_has_bus_lock_exit;
+/* maximum vcpu-id */
+extern unsigned int max_vcpu_id;
 
 extern u64 kvm_mce_cap_supported;
 
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index ff005fe738a4..52e8ea90c914 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -685,11 +685,21 @@ static const struct kvm_io_device_ops ioapic_mmio_ops = {
 int kvm_ioapic_init(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic;
+	size_t sz;
 	int ret;
 
-	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL_ACCOUNT);
+	sz = sizeof(struct kvm_ioapic) +
+	     sizeof(*ioapic->rtc_status.dest_map.map) *
+		    BITS_TO_LONGS(KVM_MAX_VCPU_ID + 1) +
+	     sizeof(*ioapic->rtc_status.dest_map.vectors) *
+		    (KVM_MAX_VCPU_ID + 1);
+	ioapic = kzalloc(sz, GFP_KERNEL_ACCOUNT);
 	if (!ioapic)
 		return -ENOMEM;
+	ioapic->rtc_status.dest_map.map = (void *)(ioapic + 1);
+	ioapic->rtc_status.dest_map.vectors =
+		(void *)(ioapic->rtc_status.dest_map.map +
+			 BITS_TO_LONGS(KVM_MAX_VCPU_ID + 1));
 	spin_lock_init(&ioapic->lock);
 	INIT_DELAYED_WORK(&ioapic->eoi_inject, kvm_ioapic_eoi_inject_work);
 	kvm->arch.vioapic = ioapic;
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index bbd4a5d18b5d..623a3c5afad7 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -39,13 +39,13 @@ struct kvm_vcpu;
 
 struct dest_map {
 	/* vcpu bitmap where IRQ has been sent */
-	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
+	unsigned long *map;
 
 	/*
 	 * Vector sent to a given vcpu, only valid when
 	 * the vcpu's bit in map is set
 	 */
-	u8 vectors[KVM_MAX_VCPU_ID + 1];
+	u8 *vectors;
 };
 
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0f4a46649d7..0390d90fd360 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -177,6 +177,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+unsigned int __read_mostly max_vcpu_id = KVM_DEFAULT_MAX_VCPU_ID;
+module_param(max_vcpu_id, uint, S_IRUGO);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
-- 
2.26.2

