Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D156D8B31
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjDEXqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbjDEXqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:46:05 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AE876A6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:46:03 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54be7584b28so56442437b3.16
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680738362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0eLsdRSWRS14XpdXI5Oe0msGImkWJM9UiPZLdHxJ9wo=;
        b=ZzdivL5RkQKVveq4bXKtR9D8nwwhzP80YxQP/yYQDaIHyF6AVChFfUxn0gCL6GEd4r
         wl6WXiTj/vpKn0EDm31ZR6Ob/4bXPB2JsoGngpHGCl9nkdU2cKIzeRI1SBL3Y3y9id71
         Ba+DE2lW3kItrlyVzDFtsKmbp4bdsroFLmMCtfjAG92KcAIjJ1XvcfAGcAFx+cHKGiE1
         99z7Ad2NSoslbBS6JIHPXeEZqECo7mfVPVVYwK3TDjh2U3sJSAjuzv+sRN31/3v233B7
         6y1F7FKudKtQJpJQ/SjeKY0ro6NhQBdPgAtm0DfOHnaRZ6hENZwDxaocyuk661beWb4P
         yyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680738362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0eLsdRSWRS14XpdXI5Oe0msGImkWJM9UiPZLdHxJ9wo=;
        b=ayXMgoI237C+0ZPd1NgDjirNWHVFEjEt4tuCojYo4ksQQUURHF/i8ec2pNGIV5trwy
         lGNTH4RUIhCtj+OD1f8HE4Tdrzt+aJncBZxFrnh5ueyqtgU7U7PlRHTaVi5mJWhe1OG1
         wn7whPtddDlAKmuOfnUIGjocb+Kwr5MCcwj+NJXY8S6YgbK+quoPPenlTtXNBrIoMsgw
         n4zec0wdLG+0BHpDfSx01vTVupL/50uCsdaTjaimCkDpX1rHd15Ws306C57yJ5GKqnbS
         jBZ1bZsLx4j/S+fZNTKNjhsr8Eqv/bzLx57ncYQe2bShz8eqbak/Djv4JGMZfhUfJ9Cc
         gO7g==
X-Gm-Message-State: AAQBX9cR5qIu2Acs/Pf14wnDL9eyVtobe/AbXtzqY8WSwKH6bpv5Sn4B
        ZTDbz3D/zcSoQo587Ljioj7fK085s1w=
X-Google-Smtp-Source: AKy350a+d6/a4DkxvrL/rpRYD6LS9nKcyFhck7ZSGe8DaW4EwM+NZaQuU8uHQp0KPVCKlz9EOKXwXEp+lQs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:714:b0:54c:88:64a1 with SMTP id
 bs20-20020a05690c071400b0054c008864a1mr1349340ywb.0.1680738362747; Wed, 05
 Apr 2023 16:46:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 16:45:56 -0700
In-Reply-To: <20230405234556.696927-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405234556.696927-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405234556.696927-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs are unsupported
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Intel's SDM, unsupported ENCLS leafs result in a #GP, not a #UD.
SGX1 is a special snowflake as the SGX1 flag is used by the CPU as a
"soft" disable, e.g. if software disables machine check reporting, i.e.
having SGX but not SGX1 is effectively "SGX completely unsupported" and
and thus #UDs.

Fixes: 9798adbc04cf ("KVM: VMX: Frame in ENCLS handler for SGX virtualization")
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/sgx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index f881f6ff6408..1c092ab89c33 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -350,11 +350,12 @@ static int handle_encls_einit(struct kvm_vcpu *vcpu)
 
 static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
 {
-	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX))
-		return false;
-
+	/*
+	 * ENCLS #UDs if SGX1 isn't supported, i.e. this point will be reached
+	 * if and only if the SGX1 leafs are enabled.
+	 */
 	if (leaf >= ECREATE && leaf <= ETRACK)
-		return guest_cpuid_has(vcpu, X86_FEATURE_SGX1);
+		return true;
 
 	if (leaf >= EAUG && leaf <= EMODT)
 		return guest_cpuid_has(vcpu, X86_FEATURE_SGX2);
@@ -373,9 +374,11 @@ int handle_encls(struct kvm_vcpu *vcpu)
 {
 	u32 leaf = (u32)kvm_rax_read(vcpu);
 
-	if (!encls_leaf_enabled_in_guest(vcpu, leaf)) {
+	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
+	    !guest_cpuid_has(vcpu, X86_FEATURE_SGX1)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
-	} else if (!sgx_enabled_in_guest_bios(vcpu) || !is_paging(vcpu)) {
+	} else if (!encls_leaf_enabled_in_guest(vcpu, leaf) ||
+		   !sgx_enabled_in_guest_bios(vcpu) || !is_paging(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
 	} else {
 		if (leaf == ECREATE)
-- 
2.40.0.348.gf938b09366-goog

