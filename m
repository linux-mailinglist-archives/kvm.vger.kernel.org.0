Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E5C7270BA
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjFGVvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjFGVvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:51:36 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692691BFF
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:51:35 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53fa00ed93dso6842220a12.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686174695; x=1688766695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Mky0TyVJplhbL0ZA6QSy0bQSeQb6MNLQdLcVynl0ssM=;
        b=oyE2FzzZOz9lRKO8sXPzYP3huVz2tuX6S5wWvSbKqr8c7kuyQ31MVUtpLjgukXrl5z
         MvjkzFXD/8Qz531LgxaEmIDipAunYy0jJQal3XlIZoAs8Z/ppUZM4KUfDzgJPc1EoXUa
         VT5OS+RIaEROMNkSQ0kuP8meLGjreuZabxu1RBBs2o7d/qq3ktIKOEZK3P0K95RDBxV5
         LNabn2yVQQdNdiaCCQJ7Pxx+qVhHQhhxRwsYpzLggrOYxMF5A2f/40Pj7Q40CDgK2QkO
         l9ng45ycvEnthD1ODq4NZ8jLfa3lhc5E1N+7BbGsTYgiN/h4u9P4EfrnT8muRYc+XEXz
         7JwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686174695; x=1688766695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mky0TyVJplhbL0ZA6QSy0bQSeQb6MNLQdLcVynl0ssM=;
        b=cPoE6kkFDBW5eKMS67ut2QZtgVJVJDXCsyTNjCgsI7hknK+dp5nb0QfA0XnUZLnLf7
         3sTW9o3yzoIn64F9fscOkSXzConleIj+21Q6dMEHAc2ICsggpyD8FyQ8TfiR6+LLNRAs
         TKVoXFPW8D5QTstUTzRUjRkp+zp3wvdlP4utChTOBLjH2PV+S+uRzh1Ssm26Xzq6hlqP
         x44SgcjNmLHadkig3qPAHwrebBP/ry7cNGraXmehozW4Pr6aEyW+G0p4/9wNICMX+qs2
         CmQfPhV8gLxHVDNRN2vqYhzJnHpzetMiWx1MByGyCiSooaClM5l6Dczm5lrbqjXIDZIq
         GDcw==
X-Gm-Message-State: AC+VfDzj6ckUxz7RbrKyDRqcfUTQrGE/GChy2pzQeF9kcikI2ehh3Hn2
        dfBtNOSNXSAo8sNyhjkCaizkk6WLv78=
X-Google-Smtp-Source: ACHHUZ4MvLOB581PkvPGah8I7ZhsiM+TdZHqgXRWPr5Fgn1XaEwBDO7yepmj4Esp6Y1iWdw41Ls1d2yQQ7Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:116:0:b0:53f:2302:8f6a with SMTP id
 22-20020a630116000000b0053f23028f6amr1513697pgb.8.1686174694968; Wed, 07 Jun
 2023 14:51:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:51:13 -0700
In-Reply-To: <20230607215114.1586228-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607215114.1586228-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607215114.1586228-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/2] runtime: Convert "check" from string to
 array so that iterating works
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Convert "check" from a string to an array so that splitting on whitespace
for iteration works as expected, i.e. so that testcases can have multiple
requirements.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 scripts/runtime.bash | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 07b62b0e..1cfc5bfd 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -120,6 +120,7 @@ function run()
     # the check line can contain multiple files to check separated by a space
     # but each check parameter needs to be of the form <path>=<value>
     if [ "$check" ]; then
+        check=($check)
         for check_param in "${check[@]}"; do
             path=${check_param%%=*}
             value=${check_param#*=}
-- 
2.41.0.162.gfafddb0af9-goog

