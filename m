Return-Path: <kvm+bounces-22906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A87944758
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89E4B1C24447
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205DC170A30;
	Thu,  1 Aug 2024 09:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rKlwcllm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F144916F8F5
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502901; cv=none; b=GSS8dXBx7Xco+RJ4qeuZcM9mWI5qJWaUwztnBeq/jHCeGe0ivE3V3CzlCllW6YpUUIgrquzRg+x7++3+Bh1ZZaTWV04ztNgTylTVs0895/mnHpv+TYEM3a4xXPBPtwTs6UEZD6EWKBTAVWugenMZYmqdl6cTNdjE294G62eMuYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502901; c=relaxed/simple;
	bh=/xyaq17skgd/L7RMTEIyM7OuUD5Qi6/Az+T9v4EOwIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gwYhIYlN4Lv+PkO1Hdg42PGvUR9oaerh+m7/JHXl/NCGWYgNs3qkPlJUrcoeaKk3PrmcnBBYDhSPQj/1YZFq2Kb3j8bFJgC7bdV0BdottMFL2LLje9Lp/lGWfat0AJG+a3BpWd26meMiAgQmt2o2tw6YwqBBEd+N1kSDbIK5GsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rKlwcllm; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-65b985bb059so125081607b3.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502899; x=1723107699; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VYgP8TsqpjmhLiOepZBWnEDyKrGoYglq1ochGe+g9ag=;
        b=rKlwcllmqT3DNxXeUx3t9TKeOsuQYOZ1OdjmuY2h388pOPyP/rAL8IVQad7QirMR+F
         m1+VVxdJmEUz3bYMTRBImn8Wy/Eqj9ycyoxIULA0OlsgY2STxcSfXBpuiDrzxzabHXjG
         ZIfKOPtpcX1weCndJilBLSDQjQIdHefwdt/Cm1tJC8I5J9TJfvrvSnt0BdGAvm7mXmeR
         50dP8Q9qHY3nk5ywZY9KyARmBGw2YdMQnyXMAaxfGlhfjc4yKZ1r3xkuEIPRLShTW1ht
         9VTuQkWIk92M3WTDAG3FlGy/n2po7xZ9kjmfT4B/Z8GXStLXCfjaZjJMzQjAhvORBadx
         HHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502899; x=1723107699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VYgP8TsqpjmhLiOepZBWnEDyKrGoYglq1ochGe+g9ag=;
        b=NgMzejZzDi2UJ4GndB0+xUNKpMfc0GSMtaheK5mTegPZpr7P7hVIGaaKd9tSLXqUBH
         X9ltgo25gmT1eTKhwJ0iexXwICR2S8dH1xo/x72ARrEYyclCVF//e1mflAn+YA8BRDDG
         iUUd9Q/Ai1ogbPfX1ZT7YMVDcjzs0WAgC9YGvqrPsnmTMNd2nTa9quF1hlpgB7ycI71+
         IQE3mvcGbhHnS94kBSy4DSdEwVqgs/iGoctdfeUs+sgNmoQGykwtekN0aFUYYjyx2bAx
         mmJj7IZbig2BemurT0k8gqQVKeNLJlvuziJLzpjn0/XIvqoS2+TichxjcO5LPfoKf1rN
         7O3A==
X-Gm-Message-State: AOJu0Yz4AMJifRxPq5QGhr5VU36Hbpen31zj9xSUskFO7Klnm6/TD3Gc
	LtGQE4zdmGhd/5tSCC4kPEfFY08SqwHbQXlcSrgFhgtcenicc1n/ZXOjfJjTTTfxXrwVtcM3/ew
	SBuugfcOpnkShVnWfIKMBSVitPUiBU5RCNbe7Muo3k83yc59Ul5dANHPHtq9Nb+SaU2GgkpKtbH
	qqFMud8ReqXmRqeIxncYmkLN4=
X-Google-Smtp-Source: AGHT+IFYiAm/ZMOGWhUa/K3MvrLtTZnEUf3NdBQXNfdF1a3J1k2aDdCJIpsdZ+5mVOdSrR6hCD4FF6rWww==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1107:b0:e03:6556:9fb5 with SMTP id
 3f1490d57ef6-e0bcd3e5b26mr6126276.11.1722502897790; Thu, 01 Aug 2024 02:01:37
 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:14 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-8-tabba@google.com>
Subject: [RFC PATCH v2 07/10] KVM: arm64: Do not allow changes to private
 memory slots
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

Handling changes to private memory slots can be difficult, since
it would probably require some cooperation from the hypervisor
and/or the guest. Do not allow such changes for now.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e632e10ea395..b1fc636fb670 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1970,6 +1970,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
 
+	if ((change == KVM_MR_MOVE || change == KVM_MR_FLAGS_ONLY) &&
+	    ((kvm_slot_can_be_private(old)) || (kvm_slot_can_be_private(new))))
+		return -EPERM;
+
 	/*
 	 * Prevent userspace from creating a memory region outside of the IPA
 	 * space addressable by the KVM guest IPA space.
-- 
2.46.0.rc1.232.g9752f9e123-goog


