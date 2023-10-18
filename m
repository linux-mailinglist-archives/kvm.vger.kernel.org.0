Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DCB7CE0FA
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 17:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjJRPTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjJRPTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 11:19:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298D0F7
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:19:09 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a828bdcfbaso80158787b3.2
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697642348; x=1698247148; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RKf8GaX1o9f6WWK2vB+CbFj4C9pCegGrVSLQx7G2y0M=;
        b=S/0zXeIxD13YbjYzwZCBZ2z9UnHoSdEXs/cI7Biovs5AbBxT0GU/WmSfCo11COypGK
         03Xy4gMYgp3c5hLQYcA++km7MbdaAGNLr4WkIMJjRklLtKyNIaP94nDweokVM6CJZ911
         oNFMA5aNI127d8NrC7fsNLN2jr0YYFmtQhZw1t046AJQ0HF67JaoPK2gbBax52jMk+1x
         zUHqAT4g6TamsrZhqh2ehrV2DC5N7jzbrfY31x9WYpbnInSzRJ6kbPKCRbfjhHNLczDA
         u9kUF4ozsMFcfyVNhlvNhdBJqehcTYDHUZRUOgLAXbbQBkxAuvtm0QVIsQyRrT7dUUnX
         3RGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697642348; x=1698247148;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RKf8GaX1o9f6WWK2vB+CbFj4C9pCegGrVSLQx7G2y0M=;
        b=q0WtQixC4esFZOeIif7F6TiH6OX2N6YagxbRRB2QUlj9baWIEdpa9a/Z0OLpkwbCFK
         ClcX5DgGMTVhXXyk8JsWDX6ZB8KzJGTT2MeHVcZ/k+uAICl5dpuYReb1bVWRcVSX9hui
         FGKsQ/xiHhzILg2FB2cTAZ/neFVAdFJdYsyqOekPPrnd8wY46cn5T4POtVRKx21bvg8u
         zs/U/R4YEpyRONn7yPD58LPNmBNIGyvqdJhQSdQ0FIjrZf0hRA9zkUp41o0bhky+1yw0
         XX8vYnrq7Xrsrvw5xofApvYNpzLvXVbAwzWX/UXgeqLeJ+UrLj6nGKDqZB2aXc47RCjz
         sSRg==
X-Gm-Message-State: AOJu0Yy5Fu68t8y0U5afRZx04fHMj7AkknWiJrafIIcc1Rj/a71Olis7
        tw5Qbomsl6hoPLv8zGR3eVx6iGgOur0=
X-Google-Smtp-Source: AGHT+IFzVOU51luGASB5uQCNgMK/kOtMd82lhexpSuoDtf9livm6SIy9kw5c8OYWxamwbZ/VoiOC/njkOwU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca97:0:b0:59b:c6bb:bab9 with SMTP id
 m145-20020a0dca97000000b0059bc6bbbab9mr127129ywd.3.1697642348422; Wed, 18 Oct
 2023 08:19:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 08:19:06 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018151906.1841689-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Turn off KVM_WERROR by default for all configs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
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

Don't enable KVM_WERROR by default for x86-64 builds as KVM's one-off
-Werror enabling is *mostly* superseded by the kernel-wide WERROR, and
enabling KVM_WERROR by default can cause problems for developers working
on other subsystems.  E.g. subsystems that have a "zero W=1 regressions"
rule can inadvertently build KVM with -Werror and W=1, and end up with
build failures that are completely uninteresting to the developer (W=1 is
prone to false positives, especially on older compilers).

Keep KVM_WERROR as there are combinations where enabling WERROR isn't
feasible, e.g. the default FRAME_WARN=1024 on i386 builds generates a
non-zero number of warnings and thus errors, and there are far too many
warnings throughout the kernel to enable WERROR with W=1 (building KVM
with -Werror is desirable (with a sane compiler) as W=1 does generate
useful warnings).

Opportunistically drop the dependency on !COMPILE_TEST as it's completely
meaningless (it was copied from i195's -Werror Kconfig), as the kernel's
WERROR is explicitly *enabled* for COMPILE_TEST=y kernel's, i.e. enabling
-Werror is obviosly not dependent on COMPILE_TEST=n.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/all/20231006205415.3501535-1-kuba@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 950c12868d30..6cc0ea9cd91d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -65,13 +65,13 @@ config KVM
 
 config KVM_WERROR
 	bool "Compile KVM with -Werror"
-	# KASAN may cause the build to fail due to larger frames
-	default y if X86_64 && !KASAN
-	# We use the dependency on !COMPILE_TEST to not be enabled
-	# blindly in allmodconfig or allyesconfig configurations
-	depends on KVM
-	depends on (X86_64 && !KASAN) || !COMPILE_TEST
-	depends on EXPERT
+	# Disallow KVM's -Werror if KASAN is enabled, e.g. to guard against
+	# randomized configs from selecting KVM_WERROR=y, which doesn't play
+	# nice with KASAN.  KASAN builds generates warnings for the default
+	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
+	# Building KVM with -Werror and KASAN is still doable via enabling
+	# the kernel-wide WERROR=y.
+	depends on KVM && EXPERT && !KASAN
 	help
 	  Add -Werror to the build flags for KVM.
 

base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
-- 
2.42.0.655.g421f12c284-goog

