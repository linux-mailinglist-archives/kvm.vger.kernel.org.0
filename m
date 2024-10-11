Return-Path: <kvm+bounces-28585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE42E999A1F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F09E281235
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0B31F8EFC;
	Fri, 11 Oct 2024 02:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WB7M3S/m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05CD1F8929
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612671; cv=none; b=sIPNM2df69RdSrjq4OrgreNJ2wiLwvr5glduJmEcW/6VDj1YsCOJTFkPyad8tS4wXJDA38idzTKCoifqB5/wodu2NIr8h+nNGcVXfxr0NjgdFgf/dNu8jxeFnDEsiIdZPt65cNAN6RCAXELZo/VOOMNeG0i+72wSV784+JYO7dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612671; c=relaxed/simple;
	bh=Oaro4dCEU4jcQGzk11Dklpup6VCv/ez4gfRevJ+nC8s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e9P2RtbWOcwKnRvhLAX1jfX/ccT7bK37sSiDxpjBOtQa8bxdTK3nKP3aaqjcTTroamRlip1jf9UJsMD8DU+AmBbWRvpkczhtZzoa22RAFuTBrYObx4rgXbxO2pJ9M+nPreHYMwj+4Dab8/wrajfpMrPO3qmIxK0eQKmpyAYfah4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WB7M3S/m; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e00a395b1so1864711b3a.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612669; x=1729217469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/d560U3Z5EC8iutMB38TtGLr0WB17Rh2gPoL7ugF38Q=;
        b=WB7M3S/mFw5YlZ2Um1eaaGC1gfdCVmza8EOZtjW4VsDALD2c331x53GopaQkASzX5z
         ZKyUU9JcIDKLKQv/9YbjENe3F/9JQ/E/10cFwupxy+mKCb5VbgW4Su2fwpRXzvv91dRn
         xwtCnZAaAZOR/AgUtFmbobvQA7IF9yD3DtNOijOGIHDagKv2ZizEco31Pirsl7xfKdcB
         OQBvzxGxLOUTuKlMki5Cd5cgNjt8r5uy4qhRygl18QUxg30mwqoSF9JYTjfCYRSXE/yL
         540SCxS0rgPBpMw8C58lPCJxaWTqAJEqzWGDvGy8sqDAvmrWOJeXtQzjYCvjIXK4LP4P
         Q6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612669; x=1729217469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/d560U3Z5EC8iutMB38TtGLr0WB17Rh2gPoL7ugF38Q=;
        b=dtiwR1wAYTm77yP+Ri5XDWrHIvX4UtCqmzNwSyLeryohMF+GUMtYgilM+a4xVUlStP
         cyMvw1RC2SZnzHxEpTEALvmbmjZzK26AsNGc/M5C5+IiDfn+WA5oA3xAB7PjwG0KLo9V
         RRgz0zL3CPS+iygnW2iNbO/pFoGAb8Pl9EvTssXOTBhhLl8uF1GonF0VkpTw43mb+mXd
         vQAsTDp7NiPaltEmG6uktkcoU6BIAWv99iIAf76sircQxkeE3dMGfF1JLOheQ8Sc+emS
         lLfex+S6RakeFoKVg6AJQRyoElCFTAPnKp/BnJLO/aGbmtaU6CGGer+71nYLohuYbPXN
         R20w==
X-Gm-Message-State: AOJu0YzPIjaYBZCHkLPS9J+kCOOODJRuC1KJ/Od67aIaV+XSMJIzF/OG
	zUmf7JMzeRRtnv5kwnmkthZvU1f24wcfMG5NwWDT8f5u49fyKrKR5FIgJPDNbuUDw43nKVZAVav
	b3w==
X-Google-Smtp-Source: AGHT+IEDwgWqwtaUpKGOtPV1SFkzcT7nOjDPYXAUgFqKAshQBSQwxTCbIPRBqsJGwoI5XT9ksv8whQ+VyDY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9161:b0:71e:1efb:3239 with SMTP id
 d2e1a72fcca58-71e380f82a9mr11932b3a.5.1728612668662; Thu, 10 Oct 2024
 19:11:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:40 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-9-seanjc@google.com>
Subject: [PATCH 08/18] KVM: x86/mmu: WARN and flush if resolving a TDP MMU
 fault clears MMU-writable
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Do a remote TLB flush if installing a leaf SPTE overwrites an existing
leaf SPTE (with the same target pfn, which is enforced by a BUG() in
handle_changed_spte()) and clears the MMU-Writable bit.  Since the TDP MMU
passes ACC_ALL to make_spte(), i.e. always requests a Writable SPTE, the
only scenario in which make_spte() should create a !MMU-Writable SPTE is
if the gfn is write-tracked or if KVM is prefetching a SPTE.

When write-protecting for write-tracking, KVM must hold mmu_lock for write,
i.e. can't race with a vCPU faulting in the SPTE.  And when prefetching a
SPTE, the TDP MMU takes care to avoid clobbering a shadow-present SPTE,
i.e. it should be impossible to replace a MMU-writable SPTE with a
!MMU-writable SPTE when handling a TDP MMU fault.

Cc: David Matlack <dmatlack@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9c66be7fb002..bc9e2f50dc80 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1033,7 +1033,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
-		 !is_last_spte(iter->old_spte, iter->level))
+		 (!is_last_spte(iter->old_spte, iter->level) ||
+		  WARN_ON_ONCE(is_mmu_writable_spte(iter->old_spte) &&
+			       !is_mmu_writable_spte(new_spte))))
 		kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level);
 
 	/*
-- 
2.47.0.rc1.288.g06298d1525-goog


