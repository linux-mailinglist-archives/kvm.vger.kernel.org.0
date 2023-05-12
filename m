Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1447012B8
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241572AbjELXwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241115AbjELXva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:51:30 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7366D2F8
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5308f5d8ac9so1106416a12.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935450; x=1686527450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LxDcS09oj97Wx6mpqCitfgO/wEihL/zs3WwclzJXVrs=;
        b=3UXj1nizRj4oLlTnGsYo1jkyfL9mkU7aP/AxzLjzcVWd8MZkQxCNMnS23/8RJLUodw
         ok0SC36DquJdKQxN0hVH2pSrfB/YpQoZ+CuGE0RKez4/PELDoIiFFBzGqSy72J+ABaaq
         GWVTkuyWWe6Tawuv1GiXVa+yG8hjXRwVLP72B8xy5qR/7Hdii+1lAGNeR5AzErGSj8m9
         gwg8AQX2Ds6B/Uah4Wo0jc/YRzmzCj0Cnbuf2MQ8taXsF9E035Mhg+npjUwXrmSfYxXv
         Diw7E7tGb2lO1KIw4MRr1dv/yBVPkPcpcpc06jetvGRD/CVzjuA/1axT0GN8S+Tn5KGZ
         rGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935450; x=1686527450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LxDcS09oj97Wx6mpqCitfgO/wEihL/zs3WwclzJXVrs=;
        b=AssYIFYs8NV3rymtIlwMNUEBemGwtnVg6WxcCpXE1GGWOlc0Qlav7kIAD9ekLw7dx1
         UHjERyUd61fVtJi7Z7wWGCT99ljCzGiH53cOWxjwQJNfe2wCjDrAj3uNVIV6xSMbuhP0
         mfPqlpNPz6vzZxZEijhyLLUI2QxNUk1H2gGGjgjb1+9Rs+1dcxYn7ExLctt+BYHbROC2
         DbUJXH0oZ1yZUQgmzDKwmIFN1n2WuImhQyCWF8HisZMtcNMa5SXXKS1GMt5EtwdzqUKP
         x6FGHywa+zxVpqBTA9njX3sjTgg2Ot96cTG5YL4En8+mAa46h9rbDmmTjYYEjG5Amiyv
         8PPA==
X-Gm-Message-State: AC+VfDzipqFLayKa5lLI9ZlAzFmd2VORjGqVXbVktMrGdHJ+BsYnX3bp
        fqCNEgMdkuQXu8+X/ZQfZaO8qj10Qgo=
X-Google-Smtp-Source: ACHHUZ48zczwBDKdvB3sWp2+ob+YdKHROmTh6zcvA3LCitTa2KUmje9WaICS5+vDj+EmmtaYbGyho3TFxQ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:482:b0:244:9147:ee20 with SMTP id
 bh2-20020a17090b048200b002449147ee20mr8107720pjb.0.1683935450341; Fri, 12 May
 2023 16:50:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:19 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-12-seanjc@google.com>
Subject: [PATCH v3 11/18] KVM: SVM: Make KVM_AMD depend on CPU_SUP_AMD or CPU_SUP_HYGON
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make building KVM SVM support depend on support for AMD or Hygon.  KVM
already effectively restricts SVM support to AMD and Hygon by virtue of
the vendor string checks in cpu_has_svm(), and KVM VMX supports depends
on one of its three known vendors (Intel, Centaur, or Zhaoxin).

Add the CPU_SUP_HYGON clause even though CPU_SUP_HYGON selects CPU_SUP_AMD
to document that KVM SVM support isn't just for AMD CPUs, and to prevent
breakage should Hygon support ever become a standalone thing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8e578311ca9d..0d403e9b6a47 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -102,7 +102,7 @@ config X86_SGX_KVM
 
 config KVM_AMD
 	tristate "KVM for AMD processors support"
-	depends on KVM
+	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
 	help
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
-- 
2.40.1.606.ga4b1b128d6-goog

