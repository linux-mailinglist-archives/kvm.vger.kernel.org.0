Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C9554D19F
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346484AbiFOTbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 15:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346239AbiFOTbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 15:31:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9251544E6
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:31:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u128-20020a25dd86000000b0066073927e92so11159218ybg.13
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0A1qUobQisYFir8bSqnJq36CQ0mNNtlgbs2SvOAwXHc=;
        b=bCrCYBvAVJ0y9knJ7QoMwIeTYXyOw5k/4LkQcVf0DA/Yr8hb3yW/EgVWEv8valPkm8
         U4svsfa3sLOe1UCzmLIXirRpvkijJ4/5AqxlWOdebDyGc/+VUvhKUHom4CroL00WVP1r
         Zt++yo/4GAyKr2NIuzZcWFegc1x2B3sGI1VUIPt1ksp09TutxZREOyldn6VFPZsWCrtR
         l4LGYraLm64GnCpy2fUgxby76+e/rwy8XMNm8bzF/lmnIsyCDU7g2EYFAj7UT+a1CRCm
         FF7nv4Ddtbtcb9kIgHsRN6srMWtxGKYFdXzTsm/cplt1sKcPfDrRuk3CsjRsKbKnWC+w
         lKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0A1qUobQisYFir8bSqnJq36CQ0mNNtlgbs2SvOAwXHc=;
        b=sU1edyNzxyUuLTkFgTWXjMFMYmX3EiTDv44yFFyuPHKWvCvnZQtNZO9ZqtKo0aTnM8
         CxU/bNmvhfWEDSYFg5ZbxZPHVIgDAdtvfvsFk3+JOvGx3l07SXpJujVjZntkBrvESACQ
         za4PXApUarzhHZkCEHtnSeofD3Blg4VFPLMZpcHlESASTK/URaiuZE9SE+nFFXoYLf+Y
         7nPhdvL9mPLMkyT8NACo38UsCOO5cV7Lh5rLTNEudAnz56gAEbGxbV+3naZThhYzmt2i
         puple42/CmK+2dC4hgn6x5mYeMjOYL/fxLCxqFWBDbO20kYz/8SmCTfqWsapx88Ae3vN
         udXA==
X-Gm-Message-State: AJIora+f0ci4Vgp4Q5PZcQlgSiwm7qplEwpoAOs7IBhYkBvG4jswRmFX
        BHOs+NWupgOm3JWiyoQTUnNAeuDgyb9VIPGy2PjKEvoHP2tiW+2U+8hQSpXm+GPVbfwqj5h7dTz
        neIu2lMT6azHMfyHRt1mGfXHF67j2oHg0E3fcs6xRBZYsDXL5yHoHVn4fgIr2GTla3375f+g=
X-Google-Smtp-Source: AGRyM1sFpUaVIm0gUXUCuBF8nXSdLidTfcGiqvEhvoTkkRBFVlcKYuhXbB7NYKNV0DsIASsf2o84Kvj0GtDCb8zK2Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:4992:0:b0:30c:1b61:82ac with SMTP
 id w140-20020a814992000000b0030c1b6182acmr1399797ywa.348.1655321494001; Wed,
 15 Jun 2022 12:31:34 -0700 (PDT)
Date:   Wed, 15 Jun 2022 19:31:13 +0000
In-Reply-To: <20220615193116.806312-1-coltonlewis@google.com>
Message-Id: <20220615193116.806312-2-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220615193116.806312-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 1/4] KVM: selftests: enumerate GUEST_ASSERT arguments
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Cc:     seanjc@google.com, drjones@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enumerate GUEST_ASSERT arguments to avoid magic indices to ucall.args.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 98562f685151..dbe872870b83 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -32,6 +32,14 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
+
+enum guest_assert_builtin_args {
+	GUEST_ERROR_STRING,
+	GUEST_FILE,
+	GUEST_LINE,
+	GUEST_ASSERT_BUILTIN_NARGS
+};
+
 #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
 	if (!(_condition))                                              \
 		ucall(UCALL_ABORT, 2 + _nargs,                          \
-- 
2.36.1.476.g0c4daa206d-goog

