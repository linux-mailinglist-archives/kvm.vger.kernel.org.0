Return-Path: <kvm+bounces-7765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B4F846113
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 20:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF0BC1F276E3
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1518527B;
	Thu,  1 Feb 2024 19:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuIuNajf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779B06D39;
	Thu,  1 Feb 2024 19:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816292; cv=none; b=uXIR/gB+kYzb5pvGsnEya57hG6ofeYBKrP1LfzPIUt8p7CrvuX3eM/IOKodLH8R5DVERESAWxLZXb20Y6vAvK+7dCudzwi0xtDpTtrJEH1/jpK5yMW/UV7j2dEz6IUyvKcerafIOmNMM1uX0ACkv7LCDI2ITw0sOdwmlK7SM3Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816292; c=relaxed/simple;
	bh=Pc8RJJh2G6jJWkbbYSZ2kbzKYJeZHz+HBeINvqtqkOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBe25lWU1xOw8SwOYXYQccQS8iHBHe3WN/moXCqEq7vDECxtxA7VHYrXGtoFQJvcaGtoFCTIOzu6e8eeZLZkoYSr6zoI/eeyHFQIPxhEakiDjz+pVxb8bC8y/BwHPjYHBckjH2tMZtbsI+3fU6NmPKrcBU3+5F3VSJ08Hkz+5JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuIuNajf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5D0C433F1;
	Thu,  1 Feb 2024 19:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816291;
	bh=Pc8RJJh2G6jJWkbbYSZ2kbzKYJeZHz+HBeINvqtqkOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KuIuNajfDKG7/E3ZIeBHtV8/CFSrNKOmaY0nx8dkI1GH6VMIRsyZxDrqaI/vwG0vB
	 KDp9YxOgUAVfuq2bbtqh+KGA3/3/Wrkf4MSI36WHQXy6daeHlgWKK4eA1nyoq3hGQY
	 pESBJ3BX6KstsHRVP3NdvYGcHpJBrKEs8HBPZdKEnzoUJmcUFF8qPjBkmVWLkIIA/V
	 VFIbbNlj2joyAFFwNC8nQA7KLn21Aa/uh5ldgZArRkj++y0xY6WfVk/0i0fmEi6I+D
	 9iqe/X1HD/ZPIk9XpcRu3O85JYIraeMKU/sMwCQK1rXpbxWQSEcLA3VRgzAdPDFvHK
	 OuvcYIYaquUNA==
Date: Thu, 1 Feb 2024 12:38:09 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Rientjes <rientjes@google.com>, llvm@lists.linux.dev
Subject: Re: [PATCH, RESEND] x86/sev: Fix SEV check in sev_map_percpu_data()
Message-ID: <20240201193809.GA2710596@dev-arch.thelio-3990X>
References: <20240124130317.495519-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124130317.495519-1-kirill.shutemov@linux.intel.com>

On Wed, Jan 24, 2024 at 03:03:17PM +0200, Kirill A. Shutemov wrote:
> The function sev_map_percpu_data() checks if it is running on an SEV
> platform by checking the CC_ATTR_GUEST_MEM_ENCRYPT attribute. However,
> this attribute is also defined for TDX.
> 
> To avoid false positives, add a cc_vendor check.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Fixes: 4d96f9109109 ("x86/sev: Replace occurrences of sev_active() with cc_platform_has()")
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Acked-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/kernel/kvm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index dfe9945b9bec..428ee74002e1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -434,7 +434,8 @@ static void __init sev_map_percpu_data(void)
>  {
>  	int cpu;
>  
> -	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
> +	if (cc_vendor != CC_VENDOR_AMD ||
> +	    !cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
>  		return;
>  
>  	for_each_possible_cpu(cpu) {
> -- 
> 2.43.0
> 

Our CI has started seeing a build failure as a result of this patch when
using LLVM to build x86_64_defconfig + CONFIG_GCOV_KERNEL=y +
CONFIG_GCOV_PROFILE_ALL=y:

  $ echo 'CONFIG_GCOV_KERNEL=y
  CONFIG_GCOV_PROFILE_ALL=y' >kernel/configs/gcov.config

  $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper defconfig gcov.config vmlinux
  ...
  ld.lld: error: undefined symbol: cc_vendor
  >>> referenced by kvm.c
  >>>               arch/x86/kernel/kvm.o:(kvm_smp_prepare_boot_cpu) in archive vmlinux.a
  ...

I was somewhat confused at first why this build error only shows up with
GCOV until I looked at the optimized IR. This configuration has
CONFIG_ARCH_HAS_CC_PLATFORM=n, which means that cc_vendor is declared
but not defined anywhere, so I was expecting an unconditional error.
Looking closer, I realized that cc_platform_has() evaluates to
false in that configuration, so the compiler can always turn

  if (cond || !false)
      action();

into

  action();

but it seems like with the GCOV instrumentation, it keeps both branches
(since GCOV is about code coverage, it makes sense that you would want
to see if each branch is ever taken). I can eliminate the error with the
following diff, I am not sure if that is too much though.

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 428ee74002e1..4432ee09cbcb 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -434,7 +434,7 @@ static void __init sev_map_percpu_data(void)
 {
 	int cpu;
 
-	if (cc_vendor != CC_VENDOR_AMD ||
+	if ((IS_ENABLED(CONFIG_ARCH_HAS_CC_PLATFORM) && cc_vendor != CC_VENDOR_AMD) ||
 	    !cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return;
 
Perhaps another solution would be to just

  #define cc_vendor (CC_VENDOR_NONE)

if CONFIG_ARCH_HAS_CC_PLATFORM is not set, since it can never be changed
from the default in arch/x86/coco/core.c.

diff --git a/arch/x86/include/asm/coco.h b/arch/x86/include/asm/coco.h
index 6ae2d16a7613..f3909894f82f 100644
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -10,13 +10,13 @@ enum cc_vendor {
 	CC_VENDOR_INTEL,
 };
 
-extern enum cc_vendor cc_vendor;
-
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
+extern enum cc_vendor cc_vendor;
 void cc_set_mask(u64 mask);
 u64 cc_mkenc(u64 val);
 u64 cc_mkdec(u64 val);
 #else
+#define cc_vendor (CC_VENDOR_NONE)
 static inline u64 cc_mkenc(u64 val)
 {
 	return val;

Cheers,
Nathan


