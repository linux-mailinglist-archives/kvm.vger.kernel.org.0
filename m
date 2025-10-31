Return-Path: <kvm+bounces-61681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD815C24F92
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 13:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D2B23BC7B6
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 12:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F10634844A;
	Fri, 31 Oct 2025 12:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="YYmgil9l"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7618A2DC766;
	Fri, 31 Oct 2025 12:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761913315; cv=none; b=BBmwwA88vIC4Daq6yewpteRfqDcx+znmMmRLm4ksJTqOFv89P2hcRlIVGo93gW746RrgxZIk0Pefypdk9qDXr1onP9OJTn6FDiQ2VYNyN9LX75XY7/MzImnr5lScHEeJC4jei71Bj31RSVacmr2gom8y+qe0ORpwjJJJX6H5I5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761913315; c=relaxed/simple;
	bh=uUz+WJz0AhBq+GccWtcHFgbwZw1qkTsi4mIMZTyjwJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4aIY3o/uXJEhrDWA30YV/Gw84jf5/hZiKclGff5rRp8XFGRjbQOoKUUx2vZw3P+x3qwNmNqG0wULm6597Z09Oxw5EPS6srO40nKQtAg9dvOGqyp6sv2eyBZ3XUcudDr9XGOod1JwC+c27CksM0KvzTXmprTaHOmlKl8rEamNTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=YYmgil9l; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0343840E0225;
	Fri, 31 Oct 2025 12:21:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pcvSBFS7-lU9; Fri, 31 Oct 2025 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761913305; bh=Jr5fpbDSL95/OvscEnqB0dNPgRynpl0g4+v+F7hO+bo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YYmgil9lDEqD6QqCo5Syrj8EB9kn3LFUt8BxQiQduw01/qwN1Vf7pcsQa6fl5s+1W
	 PEafeJY7v2GC6M/I/MWF5/VwvIQmLcj3jbi7LALUwvLI9MmYLHbLxwOrKxSF8VPQNH
	 ZE39HkwiUIMREwNZD0cv81tnGGW1jbAlNO2K6ZUoY0aQRwpD7A0uJHpU8ZcD/rt7JA
	 lIdy8kwbK513cdWsGXP+Bgi6pOliPnNZ4dAIWxmsWnm3sdGEODLryeYtDbi+2RkRAX
	 mYJi0ssTPoqCZEQrNnciCre99VZsf7Bu2WpT3Sbx7WsQx77V2iwJdkWmrCDEFwjnhO
	 CY9/rqOM9XUyo9AZInxmerOzX1oaN21/N7KyINhGN107rjLEeCOlyGkx5iKI5G7yfI
	 R5u4+GqSAnpe35r6Liz7xm35Rdsq5JwPCAqBbYupNJsgmazREV/p1Xhugnql1Ff5sl
	 SoaOV2T/Hrbi9OKWPbpD0hjwiIVbS98b+akFLtRIPQMk9UNapAoZvi5xdaKB7ejTqq
	 /VCmHNTsMpMRA5syjEu9Fqu+dKEfmS2f/grQMFygmxHpJvHIrE8LCguORGydmUCt7b
	 dqftMxjUKWbzBnmtIBMOgGsZTOy8rqdy4S+77Uv/mUDwMtbi/0grS3CE93VnG4aqax
	 YU1oFIe1WyOJ3hQ0tjohOiI0=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 4523D40E016D;
	Fri, 31 Oct 2025 12:21:29 +0000 (UTC)
Date: Fri, 31 Oct 2025 13:21:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	weijiang.yang@intel.com, chao.gao@intel.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	tglx@linutronix.de, thomas.lendacky@amd.com
Subject: [PATCH] x86/coco/sev: Convert has_cpuflag() to use
 cpu_feature_enabled()
Message-ID: <20251031122122.GKaQSpwhLvkinKKbjG@fat_crate.local>
References: <20250924200852.4452-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250924200852.4452-1-john.allen@amd.com>

