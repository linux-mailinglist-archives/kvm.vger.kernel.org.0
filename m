Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92A054D1A2
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346555AbiFOTbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 15:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346383AbiFOTbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 15:31:36 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1450544E5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:31:35 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3175d2c4beaso14005297b3.10
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=p5lI2xiHmpMNi5Qspc8ysgo55K7EWn4WgT9n1L+fZKs=;
        b=mG6dyBnv2Z1YIhYMMdOhxpmTOlhI6K5F3pqVu7BBfWjuTllDmyHe24BM5YFrSH3k3m
         k37eaVag1hTqsXm2MRzzXDOHY8me4Bq0JCL74CQUtSUR0vYxJ92PPv59X3Z/tLK9Dn+F
         zeTFHx0m2edykqQZX28LMgGlhp3UWw1H3teXTxJbhpynPri8OGPfBeq2am/bZgiujx0X
         RListKVLmXaPRxX72t+rUnfMj64Mkah1i+sXryEK9ouBTNns2t/OmP+IoEmB0+ArGp0B
         fUYX+EcewLKlIUXdyTsVoKIvawpcNwMHPujF1u2WdawbTnka+vjiHykWjlxZcCf9FAZY
         07pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p5lI2xiHmpMNi5Qspc8ysgo55K7EWn4WgT9n1L+fZKs=;
        b=O1kF3ZtDJUcLjTyssgZTXNZlPGoGl0XUGEmOYMYyQOLnJHa4CBlto9RWUDfLEUtVMl
         pgdnaTZ60o9fVc7M7cVQMn+O7QgUVN4GozY5zgCXj6zKM20kYqn9Re9oSSMaMf/elIjo
         GhN8m0B9Xk3e/fsQGTl1cYhGC6HwtW4SuA7oyywCvkNz3FXcBiqst0t3Neu4a6agyyWy
         f1NNhzKscp+iYIYs1ARkSaNAO0xslpZvVGsW+sejt2izqmj/HE0AOl3Z+STRXUdm7MMg
         63mDJkRlmGRzJIiA17Q0pXlUUFcunZ/oTKdzG8+YcetfueJoe67nM5Bcm8YoJv0qD/T7
         Ug/w==
X-Gm-Message-State: AJIora8qz/u3ETELBOHiNqahZQN/mDEpW5WX9SMxt/pmKE1SweNq+3E7
        N2HEu2sa7X0uh2uPsMn0LxE/GW2z0nM+2fQzDC0qi37p+NAa3ctH/1KwM1jAIx4fFOHkqJyWjYr
        YLCvFGaiIYpVP/G+ADK7t2zUy0F6JBZ0jhu7Gfr8NrQpXKp1VHX2LmQr3lHPThMZTVGguWLw=
X-Google-Smtp-Source: AGRyM1se+2rADeaOeSDd5N6eWtlHqK6a1Gro/vu3VtVQEeTKiC1Lznt62mYgLeGnbzgYXtxxD8SkUuHPd61HawlBMA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:803:0:b0:314:17cc:1994 with SMTP
 id 3-20020a810803000000b0031417cc1994mr1398832ywi.505.1655321495080; Wed, 15
 Jun 2022 12:31:35 -0700 (PDT)
Date:   Wed, 15 Jun 2022 19:31:14 +0000
In-Reply-To: <20220615193116.806312-1-coltonlewis@google.com>
Message-Id: <20220615193116.806312-3-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220615193116.806312-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
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

Increase UCALL_MAX_ARGS to 7 to allow GUEST_ASSERT_4 to pass 3 builtin
ucall arguments specified in guest_assert_builtin_args plus 4
user-specified arguments.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index dbe872870b83..568c562f14cd 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -16,7 +16,7 @@ enum {
 	UCALL_UNHANDLED,
 };
 
-#define UCALL_MAX_ARGS 6
+#define UCALL_MAX_ARGS 7
 
 struct ucall {
 	uint64_t cmd;
-- 
2.36.1.476.g0c4daa206d-goog

