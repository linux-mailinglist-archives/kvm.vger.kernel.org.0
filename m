Return-Path: <kvm+bounces-45199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06BFEAA6C2D
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 10:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 683E71B662B9
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 08:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4F42690F7;
	Fri,  2 May 2025 08:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o40ruDpd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D3426772A;
	Fri,  2 May 2025 08:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746172957; cv=none; b=SsNGsBRXJZfNjBj2nlca3vZEuGbvN3I7SRrrLrzOeaE3tp8BZn43mf1SWIYNiu04HBLXibI4LRyX2YHVuLX70JMLW1Idv8qEOVu4OzWnPJQgHvdR6Kolvxin3w+DWKsBLBjGGMEe99ljp3HGaBSmm5f8l3HwQGKv1nkdRYM889U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746172957; c=relaxed/simple;
	bh=VrP6FYMiM8APrbbiFFr3vwipUq0BMzeGXIdgg8yPKw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCHlu1zSYY41ig/48LvnpO9otB1H8qnK5lJAz2V6++HLw/UNq3c6aR9r71UgJfjDGbsy+AtpDOc80YBA+a7cdxtk3Xv3w2GG7KlqKU8a5xw35u3t9UPtw39myLGqHMyXhxviHVio+U1AdfuDH/o+ZZtfR1jfVUXrKkoKQxEE3Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o40ruDpd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE92BC4CEE4;
	Fri,  2 May 2025 08:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746172956;
	bh=VrP6FYMiM8APrbbiFFr3vwipUq0BMzeGXIdgg8yPKw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o40ruDpdxuzYi5SlPXBVO3KE83CyehxDNrNO/541PgVjFTDFgkp9ttfsSywwoC2Xi
	 deyF+fk2wjQxxc5XQRBVm8Bmt2O6KE/EWUyWPBtkP4DjmRVUsgvwR4qUU7TcNGYno2
	 LrsDSCZuBZAWl/LYiTehIFOfFP/Ile60POceUApHmDdzreBk3ZrpTs99IMSeErgzEI
	 qcVRENdvjn60dt64quynSDl7VztBTPTl/yjYLXHI6ByaM4mPy/wh1yniu8zkGauz6l
	 KWZFS4mxzAp7qh9gzlauN/px1lSmL30l6NU2jcy73WKeezA7wFlGHek2h34pt4xuBA
	 QpbqWIpAjreaA==
Date: Fri, 2 May 2025 10:02:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
	peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
	tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
	seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
	kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
	dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: Re: [PATCH v4 02/15] x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
Message-ID: <aBR8EoYkxaFHwZN2@gmail.com>
References: <20250427092027.1598740-1-xin@zytor.com>
 <20250427092027.1598740-3-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427092027.1598740-3-xin@zytor.com>


* Xin Li (Intel) <xin@zytor.com> wrote:

> index 94408a784c8e..13335a130edf 100644
> --- a/arch/x86/include/asm/tsc.h
> +++ b/arch/x86/include/asm/tsc.h
> @@ -7,7 +7,81 @@
>  
>  #include <asm/cpufeature.h>
>  #include <asm/processor.h>
> -#include <asm/msr.h>
> +
> +/*
> + * both i386 and x86_64 returns 64-bit value in edx:eax, but gcc's "A"
> + * constraint has different meanings. For i386, "A" means exactly
> + * edx:eax, while for x86_64 it doesn't mean rdx:rax or edx:eax. Instead,
> + * it means rax *or* rdx.
> + */
> +#ifdef CONFIG_X86_64
> +/* Using 64-bit values saves one instruction clearing the high half of low */
> +#define DECLARE_ARGS(val, low, high)	unsigned long low, high
> +#define EAX_EDX_VAL(val, low, high)	((low) | (high) << 32)
> +#define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
> +#else
> +#define DECLARE_ARGS(val, low, high)	u64 val
> +#define EAX_EDX_VAL(val, low, high)	(val)
> +#define EAX_EDX_RET(val, low, high)	"=A" (val)
> +#endif

Meh, this patch creates a duplicate copy of DECLARE_ARGS() et al in 
<asm/tsc.h> now:

 arch/x86/include/asm/msr.h:#define DECLARE_ARGS(val, low, high) unsigned long low, high
 arch/x86/include/asm/msr.h:#define DECLARE_ARGS(val, low, high) u64 val
 arch/x86/include/asm/msr.h:     DECLARE_ARGS(val, low, high);
 arch/x86/include/asm/msr.h:     DECLARE_ARGS(val, low, high);
 arch/x86/include/asm/msr.h:     DECLARE_ARGS(val, low, high);
 arch/x86/include/asm/tsc.h:#define DECLARE_ARGS(val, low, high) unsigned long low, high
 arch/x86/include/asm/tsc.h:#define DECLARE_ARGS(val, low, high) u64 val
 arch/x86/include/asm/tsc.h:     DECLARE_ARGS(val, low, high);
 arch/x86/include/asm/tsc.h:     DECLARE_ARGS(val, low, high);
 arch/x86/include/asm/tsc.h:#undef DECLARE_ARGS

Which was both an undeclared change, bloats the code, causes various 
problems, and is totally unnecessary to boot.

Please don't do that ...

Thanks,

	Ingo

