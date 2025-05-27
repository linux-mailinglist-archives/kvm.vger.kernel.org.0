Return-Path: <kvm+bounces-47820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F84EAC59D7
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:04:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7AB516B97B
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E262882A1;
	Tue, 27 May 2025 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FTvn0g3c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B77D286D75
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748369001; cv=none; b=B51a9m8wIbGlbLrfFOyndPvXMRkObBoCWv1z7SzqbM3BChY9k5YXgQITptStIGYuZ0fCQuYoHc8Nny9hsNHt+f6jPHGznRPkgGieJNgZOaOLLLhUAa3Xr99qogX4o95Z/8dkW20b5U4SsmEwY5WJCPQDmKAD080hR89BFEohbBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748369001; c=relaxed/simple;
	bh=kENE87KuWbwh9oeCaMYkJMHzEPRYjvlvodmWu3BNCiQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nyc3vtKgnLxOZ3U8uBVob2Y0xdQ6EA2thcgA5i9LAQxmF0gCszHa46sCmxm9pjQxCAinS1r4eiVG+b6RHHAHuBd3uAa7AssmqpNGjQFPGf1Djrcrcei2GdCg+8TMhWG6e91KH5ZF4RKP2Meo+f1RA3IlZOkul+wjnyLiThD07y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FTvn0g3c; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-44059976a1fso18043235e9.1
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368998; x=1748973798; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9THl6tngIifyO/Z8cUw5Iyid2fdTuuhsEdmTcONf0nw=;
        b=FTvn0g3cBD1/r5esJfNEZ7MbCNR3cZM+g87m1C1cFZD24FEs422KG+1r2l+fdGCuNk
         vIRVoS4tNTsuXbIM2Dfay0sZMMAUY7qrNKdwA8+2F51ZsEgmLLbpvphfpjcsndwWWXkS
         tR7foyAdSWWY4WYBA+KvmQH6qzVzBgZNRte7PAS0lvdXLsAK8b6+qFAzWK29SVbA/uzq
         ICPDJ6UbOWZS7TwhwBklRVuRey+f5IL3H5PXJq1uGmIKHx0IKsOKoIpvSS9D3XfHAXDu
         9B7Q+rACm7ggOo2y8z3KZpgVArPXh+WkOJSn4G8jQVHjMpPf9Tp6SEmwACG8uoCiKo4j
         0Oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368998; x=1748973798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9THl6tngIifyO/Z8cUw5Iyid2fdTuuhsEdmTcONf0nw=;
        b=AxLktM+GItt9cc5vadfJLmxAZmwuJzuDrlPjdZ1aoi0VV9jpSWJr7Crr0bGdn3+zoW
         3BT7RzmrrbSKUiL4N5cYnBSC7HUmtlWReuqWUVV7TF9jcRd2WePIVkgPWMVm1i7jLiX7
         pUMlyEIHia6C5AOQY686pMun1wST0VIYskpjX4sKbkMRqFZ4y4dYP0k4+4CROoQpEWaX
         OFb265fUcAG+W+YkS+/LZjEDVquosadhYlfZMfjDLQooc+po8Oomqp2v6H/w9Xfdm14T
         /qpYGPV4iQEVfVLD4s9Iwz5bWmBi3Yxvl6FzxW/DY6ciCuoULXc8riSI+cwJknWoQcaV
         VnSQ==
X-Gm-Message-State: AOJu0Yw0ulxJKHOklIJ5BoLE/FyKg6uGll6L9ehzQC8KkM4T1jkrbL4m
	7cQn1OVqwAawrJrCqxy77sBVWU0ZHeKBuiMTIhQvIOV/QPaAtGDdNdUE2e/NSTfPOZl+MZYQLk+
	4Ni2ICO586mQ9buKVQbMUvgXoo/13GizE4cps9KSotmiJgSNJICFcE994ly07lrpku2ilGvQ+m9
	2BVjU4EpOA7MebdeOhCssH1qx16bY=
X-Google-Smtp-Source: AGHT+IHaWU4cjmU2ZJj6ZDgH2LFwc1fe3ZWZyDJV47KGyLvZv3pZdzSxkao/kyPFI8gll31nq6XOjsI8vw==
X-Received: from wmrs12.prod.google.com ([2002:a05:600c:384c:b0:442:fa35:dd50])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3115:b0:441:d437:ed19
 with SMTP id 5b1f17b1804b1-44c91ad70afmr121906045e9.11.1748368997713; Tue, 27
 May 2025 11:03:17 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:44 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-16-tabba@google.com>
Subject: [PATCH v10 15/16] KVM: Introduce the KVM capability KVM_CAP_GMEM_SHARED_MEM
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

This patch introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
indicates that guest_memfd supports shared memory (when enabled by the
flag). This support is limited to certain VM types, determined per
architecture.

This patch also updates the KVM documentation with details on the new
capability, flag, and other information about support for shared memory
in guest_memfd.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 9 +++++++++
 include/uapi/linux/kvm.h       | 1 +
 virt/kvm/kvm_main.c            | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 47c7c3f92314..59f994a99481 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6390,6 +6390,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
+When the capability KVM_CAP_GMEM_SHARED_MEM is supported, the 'flags' field
+supports GUEST_MEMFD_FLAG_SUPPORT_SHARED.  Setting this flag on guest_memfd
+creation enables mmap() and faulting of guest_memfd memory to host userspace.
+
+When the KVM MMU performs a PFN lookup to service a guest fault and the backing
+guest_memfd has the GUEST_MEMFD_FLAG_SUPPORT_SHARED set, then the fault will
+always be consumed from guest_memfd, regardless of whether it is a shared or a
+private fault.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c2714c9d1a0e..5aa85d34a29a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -930,6 +930,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_GMEM_SHARED_MEM 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6289ea1685dd..64ed4da70d2f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4845,6 +4845,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_supports_gmem(kvm);
+#endif
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	case KVM_CAP_GMEM_SHARED_MEM:
+		return !kvm || kvm_arch_supports_gmem_shared_mem(kvm);
 #endif
 	default:
 		break;
-- 
2.49.0.1164.gab81da1b16-goog


