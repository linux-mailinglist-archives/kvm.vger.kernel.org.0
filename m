Return-Path: <kvm+bounces-44764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12987AA0C34
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45E5F980154
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 12:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596D92C2AD8;
	Tue, 29 Apr 2025 12:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=rev.ng header.i=@rev.ng header.b="P7bOC6ZL"
X-Original-To: kvm@vger.kernel.org
Received: from rev.ng (rev.ng [94.130.142.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84A51DE4F3
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 12:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.130.142.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745931178; cv=none; b=fmVhBy78xWSWc4rShtrl2Ry93vpEz2Z5RiDMOiPMWyj94XAKIbHHG7pfu6wg8/GzJEwI0RFokCLe+CsM74QcaK1rmavNNYUlFb8Q8JnOJTU6rsCcu2Czw828/LdV1IiOnrs8A2tu0By7VNt/krh6N+irBt/AZ0rrY/tZyTOIZqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745931178; c=relaxed/simple;
	bh=K+0U3tNzryEHN2dC2TANxrqOX8AChF4y2VVyiWT1+PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pd9+wNEyt/ayAMKgJXjQcl2QOUepo4DebLWFGAYJW2p1Xg7GXX9J3MG7IMmgTCl+OnWDVFG1ho0K7iMneovPhzwscpwcfPDLTNWKJ3pcOvSvqS4t+Hwj0SYJ5GdpOKDIELnRF4jW7Dkh9IRNaei1nV87BSZsGwfNJLVcclAcGXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rev.ng; spf=pass smtp.mailfrom=rev.ng; dkim=pass (1024-bit key) header.d=rev.ng header.i=@rev.ng header.b=P7bOC6ZL; arc=none smtp.client-ip=94.130.142.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rev.ng
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rev.ng
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rev.ng;
	s=dkim; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
	:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive:List-Unsubscribe:List-Unsubscribe-Post:
	List-Help; bh=FulfBLl+ryoBJvND2Xguk6hmdm7/JzY6FmhA7EIub6k=; b=P7bOC6ZLZYKAMHf
	YrU1O3CmQYGrLyMxE02eQxFB+rYGvLad0CFBjOgGqyed7S4z7ALirSv+B9+CcTQZ2/AAC5vwxbUsJ
	8Mnw04MForklBltw44GvEy0YavxagJ/zgtObuTd9qY23OnkpofNMv54IiRWtnLcZuiR2DvcdlCjBL
	Xs=;
Date: Tue, 29 Apr 2025 14:26:30 +0200
From: Anton Johansson <anjo@rev.ng>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, 
	kvm@vger.kernel.org, alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, qemu-arm@nongnu.org, richard.henderson@linaro.org
Subject: Re: [PATCH 09/13] target/arm/cpu: get endianness from cpu state
Message-ID: <bwdflzaiqdpq33uzowvrgjbha3wye6k74puwur755pq27z67eu@mnc2ze4it5cl>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-10-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250429050010.971128-10-pierrick.bouvier@linaro.org>

On 29/04/25, Pierrick Bouvier wrote:
> Remove TARGET_BIG_ENDIAN dependency.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  target/arm/cpu.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index e7a15ade8b4..85e886944f6 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -67,6 +67,15 @@ static void arm_cpu_set_pc(CPUState *cs, vaddr value)
>      }
>  }
>  
> +static bool arm_cpu_is_big_endian(CPUState *cs)
> +{
> +    ARMCPU *cpu = ARM_CPU(cs);
> +    CPUARMState *env = &cpu->env;
> +
> +    cpu_synchronize_state(cs);
> +    return arm_cpu_data_is_big_endian(env);
> +}
> +
>  static vaddr arm_cpu_get_pc(CPUState *cs)
>  {
>      ARMCPU *cpu = ARM_CPU(cs);
> @@ -1130,15 +1139,6 @@ static void arm_cpu_kvm_set_irq(void *opaque, int irq, int level)
>  #endif
>  }
>  
> -static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
> -{
> -    ARMCPU *cpu = ARM_CPU(cs);
> -    CPUARMState *env = &cpu->env;
> -
> -    cpu_synchronize_state(cs);
> -    return arm_cpu_data_is_big_endian(env);
> -}
> -
>  #ifdef CONFIG_TCG
>  bool arm_cpu_exec_halt(CPUState *cs)
>  {
> @@ -1203,7 +1203,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
>  
>      info->endian = BFD_ENDIAN_LITTLE;
>      if (bswap_code(sctlr_b)) {
> -        info->endian = TARGET_BIG_ENDIAN ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
> +        info->endian = arm_cpu_is_big_endian(cpu) ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
>      }

I'm not the most familiar with arm but as far as I can tell these are
not equivalent. My understanding is that arm_cpu_is_big_endian() models
data endianness, and TARGET_BIG_ENDIAN instruction endianness.

Also, for user mode where this branch is relevant, bswap_code() still
depends on TARGET_BIG_ENDIAN anyway and the above branch would reduce to
(on arm32)

  if (TARGET_BIG_ENDIAN ^ sctlr_b) {
      info->endian = sctlr_b ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
  }

giving the opposite result to the original code.

-- 
Anton Johansson
rev.ng Labs Srl.

