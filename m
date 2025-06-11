Return-Path: <kvm+bounces-49063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B208DAD5740
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4E9D16599B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCF82BE7C2;
	Wed, 11 Jun 2025 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CT5uldrU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269D72BE7AB
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648848; cv=none; b=RB946KNveuQGyhwiaIR7AUf/NrzSimtl4uGg+s73aMA2rVYc0wM3rmfQeV61Dk8Pro5sRVFJ0i9AGvXYCDFlTTItg/96Iuhu+lKrW5ms4JszQEgh3sPNwYZzfe0KL7ZaS3Vps3cXyDukBFme9FyMSUfVA8PjH730wLvxvkUFnxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648848; c=relaxed/simple;
	bh=85h3na1gsYFMlWN8UpZMM/0gWDZKX7wBW0lX7RlGk8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YkjfKsEwaeqefAGEi97lfJjDcpI/rk5JxdGflrB/jfNgtf0cRdZgehyG5rC9ilKNSWcBkW6OkyJwOmO53Ss6r7pkKntZbnrzyOd5x+Fa+bRWcfqbhaRs5HJfnVEp1yUptpOzeJPMToOwNjl/eVCRd9/j/5bJ93CNc4TdoC7Pfmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CT5uldrU; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4530ec2c87cso22565835e9.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648846; x=1750253646; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1XR59PTGuiW1gb55TNwkuIBSMjZG1XsBaxGQqCed/os=;
        b=CT5uldrU7DZPSVilcxSRD8hOdiMzn2ccOeBUFstqow/qOfe+SfjH00a+FYFNPn9qTs
         s6K7i9JX3aDIIcDv6F3i0Ha+Ttu33BYAEpxbF+BDIj1RWbhyVh8ga9a5Nv9UZ6RXH7e+
         AkYk0FP1gzx/PmixMjWv34x3ve7Ey4OGlbqe1yENsZsuvlNGMfW0RI2DBe46my3lvdx5
         lh9kKrxUAD1N+2FIVTJlIStNeoV3R7YRccWcT5UAOtLg/0wIjSn9GALcwELUN+FGmZFv
         L1ZqsGn5Hd3VaACtG303or8A3JXusg9oIC/8WH8RwK62S6mf8hhp8nHivS0wS90uwOnW
         DvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648846; x=1750253646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1XR59PTGuiW1gb55TNwkuIBSMjZG1XsBaxGQqCed/os=;
        b=AVkHYEWdUu8rlDB6so1H2XTyuWopjrm64474QAq1tT2D+pE87mwDazI6y5cQQjRohf
         7kN2gCwf7zUc6G2adL3ihTyasdZLUWfX1vei7B+IQU989O1d3c2k5eHBwXLGxdr1PdmA
         AZa58EfPZSYuz009t91OoXm67OCpv8lMfDshi+KH7NXf2xtsL+MtOXw0ooV+lH3Js5cg
         Opx+y6NsyHK6ZPLTd6ITpwPayNeCclr3b2R5i5Y9fWEOMin+zu1B0Lm48M9q/bKgN1CQ
         KhXOeKScMfaSJjbwQ9f3Nyj+lCnt7QN6cqdIEVeOwznukjmrQMBPAm44+gMPCpiGVMMZ
         lerg==
X-Gm-Message-State: AOJu0Yw+azruofWG1ntpQ461eKKroUH9Hf9InbS8WRHYfIcgeeWguAQD
	Drso65XJ0h46VeiT2NPHsKh+PO2lz+Ys5YOsIUfFuh8IL2ss8IEa2y1B6EZ3hS6B0uiv7kXGkC3
	cUzvpB842D7+prnGg3r11grWKz0mT8wjZoH2wkh3AI4Dz7/Biyv4P2541O5+PFIbV42f27zxHKj
	Xt3kRVWaCRPH87sR8URoqyNx+P4Ys=
X-Google-Smtp-Source: AGHT+IEfAr/l95Kf+rwSAj9mppIOYExWAEsd3FitYHNfOu71BGp8Mi+xQZ98YDO3SYy4dT9bCQ1C1E+czA==
X-Received: from wmbep25.prod.google.com ([2002:a05:600c:8419:b0:442:ea0c:c453])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6986:b0:439:9424:1b70
 with SMTP id 5b1f17b1804b1-45324f6a144mr26676635e9.30.1749648845441; Wed, 11
 Jun 2025 06:34:05 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:28 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-17-tabba@google.com>
Subject: [PATCH v12 16/18] KVM: Introduce the KVM capability KVM_CAP_GMEM_SHARED_MEM
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

This patch introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
indicates that guest_memfd supports shared memory (when enabled by the
flag). This support is limited to certain VM types, determined per
architecture.

This patch also updates the KVM documentation with details on the new
capability, flag, and other information about support for shared memory
in guest_memfd.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 9 +++++++++
 include/uapi/linux/kvm.h       | 1 +
 virt/kvm/kvm_main.c            | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1bd2d42e6424..4ef3d8482000 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6407,6 +6407,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
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
index cb19150fd595..c74cf8f73337 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -934,6 +934,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_GMEM_SHARED_MEM 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d41bcc6a78b0..441c9b53b876 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4913,6 +4913,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
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
2.50.0.rc0.642.g800a2b2222-goog


