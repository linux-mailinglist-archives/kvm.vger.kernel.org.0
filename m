Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1AC69E4D8
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 17:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbjBUQiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 11:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjBUQht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 11:37:49 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87012D172
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:37:33 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f11-20020a6547cb000000b00502d7714305so1002697pgs.13
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iiRrB1La2XaBQ8X9jljAYPafLfxRlgHLwbfoJQq6vJc=;
        b=fAH3hCUl7uqbwUtd34iFW4FxURELK93IK/02Vx0KEZ+6k0X581BSlqbabdxNOqoBgo
         meEl6t2ZiDTIdhAK579ZxSCzIGixUue+EXZ/tFu3HlVbvdHU3QCq9IeS3SSra0MJxJ7i
         nbq8TQ51m3339oT33ydPu9XaJMCzD1QjV689OxEdbjY4FRc7QacllNDSkJuhhi5eFXoL
         TcOKXj4ubRAQ5sUHN9Y8qlxN5G8h5tss7+dpwoJDOirM9qLKmpDmS1YaqKN3XDYNUPCz
         zOiltEGWXv2rsSRM7wh4fzWdgxRKe5qA04L0Htv1bI7O/TZF70MfnASoGoq6SDuVhfq9
         FSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iiRrB1La2XaBQ8X9jljAYPafLfxRlgHLwbfoJQq6vJc=;
        b=mrzklCaNfC8yxwIWsnDiXp3Lop+PccXfO+vtV8V0yUNF6VMZXrUe2lA1WATZEzzLji
         sgqlJ61r/DJ/mUi0mL3iopdnWLJPPihG0oU4jCxBVW7xL9HVF6BR2SMxUIsb4B2S17Ye
         Zv+t/7M0IwxK8TEqAeRiyoFKUSBSGXIg5/8fH5jtTSJA+ghiSDkY3i1U1e0Vjy9ZQR9J
         xYOVhgNUljijG9fQygn+4znRFtx7/mfJnmzKemmKmP10Yd7bhJZLZ2XfuNkTSa2ReH3s
         6ljlOl9DNtuwDhPw2LrZ3h7HPxU/9rg814OF5N8eNkdqyWdTI7FsXCYWSVKuw7f5a9nE
         2Uzg==
X-Gm-Message-State: AO0yUKU2iQZXixuNcQjwDMhGynjOrAjhg02b8Fwt0KJgY/TiVu2lSI1q
        jYl9yu9xyxxbuPvXdVSMDNur0sDl7GRh
X-Google-Smtp-Source: AK7set+yc+UPbgHRSjGfHtztbpCerRitgUNtWXsAYPaaIY95QIVoKUQZahzKckS3seET9A2paVtccvS0Jy9Q
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a63:7a56:0:b0:4fb:b88f:e98a with SMTP id
 j22-20020a637a56000000b004fbb88fe98amr733518pgn.7.1676997453182; Tue, 21 Feb
 2023 08:37:33 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 21 Feb 2023 16:36:51 +0000
In-Reply-To: <20230221163655.920289-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230221163655.920289-1-mizhang@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230221163655.920289-10-mizhang@google.com>
Subject: [PATCH v3 09/13] KVM: selftests: x86: Assert that XTILE is XSAVE-enabled
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Chao Gao <chao.gao@intel.com>
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

From: Aaron Lewis <aaronlewis@google.com>

Assert that XTILE is XSAVE-enabled. check_xsave_supports_xtile() doesn't
actually check anything since its return value is not used. Add the
intended assert.

Opportunistically, move the assert to a more appropriate location:
immediately after XSETBV and remove check_xsave_supports_xtile().

Fixes: 5dc19f1c7dd3 ("KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 724e991ba814..d1fbf8936192 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -115,11 +115,6 @@ static inline void check_cpuid_xsave(void)
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
 }
 
-static bool check_xsave_supports_xtile(void)
-{
-	return __xgetbv(0) & XFEATURE_MASK_XTILE;
-}
-
 static void check_xtile_info(void)
 {
 	GUEST_ASSERT(this_cpu_has_p(X86_PROPERTY_XSTATE_MAX_SIZE_XCR0));
@@ -166,6 +161,7 @@ static void init_regs(void)
 	xcr0 = __xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
 	__xsetbv(0x0, xcr0);
+	GUEST_ASSERT(__xgetbv(0) & XFEATURE_MASK_XTILE);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
@@ -174,7 +170,6 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 {
 	init_regs();
 	check_cpuid_xsave();
-	check_xsave_supports_xtile();
 	check_xtile_info();
 	GUEST_SYNC(1);
 
-- 
2.39.2.637.g21b0678d19-goog

