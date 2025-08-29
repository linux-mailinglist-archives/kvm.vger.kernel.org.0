Return-Path: <kvm+bounces-56222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC45B3AEF2
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:11:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 524143B9819
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF76C25A321;
	Fri, 29 Aug 2025 00:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h7aEbgmf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4632512E6
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756426012; cv=none; b=ROkAHnpw+Kq7mH4v/67D4Sve0/crRLrbPtiEN8R5EY56XPI5ggs2XNSsekXzeWxdY246MlEYxJWxhhEx7AWgtAvCAOg5xpMBJRaARzSAwrTyQ8GCDOYZuLuA4l9LbPE74lwB89zyxbeL8763z6ePBeqyU+MU1Lun15JW82ksYMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756426012; c=relaxed/simple;
	bh=H65S3rJ44uz1vGqMB8iQWHr3yMc9skrgmgdydv2RDBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G1aFboYPv4wgTqDKce+QIjKH88SkZI/HC7LkKv6bVaNSXJ2YukS5X99ob8gy+1LQw7sazrMdaLBROP2Ip1ckkDjwnbVh1ohO/E1MDQ9dT3xp3tRZfo2qD71IUFDHS/1hlhJiP1YDsy1R07v8cP30B9Zey0W3xP5wD9tnuhLHg3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h7aEbgmf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-327704c12d3so1292229a91.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756426011; x=1757030811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RxLpwttBWSyhDMcXeP9tOwiMvx8JT1XOIrXDB90LYs0=;
        b=h7aEbgmfH+cGre/Y2hSqw0HDXlCJOU5E8gTFMEVIQY2NBWKPF/f3Aof7R/4NYyTOEK
         XFbvZ2EtoskhR2KUItwuHL1lDI6xI/n6oyIIwxLxfAn/pZ29t1OGDjf+JEHG6omlDpyz
         fC8wDMl6OM9sRglQLx7ogsBJMlQnObo18oL3OYk+ciYqXzdMuCy7GAmlPd+ncncRSNbn
         tcwXiymIvsFRQkwqba89MhM6bjt/+hyb0A6djJf5t23thqLtGBQh0rbtszDaAiHCz4k9
         gIH8Mx4k6qtXS+Tzqfegzgg91JYPUtr+VueaJWQ5Q5l4Qov0HK6fRBUaNlA6oZ8SwiuS
         F6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756426011; x=1757030811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RxLpwttBWSyhDMcXeP9tOwiMvx8JT1XOIrXDB90LYs0=;
        b=jTlsobsPxAJ+TAKQmsT5glO+ycrC8RE7y3jSVzUOwX8XttvzR4oaEut2lg6o5nbY+U
         pQtyI6ad38E/1f/gNDCKyE1WQ/0pOUhShUh/Sjt+B5ulLnBJ9bi/5gq/Zxjj+3YLIXAQ
         owOlIfwbondlcLIQH8XSMpYPf31YTrgc+WfJ3zThL23ZjmxNFpSk7VIm9eQzDGtTZuKw
         2CYO2Uu31Sl9t3GqPCK2/Ji5Un3OlC5fcwpK8VoFrWkpKYzk4X/7S6u96RX57ip8mmSo
         IrmqIJDvXx25ahOMJQd5ASFqFZs1HC9hNftRNwj9hSK2EWi/Wv0O2CvlNHamebki9ZY7
         cWTg==
X-Gm-Message-State: AOJu0YzaFtgnMZftlZfXpPSXUzpGFvo+QS40d7/ffN008p2ERFyMAiwI
	pdX6zCmWe7FPwvezTYWNcYLPW0Wx/LNPw4hcFCEgSCTBou5e/3q3XOxiLrE20Es8RcQ0pv779CX
	j+RR28w==
X-Google-Smtp-Source: AGHT+IGLzPaUhXZ+u9d9SfG1XeBM9vvj2fmTjF1JBq9az/V7jTBWQ9o6GVfcj9yTochgKtIXUfKJVyXd6sU=
X-Received: from pjbnb7.prod.google.com ([2002:a17:90b:35c7:b0:327:41f6:db15])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c02:b0:324:ece9:6afb
 with SMTP id 98e67ed59e1d1-32515eadfb6mr29318208a91.3.1756426010777; Thu, 28
 Aug 2025 17:06:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:17 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-18-seanjc@google.com>
Subject: [RFC PATCH v2 17/18] KVM: TDX: Assert that mmu_lock is held for write
 when removing S-EPT entries
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Unconditionally assert that mmu_lock is held for write when removing S-EPT
entries, not just when removing S-EPT entries triggers certain conditions,
e.g. needs to do TDH_MEM_TRACK or kick vCPUs out of the guest.
Conditionally asserting implies that it's safe to hold mmu_lock for read
when those paths aren't hit, which is simply not true, as KVM doesn't
support removing S-EPT entries under read-lock.

Only two paths lead to remove_external_spte(), and both paths asserts that
mmu_lock is held for write (tdp_mmu_set_spte() via lockdep, and
handle_removed_pt() via KVM_BUG_ON()).

Deliberately leave lockdep assertions in the "no vCPUs" helpers to document
that wait_for_sept_zap is guarded by holding mmu_lock for write.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b73f260a55fd..aa740eeb1c2a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1714,8 +1714,6 @@ static void tdx_track(struct kvm *kvm)
 	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
 		return;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
 	err = tdh_mem_track(&kvm_tdx->td);
 	if (unlikely(tdx_operand_busy(err))) {
 		/* After no vCPUs enter, the second retry is expected to succeed */
@@ -1761,6 +1759,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	/*
 	 * HKID is released after all private pages have been removed, and set
 	 * before any might be populated. Warn if zapping is attempted when
-- 
2.51.0.318.gd7df087d1a-goog


