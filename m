Return-Path: <kvm+bounces-34778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE6CA05DDB
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFBAE3A33C6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 14:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6607F146A69;
	Wed,  8 Jan 2025 14:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FHKeTEwh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337CB2594A2
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736344863; cv=none; b=MDFIlGMIqbADLJmnvO3+qkxs+gwLPP4WsTnI9CUyBVA3SHVyx4MjiosZUq/axmF/yGRnSa7CtW5jVS3NyEbgv22G+ySGrI/JiAiOXA5Cxpzk//ZMm52+MGFCj3dQBxTbLwMhPEcZRONQpKhqhCB7qYCiqlV/C2ilJDGH1mTU8hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736344863; c=relaxed/simple;
	bh=VxYuoDF2a4u1sXO5+YYQjOrZAtLkpujcDAhNHFETGp0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P97aKnBMVQOFkz0mfLUEtRO6bJc8qV7QIkJK923drwGb1le4jrek7KRTMAaLA7zbyby9cZXyZBDj72V4YJXYOJEAUd44qUiyQ+RV6D3bkQXuHOGy1L8Bpo00cnMH5871miFgz5zA0jEGsjjcefsKA1LkBeYeXjrLGEhBagFgpNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FHKeTEwh; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2162f80040aso228128445ad.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 06:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736344861; x=1736949661; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KoSb0DVqwwdqCnPFQHqX9QxKv5379dwSqLcL746sAZA=;
        b=FHKeTEwhdPHGBTwEhvYROgjoeSS8wCsLDm+yF/8TNUOiwU8DY6d+4bp2vWoTRW4bOa
         myYoatXAcqzGHJNiG9/yKzF60JGKJW06J6obMIIz0KHNfOZhG1/u4reg2v6+FXQ/g58n
         jp0TMLKvAUeezouHL6WRola2gzRrsxSDynYhGDOcnGEZrluRoIq3x3CGvzsRyOX5Yv9i
         y6xjISoxSPWnosj7zA+IfqE9Sqd3/PSNsElb6Ja/0Nb57YdDRfSTaVHYkwOLQLa2utKr
         fsIJJmwMweczi1bBEInMZDHHjM9J1ZvzW7ePP5bNnVG2IejZY84t7KCy6I36+RAxk4GQ
         uw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736344861; x=1736949661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KoSb0DVqwwdqCnPFQHqX9QxKv5379dwSqLcL746sAZA=;
        b=RpYQn8xOfGb2j62zAYwwgy1ElDWaHpyHqnWZaGrCl1hPeiyFSmxLsZ+sIOb34Nz5LG
         BRtkEP7QkSkxQKj1loDLICJGO8wtSPqeSWkYpI0nRJFQqCG+uf4+o4fc45gN+DXHmh3u
         ClaJP9iGWMGLAOau3AJ8FhDQJ/7F4TRuSwPN0G31ZngFnSEKsadgpwtUvbRhNQeaIa/j
         h+HTSYQhQbcqAQJ7muOWnX6bCtHS3d0/J07N3eLy0e9nnoQetRfy2/g1t8BZWJ6yDAaf
         X7vi6GRWJEtQue94tPdU/UPDEudrzlFcdWAADoWElApH/8J7Oihnzxary78oKegqqrKw
         z6+g==
X-Forwarded-Encrypted: i=1; AJvYcCWfO5GOOpvciFHEBDmI6tYL9pMWqTAFFy2yvB+4dZ9kjDjagmjXpfzPRJwSQkWu1xzG2cI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRffFYHn20nZpa8nbOZP1/V/OrmnUVZKZthYMnVI3NTImaK95p
	bXbYM64XCdMsgYN9kXmleEmMpWM7PhyhVtcgEQLU9p2WM3kXQP1pxQ3CGCow0BKIbDbwU5IOxrl
	Cmg==
X-Google-Smtp-Source: AGHT+IHG7dyfKAL1bSiG38RaEeMjMKlAgfX1dqFkBaWY/kQlYp650airghqKnbSSTqx7qJ4Xpssouik/k1E=
X-Received: from pgjs17.prod.google.com ([2002:a63:f051:0:b0:7fd:561e:62dd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748b:b0:1e1:a0b6:9861
 with SMTP id adf61e73a8af0-1e88d0e21dbmr5275883637.12.1736344861510; Wed, 08
 Jan 2025 06:01:01 -0800 (PST)
Date: Wed, 8 Jan 2025 06:00:59 -0800
In-Reply-To: <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250106124633.1418972-1-nikunj@amd.com> <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local> <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local> <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
Message-ID: <Z36FG1nfiT5kKsBr@google.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
From: Sean Christopherson <seanjc@google.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com, 
	francescolavra.fl@gmail.com, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 08, 2025, Nikunj A. Dadhania wrote:
> 
> On 1/8/2025 2:04 PM, Nikunj A. Dadhania wrote:
> > 
> >> If you want to take care only of STSC now, I'd take a patch which is known
> >> good and tested properly. And that should happen very soon because the merge
> >> window is closing in. 
> > 
> > In that case, let me limit this only to STSC for now, i will send updated patch.
> 
> From: Nikunj A Dadhania <nikunj@amd.com>
> Date: Wed, 8 Jan 2025 14:18:04 +0530
> Subject: [PATCH] x86/kvmclock: Prefer TSC as the scheduler clock for Secure
>  TSC guests
> 
> Although the kernel switches over to a stable TSC clocksource instead of
> kvmclock, the scheduler still keeps on using kvmclock as the sched clock.
> This is due to kvm_sched_clock_init() updating the pv_sched_clock()
> unconditionally. Do not override the PV sched clock when Secure TSC is
> enabled.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kernel/kvmclock.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index d8fef3a65a35..82c4743a5e7a 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -324,8 +324,10 @@ void __init kvmclock_init(void)
>  	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
>  		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
>  
> -	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
> -	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
> +	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
> +		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
> +		kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
> +	}

This still misses my point.  Ditto for the "x86/tsc: Switch Secure TSC guests away
from kvm-clock".

I object to singling out kvmclock.  It's weird and misleading, because handling
only kvmclock suggests that other PV clocks are somehow trusted/ok, when in
reality the only reason kvmclock is getting singled out is (presumably) because
it's what Nikunj and the other folks enabling KVM SNP test on.

What I care most about is having a sane, consistent policy throughout the kernel.
E.g. so that a user/reader walks away with an understanding PV clocks are a
theoretical host attack vector and so should be avoided when Secure TSC is
available.

Ideally, if the TSC is the preferred clocksource, then the scheduler will use the
TSC and not a PV clock irrespective of STSC.  But I 100% agree with Boris that
it needs buy-in from other maintainers (including Paolo), because it's entirely
possible (likely, even) that there's an angle to scheduling I'm not considering.

