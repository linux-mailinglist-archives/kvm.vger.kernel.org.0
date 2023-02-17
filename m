Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0F969B528
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjBQWAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBQWAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:00:16 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E464D5B2E7
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:15 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 11-20020a63030b000000b004fb3343142dso944765pgd.5
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k00jmPPGYoi9g64coPtuhUtlvtYczcvpQTMQxklUXCQ=;
        b=ac+v7qEX9B/6UJ8OfDDwMOOOr21TQ4e0Gq2Zvv0XMhfqk7HFbYk/spUlOfAKaIpLrp
         Pvp0a25a0FnkLESTDgIN+lCrXGLOlWhr+HsVdVi8/1MylWbWRIz9cdjV0feNxMOoMIiu
         iVdwqoJpNq4NHoAG2uKv8hBtwDdiJkLAjtYZUM0LPrvQZDHWjDvbPpyhoSEhEp/ynf6/
         CKvHpNrbDJ392LeMoRpX5Wj4s2aP9YxfdKVMNZidprTIXjqC2tNJaCsT28zTxy8BGe0x
         pNtYq7lc4yo3n3S2tP/fC8faBecJRaYwrs+kzULw+us3plERqaJaRSCGIQLw5Q56BXgJ
         Mm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k00jmPPGYoi9g64coPtuhUtlvtYczcvpQTMQxklUXCQ=;
        b=0kPO4t+EAcZQZU8t970rMY0LAoqIA93vJ7Du8kuuBoxpynnxGIaZSj4Jl90T9djeNa
         2DOJvXl1gnHiVVjjXevff3IFHbIBlX1MZaXaXi6/QJ4EcWYPNnUODrEhB0qj4tEAsaQq
         NtkugYD61zieZwA9tYSULLb7t+Xsh5wrKYtucGpCgBFTrzpAq+FF9X4GggtlFwOqJiZ3
         8xmuW7Y2Ptswljq2QyGvb5DE539tkGrk5PwDJl1VF5pFt5KgUDjqogWA8VvsfvepayZE
         hvk8e9Aqgp5kq8dwMwkeCZ4LYGW7jj7cJ0CTKMER4mydiC8zbXTaeJgE7MtKRwVPFU8U
         568Q==
X-Gm-Message-State: AO0yUKVcrH9ESFFMu6aqQkzl3Ik74Isz2g69uRZRk5ohGbx4BUvLpUCn
        izAfgG+QIs/lec3vUBpXdshCOrIzX8uZM3La6TNuig43eYEsg2t/+Yc2esSShuSa98CBpPh3lD6
        5xiM70gbGWlDuy0QjvIOVObPEpoMQXIbJrOwebZKyg5qGhVsGVjcM8wmlbSu+gXOvOv3a
X-Google-Smtp-Source: AK7set9+1Tp5Ui5p93h4tcgTKX8MIOjiOKP16aFibOJrtVPk4qWXNuUg2WSPm6qNhjwA+C7P2OocUpBrclTUeAGZ
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:48f:b0:199:4bc:1fed with SMTP
 id jj15-20020a170903048f00b0019904bc1fedmr346262plb.9.1676671215332; Fri, 17
 Feb 2023 14:00:15 -0800 (PST)
Date:   Fri, 17 Feb 2023 21:59:57 +0000
In-Reply-To: <20230217215959.1569092-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230217215959.1569092-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217215959.1569092-4-aaronlewis@google.com>
Subject: [PATCH 3/5] KVM: selftests: Remove redundant check that XSAVE is supported
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

In amx_test, userspace requires that XSAVE is supported before running
the test, then the guest checks that it is supported after enabling
AMX.  Remove the redundant check in the guest that XSAVE is supported.

Opportunistically, move the check that OSXSAVE is set to immediately
after the guest sets it, rather than in a separate helper.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 27889e5acbedb..9772b9fb6a15f 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -113,12 +113,6 @@ static inline void __xsavec(struct xsave_data *data, uint64_t rfbm)
 		     : "memory");
 }
 
-static inline void check_cpuid_xsave(void)
-{
-	GUEST_ASSERT(this_cpu_has(X86_FEATURE_XSAVE));
-	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
-}
-
 static void check_xtile_info(void)
 {
 	GUEST_ASSERT(this_cpu_has_p(X86_PROPERTY_XSTATE_MAX_SIZE_XCR0));
@@ -171,6 +165,7 @@ static void init_regs(void)
 	cr4 = get_cr4();
 	cr4 |= X86_CR4_OSXSAVE;
 	set_cr4(cr4);
+	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
 
 	xcr0 = __xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
@@ -183,7 +178,6 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 						    struct xsave_data *xsave_data)
 {
 	init_regs();
-	check_cpuid_xsave();
 	check_xtile_info();
 	GUEST_SYNC(1);
 
-- 
2.39.2.637.g21b0678d19-goog

