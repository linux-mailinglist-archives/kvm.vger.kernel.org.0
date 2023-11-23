Return-Path: <kvm+bounces-2361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 533547F5D33
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 12:03:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8146B2116F
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 11:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C533B22EEE;
	Thu, 23 Nov 2023 11:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="iyceZfyQ"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6C6D67;
	Thu, 23 Nov 2023 03:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1700737362;
	bh=uqbk3lyeqSjwPRhuNVxLOm4uc+e6PUbNsNGKGUbeIeg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=iyceZfyQVViQ82WYOcVcZ3y8up/cjELd3RnGCnxCtDVEh/Zdegj+Tdx+Q6R9CdMR2
	 ufdh6WYHbLsidP6MHaX27LNzygxAa4UQG3lxH0RJrtLXsxNggd3NFS67DNAra/5yzJ
	 KtKZLWiLvuPFOaEQkqAZPXsfRceh7q/qS5GjjygijnLUR8AJgn++JFpcba1aH+Lp4x
	 Kvgnz9wzcGN5Jff6NgAhZ/Gn2c1ZnP34y/764x88gSJC9YFj4o9kPHjN2KmXTmrpow
	 HxbkjRbzEXlnzxSSvNVHJFxcL8aZ1mW9BoNz0iKYg0a1gnQBAoJv0ivTtNGxXgXByd
	 0dtv+xpjv7WHA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SbZvh2jNPz4xRn;
	Thu, 23 Nov 2023 22:02:40 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Greg KH <gregkh@linuxfoundation.org>, Zhao Ke <ke.zhao@shingroup.cn>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, fbarrat@linux.ibm.com,
 ajd@linux.ibm.com, arnd@arndb.de, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 shenghui.qu@shingroup.cn, luming.yu@shingroup.cn, dawei.li@shingroup.cn
Subject: Re: [PATCH v1] powerpc: Add PVN support for HeXin C2000 processor
In-Reply-To: <2023112317-ebook-dreamless-0cfe@gregkh>
References: <20231123093611.98313-1-ke.zhao@shingroup.cn>
 <2023112317-ebook-dreamless-0cfe@gregkh>
Date: Thu, 23 Nov 2023 22:02:35 +1100
Message-ID: <871qcgspf8.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Greg KH <gregkh@linuxfoundation.org> writes:
> On Thu, Nov 23, 2023 at 05:36:11PM +0800, Zhao Ke wrote:
>> HeXin Tech Co. has applied for a new PVN from the OpenPower Community
>> for its new processor C2000. The OpenPower has assigned a new PVN
>> and this newly assigned PVN is 0x0066, add pvr register related
>> support for this PVN.
>> 
>> Signed-off-by: Zhao Ke <ke.zhao@shingroup.cn>
>> Link: https://discuss.openpower.foundation/t/how-to-get-a-new-pvr-for-processors-follow-power-isa/477/10
>> ---
>> 	v0 -> v1:
>> 	- Fix .cpu_name with the correct description
>> ---
>> ---
>>  arch/powerpc/include/asm/reg.h            |  1 +
>>  arch/powerpc/kernel/cpu_specs_book3s_64.h | 15 +++++++++++++++
>>  arch/powerpc/kvm/book3s_pr.c              |  1 +
>>  arch/powerpc/mm/book3s64/pkeys.c          |  3 ++-
>>  arch/powerpc/platforms/powernv/subcore.c  |  3 ++-
>>  drivers/misc/cxl/cxl.h                    |  3 ++-
>>  6 files changed, 23 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
>> index 4ae4ab9090a2..7fd09f25452d 100644
>> --- a/arch/powerpc/include/asm/reg.h
>> +++ b/arch/powerpc/include/asm/reg.h
>> @@ -1361,6 +1361,7 @@
>>  #define PVR_POWER8E	0x004B
>>  #define PVR_POWER8NVL	0x004C
>>  #define PVR_POWER8	0x004D
>> +#define PVR_HX_C2000	0x0066
>>  #define PVR_POWER9	0x004E
>>  #define PVR_POWER10	0x0080
>>  #define PVR_BE		0x0070
>
> Why is this not in sorted order?

It's semantically sorted :D

ie. HX_C2000 is most similar to POWER8, but is newer than it.

PVR_BE is out of place, I'll fix that.

cheers

