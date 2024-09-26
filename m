Return-Path: <kvm+bounces-27523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FFC986A83
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE3971F22596
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE2618C32D;
	Thu, 26 Sep 2024 01:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jNXTG1Op"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com [209.85.160.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1716187FF5
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314524; cv=none; b=K9ZAnwEKT2L1gJSGaO1/ElF2+qYGhQLdQU8oLYOhiFnEEOxKq0Jd53sqB4FraxvKziHnF4K3+RtPtzbAxFVukrNp2e33iPRmhBXi4AfXHlJqPlpQT3yEFXtHDhlwHY77MbXxV+Ff3cJJYy3/xBgan3pUWtLUbSeFXqJ2OPY9MjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314524; c=relaxed/simple;
	bh=hkxJqdv7VrfnIe/UVtmf3L4Q0b/v0J4ZLYo2Ee8Rysg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GXZ8teoZ6D9YXdb5eiGY3wbDeaMwq2BVygdxj8mJqdypIsyw02P9JHFvqg96PDMgE6sWhgu/OF81vWoypiBdMpSA/PSvFEWRb38KJKsPl/uswB4GvM2qdCU5pJZoXAgmgYRf1rpciu9gP8NRgk7GZgGyaWJFpPTi3MUeVu6LEic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jNXTG1Op; arc=none smtp.client-ip=209.85.160.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qt1-f201.google.com with SMTP id d75a77b69052e-458353d3635so9499231cf.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314522; x=1727919322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiB+e++yi01uCPO64xcLvipIH38DTgOpYlfSBrXkWpM=;
        b=jNXTG1OpLevsGbcR+MqpfVMZwgPXRmUJxePMjPFbYIVYVnzjIa+2vHGoF1izPxKCyt
         9SVTXm1FZnY3ncNWznXj4uBLnlXbdn2GeYtWZWpSXKkcI5H3SRsxERO9Xp+TVqY0h7S+
         AK30Cd/4CwnroUusiuT3bDUODwiI7Aiujsa4He4egeauG62IKDi7Z8XpvvvANOBOstGE
         ab8DFXXdhao4wNIwzqzYKiYMkXuvTcCXsOegUdstL1z6VfFEkPiNlo8fthIxpWJKkQWD
         +P/bZkinHQZmCIy1Tla4re1ec/smNsh3DEB6tzVDDAm5dWHrZMZaRzhmuv5d7cQ9ZxIL
         pklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314522; x=1727919322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiB+e++yi01uCPO64xcLvipIH38DTgOpYlfSBrXkWpM=;
        b=alorpNtTUhKmw1qXMDQWgzqLyK9cBBSDlTxRKbQZvwwdlY7c2OZiYIcYDADMb638+e
         6q2PQN1hAhtNBsb94e7aXPUTQrLjF/2OyBs6JclVvtiVDBa4WRiVtmGsdO1zjAOfq9xA
         T6GELKjYNrU7247y0PJLTLlP8Ou6woqQRYL7C7djHP3p1n2EOVjj15OCI5ki53pNJ/0+
         JUfDx0gtLFlGEgVbfvyKIxbzhIJIb4LN1jrIVbX12O/b8yE/67ufX24OHE/vFjlCVTsh
         2XPt2AUs8zTN+9ZzlE4MW2yrhQ4ymrI0mYtQ79kD9cFOyazDCSGzxWTwp0GqbPsGIIEs
         Dxwg==
X-Forwarded-Encrypted: i=1; AJvYcCXANV5hakuW5SHGpiiWBMdL7LeiMlv9Ijb7nuUoQDwz+cRKUrPuscNvir0f0f4M2sJu3H8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXQE9cnGAiSzmveXtuD0KodGNouJsdVkV9ZKn+0+JVbxmxwFWW
	WHG0qtKTAFB3bVAWq4eCV22EPhDktKEirvU+ArOlZz6phfi5gs6JTJBcKezlhRVjA083cCpQU8+
	p7wRkiyhqJ0tswN/pAA==
X-Google-Smtp-Source: AGHT+IEij2jZTZ7Qfz4w3meuEhq8eeslauQ2yZtvTlXKLk5ZsUhbavG3fPazfw188lkIpQjxnlBFPCvmtl1c33sQ
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:ac8:43cf:0:b0:458:4a61:2020 with SMTP
 id d75a77b69052e-45c9493ec3dmr13541cf.2.1727314521861; Wed, 25 Sep 2024
 18:35:21 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:34:54 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-7-jthoughton@google.com>
Subject: [PATCH v7 06/18] KVM: x86/mmu: Only check gfn age in shadow MMU if
 indirect_shadow_pages > 0
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the
shadow MMU by, rather than checking if our memslot has rmaps, check if
there are any indirect_shadow_pages at all.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 03df592284ac..b4e543bdf3f0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1645,6 +1645,11 @@ static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
 	return young;
 }
 
+static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
+{
+	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
+}
+
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
@@ -1652,7 +1657,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	if (kvm_memslots_have_rmaps(kvm)) {
+	if (kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young |= kvm_rmap_age_gfn_range(kvm, range, false);
 		write_unlock(&kvm->mmu_lock);
@@ -1668,7 +1673,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	if (!young && kvm_memslots_have_rmaps(kvm)) {
+	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young |= kvm_rmap_age_gfn_range(kvm, range, true);
 		write_unlock(&kvm->mmu_lock);
-- 
2.46.0.792.g87dc391469-goog


