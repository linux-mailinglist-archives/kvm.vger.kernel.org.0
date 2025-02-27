Return-Path: <kvm+bounces-39467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 531A4A47166
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37A0316CA58
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6EA22E413;
	Thu, 27 Feb 2025 01:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="27shFyFa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1D622DF81
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619559; cv=none; b=OqugKevDbZW0ceONdR8OaAn4H2W4gJ8K5wgN2sXelVBoQjSa+iYGCEfX2l8o/63DPocgTRZ4I1fYCwhiaDDO6ttlFuiPHRC82oYhPJH94y3l/pMq70plBlq87f72M09jC8HQy2kei14rg4fJ/Kfqf5IWZyB6xNmjAhBAGNlGr1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619559; c=relaxed/simple;
	bh=3rMdxdgx2qWe5YUgeEwNff8fTKobVmh249Xk/BEEAbw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V/p3CGKVvUxTeBhEh7hcYNaA+rNI2d7l3fiwgLj4OapHPMAz+1E4nd2oBnKK7ffLdoX7kB3RIqKDqO+h6g5B5zZrMyKs9Yeb5tWTw+YSPd1O7m+gYLWShodEAJFQXZGPFzvNVWsj4cBMfckIjB2HCU9O3OP/ovMSSZT0Kb0gYQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=27shFyFa; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2234c09241fso10834255ad.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619557; x=1741224357; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lmdAwPEyCZdB0cvoeTHRqa3iDsz832lsztWM5iTizzQ=;
        b=27shFyFa7us91YMSdCLNQFswgRfPh3a60qe4ZSGaUmrTexGUEHhGJq9E7wpAcy0A3X
         CWumEerMK5luUsBakwMWHBMPujn4G1dFkx47+CO8YM0keftCapeTcH5BfeQyEwLg54Qs
         RvsF1mAC1xFrU5YNtOTkRoNDTVbc9bx81Xc123nvzwvAwzuikUqBgWYNMrRF8muYqE3e
         d67MMFx4zJkbTmibnG40wwRlPYEqM6smB5aaaIJctBJon8vS9qAcfiSA+esPa9ULN+86
         f4GdKWzXV4aTA7YH7PvIP0xLgaUmWiJnVjV9coFVdA5WfUajXLBPa0LD1rZbk8k8e1VM
         YpLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619557; x=1741224357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmdAwPEyCZdB0cvoeTHRqa3iDsz832lsztWM5iTizzQ=;
        b=D2DDmkpNMgtAGrfQFxX0pNG2ggBluldydhXM/KT2KuCwSuLMIVsVehPm/z/0U8K5k2
         b+vyHvLgDks3j1ezEiGQsQW2EtSOr9cp4/ScpU92sSW1TLFiatQSEs4da/+xi5wC1fub
         SSYYyrbXGLMb4Kkjz3+Hm7uvpeuqBTCOhoSjEeHsyEyyyjbc/KwIAqxbopXY78kzqKeR
         35Ev9vd//xzA6bXSHADwnVE7c/DWu+wwpv2omUBJCXhRb7ErtgNHwx6efEgZx0qj3mL+
         t66dQpRDlS6iFxcEjVFIkd8Fzr/OR2ObzCtklCLA5/CXJmf9/afPs2pHjdLvltxNXJkx
         hwyA==
X-Gm-Message-State: AOJu0YxrEtmaz+TTdz0qwr9A6PwThK0fTKBbtvXgaCc2Xi8SVnMv9Mdo
	wlzbMwpgF1qbUMM6x0s8ZChowzwoi9lvDuQcFhWpn1Up6mO97ep4DYm/AIah9txi4y+dAt/CpGT
	ZYA==
X-Google-Smtp-Source: AGHT+IGyW+IanDv2gn10X8mgRJgrQ6dxChAv+7NcHxpQspV9qJhboJEE29I20MwBycuSfUIjaysnSToTWm4=
X-Received: from pfbik10.prod.google.com ([2002:a05:6a00:8d0a:b0:730:4672:64ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1709:b0:732:2967:400
 with SMTP id d2e1a72fcca58-7347910977emr15073690b3a.12.1740619557217; Wed, 26
 Feb 2025 17:25:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:39 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-9-seanjc@google.com>
Subject: [PATCH v2 08/10] KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Mark the VMCB dirty, i.e. zero control.clean, prior to handling the new
VMSA.  Nothing in the VALID_PAGE() case touches control.clean, and
isolating the VALID_PAGE() code will allow simplifying the overall logic.

Note, the VMCB probably doesn't need to be marked dirty when the VMSA is
invalid, as KVM will disallow running the vCPU in such a state.  But it
also doesn't hurt anything.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dd9511a2254b..c74cc64ceb81 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3850,6 +3850,12 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 
+	/*
+	 * When replacing the VMSA during SEV-SNP AP creation,
+	 * mark the VMCB dirty so that full state is always reloaded.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
 	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
 		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
 		struct kvm_memory_slot *slot;
@@ -3895,12 +3901,6 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		kvm_release_page_clean(page);
 	}
 
-	/*
-	 * When replacing the VMSA during SEV-SNP AP creation,
-	 * mark the VMCB dirty so that full state is always reloaded.
-	 */
-	vmcb_mark_all_dirty(svm->vmcb);
-
 	return 0;
 }
 
-- 
2.48.1.711.g2feabab25a-goog


