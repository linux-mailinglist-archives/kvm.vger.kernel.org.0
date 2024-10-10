Return-Path: <kvm+bounces-28544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 447AA99911C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 746F61C25420
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8731E20FA81;
	Thu, 10 Oct 2024 18:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GNF92OQx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5993420C495
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584835; cv=none; b=pg6t4Tjz8lGOX5HKTk1S99DzPwbd27X/rjNZ2XwyAW56FktO9ctzwSeJr3TTzPTlRrFGzewJxSFaODaT1sLURoibMb9m+R7IWdgyiQL6xEZD+3dywOK3KDqwj6yEwuYPB+5StoystdKisICHDVCqMUAdVl1TeDT6gbNSJNukeKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584835; c=relaxed/simple;
	bh=+TpPAbVVI1obWW7OdvHKpXsCMwy9+BV5v8TfW2u9vbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kCMiDNio8VnqaackX8RE5gq3fxurGIeGii5BjJpICE2atjjBx3Ajjaises4Ozin6+LGcDcs2ChdyAKG8xF6SHVD0QhXWjfSpNKmct2WRYsNTN4piL86PKl28WC5tCbZd4pWZvzzu65sMG2u01MReKt9iXLgwC9ewdc7X/7ozzMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GNF92OQx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2a013a01bso1335887a91.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584833; x=1729189633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3FFUjrr9Bcuid6sLVD5OEsWVTb8VG25P9bGjkNYbAzk=;
        b=GNF92OQxF0tq2Sy3NXgpLFxQxC22Wl9tw03n7HzL4JrVAJCkh+Hov4DvKeVAkbLbz6
         guCgfWZA8nqZBp6XZ9pJ4Hawa9uVtgV3UErDEF6u0+OBm51ovt6v1pRCPWJe2lNSocFb
         9IG5h2poJKL8NVnbhGa7Q5llq0RI6iyjaleF9SNYfF/o/fNFc2aKi+UykoVstbZ8OxwU
         d1wLhivyUM4mbES9K28ITC9CcdOVPnfsFw6ARgKHJiVEHnES4HjeBBPrQzXn/hChp5jb
         ncyckAUOmfR9C543A9BJWxeDUS9424yzgfnC3W2p+8MxlZym6ly+BGplBaNU9k30CJj/
         w62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584833; x=1729189633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3FFUjrr9Bcuid6sLVD5OEsWVTb8VG25P9bGjkNYbAzk=;
        b=flfw8JIBIDRbkW8kugIjPI/8lH9xWJyF/WJxbus8V1r+h4ucdkPyk7fCKs7T2QtkZo
         444EbpTEG3M+IjgDR12aQEBq0ORxSnJU/Q3gtLFXFtcVwckJgl8u79q0qodOfgPFp1qN
         LxQvVROIxXq36Bi8FfnfqOKhfsXcLLvPimmZ0hinYI7qlGRkItQJTurjIx9PlTz5hXl7
         0u0dQIXgRaVVU6dN3iPX50UwrOrmvLdkJbks0BpKkSD6hZWLHT1rfNQbAVT7PHeJLOii
         Y1F06dY9gPZutf3sftcj6dDEdBikByOViIKBdxs7c2V6Xy4yt+EQ+5y+xZObiQt6zkro
         UK8A==
X-Gm-Message-State: AOJu0Yx/DLo7F5ORCMhjby1S8o7E1CaWiWKSS//y7bLNtESbLoyqzT3i
	GtbA+QIqSp9hWdgGQMyqHblP/y0XFO3PaFsO04d/T3puM4QyouZX+jfRyILm7FpH7xf+C+DcdWK
	p1w==
X-Google-Smtp-Source: AGHT+IFpwqxWKAWfrUvKF1EatvnBv5g5CrzcpgT/ZTuiTODJnzoCoYK053S1MFwF0WyL9wI3LVhDYDAiv74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:46d4:b0:2e2:e148:3d37 with SMTP id
 98e67ed59e1d1-2e2f09f1a56mr94a91.2.1728584833102; Thu, 10 Oct 2024 11:27:13
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:09 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-68-seanjc@google.com>
Subject: [PATCH v13 67/85] KVM: LoongArch: Mark "struct page" pfn accessed
 before dropping mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Mark pages accessed before dropping mmu_lock when faulting in guest memory
so that LoongArch can convert to kvm_release_faultin_page() without
tripping its lockdep assertion on mmu_lock being held.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index ed43504c5c7e..7066cafcce64 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -902,13 +902,13 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 
 	if (writeable)
 		kvm_set_pfn_dirty(pfn);
+	kvm_release_pfn_clean(pfn);
 
 	spin_unlock(&kvm->mmu_lock);
 
 	if (prot_bits & _PAGE_DIRTY)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
-	kvm_release_pfn_clean(pfn);
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return err;
-- 
2.47.0.rc1.288.g06298d1525-goog


