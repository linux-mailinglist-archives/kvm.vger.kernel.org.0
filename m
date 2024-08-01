Return-Path: <kvm+bounces-22900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBD794474C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09F51285B1A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC1816C87B;
	Thu,  1 Aug 2024 09:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ihGrjVEy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7C016EBFA
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502885; cv=none; b=sTApaTiC1w6jGvH1nQjQPX//iyYueLDUx1xq5BctH1w1WnuKQM/Kgo30qiZU3a84VtsSna7XIG13lccfrq7isuWinoKf9++R+LYV78tkSt9uQqaYkGmTppJX9TzpQ9c4CpJbivPVV0P6jRJSFAXNmcZQ3idVpqOtKJvND51xcd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502885; c=relaxed/simple;
	bh=HhD/ECd8uGqtdbqpkSn1wxM8zfqN3I3b8kecNolsv+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rXoWRt2j2ed0EhxUuiYHE1O0aN5sq6blVaUMHG/SezN2btgdATT0KSOLIuK1gyQgcbhigoxG8Q5azJ1YuPqce8GtYLcjUD/KIx0JZZx5l0iVjawJ9cKbeGuNO83WPF5Zmw+vfCQWPq+VWsyFn1wolG0EVrZ7ixG+SQpovZu3R/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ihGrjVEy; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66b8faa2a4aso137919977b3.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502883; x=1723107683; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=55lqFFECQwDLNrYt4aytrJso1NybdDvPLt3jS/2DBHA=;
        b=ihGrjVEygGyygmgVLBUu48sf0XqGZzKC5rM0VOzzrWZNhB2hyzNOLX3Fa91BCHFojY
         MN4Bde/mdGQ+cB/TXegDB3lOaRGTcjsylNwi7lZFAsrCroqbJQGwJbw6bFe0kbo2C5P+
         uLQOwX4E1wAglZrnyi+6GI7lwLxsVme3tkFeOIvxh66iuU84/SQhXeojF5DM/qNWcTuK
         Ub/K0n3aOkMDH2a/ObrsmdZzQ0iWnivpSlMzs5Yk2R8hruMOCMVVayJHNWgfubFFnkNW
         SaeMOhJ9bgeEY7LjPTXxSLQ+fpoQPpd8H+ivcRl0+uoyaglX9qMhSN4hqJx66+/kLhIg
         uHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502883; x=1723107683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=55lqFFECQwDLNrYt4aytrJso1NybdDvPLt3jS/2DBHA=;
        b=m6fLpqMMfBYzC3ZpLA5deyOVu24s/VPwNJTSICMkxIwQt660icn9oVT9/sVOuUSKKB
         P0bn+0iKEp8GQHOtsQfGPmHzZrynVoK4O3R+EirXD3W7KyByKDQDGVn52JBRSQM2Zrha
         lkvuF/vNHbt/wtpaA5hBGD1vIbN/eiKxGigPgHLpbVVxhuvHRKjJtHnBaFFVR+zdzm5M
         Acg8mkb+W6UMikFIw/7DM23fx+MGePzhYweU2RyygEj4YatHY1oxH2N0GVyVVZFjyw5s
         8GhAcPYk2R5VMr4vtG4VJPllgFSGGY0ApRXcmcG4HGenIh2izC94+RZteNXFbV/Wy0B9
         vKKg==
X-Gm-Message-State: AOJu0Yy5SGJbvqtPaYnfz27gj5bSVWY2B83+2hUnoQjrdxOrxdvGHD05
	Qm8M5ZR1imUH3bvihtPFdXEkK/CiqI50wjqazqIK97FGWQOCj/0nqsRTpTnbThvA2Gn1IGwzW0D
	htKanR4ak+1JgMxKKL25tiv/C5C1a+ygyprh/6ksrY0W51BDMCJUf7KQN1dbOB9Jtc2rnZ2eN8Q
	xQ1xbzAYpT4VmbBf6l3eGTf/M=
X-Google-Smtp-Source: AGHT+IFXjhPCx5Vb6+Hy1aNGDM/3GXCZNNlq0AHfSY4+hcUlvoRXu5eLes4iJzd35wbNh934dQJX6BHp3A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:f05:b0:648:3f93:68e0 with SMTP id
 00721157ae682-6875028afcamr1291237b3.6.1722502882722; Thu, 01 Aug 2024
 02:01:22 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:08 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-2-tabba@google.com>
Subject: [RFC PATCH v2 01/10] KVM: Introduce kvm_gmem_get_pfn_locked(), which
 retains the folio lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Create a new variant of kvm_gmem_get_pfn(), which retains the
folio lock if it returns successfully.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 +++++++++++
 virt/kvm/guest_memfd.c   | 19 ++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 692c01e41a18..43a157f8171a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2431,6 +2431,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+int kvm_gmem_get_pfn_locked(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2439,6 +2441,15 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+static inline int kvm_gmem_get_pfn_locked(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, kvm_pfn_t *pfn,
+					  int *max_order)
+{
+	KVM_BUG_ON(1, kvm);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 747fe251e445..f3f4334a9ccb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -482,8 +482,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }
 
-int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+int kvm_gmem_get_pfn_locked(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem;
@@ -524,10 +524,23 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	r = 0;
 
-	folio_unlock(folio);
 out_fput:
 	fput(file);
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn_locked);
+
+int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+{
+	int r;
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, pfn, max_order);
+	if (r)
+		return r;
+
+	unlock_page(pfn_to_page(*pfn));
+	return 0;
+}
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
-- 
2.46.0.rc1.232.g9752f9e123-goog


