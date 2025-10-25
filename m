Return-Path: <kvm+bounces-61088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3372EC09AE5
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 18:45:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C948D4F3C8F
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 16:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3E130C356;
	Sat, 25 Oct 2025 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UirOREv9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9882F7ADB;
	Sat, 25 Oct 2025 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409356; cv=none; b=D36BNAUYSqu0zAaTUZy451G0o1EJNOwKfX24XhJ2rI5Fq7ZcY+3szgC98Gqf2EU/BWQxtBYmQvYw4ZT+FcT/ctEJxxP+O7hBCKwWdNKG7G4ij/MFtmNCc8wt1UP6auBVmE8/wSOPGWPJg9LGarbTJsLhMWN60/2bbLcdNh26Zgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409356; c=relaxed/simple;
	bh=Scyd5qEDWJqJQEzt5obIOadjeCJCp5CBwuOwu4LwHsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NcW7sY4tTc2chMN7H+2q0GhmV7RrxGq7+nuQ+70XUawwusararwkRX/JjZGmRK33lyQw+cC1uH2YNgyt2+O669Aw9KwbiIb4sCNb/CEoavGYhUOkdoeT4BIXHk5MRMAGffoqugRIJ3pnvoLVyhanHExx1CAKokodr+rPh+C6Y68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UirOREv9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F706C4CEFB;
	Sat, 25 Oct 2025 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409356;
	bh=Scyd5qEDWJqJQEzt5obIOadjeCJCp5CBwuOwu4LwHsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UirOREv9sYR8FYy4at1GfAVYjMzSo5NJOhpIzdhF0yOhFCzQVn5hQO5QRKZgai+Tx
	 qWDFi4xJsYnwAdptGQFnPKlhNiXZmXfZ6HYOHIX/isfX8ECymfyN02d5OhNC4rZ3tR
	 OZ4D36dXf9ogcmLbUZvfvV/XnerBfEIP4oWOVHVXTL96dLfYawmt6Qj3s7hEHpGLD7
	 2IJCVidxoVTnnCGnbynDeRN/65wpJZ9bh7gvFEtwcZVSHVabpr1p5I7YRwTAc2jYuG
	 JbBuaffdmOY0qwBMDxrZPMMk4zh/BGldwLGooti+QaXFYikX/qLlql2m7U0patgZGK
	 3wol22IpvaeTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kas@kernel.org,
	dwmw@amazon.co.uk,
	mingo@kernel.org,
	bp@alien8.de,
	alexandre.f.demers@gmail.com,
	coxu@redhat.com,
	peterz@infradead.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] x86/kexec: Disable kexec/kdump on platforms with TDX partial write erratum
Date: Sat, 25 Oct 2025 11:58:39 -0400
Message-ID: <20251025160905.3857885-288-sashal@kernel.org>
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

[ Upstream commit b18651f70ce0e45d52b9e66d9065b831b3f30784 ]

Some early TDX-capable platforms have an erratum: A kernel partial
write (a write transaction of less than cacheline lands at memory
controller) to TDX private memory poisons that memory, and a subsequent
read triggers a machine check.

On those platforms, the old kernel must reset TDX private memory before
jumping to the new kernel, otherwise the new kernel may see unexpected
machine check.  Currently the kernel doesn't track which page is a TDX
private page.  For simplicity just fail kexec/kdump for those platforms.

Leverage the existing machine_kexec_prepare() to fail kexec/kdump by
adding the check of the presence of the TDX erratum (which is only
checked for if the kernel is built with TDX host support).  This rejects
kexec/kdump when the kernel is loading the kexec/kdump kernel image.

The alternative is to reject kexec/kdump when the kernel is jumping to
the new kernel.  But for kexec this requires adding a new check (e.g.,
arch_kexec_allowed()) in the common code to fail kernel_kexec() at early
stage.  Kdump (crash_kexec()) needs similar check, but it's hard to
justify because crash_kexec() is not supposed to abort.

It's feasible to further relax this limitation, i.e., only fail kexec
when TDX is actually enabled by the kernel.  But this is still a half
measure compared to resetting TDX private memory so just do the simplest
thing for now.

The impact to userspace is the users will get an error when loading the
kexec/kdump kernel image:

  kexec_load failed: Operation not supported

