Return-Path: <kvm+bounces-55021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EDDCB2CB78
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDA4A62520F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E7E130DD34;
	Tue, 19 Aug 2025 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fQpLuwh5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECF91D6DB5
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755625772; cv=none; b=ulluODfaGaP7xnUja74UoeiMnyQ1NMHPtxm/p5EkkYpyQ9E/3/F4cpT0RESVCsGTrkbykVOtNQkz5kaHKiCsWgaOSlkCRAykyPS7+XQHCsdn2g01nN4lwwiR6xx7z05Y6+Sgp33Lhw431rtXkqYmrCSYk6sa1+r1MII33knl/kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755625772; c=relaxed/simple;
	bh=YWkp7me/aGAqDor+8g4ul51C+lYC9lu/O53kvPxYg4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gwFmOiTL4dh/nq3qoQx2j+zuF4G04iwhuy1WCGESaHDxU6X6xt5353Ts19wlPdahzd9grYrhPUMszYiWntnqnFB9eS2CIT/w7ktgqItzOA0t92kjSw8lhRRpaWCftoLLRkwi9HoSIRvg8AVQV+cR6vbK/ewI1Tps0Dui487f8Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fQpLuwh5; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-50f8b94c6adso1370631137.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755625770; x=1756230570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWkp7me/aGAqDor+8g4ul51C+lYC9lu/O53kvPxYg4o=;
        b=fQpLuwh5yNqxvx9BovYEUoVO+U8lWGFmgEesys7A/OYKL61yjBESefcISBOmwUZeGH
         3yB8ZFvi9hdElBnMaPONv1t/vtiFRQ02WNr3Dh/DfRWhKfEF9CBioPzfgyxsgJjzceUe
         a9wix2Va8aRJe4II7SvrGrqjrYSUvRT7k1/3v7UE1Ejkyuhy5LrzrDlJDP3SYBts1jS8
         vyVp3ZGH9bHftyzCazeD7IpKJYxMZvyzt4F+53YG9kr/vFo0qSyWTajVVAd0WWuUf94h
         GjbjCKVb9hYhhweO9vQE7b318m9OT5IvzoNM0WfV8p+cU6W9cqYMxqoMubxtYa5biAIn
         cgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755625770; x=1756230570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YWkp7me/aGAqDor+8g4ul51C+lYC9lu/O53kvPxYg4o=;
        b=RfcDjUAlwu7vSZlIQus3jM4LX1xvPsKkgKMlOg7uC+P5kL8Bd4J4vl98vAvFHJ7TJ/
         W+1/L7tLxsLz7c6A9dH4ztPx+kH9TGS0D4JFu1+FDp0Jx8YOt1xksaVtXSPLjdApZNlG
         jhMiYgNMzCNZPm/s3tV7w0Jy8b1ByXo7qYw8uxlUA1fELnBhomP9ZBloWm14ob5MVn/U
         aT8ZZPsQQKzqYlk9YXbWrIcxDF+fADRLOYBSsNfUKYKCAkaCyW16+UlEE7vSQ6tCd/af
         TDp+FGk80fUvqqOdqgnfuW0hWCZ5uNDgLgdhVXD3sYHsJWfZqj+kUfP9sKAL2MKvfbvO
         aVMA==
X-Forwarded-Encrypted: i=1; AJvYcCXwqdzTON/D1UTOFQsr+01T1sZWny9vOGDB4nhWJF+b5fe1bvh2rqfpMab8u2m3NJo2cyU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8YPF7m80Vw+qbrgkG1Z4NEZ0FlY8K7T+oEoirvZ+ruWMSW9py
	CAE2D8Y8TRGR3rnPKE2TKUTB2kKkKtAv9bri6t0xFSJNnd7C7trCBUHSbno3oYv8vdn3Qmi/BPX
	eaS//Gw5ODtmaLutD2Mn4lUw6bgaVyX/Lu+HTTi/z5BBpMNxmiZiX5AEGSlE=
X-Gm-Gg: ASbGncvH8TzY8cbINMMlJsu5NiDcoVTPRt26FhUrEONCtqUfeXwVEOchFLiXGNoYEf+
	s3lKN8vVV3pfdndeMTGuQfz/ncZczFKOioy6Awq6uRt6edG1l4UgLF6o/sghOKaHEbO1eJYVwNe
	rtiW5woJRQDdyTQ1nu/3A90xsIwOFDdQeslp/V772jY7coOgjtzhEC/UsYzYE56TPaIbssXA5Uz
	HkmO1jOCqH7wA==
X-Google-Smtp-Source: AGHT+IFhwGbrpihJuRhLUkMJwZwhp7F48vbVUtNc9cDlNYXnwMfD57uFUB1fnDEYXaM+LrUY65InbhFraP2uGeXjfLE=
X-Received: by 2002:a05:6102:290e:b0:518:9c6a:2c03 with SMTP id
 ada2fe7eead31-51a52a18e04mr12948137.30.1755625769614; Tue, 19 Aug 2025
 10:49:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com> <77qzhwwieggkmyguxm6v7dhpro2ez3nch6qelc2dd5lbdgp6hz@dnbfliagwpnv>
 <aJtYDWm3kT_Nz6Fd@google.com>
In-Reply-To: <aJtYDWm3kT_Nz6Fd@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 19 Aug 2025 10:48:57 -0700
X-Gm-Features: Ac12FXyvmYoSYuILjgZtuLq3eWcuEq7lOvEZt6VwwKRTWGTNC68lrUWFoa_zNzo
Message-ID: <CALzav=caCWiZ1oS05ZpPNcE1cVVmn8jk9xmbXsEF_Sqexq03JA@mail.gmail.com>
Subject: Re: [PATCH 00/33] vfio: Introduce selftests for VFIO
To: Joel Granados <joel.granados@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Bibo Mao <maobibo@loongson.cn>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, dmaengine@vger.kernel.org, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Wei Yang <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 8:04=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2025-08-05 05:08 PM, Joel Granados wrote:
> > On Fri, Jun 20, 2025 at 11:19:58PM +0000, David Matlack wrote:
> > > This series introduces VFIO selftests, located in
> > > tools/testing/selftests/vfio/.
> > Sorry for coming late to the party. Only recently got some cycles to go
> > through this. This seems very similar to what we are trying to do with
> > iommutests [3].

Joel and I synced offline. We decided the best path forward for now is
to proceed with VFIO selftests and iommutests in parallel, then look
for opportunities to share code once both have matured a bit.

