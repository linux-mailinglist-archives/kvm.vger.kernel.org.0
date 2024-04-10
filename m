Return-Path: <kvm+bounces-14174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5208A036A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:32:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E118A1F226A0
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6F9C8DE;
	Wed, 10 Apr 2024 22:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RkkB7C1d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F63428FD
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 22:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712788366; cv=none; b=EVe50NPnah5FsYRWGPmDEcQ5cdVIk3GzMsI7Mg5mD4y4eJZY/Ov+OFk+cUdMjBVQxnOUReYTyTcDoIgv591eOvc27Lmby7bWEynjOYO+i7dRd7tPLkkStiwhtD2KyYQQ1KePOj33qev8zafNwsUeamSa2RYEj+6OD3zgwFJukqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712788366; c=relaxed/simple;
	bh=CM4Nfxlau91i+wTCngy88tyM8dxynNHwdKc70IzsoDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNNZI+bNlcgBV8rtrunuJSv7EMyXa3RaiVFwwe77tYzzC8/srwdH2Q0Awgx3K5P8nZskBBmOSQmdtlTQbMdFztGfJ5rbvufAVfd83wj+JPwsEHPPqaPxCl+LZhc4BvPem0ibb1GWwpkbygM7ALubU+yClE0RoL8nL8DrlXCmmYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RkkB7C1d; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5a50880ce2aso4485717eaf.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 15:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712788363; x=1713393163; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8QwE0M/+UHCtJodiY6DO3J7/Qf3c8/oO3mN4e+iOAjs=;
        b=RkkB7C1dNIBvXbGFDUkYVbREy9QrsdRlTumeDjfDUj/DO1V38garIc7VxpOWCXbb9P
         5o4cPZZtezzgY7dD2ijiFiWul651qM5lzOYpo3hG6L6NQ6Hrz/5MCSdqjXqqqriwEFYF
         NdUS7cDKYcwDeUBoINrb+0IyC+QhGQoJZtqPt90g9nXNtvrsWhCI9PttAuuEL/0uPsVR
         RgD0FvRO3Xzctlc+2Kx8REL/EwtlgMHsDodQrY9lJpBU48nXnSZZirl0oP24J3KaSBP/
         i6qsxMvHURwT5XFVrZ8Fc/m/i0l7r7O/NmvYWt4pjA64f41lNCm/DenCqnnuxCr2nqFJ
         KtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712788363; x=1713393163;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8QwE0M/+UHCtJodiY6DO3J7/Qf3c8/oO3mN4e+iOAjs=;
        b=u8h3n1HltOF5oFAFxiolT8/dzdxfAWuNYfabSShGZI3jQeOPBNpPOB5E1PbvT30BVN
         67vpTY5tCyvJY5xEIy9bHOZjbfDXWN84Vz3Ij/bolBGWCBCb3bBivw+H00DmQhA/3HGB
         tGecwaYMxmpem3y2DeFajP7Sy6U9gsLF8OoO4awvbmbeOX4CkArb5rukxDVKvcuCUSM0
         +WkEaxD80CUn1t/QwHcuL6T4WinHHPDWWS3B3AB1ZJC7wvI2cXaQJHjqqWSprPLFkWi7
         97XCPIdzCJx1/I7GWPCpSVghwfa4Z8IQFAg9nja4yWRg2RFC+30kDQbrXaZs5zK6trkd
         8W6A==
X-Forwarded-Encrypted: i=1; AJvYcCVZhLP+sXkNLNbMFGFDb19TYHKVns+jRyHw0+rFZEkHbzkLmQy+kTFjUyapRSXUnL+wwSGsx4QiPjP8+l9aP7Yux9SJ
X-Gm-Message-State: AOJu0Yzrm4o8eSU6bV/33JUvrT3btRUYNGNlKq+CI6elERuKKk+CkA4G
	jS+Hk3DW51tpjFGZ9LQKbwb2m6A9m03tnbkYsSA+PxWd5qb2YiVRYrahND9JMBw=
