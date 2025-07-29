Return-Path: <kvm+bounces-53700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8694B155A1
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 679A93AA387
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94D72D5C74;
	Tue, 29 Jul 2025 22:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DuxDQcIK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4492D320E
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829767; cv=none; b=hEjZ6ka5E6FcJTUAejMGa38jZgRs8uIO+4IdQ+Xc5ERALVmNixeLbazPPPkBgFpJ88r2W8s/tVevXyB5f8A80gCpC9Kb8ReQJSKO/DqFQ2OddmLFoM7vgKdeO0vPj464sj50EeY8cbDds2dFu4v79IP44UdgxXAftXDn6OeVOQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829767; c=relaxed/simple;
	bh=FDS7h/17Bf9zVz5r9O8pE9JWmV8y8PXqVP5l+lc/jCE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XTtih+i9HYROeWpuVF+YjsWc6xkJT3T5YJc3Qqle20QEMbUIyshxbJtLMxvBqvh8vmaDEYPIChl5n3DdOZJEtxRyiB5KYivdtcWKi5TduCeInCGMLBsiM1c15YRU5uBBNl5pAzYppbn7v/9GNBQMT0HpJMl6oYHtGCZBQNIo0Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DuxDQcIK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so5960076a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829765; x=1754434565; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wF2h8ScGoC7OanPGG/hP6EWf/t8cFJTqDkywcYBe2kU=;
        b=DuxDQcIKCJ/UYfMLJfn9vIAmZXsarC6MIRYE7jxGf/egl63tClupExawf1K8vb5hcw
         nRS1K4hIkGi7tmsaNLW7WlP4IPhClAFtqzuCjq3oWa/qRfm1+avmgtYW18SxMnkEQi0j
         YwKEC3jjAb7FeIXdx1/QD8ifXbARtGeOXqxgMHRrt60QqQfsJ3ao8SM+cMa1QqWxgxny
         RK1dh3uzTDpYCgxR524yFHQZRJKEDl6Tby9fzMt1ZqT3saQ6/4MsaoqJBMsJEf5Ucwyz
         bWOexWCe6QhnP7+Ja6fYWylGpHwJcTpuPsBUcusLfYclagxp5Udhss88mGKt+FyM2Mgu
         9dFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829765; x=1754434565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wF2h8ScGoC7OanPGG/hP6EWf/t8cFJTqDkywcYBe2kU=;
        b=cbsxbMvJONApAdSugJBJd8BO/J4zlhxzGVVzpZ0pPSU3qfmIWT2Gag8Wkj0S3+rL7c
         uIU6HJVMbo/PQswSs3btDpo5WFCQfXQByW4TbCEF34iFCNyX4h8F7diYPkqvsZJih0Rk
         VXxZ0+SC1+t5eNXTAJvBHoei/KAkVLfp7hmTGiGrosNGWIBOfoKkbo9A5oY9St3Gipr0
         IOZaLAUtvx/94wkRC8MQlKDud4l3xPNoGQRKrIguVCOJu1CdFlzbNeCCVm5W5EH62Q5P
         jQQJReuK/Bto/Q1/EGjbm6+8ftUtb1/nqF2OiasxAag90LAR3Tod7RppmcgXfYOLGgcW
         a6Nw==
X-Gm-Message-State: AOJu0Yxsb6HNxfPlGNSIqPA19ugccl+7lmMYJXdd8yytdCoIfLmyrmIr
	ThcF101Pif2BtKa0zfWt1a9evPrPPNEJt1F0YGP6hybrFGgOLdYeVb1BmR2phsSwNR8jBAa8gXT
	RIMg3Mg==
X-Google-Smtp-Source: AGHT+IEXfNMzWFuUnpYP1cCz6K5G+b+u3Xc0/pqStPWs0koB9KyFWEn1m6GJPyVim24B5D399fJqjTxhm1s=
X-Received: from pjyr14.prod.google.com ([2002:a17:90a:e18e:b0:31c:2fe4:33b7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:562b:b0:311:c939:c851
 with SMTP id 98e67ed59e1d1-31f5de2e6dcmr1392130a91.4.1753829765637; Tue, 29
 Jul 2025 15:56:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:51 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-21-seanjc@google.com>
Subject: [PATCH v17 20/24] KVM: arm64: Enable support for guest_memfd backed memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

Now that the infrastructure is in place, enable guest_memfd for arm64.

* Select CONFIG_KVM_GUEST_MEMFD in KVM/arm64 Kconfig.

* Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Ensure that
  guest_memfd-backed memory slots on arm64 are only supported if they
  are intended for shared memory use cases (i.e.,
  kvm_memslot_is_gmem_only() is true). This design reflects the current
  arm64 KVM ecosystem where guest_memfd is primarily being introduced
  for VMs that support shared memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 arch/arm64/kvm/mmu.c   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e0..bff62e75d681 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GUEST_MEMFD
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c82df80a835..85559b8a0845 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2276,6 +2276,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with mappable memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.50.1.552.g942d659e1b-goog


