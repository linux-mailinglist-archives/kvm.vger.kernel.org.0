Return-Path: <kvm+bounces-23773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B1194D6F8
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04365B2233B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D1119DF60;
	Fri,  9 Aug 2024 19:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BtQcNZHX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC519D8AF
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230249; cv=none; b=vDjz0svskfsegNqy8Kq5K8RytZxBhQJZWgkKZokZiK0oK5AffEay1GpkrnYelrxMDjS9yA10IvFHMslZwp0Y3vr/2Q18z2VaQTDk8OaQEV7LOTWt6JoNnywzU2cn8ACmLoOfGkvCj/DfBB6jDtCXU4fb9nk7iiumUHveywgiGiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230249; c=relaxed/simple;
	bh=fQuuC8h+my/ip7xEVnWzpMj4lV5hpjnXHtbzdkoRqRI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WR+sy2w5R/jC+tPM7m5Hhm8THjNZRz1XRo0XilStZtv90fMq0Hga2Q/WXa2UvYKlsmTRUdgjwvSeNwJJApjtjg697R7+13ikDXI4//QdM8B3YjBJRFLM8gWRaLWcyMl+67RMFNGLf6tu2U+0EMae9WzEqT7tuQrwDZ4XDJd+UIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BtQcNZHX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb576921b6so2826308a91.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230247; x=1723835047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oWpScC2lPAOYQSvm8ofyxB/d7cOw2/4qi1QTT+90O+I=;
        b=BtQcNZHXhmSs64QAR2YOmmt44qJx16MN0wvYFpE4NKJQYAKOrch1mmZ4RJLN/JijtZ
         /54RyTnlbUhvzsFYk5SnfTosafZpskQk15P5lXSo4FGNyIf9xmey5RtbUYRaK2uC0qJe
         HZJtm65BKrobVAoUnbHk7hCevCsJhXbKs+HFo2bEIzl/rPnUC1U2iFzKj8Dye1Hx00Q9
         axYvDCNfVienClKv9u8EkBVDRljsvtToxTQgNQ6Wfr04y8soD4ki5TNmoJe80nLaY3mo
         3DKhFyX5fr6xG4EDnCzWW6u7+JQdiNzjI3UdMxx4LB4g0ISVG2F857CNIBCVBPV6g5LK
         wOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230247; x=1723835047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oWpScC2lPAOYQSvm8ofyxB/d7cOw2/4qi1QTT+90O+I=;
        b=NxThy7JkiypHaKMkXaS3EEfGQHiw0/cDOetuMLQget/I1LDXlZ9xpWvilDDeOaQWRn
         6fLmjPhaNsDPVXj2ZL64WAkzXVP0yrRMffYjdOKd6P9DNjd9Gz/sxe9vbFjziWMUMNfW
         5vPdxr2CDx0nvijoRnYI0Zj8UonIegDjkCHltjX9qEXzjHr/weAuKWnLKLE6W8pSAz6l
         7muiVCt1gLtmMoG4IMJHLeUbZeTGjc1rmRzXK+1eQV7XGAyQXmTSHoEjiWXVCOtPyrmk
         lYldSohdhF/p6Mi2zDimgcyrSl+mua++u8W/c/Gk1ctXrcx6QGHdcg1NZYA63IqO28HX
         2vNg==
X-Gm-Message-State: AOJu0YwmSrRmkkP1uckho6kWuRgVS/TsWbDNLxCEn1dyRXonBo/RDQ/L
	mEshIWv747CrbUA1h4CsVkaHTLWeem3Xmqlx0RI8jiWwsqc3G1TlQYxb3XgrHquIFsQ0h4Bo5x2
	RbQ==
X-Google-Smtp-Source: AGHT+IGa40bwUoG33bFhX/FYTpen2eZdAbi/a/MWhlBc3vfk78wwXJqpBLLJqIKqaXmEqi+kQcPOVyN0PcA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d812:b0:2cf:dafd:b793 with SMTP id
 98e67ed59e1d1-2d1e80674c6mr10196a91.5.1723230247317; Fri, 09 Aug 2024
 12:04:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:19 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-23-seanjc@google.com>
Subject: [PATCH 22/22] KVM: x86/mmu: Detect if unprotect will do anything
 based on invalid_list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly query the list of to-be-zapped shadow pages when checking to
see if unprotecting a gfn for retry has succeeded, i.e. if KVM should
retry the faulting instruction.

Add a comment to explain why the list needs to be checked before zapping,
which is the primary motivation for this change.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 300a47801685..50695eb2ee22 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2731,12 +2731,15 @@ bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			goto out;
 	}
 
-	r = false;
 	write_lock(&kvm->mmu_lock);
-	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa)) {
-		r = true;
+	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa))
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-	}
+
+	/*
+	 * Snapshot the result before zapping, as zapping will remove all list
+	 * entries, i.e. checking the list later would yield a false negative.
+	 */
+	r = !list_empty(&invalid_list);
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	write_unlock(&kvm->mmu_lock);
 
-- 
2.46.0.76.ge559c4bf1a-goog


