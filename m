Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855B65784F5
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 16:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbiGROMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 10:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbiGROMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 10:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 653C1275D6
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 07:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658153526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nBIZ5inYKW+z3A/0WRI0HsZbXbpbCq0J/0LeFUWRE6c=;
        b=LYKIHN+ChAdJYw75wiiDRCGB6GspYUUogSuovagyADh6sR8QehBDdI2PAbRcgCX1JchQaN
        DGWHLcWipCzWnnq/c+I2870QzMpp2QNwrqA97sbmu2L9PdnpFXZQZvFwtkUYso5IDZEwMt
        Gm4c0b0N401zsv/8wehLzGsddJSzHVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-pGEqucTQNjKNyVCGKumkbA-1; Mon, 18 Jul 2022 10:11:57 -0400
X-MC-Unique: pGEqucTQNjKNyVCGKumkbA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C6001019C8D;
        Mon, 18 Jul 2022 14:11:56 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07E2C2026D64;
        Mon, 18 Jul 2022 14:11:50 +0000 (UTC)
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
Subject: [PATCH v2 5/5] x86/cpuid: check for dependencies violations in CPUID and attempt to fix them
Date:   Mon, 18 Jul 2022 17:11:23 +0300
Message-Id: <20220718141123.136106-6-mlevitsk@redhat.com>
In-Reply-To: <20220718141123.136106-1-mlevitsk@redhat.com>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Due to configuration bugs, sometimes a CPU feature is disabled in CPUID,
but not features that depend on it.

For example, when one attempts to disable AVX2 but not AVX in the
guest's CPUID, the guest kernel crashes in aes-ni driver, when it
is used.

While the aes-ni driver can also be fixed to be more eager to detect this kind
of situation, it is simpler to fix this in a generic way since the kernel
has all the required info in the form of a dependency table.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kernel/cpu/cpuid-deps.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index e1b5f5c02c0106..376296c1f55ab2 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -94,6 +94,11 @@ static inline void clear_feature(struct cpuinfo_x86 *c, unsigned int feature)
 		set_bit(feature, (unsigned long *)cpu_caps_cleared);
 }
 
+static inline bool test_feature(struct cpuinfo_x86 *c, unsigned int feature)
+{
+	return test_bit(feature, (unsigned long *)c->x86_capability);
+}
+
 /* Take the capabilities and the BUG bits into account */
 #define MAX_FEATURE_BITS ((NCAPINTS + NBUGINTS) * sizeof(u32) * 8)
 
@@ -136,6 +141,10 @@ void setup_clear_cpu_cap(unsigned int feature)
  * Some CPU features depend on higher CPUID levels, which may not always
  * be available due to CPUID level capping or broken virtualization
  * software.  Add those features to this table to auto-disable them.
+ *
+ * Also due to configuration bugs, some CPUID features might be present
+ * while CPUID features that they depend on are not present,
+ * e.g a AVX2 present but AVX is not present.
  */
 struct cpuid_dependent_feature {
 	u32 feature;
@@ -153,6 +162,7 @@ cpuid_dependent_features[] = {
 void filter_cpuid_features(struct cpuinfo_x86 *c)
 {
 	const struct cpuid_dependent_feature *df;
+	const struct cpuid_dep *d;
 
 	for (df = cpuid_dependent_features; df->feature; df++) {
 
@@ -175,4 +185,16 @@ void filter_cpuid_features(struct cpuinfo_x86 *c)
 		pr_warn("CPU: CPU feature " X86_CAP_FMT " disabled, no CPUID level 0x%x\n",
 			x86_cap_flag(df->feature), df->level);
 	}
+
+	for (d = cpuid_deps; d->feature; d++) {
+
+		if (!test_feature(c, d->feature) || test_feature(c, d->depends))
+			continue;
+
+		clear_cpu_cap(c, d->feature);
+
+		pr_warn("CPU: CPU feature " X86_CAP_FMT " disabled, because it depends on "
+			X86_CAP_FMT " which is not supported in CPUID\n",
+			x86_cap_flag(d->feature), x86_cap_flag(d->depends));
+	}
 }
-- 
2.34.3

