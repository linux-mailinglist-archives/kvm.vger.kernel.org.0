Return-Path: <kvm+bounces-17718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02FF88C8EBC
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 02:05:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BDB51F22549
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614E0B64A;
	Sat, 18 May 2024 00:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Evs33zy7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4893D63B
	for <kvm@vger.kernel.org>; Sat, 18 May 2024 00:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715990680; cv=none; b=uidCGleGbQ2I45Mey8rxoqQKq4aBO7/2Tbo3DDiA/DGBjnipDGMeT3nH9y/eXGxVbcjJ7DXgTKhfqswuCk2QqBmK/Ni38J1WDxPGDCjKSdDia/0qqz3ZkMR0wXl9058NASDDLQceOot0NlSXxGssUDZF2E4QjokLHdCdTJznUqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715990680; c=relaxed/simple;
	bh=rvIusehJzyfZSU3DUGfZk3ycQpyzGMDHRsg3jAj+Fmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DfX+smz6ftCNW/AB+2ab2Z7ahBs4hfczQFyzrd9r/yiqK/sySEmuUdqMfAPTq2VE9HguJgXB4mrZEJXS47AWy7Bf5tDFjHcdyoLkaNdtDfeYw6oEVV+UmIbxM04PYIT8f3P8gLYB+Rh6zX8v70Gp3VAnhplnxNtuU5lNngcF2fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Evs33zy7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b5cb8686c9so9236059a91.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715990677; x=1716595477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lj20UPkGYyPVSIzMYtQicJyMaFFHUkTnXbi2b/YJs04=;
        b=Evs33zy7rS9tKW6zWsgeD6fwSsJy5yVUeQMorSYou/bVEFHs7fC71O1KyAvgOUD/Cs
         D7W3UqdauEvezPDstiPYmK5GyrgykeKXFRVCdtbCtpt+hUV6BfAEDZHG/w5FvmIRLdot
         B7XezgmiCp3/eteM+IUcXmuf667vrgJasr8DjdM18iwTs6uAWth86iKLSVBSrWm04M85
         YWtYc2i0V4wCJyDS+XHpCHPfZAQXpoZvSUM5uooK0DTIMIpMyLfvdxvdMmrcqnNpvbJg
         s0SvW9wpmKvQWBiSY+851mY02Hj/3OhUmDm7Z/B7vHLc2YDin01V7nKwscsThwTWOxgk
         PT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715990677; x=1716595477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lj20UPkGYyPVSIzMYtQicJyMaFFHUkTnXbi2b/YJs04=;
        b=KlRMRBcHcZHyqxn2Bgk+oZZP5ZAycXab21OZC0eYT0xhT4tBOAsOEQMqvY3DRhlkiy
         09BxAbQIUHnV0UfSyuAN4F5NqNTM6TpRo5OXKeYhNmdc4cSHrVlxyAFJxdF1XATc/rAc
         xO/knzBFbsBScLZurUC2LooN6ZYysv2Kswm1G+Gxqy6Sd3YYzToTD4OYn+EOmQ8zu6Zx
         C7W4XXMUdcpv0XvuyF7UV7HSz6udL0Nq8CxsoJOKzQm3lupKu4p7luxhoZez4n5NkpB5
         pEr11Iq3QPNLD3vVh83zOWkh8ql+9ZCcfQRD1h4Fl6SUsCqWS26dVA7ReR+pJLikBCMo
         ewWQ==
X-Gm-Message-State: AOJu0Yyrm8WsZA+a/7+QuSOaV6CFjCvmh3Wim6298b46FUYGhcga1WLl
	QJ/R/PDQKQppTifGAqyQNFmLtO6+nBZDqc5v/u9dfgrdwK4IioXRE7T7xaKQea8Vbi9qizxN/3J
	fLw==
X-Google-Smtp-Source: AGHT+IGpdxtM8Gr2Cby17gotkm6Me/GjSzJCCJjzc+9CZGnGeexqUy7HUOGADG/0D9GVxcMlmsZaUfGAvLs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8809:b0:2ad:df73:31c4 with SMTP id
 98e67ed59e1d1-2b6cd20f995mr63818a91.9.1715990677507; Fri, 17 May 2024
 17:04:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 17:04:22 -0700
In-Reply-To: <20240518000430.1118488-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240518000430.1118488-2-seanjc@google.com>
Subject: [PATCH 1/9] KVM: x86/mmu: Use SHADOW_NONPRESENT_VALUE for atomic zap
 in TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Isaku Yamahata <isaku.yamahata@intel.com>

Use SHADOW_NONPRESENT_VALUE when zapping TDP MMU SPTEs with mmu_lock held
for read, tdp_mmu_zap_spte_atomic() was simply missed during the initial
development.

Fixes: 7f01cab84928 ("KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed SPTE")
Not-yet-signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[sean: write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1259dd63defc..36539c1b36cd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -626,7 +626,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * SPTEs.
 	 */
 	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    0, iter->level, true);
+			    SHADOW_NONPRESENT_VALUE, iter->level, true);
 
 	return 0;
 }
-- 
2.45.0.215.g3402c0e53f-goog


