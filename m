Return-Path: <kvm+bounces-49053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 490F9AD5733
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65E661BC0E80
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25DF29ACF1;
	Wed, 11 Jun 2025 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ggIFgvgt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F88E29ACCC
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648827; cv=none; b=kPAAf57EfYcAr9OvdD3G6GXGxvEZkqF5+8P2MDAMJG9+3Wx9xgZMrUTvsk57AU1azguHAObCdlti3GOAuxWRjYHzYj4AwaCDNth6+Sp15NfEeKBbSHcBVKACYyoPKZZNfAO7c69uTnbvVgG+FOzsC3NV0EEHPT8YI/woWkVO0z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648827; c=relaxed/simple;
	bh=YGKWeS/02fp1ZvntQjnXiLE+15TL6ZwC9xQKq/URy3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SbYwvwuoNiEwfFe71j3umuGKJt/bDe4SnxibKxC7QxHDs0eOVCgt5FesuX1h8j7j4TSZIzSBhmdKqPAWIY6Cqg0xlqunEbrgl3NGJokfUb2JHMK1+t2y8/WFWUDh5z2V1VbLUkIF/PdM98FpFTJZZfRfakgTeJF/VifYMlMcxfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ggIFgvgt; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-450d6768d4dso41977275e9.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648824; x=1750253624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8aR8d2ohKDYUtwqlUQwft9/8cX0oCVtZ+VCOgpKfhcs=;
        b=ggIFgvgtb0U3D2aPVezV0lZEo6adA196EhwOLmg1ftZzOtcL46leWZnpKHPIHy4Sv/
         quem/WtKwy49sROiAupVA2x/tO5VCWDn+SxfeKrF9zZ0zVtjXoPT7ROgPRcX/vfo6320
         dpdJRfuScJl9lwGj+V/xyOrzQ6lQ8EdP6MN+suRNzYGmq7uOkRWcyaLjtLjVDkBNyAIV
         xN15cuiiJIhqmIqhs7vu2ZmBgBXJYw9h2r7WK9lSNetK27ZIZQ6qs2LZd7NZ888PFZai
         +NWxVYnPzaPMdfPLdxLwNrlmagvB/OpnwQiwhAo9+8nB1mke2DQgCQSB8XftUmsROYL7
         OEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648824; x=1750253624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8aR8d2ohKDYUtwqlUQwft9/8cX0oCVtZ+VCOgpKfhcs=;
        b=qlfyxGVFK/BbN6yVmE37mMybBbJQ7fFMIHsL9l/3NCrmu67dNTMeqgxEKSfcZKicKm
         9P/+XXoyE4/GNrwO+J6dMs1JK6u9KouUnT1xfqB86UAvzcJZXV4jiCaHgejZqctuJehq
         yAJdvzB3hy1UWuHYNXeo/iUVEC9/ti9rS62Ph+r1qSOIKPKu4YGH1nfaQxufd0XGfLAz
         cucGWD44ysj8ouG+8X0pUWOr5FTt9kSG6Qkw7ORUkdA6vLZsQSbyHhxb9GW8K3gtY+Vt
         Wx2tpOUCMEc3Pls196I4ld69nMBulTkWWrcQUC0vrHDqitiPI415pSxylYqhG0MtBQ5d
         WrfA==
X-Gm-Message-State: AOJu0Yy0aDMWT/pV3ZIaWOLs8n9bGFBOfiDXIgE9QuvTpvyG+6nRqEiz
	yrBmyZtRtXFrVVYZyfjBTrDzTD5LAQzztHkMTr+2QGQ3NYSuiwAUYOLopjifUP8i9a/VU2u262c
	9N30+iw7FYlowOJkoDW12DUTJ1Tw2DQ3i72isc6eNz0p0peBf0oW09/FN/Z/RKVB7Eyi4fNrwrN
	4IX0KAvwm6ADcIxhYIDVyXE9FmBno=
X-Google-Smtp-Source: AGHT+IFCb8jHeuPCB7LEmI7avFCyTPGfgQduPiszdiF9PVCb/8oC0jpiLuFzDzkO8e+SWuappNsS6C6Y4A==
X-Received: from wmbez14.prod.google.com ([2002:a05:600c:83ce:b0:450:d422:69f9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b9b:b0:44a:b9e4:4e6f
 with SMTP id 5b1f17b1804b1-4532956d50bmr9767915e9.16.1749648824195; Wed, 11
 Jun 2025 06:33:44 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:18 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-7-tabba@google.com>
Subject: [PATCH v12 06/18] KVM: Fix comments that refer to slots_lock
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
index 76b85099da99..aec8e4182a65 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -859,7 +859,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6efbea208fa6..d41bcc6a78b0 100644
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
2.50.0.rc0.642.g800a2b2222-goog


