Return-Path: <kvm+bounces-42814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D267A7D6FD
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 445DE3B128A
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21CA22655E;
	Mon,  7 Apr 2025 07:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0NUK7Je"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848D72253FF
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012417; cv=none; b=i7U1qy8jGQklKmbQtiNBTZ5j1fzOHMRD/Y+iW3/KdvlRTTMNQ15OMi+jqUHBUGd238qUki05NAfzq3OkXm8IFUVf5PQyjOvSxRQ95zqJM6w9LFTxbGYCYfn3jp8bKsbUXzKwDyGK24Cdno/xiY0+/VZIsYmgoBriVvk5Iy3fGDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012417; c=relaxed/simple;
	bh=szwnXOzOSOjBOch3SoWaXXjO3Tlak50jw4MvIJHciKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gaUIjL7SrnFXwy+VfbMYeahwbKv2NeMAk9+2czFnT0arnBlNvdDHYip3os7KaGl3DM3dUeATRS9VTRsHTaaGiNruPMquPEoUKBc6UXwhRSuEUYF0Fpi9cwoGZH8UQ2bP21+9sbbQ9McQocSiJ3PEC7MWpvJaq7qWst6wPrzVs4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0NUK7Je; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744012414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofsy77ssOrCPdPnwbpfIBh3i6M18rOr/4yXwZKj56Wg=;
	b=L0NUK7JeD1sQMw4xDSvwNBx9w7BkhnJzcFVg2Cl6vnp9uCjeNaVN9h49J8Sr28z8D/Fj5Y
	aPLp0ugrnkAqmxjJQgj8guIyAddGDXLR/wlg3gVVXRb4lFI/ApCM0lYq9FvAuNwyZeIvFv
	rZrbmNhEo9EMObyQnCFGLzvXnRvP08g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-y90YfYznOXao36Ll0im6Kg-1; Mon, 07 Apr 2025 03:53:32 -0400
X-MC-Unique: y90YfYznOXao36Ll0im6Kg-1
X-Mimecast-MFC-AGG-ID: y90YfYznOXao36Ll0im6Kg_1744012412
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39143311936so1633059f8f.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 00:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744012411; x=1744617211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ofsy77ssOrCPdPnwbpfIBh3i6M18rOr/4yXwZKj56Wg=;
        b=prLNVAZgjmh2aqwkCoKe/1W+KDDvs3uS99Xf8Pxl3vqNVwBZRAay1PGYXTdCjxy1en
         ZlsAk7GuRDSpwzQeHDeuA6LIyOIZrNdiD3Wn552ij8JejCLoFm1iaIp9xRh0i2l4FpwE
         GGB+C6tQzkxvD/9WBBG5sQu0H5Bht7BNG2c4efHlsRNWd8+iy4T0t8XqgrHl94Rf1h7p
         k6ryxJNEePhecNXcqLjyo0ys57wBXEo/agrxSELjR7ITEU5hHJcEed1BrmNUhjzIJozU
         QDL1BcjpAe6STFG5XX+jbUb/IZOaHKhBaryLi8Zgqs8OsGcIpvPszi2Iht5L/gxsbj58
         BU8g==
X-Forwarded-Encrypted: i=1; AJvYcCVY9ggl3uxg2G+chIqGhkxTrVxF/NJb33B8LTGoTt/UhKRhU2SSu8gaYYraYdn/tbikNyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDckbnm9XF/6qSGrfAhh8qHCBk7/cp3Tl8ZHK7PgkAp4TACt/D
	Ns/SpcWp6tOfLc4wcCkmNxsSl49mRvGu9I8G0K5Ksl7Y5E/AQ5cHSzV/yv2YeUdo49lBV3xUx6y
	12Y5JENTdKNEIcuppwAAZKD5Yy+3xnHdJvvOvZKGr5rjesxxPWs8qz2J+ZalD5hve2fTvefopkG
	1/+tkj4qa1hvNR0JFUrijeiTqr
X-Gm-Gg: ASbGncvhZGKACMoMPDaXOg5rnp6yBhuaz+MGyavTWf5dBCsAdRVOHgi97zKA8Pd9V3l
	mXZFYLPHP4WnJUEZVljyB5i90x+b0IsW1M1Gb3HOzU0fk4pTAKyifCnYEGtx7MdUBoCUXTps=
X-Received: by 2002:a5d:6d8b:0:b0:391:489a:ce12 with SMTP id ffacd0b85a97d-39cba9324c4mr9434699f8f.26.1744012411522;
        Mon, 07 Apr 2025 00:53:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEucAUDP41Wd19TJhxmtFTNd5L+/2tfINDx0SVCwJt1Ss7gnd+Nfa6ty3EOnVN7dms57jS4L4Bva0CX/NdTT8g=
X-Received: by 2002:a5d:6d8b:0:b0:391:489a:ce12 with SMTP id
 ffacd0b85a97d-39cba9324c4mr9434669f8f.26.1744012411222; Mon, 07 Apr 2025
 00:53:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1742850400.git.ashish.kalra@amd.com> <Z_NdKF3PllghT2XC@gondor.apana.org.au>
In-Reply-To: <Z_NdKF3PllghT2XC@gondor.apana.org.au>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 7 Apr 2025 09:53:19 +0200
X-Gm-Features: ATxdqUFovAPd1YyW8urz9uvodd5Msi-Jyl0y3VBXdc00kyPAkug_xTk1qmoKSKs
Message-ID: <CABgObfa=7DMCz99268Lamgn5g5h_sgDqkDoOSUAd5rG+seCe-g@mail.gmail.com>
Subject: Re: [PATCH v7 0/8] Move initializing SEV/SNP functionality to KVM
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 7, 2025 at 7:06=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
> > Ashish Kalra (8):
> >   crypto: ccp: Abort doing SEV INIT if SNP INIT fails
> >   crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
> >   crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
> >   crypto: ccp: Reset TMR size at SNP Shutdown
> >   crypto: ccp: Register SNP panic notifier only if SNP is enabled
> >   crypto: ccp: Add new SEV/SNP platform shutdown API
> >   KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
> >   crypto: ccp: Move SEV/SNP Platform initialization to KVM
> >
> >  arch/x86/kvm/svm/sev.c       |  12 ++
> >  drivers/crypto/ccp/sev-dev.c | 245 +++++++++++++++++++++++++----------
> >  include/linux/psp-sev.h      |   3 +
> >  3 files changed, 194 insertions(+), 66 deletions(-)
> >
> > --
> > 2.34.1
>
> Patches 1-6 applied.  Thanks.

Thanks, go ahead and apply 7-8 as well (or if you don't want to,
please provide a topic branch).

Paolo


