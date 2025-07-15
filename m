Return-Path: <kvm+bounces-52474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB97AB05681
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63F83189730F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B072D8DD3;
	Tue, 15 Jul 2025 09:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KCzN2zts"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90822D8763
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572048; cv=none; b=B58TyImHe1XDZdtewIaRGPyD0+lXwGP2L3d2+luXqr5qjTzdxd/EoZ4T8V2N3Z83Dxd4t05lJIOHk93meg8jDfFsZSQzIBUXWfp63rJfvd2BcHKYF0tuUG2w7ggY3BpGQ4dq3KL2b7dh7e/Ix5XGjimiq7bRX7x17w84ALWyq90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572048; c=relaxed/simple;
	bh=eAbMIJcHK/F51o9nr4guiznjnDwffZaDRzSajhDolHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uZuaxQQKTrVbI0xHU+BSr1D2BdUa9TAJNtUSLrHrDb6lxE/1a7bDLE+UlOGoSOVifsiqtS+VsTFLJDmS3hEVYlwOAm6zSJqslbJpqxaTVqHhvGkDQpFSxZErFvyivDm7BWMCMruVHUye9JHoYxsrn5iwynGltxTFZNlFIf4sTRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KCzN2zts; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a6d90929d6so2356079f8f.2
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572045; x=1753176845; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7j61AiDEYKRdqOr/Xh1CHmy2PK2pOlrkOryB4JYpx5E=;
        b=KCzN2zts9trPwtytLKas7+xJAmHLc5d60FUCvsL+pdqT+3NxrPmtixW+RfhiouVDil
         i4ZRZEgxED4lZyyxiAriC22J4NL+L4pXDHDRlVz8a8z+SeuwrRv3ICf57jzwcveNVyx3
         IVa8jkU/WDJ7ubebK9ofUOFfr0Y/kDVrrGnYsh2tFv7ITivlDSj8MEO3NNOFaKGg3LUd
         Vr9nZqVQJ4S4NEZY8QdgzSwTfeEOj/FG8xY++GeEOykwNCdQgXlyw84BusPp9xSGqF5G
         dm8CNGgZRmxlOwcpOBd0M/wL/xToGh5P7C1ZtvzARXL9aqlmfvc8MWLBzZXhEDjVfvEb
         JbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572045; x=1753176845;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7j61AiDEYKRdqOr/Xh1CHmy2PK2pOlrkOryB4JYpx5E=;
        b=azcbB7YTHnE/yHH9CXy0Wb5K9vOJvPaBiyee9cXPocjTXp/mgGC5jFH/rW++dn0qGV
         4fe+aPgo9cP8xTBaKLszwQUDtrpIQYBoVrikVodomrJt34ukjI4d8w9ft1dpTN/DIXQf
         WKl6ioKMUQjtFZ7Y1OC7n2esRRebg/mpjaPKqc8fQ7W682fCm7KAc+ziPXN6ere5qECl
         26t1/lPBb4MdOqF2UmnmxFBhXKZnnjfGDT+cB9EpITifsZM5lnaqqrzAZc0Z7inaeW1l
         cTL/NEdoUoVUIQSQtV1FMLOjOvo5zbzP+QziPj9yu8/4FosEMT7JNd1fLox1Caq9IXbl
         nycg==
X-Gm-Message-State: AOJu0YwO6Uwqfnq0JXPE8JyxGDX6Eo3gf8tiTRcc8KMoLU1cZvTh2kcB
	bu5ZGaFmE2dWfNfYMDuYTvXVLWGX+16W/8fnIcNnT7juKZWxmyGgfuL5K4FVZyfKUcWcE5TOjLG
	YhOQB9gHhXfZCElKrXFWHiQmer3GfXvAktN2VzA7LytKoj/8+9Io+Z6GYxHmT8WNArr/J40E+zO
	17fkG5ZIXXeNKBzgNv2ydCGaOhevU=
X-Google-Smtp-Source: AGHT+IEOvr3wyT4KsjEFui8u47n6x+FVFq3D3Cl0DCM7gD+8djYdie0rM5VY70PS34cmaOF5B34O1xWZrQ==
X-Received: from wmqe20.prod.google.com ([2002:a05:600c:4e54:b0:456:43c:dcc3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:200e:b0:3a4:dd16:a26d
 with SMTP id ffacd0b85a97d-3b5f2e0f727mr11480418f8f.38.1752572044316; Tue, 15
 Jul 2025 02:34:04 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:35 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-7-tabba@google.com>
Subject: [PATCH v14 06/21] KVM: Fix comments that refer to slots_lock
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

Fix comments so that they refer to slots_lock instead of slots_locks
(remove trailing s).

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ed00c2b40e4b..9c654dfb6dce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -870,7 +870,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 162e2a69cc49..46bddac1dacd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -331,7 +331,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.50.0.727.gbf7dc18ff4-goog


