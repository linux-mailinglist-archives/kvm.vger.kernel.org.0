Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADCA6F5BBE
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 18:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjECQIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 12:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjECQIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 12:08:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE2F6EB9
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 09:08:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9a7553f95dso10691474276.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 09:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683130127; x=1685722127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UpESMHY3dXiGunARd4Ma9HdMNvInCBKyCNCSaFRW6Ms=;
        b=wWTeQSe9JCCJ9pUvrrbudQKOTYO/i38kVcvsNhjPCCSRQyOR13ZqBKkCsMKvJO8ipA
         AUAokED4NY2vc/H9pYe41Pg+X5hIPEcIQpIJWr5NnqmigGPerJ3MtUKWbPYztN+VUJrr
         mnJUA/qxNDAR0r0LekD481sPNikHnSVY+cqmYJvxgd6hKMwNbcrUoOTlCKNA6uNMWSbE
         Q0BCvmEIiP24OXh3p2PhMIKcMV4Y4BqTZdm9ZSzMqEMhkrrlKNqVwXQ+sHqtsetsvlRc
         TZQdxlteiV2+NmkMidg9DbvStomj13XW9N1RgcA+4728Emo1iRtpcSbPxqfI6jxMZRnW
         JSqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683130127; x=1685722127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UpESMHY3dXiGunARd4Ma9HdMNvInCBKyCNCSaFRW6Ms=;
        b=XuDcws23rPTBfdmCFl2PxeWYDQqEXZExfQY7+2LskkOOqzYvxXdv/42Xu4tQFH3WT/
         84nlS60fGDWq615DBSTfGckzuntTgaSF1YejgyC5AZgSkGubyQGyNVDiBzO6HefnY8GB
         5G4Iobbi1x3zHPuVqyPHZQ/tFQmYIDYIGdpNHdc/qq03bRJx1Yx+7lexly/B8zcaoDbY
         l0fjnoq63j2hDuFSuPITB1GHFr/+WW00cYlPYlEzmcU4kqQQ745Gp92i9fCttnh6MXwG
         dAAwIDnaxyfQ/dA98tKQVxqQVPWuss51lz5xoHuOOuvefxiAUDwIsJ2EfEk/LozokGs5
         dhHg==
X-Gm-Message-State: AC+VfDycfidptBtUF04uBNL1p4EJZN0PSzOsbQki6w4F9VX3DGvgmlwo
        8wQZ+nVlAWzX+iQTzfyOsuxEJrHAPEQ=
X-Google-Smtp-Source: ACHHUZ7j5zBqK9ftbtMARRCXZsD6o77fHe+mRNhKP0knX56m2HlOhQ0cuPXd09xE5zp2sQBZS4Mv7o9IH9U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5e03:0:b0:b9e:91e0:ea0a with SMTP id
 s3-20020a255e03000000b00b9e91e0ea0amr2705234ybb.13.1683130127369; Wed, 03 May
 2023 09:08:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 09:08:38 -0700
In-Reply-To: <20230503160838.3412617-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230503160838.3412617-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503160838.3412617-4-seanjc@google.com>
Subject: [PATCH v2 3/3] KVM: x86: Open code supported XCR0 calculation in kvm_vcpu_after_set_cpuid()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
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

Drop cpuid_get_supported_xcr0() now that its bastardized usage in
__kvm_update_cpuid_runtime() is gone, and open code the logic in its sole
caller, kvm_vcpu_after_set_cpuid().

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0c9660a07b23..491c88e196c1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -234,21 +234,6 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
-/*
- * Calculate guest's supported XCR0 taking into account guest CPUID data and
- * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
- */
-static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
-{
-	struct kvm_cpuid_entry2 *best;
-
-	best = cpuid_entry2_find(entries, nent, 0xd, 0);
-	if (!best)
-		return 0;
-
-	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
-}
-
 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
 				       int nent)
 {
@@ -323,8 +308,16 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	vcpu->arch.guest_supported_xcr0 =
-		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+	/*
+	 * Calculate guest's supported XCR0 taking into account guest CPUID data and
+	 * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
+	 */
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
+	if (!best)
+		vcpu->arch.guest_supported_xcr0 = 0;
+	else
+		vcpu->arch.guest_supported_xcr0 = (best->eax | ((u64)best->edx << 32)) &
+						  kvm_caps.supported_xcr0;
 
 	/*
 	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
-- 
2.40.1.495.gc816e09b53d-goog

