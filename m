Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7397D4354
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 01:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjJWXkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 19:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjJWXkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 19:40:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E75D73
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d99ec34829aso4552233276.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698104409; x=1698709209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ncl3FNsJPI8hbq8cXsw5giqcYGS/9dRNgfVScKM3w+8=;
        b=yeeyb2VUbRC6r8+YnM933njw2wWKCNaYXJlvdtAaMjBumtjXFJ2M8DWsK1Vg1MwJ3K
         of4zsWTQOaBWpSr+Fsh4XGmIQoD1b01zl6U0SvlvzBMF4k+fxT0W/S/x3yDv6AvjV1dV
         9UYNXThheTPDfat+5BBDkQ7AD3PfeZ3szkxbfFFRriwBsI3klBK7RXLDf8LkyXq6brms
         9HHL+qDX2LT9NBL5W91rFXpANPLz2HoR4x2T39Cx5qlBjLXXaD47mPDnbBHRSlXO+Xfk
         uDc4MfXDkxBGndLs6ZKgzi6Q/BsD+BIJNbpfLfBV+kxW1rRPnnz2sAaRPPriPq8bJOoD
         qd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698104409; x=1698709209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ncl3FNsJPI8hbq8cXsw5giqcYGS/9dRNgfVScKM3w+8=;
        b=ZwQszMNmueqRg3xuX3az5G4NQMI6/wREKm9ivbwGjLrpuogPEOirXzImImtWCGdtFS
         /2sUuwenByz+ZsjnbtlBKNinP/mC8K8r3Gz8uVUWkoJeh77BH6ADgl/b+UNgxM4U1swN
         em1coHHC8WKDz4aq1c7bAdpzUG0IVcL01N2YyTj3MERFzmNo2yP2pfA0SxCEzcBwSIfE
         ZKwRdz9g4vEahtW7j/h27Cmt0g+P2xClzy8SPwiHLFDrmxFVy9+ZCas8+V1b/MXWXVqD
         nRtG1wioHpPktfZK+CbddjM50Lv7mZ1GzmOyY/x0saZltrBe1ky0THwitTDjC2pKm0ac
         qPhg==
X-Gm-Message-State: AOJu0YwnT6J9oRwF5slxyurVIx57kRXZufUDiqj1aYGw/AwqSSfhwJD3
        PBRNGN+i5L0+L/vzTOSRTlTDeZcrHWk=
X-Google-Smtp-Source: AGHT+IHkfZjGTo7iBRDmhKCATqJxU/ld84g8TFcJVjoXQahO7z2ttVEHXNfjaiCEHYf4ft9kRqJ37KV49N8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:c3b8:4274 with SMTP id
 v3-20020a056902108300b00d9ac3b84274mr279845ybu.7.1698104409129; Mon, 23 Oct
 2023 16:40:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 16:39:57 -0700
In-Reply-To: <20231023234000.2499267-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023234000.2499267-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023234000.2499267-4-seanjc@google.com>
Subject: [PATCH 3/6] KVM: x86/pmu: Stop calling kvm_pmu_reset() at RESET (it's redundant)
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Jim Mattson <jmattson@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_vcpu_reset()'s call to kvm_pmu_reset(), the call is performed
only for RESET, which is really just the same thing as vCPU creation,
and kvm_arch_vcpu_create() *just* called kvm_pmu_init(), i.e. there can't
possibly be any work to do.

Unlike Intel, AMD's amd_pmu_refresh() does fill all_valid_pmc_idx even if
guest CPUID is empty, but everything that is at all dynamic is guaranteed
to be '0'/NULL, e.g. it should be impossible for KVM to have already
created a perf event.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 2 +-
 arch/x86/kvm/pmu.h | 1 -
 arch/x86/kvm/x86.c | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index dc8e8e907cfb..458e836c6efe 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -657,7 +657,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
-void kvm_pmu_reset(struct kvm_vcpu *vcpu)
+static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a46aa9b25150..db9a12c0a2ef 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -243,7 +243,6 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
-void kvm_pmu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c9686207996..c8ac83a7764e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12207,7 +12207,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	}
 
 	if (!init_event) {
-		kvm_pmu_reset(vcpu);
 		vcpu->arch.smbase = 0x30000;
 
 		vcpu->arch.msr_misc_features_enables = 0;
-- 
2.42.0.758.gaed0368e0e-goog

