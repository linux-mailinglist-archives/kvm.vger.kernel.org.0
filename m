Return-Path: <kvm+bounces-56510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 892FAB3EBEF
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 18:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF6934402EF
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A38630648E;
	Mon,  1 Sep 2025 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gXTA5KjE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FE52E6CD8
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 16:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756742993; cv=none; b=En6G1TlZWRTJaZWQO+jjW51F+LMdgpkpm6fHv25Z1cdEoUcoBUK+V5KfJVI8dGTTVvvDxicuCviN7TskNnZJz7iT4LM49+4RmfmoIZmfDVw44w4/MtG1qNq+OvxA38jYjbIFw4XrijhFAPi/XpehNIjw1KPFw1vPAwRGi3NtsK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756742993; c=relaxed/simple;
	bh=jOAHCUQOI95A6NhD1bdRc7Ks4QP6hIwvLd9f4ISXn+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBYKuA9Rsc3Eo4zkNfnm8xO7TXK2Jia05R4jYZt1iLDMsNW1PDWKHRI+CoiT1qMjQFCyjz8J4ijapGcOcv4AM7lTMkoQqiJOBypJ1FWVWrQN7lwAqCuG/1NVIGkrbL1uEFPSrs+3G7YbNubL/imlu9dWCom2hz5wVsCW/iuy/6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gXTA5KjE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756742991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vlmYPrJMvaurL156kfyVvz/kxSmkc+/T+EJ8CZ+U2zk=;
	b=gXTA5KjE5Jxy/vqnORcKy3qCGatsS9dlgWT1SBJUIf26Ctn+ctfFWv478ogJ/fUrAKYEr5
	MpqkKIBQSmN9tmPxT5Ev5ohZvucvxbpvpUi/9ES+I0MqXTxk57V2qj9anvxizxCsVL5vfR
	LSM/nHygS5wfNWa0CFOL4w2a7/Cw5xM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-CYezVHYTON6-VSLA7AzNmQ-1; Mon, 01 Sep 2025 12:09:50 -0400
X-MC-Unique: CYezVHYTON6-VSLA7AzNmQ-1
X-Mimecast-MFC-AGG-ID: CYezVHYTON6-VSLA7AzNmQ_1756742989
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-70de1a3cec7so79518426d6.3
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 09:09:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756742989; x=1757347789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlmYPrJMvaurL156kfyVvz/kxSmkc+/T+EJ8CZ+U2zk=;
        b=BKUPqVHcCDh2xlVzgNlNW4/xzExm4Rf5jgm1rSSbFSZdAlp0k3sTcm40737I6cx1EB
         UeG7oIYK+rw8s5rXQwP2+pxZ112VfQ+2ltkCH8853DwPD2dEQGnQvCztuld/FoUYBEU6
         Uu7xWpPE9IDadpiJjG3Qje0py16mWTq70XNJhm5NLOyJMVHLYp9Ld0iZkonBsSk87bqs
         j7EdYWn/xdBsCJKOXhmmuDhtEm3p/y5TUuh1FTQwK3AcbE1vJaiCEtBwVBeMW8/9vbVB
         6Yn8Zn3OhDH8J3wCqyiiDPaxt8gWRNkW1sGQ7xat3v79KQOW6mmZvPURJLiB9HqbYczT
         sk8w==
X-Forwarded-Encrypted: i=1; AJvYcCUwWEHhA4aKm+OFFF0YgAUjU11KcSgL/9QlwhNlTuJotr46PHtc3KTQKEKZVPrWoeQCJlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRjqCfXAXNlAdKJ9SHaA5AvczMLaAk1TD89Wa7XZcAKuiJFIpm
	sM0jnnovSddkP73HDMvRAOjFw4mPXGX9oBzfiyipOG4A0gTmQdB2VT6CLTucJXEatpxQkCQQNm4
	d6fEwljw47qmyz4G8n6DcEukQnpfunvtaJbFlW8j+Br46Xq8XbOshKw==
X-Gm-Gg: ASbGncubEgI1f1BM2b6Pq0isTYzhpo1ukk1bNBtWcBak/GFSHtLvCKv+bpz46G1P8Wm
	Vsg0+5QURTU5WA+pKo7X05V2ksTIrkaxBmA1wSG0P4WAgD3uhD0FM6YhAQj4IQjOSSLP/4A7nQb
	0+DHjk0JqVc4ZSLWUIcgJIm865Hvw28niCaEGG+4hQSzIjFrJEHSYmlDe+8gXlAPz3Z1ZChQncR
	oikB9kLNj4pUbC5fxTRmCMqEYihJu9jgOT7rzoBG/yWyfAEvxNbp39qLa2J87nDkZAozCHXwApP
	6RkrqT1BiRMIPgJL2KjUoyEoKwdzBLCiIK/ZLjgLtcnlFkQtYQDTxFWp9TqQT+e7pEIs3UWN4re
	uWOw8k5QwQYUnCbgzNv4riTa2dSOf8L10pqN0EXtOt4CzsYe7xJUqjOJpX4RqEKJZyr0+
