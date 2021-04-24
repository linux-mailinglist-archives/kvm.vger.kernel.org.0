Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA21369E3A
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244187AbhDXAzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244674AbhDXAyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:54:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42682C0612A7
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s34-20020a252d620000b02904e34d3a48abso26210576ybe.13
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cHlwUSJUjHnQJ6kDK9sfUkfBgeAVcW+1jr4rnQYo1Ko=;
        b=fumK39euhhCQk2484+Hwff7kn91tSshSd9Oao+wPZHIv/x6YICMBz2CGSs2lqBhgJo
         RRSVdlnliIu3d5znNnEiGxMnWYvfq0A+0gfcvNZaz2ejSvhpOSfYlP7nXCW0tMkPei7y
         IA9nlGv4r/dckLaQYT/H5SYXrYoxyPPLLYB2oTteq7Em6/H4stXp2fzofJ0qBVGHDXco
         QeTDQrA9HBw0K2njlFLzyx6OyFGmgcb04pshJi/ZCdb3p9rSFhHVLTSP8LDexL1A1Cl5
         wAJ2sdlqS2/P73F1uOHSYq45NGO+BN133HuQg0l52L/Tgdm81DVYlynl3j3zWGy/4+qS
         uPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cHlwUSJUjHnQJ6kDK9sfUkfBgeAVcW+1jr4rnQYo1Ko=;
        b=WDbsiaTcnMZ3SgovGBcYNX/bkLLFBAOWfrV3NejRgHg/Qddo0eOfabok8ImjqAPFep
         DMKwzu503fV9IoIlWyRAtAgNikHpC3Ypmtdkmv2GtpjRniChdKdkEdMDR12LGEFFVZsM
         YLzT/DSbmLfE+E5nH/OmuYY6o7COAux4lalEnhuLtOaSH2wmqJJa/VP/2iAQUk0/mqCb
         YPlq++W7H6JiRif3HSXQ63MFBLRgZGpP1M1k5XUIHAsnKxDDg1OU1sMvLi1zy2BOEiUy
         qUl8UIRnNWv2TnxAX/7aDyGIhBU0x3eT1T+Sba35G+j8wp/QkRnOz9fbigIlBElHyAQK
         qz/w==
X-Gm-Message-State: AOAM530qxbjDepYL9zfiYyb+y/xYpgoKnygrVPUV0UzXKGGXKzirQmF6
        VHjn3uYfTwKasOihR0M234i5wFi0QrE=
X-Google-Smtp-Source: ABdhPJywoeVodiv4R9BqMCGeljzHV7ruPDnZWCAYDPfKq7hCQsoy3MFsMAmsat+0vbkVlsG6vvps6QRMv4Y=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:4bc6:: with SMTP id y189mr9589994yba.14.1619225306532;
 Fri, 23 Apr 2021 17:48:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:41 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-40-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 39/43] KVM: VMX: Remove unnecessary initialization of msr_bitmap_mode
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

Don't bother initializing msr_bitmap_mode to 0, all of struct vcpu_vmx is
zero initialized.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index beaf9fefddad..cfd986aae7b7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6982,7 +6982,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
-	vmx->msr_bitmap_mode = 0;
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

