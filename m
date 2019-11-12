Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E62F9C05
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKLVWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:22:19 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40246 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfKLVVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:21:44 -0500
Received: by mail-wm1-f65.google.com with SMTP id f3so4508810wmc.5;
        Tue, 12 Nov 2019 13:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:in-reply-to:references;
        bh=JnYn9uI3yxG6VZUb0pRxgCquzXyinIAZQISEMZhmypI=;
        b=c6heNSUxxH0oSCrrZxfbuO1+iBKrdMQPa1BgSH2jEDX7jL30fU/j2fySQZZC0bUpUG
         yurhMl/qRZbzE41t/pGuNSf1a/5mDIJ3F3eSS1CE5Ot5O/ytZcweG+wArghZ6CdhKVnu
         IAMfek98DzNDTKQOon6AYCm4CvPqf8dTaKtMibKJowETWqmxxHDVbvNVayirLLnkgTmV
         jOBJNttUDt5PH0Sn20pgeWsKF/NlTB8df7FpAK6C2p7N0cYO9RnePFrdEEzvNUwXfs7g
         DR7XSmN45gZs1HTCfVWrq1guTQXt3+ygY8rJOYZoLdPw+gbm0kjoZMEsLNFb7UkiS/T7
         Adxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references;
        bh=JnYn9uI3yxG6VZUb0pRxgCquzXyinIAZQISEMZhmypI=;
        b=UnMukUBbIKwf926K9c7X1prKzXb4GZ60LnwhoL0FnoQIuHmr9c5OEaUguBaLRQf6ex
         S8e4KOs+w5q+DYGtuuh8q3eaDZM4skFRCOu2JYWFZ7h091QKstOPUqooge1n/4Eq/YZR
         FmI+o8PILEbMyN1oc3bTw5fzzyQzLuPNzn6HfRt93+lbtACDQnF85yZ6C8Nhft4E2YKb
         355Y6g53sGgxvBE/HXwzKUXz1tTTw3xh7PEsP1oYQR5N5AgFveJtfR04E7xVGYS/YTqM
         MlD9w83i1kbQ8St28BY+9r6C3FVOUcPnxDHgxAlHxmB+GM/k6VUHSYEMLECCOrpvuEpo
         cn9g==
X-Gm-Message-State: APjAAAU8k36VLFrNwfQHXM+iBpSEVvuoEhgmIXTA7K63InfWiPxElxMk
        qMlpbl84E9AuFk3KVbnV7Xt7XXkw
X-Google-Smtp-Source: APXvYqyflfP/bbvqcVZbOtkbkEMjU2ik2y3Bch5Qkw8SHzU2Rj4s0FcAH8rXTDMj2FRJY5Y+jNf82A==
X-Received: by 2002:a05:600c:299:: with SMTP id 25mr6265599wmk.50.1573593699937;
        Tue, 12 Nov 2019 13:21:39 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q25sm198664wra.3.2019.11.12.13.21.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:21:39 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/7] x86/bugs: Add ITLB_MULTIHIT bug infrastructure
Date:   Tue, 12 Nov 2019 22:21:31 +0100
Message-Id: <1573593697-25061-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vineela Tummalapalli <vineela.tummalapalli@intel.com>

Some processors may incur a machine check error possibly resulting in an
unrecoverable CPU lockup when an instruction fetch encounters a TLB
multi-hit in the instruction TLB. This can occur when the page size is
changed along with either the physical address or cache type. The relevant
erratum can be found here:

   https://bugzilla.kernel.org/show_bug.cgi?id=205195

There are other processors affected for which the erratum does not fully
disclose the impact.

This issue affects both bare-metal x86 page tables and EPT.

It can be mitigated by either eliminating the use of large pages or by
using careful TLB invalidations when changing the page size in the page
tables.

Just like Spectre, Meltdown, L1TF and MDS, a new bit has been allocated in
MSR_IA32_ARCH_CAPABILITIES (PSCHANGE_MC_NO) and will be set on CPUs which
are mitigated against this issue.

Signed-off-by: Vineela Tummalapalli <vineela.tummalapalli@intel.com>
Co-developed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |  1 +
 arch/x86/include/asm/cpufeatures.h                 |  1 +
 arch/x86/include/asm/msr-index.h                   |  7 +++
 arch/x86/kernel/cpu/bugs.c                         | 13 +++++
 arch/x86/kernel/cpu/common.c                       | 65 ++++++++++++----------
 drivers/base/cpu.c                                 |  8 +++
 include/linux/cpu.h                                |  2 +
 7 files changed, 67 insertions(+), 30 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 0e77569bd5e0..fc20cde63d1e 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -487,6 +487,7 @@ What:		/sys/devices/system/cpu/vulnerabilities
 		/sys/devices/system/cpu/vulnerabilities/l1tf
 		/sys/devices/system/cpu/vulnerabilities/mds
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
+		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 989e03544f18..c4fbe379cc0b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -400,5 +400,6 @@
 #define X86_BUG_MSBDS_ONLY		X86_BUG(20) /* CPU is only affected by the  MSDBS variant of BUG_MDS */
 #define X86_BUG_SWAPGS			X86_BUG(21) /* CPU is affected by speculation through SWAPGS */
 #define X86_BUG_TAA			X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
