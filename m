Return-Path: <kvm+bounces-30778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1EC9BD53B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 633C91F26777
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305881F668E;
	Tue,  5 Nov 2024 18:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V+NZJ/jf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02B91F4FD3
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832231; cv=none; b=UYZpzoeHfC9K3zXttq2HKk8DmCX0zMxXBPjfO0cvKQw62uNDi3pMaN6a9vquS1b+HusNHp8UCnFJR/aj5mTEvmeMiEEt8fvJsGS4tNZLkkzCg1C/bG8osYpYJcCm0eggHzFVbeRBhhXQoUAQdobHdHAsSnhhof6K29qo4MoFzLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832231; c=relaxed/simple;
	bh=adN5zNxLOGpGOTqMwOHxC6d7vF3p5DoHj0SGHVvTfJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X9h7rgm4W/qc2VzYhNsCbEHRHZLZbeX6Yscd+5QMkHSNWYKfh1q09FQe7vH0M8RQJcdUaTbviDv50fNzZqfOh5Ksnb+2mONg8rH/V0WHL+K3cTjiVFMAuNgQPey0hvBbRI+iTTRIruF1H+ojtLVpqQCT2kjUQtTKr+Gf+Vsi5m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V+NZJ/jf; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e7fb84f999so90023177b3.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832229; x=1731437029; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOOEVUdnHgf32MRIxCKSoPjfbLEYf1LngBtyI0A4Ics=;
        b=V+NZJ/jfYOQqvRmQ32lF9cixaj3UqH49cYvYTGXoQss9HEqwzCEZ8dHgr9n/8+sydI
         slH9dzcf8Fjk6R8Wd+msqnzv/qOs5zusbk9XnNXbqOxveBpCbr+VS3wVo24dhfhkJn9m
         2vbtHAATBD+2Jns+cov9DYQEJFFyOq7V2qlUDfq4EiA6V4pNe6BU2ux10BnHIbipzVM5
         uSJck1Gpa5mOBootWbmc4z2chB8Zt3dctpcO8CwA9hKQch/qcHzzUesEjfknhvc9UeWz
         k9IpDna8/646KqM0WSuPTJbe1GiofusF9caF2y2+fHIX2TVy5IfJX7toTUhifCsZYB7/
         +QhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832229; x=1731437029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FOOEVUdnHgf32MRIxCKSoPjfbLEYf1LngBtyI0A4Ics=;
        b=vBCaL5uetRgjcmqw3VHtx6fUEleZ4pIC4lv1QJvFt10/vHWyC9t1rgaGtwBoVcIvqy
         ZDclsI9P/7iJhhQfcswXlmIAei5jUhmwT48WNy0af9GackzYvnxrR+Y1GasvasbjdhNw
         jFa1i8QGYz1qdA2RcE7iJKeDVyp8mQKS0AQETkKw1H9/obgmjn7UzPwenRSjefCg217Y
         XXVIHfh9X1d7buYb0ZQ0U0zu5rl+qIjRo3sLRUgWgx0KwApPj+v+gv8Ii+fJjH5oE3vZ
         9OT3C0VeN52Q8Uw5TBXAuFdZC51/XUz+FnIzG8hijiDnCmtheRO9mkCWzqIMLrj+5uJO
         iwAg==
X-Forwarded-Encrypted: i=1; AJvYcCVVo2jFhtDoFYV5pEe/UptlbSMzntqWesTX8L99QggDOPd3n04HhmAEvDRRBRCmciCv9ag=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz764eFsoo342olSi6LpYFjAytW5Uq4RYdlhDEFl6GXajLqUlA6
	3NiZCzRdBPUORYYqM1W+ntKqtT4x0WSCyt7TF3VvoC0d95ZlnACUe8L1JLPvYoCBGEjAEFiBAEv
	flpLg6J6H0IPS4nuh3A==
X-Google-Smtp-Source: AGHT+IGVL4XrDgFmvYXl5VxvaY4ee6ODWUq7wk9dSm9xDKUM11C1od5XcBT+XS/F+nwINXTTz1u2yJuF4xm6dR9N
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:4484:b0:6dd:fda3:6568 with
 SMTP id 00721157ae682-6ea64b8c23cmr1286667b3.3.1730832229001; Tue, 05 Nov
 2024 10:43:49 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:28 +0000
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-7-jthoughton@google.com>
Subject: [PATCH v8 06/11] KVM: x86/mmu: Only check gfn age in shadow MMU if
 indirect_shadow_pages > 0
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the
shadow MMU by, rather than checking if our memslot has rmaps, check if
there are any indirect_shadow_pages at all.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 793565a3a573..125d4c3ccceb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1582,6 +1582,11 @@ static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
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
@@ -1589,7 +1594,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	if (kvm_memslots_have_rmaps(kvm)) {
+	if (kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young |= kvm_rmap_age_gfn_range(kvm, range, false);
 		write_unlock(&kvm->mmu_lock);
@@ -1605,7 +1610,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	if (!young && kvm_memslots_have_rmaps(kvm)) {
+	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young |= kvm_rmap_age_gfn_range(kvm, range, true);
 		write_unlock(&kvm->mmu_lock);
-- 
2.47.0.199.ga7371fff76-goog


