Return-Path: <kvm+bounces-60374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55305BEB875
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 22:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F3156E325A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 20:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7482A33DECB;
	Fri, 17 Oct 2025 20:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fprGKKnm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823F6337BB0
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 20:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760731977; cv=none; b=dZz11tUSGorPpN9SHtYiLMVmR27ynWOud6E3Yd88uYI/h6HiVu0SxyEF6CGvM7rinTtIS9y/VqvhC3+4xXZHaH6PibN3yJvplwoy9aMVQEkbKK1IDJcL7FYXC5VUOU5//pmhm6jT7cUEVWwidG83FA1P9MqFaO3BiIxXFDa9rG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760731977; c=relaxed/simple;
	bh=xpaiJEnDZinh9peGS+GUN5rKgVdOnYR4syNnqaW+Eyk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kogg2fSmc/s+sQXLEP5y2UfYMgl31P23NOmypIPU3x8WAcioDYq9rDfhWponMMW52JlI0il7AA843tZrJxJhh/aHt28EvkCWR3kkb7IEkYy+EdxGwq3hSnkXlHPWgl3attm65ku6nBw3U3cHePMfGcN/ap7E70te61YtYU/v8lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fprGKKnm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-26983c4d708so19820275ad.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 13:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731971; x=1761336771; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IHQmo+/9l+Hla8mfwD4OvgjtC6QhXzaCqLReRxzUxFc=;
        b=fprGKKnmSDkkWd8v+fCmHTilPZ8AuzOQhzaUBYKFjf76ywSMaj7baHJIqgrmj57MVR
         0nciXLwjuM/6NQwItKWt6gNRYcHygQep5NOCiff0Lg3gDj1wVGBocw9Ywjv0wRmrsawO
         paskqANTDSNM2F4WdINg+nvLfnzQN9KhpxWlogl8JTSO4cLCSTRRaqBz3dlD6hUXWPiA
         /8vzl2VOK1De6mJBQe2nfxYlpuovBP6aZqMkvTWtY6DOJpO7BUzDiwKkEzbVFiu3D6US
         l8sAgoaGjT1DgoHa3gag9E2rOXsrKs20rL+lWF9+ZsTLDufqjoMS+9cL1X/hWPvoYtPW
         SHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731971; x=1761336771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IHQmo+/9l+Hla8mfwD4OvgjtC6QhXzaCqLReRxzUxFc=;
        b=eMAPWKIdyokHWqNFI/eQZcjF0WNncSSJdlc5V8ZEN7y73rBwljrjN+P7CZqdPLrcIh
         zu8a47lDsbRHuR+CP5YQTpkXejEIr4GrxcZptZpfS/j61tqnN38hHqdblYQDK43hS3iv
         rj6YQ5Ysrl60Ps34bea0OW0S9Cj5M9OMMC3tzJSrRL/9uLYPxChabZh4FvIz2L8yIF0F
         aUivz4KthTbxe+r6OdVkqWqepyavxkINLAmJV09Wv+HOr1qJivAXqPymOz9TLD7nFbRP
         yKw0+vQCNr1h7NjnQur5d8g0Lkit1U4moAEBTjZLu1WCRh6koNy4MyzZ0WvsYa3QNpRJ
         8/4g==
X-Forwarded-Encrypted: i=1; AJvYcCUcVtpXqxA3RuEsXWUcCD93xExr1ozme0umdu4tOS3KJ91ECb8F8OZngHBYnl6rRFbQqM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YweuHTmHOz1PRyQRfrZBkWTdFnUs43ia6quV8Jm23tPjLHozaPb
	MtchMPj9T8ye+PXkwY5YBYnZxF0gcz9Q1EyxarscFwHA6wPza32oPedfb+2D2+0dt6H7U/h5w41
	tGFBrbOUAukZpph7ca0GlaV+pDQ==
X-Google-Smtp-Source: AGHT+IHjLngq9Gz+3lpTwbSTAGILDclyy0S+0yhINh6dVc1pppWh9CmWhkL9jK5CpkjfqLGl2H3Ae/sqhUuPXSzBOA==
X-Received: from pjbbk24.prod.google.com ([2002:a17:90b:818:b0:33b:a0ae:940])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d4c4:b0:27c:3a0f:f066 with SMTP id d9443c01a7336-290c9cbc16fmr54129445ad.22.1760731970364;
 Fri, 17 Oct 2025 13:12:50 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:54 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <78c64979b35f7c1b5edc662bd8dda64b58904e15.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 13/37] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Make vm_memory_attributes a module parameter so that userspace can disable
the use of memory attributes on the VM level.

To avoid inconsistencies in the way memory attributes are tracked in KVM
and guest_memfd, the vm_memory_attributes module_param is made
read-only (0444).

Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
that might use vm_memory_attributes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Drop compile-time check for CONFIG_KVM_VM_MEMORY_ATTRIBUTES in
kvm_gmem_range_is_private() since vm_memory_attributes, if defined false
with a macro, should elide generation of the if block anyway]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 13 +++++++++----
 virt/kvm/kvm_main.c  |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 49c7709e3d895..5cd5046c542ba 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -82,13 +82,20 @@ config KVM_WERROR
 
 config KVM_VM_MEMORY_ATTRIBUTES
 	select KVM_MEMORY_ATTRIBUTES
-	bool
+	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
+	bool "Enable per-VM memory attributes (for CoCo VMs)"
+	help
+	  Enable support for per-VM memory attributes, which are deprecated in
+	  favor of tracking memory attributes in guest_memfd.  Select this if
+	  you need to run CoCo VMs using a VMM that doesn't support guest_memfd
+	  memory attributes.
+
+	  If unsure, say N.
 
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_VM_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -138,7 +145,6 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -162,7 +168,6 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3506a2f2be041..7680c868fd6e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,6 +104,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 bool vm_memory_attributes = true;
+module_param(vm_memory_attributes, bool, 0444);
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
-- 
2.51.0.858.gf9c4a03a3a-goog