This might be confusing to the users, thus also print the reason in the
dmesg:

  [..] kexec: Not allowed on platform with tdx_pw_mce bug.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Link: https://lore.kernel.org/all/20250901160930.1785244-5-pbonzini%40redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Why This Fix Matters**
- Prevents machine checks during kexec/kdump on early TDX-capable
  platforms with the “partial write to TDX private memory” erratum.
  Without this, the new kernel may hit an MCE after the old kernel
  jumps, which is a hard failure affecting users.

**What Changed**
- Adds an early guard in the kexec image load path to reject kexec/kdump
  if the CPU bug is present:
  - `arch/x86/kernel/machine_kexec_64.c:361`: `if
    (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE)) { ... return -EOPNOTSUPP; }`
  - `arch/x86/kernel/machine_kexec_64.c:362`: Prints a one-time reason:
    “Not allowed on platform with tdx_pw_mce bug”
  - The check runs before page table setup and other preparation,
    minimizing side effects.

**Where the Bug Flag Comes From**
- Bug flag definition: `arch/x86/include/asm/cpufeatures.h:543` defines
  `X86_BUG_TDX_PW_MCE`.
- Detection/enablement on TDX host platforms:
  - `arch/x86/kernel/cpu/common.c:2124`: Calls `tdx_init()` during boot
    CPU identification.
  - `arch/x86/virt/vmx/tdx/tdx.c:1465`: `tdx_init()` calls
    `check_tdx_erratum()`.
  - `arch/x86/virt/vmx/tdx/tdx.c:1396`: `check_tdx_erratum()` sets the
    bug via `setup_force_cpu_bug(X86_BUG_TDX_PW_MCE)` for affected
    models (`:1407`).
- If TDX host support is not built, `tdx_init()` is a stub and the bug
  bit is never set (guard becomes a no-op). This scopes the behavior to
  kernels configured with TDX host support as intended.

**Effect on Callers**
- kexec fast-fails when loading the image:
  - `kernel/kexec.c:142`: `ret = machine_kexec_prepare(image);`
  - `kernel/kexec_file.c:416`: `ret = machine_kexec_prepare(image);`
- Userspace sees `EOPNOTSUPP` and dmesg logs the rationale, avoiding a
  crash later at handoff.

**Scope and Risk**
- Small, localized change; no architectural refactor.
- Only affects x86-64 kexec/kdump on systems where the bug flag is set;
  no behavioral change for others.
- Conservative by design: disallows kexec/kdump to prevent hard machine
  checks.
- Reuse of existing CPU-bug infrastructure ensures correctness and
  stability.

**Dependencies/Backport Notes**
- Requires `X86_BUG_TDX_PW_MCE` to exist and be set on affected hardware
  (see cpufeatures and TDX init paths). If a target stable branch lacks
  this bug flag or `tdx_init()` path, the guard must be adapted or
  prerequisite patches included.

**Stable Criteria**
- Fixes a real user-visible reliability issue (hard MCE on reboot-to-
  crash kernel).
- Minimal and contained change with low regression risk.
- No new features or architectural changes; limited to x86 kexec path.
- Behavior matches stable policy: prefer preventing fatal errors over
  risky runtime mitigation.

Given the above, this is a good candidate for backporting to stable
trees that include TDX host infrastructure and the corresponding bug
flag.

 arch/x86/kernel/machine_kexec_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 697fb99406e6b..754e95285b910 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -346,6 +346,22 @@ int machine_kexec_prepare(struct kimage *image)
 	unsigned long reloc_end = (unsigned long)__relocate_kernel_end;
 	int result;
 
+	/*
+	 * Some early TDX-capable platforms have an erratum.  A kernel
+	 * partial write (a write transaction of less than cacheline
+	 * lands at memory controller) to TDX private memory poisons that
+	 * memory, and a subsequent read triggers a machine check.
+	 *
+	 * On those platforms the old kernel must reset TDX private
+	 * memory before jumping to the new kernel otherwise the new
+	 * kernel may see unexpected machine check.  For simplicity
+	 * just fail kexec/kdump on those platforms.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_TDX_PW_MCE)) {
+		pr_info_once("Not allowed on platform with tdx_pw_mce bug\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* Setup the identity mapped 64bit page table */
 	result = init_pgtable(image, __pa(control_page));
 	if (result)
-- 
2.51.0


