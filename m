Return-Path: <kvm+bounces-52772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 569B4B091DC
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8390E1C44C1A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC44A2FF487;
	Thu, 17 Jul 2025 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="spsuPo4e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A972FF488
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769675; cv=none; b=V87COWZw3Nf2us8lX7gXLQEpCkeDUxf4aZHVwYGrl2pRu6KwzNfz51383BFIrXWrUHmQw3bOLL1/u0e3YXkEqR0X7vXjsF4DuFZG2Q61AS7hyaf0wvjc+TEBc2OnEIMz3rqRW6By2FRPP2GL4Db64aoA+/nouP4N5l1of592aJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769675; c=relaxed/simple;
	bh=s81rdo6xJig6RnBs9z2MASUF9cmSxvjSWz88FGej91E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=db09TagTGzAPu+Z9nGkKc1eE1NqbI9VqoyD20CKtnYL5RClDOkP+WG3oveWxGdhTuNsuSrZpRH1CzOFfLt79Xl5LZecIqTRMMEsxP4zqwIvj1yDW4whblSpFJvNNlSLK+DHYrd602zup+L3mcBwyQR3FtKmpcbIBnHDNlJfI9Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=spsuPo4e; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-455eda09c57so7400305e9.2
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769672; x=1753374472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qSAaCs5u3stWdE7jpelRBQbwP+260qm4giQezY97SA=;
        b=spsuPo4eA+ATFsbF3ckALG0EKnuMfeLA7TtLKTFIqxRm855Bn8M9l8MRDDylCbmdHs
         y3e9aP1MLMi9GUTWDtfSA/mLvBbbDCSrit9CghitZ3letta34FHw2mvAGaFfQV1D4yq3
         g73H1o7Y2v1oZZcbeukOdDcJodDww08ZKD2mLrs9CcgY0HMeCOY7ZY6q3WthA+Tr0A6z
         Eqk0OKweGFweF7FZ8X7+d6R6xTAfDMzxgHgLN4bUrVYZOPEcM2KhTmONA74R2xvYUCLG
         awWue825u9FxaIkOO7Mgh96Qv+VbfPIdC91emeAo1zah7sz9pnuyd72Kq3nMmVAibicK
         LKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769672; x=1753374472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qSAaCs5u3stWdE7jpelRBQbwP+260qm4giQezY97SA=;
        b=mNSu6hvGbI0MYDOnRxVlZwN4UtYQG8rC3xUM/CReIlSqH1aoi63GLhx8kk547M/ECN
         DCA9BPpYnktu9GdEjAy89dvJGUoUNr4egz9ysbu8+x8nzyqCNyvbxOxk+hKaUzJxi/f+
         L3OSig/TOp9NwQ0gEJg6JQSTMrgu/qiV053Vcc9kNyOHCUBz2WfODtZQDD0I7CODmowY
         mdR8He299p9P5u4D2x3T3XeAzZXo3QGQnwwAqMR6xu70/liHYZx3GaPTvFt5uHOo8acB
         pfRjmsMsQgrpGYYPsZPBjEqoVIaUVdYJfPV3tCYXhfFkSaLD1I7BQaict5YKJzT8dlES
         ZJfA==
X-Gm-Message-State: AOJu0YxQiJCgWXUYRP5SewQfXkjRyFpn9IEZ+J9LnOU2JjebeA2TTgxo
	I0KoYZzYga1MQS0umu+aBiMJa6vzo2/g2RStBKt6c/dJKA5RrUnENYgesYiM0la90IDdy+0/8Q7
	ZMEFpbCPMpeCe660ime1PSNngrOFJ1d/rYck2FUhjrz0INQFrWnJr/Z0Py4/tmymX96XikzXtHl
	ozJrM3kWSeSth60LotGx+T7XtXC3w=
X-Google-Smtp-Source: AGHT+IGjg8/uLQNLo8/8nfgrm1uVOjDa07uVW/Lwkho3eZQgaQ6oW4O+FKLkfDBYZb3MytplRqZrWm9Nig==
X-Received: from wmbbi12.prod.google.com ([2002:a05:600c:3d8c:b0:456:2b3a:c21e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3d96:b0:456:c48:491f
 with SMTP id 5b1f17b1804b1-4562e3548f0mr88434095e9.10.1752769672325; Thu, 17
 Jul 2025 09:27:52 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:29 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-20-tabba@google.com>
Subject: [PATCH v15 19/21] KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
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

Introduce the new KVM capability KVM_CAP_GMEM_MMAP. This capability
signals to userspace that a KVM instance supports host userspace mapping
of guest_memfd-backed memory.

The availability of this capability is determined per architecture, and
its enablement for a specific guest_memfd instance is controlled by the
GUEST_MEMFD_FLAG_MMAP flag at creation time.

Update the KVM API documentation to detail the KVM_CAP_GMEM_MMAP
capability, the associated GUEST_MEMFD_FLAG_MMAP, and provide essential
information regarding support for mmap in guest_memfd.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 9 +++++++++
 include/uapi/linux/kvm.h       | 1 +
 virt/kvm/kvm_main.c            | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 43ed57e048a8..5169066b53b2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6407,6 +6407,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
+When the capability KVM_CAP_GMEM_MMAP is supported, the 'flags' field supports
+GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation enables mmap()
+and faulting of guest_memfd memory to host userspace.
+
+When the KVM MMU performs a PFN lookup to service a guest fault and the backing
+guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
+consumed from guest_memfd, regardless of whether it is a shared or a private
+fault.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3beafbf306af..698dd407980f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -960,6 +960,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_GMEM_MMAP 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 46bddac1dacd..f1ac872e01e9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4916,6 +4916,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_supports_gmem(kvm);
+#endif
+#ifdef CONFIG_KVM_GMEM_SUPPORTS_MMAP
+	case KVM_CAP_GMEM_MMAP:
+		return !kvm || kvm_arch_supports_gmem_mmap(kvm);
 #endif
 	default:
 		break;
-- 
2.50.0.727.gbf7dc18ff4-goog


