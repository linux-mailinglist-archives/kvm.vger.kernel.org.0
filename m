Return-Path: <kvm+bounces-46369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E1AAB5A2C
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1B17188B78A
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53F42C085D;
	Tue, 13 May 2025 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MBIoQKYh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF482C0853
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154114; cv=none; b=Wq4tpr3UGaLDA66RxWwj5kFn2Hf7iwlYTWFZyhDgdSK5j4osNCGvYTeGK3xcHYlx6ItH+RiBMFMn8QUuLYzo0NT+m3Db6YUD8Qmx7++DCdzt6jWhCudY3WUfMqEp0Oi48mnJtV+5EVH+d5zXKf4CxADrtgkriqE9kvEEvNoV3uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154114; c=relaxed/simple;
	bh=bNE8fjz0DjqD61kI2dV9cmfzEuqeWV0E/d5rTeYbx6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HEGKiT5M/X7nr6tIWRqbRsmUJQ3/hozaXGJOTBRe8CO26AQZ81qLRbeL43VdyTg+5I58s2AfXX9ObADvUCbV6tQZ0cAsjIc6+QVcjTgdGU58E+ypmyAj5ACzcC8XuFI/FofYsNUof8FOrR0rBgMZ6ratF24oSaN9gJ5sQfCjbKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MBIoQKYh; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-441c122fa56so23382475e9.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154112; x=1747758912; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZWH6ggb1hC8uB3wzLXpUmgA6cvqTdmcA385l2vtyqo=;
        b=MBIoQKYhjxs0HHqVVZs11rYv9uz8iuBHyQ1GMWfi237mnp6SyrL/mkmlh9TuDhLteD
         vth0nvtOBARs2yAdGV2B8VL3xMBMcXwAHWkQ6Kev76WlyUnQMbQN685QfKzfoVQ6AVIy
         OEt5gkO8PmK5gvtjX5T61+W9IQVOLJrXQwEetfHJ1PZJ+ns7pWJm1FnCfnS0dLp7yaxO
         f2fSW9R8mPDK6N7pFWDsMTRvbOpj6TToDA4IqJV8Bjpih2Vtw9wM86M+6HrZ/fMZemS7
         dPRB7xNsCsISmfVFaUtvUSWMYHEn2sT6IdKo84WYGZAiX0Ez6nGWm+grLlIbm50NSnCE
         vUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154112; x=1747758912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZWH6ggb1hC8uB3wzLXpUmgA6cvqTdmcA385l2vtyqo=;
        b=KbgrAlpNVL6ExfmWMv1tVqTD1oGVLIE2+RT+YxjO2csU+wnfSjt/6GlHZeParAtKjs
         K60okBXnoHvoaAD60pBjHwf6Io2sTo9qIdBitcj3iWlTN0sDkLFmlruDWpueKsQ4/Ew3
         sTJEVSk7wIaOtq8J+Kynfbb1O+SKTExoDYEmu9qECJlCi1m7m3Fcoru9OLuOMPmHYw6a
         yTT/ICD0p2dQZn0NezQVuuxS1gK+zTdGvQcneBQnxVACL62rl1lyWejcotWeQ0Jivyjl
         v0uOzt6dRY46cT5z6mUFdk29IsiYIndaf0/7ofCF2M/IKs5UQZXHTNlzhN7Dw2yLgsw0
         LV4A==
X-Gm-Message-State: AOJu0YwCYGc8Xky4jLvMywl1qiCtd93/LbJWicwTjHMpnnMtBWjiReAh
	wm4/+vlYeYFls41gv6WqB4NoWYfIg116pQwpZ9poKWDrfrQ90H19nIDdVKdvl5Kclp5VeUhPnsF
	bss1XfHWQQbo3m3OZD7ozFBd6VCI6iy+R9jH5kvv8fyGqq18hNtdim3qW5gCoLZyfH84lSpkX0a
	v6goyTEPR1+plkTiDpnB30NxQ=
X-Google-Smtp-Source: AGHT+IGHTibNt10zPPbfcc7hWBFBZ+4Wb9WgnMsxL3M8OZ9mvTxE/IBubiT+QXo86B+nchX57b8DoHTPkg==
X-Received: from wmbjg17.prod.google.com ([2002:a05:600c:a011:b0:441:d228:3918])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:154b:b0:441:ac58:ead5
 with SMTP id 5b1f17b1804b1-442d6ddd0afmr192218995e9.31.1747154111449; Tue, 13
 May 2025 09:35:11 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:36 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-16-tabba@google.com>
Subject: [PATCH v9 15/17] KVM: Introduce the KVM capability KVM_CAP_GMEM_SHARED_MEM
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

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 18 ++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/kvm_main.c            |  4 ++++
 3 files changed, 23 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 47c7c3f92314..86f74ce7f12a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6390,6 +6390,24 @@ most one mapping per page, i.e. binding multiple memory regions to a single
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
+For these memslots, userspace_addr is checked to be the mmap()-ed view of the
+same range specified using gmem.pgoff.  Other accesses by KVM, e.g., instruction
+emulation, go via slot->userspace_addr.  The slot->userspace_addr field can be
+set to 0 to skip this check, which indicates that KVM would not access memory
+belonging to the slot via its userspace_addr.
+
+The use of GUEST_MEMFD_FLAG_SUPPORT_SHARED will not be allowed for CoCo VMs.
+This is validated when the guest_memfd instance is bound to the VM.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9857022a0f0c..4cc824a3a7c9 100644
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
index 6261d8638cd2..6c75f933bfbe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4840,6 +4840,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_supports_gmem(kvm);
+#endif
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	case KVM_CAP_GMEM_SHARED_MEM:
+		return !kvm || kvm_arch_vm_supports_gmem_shared_mem(kvm);
 #endif
 	default:
 		break;
-- 
2.49.0.1045.g170613ef41-goog


