Return-Path: <kvm+bounces-23285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 352EA94861B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E17A82819F1
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDAD171E68;
	Mon,  5 Aug 2024 23:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a+3UHOE+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7717109B
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900691; cv=none; b=HdxBkORE8OZoTQr+8/VfFiUrVX1/5TDk+n4ElRC6NzI0Qwv2TjrN2o7goeWDspK6+Id1bkHFJAkdpxUT5zycPM+AyXV3Eh/xEDJ1KFHi/GRIbiaOraUNyHb9Vj2sX0c8bGaehah5kopQA4aBOdkxbogVR08zkmUPbxobamSEG2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900691; c=relaxed/simple;
	bh=0HmNEOpgMjQpIHUlfH6eKvwTm69FIkgwj2MocE8We5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pfdYaQmNqdLrNcysYesOjQG55rqZkXsysezUObqo4fAImeVwkpSd0NW8S6BFrW575/6pgJgt0rxMpJ6NOEAb38S3rZI4uXXmJKrX58B6KX9fb0uMV38QyVVsRiq2RobSjrCGbAQ/zkoiJxaG+2Mj/diLuCLcoYzQrPHmR05LSTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a+3UHOE+; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02b5792baaso20387395276.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900689; x=1723505489; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DKEJYawgFTgqeLxqFQfo6jraqV3EuXPgrnHcDXOEExE=;
        b=a+3UHOE+ECTrYrSW26+ZFqtyFySIMtnsKp/6nq+oHlBAqCmizyHi3TzC+NPjscsIin
         Gax7i7watIQfUUX/3q5Rxeecdyv0WwRtm+eH1gGi4NtPV4eBIuuxjj63M8B9HMJ5O2ca
         rwI5Il+givCmkM44QaoKruR+43W47rUUtmcRfnwAEio6+0GmCO6ZFcTacBVhaOAJ5hWv
         jPGOUzSMCHHdkee1Ip1iKptYABDcfm18s22fjxbpSXwDzqEnRHnCT7H6injdPEyAzw4n
         CYnIxY6PnPVR3etRYGwIcxn9vW0NgfhZHLQVrxxrsneE6HL2zee+iUP0DF2iFuQV5aEM
         hk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900689; x=1723505489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKEJYawgFTgqeLxqFQfo6jraqV3EuXPgrnHcDXOEExE=;
        b=WI7lJ21HHE2XxwFGoaTXozaYI8YeNg89e4L6jD3/tbbau35XkiEIvCeUMxJ/8qbTlq
         8+xDxc9Dvjjx7dLwwEttvGfdR3dS+fZWAq1Ox87aUMEvXMFX4kT93slYxWoE/g+W/ljk
         DYcsW3lUld1885ezbUngN8QNO8FYj8aUgBsJ2r44u/bwEa5bkZr+z9izsGjXx0x7CmAX
         D/A66Fqf6DbEhJX/g/n8PrnJ/QmJHjRLho9ogClRTGkbLMRtwgWZ24uW4hDp6xcusE9Q
         pnyTmBlORAUuRqtlpca2SW0+hd+/MqdB4Usfts0ZhRxMvpdHo9T1hTQMRXXXr9c6TyQU
         O/+w==
X-Gm-Message-State: AOJu0YzLEx+L8WLm86x2Mzjd5sM+a5Kvm1OD08cEoLJAHA1oldg61p2m
	ynMkDOziStn/INu0D4LkVEjkxSwRVnHmu2Q9W9hfUaemfFTr3NaSiX1Xz0lg8caTApbx8i9znOG
	A8OpbOOS5Mw==
X-Google-Smtp-Source: AGHT+IFV1GjWLQYMLRrUrhhfXUhX9zXBqQRj7Y3/Pl/wJJTSBB1xP3VnbQKxlqCwlbyCj71YlBbnnpPzI/u/Cw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:405:0:b0:e0b:f69b:da30 with SMTP id
 3f1490d57ef6-e0bf69be1bdmr56099276.9.1722900689163; Mon, 05 Aug 2024 16:31:29
 -0700 (PDT)
Date: Mon,  5 Aug 2024 16:31:14 -0700
In-Reply-To: <20240805233114.4060019-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805233114.4060019-8-dmatlack@google.com>
Subject: [PATCH 7/7] KVM: x86/mmu: Recheck SPTE points to a PT during huge
 page recovery
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Recheck the iter.old_spte still points to a page table when recovering
huge pages. Since mmu_lock is held for read and tdp_iter_step_up()
re-reads iter.sptep, it's possible the SPTE was zapped or recovered by
another CPU in between stepping down and back up.

This could avoids a useless cmpxchg (and possibly a remote TLB flush) if
another CPU is recovering huge SPTEs in parallel (e.g. the NX huge page
recovery worker, or vCPUs taking faults on the huge page region).

This also makes it clear that tdp_iter_step_up() re-reads the SPTE and
thus can see a different value, which is not immediately obvious when
reading the code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 07d5363c9db7..bdc7fd476721 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1619,6 +1619,17 @@ static void recover_huge_pages_range(struct kvm *kvm,
 		while (max_mapping_level > iter.level)
 			tdp_iter_step_up(&iter);
 
+		/*
+		 * Re-check that iter.old_spte still points to a page table.
+		 * Since mmu_lock is held for read and tdp_iter_step_up()
+		 * re-reads iter.sptep, it's possible the SPTE was zapped or
+		 * recovered by another CPU in between stepping down and
+		 * stepping back up.
+		 */
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    is_last_spte(iter.old_spte, iter.level))
+			continue;
+
 		if (!tdp_mmu_set_spte_atomic(kvm, &iter, huge_spte))
 			flush = true;
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog


