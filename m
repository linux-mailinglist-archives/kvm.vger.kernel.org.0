Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AD75784F2
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 16:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiGROMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 10:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbiGROL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 10:11:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E93982715A
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 07:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658153515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T8Z2XJYyS9V8KZ6uFYvGdAv2HuDcr4S84Jovz3Opi0M=;
        b=Ykl+ICp5BuKD6lWyrr2SgMGaWAn4rzhPMDgmX2xyCCoQGirB8XXCRCoZB+A2Mh3TIm/PxX
        QIZUzLbSDA6WbGZ8OiFOl2hb0vEEarm4fBrwEGjOZ4zMJKCAH54Kw1VTPnOGI/8b9P7+Jc
        OqYpJi4kZcaM2T/b7VkL5mcqQsBRWKQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-Rqy0FaU5MVW-WcZIbWk9Kw-1; Mon, 18 Jul 2022 10:11:52 -0400
X-MC-Unique: Rqy0FaU5MVW-WcZIbWk9Kw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A17003C02B86;
        Mon, 18 Jul 2022 14:11:50 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A528D2026D64;
        Mon, 18 Jul 2022 14:11:45 +0000 (UTC)
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
Subject: [PATCH v2 4/5] x86/cpuid: remove 'warn' parameter from filter_cpuid_features
Date:   Mon, 18 Jul 2022 17:11:22 +0300
Message-Id: <20220718141123.136106-5-mlevitsk@redhat.com>
In-Reply-To: <20220718141123.136106-1-mlevitsk@redhat.com>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This parameter suppresses the warning if issue is found when
this function called from early boot cpu identification code, which doesn't
seem to be useful, except that it actually completely hides the warning,
because next time this code is called for each CPU and when the warning
is printed, the issue is already fixed, and so no warning is printed at all.

Tested by using a broken CPUID with missing leaf and observing no warning printed,
and with the patch a warning is printed once.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/cpufeature.h | 2 +-
 arch/x86/kernel/cpu/common.c      | 4 ++--
 arch/x86/kernel/cpu/cpuid-deps.c  | 4 +---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 3eb5fe0d654e63..86d7fbb3f2b592 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -147,7 +147,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 
 extern void setup_clear_cpu_cap(unsigned int bit);
 extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
-extern void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn);
+extern void filter_cpuid_features(struct cpuinfo_x86 *c);
 
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index beaea42c1b47e1..1a2f4e83e2f312 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1485,7 +1485,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 			this_cpu->c_early_init(c);
 
 		c->cpu_index = 0;
-		filter_cpuid_features(c, false);
+		filter_cpuid_features(c);
 
 		if (this_cpu->c_bsp_init)
 			this_cpu->c_bsp_init(c);
@@ -1773,7 +1773,7 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	 */
 
 	/* Filter out anything that depends on CPUID levels we don't have */
-	filter_cpuid_features(c, true);
+	filter_cpuid_features(c);
 
 	/* If the model name is still unset, do table lookup. */
 	if (!c->x86_model_id[0]) {
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 306f285844aedc..e1b5f5c02c0106 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -150,7 +150,7 @@ cpuid_dependent_features[] = {
 	{ 0, 0 }
 };
 
-void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
+void filter_cpuid_features(struct cpuinfo_x86 *c)
 {
 	const struct cpuid_dependent_feature *df;
 
@@ -171,8 +171,6 @@ void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 			continue;
 
 		clear_cpu_cap(c, df->feature);
-		if (!warn)
-			continue;
 
 		pr_warn("CPU: CPU feature " X86_CAP_FMT " disabled, no CPUID level 0x%x\n",
 			x86_cap_flag(df->feature), df->level);
-- 
2.34.3

