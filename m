Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A77849D0A0
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243677AbiAZRWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243638AbiAZRWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 12:22:33 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA55FC06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:22:32 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id q1-20020a17090a064100b001b4d85cbaf7so2681412pje.9
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=I97TBKC/A0lzYm9EyTPn+bNZHuyeg/4OQD1iS2bFokU=;
        b=Diz3M/ixEXmXl1TJVUtoJ/8drmR6UmZS/0Up/LHI/Tl7IeTBwPCb9fwNQFbgsp1jJ7
         dCNLqc2OpizZR22Z67B7iOOTVgNn6EJQS72LraPBAGLHppvogdQaIM5aUizSUh6Ea17o
         wxUaQ64ZW5ZHj182kdVZRN7+ApaZvcgfzpTV0qkibqV8omSysdq93BCea5PHM/jzS60y
         W6A7Kc8ZA3KMs2iPl3aklRi8kYsXlt9gAHsMtSfyl2yVRMnBkwkwzQaimkyO5ve4F1yd
         sR3hJ1woqT+BeCkFf/oDauJlEQ7MevxDG3heiraWUT5+n2bw7xs/49+rwAa3bCGbDHLz
         69ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=I97TBKC/A0lzYm9EyTPn+bNZHuyeg/4OQD1iS2bFokU=;
        b=a+ihaaw/FYkmrZM1fVy4eXT3fwPVZCzlbrL1M0sv8W87gpRPwNTZEyVeH9mowGtmM/
         ZZd6LwgxKowK/caK8MtYXKo8G795mr86EqXm3PAOKA96CAtzYr81Pz4q3HNCHtMlxJXY
         EjSle8nJjdVFEuWAUa7ygxMVqHniZimCa7yjY7uw/BlmwoUR2H76xKlzzGCfhY8X3lG+
         VSMH06GIDlvs7gRQ6B8dpaKR2GU9CrNzZnk9Ay/wXF34RGuQOD7XIfL140tArpN839Qw
         CjmCPN0i4Sit5QcJKlWIxfACJCwwXFDYNxyao62dC5pm/MoTba6A8kboGYA5OaxbrzVH
         MsFA==
X-Gm-Message-State: AOAM532J+QHTToJ/3bFH1+FNXJyoNN1uMrEOVAwKa36GcDp8qDm7C1L9
        eNaayF1YveY3YLMIdEqbkf3umn1A3Ys=
X-Google-Smtp-Source: ABdhPJx/fxMSR+nLX2SWcl3AxwUoej9VntUca9BeiBQI0SDJMoSiocmF8Hs/oCci/Iw1mQ3IYVnsS8qdls0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:22d1:b0:14b:3bbd:82df with SMTP id
 y17-20020a17090322d100b0014b3bbd82dfmr17533342plg.101.1643217752422; Wed, 26
 Jan 2022 09:22:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 26 Jan 2022 17:22:25 +0000
In-Reply-To: <20220126172226.2298529-1-seanjc@google.com>
Message-Id: <20220126172226.2298529-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220126172226.2298529-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 2/3] KVM: x86: Update vCPU's runtime CPUID on write to MSR_IA32_XSS
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Do a runtime CPUID update for a vCPU if MSR_IA32_XSS is written, as the
size in bytes of the XSAVE area is affected by the states enabled in XSS.

Fixes: 203000993de5 ("kvm: vmx: add MSR logic for XSAVES")
Cc: stable@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: split out as a separate patch, adjust Fixes tag]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c0727939684e..13793582f26d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3535,6 +3535,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~supported_xss)
 			return 1;
 		vcpu->arch.ia32_xss = data;
+		kvm_update_cpuid_runtime(vcpu);
 		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
-- 
2.35.0.rc0.227.g00780c9af4-goog

