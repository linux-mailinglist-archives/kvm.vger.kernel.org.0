Return-Path: <kvm+bounces-11902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1132E87CB4A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 11:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 434C11C2148E
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 10:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D26E1863F;
	Fri, 15 Mar 2024 10:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U6Zi57zx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2969F182D8
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710498148; cv=none; b=Zkc5d9DK25U5Ejo05HTc2vuUE+GJiSlhUZZfbRY9+HbMLn92sf/CYH6PvBbDyILwJAH6dxhXfZiXXBd1DSWrjlUh+b734yxCY30hmb6MmrtIYrVoSjTuhMV6c1HGEh/w6ASVm2ICRxhVvUdY2DTspDmr2PsdQXbRocOKxW0kEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710498148; c=relaxed/simple;
	bh=5U2FdyBJ9x2N/ZT3lykt6b/ppnU43zp52hERVtbnd4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKJE8IaYq8NF9AXG1drd3GVrLYlliYuORtRKuRZZdeYaDYH91Sln1JTj5cyBVHh9ZSdUm9uBjcOvAqt9TWkKvBIdYuQYdlx9vJNReS+t4Jupg7gk+ZmUzsv2qjsYJeT/PygXuXy9qD5mfcM8arZ76nfFceVS9VpxIRsTqN3brG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U6Zi57zx; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-51381021af1so2644128e87.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 03:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710498145; x=1711102945; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4hKS13cZNwTAuS0CQMQLil3nPF8VhVj/moqaBbt3e4Q=;
        b=U6Zi57zxqfFdpJGE2hlDtNFINl84TbrlrJDB8cTu0KSfSvDQamaymuj1ZQH8iX12XO
         79eMLqlIwG96MyqBFTUIV+pRs+79vKHMgkDUmucukf9cw8yPHcD3DTW0PTtT8ZMoTwJ1
         MZXbRdfromKT7mofgC9Ex3Zf3VN8qPhWO80AhOftw/FgUIfedE3MEDM7FsE02hulDeUF
         D7labFenUSlWbVJbwYKOGR6nvfYmZktAEl12RpsGNJ6ZLl8aZxQOgLRFssuAaQxAUZ/z
         3mXntQ/B9oDZ5Kk5o0LM7s6XYSX/G044/FPdG9Yz9cs9tGPC2FuoT+Fnr86x0KuoXQvL
         jq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710498145; x=1711102945;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4hKS13cZNwTAuS0CQMQLil3nPF8VhVj/moqaBbt3e4Q=;
        b=GdfjgwKgs48CZuCby8F2lXf847LeMi80WSU49Bo0qGIJUB8e80XgjFiUvDt4Wc3uFl
         ZuB/w0tg+CPG9+4YfEBHDH6z7sHJXNfdKfJfJTIenmckm+PeAS2q3laSuqF2Kwy6K2fZ
         VfvYdMRA65nLpQcGyS7VCOEQCKcCGUq6xNcS5o/MrihvBUxoQdTOpyoEHVJdxhmLDLow
         phHkhs32pClWqaUQZG+gTv//+uSh5yf2/XG90KRXo/5/C9iwG1FZyAUTIOAnKJJMkj/E
         F5BV5qgwG4X1bu8qK6tmoSKUHxudwswurugSjKKQMt0gAB/CtslLv2qmxdfFkWHl1POq
         418A==
X-Forwarded-Encrypted: i=1; AJvYcCUpgEPyA1EpNT5pyvM8aPNGHGFlRqoGJKfDXSrV1M0UO6ZNzzB42oNdwaxMZMghZaIA4yT7jj32nUFEPEOazEgGToiw
X-Gm-Message-State: AOJu0Yzlj/8cKrfpkIfJoIxTNwbArTiYz2f+FM5E1runMivfVEtQobPL
	Gf579kmxXzZ5vU9Nmbs276MF2eBSyO5hTwMFBMJvw1BKFQR3n2wUV/DFOerDP8PwPNepgQ8kW2c
	YHrFi
X-Google-Smtp-Source: AGHT+IED8mmZANKTy9MzOwavrd3Hatz/1kDglj3tvY7tFGNBe5aHeRsc9tnZUPRJMEZX60J8/tNElQ==
X-Received: by 2002:a05:6512:10d4:b0:513:db29:8905 with SMTP id k20-20020a05651210d400b00513db298905mr1317908lfg.69.1710498145116;
        Fri, 15 Mar 2024 03:22:25 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id v23-20020a1709067d9700b00a461a7ba686sm1578047ejo.75.2024.03.15.03.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 03:22:24 -0700 (PDT)
Date: Fri, 15 Mar 2024 10:22:16 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 00/10] KVM: arm64: Add support for hypervisor kCFI
Message-ID: <wlkwdcati2klte4u3xvjiacf7hbuvupd2gksaa6ekjgfjuiy7j@7jvkv45iwdkx>
References: <cover.1710446682.git.ptosi@google.com>
 <86edcc1low.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86edcc1low.wl-maz@kernel.org>

Hi Marc,

On Thu, Mar 14, 2024 at 10:40:47PM +0000, Marc Zyngier wrote:
> Hi Pierre-Clément,
> 
> On Thu, 14 Mar 2024 20:23:00 +0000,
> Pierre-Clément Tosi <ptosi@google.com> wrote:
> > 
> > CONFIG_CFI_CLANG ("kernel Control Flow Integrity") makes the compiler inject
> > runtime type checks before any indirect function call. On AArch64, it generates
> > a BRK instruction to be executed on type mismatch and encodes the indices of the
> > registers holding the branch target and expected type in the immediate of the
> > instruction. As a result, a synchronous exception gets triggered on kCFI failure
> > and the fault handler can retrieve the immediate (and indices) from ESR_ELx.
> > 
> > This feature has been supported at EL1 ("host") since it was introduced by
> > b26e484b8bb3 ("arm64: Add CFI error handling"), where cfi_handler() decodes
> > ESR_EL1, giving informative panic messages such as
> > 
> >   [   21.885179] CFI failure at lkdtm_indirect_call+0x2c/0x44 [lkdtm]
> >   (target: lkdtm_increment_int+0x0/0x1c [lkdtm]; expected type: 0x7e0c52a)
> >   [   21.886593] Internal error: Oops - CFI: 0 [#1] PREEMPT SMP
> > 
> > However, it is not or only partially supported at EL2: in nVHE (or pKVM),
> > CONFIG_CFI_CLANG gets filtered out at build time, preventing the compiler from
> > injecting the checks. In VHE (or hVHE), EL2 code gets compiled with the checks
> 
> Are you sure about hVHE? hVHE is essentially the nVHE object running
> with a slightly different HCR_EL2 configuration. So if you don't have
> the checks in the nVHE code, you don't have them for hVHE either.

No, I am not and my assumption that hVHE was running the VHE hyp code was wrong.
FYI, these patches were tested in VHE, nVHE, and pKVM (with NVHE_EL2_DEBUG set
and unset) but not in hVHE (clearly!). Thanks for pointing this out.

> 
> Or am I missing something obvious?
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

-- 
Pierre

