Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666075033C4
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiDPDpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 23:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiDPDpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 23:45:32 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798F5AC91C
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:43:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id mm2-20020a17090b358200b001bf529127dfso5602307pjb.6
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SmCJkdJ/vwMUfGmNWazGZsDfEc6XkQHjevkhSXAb2Yk=;
        b=juavA14gxeDUNMBVNDFwrkIewI106flYCwM8f2DzoPuJXlSo9m/7dyuwNeKSJMVzOS
         ddxnzaXXP8NCtBJCESS6h1KWx0qRdJ7SBopKU0G8uJ6pskNvPqPkTdr8ZDuEjcgjYQ6O
         vw0jraBFoCDIp+jzX3mrtG0AoFKFq+QY0k5PJcuz6uPwWX/nHnG/aIP493gffDska3VE
         w4woJJschfQTOpgiNwHlb+jndJnMdU8kjyGd+x0kOgLm74fmqF6sAuLsry7T0aXdhxrK
         BfivIU3Mmz+ggBito4Ec+NNP5+ohaKNPcNm0+VZLSZXjbDhfKmiVtmxHBdD1I6cAnqkE
         6F8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SmCJkdJ/vwMUfGmNWazGZsDfEc6XkQHjevkhSXAb2Yk=;
        b=SnNN7ukILC9jGx/jW2ZrSGLMAKqIi90q9gLnEeIPbYcj2yK1IRoOLitqlTTDpD8JT8
         srjk31LBzgrzFgK4bANdeRD8cmWPXThMY27tq38jw1sGkUfg7RdqhIw1AJ9jjM4VB+ZD
         30VFhH4FbYYT5Yj6TC0m0n6E5quFPuCTBElTYMGa4YuBrEVlSYTMGtMQ9fKJ4aX1uzTQ
         8tmjmjxrzX4e+y7WSIHbwh8Mdu4mZ93cJHcy/aRILEzF7TcBAup75+eB0mXmji2PPiK6
         DxJT6HUML0P94RnWnPx4ynspI1qX0ykyrBVM5NI3DMdK1cXFmq7kmbOwHTaUdwMeYkEh
         hygA==
X-Gm-Message-State: AOAM5330B1YqqLt7NQnWgdFD4e8LpXIsFSpkCM1bOeiQNaeWlOhFogU5
        reFX52ILPvDmjMnNv2RTT7VKPdXh8xA=
X-Google-Smtp-Source: ABdhPJwp9G55Zfsk1+YnrNMGhIGmdzfZoZ2wR/fGJroCgp1Cvrv38rD0KsQLZIcG0uOnn2j0WI7n9Zqeoik=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9b87:b0:156:bf3e:9ab5 with SMTP id
 y7-20020a1709029b8700b00156bf3e9ab5mr1733337plp.119.1650080581878; Fri, 15
 Apr 2022 20:43:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 16 Apr 2022 03:42:49 +0000
In-Reply-To: <20220416034249.2609491-1-seanjc@google.com>
Message-Id: <20220416034249.2609491-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220416034249.2609491-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 4/4] KVM: x86: Skip KVM_GUESTDBG_BLOCKIRQ APICv update if
 APICv is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Skip the APICv inhibit update for KVM_GUESTDBG_BLOCKIRQ if APICv is
disabled at the module level to avoid having to acquire the mutex and
potentially process all vCPUs. The DISABLE inhibit will (barring bugs)
never be lifted, so piling on more inhibits is unnecessary.

Fixes: cae72dcc3b21 ("KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ active")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09a270cc1c8f..16c5fa7d165d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11048,6 +11048,9 @@ static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
+	if (!enable_apicv)
+		return;
+
 	down_write(&kvm->arch.apicv_update_lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-- 
2.36.0.rc0.470.gd361397f0d-goog

