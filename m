Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FBE3A86C8
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 18:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhFOQrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 12:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhFOQrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 12:47:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0EAC061574
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:45:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a17-20020a5b09110000b0290547160c87c9so20692086ybq.19
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KoATQjf1bqJX5+Cn3Pm5jquL1TOAr2SZYGD15c6rjGI=;
        b=i8b5Rxvb8TY33lBOb2tS3EkwWuF2Wot9rZRAyYQvgF4is7spcEvT+E5xX5qaHgplJf
         /oTkbqp2GWi259MVdZkiunqm3ZPf82XNW4yuibpf5bLVsr0a2vQhhsme5la0C0mDQAKz
         e/RqVpQ8qUz0vPJ5h4OI00Smty6GASYEiG0FLschtY50a7SX3NiuUFy/8hIhvz0RG4FW
         kVAe10AFzCivihB9+pV4MUUK3HfPwG6om1vCKbVpYOFQZX7liv6ripc1aRM84Ux/9cMM
         w1wetKMj68BHuEyHzsSmgXKHgPsxk7tLs6JxNmV02iOk3ZrOxwoeO7sHWKJBVl9brvfd
         /Bpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KoATQjf1bqJX5+Cn3Pm5jquL1TOAr2SZYGD15c6rjGI=;
        b=dL1KtxVtNYWuZ26By+9kWt95RF7qEIaY6LnA+vvuwndDN7ALlVi9gTCi2dlIhwLvPA
         wK+1azRhubLa+So5NVsbJ6LUzCFszvC5fwPsUnhvmsseqwNDs0wPQ+SYgN3owkhpD99Q
         mRJwlUYuqxgsF4X/Xe08MSqkbEmKVEbgO0MGZAd/HoYUW1gDsv499CUa4haNZSBcLZv4
         SksQAcQ0RMdFHi53Rzvp8uU4QsMsqOBoHoE7a0MqRG3g7tyuURQY/2AzTNkykNTOrYfP
         gssJTek8fVFscmuJt828AMaL20jXxE7H6n6e8bEnE2/RLel7amV4CzszaX+2i8iweE/Z
         v76g==
X-Gm-Message-State: AOAM5336vpxOi968bCyljP2ux4Rt44dV4U9Uk+oSFaS23AO6FZRq49Jg
        fk/nNtPWE1t/e+O8efzBBVZM8k8QN8g=
X-Google-Smtp-Source: ABdhPJzMuxBn6CbXj7dqEDl/F6v5foDuq6XtTIS9K1vgrOxspUwq2OsoSvuLlfBrfAomFRe15lFYc5UdzeA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:13fc:a8bd:9d6b:e5])
 (user=seanjc job=sendgmr) by 2002:a25:dc8f:: with SMTP id y137mr108064ybe.248.1623775540537;
 Tue, 15 Jun 2021 09:45:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Jun 2021 09:45:32 -0700
In-Reply-To: <20210615164535.2146172-1-seanjc@google.com>
Message-Id: <20210615164535.2146172-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210615164535.2146172-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 1/4] KVM: VMX: Refuse to load kvm_intel if EPT and NX are disabled
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

Refuse to load KVM if NX support is not available and EPT is not enabled.
Shadow paging has assumed NX support since commit 9167ab799362 ("KVM:
vmx, svm: always run with EFER.NXE=1 when shadow paging is active"), so
for all intents and purposes this has been a de facto requirement for
over a year.

Do not require NX support if EPT is enabled purely because Intel CPUs let
firmware disable NX support via MSR_IA32_MISC_ENABLES.  If not for that,
VMX (and KVM as a whole) could require NX support with minimal risk to
breaking userspace.

Fixes: 9167ab799362 ("KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 68a72c80bd3f..889e83f71235 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7723,6 +7723,12 @@ static __init int hardware_setup(void)
 	    !cpu_has_vmx_invept_global())
 		enable_ept = 0;
 
+	/* NX support is required for shadow paging. */
+	if (!enable_ept && !boot_cpu_has(X86_FEATURE_NX)) {
+		pr_err_ratelimited("kvm: NX (Execute Disable) not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
 		enable_ept_ad_bits = 0;
 
-- 
2.32.0.272.g935e593368-goog

