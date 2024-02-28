Return-Path: <kvm+bounces-10194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B476186A6C2
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:44:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E635F1C26288
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AA72562A;
	Wed, 28 Feb 2024 02:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C2imXfn4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB87E24A0F
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088127; cv=none; b=ZamojoHuWEi8zSQThqSr9lm+yOG0/mUefjUQnoG3TJPn7FvN9hPxicO4ipWO1bfNgcqbQzVDq/5aV+IfmBdUpM0MBhpJe4jz2ZG41OeYK5xVvLw0lYatE2y78h7HhKrYwwFlEnSF9FWMmrdZTutSfzrKYi/hLlGiszwEJb9QzXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088127; c=relaxed/simple;
	bh=10WzY2o+Flr57bQulGQh5SH//bSBY0IZ4G03BJuz+vI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ct3O/p2o2RaUvtw8yTgNVetJf8LGIx6hx0rnsCnmyXrk02OxG2h9BmsK2zg3kLOtwU2j/n15vyGQWyjwDYk2fGBKDH8fmcIXfQUVqXMWLL5IUdM74PnNmouLPZ0DL5I6q19YTPFvRxF6ME3vyxE+yaRW1PAxtrzFr1Ia8Ly25OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C2imXfn4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2990e2d497fso4216786a91.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088125; x=1709692925; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9j/IY1O+fiTDSKSqyI0HJx2iE7AMuX53NhuhIZhorfQ=;
        b=C2imXfn4SEpwwn8cx9cbELjtlxgLpNqvKJwrmQBiuqZKd/kOIAPHLnAuES//+XIDEV
         23DauaSA9GocbUTI0NgSscwhCzPBg79p4/uUqp5LdYW90kKhyJ5VR+gwJDTdYE+UrTQX
         jiMPVaYNDMe56BbdYC1g8X9XMWlJdTe3coP/YLKW9rbp10BLTa2wbKalhSstO+VllRgd
         9d5R/VY83bnyM3L+3QAQqSlda/zltRJScOlG1ReAlk7EMRRt4m32vXkON3fvjLZ6J4iB
         o7XVq39qGPC403Aj7a0H6ei3cR2Op92ewh/s5fTMqJDgd+syonFZa48MB2kTDhtdGYXc
         Fk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088125; x=1709692925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9j/IY1O+fiTDSKSqyI0HJx2iE7AMuX53NhuhIZhorfQ=;
        b=dU7GV4D83O8qvqVy+0w4w8QLZ2o93NdDmYx2TOkZXI5zhtZ5Cmeu2pab2rKPT3rKt7
         tRkslyGZNr3tG3jiwb6wFAcyMgBKDSgMrd4nlJ3QkvktUza2KppngY9ys1jhrU0PMoOo
         bzh9ODwKNaAHwEiNzqkn4seyX2R1xUSS3SzMgsUi1mKugV1fN8/RH8av7eiaMTiBlnxh
         af8Ygk+xxeyfALZ6/uvWs0WH9MopWch4jjOwWM35BomSTCNNlOww0G8HY35fundk3SJY
         t+5Y0B68TUwVAOub4FqEW2wRqLeBOS/KUWMuAR+4pdIZzc2dlBSNwdsEacs/1X8AEC2/
         ctMg==
X-Gm-Message-State: AOJu0YwBrRjjVsG1aEAL6M8Bo/aaZ6Tap3TtI3pfcwCCoKHq/EFGQaRB
	wglQ8hRXKckDz3LhFz+rnsWCh+xGQDWA+DnkK8q1CZHZ/xjY0mDCtnVLYios0ek/mJG2jYhftJA
	aCQ==
X-Google-Smtp-Source: AGHT+IF4cMKYA2HyWXFn/s6kzTHvnYGOu7L8q1paC0Vx85/7XZ8gBkVthsx01n5pIwYIBwPcox/9ac5Rv1s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:518f:b0:29a:b2e7:91d3 with SMTP id
 se15-20020a17090b518f00b0029ab2e791d3mr80809pjb.3.1709088125284; Tue, 27 Feb
 2024 18:42:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:39 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-9-seanjc@google.com>
Subject: [PATCH 08/16] KVM: x86/mmu: WARN and skip MMIO cache on private,
 reserved page faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN and skip the emulated MMIO fastpath if a private, reserved page fault
is encountered, as private+reserved should be an impossible combination
(KVM should never create an MMIO SPTE for a private access).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd342ebd0809..9206cfa58feb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5866,7 +5866,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		error_code |= PFERR_PRIVATE_ACCESS;
 
 	r = RET_PF_INVALID;
-	if (unlikely(error_code & PFERR_RSVD_MASK)) {
+	if (unlikely((error_code & PFERR_RSVD_MASK) &&
+		     !WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))) {
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
 		if (r == RET_PF_EMULATE)
 			goto emulate;
-- 
2.44.0.278.ge034bb2e1d-goog


