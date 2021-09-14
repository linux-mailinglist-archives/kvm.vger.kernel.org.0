Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3987D40BC08
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhINXKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 19:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhINXKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 19:10:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200BAC0613BC
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 16:08:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a23-20020a25ae17000000b005ad73346312so984305ybj.18
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 16:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Kb4RIrU35lN+tPmwsgBaQo7Uv7rFiX3GXXf8rcFZQTw=;
        b=ENSKM5WbOnYjx/ds/KccT7z4pBTRJTWdCgEbYzGw5T8KtwsZwrC29Xmv2SXMhRoaPf
         l4iBm0/agX03hp6Xd+TdfwSZcaXreaLMBNy0GzeMIeWD+iyFdMBpX03FJx//1K0Z0DfX
         Bq0MsI6ZQrUsHJFfKvADUnbh5LCVGsiCA7HNLNx3wO5hvmRNK9qn8kovJVp+Y27XQrS3
         jwWekIWJ7b8YjFKx/VJTLlNZ1iaUHcC0rotSRBWuagcVxKClOsw3GBtt6DcLDP3Epg2+
         WzSaLthJP2u02Eq+QAws0TPf+isx3ihQ2ZDmXHg/9bZ9oG3UvnRGgnVOoF4EP+20uyct
         PneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Kb4RIrU35lN+tPmwsgBaQo7Uv7rFiX3GXXf8rcFZQTw=;
        b=sf7riYt5uIs/5+9hPub570QeYAHwm3I8J1cMF6ovjZOYJB4MqS6lqg7Kwo9seRlDLV
         6SOtEtFiSw/d4ZOUkKZw/v9+Z2dhb2Se4kiqRtsTxq6HzNy0ngCDrJxFg9RcL+Ro6+5t
         TB3PTQgjGIHOXVlP54vHvKo2Bk/IHGAUiGhpTn395pErzqJFcc1wb5QYhYfCrgUy6y+r
         oNm/FZgi2YXZAnvwHcSdGv6BtePk2zqr+j+lWXzSLwfPIrH9gDdzY/bv++LKX2A8b4eK
         whEE7hmu6+wnZxhk9WXE+K26q+bMsKYtwSJLUSRwt3NDLlsC+RYat1Y9+MrisXwDDIrz
         YBMQ==
X-Gm-Message-State: AOAM532uU5LnK75v6VAs1u/aW6LGL05dvB7G3kzvu/xMhoxTD4eh7eB3
        Y+pGcg2pGedwuHcA7DwXzi315YP1ffw=
X-Google-Smtp-Source: ABdhPJwPxxyO6jpT2L9j4gJKZpd98VUb4RcOHs7Auq/lkyVAkKhP514ZWGtkjcd0OXhZuXlYWREzVmHknbE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:d59f:9874:e5e5:256b])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1005:: with SMTP id
 w5mr2151354ybt.330.1631660926348; Tue, 14 Sep 2021 16:08:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Sep 2021 16:08:38 -0700
In-Reply-To: <20210914230840.3030620-1-seanjc@google.com>
Message-Id: <20210914230840.3030620-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210914230840.3030620-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 1/3] KVM: VMX: Drop explicit zeroing of MSR guest values at
 vCPU creation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't zero out user return and nested MSRs during vCPU creation, and
instead rely on vcpu_vmx being zero-allocated.  Explicitly zeroing MSRs
is not wrong, and is in fact necessary if KVM ever emulates vCPU RESET
outside of vCPU creation, but zeroing only a subset of MSRs is confusing.

Poking directly into KVM's backing is also undesirable in that it doesn't
scale and is error prone.  Ideally KVM would have a common RESET path for
all MSRs, e.g. by expanding kvm_set_msr(), which would obviate the need
for this out-of-bad code (to support standalone RESET).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..dc274b4c9912 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6818,10 +6818,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vpid;
 	}
 
-	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
-		vmx->guest_uret_msrs[i].data = 0;
+	for (i = 0; i < kvm_nr_uret_msrs; ++i)
 		vmx->guest_uret_msrs[i].mask = -1ull;
-	}
 	if (boot_cpu_has(X86_FEATURE_RTM)) {
 		/*
 		 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID interception.
@@ -6878,8 +6876,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	if (nested)
 		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
-	else
-		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
 
-- 
2.33.0.309.g3052b89438-goog

