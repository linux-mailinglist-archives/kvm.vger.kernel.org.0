Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AA7369E3D
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244728AbhDXAzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244712AbhDXAy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:54:26 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93CCC0612B1
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:31 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id w20-20020a0562140b34b029019c9674180fso19479162qvj.0
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dwT5gDx8U+TXQv6xKXH5cDgd0KUyWk3Y9gjyR2V9h0g=;
        b=l8ErXtGiagqYGtTD5hcXb339Fg9mJCb4XUVGzrj5cDuO82nBEXHxHkUm05WJ0ypAWz
         fve7vgYc1/WZwz2APDMoyEn72hM55Ydxd/Vm3cpuzSNFI26zDZunqMRAmEcJBze5CEPo
         QdW7j5tWccjbNSW7GaO/JxQpi84x7UClBc+dgzKPNJ6+bwN1U2Qq1XTHC82UmYhxJ+u9
         pi9LPGonJtCYXHPTCMLq4SiQCCoAz9bYmvKv4GHSQDNVVbzmFRIK+b2Hm3NknIdHQ4WI
         b7jPoNOb24j5/Q27UwlAqWyjrGIRJzjiUzFa5dysl6hvzRBXTyAx6e5mH6Wq9E4asuUk
         ewbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dwT5gDx8U+TXQv6xKXH5cDgd0KUyWk3Y9gjyR2V9h0g=;
        b=B4ahjYB2MaALQPX709O1FUBwA8a2h0G6xNv/wUUihF402oK0w6QIYP3PaTJHXMo0t7
         lwOak3q5Iwve0bAsGHJi38ATTtzUq1btF8ELfywn+iGfP6/sPdMISjkaRPmUsf7yF1gJ
         BZBLk/dpDb3Np8Cbt6Z8dRO8/WTSXYJEDFyJWMUGwCPs4HZBRChaoF6bS5malqaMa6eG
         nWpQmEnq7shwoyGFTyCVY6+dssBEhDFrusP5lBYffASNufMnJLgrPOWP2sFoLXGUiaRz
         X218+qAwBsOZDsIi/PHs+v3jCXPk1UJf2Mxeoko8ah2bdG+1Ex5fO095ccyGrOUZjH6k
         v+6g==
X-Gm-Message-State: AOAM533CtbmHco3riCrAt4guMSUocD6TaCzFocqhTVijQ4xLVDFEVB8C
        dRIssoNIEEE14ZzCLCmPU83NU9gD94c=
X-Google-Smtp-Source: ABdhPJyJLXPmypGxS0Nd+GIxuMgYV+8Xnctu20pirxZqq4r04lQSaraBi7RF97vOU0EGhYj6UvgkWN515yM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a0c:fa52:: with SMTP id k18mr7269182qvo.22.1619225310920;
 Fri, 23 Apr 2021 17:48:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:43 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-42-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 41/43] KVM: VMX: Remove redundant write to set vCPU as active
 at RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop a call to vmx_clear_hlt() during vCPU INIT, the guest's activity
state is unconditionally set to "active" a few lines earlier in
vmx_vcpu_reset().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dcef189b0108..78d17adce7e6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4568,8 +4568,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
-	if (init_event)
-		vmx_clear_hlt(vcpu);
 }
 
 static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
-- 
2.31.1.498.g6c1eba8ee3d-goog