+#define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b3a8bb2af0b6..6a3124664289 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -93,6 +93,13 @@
 						  * Microarchitectural Data
 						  * Sampling (MDS) vulnerabilities.
 						  */
+#define ARCH_CAP_PSCHANGE_MC_NO		BIT(6)	 /*
+						  * The processor is not susceptible to a
+						  * machine check error due to modifying the
+						  * code page size along with either the
+						  * physical address or cache type
+						  * without TLB invalidation.
+						  */
 #define ARCH_CAP_TSX_CTRL_MSR		BIT(7)	/* MSR for TSX control is available. */
 #define ARCH_CAP_TAA_NO			BIT(8)	/*
 						 * Not susceptible to
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 43c647e19439..5364beda8c61 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1419,6 +1419,11 @@ static ssize_t l1tf_show_state(char *buf)
 }
 #endif
 
+static ssize_t itlb_multihit_show_state(char *buf)
+{
+	return sprintf(buf, "Processor vulnerable\n");
+}
+
 static ssize_t mds_show_state(char *buf)
 {
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
@@ -1524,6 +1529,9 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 	case X86_BUG_TAA:
 		return tsx_async_abort_show_state(buf);
 
+	case X86_BUG_ITLB_MULTIHIT:
+		return itlb_multihit_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1565,4 +1573,9 @@ ssize_t cpu_show_tsx_async_abort(struct device *dev, struct device_attribute *at
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_TAA);
 }
+
+ssize_t cpu_show_itlb_multihit(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_ITLB_MULTIHIT);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f8b8afc8f5b5..d29b71ca3ca7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1016,13 +1016,14 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #endif
 }
 
-#define NO_SPECULATION	BIT(0)
-#define NO_MELTDOWN	BIT(1)
-#define NO_SSB		BIT(2)
-#define NO_L1TF		BIT(3)
-#define NO_MDS		BIT(4)
-#define MSBDS_ONLY	BIT(5)
-#define NO_SWAPGS	BIT(6)
+#define NO_SPECULATION		BIT(0)
+#define NO_MELTDOWN		BIT(1)
+#define NO_SSB			BIT(2)
+#define NO_L1TF			BIT(3)
+#define NO_MDS			BIT(4)
+#define MSBDS_ONLY		BIT(5)
+#define NO_SWAPGS		BIT(6)
+#define NO_ITLB_MULTIHIT	BIT(7)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -1043,27 +1044,27 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
 
 	/* Intel Family 6 */
-	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION),
-	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
-
-	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_SILVERMONT_D,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+
+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SILVERMONT_D,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
 	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
 
-	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_AIRMONT_NP,		NO_L1TF | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_AIRMONT_NP,		NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1074,14 +1075,14 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 	 */
 
 	/* AMD Family 0xf - 0x12 */
-	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	{}
 };
 
@@ -1106,6 +1107,10 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 {
 	u64 ia32_cap = x86_read_arch_cap_msr();
 
+	/* Set ITLB_MULTIHIT bug if cpu is not in the whitelist and not mitigated */
+	if (!cpu_matches(NO_ITLB_MULTIHIT) && !(ia32_cap & ARCH_CAP_PSCHANGE_MC_NO))
+		setup_force_cpu_bug(X86_BUG_ITLB_MULTIHIT);
+
 	if (cpu_matches(NO_SPECULATION))
 		return;
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 0fccd8c0312e..6265871a4af2 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -561,6 +561,12 @@ ssize_t __weak cpu_show_tsx_async_abort(struct device *dev,
 	return sprintf(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_itlb_multihit(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -568,6 +574,7 @@ ssize_t __weak cpu_show_tsx_async_abort(struct device *dev,
 static DEVICE_ATTR(l1tf, 0444, cpu_show_l1tf, NULL);
 static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
 static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
+static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -577,6 +584,7 @@ ssize_t __weak cpu_show_tsx_async_abort(struct device *dev,
 	&dev_attr_l1tf.attr,
 	&dev_attr_mds.attr,
 	&dev_attr_tsx_async_abort.attr,
+	&dev_attr_itlb_multihit.attr,
 	NULL
 };
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index f35369f79771..2a093434e975 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -62,6 +62,8 @@ extern ssize_t cpu_show_mds(struct device *dev,
 extern ssize_t cpu_show_tsx_async_abort(struct device *dev,
 					struct device_attribute *attr,
 					char *buf);
+extern ssize_t cpu_show_itlb_multihit(struct device *dev,
+				      struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,
-- 
1.8.3.1


