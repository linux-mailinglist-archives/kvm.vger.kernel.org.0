Return-Path: <kvm+bounces-41401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BDEEA67921
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E6E9884B5F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D6B2116F1;
	Tue, 18 Mar 2025 16:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OzCYUQwS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95642116E0
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314718; cv=none; b=CvqZnZR5QzsJxQARQPPDLq43UF0vGXWVsscVl4Rb957maLAx/7aR2nsM7CS2bvkM1f1/V8jKgDJk4f2czOwg9U99zAFBHdLh3h7AQJaiVp2EMdaAS9DkbHtwLdJyWhc2+d/oRs+RwsBgpacbJlqLABF9BtjovYBOnkj++aY07Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314718; c=relaxed/simple;
	bh=jf+B2iS70Uwb6ZtEVIm5gx07fxqJEaEZ6wF2FlUqvaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sK0wyc/qUNMQFkHFFqY2coHYeZ6v46lTZJ6Z5bcBf/ShNPgFpgMXI/EdUCnjX9S80B7DgmOjBvvHTgaBk9Ss5kYzMhPnPoDa83P9Y3OEkzgaMvFjLl/fIja5IWTtCyyMTuYgJlsA97F8/9wb7JDcB3UI1BvN5YvUJarkzS64AFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OzCYUQwS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43943bd1409so23509195e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314715; x=1742919515; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4fZ+plV8ov9Z8BdTSvHhlcpnsxWp2MsGy/DzmNzLSwM=;
        b=OzCYUQwSa40zpZxULJjvGJMA908t/BIgWYi7exYAX2mF8KRsw0aBFM1euiEPOMvee3
         xpjYU9Vvzu2bxpKQO5iEH1BA3ovHQKZ8ajqxo8DAwj7gvrkokFqkg32UHowOCO8cYF9g
         RmcjNN06aazcVxaBVqmSLMiPg/2ApKyeh8AU5eSTO+6zMJdzb5+V2VjeUaeD64J9zSDh
         2+qJQBr0sKNzS2zu8uVq61RhBMS0eXeFKRYmvywG+pRe2gKmXci0lJtacfjPWudKesAM
         2aKtMup0JBXvOZKepRQ8A74cmlqLim7byZVT46tGcHVmPuC9GINHUR7ScfImbfkNB48y
         9dIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314715; x=1742919515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4fZ+plV8ov9Z8BdTSvHhlcpnsxWp2MsGy/DzmNzLSwM=;
        b=GWvC8w6Lc2I8HsCCAGf2SMVxFnEJpSebyv4/PZhUStBFj7nn8CE6i6JyKQsO3WMgmz
         Woij8GlVS2jt9xQPeluPwrJZrbBvP0NpUVEONKQVuPEYVsdylaHQsdwnmQ/ReuAfKFd8
         banInDYIaWu1cG9W9TCX00blM480h+P7ZwJJ2ESWYG7mKY47pVCOLrmqrduXA3yatOQZ
         Npp0QtMFc60E/RxEm6Ce2lnGhRNrQ4nFkKDjFK2gUmQxwlC0lB2VO+fDvDkPYPBZVRuB
         mJXGLW3XL+Z2HMaTJ+7oA+jSJUhkSSlJV28o/sQsVGJVP8ADZe56EpehmWk8g3ZsznM/
         njxw==
X-Gm-Message-State: AOJu0YwGiNCYnR9nhg12Hn50vxQ0WpgetFvwNRboQXIVlHnkKN6a0eqb
	zLpNhNBcfKAzuARUhOdK4Vyvt9N4gMqAHsQU7EIOpsE+ubWrTQgSSQhK9V3xXLF+qUhBZzAyQad
	64JcdzzCJly/iOBIvmiUVtrxaTbGZ9CKPMtHtWI5qVGevspdfMDeVs3OHwnKLXxW5usqXfekdD8
	DxL/i1mfObW3LZtPuolxyiktU=
X-Google-Smtp-Source: AGHT+IE5r6NZGIAwIlUsfF8t936pPzkXscDur3evGfQYik55htUq2uf1gHv3wGk0726Sq8CrcfH6U2o3QA==
X-Received: from wmbgx13.prod.google.com ([2002:a05:600c:858d:b0:43d:8f:dd29])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e0e:b0:43d:45a:8fbb
 with SMTP id 5b1f17b1804b1-43d3b9d46bdmr25410005e9.22.1742314714991; Tue, 18
 Mar 2025 09:18:34 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:18:19 +0000
In-Reply-To: <20250318161823.4005529-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318161823.4005529-6-tabba@google.com>
Subject: [PATCH v7 5/9] KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as supporting
 guest_memfd shared memory
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The KVM_X86_SW_PROTECTED_VM type is meant for experimentation and
does not have any underlying support for protected guests. This
makes it a good candidate for testing mapping shared memory.
Therefore, when the kconfig option is enabled, mark
KVM_X86_SW_PROTECTED_VM as supporting shared memory.

This means that this memory is considered by guest_memfd to be
shared with the host, with the possibility of in-place conversion
between shared and private. This allows the host to map and fault
in guest_memfd memory belonging to this VM type.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/Kconfig            | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ae3aa50c7e..b874e54a5ee4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2246,8 +2246,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+
+#define kvm_arch_gmem_supports_shared_mem(kvm)         \
+	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&      \
+	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM))
 #else
 #define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_gmem_supports_shared_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ea2c4f21c1ca..22d1bcdaad58 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -45,7 +45,8 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+	select KVM_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+	select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
-- 
2.49.0.rc1.451.g8f38331e32-goog


