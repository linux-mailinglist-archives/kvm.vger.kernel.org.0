Return-Path: <kvm+bounces-52766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A427B091D3
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 023617AE148
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A052FE383;
	Thu, 17 Jul 2025 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KbYByOdl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B32FE39C
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769669; cv=none; b=U9Yp6pqsGV+pYUQHHWJrnjJ+v2/NROtXPU8235IcpxUachu5S633Cr5L115wXJ6eloE5//6cpd85FlEE9o3YedtPECK7eFBux876jrNP3FKyChnMNPF2IYf57vZ3OUqUmJEaKVsDLGv3b358rX5ZUfY91xv2MnbgnYYCppvPVYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769669; c=relaxed/simple;
	bh=WCxjveG85jEEirX3+ZEjjVpqxosxj2gmLmYBllHeBRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XhtNQvRuOMsTR1kCLKcYK+beBa8DpryHzKVXDQho4WATHX0kE6xXEEF+b3u44w8wTZxXPtaWX9+YKkw1Hm5IXx58lyUpHhjQhxK/eKco1JB8XmaqmDfsoa4z+WfgiLi8VYjdxNA1k1vQ+/0kur5VM9xeJo2rnpNcp/AYDGnFI7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KbYByOdl; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so8576175e9.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769666; x=1753374466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9hcizvzxVzWO4/kQqjXHw92JJzwP/fSnU0kfx5Or1Rg=;
        b=KbYByOdlcjtMqLfSIUPyTi5tfBNItQ/sKjohWNOF1oZwJK7P1P82il3dQWLq/NKkcv
         hke4UnmdgX8rBizZENoMm6JhurgECVA/jRF4NA+zRMUef7z2dtP+3bkwQxmAaz+qszNS
         Pvg1/vGy3n55d0uHdvR0giSBvSUW+fkuyAycMXvk9GRIGZ6hkgEWKSRbpeUy2736vJBN
         JkDRsuVFMEqnVgxPJJRvJ6DwhOiyqlyJ0dfi8PW2mMpbdFc+oCJgrE49Xo+yh7q6Q/mN
         rcGrN0aYydaxWafJ2GdScwOG1IkFYIcq3ZtsPTusJfdzDxt9X3q888lWjPfM3ovRwisF
         XU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769666; x=1753374466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hcizvzxVzWO4/kQqjXHw92JJzwP/fSnU0kfx5Or1Rg=;
        b=aPns3MzZFckIBwxf1gmsPtSfxMXz7nc6o0uj+j0qz2pBIZIlYfxLYiWE0sZGFnGXtt
         KGyHkxnvsXb/2JdMg9276cTcqLCQ1W1jXoVPKmGcOeWIqrWjFFJSClI/GLtO4/4zWubx
         KOcIG23iXOHQJXCfdW8YlZof1MJuSsISLprozt//hnw0XdLAJcYRmIBEYXLBrTI7II/Q
         T164+ak0NnFRa7TrRFOG8lxz96ZmmL64ZePf645B1rVyMeYudeYrd5t7F5HkxJyuidQJ
         ZnzyKGvk3xWxO7kOKgJCB7jnw6IqY4omeGtMLzRjnd3V2uKO5SuYIqSb9lZm88pn8y3g
         tlpw==
X-Gm-Message-State: AOJu0Yz6s7NDe9sI0tNz310gZewNTeaW1uw91W/8oc/s3nVrawBh08UB
	8BAJF+iUT6bE6IHfTFIWAGPlEADmLvm9wt6kiQuUWE6RZcoM5NgplThGGxPyQkZwcaeY5YbD1qD
	ImYey4jsveb4ynyHaG9vR335fhx6EyponI3ubstqt6A9K6LlfqmXEqFzfFIWPNZjZ1ZX1GweHZe
	6P+jD6q944/ZQtKBMSjsKMfcHdwQk=
X-Google-Smtp-Source: AGHT+IEEuq7D3nYp2xk7nCkef5mMIaWIaIcknj6Ge3ixESMVMRr3DmDdSG+66XhcfnXqgmLH5zZbYyYdgg==
X-Received: from wmqb22.prod.google.com ([2002:a05:600c:4e16:b0:456:26d1:4451])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1912:b0:456:2020:165d
 with SMTP id 5b1f17b1804b1-4562e2a5cfcmr88497235e9.31.1752769665804; Thu, 17
 Jul 2025 09:27:45 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:23 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-14-tabba@google.com>
Subject: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Update the KVM MMU fault handler to service guest page faults
for memory slots backed by guest_memfd with mmap support. For such
slots, the MMU must always fault in pages directly from guest_memfd,
bypassing the host's userspace_addr.

This ensures that guest_memfd-backed memory is always handled through
the guest_memfd specific faulting path, regardless of whether it's for
private or non-private (shared) use cases.

Additionally, rename kvm_mmu_faultin_pfn_private() to
kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
pages from guest_memfd for both private and non-private memory,
accommodating the new use cases.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 94be15cde6da..ad5f337b496c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				 r == RET_PF_RETRY, fault->map_writable);
 }
 
-static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-				       struct kvm_page_fault *fault)
+static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	int max_order, r;
 
@@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	return RET_PF_CONTINUE;
 }
 
+static bool fault_from_gmem(struct kvm_page_fault *fault)
+{
+	return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
+}
+
 static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 				 struct kvm_page_fault *fault)
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private)
-		return kvm_mmu_faultin_pfn_private(vcpu, fault);
+	if (fault_from_gmem(fault))
+		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
-- 
2.50.0.727.gbf7dc18ff4-goog


