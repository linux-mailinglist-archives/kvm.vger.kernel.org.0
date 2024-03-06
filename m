Return-Path: <kvm+bounces-11101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E91872DF1
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 05:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC3AD1C2189C
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 04:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D9018637;
	Wed,  6 Mar 2024 04:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDNmoOZd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9161759F;
	Wed,  6 Mar 2024 04:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709698520; cv=none; b=tV1qJPhMS9NaDCRJfgu13R5CtuIas5A5mzwiOnqdVmEBi+WNU0obtznr3NKrxJhAcabpjYeDCab/AQsr9/pkFfuHZuRQhR/O1FlQt+mvd0aSJUh7CRngW8Xi4IPrOCNjllUhklyWQU1CkwPq05OjNtDH0xGMeiDqSFcWC2918VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709698520; c=relaxed/simple;
	bh=2mZOift1zTCFAAkkTaz50gagDuRV3FpniOphDqMAsX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mw5S/iCpVME0tz346Yj/pIZBJOmxpj4OxkbniZang5YyNV4VJYdTwHWjmg38Q34djRNimBXscgal6Hn0FVarZbiLNEtGTdOrc8MmlEqBMTB1MphB4J+vqYXwc14zHUbWIEUmzjEkiadXkuKhw7GkzmqoFBSUHsj58r/gavREH4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDNmoOZd; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-dc742543119so6504681276.0;
        Tue, 05 Mar 2024 20:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709698517; x=1710303317; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2mZOift1zTCFAAkkTaz50gagDuRV3FpniOphDqMAsX8=;
        b=lDNmoOZdOo1aI32FGYjW3RSvdzLN2yADOUh39G9R2qYaJJrJTqHXprYEoLRwxR0L6Y
         r4S7iedq2Eb2AS7rifVPW3iiGcoVBv3nVQL2aZYDsdVmutd/EBnsRO60efFVNMatm3dU
         RScW8fpHrn+bQVlzrXAju/TbbgVZcGvqEQ4G8tdSwaeSNyyEVfAPFHh++C4GgBj+tGxb
         LkbgZ61ctqhgxyP5g7HXXZJHSBRNBvQdO4d7n8IlMhDAslO1jl14U6zs8RPAobtYgXu2
         5vB/k0o95UXlH+bNdZnyXUv91UvE2rcHP50nUqjprpH49vmwve89A/H+gXZi6W19uBM5
         z8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709698517; x=1710303317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mZOift1zTCFAAkkTaz50gagDuRV3FpniOphDqMAsX8=;
        b=sJWhpwlt2aIJdX55IyzqjUHe062k01puFsPZbbrk4haAhNXaeMkByPMbw9nqyu6DHF
         H0nqNlGPUsaR2U9P5W0Fy3F8QtlMbXUXpR5TmMWYkWEoxSKoZZ0BoQT3DJf+vJ2Rwg9d
         KwJvgjgfYartslLxGrD9V8z7T+13lqreZDuu6sZ9sxkN2uCKdFmdZYqc+j9MinyjEC9l
         U6CgBAUboLPcnHe6PJ1x4Icqpt8IzmNbQG9oDbeUizO4xCISjA/12IE6eMwOKlnoo3fm
         nBD2gW0oa4RCPlvuiBhA+R+DBJjOhkgxUE6X348XPnVLFsDM0w9UVvMPlYDqNl1PnwU1
         Ef2w==
X-Forwarded-Encrypted: i=1; AJvYcCW4yjNAMSHTsakovkE46YnCf1R3rxhzqmjBz/jnHhwX/+AdF7Sze30IGu3c3HOkJt708VoyVj0EDbBmD3i/cnhdN045vBqywgarBES1
X-Gm-Message-State: AOJu0Yw4B3mVHhubqvFsMHmooiG+o6eC2PBii70OR9dmz4BeWH4boLs5
	fTJWztisLbLfl2d/XxAKanTuc2ZeaPWcexFcnDXpEA7kqwVrDGE4io178gWAQ8q6ZHFqO5U6N/i
	2iv1mAjbMLGo2jBJMFS+7Skkacdo=
X-Google-Smtp-Source: AGHT+IFNBJTagpJjuT7X/nAY1/ZTuOlv+jvuIJjU7bSnP1MmPnHh4BLroNOiJWfnH+TAfbRiOQQqUA46F/bGeZtxETE=
X-Received: by 2002:a25:2107:0:b0:dcc:ca51:c2e1 with SMTP id
 h7-20020a252107000000b00dccca51c2e1mr10654514ybh.2.1709698517460; Tue, 05 Mar
 2024 20:15:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229065313.1871095-1-foxywang@tencent.com>
 <20240229065313.1871095-2-foxywang@tencent.com> <5e35c8e1-5306-8ee9-300c-2426d6a0f050@oracle.com>
In-Reply-To: <5e35c8e1-5306-8ee9-300c-2426d6a0f050@oracle.com>
From: Yi Wang <up2wing@gmail.com>
Date: Wed, 6 Mar 2024 12:15:06 +0800
Message-ID: <CAN35MuQFzXELAoZTA_sizf_1Nkhw9JtTtsaFK5n4eQM0HN0X=A@mail.gmail.com>
Subject: Re: [RESEND v3 1/3] KVM: setup empty irq routing when create vm
To: Dongli Zhang <dongli.zhang@oracle.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de, hpa@zytor.com, 
	imbrenda@linux.ibm.com, frankja@linux.ibm.com, atishp@atishpatra.org, 
	anup@brainfault.org, maz@kernel.org, foxywang@tencent.com, 
	wanpengli@tencent.com, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 6:15=E2=80=AFPM Dongli Zhang <dongli.zhang@oracle.c=
om> wrote:
>
>
>
> On 2/28/24 22:53, Yi Wang wrote:
> > From: Yi Wang <foxywang@tencent.com>
> >
> > Add a new function to setup empty irq routing in kvm path, which
> > can be invoded in non-architecture-specific functions. The difference
>
> :s/invoded/invoked/

Thanks for pointing this out.

Sean, Oliver, Christian, Do you have any other thoughts? Any
suggestions are appreciated.

>
> Dongli Zhang



--=20
---
Best wishes
Yi Wang

