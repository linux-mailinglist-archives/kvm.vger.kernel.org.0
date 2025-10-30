Return-Path: <kvm+bounces-61543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B508DC222DB
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:16:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 281E21890977
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82ED7374AA3;
	Thu, 30 Oct 2025 20:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3A5p7Oup"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33F8384B95
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855037; cv=none; b=ipbySGcuYqAXIaBAfuEtRM0JxyoRWqo8p1jLKcUtho+YywYq7N29cE3WWUyZeH8jvS/TibQP8ZraRwnB1VYFelwfgtC8+Ke/76XE3PuseCqgUO3u6YYk+p1s2RQOl7MbfjaQlHtqzyXLtRIz9LZEr0DFCbuftvNxg5iGZK0WIIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855037; c=relaxed/simple;
	bh=hZ6oGgJsAxLyizwY2nBkXOfX86m8d4LnroP9LBDe0vw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c3LURGjGa30J9iTx2FAO6jIHACbuAoOByxlDaEl7lTZf4cTsB0fNcz8jZt2+FwTGb6V1rf26PnGxNzDIDaaecUbntIcKwLipls65tG9j5O+hv48b6uxfhttLwxaxZBQ00sraUNgvBgXOR9oLzdEX2hT5ZZ5s7/CQNCZ9UL8YiN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3A5p7Oup; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3403e994649so3115346a91.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855035; x=1762459835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2Qp65v2XVpj2mbgYoCIcn74lwhNS3G3VX8VrR6k2zs8=;
        b=3A5p7OupYLEJL57URKNOGGxMM98HcF2+WLquTZNZSBnthoI4ayXJ79BYxCdhf7/4pF
         swxficeXIf1dR4LyNeI44RUUdALRJwXVxauonNboTc+f3cHbKPfZXrwmBQHViRCWUqxt
         9Hc+LNbVZ7Z0dTGdT9OpFid8zN1bZbkcjOI5T6cSDNiJdpOIaD1mhWvNIHnNVw12eTvi
         CVehsXqeBU9U9Y37MlV51XRHI1vTzsPtxPcgLSLlZPZFy/YIVW1wXsRVbzk3UTcrf+Av
         qlulcr9TfTcOA5W1cMLWMo76X5sTSFD1l7OLbJaPu6OLhYweZU/lnb+iT9cy7KHKjzy5
         39xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855035; x=1762459835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Qp65v2XVpj2mbgYoCIcn74lwhNS3G3VX8VrR6k2zs8=;
        b=si9/tRMRnl/S0jHgwM3ICPV0PbvFIlf7jDptgnWrDsVrRTdfU6Shvy6LIkRU6zsCr5
         UmNm+1xa2U7DO+2/LOq7zXmH13y1lOeOtHVy9KzKRq4l3WGh1zFCDgM9krYJGW+pi8+j
         HrS6VofopM0FKrCmK+8/weHIFOnHKukQ/47/ZOdculasZbrNPQj5H7OdePkVpRFpg3ju
         vcj7tgeCyxSELYv0nuIm7fHsLP38B+ba2gWWUYPO2uNFGDwYEpQqvLDAD1hug0v3s6sq
         5vJIdOfAU3t5LUgtA+EWN4vPdBVlgEVruUu9CK5VQy+XdQbo1R8WrPk09JhP5tytOjKb
         s8Dw==
X-Forwarded-Encrypted: i=1; AJvYcCU0X5Hqb9/LBUCzoDxYcZXmMPwEZ28c4pej7hBqdb0W5AzPI1vO5SvfEifbyyP3dcsAcmI=@vger.kernel.org
X-Gm-Message-State: AOJu0YykpS9/CedhKAkvuhBHPGZk9QaqUlkmETwosJKOtk8PUjwSCAgQ
	3u8z9OyID936PpqeaHK51wtAO5NDCeYzTvOfO3E/1zsvbywCmN2RjiCs4y3YzcOnxVncC6rxJEk
	GHjSsgg==
X-Google-Smtp-Source: AGHT+IHtEBN2FzRvx/PBMIz+g6mN5JL6fejVbo3/Jj6z8BZ8mwuwi1S8UZTxug0dqnAA2vI1WFCMGP+gtTc=
X-Received: from pjph23.prod.google.com ([2002:a17:90a:9c17:b0:340:2aef:8b01])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3842:b0:335:2eef:4ca8
 with SMTP id 98e67ed59e1d1-34083088cfamr1279023a91.33.1761855034597; Thu, 30
 Oct 2025 13:10:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:37 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-15-seanjc@google.com>
Subject: [PATCH v4 14/28] KVM: TDX: Use atomic64_dec_return() instead of a
 poor equivalent
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Use atomic64_dec_return() when decrementing the number of "pre-mapped"
S-EPT pages to ensure that the count can't go negative without KVM
noticing.  In theory, checking for '0' and then decrementing in a separate
operation could miss a 0=>-1 transition.  In practice, such a condition is
impossible because nr_premapped is protected by slots_lock, i.e. doesn't
actually need to be an atomic (that wart will be addressed shortly).

Don't bother trying to keep the count non-negative, as the KVM_BUG_ON()
ensures the VM is dead, i.e. there's no point in trying to limp along.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index db64a9e8c6a5..99db19e02cf1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1726,10 +1726,9 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
-		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+		if (KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm))
 			return -EIO;
 
-		atomic64_dec(&kvm_tdx->nr_premapped);
 		return 0;
 	}
 
@@ -3161,8 +3160,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
-	if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
-		atomic64_dec(&kvm_tdx->nr_premapped);
+	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
 
 	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-- 
2.51.1.930.gacf6e81ea2-goog


