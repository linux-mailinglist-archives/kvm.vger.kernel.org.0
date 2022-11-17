Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2771B62E5FC
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbiKQUea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbiKQUeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:34:24 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52EC11C1A
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:34:23 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s5so4246690edc.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i8p0Y2g3W9WxbciMyPWKXluBzCqKVe7ku277ee8HdV0=;
        b=TK9xPjxqSMqvypiFPPOvDehAVsCyI0Qm0yW84ddWsSa1sfKcBL6LIgNxI1incD42h9
         NIgox4wcfO3aJDEiXrb+EPZFJJhADQeZaw1T+TbHxUHBy+LTFhJZeN2hwArEsvIfgUj/
         UeIrWXouuq9owj5lxvfKm1vHqqQ49kPiVE2wn1bAGQAGbwSyJme/mPGcblvcAqimWCZH
         VqLA2ORgp43TgZ7L4Sd8JDJ73arRTkSvXAXbtflhx9M1ppdmlAI0gEhGjjpGXyEH9JfE
         x9dlVQZmM/1wFBE2JDodyHv1V0zidGbrrk3zXeh6ouggbRCOlNkDqEsVRMswNAbQPbFk
         BPwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i8p0Y2g3W9WxbciMyPWKXluBzCqKVe7ku277ee8HdV0=;
        b=ap93Dze3ZrLLmSy0RJtEppk6MOETS8SM3NHYVADzDQaItDkwM9TZwbkpr04QM+8U2x
         Km1UGqY7oWhjH6aJ9RgmotxssVeYUSrOiKvCXnMkGM1nyHZDtntGSlBeQCq70mYWnQOE
         l4QB37b/qU/lpKPxcYjm0y+l1X2ghC7SvWVd257/tTYikDSks+uZ3gLEm4qtZiGaSOA3
         hPoHyEuO3Ytai9tI2AC1mQPaAnLDy5dgIBBEhd8lcWwJCX9boZ6f/1/lBYK4BIklpWzq
         6QIFuPntwYI19WRhBhHZUVE+VnL2xjfgUgpfu2qV251RFXuCTDPHWlCynSiRvk4Jo3vW
         yYpw==
X-Gm-Message-State: ANoB5pkvegZ4sKfgCGuVDwba2v/PHHDWjUq6wpNDrAXgmpH9AAMOyshG
        HDeDvoyMdY36opC1LDapQA==
X-Google-Smtp-Source: AA0mqf7IiZwNwEz7T0sel2YQvgrsXMKKggZuymhg0wOlQIKzAYqnDeASU1Q5T0UOSkuKuguR6Dw52w==
X-Received: by 2002:a05:6402:5157:b0:458:d1c4:106f with SMTP id n23-20020a056402515700b00458d1c4106fmr3611344edd.408.1668717262156;
        Thu, 17 Nov 2022 12:34:22 -0800 (PST)
Received: from p183 ([46.53.253.26])
        by smtp.gmail.com with ESMTPSA id qp25-20020a170907207900b007081282cbd8sm796086ejb.76.2022.11.17.12.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:34:21 -0800 (PST)
Date:   Thu, 17 Nov 2022 23:34:19 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH] kvm: account allocation in generic version of
 kvm_arch_alloc_vm()
Message-ID: <Y3aay2u2KQgiR0un@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is persistent allocation and arch-specific versions account it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1466,7 +1466,7 @@ int kvm_arch_create_vm_debugfs(struct kvm *kvm);
  */
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	return kzalloc(sizeof(struct kvm), GFP_KERNEL_ACCOUNT);
 }
 #endif
 
