Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB5862D669
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239843AbiKQJUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbiKQJUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:20:43 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B989697FA
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:42 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-348608c1cd3so13958347b3.10
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L4/FyrIOiD4M1W0FW3paNIGrsKBsuVP1axi0oXmujHw=;
        b=K+tqrE/JBPXutuGvbv64i1oN/E7jIcPqzoxTqTOoMKyj2TygGQBInUK5b77m/B5CUU
         XIDNkT0JSW8FbmWBGXt7x3kSjbgB/0IbJV1tH3wQeCWJCiuYGujL2SNdQthkHw9BgT+a
         mGdbBLfVsUxKqPiYs7vEBVLe+LrPIe+ZLj5YupguFbC0hq12HVIawk/0SxVnDf2s4qhw
         VtHXWrssKCkQo93ndb/s1nHim3lfGINJviBVm41hCjKp/4klqJ9elHhCChE/Y1/EZC12
         RePrk/wZaypS5Aa+YmXYeYCf0RITYWh6hvjLxaUHKGaNk5JZ9xEiyTD/FrAhrCY2h1UF
         wodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L4/FyrIOiD4M1W0FW3paNIGrsKBsuVP1axi0oXmujHw=;
        b=iC5yvc6SP64kJZuK5AYyEcqBfHVa7pAjIEoWxf/japETN+G7a8Vkyh0UE29Va253jB
         QpNmp9/FAVtH0+8dxvLw9uCinK5RaAXYdwIESkiAsTJog2KiISZIBibfMDBw1L8leLya
         LJU7GecpNHGLYn2KLkLjY1HW1sB/LoPBGHi9F70QpujAMPxcJJ1UtEdtforoRksGxg27
         bVehNf+EbKzSteRAXVd+fgti0ql0KqL3mOk8HzJ6Rb+GU795w0aCFHgalGgG8eIjo3HJ
         9jeVDQllE5QP1Maqj0+YdrCXmWF5ObdQt1dFoJ/FuNXrh9azxsfIasddv3rdqBSsu7EV
         5KXg==
X-Gm-Message-State: ACrzQf3KIIu1p9hWefiIsYFl6hlg+soSu6DhkR46hZmM3YddcgO3gDqp
        FDR7Tc/wZxg4MjyJ++hv1C0anoqjuPp/KA==
X-Google-Smtp-Source: AMsMyM6zcPzi+3ZL8UyuW+7rs6E33OqEAkk8Bq+LMiL9lJ34Bmc4yMCqaJVB4lzRTFaAMINTCF3k6QCGBSMNpw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a25:9c01:0:b0:6af:4a89:26b3 with SMTP id
 c1-20020a259c01000000b006af4a8926b3mr69666731ybo.190.1668676841036; Thu, 17
 Nov 2022 01:20:41 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:27 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-10-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 09/34] x86/bugs: Report AMD retbleed vulnerability
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandre Chartre <alexandre.chartre@oracle.com>

commit 6b80b59b3555706508008f1f127b5412c89c7fd8 upstream.

Report that AMD x86 CPUs are vulnerable to the RETBleed (Arbitrary
Speculative Code Execution with Return Instructions) attack.

  [peterz: add hygon]
  [kim: invert parity; fam15h]

Co-developed-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: adjusted BUG numbers to match upstream]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[suleiman: Remove hygon]
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/bugs.c         | 13 +++++++++++++
 arch/x86/kernel/cpu/common.c       | 15 +++++++++++++++
 drivers/base/cpu.c                 |  8 ++++++++
 include/linux/cpu.h                |  2 ++
 5 files changed, 39 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 84b75711b0a5..0c6734329ed5 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -404,5 +404,6 @@
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
+#define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index fc65fe5b28c2..54b15d3a0d55 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1899,6 +1899,11 @@ static ssize_t srbds_show_state(char *buf)
 	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
 }
 
+static ssize_t retbleed_show_state(char *buf)
+{
+	return sprintf(buf, "Vulnerable\n");
+}
+
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
 			       char *buf, unsigned int bug)
 {
@@ -1945,6 +1950,9 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 	case X86_BUG_MMIO_UNKNOWN:
 		return mmio_stale_data_show_state(buf);
 
+	case X86_BUG_RETBLEED:
+		return retbleed_show_state(buf);
+
 	default:
 		break;
 	}
@@ -2004,4 +2012,9 @@ ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *at
 	else
 		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
+
+ssize_t cpu_show_retbleed(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_RETBLEED);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f4ce78c20eab..bc9c0739c9c3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1019,16 +1019,24 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	{}
 };
 
+#define VULNBL(vendor, family, model, blacklist)	\
+	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, blacklist)
+
 #define VULNBL_INTEL_STEPPINGS(model, steppings, issues)		   \
 	X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(INTEL, 6,		   \
 					    INTEL_FAM6_##model, steppings, \
 					    X86_FEATURE_ANY, issues)
 
+#define VULNBL_AMD(family, blacklist)		\
+	VULNBL(AMD, family, X86_MODEL_ANY, blacklist)
+
 #define SRBDS		BIT(0)
 /* CPU is affected by X86_BUG_MMIO_STALE_DATA */
 #define MMIO		BIT(1)
 /* CPU is affected by Shared Buffers Data Sampling (SBDS), a variant of X86_BUG_MMIO_STALE_DATA */
 #define MMIO_SBDS	BIT(2)
+/* CPU is affected by RETbleed, speculating where you would not expect it */
+#define RETBLEED	BIT(3)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
@@ -1061,6 +1069,10 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
+
+	VULNBL_AMD(0x15, RETBLEED),
+	VULNBL_AMD(0x16, RETBLEED),
+	VULNBL_AMD(0x17, RETBLEED),
 	{}
 };
 
@@ -1166,6 +1178,9 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
+	if (cpu_matches(cpu_vuln_blacklist, RETBLEED))
+		setup_force_cpu_bug(X86_BUG_RETBLEED);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index cd204be1f4b7..ce5b3ffbd6ee 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -577,6 +577,12 @@ ssize_t __weak cpu_show_mmio_stale_data(struct device *dev,
 	return sysfs_emit(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_retbleed(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -587,6 +593,7 @@ static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
 static DEVICE_ATTR(mmio_stale_data, 0444, cpu_show_mmio_stale_data, NULL);
+static DEVICE_ATTR(retbleed, 0444, cpu_show_retbleed, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -599,6 +606,7 @@ static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_itlb_multihit.attr,
 	&dev_attr_srbds.attr,
 	&dev_attr_mmio_stale_data.attr,
+	&dev_attr_retbleed.attr,
 	NULL
 };
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 8cc06e1d4fc2..12ed4cb751de 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -68,6 +68,8 @@ extern ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr,
 extern ssize_t cpu_show_mmio_stale_data(struct device *dev,
 					struct device_attribute *attr,
 					char *buf);
+extern ssize_t cpu_show_retbleed(struct device *dev,
+				 struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,
-- 
2.38.1.431.g37b22c650d-goog

