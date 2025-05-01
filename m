Return-Path: <kvm+bounces-45111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7644CAA6088
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4BF59A0310
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511F4202F7B;
	Thu,  1 May 2025 15:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="IKF9y59q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E8618D63E
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112349; cv=none; b=mPC1qhIFiSmncOrUSwUt8OviCVORVDozyF7qPioNMCzxPwZwuY4uyczsr0nX0k/z6KW69CjG5APrCDHzzmbLpIBpveYXNtiU6YARilKNs8UuQ2DDyMH7g4hH/Qz5ahXBLpsjgItDKW7QUeidJN4uzqgT4f1n+H/dee7DaVNn7YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112349; c=relaxed/simple;
	bh=dWnGMRLuuiig00/q1qNO4cfo1u8O7FAVX0O/ycoMXU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ly2pvtjs37aFhCte/fTtwK/oZe2cSBkARDdsIEX5kSALbvIFboN/E4BHAEKQu6mRsaV7cba6gbcn3uYUKEyW/I0xXuMWdg3DA2sq7NM7TiRohE5/XHLTCGqfSbB6RStMhTT+v1ek1fADEKMEom+Gk7GMIJ3ag856pQB3maqRgDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=IKF9y59q; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d818add2a3so3741705ab.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1746112347; x=1746717147; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fiSgvlc+jgTt+SalF/TBVD1MvIkMlCI4kO67DxSibGs=;
        b=IKF9y59qzvtHHAEtcYSWSg+wHaw6Q4necx02i9DDF5ilKba40s04+SmaY1KSC/x+zJ
         2fy+50aY1VKWcXFm5BWT10OtE28D2bgxMiWwlcfmzwp3gVmM/vEXSbwti5yowLP8Ppk7
         Tf13+GahJ9g+C2gH7wrhPE1p/e/m5YmZ0m7ZsUEXA2/+li7EeGHFcDJHgnGI7Ppy8AKt
         AMf9MX0DuTkBq5mBu/KPui1L0ACFp0PPM8nqwEDTkptiSO7ohPbpXzRIrXVhmx9qyUSr
         OeA/X5yf5KTRQCOy0Np2VcnroS4+mPiOwlsrJIbRoDsFbga/UkpyCLyvZT4AYRyYG+HU
         C5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112347; x=1746717147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiSgvlc+jgTt+SalF/TBVD1MvIkMlCI4kO67DxSibGs=;
        b=VivtrYd2kPRoyKsLX1bbXFLMWnHgxyun+CgXd0fIOh2qVw9LMvwiPBHzGZ1B6CTSVW
         gNgzMI2bP2SjT71RVmJpPpxefD81aw26jOezTi85VRDDc8D4LGOF2ls2JQiXRu+QxNXv
         eUilVzdsaNLlo0VZz1ueavenJ9zAjKS5x+yQnZ9XBqsJdFfbJJ0H/CJM05Ai1ZziQHyG
         KwiyVUDhnmChe6ZrgV43B/fsfP8rfcuve/8qiq7sMLcgVrjf1ne3+ky+G5svt1bybjkT
         RxflU+I1yM475+NVmN/Sapg5HHY92wntYC9Jz/OC/U83AWViv+FX/2R5sENnW31LM+We
         9tfw==
X-Forwarded-Encrypted: i=1; AJvYcCU9yRrwK+uuEX9DLIj7+zo3Tv4NkICwLLsGmgfKE4UKZmJFfFEK29Smd3ZfKBVXAscN9+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBEvPizu+K0S9TgLqrvBJkC9YA1+bB/BrebS50ZWEUJEV9ktVU
	P8E3ZdrRMAT794XOraMKYtE3YDFMjO5KywWlxNZa7GqSJDqJo0taoG9t8QD7Psw=
X-Gm-Gg: ASbGncsSQdRRgro+4ks5+ry4jiZqQmEBmQ+5IeiqbzJ5iPGwltT9MOPdZuSGSDcpgXS
	rub3y6b0DOS5ayqSwhPsA9OvkkdAgNnl291Nje23LILHC3dPKRnlJH4HeOycZuqiEo1YW6u/dUu
	fkVpvKLqr2JbnV09yU5oql8aC5Xkw8OR0GAHFwP1F8YZma+EUh11FqwRzj0ZzuC3HYpdM6nU+9A
	IOXSKYn+GiOeTMxzPXUPObF2mjkMzXIaGMB1HNYJ4YTMUSeB1RhwzcPUFFKWCK2ycY/JELSlWcE
	DUOJU4dYumFI7qM1q5kh6i8=
X-Google-Smtp-Source: AGHT+IEIOmyJqg0IDfnq12HF/KNZxN2C+QMTntsNo+GE5770dKW40hle7cceFLWUyRubp7ZQk3Lr0w==
X-Received: by 2002:a05:6e02:5c2:b0:3d3:d08d:d526 with SMTP id e9e14a558f8ab-3d970bab314mr23866965ab.11.1746112346920;
        Thu, 01 May 2025 08:12:26 -0700 (PDT)
Received: from CMGLRV3 ([2a09:bac5:9478:1b37::2b6:2f])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f882ead968sm224915173.12.2025.05.01.08.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 08:12:26 -0700 (PDT)
Date: Thu, 1 May 2025 10:12:24 -0500
From: Frederick Lawler <fred@cloudflare.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Simon Horman <horms@kernel.org>, Keith Busch <kbusch@meta.com>,
	seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	leiyang@redhat.com, virtualization@lists.linux.dev, x86@kernel.org,
	netdev@vger.kernel.org, kernel-team@cloudfalre.com
Subject: Re: [PATCHv3 2/2] kvm: retry nx_huge_page_recovery_thread creation
Message-ID: <aBOPWGPTCgnUgtw-@CMGLRV3>
References: <20250227230631.303431-1-kbusch@meta.com>
 <20250227230631.303431-3-kbusch@meta.com>
 <20250304155922.GG3666230@kernel.org>
 <Z8clO24vFqlDdge4@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8clO24vFqlDdge4@kbusch-mbp.dhcp.thefacebook.com>

Hi Keith,

On Tue, Mar 04, 2025 at 09:07:23AM -0700, Keith Busch wrote:
> On Tue, Mar 04, 2025 at 03:59:22PM +0000, Simon Horman wrote:
> > A minor nit from my side:
> > 
> > As you are changing this line, and it seems like there will be another
> > revision of this series anyway, please consider updating the indentation to
> > use tabs.
> 
> The patch is already applied to upstream and stable, and I think Paolo
> must have taken care of the formatting because it looks good in the
> commit now:
> 
>   https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=916b7f42b3b3b539a71c204a9b49fdc4ca92cd82a

I backported this patch cleanly on top of 6.12.24 and ran it on some of
our production nodes. I compared 6.12.24 to the patched 6.12.24 over the
last three days, and we saw a drop in ENOMEM reports from firecracker.
It also appears our VM's to be consistently spinning up again.

When you said stable here, I checked the stable queue and lists, but I
didn't see this patch in 6.12. (only in the 6.14/15 stable) Can we get
this backported to 6.12 as well?

Fred

