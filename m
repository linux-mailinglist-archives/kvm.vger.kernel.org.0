Return-Path: <kvm+bounces-52475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D30B05689
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F19B5642F8
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFC02D948E;
	Tue, 15 Jul 2025 09:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hL5jnk/q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718082D8DB9
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572050; cv=none; b=DH5cbBONptJTm4/I+VXxhb80tualOxduMk5TrxX/s79I/vM+5cMDzo6O8uYmL6hkMOG3mKevLvh6Wm2bTlguuG9o4Fx8xgfIH3n+ZCxQAEUSNOo2UPjg5+D0JfZSQ8E9ys6Q5YLwM48/KAuFEiSOpz9A/O2G2L0g3RTLSyni0Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572050; c=relaxed/simple;
	bh=aLq6w6iMVx9A+GXdrTT+UqPhvEMW4mi+b5uKE2VvZds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DkKsBWV5eg/oGUzUN+bp9NtKkUOMQ9VWCJzHFGYH7lkz1VZA7SX62COYjg1//5zqsO7vJZIElBgfjlJAcVIef6oKKN0c2p0vwJbLr/9w1TJBZn74V0UgkSpJLItJyhHkQk4bsYzhJR1aXvikkyqpPK3JKP2XP41w3B9cPIeZkgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hL5jnk/q; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4562985ac6aso3025825e9.3
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572047; x=1753176847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkuKuazKKizZ6ZlT9w9fSwNujhSChJOs2f7h5A8NbUM=;
        b=hL5jnk/q/MoarJr5KKTYLX2ssSlmCbW4/hDt8l4S1bmrBnzzvwZrBJu8juomSPIuI4
         UPS6xkJ2WlYBBoU+F2F+EPbnEdGY9kU8QF8wA0Z7lKscVMep/xg+XsI34Afr71wJkd1p
         NRACVuXRaaVVlbSKKoVBhMe9tqxVH2s+cGX8BFlcdPx4FWcJCNup9IkxZr297jyGzZwQ
         scdHobauKyIrs+DB64jrCe4gmefIdvAiSP/JfwUkpKcOUaVWEJwZZMYF23CGafbw5n4J
         FJnwVWOlERtlGqEuIetNpN8D2rbj8oREx2hbc9kfsJE/+xOaJMebWbyRPrWVM17UPu3E
         JDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572047; x=1753176847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TkuKuazKKizZ6ZlT9w9fSwNujhSChJOs2f7h5A8NbUM=;
        b=T2QfpE0eyE+H0RXnzoupDLLscTKlFtgcWSdnS5SHMpAYz7iX9mEdDWvNwHRH/xEG7V
         ctoEtH8cRvRtGonNlmjahNSeErWvsECRH/3S6o5KKKiP1S2UUf4iFCj4ngMn6SGcSKBR
         kTKWyUFVS9XnDl7kbVQcv5shZkk1VUHCSFtymzR9V3pA8CTABBcP7JbqvhYD1nd3S74h
         CxrvfKMt/UP0yZFH8LIWHQC7EOfyfaJyVzHX8gx0F0+WbiFNUpGn76DhEyrSEmLAvoE5
         AGS2XjWb0BZUmq9GCWK4KXj4SdQCk10h1z4ZqhCYuTCcgIun8J0IjYP1h5o9w++Cda6N
         QYAA==
X-Gm-Message-State: AOJu0YxMR2DTKBvLlQQjBP6Xd8+BFcmigSVauyUi7/LH3FEs0zYHct6T
	IuWndMGh99rW5iFUyn8bjZdlotMKVDL/VPk8hX1NDlkVgGL442qHO+wfC1Iu6CsXcF0U/e0Jrhe
	wXJt9rzwHUwq/s/H1oXM3vsvGhEF0KD1+k0yApKCIrCCJz2FKzl3jgI+VMGPqVyRq8Cilvy23Fl
	QJ1PUexFzSZFF2HtO1zUXF62eDkI0=
X-Google-Smtp-Source: AGHT+IGHXP0t1xMDlthuKsBdUUCbcrAxXrLxIuWqHsf1c70IZpuqDuBfFbcmN2MndgHaJWicrlcB1Kwa1w==
X-Received: from wmsn28.prod.google.com ([2002:a05:600c:3b9c:b0:456:2003:32a5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b0b:b0:456:1e5a:8880
 with SMTP id 5b1f17b1804b1-4561e5a9020mr52008185e9.13.1752572046722; Tue, 15
 Jul 2025 02:34:06 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:36 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-8-tabba@google.com>
Subject: [PATCH v14 07/21] KVM: Fix comment that refers to kvm uapi header path
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


