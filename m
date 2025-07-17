Return-Path: <kvm+bounces-52760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BFDB091C2
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:29:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 195BD179CBB
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2382FCE1E;
	Thu, 17 Jul 2025 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZkqSp9rF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1CB2FD882
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769663; cv=none; b=rqRrlpm1wt7CQQL7s6KPPSt+aIOOSL2EeX/hjeIxIC+jB4fu73jmynO1i5l9pgwnDFjXmde+5JOAa8mggqYupD/nnLdKbRTEvjdHeknpkDQuQowXJLQuBqSKoZrFkeZAZ/L54VNPq7JupFGsoc+VQTXH22b/fCNCBj8LSkE0qeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769663; c=relaxed/simple;
	bh=DGSXIBpaZ+VliuyanNwueZCPMfss1HfDwsSY4rS1zkI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qGRq9aWVbSLyPCsyly0EcX77Rat3XSB9Nf56Ak1olj9daihvmrryJg9HQnmIo312GveDPivU1EiOtpd8mq1E71+Pp1oZGFQWXSKGJ3hrlFyzUSf9192J1e9rrqDADThsL5e08BfM9771hvtXGIwSPktH8kaw2xRl+qNrKqVo168=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZkqSp9rF; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4edf5bb4dso894926f8f.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769660; x=1753374460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=81cYjGlMvTtj0w3SoYGXht/cTScIXHWu3YXSJD4H52Y=;
        b=ZkqSp9rFnOYQY8V8b8AlP27zH2ggTiZuMp+6Ito6TxvPPqSNeqXh5T+ngJZgz3iEVo
         2+S6EhIGjoMNO+HQxGWlwAOQ2JpPMRlsYWmZaBl/pdOVfxBxZmLAIQzWTR97e2tdh44F
         GASQAfkBFUuNU7QGE3d36GT2Rh+B7iMu2eci6Jfh+TniRLGkNM5h063/T8FbzT0kSsOb
         omGuLNRw0JJF/fOcCBmvYqz0Rdd4Zvk7GCyC1/3Ozcm8Cnk0j1UneLeH8Uk9Zo5UzHzD
         LRTCBxjEcZblZgDJ4q76clFxvdQZKuMH/4Aq/HhjYVIjs1+jP+Q9PWDwXCgojrYCth9j
         SvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769660; x=1753374460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81cYjGlMvTtj0w3SoYGXht/cTScIXHWu3YXSJD4H52Y=;
        b=mos6Rob4E5rY13WU/cVmb+Ze0fejjtzdcKpEu9Ej+/5FAYdNgbU4hKVF3GlLsrNRzy
         Ev2O5pasE1sVyFJyor7xe705tIPOA0oZlSNcdrEzMstsIgBiKSVwfEU6rt97HjlhRShC
         gSZjERjBn8bEs/6cF2srQQ2njTqdEGnXOYFKL04WXk1rmM3aCIb5YGBXX0TEe6mB6uNt
         g8bChZSgFeOx1V8SGNjV1JWof1MI53bVkP2MhTvBC80P0hl9PT0tozWZ12XM75BXjXZP
         OL68pRQQIhul2IqgC88JbimUnoMsyJ6Ref5fEzd8xvxbG922bErtpYZp0EIP0LFrjFee
         OAZw==
X-Gm-Message-State: AOJu0YxpD2D2L8hLAwu2YzV7q1rBZtz5TdaRCzUFZJRHe94qJXqqR6jZ
	H/B3IRNZuHKhWjIhYk5La9y/p6+27JfQk5TEkBk3Em7GaY2EqtTuwooyTqCFFXQPPzf2o6Yv3b4
	AcrKfFoiU4rNOjgPG85+2SnliOaFqmde05MLotfy+zE4a40YJO481ZQTsidBD/YTIKSZxiXQjJa
	e3f4T9GRdFHes7YLGl2XLX177N3pA=
X-Google-Smtp-Source: AGHT+IH5bmHMDd4zJafAHZwYYPcavwxGE7apj2R2grFKsJXx46AWhyZfurpkrtNa5YD+GGFrD9t1NSVLmQ==
X-Received: from wrvs4.prod.google.com ([2002:a5d:4ec4:0:b0:3b3:a665:e00e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:9d83:0:b0:3a4:f7af:db9c
 with SMTP id ffacd0b85a97d-3b60dd8d273mr5658619f8f.59.1752769659430; Thu, 17
 Jul 2025 09:27:39 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:17 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-8-tabba@google.com>
Subject: [PATCH v15 07/21] KVM: Fix comment that refers to kvm uapi header path
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
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