X-Google-Smtp-Source: AGHT+IGx5/hd/E8Yp0sczgMFtCMtxA7z52W92PBZElrVxV9jPGQj2rV/u6V+YaWfxr37Nv+l4bXzlQ==
X-Received: by 2002:a05:6358:b5c1:b0:186:2ac7:316c with SMTP id wb1-20020a056358b5c100b001862ac7316cmr5042482rwc.20.1712788363600;
        Wed, 10 Apr 2024 15:32:43 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id o65-20020a634144000000b005dc36761ad1sm55196pga.33.2024.04.10.15.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 15:32:43 -0700 (PDT)
Date: Wed, 10 Apr 2024 15:32:41 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Conor Dooley <conor@kernel.org>
Cc: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 07/10] riscv: add ISA extension parsing for Zcmop
Message-ID: <ZhcTiakvfbjb2hon@debug.ba.rivosinc.com>
References: <20240410091106.749233-1-cleger@rivosinc.com>
 <20240410091106.749233-8-cleger@rivosinc.com>
 <ZhcFeVYUQJmBAKuv@debug.ba.rivosinc.com>
 <20240410-jawless-cavalry-a3eaf9c562a4@spud>
 <20240410-judgingly-appease-5df493852b70@spud>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240410-judgingly-appease-5df493852b70@spud>

On Wed, Apr 10, 2024 at 11:27:16PM +0100, Conor Dooley wrote:
>On Wed, Apr 10, 2024 at 11:16:11PM +0100, Conor Dooley wrote:
>> On Wed, Apr 10, 2024 at 02:32:41PM -0700, Deepak Gupta wrote:
>> > On Wed, Apr 10, 2024 at 11:11:00AM +0200, Clément Léger wrote:
>> > > Add parsing for Zcmop ISA extension which was ratified in commit
>> > > b854a709c00 ("Zcmop is ratified/1.0") of the riscv-isa-manual.
>> > >
>> > > Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> > > ---
>> > > arch/riscv/include/asm/hwcap.h | 1 +
>> > > arch/riscv/kernel/cpufeature.c | 1 +
>> > > 2 files changed, 2 insertions(+)
>> > >
>> > > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
>> > > index b7551bad341b..cff7660de268 100644
>> > > --- a/arch/riscv/include/asm/hwcap.h
>> > > +++ b/arch/riscv/include/asm/hwcap.h
>> > > @@ -86,6 +86,7 @@
>> > > #define RISCV_ISA_EXT_ZCB		77
>> > > #define RISCV_ISA_EXT_ZCD		78
>> > > #define RISCV_ISA_EXT_ZCF		79
>> > > +#define RISCV_ISA_EXT_ZCMOP		80
>> > >
>> > > #define RISCV_ISA_EXT_XLINUXENVCFG	127
>> > >
>> > > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
>> > > index 09dee071274d..f1450cd7231e 100644
>> > > --- a/arch/riscv/kernel/cpufeature.c
>> > > +++ b/arch/riscv/kernel/cpufeature.c
>> > > @@ -265,6 +265,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>> > > 	__RISCV_ISA_EXT_DATA(zcb, RISCV_ISA_EXT_ZCB),
>> > > 	__RISCV_ISA_EXT_DATA(zcd, RISCV_ISA_EXT_ZCD),
>> > > 	__RISCV_ISA_EXT_DATA(zcf, RISCV_ISA_EXT_ZCF),
>> > > +	__RISCV_ISA_EXT_DATA(zcmop, RISCV_ISA_EXT_ZCMOP),
>> >
>> > As per spec zcmop is dependent on zca. So perhaps below ?
>> >
>> > __RISCV_ISA_EXT_SUPERSET(zicboz, RISCV_ISA_EXT_ZCMOP, RISCV_ISA_EXT_ZCA)
>>
>> What's zicboz got to do with it, copy-pasto I guess?

Yes, copy-pasta :-)

>> If we're gonna imply stuff like this though I think we need some
>> comments explaining why it's okay.
>
>Also, I'm inclined to call that out specifically in the binding, I've
>not yet checked if dependencies actually work for elements of a string
>array like the do for individual properties. I'll todo list that..

Earlier examples of specifying dependency on envcfg actually had functional
use case.
So you are right, I am not sure if its actually needed in this particular case.

And yes definitley, dependency should be mentioned in binding.



