Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C36C4979EE
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 09:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241979AbiAXIDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 03:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbiAXIDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 03:03:02 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF32C06173D;
        Mon, 24 Jan 2022 00:03:02 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so16005152pjp.0;
        Mon, 24 Jan 2022 00:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=heE4OVfXzjcbLsiS2jXpXXVHXoZTraF8TtJEtw/GvF8=;
        b=h2e7cQ1kaG27HENpOzrw7hG3ADVmrfXIOH4qnrpAXnwohkTaTC7ImFxUNLKqf9ybfe
         dvNYNCKiaWpMPIA6txMONOP4EN84EpiH3jl+yiilaetL1TeHsagy4b/1P49CSN2rPwrf
         bYHISh1CcZTiiOJr/cqsq21ROKJ3qwi/6X3gAbq7+Lk+/XXMvHYxR24Q4RMgHIabxrU+
         pLcVomuP+zYD4xqJgczTabCES7o8EO8OW55Kl0HTUXQN4HWW640MTZ7/6cR8Y/wYhLQ1
         SPGkEo8Sy3TAAPTGa+SIuBOXQUK5oXO0UqAUnJrPjIurxhdbZb8eU42poAULJa/w4p/B
         abZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=heE4OVfXzjcbLsiS2jXpXXVHXoZTraF8TtJEtw/GvF8=;
        b=A+MgnsqXzeGLRbcrYUtMzRGq7BWUGKziNGh4pmiUQdSlNZ4PcFNS7Ma/lF0EKS0Zz8
         Qh3MrWCgGN0Mfks3baaoyedNFnoj4/KG2y9cUcrOiTSDZwDgehmO/7Hw6SBCz3Wzyw/u
         3hHo13+mHCk7+8P/EKKf0D3KVLmBrZDJZ/SiMFDhU1YtGhvhJYfGVGaKyu6kkBtvUeko
         IOz9d0YnUJ7VGGokupD7Q2szu/pRelE5bAJ9BuqDs2162feopr8NrDJdpyxYdVnaocjW
         f3+GNn62w8B+bXyMwDp830Ap47J8XCvWZbo9lEqI5mc9gerF3vzTGv/L7aXARG1EXgGO
         6vOQ==
X-Gm-Message-State: AOAM533kqz/yGNDJUq5bIjSwFWLZ6Y0OcOYe+SSeMTjXaztDI1jkSzZ/
        5wX+XlKjm1TMVxTWkbUFXsQ=
X-Google-Smtp-Source: ABdhPJyP4yUgARzH2bzIdYRPXgwUA8v2dwGwEaBHGP5B4NCN5jPL5SztRTPNZZ9JjbPqC0vTZ1SOYg==
X-Received: by 2002:a17:90b:3503:: with SMTP id ls3mr755572pjb.127.1643011381508;
        Mon, 24 Jan 2022 00:03:01 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s1sm6505200pjn.42.2022.01.24.00.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:03:01 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tian Kevin <kevin.tian@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures sizes at KVM_GET_SUPPORTED_CPUID
Date:   Mon, 24 Jan 2022 16:02:51 +0800
Message-Id: <20220124080251.60558-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

With the help of xstate_get_guest_group_perm(), KVM can exclude unpermitted
xfeatures in cpuid.0xd.0.eax, in which case the corresponding xfeatures
sizes should also be matched to the permitted xfeatures.

Fixing this inconsistency by introducing a local variable with the same
name also helps to fix cpuid.0xd.1.ebx and later leaf-by-leaf queries.

Fixes: 445ecdf79be0 ("kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3902c28fb6cb..3dcd58a138a9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -887,12 +887,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		}
 		break;
 	case 0xd: {
-		u64 guest_perm = xstate_get_guest_group_perm();
+		u64 supported_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
 
-		entry->eax &= supported_xcr0 & guest_perm;
+		entry->eax &= supported_xcr0;
 		entry->ebx = xstate_required_size(supported_xcr0, false);
 		entry->ecx = entry->ebx;
-		entry->edx &= (supported_xcr0 & guest_perm) >> 32;
+		entry->edx &= supported_xcr0 >> 32;
 		if (!supported_xcr0)
 			break;
 
-- 
2.33.1

