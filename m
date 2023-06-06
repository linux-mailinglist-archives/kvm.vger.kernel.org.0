Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE827246C5
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbjFFOuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbjFFOtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:49:43 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64BD1BEF
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 07:48:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f736e0c9a8so24129255e9.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 07:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686062928; x=1688654928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SvND4Aoifwo+dUZ1S4WsTaPbsjIsvOLxsML72gE5gQ=;
        b=W0OzQujYiFTvXg55rGZ10eI+6awilNw7pRMlA0O/YJNbn/9Kbj31LK4kKBhsb3FAjO
         21MI1dhKvKXonr9cYPeZCHNLjfD3fsByV7z50Nxv4Fu/encGA6GfcRo/MIign9GH2I4h
         /1zhRP4VVdmWD8Jlbo6k2+VFblqMBf8bliBBsblix2KaH6glU6PFLYGd+/of8/1mgRhA
         Xi561ojYk4uzaQB0CRmKLrZw8dyWEgmAtbwA8y8LuIWXOTuBNI3yAlYswLEmSBf8DhKc
         yHzEpwKYQyorlv9w44M/I6AdbBnZdKjWgttGza1Yb95a9XU5I4jCpjhDXRVvOJRlkjc/
         Xrww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686062928; x=1688654928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9SvND4Aoifwo+dUZ1S4WsTaPbsjIsvOLxsML72gE5gQ=;
        b=K37nSTGKEbYtjCfbjgOToc4J23CLOLtGW2mQTw/4L+wWcgn3Ba/SqR5Zbv+9hvxz51
         FWSWbUx963+XhhoTFKYM6WTc12w2qQ+5NnoYebEJSqiji8RltnnLtkntUOGLt8l4kMjB
         Lzxsh8aCsBmrlIHmVmG4HCgOlGfnZHhOmBGdkx2Gf3wAjy9wb4AaFrSV9uco9OI/fVEU
         uixhb7C9afKRRO8r4M/Cu/qyRMvqRSRTulLEZ0mXMyn6kcHl5n2vSmkrTFdXA3ASsLNF
         zunkq6yBuPe2SxxnyXR+Nt6PALV1wTd9LTItP+CGLhguXqiDWRFFSgd0awzhzl92BYFb
         9bZg==
X-Gm-Message-State: AC+VfDxt0ho+cgf3RqAIDsWbdLKLnuVudA7uz2E83NeVqDR6iXQuqgZ7
        Zii2HEN0xwM8zckWQwmZhdHngiB+fT9tD/L2Degnxw==
X-Google-Smtp-Source: ACHHUZ7kOV86Q7cILymxN8rGTsBUaOH7XH/w8PzONPJ+YYIm4jy4s6HeFtbHPGsqLsNAUYpfYvvdtw==
X-Received: by 2002:a05:600c:286:b0:3f6:69f:75e0 with SMTP id 6-20020a05600c028600b003f6069f75e0mr2373582wmk.25.1686062928326;
        Tue, 06 Jun 2023 07:48:48 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c378900b003f7e4d143cfsm5722692wmr.15.2023.06.06.07.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:48:48 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 2/3] arm/kvm-cpu: Fix new build warning
Date:   Tue,  6 Jun 2023 15:37:35 +0100
Message-Id: <20230606143733.994679-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606143733.994679-1-jean-philippe@linaro.org>
References: <20230606143733.994679-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GCC 13.1 complains about uninitialized value:

arm/kvm-cpu.c: In function 'kvm_cpu__arch_init':
arm/kvm-cpu.c:119:41: error: 'target' may be used uninitialized [-Werror=maybe-uninitialized]
  119 |         vcpu->cpu_compatible    = target->compatible;
      |                                   ~~~~~~^~~~~~~~~~~~
arm/kvm-cpu.c:40:32: note: 'target' was declared here
   40 |         struct kvm_arm_target *target;
      |                                ^~~~~~

This can't happen in practice (we call die() when no target is found), but
initialize the target variable earlier to make GCC happy.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arm/kvm-cpu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 98bc5fdf..a43eb90a 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -37,7 +37,7 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target)
 
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
-	struct kvm_arm_target *target;
+	struct kvm_arm_target *target = NULL;
 	struct kvm_cpu *vcpu;
 	int coalesced_offset, mmap_size, err = -1;
 	unsigned int i;
@@ -81,7 +81,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	err = ioctl(kvm->vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
 	if (!err) {
 		/* Match preferred target CPU type. */
-		target = NULL;
 		for (i = 0; i < ARRAY_SIZE(kvm_arm_targets); ++i) {
 			if (!kvm_arm_targets[i])
 				continue;
-- 
2.40.1

