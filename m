Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6455784EB
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiGROLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 10:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiGROLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 10:11:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC0212714C
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 07:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658153511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WQ28KCG8qrZVHeMH3WgWsVAsqXW66sq9MXnU4h146Bs=;
        b=Xns/S1jhMb8wUJsqIJcMSksx1tsSYXEkRxXoYI4at1SiGSyKGgHnt6I5ZTgXChhGTYmupG
        nBL42QZWW9Sbzt//ufDlwnDfKnXwOOiQV3IYOdXTnV+DfXR7a1zKewk4xeVofj2IQlX/ZU
        ijjZfC6JWbC0U+HsnM8GfIvwEimj/OY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-Mw1UrJkLOfKZHkMeNfQTmg-1; Mon, 18 Jul 2022 10:11:46 -0400
X-MC-Unique: Mw1UrJkLOfKZHkMeNfQTmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EC0529ABA0B;
        Mon, 18 Jul 2022 14:11:45 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DE182026D64;
        Mon, 18 Jul 2022 14:11:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        linux-crypto@vger.kernel.org (open list:CRYPTO API)
Subject: [PATCH v2 3/5] x86/cpuid: move filter_cpuid_features to cpuid-deps.c
Date:   Mon, 18 Jul 2022 17:11:21 +0300
Message-Id: <20220718141123.136106-4-mlevitsk@redhat.com>
In-Reply-To: <20220718141123.136106-1-mlevitsk@redhat.com>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

filter_cpuid_features performs a sanity check on CPU/hypervisor
provided CPUID in regard to having all required leaves which
some CPUID feature bits require.

Soon this sanity check will be extended to also disable CPUID
features which were erronsly enabled in CPUID and depend on
features that are marked as disabled in the CPUID.

It thus makes sense to have both checks in one file.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/kernel/cpu/common.c      | 47 -------------------------------
 arch/x86/kernel/cpu/cpuid-deps.c  | 47 +++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index ea34cc31b0474f..3eb5fe0d654e63 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -147,6 +147,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 
 extern void setup_clear_cpu_cap(unsigned int bit);
 extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
+extern void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn);
 
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 736262a76a12b7..beaea42c1b47e1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -620,53 +620,6 @@ __noendbr void cet_disable(void)
 		wrmsrl(MSR_IA32_S_CET, 0);
 }
 
-/*
- * Some CPU features depend on higher CPUID levels, which may not always
- * be available due to CPUID level capping or broken virtualization
- * software.  Add those features to this table to auto-disable them.
- */
-struct cpuid_dependent_feature {
-	u32 feature;
-	u32 level;
-};
-
-static const struct cpuid_dependent_feature
-cpuid_dependent_features[] = {
-	{ X86_FEATURE_MWAIT,		0x00000005 },
-	{ X86_FEATURE_DCA,		0x00000009 },
-	{ X86_FEATURE_XSAVE,		0x0000000d },
-	{ 0, 0 }
-};
-
-static void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
-{
-	const struct cpuid_dependent_feature *df;
-
-	for (df = cpuid_dependent_features; df->feature; df++) {
-
-		if (!cpu_has(c, df->feature))
-			continue;
-		/*
-		 * Note: cpuid_level is set to -1 if unavailable, but
-		 * extended_extended_level is set to 0 if unavailable
-		 * and the legitimate extended levels are all negative
-		 * when signed; hence the weird messing around with
-		 * signs here...
-		 */
-		if (!((s32)df->level < 0 ?
-		     (u32)df->level > (u32)c->extended_cpuid_level :
-		     (s32)df->level > (s32)c->cpuid_level))
-			continue;
-
-		clear_cpu_cap(c, df->feature);
-		if (!warn)
-			continue;
-
-		pr_warn("CPU: CPU feature " X86_CAP_FMT " disabled, no CPUID level 0x%x\n",
-			x86_cap_flag(df->feature), df->level);
-	}
-}
-
 /*
  * Naming convention should be: <Name> [(<Codename>)]
  * This table only is used unless init_<vendor>() below doesn't set it;
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index d6777d07ba3302..306f285844aedc 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -131,3 +131,50 @@ void setup_clear_cpu_cap(unsigned int feature)
 {
 	clear_cpu_cap(&boot_cpu_data, feature);
 }
+
+/*
+ * Some CPU features depend on higher CPUID levels, which may not always
+ * be available due to CPUID level capping or broken virtualization
+ * software.  Add those features to this table to auto-disable them.
+ */
+struct cpuid_dependent_feature {
+	u32 feature;
+	u32 level;
+};
+
+static const struct cpuid_dependent_feature
+cpuid_dependent_features[] = {
+	{ X86_FEATURE_MWAIT,		0x00000005 },
+	{ X86_FEATURE_DCA,		0x00000009 },
+	{ X86_FEATURE_XSAVE,		0x0000000d },
+	{ 0, 0 }
+};
+
+void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
+{
+	const struct cpuid_dependent_feature *df;
+
+	for (df = cpuid_dependent_features; df->feature; df++) {
+
+		if (!cpu_has(c, df->feature))
+			continue;
+		/*
+		 * Note: cpuid_level is set to -1 if unavailable, but
+		 * extended_extended_level is set to 0 if unavailable
+		 * and the legitimate extended levels are all negative
+		 * when signed; hence the weird messing around with
+		 * signs here...
+		 */
+		if (!((s32)df->level < 0 ?
+		     (u32)df->level > (u32)c->extended_cpuid_level :
+		     (s32)df->level > (s32)c->cpuid_level))
+			continue;
+
+		clear_cpu_cap(c, df->feature);
+		if (!warn)
+			continue;
+
+		pr_warn("CPU: CPU feature " X86_CAP_FMT " disabled, no CPUID level 0x%x\n",
+			x86_cap_flag(df->feature), df->level);
+	}
+}
-- 
2.34.3

