Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A010F4D58F1
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbiCKD3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346062AbiCKD3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:21 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95073ECB15
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:17 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id q7-20020a63e207000000b003801b9bb18dso4047393pgh.15
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ah7917HNa/g0cmKwYFpbM45yCdlvulapW582Yzn7pZ0=;
        b=N407RnY58cz0djG3g+jXoIaXBqOrqIAQT5TafvJUD7SHhBvrPDJvakgzpjkg06fbrx
         SUfemsCdjmv3U4K/JwCSJ9qb40qz9Mmxbex4VowQEoCe19Mwrp0FK/fwbJP5qnXmgDpD
         aClTR0kaIMLMEiqIc0ZV/yLp9SaHLcVsPuJPBNiBMk6K5mVLN4NBlRH6G7CyyEFQeqY4
         IVTF8YlLKrXiNpNSRsRNWqsKxFzvh6xFEB4sztjCQ+7jiG2ZGhMxYB8vvur0SRS33HBV
         jg+Fj5WHM8hBK7IuMlRSTg7uCIiA8e9PClba+YuIAQ9duIdfU9N5X6zEtGCUlvCQbGsU
         Ew2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ah7917HNa/g0cmKwYFpbM45yCdlvulapW582Yzn7pZ0=;
        b=ilZO48I/VEuwvFiufcn9nL1Q0H7qopKXPmijUTqdL1UzOPDjUUb0oh/Qj/n7H1/BHO
         Lq0wMboAKeVMU/y9MBV6NfPoENXT0QyzSFvNR8x0mfj2OAaYLZYQCRiqb+QbwTimuQ7k
         8g9EcghFt09hcDeS6hyWpq/sKdRAF/obI6bX3CTjVRyHNpHSqkJseUykJX5mwNZXoVG2
         V6VTGaut2iuVgTDs6cZfwUja5RsiobVNFZb83meHR+Yv+XQmijOYlC/O9xfqEuJBq+o4
         AnchvEaTFc7DasQvxSCc0WVd2vh8ICFVNbSbFMa91Dgt4JxD9iK848NgnCcl/nuDYs7a
         pB6g==
X-Gm-Message-State: AOAM530MZduCO4URct9ycn8ROdzPngtuQsgXj90wpfBGI6pya9zu/kTF
        V/lVJAn2M4HMQrQewVZaDO05q6x1BZU=
X-Google-Smtp-Source: ABdhPJwVEqTJyDOKgyRp9BN9/5t9HOysd368ONGXLWYbTYZ9iwc0I/OfH2lbvowB1Cq6FK3nyOUCoBrpfng=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e2cc:b0:1bf:711f:11e7 with SMTP id
 fr12-20020a17090ae2cc00b001bf711f11e7mr19466024pjb.40.1646969297010; Thu, 10
 Mar 2022 19:28:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:48 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 08/21] KVM: x86: Use DR7_GD macro instead of open coding check
 in emulator
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Use DR7_GD in the emulator instead of open coding the check, and drop a
comically wrong comment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a60b4d20b309..648a0687120d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4148,8 +4148,7 @@ static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
 
 	ctxt->ops->get_dr(ctxt, 7, &dr7);
 
-	/* Check if DR7.Global_Enable is set */
-	return dr7 & (1 << 13);
+	return dr7 & DR7_GD;
 }
 
 static int check_dr_read(struct x86_emulate_ctxt *ctxt)
-- 
2.35.1.723.g4982287a31-goog

