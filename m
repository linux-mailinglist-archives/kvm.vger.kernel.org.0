Return-Path: <kvm+bounces-45203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21136AA6D02
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 10:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B57B07B531C
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 08:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534D822F176;
	Fri,  2 May 2025 08:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJ1UtPGa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4589522D789;
	Fri,  2 May 2025 08:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746175957; cv=none; b=SS2R6N7HECSKz1Wecb2THWN6pjD/cIiDk3D0lQCV42RQ0eSTvagUAda3lh61L7CCY30GSU3aDqmxiJQj4EPJV0WpoCdvvdPT3HEqoVZO3GcsgewpBdaTbjinvJnhtV121s+mcQf20pePoueALSm9GscBGvZ+881A+3UYoHssZ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746175957; c=relaxed/simple;
	bh=SxBjkp/J5NNckAueMrQukPtaJ3IgnM76Ll+NdIUNXIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfSRfmC+stH6QESYjsTOt9lSx0tYRU2wUa7Dw4EvtuigoHYt96TzL5Rz4xapizo/oNFprUNWsU9vzoqaNIs7e/mhk/Zgm9Qib+bouqLmRjXMG9/eKrBA7XWEgQUmNywaMJpkUT1cZlvqEd1mSpiHc9Rez3g2lmChG0jKUr4ESys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJ1UtPGa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD4BC4CEE4;
	Fri,  2 May 2025 08:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746175956;
	bh=SxBjkp/J5NNckAueMrQukPtaJ3IgnM76Ll+NdIUNXIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJ1UtPGazPk6ZEG0HwcxHRuFOiH/JR3XBtmKJLiHP/jshRcy9Arm4mvyGtimOvgTy
	 OmBKdXEFyjZ8BZMwd8D5Yrhyf1bz+OVbfKouNV2DcQM8RRSV+d8/qkqc9y00t15W+1
	 79vLoiUJcrIIg1H9/yghIFiGnP5DFIedHMd4MJHdsNaPcS8RGk10pBZFuSDnIKldZI
	 i66CAPb8L+3qEo576w8fnUHJl5uZTEiJZdpOmBXZziTwORlH5NpUwvvKUbp9Waeu+E
	 Y/YctucrsKzRC6TBuMOLWKYkj+excCXHWTN55BMKpApl0iGcZF2wL5SK+lxFB1I13T
	 UP3Jz5dY9bM3g==
Date: Fri, 2 May 2025 10:52:26 +0200
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
Message-ID: <aBSHyo-pu7K_CfpI@gmail.com>
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

> For some reason, there are some TSC-related functions in the MSR
> header even though there is a tsc.h header.
> 
> Relocate rdtsc{,_ordered}() from <asm/msr.h> to <asm/tsc.h>, and
> subsequently remove the inclusion of <asm/msr.h> in <asm/tsc.h>.
> 
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> --- a/arch/x86/include/asm/tsc.h
> +++ b/arch/x86/include/asm/tsc.h
> @@ -7,7 +7,81 @@
>  
>  #include <asm/cpufeature.h>
>  #include <asm/processor.h>
> -#include <asm/msr.h>

Note that in the tip:x86/msr commit I've applied today I've 
intentionally delayed the removal of this header dependency, to reduce 
the probability of breaking -next today or in the near future.

We can remove that now superfluous header dependency in a future patch.

Thanks,

	Ingo

