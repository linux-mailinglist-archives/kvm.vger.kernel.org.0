Return-Path: <kvm+bounces-39064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E50BA43166
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:56:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E64937A6C9E
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1D421019A;
	Mon, 24 Feb 2025 23:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1VVQeIWj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3312820E019
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 23:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441354; cv=none; b=r8V+TrrYCpnELXBhwyk9s5Q2/lDZwOHluVCY4gizgnzU0+qjiTSHWSuub0e8u76QonDQtCeZ6XrvNvGo8tFyJlEoaI1z2qVmNLRjZqZFuMIyrJgzeTFoErnoukOIXUo5g4KotyDcxVZoHJFHoPFBU5Dzd2EN6KJbWDGFnTY35Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441354; c=relaxed/simple;
	bh=4XGt0AThhPQKODAnl6NTLZpfJZyUD3zLteURrvwSqiE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fmtOjca7Y1zcBFvo/N1IQieUxNdAxgW2Fp8go8UtxCje4ER7092VknGrQ6UP+Sydgw3itjUaQxFQYSb184ApPrZda7+zd3+3eqbXjnFwgEb7RmvXQx3grC6HhqmmLmReMzOLrWg9nB5h4rQZILLkeSODe4udd5zMDw9pXSMCELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1VVQeIWj; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22114b800f0so44029595ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 15:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441350; x=1741046150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cX82JgrIVLcCgP8NY5WI6d8YhxJG+M3Mihkk6f4MOJg=;
        b=1VVQeIWjxHwt2g4y2ENuwGV87HBOsTKycjXrHxuNsxbqK3Xnd4EBQ7ffAT0joI1hk8
         wrQB4botKcLivVa9uGIp6y5+4keNqsOt2B6P8uL6ZHqlAcz0OPsU+YbkWVICfJvfdRnx
         KwCcS9Rqd/qbRBxp+FJ8vn9MZca0kuqbjBhZcyHrVr/M6vMbSFV9ut71QR+j283+JPzt
         gYnGx3MTgiAMQneYDmM8pZM3+xDHuU3VhtWfZCL1nmmahdUlg3mss2g+VIieu/dsQ8nD
         vDhdk7N4Us0FJkn/VfTv2Sj/k2yURUXtxWEvHB/M8FrZvx7BhsHQnuVdv/WzYTNNB9zA
         kGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441350; x=1741046150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cX82JgrIVLcCgP8NY5WI6d8YhxJG+M3Mihkk6f4MOJg=;
        b=lem7SmQD72qFCeOv2IhGF6nHJ8x2DX/G9TYGbCfS3OO5/L2Jp6hiVvPofknGJBbtxW
         a4LDEKttgRqR4YQzKrnyCAYmrSc0SMr3omdRi1542dQUOnWqUwB9OTa0qhvB/9s8snSp
         BgNmzRCPFb/CcfAVSJCxg3/BpMvVDXVrB6OEFpzzoVJi23mcRgXQpQhMRCIBI/TLXcGv
         pKVrMDAhTplMiIt+QgRXMaCpow85QYIR2CLZdcUmWD74ELNFg1XRsQu4RbKgs9b0wG5f
         o8Sb2U5xg+Ug7Kb1vd/HoeVkY+ovYoRkJgvY2CVjlF2qr2e4QjRM14nSEbV+6FG796+Q
         dOLA==
X-Forwarded-Encrypted: i=1; AJvYcCXVAwz/Do1azBb2+12m3iglIIFia3SBSI6JHmtcDDl3H5hoCVSQhITInRNHEuhar4Fk8yo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1DB9UW7qOoaTrBXdcIFrNOSJ0/AKxblvxT2EvkrSP39MboqQa
	CgU4kDscBaoncB17PR1KLgFyiMmkCZU3XNOaZ11skGNJWu3WHpy0C/a1Iw2qP1IjT+fDrAHmy9u
	9lg==
X-Google-Smtp-Source: AGHT+IGsyGC9C+MeujnUnW2nPba4jsQ7IgXXOkNko0b7VAiFOZ5bP8OY6ummej4/xlJQLwWUr2RcXaF45Ig=
X-Received: from pjbse14.prod.google.com ([2002:a17:90b:518e:b0:2ef:78ff:bc3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f8d:b0:220:d81d:f521
 with SMTP id d9443c01a7336-22307e72198mr15100345ad.51.1740441350608; Mon, 24
 Feb 2025 15:55:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:38 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-4-seanjc@google.com>
Subject: [PATCH 3/7] KVM: Assert that a destroyed/freed vCPU is no longer visible
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

After freeing a vCPU, assert that it is no longer reachable, and that
kvm_get_vcpu() doesn't return garbage or a pointer to some other vCPU.
While KVM obviously shouldn't be attempting to access a freed vCPU, it's
all too easy for KVM to make a VM-wide request, e.g. via KVM_BUG_ON() or
kvm_flush_remote_tlbs().

Alternatively, KVM could short-circuit problematic paths if the VM's
refcount has gone to zero, e.g. in kvm_make_all_cpus_request(), or KVM
could try disallow making global requests during teardown.  But given that
deleting the vCPU from the array Just Works, adding logic to the requests
path is unnecessary, and trying to make requests illegal during teardown
would be a fool's errand.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 201c14ff476f..991e8111e88b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -489,6 +489,14 @@ void kvm_destroy_vcpus(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_vcpu_destroy(vcpu);
 		xa_erase(&kvm->vcpu_array, i);
+
+		/*
+		 * Assert that the vCPU isn't visible in any way, to ensure KVM
+		 * doesn't trigger a use-after-free if destroying vCPUs results
+		 * in VM-wide request, e.g. to flush remote TLBs when tearing
+		 * down MMUs, or to mark the VM dead if a KVM_BUG_ON() fires.
+		 */
+		WARN_ON_ONCE(xa_load(&kvm->vcpu_array, i) || kvm_get_vcpu(kvm, i));
 	}
 
 	atomic_set(&kvm->online_vcpus, 0);
-- 
2.48.1.658.g4767266eb4-goog


