Return-Path: <kvm+bounces-46360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC84AB5A09
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4837B4A6812
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414FE2BF3D1;
	Tue, 13 May 2025 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uQm8rBC8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919D2BF99E
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154096; cv=none; b=tLRyTUVyDjhYC0hdt2+jgq85PFYDiIkCFXG33e6KjPo8+sCav7G3t6GKSiHcIBH5JmgytprWNNnIK5tZdGsZarvMHgiVdxv5NtWc4JJyTQcu4yRrjXVyvgwPw2JaizJXROi2bNENRHI41hOhA+yix19XIwEP/EKd6kM1M5mYvBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154096; c=relaxed/simple;
	bh=usZ98HnqQjJuOLHnrjdI/J1buXDTlngynXDQux61byk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KRa7ZIq2lz9yhauE8D2RmMPS6PTmgCp6mdI+jswE6mjG+hXD8+VP9oLc+qLvAK1Niv5Kp5KMiG5TnJ5COzqlxe7+fztZEl76du97OXCCVpiayLQwiSV4BZ8gHZhRBD3zfPCy+Cwvf1m1N0AKjELmpRapVfoSTN1IyGELhWd/KK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uQm8rBC8; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-442d472cf84so27247235e9.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154093; x=1747758893; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfRX0WQ0nwRc65ZNXi/N9cbTM9kcIW9CoeCwP9fdsaQ=;
        b=uQm8rBC8dKN+z54cb6Ah6x5zw7AspA5CcCl6VjsEN+krMFCiCeEuCtYZNBWPADjuj6
         Uu0+6LhrWgnaCBijncnUpcaOw2CNQ2DE9+iHIr5m5DT7kt5QAdxVbr3ph6Mrda0rLS+q
         QJL4YQIDjse+K7M24IY91GAeeiiklVvRBq+X+eiQhncSw8JA1lez9IZEzZgngXx09Zk3
         y5qojo+MwE+KYSrD3CsJ3ZAfKl13QiNWTu0sMTJWaBm715khJetj66Hda5NiSnpAITfd
         1b14ZKQzL38gKvGOEPrgG/C+bbZTNBATiTsEBGUHkgvYOa7KlThM9V7RyuGp/rP5jCUD
         acnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154093; x=1747758893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfRX0WQ0nwRc65ZNXi/N9cbTM9kcIW9CoeCwP9fdsaQ=;
        b=WNgRi7FQA+6o1hkM95lmRKQ72cmtLp5gMxoGiINfq/jdnf9wpvK/TYKZ2NOwxlvyTv
         IqoUnn5Pw7ECzoBO9tjO/X5kQxoNT4o9vg1+A+ZhXLoVb87tNeuTf9PsJ3Gb//5Vd3uY
         hbtV4h6OWf+2XaLFDjn1TOsOTvUS1+TCn3vnCc1zTrOfpFwQLN8HnbF4qPDEWIev29VU
         woV/On8asSPBtBU3I/SUTzl+cWPdctSu5xIStkk3cbaOTQgw6FN1mYCw3RsfVsWX1yUb
         k7JeVePkh392ZBdqumls2V/k6Z0ZyEUObjKsdZ4uuTGjpmQDildG9UkIT0Ezcr8VcPXt
         D4+g==
X-Gm-Message-State: AOJu0Yw5LCYSH1YSIImkOq8nrV5onthh58ObXQeg0DlyIv+IG8CHoNTR
	1UOJOaq48vZBmqdor3RNYnot8lCHIA5MdQjvCq6POUXmxV+27q0XJayvVJVPghTPQjGxfFeWR+t
	AHNvl0xbkCcYg+filjWT95kLrvs3tqqWDrnURcRCaBhwkzOKevw/gnchbdzT2R89G7AstmVFT+H
	Oa0OmDrXKFdK+ZEc4fvTFViZc=
X-Google-Smtp-Source: AGHT+IH1XM5cKXN9KHIp9N+CWq3wdwJ0y1vkRxyXxd2Z8mniOCEFD2cALdYDmqraPvwEBsmjywaqCAwJxw==
X-Received: from wmbdo24.prod.google.com ([2002:a05:600c:6818:b0:43d:56fa:9b95])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a00a:b0:43d:db5:7af8
 with SMTP id 5b1f17b1804b1-442d6dc7cd1mr144031745e9.21.1747154093124; Tue, 13
 May 2025 09:34:53 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:27 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-7-tabba@google.com>
Subject: [PATCH v9 06/17] KVM: Fix comments that refer to slots_lock
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
2.49.0.1045.g170613ef41-goog