On Wed, Sep 24, 2025 at 08:08:50PM +0000, John Allen wrote:
> For shadow stack support in SVM when using SEV-ES, the guest kernel
> needs to save XSS to the GHCB in order for the hypervisor to determine
> the XSAVES save area size.
> 
> This series can be applied independently of the hypervisor series in
> order to support non-KVM hypervisors.
> ---
> v3:
>   - Only CPUID.0xD.1 consumes XSS. Limit including XSS in GHCB for this
>     case.
> v2:
>   - Update changelog for patch 2/2
> 
> John Allen (2):
>   x86/boot: Move boot_*msr helpers to asm/shared/msr.h
>   x86/sev-es: Include XSS value in GHCB CPUID request
> 
>  arch/x86/boot/compressed/sev.c    |  7 ++++---
>  arch/x86/boot/compressed/sev.h    |  6 +++---
>  arch/x86/boot/cpucheck.c          | 16 ++++++++--------
>  arch/x86/boot/msr.h               | 26 --------------------------
>  arch/x86/coco/sev/vc-shared.c     | 11 +++++++++++
>  arch/x86/include/asm/shared/msr.h | 15 +++++++++++++++
>  arch/x86/include/asm/svm.h        |  1 +
>  7 files changed, 42 insertions(+), 40 deletions(-)
>  delete mode 100644 arch/x86/boot/msr.h

---

Ontop:

From: "Borislav Petkov (AMD)" <bp@alien8.de>
Date: Thu, 30 Oct 2025 17:59:11 +0100
Subject: [PATCH] x86/coco/sev: Convert has_cpuflag() to use cpu_feature_enabled()

Drop one redundant definition, while at it.

There should be no functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/boot/startup/sev-shared.c | 2 +-
 arch/x86/coco/sev/vc-handle.c      | 1 -
 arch/x86/coco/sev/vc-shared.c      | 2 +-
 arch/x86/lib/kaslr.c               | 2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/startup/sev-shared.c b/arch/x86/boot/startup/sev-shared.c
index 4e22ffd73516..a0fa8bb2b945 100644
--- a/arch/x86/boot/startup/sev-shared.c
+++ b/arch/x86/boot/startup/sev-shared.c
@@ -12,7 +12,7 @@
 #include <asm/setup_data.h>
 
 #ifndef __BOOT_COMPRESSED
-#define has_cpuflag(f)			boot_cpu_has(f)
+#define has_cpuflag(f)			cpu_feature_enabled(f)
 #else
 #undef WARN
 #define WARN(condition, format...) (!!(condition))
diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index 7fc136a35334..f08c7505ed82 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -352,7 +352,6 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 
 #define sev_printk(fmt, ...)		printk(fmt, ##__VA_ARGS__)
 #define error(v)
-#define has_cpuflag(f)			boot_cpu_has(f)
 
 #include "vc-shared.c"
 
diff --git a/arch/x86/coco/sev/vc-shared.c b/arch/x86/coco/sev/vc-shared.c
index e2ac95de4611..58b2f985d546 100644
--- a/arch/x86/coco/sev/vc-shared.c
+++ b/arch/x86/coco/sev/vc-shared.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #ifndef __BOOT_COMPRESSED
-#define has_cpuflag(f)                  boot_cpu_has(f)
+#define has_cpuflag(f)                  cpu_feature_enabled(f)
 #endif
 
 static enum es_result vc_check_opcode_bytes(struct es_em_ctxt *ctxt,
diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
index b5893928d55c..8c7cd115b484 100644
--- a/arch/x86/lib/kaslr.c
+++ b/arch/x86/lib/kaslr.c
@@ -22,7 +22,7 @@
 #include <asm/setup.h>
 
 #define debug_putstr(v) early_printk("%s", v)
-#define has_cpuflag(f) boot_cpu_has(f)
+#define has_cpuflag(f) cpu_feature_enabled(f)
 #define get_boot_seed() kaslr_offset()
 #endif
 
-- 
2.51.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

