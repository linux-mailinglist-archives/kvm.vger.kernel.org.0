Return-Path: <kvm+bounces-61089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1344C099C5
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 18:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A07BD424991
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 16:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456B630E824;
	Sat, 25 Oct 2025 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sKZNpQP1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6711A3090CB;
	Sat, 25 Oct 2025 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409445; cv=none; b=bEIP5RopOswToi+a8NwbgLmce607aeUbaT8CkoincyPH0EdkDmuFYOfvdk2G2KFxUzCiEBoMeTdWw9HEV7qMpFYMFKIfC787RlNM0Uy1j0PmSb46l9YfNB532wDmgewRGthpifCXW01aDi1fKBDA7BFVbPXFtHD7503xxDXbMHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409445; c=relaxed/simple;
	bh=mIzmgwyZLuHoMCkfF8ACP+1cuYslvilvOq7youLoTu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UFkrIDJfLIj88cyTrlcQhefUhPH6KXLlaL3GTlwC5DxsllgpmDkOkur33HIYO2aqEVBh7puLRvUZcaSMJtGsSLkhNmlkkcRhHzV58s+BDEc40VqEagTENwBD7coRimPSXmBTftUL8eyNtcwgtzS3fT0phJ7cP+nYmdCduzM7HmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sKZNpQP1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD9BC113D0;
	Sat, 25 Oct 2025 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409445;
	bh=mIzmgwyZLuHoMCkfF8ACP+1cuYslvilvOq7youLoTu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKZNpQP1GelEK2viat3FtrtVpCWnkBJVQLkLJhKZvVfqYL3dPQzS9idz2DnWNe5ED
	 ObPgiajVNwMpz04c75V6uQN3ECF6+EbRYoZsdEGOweKvtbNG3ez0J21FmamvwwzCaD
	 ZbFtfTv08ahryxyFjc/COf3J0xdqv1msQBss6vKvGvKQyko1FbZKkx5nSbfosvc6z2
	 BzXTSyM8uYf7kkUGMZUPP3b8bWrusqXMVJFN/KUepN/WXDBK0h5Jn3+V6IwQ+WRUPI
	 aZLax2DCxr7gTUEP+4fbDFymbf9Vx1Eml9NpMNduH+aTMohNhdhs1xJ3+Mkr6zgjIC
	 JWwSNvZqRkUtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kas@kernel.org,
	isaku.yamahata@intel.com,
	alexandre.f.demers@gmail.com,
	thuth@redhat.com,
	vannapurve@google.com,
	adrian.hunter@intel.com,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
Date: Sat, 25 Oct 2025 11:59:19 -0400
Message-ID: <20251025160905.3857885-328-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

[ Upstream commit 10df8607bf1a22249d21859f56eeb61e9a033313 ]

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Link: https://lore.kernel.org/all/20250901160930.1785244-4-pbonzini%40redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this fixes a real bug
- TDX can leave dirty cachelines for private memory with different
  encryption attributes (C-bit aliases). If kexec interrupts a CPU
  during a SEAMCALL, its dirty private cachelines can later be flushed
  in the wrong order and silently corrupt the new kernel’s memory.
  Marking the CPU’s cache state as “incoherent” before executing
  SEAMCALL ensures kexec will WBINVD on that CPU and avoid corruption.

What changed (key points with code references)
- New helper marks per-CPU cache incoherent before any SEAMCALL:
  - arch/x86/include/asm/tdx.h:111 sets
    `this_cpu_write(cache_state_incoherent, true)` in
    `__seamcall_dirty_cache()` and asserts preemption is disabled (lines
    111–128).
- Wrap all `seamcall*()` paths with preemption-disabled critical
  section:
  - arch/x86/include/asm/tdx.h:130–147 uses
    `preempt_disable()/preempt_enable()` in `sc_retry()` so the same CPU
    that sets the flag executes the SEAMCALL, avoiding migration races.
- Convert special direct callers to use the new helper:
  - arch/x86/virt/vmx/tdx/tdx.c:1271 changes `paddr_is_tdx_private()` to
    call `__seamcall_dirty_cache(__seamcall_ret, TDH_PHYMEM_PAGE_RDMD,
    ...)`.
  - arch/x86/virt/vmx/tdx/tdx.c:1522 changes `tdh_vp_enter()` to call
    `__seamcall_dirty_cache(__seamcall_saved_ret, TDH_VP_ENTER, ...)`.
- Consumers of the per-CPU flag during kexec/CPU stop:
  - arch/x86/kernel/process.c:99 defines `cache_state_incoherent` and
    uses it in `stop_this_cpu()` to WBINVD if set
    (arch/x86/kernel/process.c:840).
  - arch/x86/kernel/machine_kexec_64.c:449 sets
    `RELOC_KERNEL_CACHE_INCOHERENT` when the per-CPU flag is set so
    `relocate_kernel_64.S` executes WBINVD (relocate path).
  - The TDX-specific flush routine will WBINVD and clear the flag if
    needed (arch/x86/virt/vmx/tdx/tdx.c:1872–1887).

Why it’s safe to backport
- Scope-limited: touches only TDX host paths and the seamcall wrappers;
  no ABI or architectural changes.
- Minimal risk: setting a per-CPU boolean and wrapping SEAMCALLs with
  preempt disable. SEAMCALLs are long; added preemption control is
  negligible overhead and avoids CPU migration races.
- Correctness across contexts: SEAMCALLs can happen with IRQs disabled;
  the helper asserts preemption is off, and the wrappers explicitly
  ensure it. The two special direct-call sites run in contexts where
  IRQs are off or preemption is already disabled.
- Aligns with existing kexec logic: Stable trees already check
  `cache_state_incoherent` during CPU stop and relocation
  (arch/x86/kernel/process.c:840,
  arch/x86/kernel/machine_kexec_64.c:449).

Dependencies/assumptions for stable trees
- Requires the per-CPU `cache_state_incoherent` infrastructure and kexec
  consumers:
  - Declaration: arch/x86/include/asm/processor.h:734
  - Definition/usage: arch/x86/kernel/process.c:99,
    arch/x86/kernel/process.c:840
  - Kexec integration: arch/x86/kernel/machine_kexec_64.c:449 and
    arch/x86/kernel/relocate_kernel_64.S (WBINVD when
    `RELOC_KERNEL_CACHE_INCOHERENT` set)

Summary
- This is a focused, low-risk bugfix preventing silent memory corruption
  on TDX hosts during kexec by correctly marking and subsequently
  flushing CPUs that might have generated dirty private cachelines
  during SEAMCALLs. It satisfies stable backport criteria (user-visible
  correctness fix, minimal change, localized impact).

 arch/x86/include/asm/tdx.h  | 25 ++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c |  4 ++--
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a698668..0922265c6bdcb 100644
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
index c7a9a087ccaf5..3ea6f587c81a3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1266,7 +1266,7 @@ static bool paddr_is_tdx_private(unsigned long phys)
 		return false;
 
 	/* Get page type from the TDX module */
-	sret = __seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args);
+	sret = __seamcall_dirty_cache(__seamcall_ret, TDH_PHYMEM_PAGE_RDMD, &args);
 
 	/*
 	 * The SEAMCALL will not return success unless there is a
@@ -1522,7 +1522,7 @@ noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *ar
 {
 	args->rcx = tdx_tdvpr_pa(td);
 
-	return __seamcall_saved_ret(TDH_VP_ENTER, args);
+	return __seamcall_dirty_cache(__seamcall_saved_ret, TDH_VP_ENTER, args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_enter);
 
-- 
2.51.0


