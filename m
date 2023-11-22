Return-Path: <kvm+bounces-2238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB667F3B70
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 02:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63E61B2193A
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 01:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B785386;
	Wed, 22 Nov 2023 01:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="aio2GqOd"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B85A4;
	Tue, 21 Nov 2023 17:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1700617671;
	bh=+HHlh6rPcGUnKW8ceaHbkKWRA/p99wmeiArQFNzZvO8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aio2GqOdZ0h4bAiFX1GZwLHcBo0BjvuIQMUllBXrVntKvFTB9+CzBP1JEK9hO4+Zw
	 pxxaBtf1UT6ZwYEWwnsSi2jxknguTJB/vrQJ3RkUhSaUt4GIOdcJKAQsQXL72qyuI3
	 jdHSWcWRTzx0SUzG/jmwBGmrvrVkReWcFdJ2vVYhPBxR1LmGlhgv8suoAzxqbbRQbY
	 G0rq2dBQbqZjCTy/uZw8rieyqVTbBbts9MBZpGghPtyFwsGE4sZDEkh666Z0UmBetw
	 iUpaGp2FL73xeDnYkljvOJwLR243Kw9+fxkfpUq5cN7kHABqbhpp9YhGgxi4jRf4g6
	 eFEsNUgA/k9Mg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SZkdy2pWTz4x7q;
	Wed, 22 Nov 2023 12:47:49 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Zhao Ke <ke.zhao@shingroup.cn>, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
 arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Zhao Ke <ke.zhao@shingroup.cn>
Subject: Re: [PATCH] powerpc: Add PVN support for HeXin C2000 processor
In-Reply-To: <20231117075215.647-1-ke.zhao@shingroup.cn>
References: <20231117075215.647-1-ke.zhao@shingroup.cn>
Date: Wed, 22 Nov 2023 12:46:51 +1100
Message-ID: <87sf4yk19w.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Zhao Ke <ke.zhao@shingroup.cn> writes:
> HeXin Tech Co. has applied for a new PVN from the OpenPower Community
> for its new processor C2000. The OpenPower has assigned a new PVN
> and this newly assigned PVN is 0x0066, add pvr register related
> support for this PVN.
>
> Signed-off-by: Zhao Ke <ke.zhao@shingroup.cn>
> Link: https://discuss.openpower.foundation/t/how-to-get-a-new-pvr-for-processors-follow-power-isa/477/10
 
Hi Zhao Ke,

Thanks for the patch. Just a few questions.

Are you able to provide any further detail on the processor?

Your cputable entry claims that it's identical to the original Power8
core, can you comment at all on how true that is in practice?

Unfortunately the kernel has some hard-coded knowledge of various
non-architected features, which are not controlled via the CPU table,
and are instead controlled by firmware. So you'll need to make sure you
set those correctly, see init_fw_feat_flags() for details.

One other comment below ...

> diff --git a/arch/powerpc/kernel/cpu_specs_book3s_64.h b/arch/powerpc/kernel/cpu_specs_book3s_64.h
> index c370c1b804a9..4f604934da7c 100644
> --- a/arch/powerpc/kernel/cpu_specs_book3s_64.h
> +++ b/arch/powerpc/kernel/cpu_specs_book3s_64.h
> @@ -238,6 +238,21 @@ static struct cpu_spec cpu_specs[] __initdata = {
>  		.machine_check_early	= __machine_check_early_realmode_p8,
>  		.platform		= "power8",
>  	},
> +	{	/* 2.07-compliant processor, HeXin C2000 processor */
> +		.pvr_mask		= 0xffffffff,
> +		.pvr_value		= 0x00660000,
> +		.cpu_name		= "POWER8 (architected)",
 
Using "(architected)" here is not right. That's reserved for the
0x0f00000x range of PVRs.

You should use "POWER8 (raw)", or you could actually use the marketing
name there if you want to, eg. "HeXin C2000" or whatever.

cheers