X-Received: by 2002:a05:6214:1c8e:b0:70d:9e0a:5ac0 with SMTP id 6a1803df08f44-70fac8dd487mr82340946d6.57.1756742989235;
        Mon, 01 Sep 2025 09:09:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3atxEoR4Y3UwAcVItWfUxbMXJnqefXOjBiiJOc9QLCFCXra+INStGLPsCJ1tjig0u8r6LRA==
X-Received: by 2002:a05:6214:1c8e:b0:70d:9e0a:5ac0 with SMTP id 6a1803df08f44-70fac8dd487mr82340626d6.57.1756742988809;
        Mon, 01 Sep 2025 09:09:48 -0700 (PDT)
Received: from [10.201.49.111] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70fb260d977sm42473206d6.20.2025.09.01.09.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:09:48 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com,
	x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	kai.huang@intel.com,
	seanjc@google.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com
Subject: [PATCH 3/7] x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
Date: Mon,  1 Sep 2025 18:09:26 +0200
Message-ID: <20250901160930.1785244-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250901160930.1785244-1-pbonzini@redhat.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

On TDX platforms, dirty cacheline aliases with and without encryption
bits can coexist, and the cpu can flush them back to memory in random
order.  During kexec, the caches must be flushed before jumping to the
new kernel otherwise the dirty cachelines could silently corrupt the
memory used by the new kernel due to different encryption property.

A percpu boolean is used to mark whether the cache of a given CPU may be
in an incoherent state, and the kexec performs WBINVD on the CPUs with
that boolean turned on.

For TDX, only the TDX module or the TDX guests can generate dirty
cachelines of TDX private memory, i.e., they are only generated when the
kernel does a SEAMCALL.

Set that boolean when the kernel does SEAMCALL so that kexec can flush
the cache correctly.

The kernel provides both the __seamcall*() assembly functions and the
seamcall*() wrapper ones which additionally handle running out of
entropy error in a loop.  Most of the SEAMCALLs are called using the
seamcall*(), except TDH.VP.ENTER and TDH.PHYMEM.PAGE.RDMD which are
called using __seamcall*() variant directly.

To cover the two special cases, add a new __seamcall_dirty_cache()
helper which only sets the percpu boolean and calls the __seamcall*(),
and change the special cases to use the new helper.  To cover all other
SEAMCALLs, change seamcall*() to call the new helper.

For the SEAMCALLs invoked via seamcall*(), they can be made from both
task context and IRQ disabled context.  Given SEAMCALL is just a lengthy
instruction (e.g., thousands of cycles) from kernel's point of view and
preempt_{disable|enable}() is cheap compared to it, just unconditionally
disable preemption during setting the boolean and making SEAMCALL.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  | 25 ++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c |  4 ++--
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 57b46f05ff97..c178360c1fb1 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -102,10 +102,31 @@ u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
 void tdx_init(void);
 
+#include <linux/preempt.h>
 #include <asm/archrandom.h>
+#include <asm/processor.h>
 
 typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
 
+static __always_inline u64 __seamcall_dirty_cache(sc_func_t func, u64 fn,
+						  struct tdx_module_args *args)
+{
+	lockdep_assert_preemption_disabled();
+
+	/*
+	 * SEAMCALLs are made to the TDX module and can generate dirty
+	 * cachelines of TDX private memory.  Mark cache state incoherent
+	 * so that the cache can be flushed during kexec.
+	 *
+	 * This needs to be done before actually making the SEAMCALL,
+	 * because kexec-ing CPU could send NMI to stop remote CPUs,
+	 * in which case even disabling IRQ won't help here.
+	 */
+	this_cpu_write(cache_state_incoherent, true);
+
+	return func(fn, args);
+}
+
 static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 			   struct tdx_module_args *args)
 {
@@ -113,7 +134,9 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 	u64 ret;
 
 	do {
-		ret = func(fn, args);
+		preempt_disable();
+		ret = __seamcall_dirty_cache(func, fn, args);
+		preempt_enable();
 	} while (ret == TDX_RND_NO_ENTROPY && --retry);
 
 	return ret;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 823850399bb7..2abf53ed59c8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1268,7 +1268,7 @@ static bool paddr_is_tdx_private(unsigned long phys)
 		return false;
 
 	/* Get page type from the TDX module */
-	sret = __seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args);
+	sret = __seamcall_dirty_cache(__seamcall_ret, TDH_PHYMEM_PAGE_RDMD, &args);
 
 	/*
 	 * The SEAMCALL will not return success unless there is a
@@ -1524,7 +1524,7 @@ noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *ar
 {
 	args->rcx = tdx_tdvpr_pa(td);
 
-	return __seamcall_saved_ret(TDH_VP_ENTER, args);
+	return __seamcall_dirty_cache(__seamcall_saved_ret, TDH_VP_ENTER, args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_enter);
 
-- 
2.51.0


