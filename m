Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB1704DA8
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 14:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbjEPMWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 08:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbjEPMW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 08:22:28 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EEC4C26
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 05:22:05 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-643a1fed360so8703960b3a.3
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 05:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684239725; x=1686831725;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JM6/qpQsAge7v2TKgs3A0yOlH25a2F2tkR0wV3+r1w=;
        b=boCsNFfk11nzt+7urjc+16QtkCwyyg1YW5iuUifG0Rl/dpWdksfcJL9jOX4/Xi9mo/
         ZFZf+Lvh+4uLu9CTBGy6jebUrCc+ROV+K89QG10Oed3WdwAvpICOz1lkrsx7ypzUvk/0
         hN1AgEGuvEZP4adsmUMktEk/PbJdqjqw0dTy48zKrMLV5Qu+s3cWl07dzqErF11b9H77
         Nz7ywabX0PND15PP5PTlENz70oTpt0TywhICgunnBpYWZvRY3tMYe7UipPaaExzl6C74
         eiIEprTOYf+6kETXczgLnXz78cNDte5n2S1/uJuV44Y3vjSre8TtlYZNcgZzltCxsR2F
         8OMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684239725; x=1686831725;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0JM6/qpQsAge7v2TKgs3A0yOlH25a2F2tkR0wV3+r1w=;
        b=ddaf0QlP6niS5gWrBHH6+gxXXYbQtMZuWjhH2xUmpWWgPPBYJc9DisTZfczxiC3Trs
         el1JIPeagxUrW95NZ40ePXbXBpKOcEqQ8hmaZwELUIQuqNZ+71jrvcXgM+11kWIFumo0
         OYqY652o4vHgtCw2Q2xAw+Iw2rQV8y3p72Ur1fEnqKBIx2166B0BFn9II/vV76fyWFqK
         apoYOZWqe/149T0JjAmfVVePO/yf6/Nq5Udrs5ulm33gIRmzqiFejlfJFl9e2DqB4JZj
         YDj6uv+uZ6lP4A57walbOoyD+ABALBNQPFdyaBJPL6dbcUCatJT5EAiDK+2FTgEGcUh/
         5FrA==
X-Gm-Message-State: AC+VfDxa6oipH/egQHWguzC+MsVTnXsqeEs1kVPTOjD4NFstaBlki3lJ
        ujqyZxr5sz3FWFQI6he95fXkdg==
X-Google-Smtp-Source: ACHHUZ5I3rodN/iIlA29JPvcZhsHsET6xfyIhfLdmamj6Fz3Pi1Nr0SNEaPuWSZOwL80wcguKdGeUA==
X-Received: by 2002:a05:6a00:2d1b:b0:64b:43d8:a575 with SMTP id fa27-20020a056a002d1b00b0064b43d8a575mr13172051pfb.25.1684239724914;
        Tue, 16 May 2023 05:22:04 -0700 (PDT)
Received: from n37-012-157.byted.org ([180.184.51.70])
        by smtp.gmail.com with ESMTPSA id 4-20020aa79104000000b0063aa1763146sm1057913pfh.17.2023.05.16.05.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 05:22:04 -0700 (PDT)
From:   "dengqiao.joey" <dengqiao.joey@bytedance.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "dengqiao.joey" <dengqiao.joey@bytedance.com>
Subject: [PATCH] KVM: SVM: Update destination when updating pi irte
Date:   Tue, 16 May 2023 20:21:59 +0800
Message-Id: <20230516122159.3834044-1-dengqiao.joey@bytedance.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Destination of irte will be cleard by IOMMU driver when updating irte.
It will only be set correctly in vcpu_load. IOMMU will deliver the
doorbell message to the wrong physical cpu before vcpu_load is executed.
That means vcpu can not recognize interrupt delivery during the time of
non-root mode.

Signed-off-by: dengqiao.joey <dengqiao.joey@bytedance.com>
---
 arch/x86/kvm/svm/avic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cfc8ab773025..16fe41429123 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -933,8 +933,11 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 			 * we can reference to them directly when we update vcpu
 			 * scheduling information in IOMMU irte.
 			 */
-			if (!ret && pi.is_guest_mode)
+			if (!ret && pi.is_guest_mode) {
+				amd_iommu_update_ga(kvm_cpu_get_apicid(svm->vcpu.cpu),
+						    true, pi.ir_data);
 				svm_ir_list_add(svm, &pi);
+			}
 		} else {
 			/* Use legacy mode in IRTE */
 			struct amd_iommu_pi_data pi;
-- 
2.11.0

