Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4360A49F004
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344988AbiA1Axo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344881AbiA1Ax2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:28 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750C8C061758
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:24 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id b5-20020a170902650500b0014ae8f3b622so2284365plk.22
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0eMfYCih7vaFuBJ8EMuOAoXTDwMjKd4f4Kk7vbGbBek=;
        b=UobE1XhGxotFV1a2F+P38rwwjwaCv2Et8zUI3jzIa4+8hMEkEMYcuvA8iIkX+fKLKn
         ysUsmJ2VFXBxBM23y8Z4UQMUV+lu1ouJQsw/m+N+KyzNl4oYOmL73lqiCSnpWInTuM2b
         qfiESD8hcmbVZUDKJ+tB8B9u117ixbWeRI0x6Nu5aLlY/Hwisl4ESULKgQUwAgGnseBC
         5vk7+V6Ha0MUdElrnKzkA2qHjlygi7maBN9CWaYnkpLF3fy7knVX77qVZtENq7wEViy2
         XACyQi4yu++tl4zrQfO3HULgHey1FeJEE72ZEWb2+odXP4JeP4K5r6i87Z+Hr+zElTA+
         zg2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0eMfYCih7vaFuBJ8EMuOAoXTDwMjKd4f4Kk7vbGbBek=;
        b=M2NElPlVlSeWKk2sW9PhZNbJtRjDpupmmqFo2VBSHDWw/FxkTtzy1m0SXNqqEtIu4e
         E9gXBO/lbKywce79Ogt7SoSwZK2wWvuZgdvSgpeUBEl9Z0JWQFVm6Xb5gV/xIPeuyZec
         HBXCxmTLA8kAPDZesEWsucrMQsH1Edg/Sv21X7XZewkvFHGQ3DnvksANrp70IfB8iNxF
         +M49YEILYD4zYsES1EVlxWcV42GZN+lAL5u4DnmtbL3nueVwASBNfUQAJmphca5vhiUL
         43kuqqp+9NICFFQ8z3xN/QznKreE47XkWZ1def0hWlcz4ODpOyuBxlJrTMkRbe25tYSE
         Z0UA==
X-Gm-Message-State: AOAM533VbPUB0gQez2Bu7LqM+Gm9EPhEddhlp/mVZc4WIK3XtXpwbZIZ
        OLxgksW/qvhS/1oG7eyPdEOpoyBoo44=
X-Google-Smtp-Source: ABdhPJz7pZs1Ceyo+NRWY7GpWcoS2ruelsiAb+55NOdScJRBCbqI54L2vUBn/KJ2p/BlO2vgm9Mt4MU6OuM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac4:: with SMTP id
 q4mr6635369plx.22.1643331203897; Thu, 27 Jan 2022 16:53:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:52 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 06/22] KVM: VMX: Call vmx_get_cpl() directly in handle_dr()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vmx_get_cpl() instead of bouncing through kvm_x86_ops.get_cpl() when
performing a CPL check on MOV DR accesses.  This avoids a RETPOLINE (when
enabled), and more importantly removes a vendor reference to kvm_x86_ops
and helps pave the way for unexporting kvm_x86_ops.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1d2d850b124b..de66786396bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5184,7 +5184,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	if (!kvm_require_dr(vcpu, dr))
 		return 1;
 
-	if (kvm_x86_ops.get_cpl(vcpu) > 0)
+	if (vmx_get_cpl(vcpu) > 0)
 		goto out;
 
 	dr7 = vmcs_readl(GUEST_DR7);
-- 
2.35.0.rc0.227.g00780c9af4-goog

