Return-Path: <kvm+bounces-51914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E3FAFE6B0
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 355C41884A56
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD3229117A;
	Wed,  9 Jul 2025 11:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y6Kdf+gq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7984B28DF23
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 11:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058807; cv=none; b=GkcQKR03k82XnsOFHgSzq3QKd1E9xIq+Zc8jms0aPq1K97uyhbt5NfOSOBWHYSLTA9pRB1PXHR3U/izzN0CDNoHRrKUepl1BxILcJEmRCLjK8G/W5Y+e6pUPKTTraV2gSy1HPLCXVETMVA8Dj5qsSsqXfK/w0YOBhvDwTFphP5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058807; c=relaxed/simple;
	bh=aLq6w6iMVx9A+GXdrTT+UqPhvEMW4mi+b5uKE2VvZds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qWb36BNmm0dTLeuR20oaDfvXw0MbgAPagSjBMLeb2ORYiMqKaUHhwyyAhsuNZbEg0ixMIIYSra3IAT9OZwIRo69CJB+FEAJCnKGuveiCIV+RWJF2f7C5JAMAf5jaudxHFrQwFKg4FcfnpZbSCs468qS9fMl54lmUv7w74LvrE+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y6Kdf+gq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so30682845e9.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 04:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058804; x=1752663604; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkuKuazKKizZ6ZlT9w9fSwNujhSChJOs2f7h5A8NbUM=;
        b=y6Kdf+gqZN9ZXNPFBV4/CwTf/+FPbtV64JDLtK3bI15sdUsvYaqvBl9BaZFdZ2N4+n
         ZAe8/KhB/woLGMCWNqBSNTfSD0SGkqf2ik85YfNZxcvcfsWBrO4khwPNxElJxaVFi3Hu
         YFs0semuWaFUldle62vflUf6p+KwoijUeX4tHzAivhQ0YmBhwn1JjNRY6P6zMeY1HffB
         eZuQilbM7bRGEQqkrYyFcagFQXT2XG2VMe2bs/B4f+7PJHYNpabsFDOYTBOcpeoeo0z6
         NneaMJwLriv1T0TfASvLWKwHh50fU2/+V1sIEpHLCdeQydFWUS1wVu4k2V/bc/bA98RQ
         S56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058804; x=1752663604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TkuKuazKKizZ6ZlT9w9fSwNujhSChJOs2f7h5A8NbUM=;
        b=czzEFZ8htes3TkYiEFoudIT8I3lo2P+XFz/6ABsp5wOdLTN06CLUo4Yavmv/eCLUzC
         jNRbzJUcHu/R08jRLF3Nq1YX/rwL25CGrJ7gJxsvLiUTq5EDReobbaOfXk3mIaHV4V9M
         09Ugtv2+5pCFjGC1pqMcgAGScx1OicQdXvcEwr4oGqwHJ55HrqZ6G62ibCjhKtaYihao
         Dx90ryiaBV6hewO86tRku98BwD0EoThXBJdPys0bDUSitY7anLh2nrEhGluaTc2QY+KK
         /mZ5AHAvyMNISmEl8bTaL+QFf19ZP4E5bjwna9+ZKMGezx0+cqR36vE7P8yDzJ4jvRMs
         8rMw==
X-Gm-Message-State: AOJu0YzD2jElomBxQVCr2o8TooIlkKd1z3fE7dix3faaveawLKXjPyki
	9edn66G36NqscFaB/UDvDet4wiGnma44zIDx5HSeDattO0t+RrgVMQO3JXCQqRERX+6NjiBIEsJ
	6+Pd+jj8hAmZa9Hx0zm+B7BmyLArpuVDvJm3xuRGtctId2PIgsU7fh4sULbXbzIB+cNyrtx/PIx
	cT/F1EAeTzzOzlOAL+7xeQY5gubPI=
X-Google-Smtp-Source: AGHT+IEHcK0/eYhpImfsFIrZ9G5hwIe5rWA1tVA/tSDhd6ENx7b4ZDeNGv0Vm2z//tBc+ZaDxo8/tozz+w==
X-Received: from wmsp42.prod.google.com ([2002:a05:600c:1daa:b0:453:65ee:17c9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4746:b0:450:b9c0:c7d2
 with SMTP id 5b1f17b1804b1-454d531e5b2mr20392145e9.11.1752058803467; Wed, 09
 Jul 2025 04:00:03 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:33 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-8-tabba@google.com>
Subject: [PATCH v13 07/20] KVM: Fix comment that refers to kvm uapi header path
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

The comment that points to the path where the user-visible memslot flags
are refers to an outdated path and has a typo.

Update the comment to refer to the correct path.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9c654dfb6dce..1ec71648824c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@
 /*
  * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
  * used in kvm, other bits are visible for userspace which are defined in
- * include/linux/kvm_h.
+ * include/uapi/linux/kvm.h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
 
-- 
2.50.0.727.gbf7dc18ff4-goog


