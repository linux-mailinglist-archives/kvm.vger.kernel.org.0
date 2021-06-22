Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926393B0C1B
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhFVSCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbhFVSBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:01:39 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D866FC061756
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:44 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id m133-20020a37a38b0000b02903adaf1dd081so18977099qke.14
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SZ7EFM9JvxBFqeMOjL2/OIpnWNqEz9RcVmiKiiKZNTY=;
        b=qLd9EwwFXb6FlFuWBAbTj9GBDlYyWOUYlj7xXUfYrRNa1WNb1VndejiYUmHmszayUu
         vJJNYvBjPoVKSI9+0sHO8/Cqwkw+WQnXFw8jIRwzbWs1pnog36jxsR633uO8zyYVEQqt
         ZAA+9MbxgZNqSfXTBMxOL6rfQsdAC51ZTotDfDbR6QuUfChyS66PkYaNZREVoQdW5lG1
         brykcQiDN9fo+LDwtBFz7mn2gQHQWZXj0RYrRz7FGERQH39ISxKIkmAJwg78cZe2fa+k
         74DFnA7zYx5DjRgs6h537i/+T6yfDoRqE/TW+rS6bz53Zoy/A3o5oGOUbVJtkNMqhP3O
         kl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SZ7EFM9JvxBFqeMOjL2/OIpnWNqEz9RcVmiKiiKZNTY=;
        b=SxMJeu53ECIK9FPAXhUvBpsIqSqlZ78ZcWFiAEPChyFbedD3fBYMQEAaaJP/wdVhyN
         Ag9ERRYNKqf6ogwpM9mX/xjNsvl4emygAEiXln86GXY6peKHp35M1guSBvobf95zdm6b
         OvnXy2O8i9YMSmh9PKc+1yXJDiPdNx6cJYYeWKUmhB2MMrGiVPVc6OeKLVPwAQ8MtCeN
         qLHFWOo8MVwUw/b7eT4aB0SvWLLrvEn4696HpoInR43NaVIC8N420LOPmIXi4HXswPIt
         qVvf7YaUyfOvJTwx/rnVRv9qU1F0oK+aofIuHdxBkxplJNcFi5y8zfSvyaZiNe1wRh1m
         SVQA==
X-Gm-Message-State: AOAM533m+a2KkHHhigYia2v5v5uMxmfS5adT/xGFFSUsL82dj2cRmfe2
        kUrm0I/zHSBYwmQ/7MLPNMZNljQhsfA=
X-Google-Smtp-Source: ABdhPJzkmP9nVcrzjn2llOniRu5uCh+stueauR2gXAVRn8bXGp699Eu7y8ow4WveZhwE3t7uNzL18eo8JOM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:ad4:5004:: with SMTP id s4mr21522qvo.8.1624384724058;
 Tue, 22 Jun 2021 10:58:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:06 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-22-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 21/54] KVM: x86/mmu: Consolidate misc updates into shadow_mmu_init_context()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate the MMU metadata update calls to deduplicate code, and to
prep for future cleanup.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3616c3b7618e..241408e6576d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4507,11 +4507,6 @@ static void paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->nx = is_nx(vcpu);
 	context->root_level = root_level;
 
-	reset_rsvds_bits_mask(vcpu, context);
-	update_permission_bitmask(vcpu, context, false);
-	update_pkru_bitmask(vcpu, context, false);
-	update_last_nonleaf_level(vcpu, context);
-
 	MMU_WARN_ON(!is_pae(vcpu));
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
@@ -4534,12 +4529,6 @@ static void paging32_init_context(struct kvm_vcpu *vcpu,
 {
 	context->nx = false;
 	context->root_level = PT32_ROOT_LEVEL;
-
-	reset_rsvds_bits_mask(vcpu, context);
-	update_permission_bitmask(vcpu, context, false);
-	update_pkru_bitmask(vcpu, context, false);
-	update_last_nonleaf_level(vcpu, context);
-
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
@@ -4703,6 +4692,12 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	else
 		paging32_init_context(vcpu, context);
 
+	if (____is_cr0_pg(regs)) {
+		reset_rsvds_bits_mask(vcpu, context);
+		update_permission_bitmask(vcpu, context, false);
+		update_pkru_bitmask(vcpu, context, false);
+		update_last_nonleaf_level(vcpu, context);
+	}
 	context->shadow_root_level = new_role.base.level;
 
 	context->mmu_role.as_u64 = new_role.as_u64;
-- 
2.32.0.288.g62a8d224e6-goog

