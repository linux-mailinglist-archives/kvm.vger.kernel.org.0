Return-Path: <kvm+bounces-47811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54049AC59C6
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D9AD9E0A87
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DCE0280328;
	Tue, 27 May 2025 18:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Trx+30x1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB8C28136E
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368982; cv=none; b=UPLAEYTG649BisZGpvxXrjPyHZqdy/CFV5VUpX6RXNgZVELfAET2wASpFnG5GWsG9rCW3lEvApBcrGAQ79LoOSNkyAUqptGmE714831IWnd1E/eixPwGRqphLeBKykp9/z/0vmuqA6YB+rEg5SuRZvuyAUxYaP94VlIIMPk3cfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368982; c=relaxed/simple;
	bh=EYZFk7r1z2ql5hNYNrrRqdhAJfESDaEvZFcM+jE7e6Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X3GHLoQME8zy8/qdd9SGwoPgJwRwaxOYvL62prn+t9kXy8QaDK+9QlkIo1sxAb5iKgnbWnWkUuZ7REGVcfzKKKvWELpL/gIBu4lE1M1KAyEnHrCxnKnwFIJlj1Dx8s2dU05OSGpGy6FjARPvRbnwxMWqY/pchB0Swy5RcbVJFwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Trx+30x1; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4cceb558aso1554848f8f.3
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368979; x=1748973779; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lc19MQ2L83GFf4VOSaJH4jzsZICcJBsc7b6CwdqsbsI=;
        b=Trx+30x15U/QljONChAP2JnklE1CLGplXx61CHDzyk6kC71BlQn+4ZHkn8zFDss4Zq
         sR0om0JQWE88AVsVH/LpBD9bqGDHgvG0ADwPPbsFPw22AXmx9rlFQBvkH2joBdTkUwGA
         SYep08/ltLYFcWiai+sNcFgmqPdreYezH2E9YNpAzj4Bjw9sjnU8jFyky9SYjTME1GlN
         NUKFSHesuERb1XYaN0dlF/PuzN93U+kJnLFblNa7VChACLCNIEq1wm1uOHaO+9JrzCEv
         nkcjxccYURJ0Ekv+sxmobebUOUhl0FQ43422wgQUSZ+Rdtu1/WGbwiTaR4Zcu1kA+pRk
         h71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368979; x=1748973779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lc19MQ2L83GFf4VOSaJH4jzsZICcJBsc7b6CwdqsbsI=;
        b=nmrW8L6bQYFvkP4utBuvHf02/cLHTnieijRTJHq6rdDU8gQcjA/eEHJ/cPvZ51+WZ5
         j/32Y4Swn4/bWTwvgPZHQanaaq0WzY6dY2rja5MT/UOPBTOG8mscYoSJI11/X3QrPFyu
         JoInfAAkFlwvJotledmpEuM3VjJ5n/BbIi22bq4IzoX0QpOsj5GN9sA8JALmf6v7wOqC
         ybFKhxlpaUQ8dQwaJ5cyrceInZ3fRIPPjaEaHdeRoEo5DPmZ9T6NHGVo47uO1bCgyQhr
         8XqMfmTU/x4I6vOnIbQm8WNkjPwW3oAdhPqROEG4eYuxfeid/DzVRp86MzgSxsZDclLy
         YpLA==
X-Gm-Message-State: AOJu0YyvvNjEEuHRZNsaz4FT0dxroh4Tml3lKakGojQRG8mnIA9qYssf
	SYTq3ExSbxoYY9CfdmYWpwI/5WyTiM5qCW+w4hIHufU6MT8QpDsL5OdTe7iZ3qCLa10QjuItkvs
	gYpup6L7doQmIGuzK2AUb4k6SV1O8bo6K4RDRsVLsSzt8TZ7/xQ0uephlEsA4DfvDCLmtUZ8v9J
	DqtKwVpQDDRh3vxGbe9ewXEpush8A=
X-Google-Smtp-Source: AGHT+IHLK7VmvWcDZxFTXIFk0nAZ8w70lzZCIbV5EYiVy8sWjQnhG8dciiR2hqbLtLd2GCHLUt22io7peQ==
X-Received: from wmbfl8.prod.google.com ([2002:a05:600c:b88:b0:442:cd17:732c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1881:b0:3a3:67bb:8f3f
 with SMTP id ffacd0b85a97d-3a4cb499cc0mr10465551f8f.53.1748368978280; Tue, 27
 May 2025 11:02:58 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:35 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-7-tabba@google.com>
Subject: [PATCH v10 06/16] KVM: Fix comments that refer to slots_lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d9616ee6acc7..ae70e4e19700 100644
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
index 2468d50a9ed4..6289ea1685dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -333,7 +333,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.49.0.1164.gab81da1b16-goog


