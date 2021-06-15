Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EE83A86C9
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 18:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhFOQrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 12:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhFOQrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 12:47:48 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9350BC06175F
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:45:43 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id m18-20020a05622a1192b0290247a89f63bcso9734292qtk.20
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=q3P2hFib2jpFATPVZZc6kpE2m6ZHbOchUFmf4rcGTJU=;
        b=NR3+vlBE8MV8LIYTXQWwVO9IgolxJeQ66Rxjh4Y+pfSdLn8FiGfX8uYYepU9rUu6K8
         GzTfgOsj3DFrduJ7Plzfkm5nF1NkL0pLsHBXg115JYKj9mYt+QvPKPfXrNADBPt4tTNx
         4bHw0efPACjENsaiDLPlYt6ang+brClpJdXJNqNQii1DPJfUDtzLP3baZL9T+KauqqL9
         uQVJXqRpkNRnjwD2eg9lv1O9c5Ou6gxWmdZSj3jhRBaWhqySEGfAR29CK3avwOJWo45C
         938qfqwzQkR2pPtyq2bCP0oehY+dG0dJ1BBuBZfVs7D47C2yx14w7BkJapWjsPvuBfX5
         3ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=q3P2hFib2jpFATPVZZc6kpE2m6ZHbOchUFmf4rcGTJU=;
        b=GohzExF+hTpuxLa7OK/sxbpMVj8D1xWnKo0SRf7lSy1jtZ5HvDjf4KqT4S2Ihv/DV8
         jLi9+6aYEbTgRePiuWM8rT8oThFoQs4aD3+4jRwJ/X9CMmMszM1pyDJGL0k0CJd/Xjj/
         2FBWUAqCVPoTk68IYoZygISXoclR57nlWGUoebQO7V23ri6QBEa7VgUjtz+AUbsbCbi2
         xL2RpCA3W+FfDJ9sh5ndEbfjz71RkKpELO+CHfIf4utBzaS9vmye9VCwH+UJQYZU4hMq
         2OrCTbNCiXVTGo5pZuHZgIoEQdw+pw5ASHLTKy42RBBaC9/EH7R4XZA/MhOPTHt9Dafa
         9lYg==
X-Gm-Message-State: AOAM531BtlBnWnhienGnbPqRv+FTzmaj7AWtlNVpq5pRxmTaqb3jMdit
        ecv1f9LMjdphdIaEyyUQuDUbLTrKrMk=
X-Google-Smtp-Source: ABdhPJzqaHyxI/TSJAyMGN3GxZl96HGepxQ/3rBmX2mIi9MZXIXtFgMeWrS+Ykh3ttIBeLkb6VWSV0z9iSQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:13fc:a8bd:9d6b:e5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:c6b:: with SMTP id
 t11mr5876044qvj.31.1623775542745; Tue, 15 Jun 2021 09:45:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Jun 2021 09:45:33 -0700
In-Reply-To: <20210615164535.2146172-1-seanjc@google.com>
Message-Id: <20210615164535.2146172-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210615164535.2146172-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 2/4] KVM: SVM: Refuse to load kvm_amd if NX support is not available
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

Refuse to load KVM if NX support is not available.  Shadow paging has
assumed NX support since commit 9167ab799362 ("KVM: vmx, svm: always run
with EFER.NXE=1 when shadow paging is active"), and NPT has assumed NX
support since commit b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation").
While the NX huge pages mitigation should not be enabled by default for
AMD CPUs, it can be turned on by userspace at will.

Unlike Intel CPUs, AMD does not provide a way for firmware to disable NX
support, and Linux always sets EFER.NX=1 if it is supported.  Given that
it's extremely unlikely that a CPU supports NPT but not NX, making NX a
formal requirement is far simpler than adding requirements to the
mitigation flow.

Fixes: 9167ab799362 ("KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active")
Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b6afa6b63c8f..12c06ea28f5c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -952,6 +952,16 @@ static __init int svm_hardware_setup(void)
 	int r;
 	unsigned int order = get_order(IOPM_SIZE);
 
+	/*
+	 * NX is required for shadow paging and for NPT if the NX huge pages
+	 * mitigation is enabled.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_NX)) {
+		pr_err_ratelimited("NX (Execute Disable) not supported\n");
+		return -EOPNOTSUPP;
+	}
+	kvm_enable_efer_bits(EFER_NX);
+
 	iopm_pages = alloc_pages(GFP_KERNEL, order);
 
 	if (!iopm_pages)
@@ -965,9 +975,6 @@ static __init int svm_hardware_setup(void)
 
 	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
 
-	if (boot_cpu_has(X86_FEATURE_NX))
-		kvm_enable_efer_bits(EFER_NX);
-
 	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
 		kvm_enable_efer_bits(EFER_FFXSR);
 
-- 
2.32.0.272.g935e593368-goog

