Return-Path: <kvm+bounces-22144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C42F93AA70
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 03:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9DC1B2372C
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 01:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744286FE21;
	Wed, 24 Jul 2024 01:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Vk5U3xX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5999C3B295
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 01:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783484; cv=none; b=Q6ScCRm/MFiuivyw8zAZfGxRDqjqVNykZBs4VQo1lOMrp5pFatZjfm45cwNmGtMV6j+MGhnCKlE9I4ABDwm5DepFqeHAuIJf7NoS5bZprDuOLvlznZHrj9ue7BrrmOPxr6J69lq51p6h15jhnifTOvHVGbStL6T5nUpJwLJCIuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783484; c=relaxed/simple;
	bh=ELbOSXsn2tl30guokJCMMpH45tyd+sOPH2P1Gsg+Zxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jyj5UDCAEgN/t6PjsUnjTNtqomm8J8j4wiU0L0mvZqVMFTMxHg0pjCz2Y8nYY0Fj2X5o+j9xFuD85rWjCpdm7hr+TBF4ui4ic/tRH+7+0lXqkiSV7z4362H+UmG7LFGYjT0WKTT4UfFNmPXtbNkJtjT9a69AEfkyrypiPa/sEvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Vk5U3xX; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-492a4820c4dso1619896137.0
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 18:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721783481; x=1722388281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P6265Vr7ZBVKTm4Fxp+PtFVTNDBMV13LE1gmbTEV1Oo=;
        b=3Vk5U3xX9N5NzduOtpuGbSMYSeVxZOsb3S9l6hcrpVl15VY7FGYs8+TlzJKUNXRpDD
         Ix7FgCJNrIuPf70KwBlVZ9332a7XiGPY9GYr9yMhSTjVqZfdNBLSKxZrAF1btUkpVJV1
         r+mXbVG/wvapWJK3RaH0fgAGx66qlyMrnXQ4AgAjabOgAQuelsadMxQr+/LwHdNCSGIr
         VDj/0Bs9Tv7Jofa6Lf9aCkW8Dk68JpPw0zlUQX1y5uFI91jLLBW6Uv3HCRdRUwoyrcUs
         KP/GP0YvWSC3c0ifLF2JBLFW7za2noyRbm2lWS0X4tu7ZfLy74ekZt8fIErhHrSAwWc1
         efgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783481; x=1722388281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6265Vr7ZBVKTm4Fxp+PtFVTNDBMV13LE1gmbTEV1Oo=;
        b=iyaL2ds7iqmfjaHuXNYpCXaLXGtvczco1hWgC7JtZ/T/WtJkJKR+5BemODSv/euurs
         BcqH88dWt2WWTV7oKw6XqNGNrxUt2JH0EUjPb7lnLboA5J0N9CJWIJ8Rra/6ul4W/Xw/
         vIJ3gAYGwGC/kRqLkmuVE9KgUHfjPWQT1s4cjOljFU9xSATk3MJX76GsVunYUwsrYN7/
         DrljKdx1GSRV+qOGoqKfHYHeLsTSvi5CkfeyzM54JtizJ+mprVFleHd4gVvYrjcCqCE+
         GnOWDfZtjlVm9JjO0ywFeah1GGoSV+GirNbj5/rj0tU7vDemFu0ni9X+2ZUgT9TgNhhJ
         FCYw==
X-Forwarded-Encrypted: i=1; AJvYcCXlIBqQG6AQ+bDJnrs7AODnGuPzTT70/chWVVDlV6hRJ2Xsa+g744DOhx7n3jAFQ3umGvTsBvnRaJhXSJ5IVvqpYh9H
X-Gm-Message-State: AOJu0YyGZW2l3B+evU4boIsI94vzGj/d2K1O+JHwnjJvK+C6Yb9vg6c6
	LBHICI2q6AcdzDqkZTV6YI9q5ht2eRsGkpBQlb33SQdIvuh/AZ0R8FepSXQWtlDwAyctbgixybM
	Dxchv7kBmb8VHFYzkIA==
X-Google-Smtp-Source: AGHT+IGFz1kYjtJ2CB63i3kpIK8cbKQBNz86a9KHHAO5xzKcY+Rn5KgcFneR9rdE9iF/27GJgdzSYep0JZHDL1qb
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6102:358f:b0:48c:403d:4428 with
 SMTP id ada2fe7eead31-493c4b17e64mr40150137.4.1721783481412; Tue, 23 Jul 2024
 18:11:21 -0700 (PDT)
Date: Wed, 24 Jul 2024 01:10:34 +0000
In-Reply-To: <20240724011037.3671523-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240724011037.3671523-10-jthoughton@google.com>
Subject: [PATCH v6 09/11] KVM: x86: Implement fast_only versions of kvm_{test_,}age_gfn
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

These fast-only versions simply ignore the shadow MMU. We can locklessly
handle the shadow MMU later.

Set HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY for X86_64 only, as that is
the only case where the TDP MMU might be used. Without the TDP MMU, the
fast-only notifiers will always be no-ops. It would be ideal not to
report has_fast_only if !tdp_mmu_enabled, but tdp_mmu_enabled can be
changed at any time.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/Kconfig   | 1 +
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 6ac43074c5e9..ed9049cf1255 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
+	select HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY if X86_64
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 919d59385f89..3c6c9442434a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1641,7 +1641,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	if (kvm_has_shadow_mmu_sptes(kvm)) {
+	if (!range->arg.fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 		write_unlock(&kvm->mmu_lock);
@@ -1657,7 +1657,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {
+	if (!young && !range->arg.fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 		write_unlock(&kvm->mmu_lock);
-- 
2.46.0.rc1.232.g9752f9e123-goog


