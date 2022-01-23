Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27635497042
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 06:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbiAWFuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 00:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiAWFug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jan 2022 00:50:36 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E55AC06173B;
        Sat, 22 Jan 2022 21:50:36 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id u10so8232482pfg.10;
        Sat, 22 Jan 2022 21:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VC+au0p/0264rLSy2tjWxRamXhLbDclhx0GW2hJ1SB8=;
        b=JgSQcWrPgPhAWoJbHVwKdXb19alZdAg1LDjFSFiLyN+M0UnvCjDRoRfL3f4Ohbw0Z/
         N1bzhQcxkMhPE0OgXgbeHC+Tujt8E3D57IwL0p5wIizdvRqFpo6lSltn2gJf5M3p5vRv
         cgNYQh1Nfvg3j9KJJiEuz8UqTE6AVVaUEJdFTNiCUDmyw7AB5fFvH2Ov0wpPubzB1ED0
         lrRa6snl3pyWmsm1D3jYhYfgZHUXN/ul42/VQGQlaVTLrq28PalECa4kMA54kT6MRsRH
         qTxiR6lU39rPpOJUWqWQF3eBy0MW2zztBeRe9F1GlHYwQ6YfojtcgPuK6Rjg/fV/9j9R
         xvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VC+au0p/0264rLSy2tjWxRamXhLbDclhx0GW2hJ1SB8=;
        b=eVgiivBvcJ2048I7vsvZtTzl/OfX1EgvaIbkKEK1KJVlOy2dVlqFiD6XlBM/xmanES
         5wwz3dWTEZfg6l9grADjYGDzp5+mL60hmFt2bwKnue1DDVonBC2PaDipqajqz67UBp4g
         Jzn4XDodrjUSTh3w/AFKAT4cG+Qt9jx4BUrfcNUGWiTXiASBZ6HFI+dxcGDxY5vRKIAR
         DvROY6WWVX48tMG5mHiQ2M3Snx0Q7taafRpfOdpyJlegkA4HouY3/CTKxQb9J3rUyYWz
         2GxQ9TYRS3LKZjQ7w3MXMrui/5+asHm20ihx0rGfQX0fuuWBizuypVYmJk4tjXPcRXd8
         j1+g==
X-Gm-Message-State: AOAM530b0jX/FVMx6gjwubhblsjysdogYIUp36r84kyXBJzbJh5PA4d7
        EMHSIrkBwaQHgnGaBuYnbPVESdF2vggxjA==
X-Google-Smtp-Source: ABdhPJxMjHfL9c5UtJumDzxk7MrUHTaz2wUMkfRerIdqotNbqHQ2mRydvVOFX/gZ4hWrL7K57pRC/g==
X-Received: by 2002:a63:c009:: with SMTP id h9mr7897491pgg.36.1642917035537;
        Sat, 22 Jan 2022 21:50:35 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g8sm11492760pfc.57.2022.01.22.21.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 21:50:35 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jing Liu <jing2.liu@intel.com>, Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for vcpu->arch.guest_supported_xcr0
Date:   Sun, 23 Jan 2022 13:50:25 +0800
Message-Id: <20220123055025.81342-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

A malicious user space can bypass xstate_get_guest_group_perm() in the
KVM_GET_SUPPORTED_CPUID mechanism and obtain unpermitted xfeatures,
since the validity check of xcr0 depends only on guest_supported_xcr0.

Fixes: 445ecdf79be0 ("kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3902c28fb6cb..1bd4d560cbdd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -266,7 +266,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_supported_xcr0 = 0;
 	else
 		vcpu->arch.guest_supported_xcr0 =
-			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+			(best->eax | ((u64)best->edx << 32)) &
+			(supported_xcr0 & xstate_get_guest_group_perm());
 
 	/*
 	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1) enumerate
-- 
2.33.1

