Return-Path: <kvm+bounces-36313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F1DA19BFD
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 413F816A3BB
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9741BC4E;
	Thu, 23 Jan 2025 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vdk4MviW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6142A849C
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 00:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737593748; cv=none; b=Fu9Ap/R2QmRuKGNtJyW6X7KoK+Ehjaiujtxgdevs1aWDwb2QiFEifcEkWpx5I9itRmYrE5jR/MlXbMtqgAMvdw0C6dKKNjuhSe8xWrfGNeSaSLETyXP6meKnHIdyY20C+kr+t/tPAGMZUn8htHBSECgSc3r5CfBj+xck+WGA01Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737593748; c=relaxed/simple;
	bh=ek/CJhN1pUQ93gVX1fEMXHFr9Yd6+LRWzXrqM/m5bRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EP4PVas7ZgyE1iRqdkNk05fnGGWIzL4lAdOaA9Wm5sJlbXxCWnUmnc2YO8hUlegq+HrI54xEV0g6XdjbZ+dzeWrQZYMYEDur8HQO35SW7PTKPwu1DT1cZQRpl7HAztHbZfKo5LSCPpBnsmAMDY2qjVOCSEUx1EXcY0YMByvUjKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vdk4MviW; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-517aea3ee2aso243404e0c.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737593746; x=1738198546; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9NotBxDbYozQ1tkzIrYs0D4E9urJx1SRZbVPz4aS/pc=;
        b=vdk4MviWnJ4tSgerYIrHVMIcxMys6uTRJloqshko8VTFYwa0mc1IIJeDnWaOSI8mTz
         Ru12RFSMaxVR9QCW/erbzducHy5m1gkWidOwSG5u6Nvmg/d0LbQ+gwjk59WmbinmSoNB
         0IXTYVoCterfJBNhWLKDDIN/TFYzDfFf4KxZD8QMPgw1bEAABSkea114I7D4HoDrBOuX
         T7vHvGfydJl+v49894REWNM1oLDYa5kDpbGySfLLrVfKwT2F1UdF9pJHZU3Otj07CviR
         fy3U3zdoYGLLFZnDkVxxxZoWc5ZcO6gACJss0WTDehaWkiOeAAU1RcXkAWKr24eix0OW
         5I1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737593746; x=1738198546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9NotBxDbYozQ1tkzIrYs0D4E9urJx1SRZbVPz4aS/pc=;
        b=ED2/in9QOpQtrNYFwKHqmrtzBaUlMpGiyo5yK/yyir9niS5PfaCp3XOBt5CC8oNmVC
         JF7XjkIYyBCdg3kS2qh5Lb3ddakW5M7X1ad5M1Z26D0zCXUAl7KAQMKaqeL/3b9GPhXc
         ThaleyneWMBA/LBTRE6g9/HF1YRnTwoZVEpig1WOu/JPhI1JXQEQlyF1t9TvpGPwRiJ6
         5+M8DQgqooh31fMoO71EIeEt65bXJaVsm3QZ2cImKk8KmPHNnI3tGLKiwnQBuHJLvi4s
         WAVqfR9C75cT73Bu4hQ7KfAbFQtJqGzxYg1tvnV3UPakY0Q6obZtUZt5LdY8MEIh0zWf
         A8rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXED6QChO3F0KC92FIrhTCRiSv/jNWtWXdjUD5d7MAida9pciXCD1r3ODoYQAzpF+eGQ5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiYv01oo4qOkpvHTofFbb0sRomCblaYhBYwMDlaTHOeB+C2mG1
	6gdMcBr/4C+W/G5YYwIf9Gz3KDzmf/1F0+uyjdNKcRd1QorJquZgXTF5zkdDJmv0W8nUfHBxN1U
	9Ob3Vk/X0LsbtGSZU8zKHD2Xv0NC30SYb/Jisxoxm6RaPib5ftBoseCo=
X-Gm-Gg: ASbGnctig8NTGQfJrUr9KyQxEoDkW2NuYRm73rCnK54K/ypQiup/fB9Cww9ClGH0ZSX
	CF0eVapUHkWupWLCQcC1pMEJDtgd/46lJQGHZTAaGKEs9Z5YC1MT2jnL4N88MqINzyQUWDysX07
	LEyKN9o7FK+VOqwGD+6mE=
X-Google-Smtp-Source: AGHT+IHrLbKm4Iypkmu6qYwYex4mS8qWd1sDdZWDNi4/BJKK6GIdwJs+B7YEV+2LsAwHrYTfs4G0KQcBgVJRQdUZzVA=
X-Received: by 2002:a05:6122:169d:b0:50d:35d9:ad60 with SMTP id
 71dfb90a1353d-51d5b26e01cmr19855153e0c.5.1737593745897; Wed, 22 Jan 2025
 16:55:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122013438.731416-1-kevinloughlin@google.com>
 <20250123002422.1632517-1-kevinloughlin@google.com> <20250123002422.1632517-2-kevinloughlin@google.com>
 <c1c35c9c-e657-4074-b87e-98fb4b332bc5@intel.com>
In-Reply-To: <c1c35c9c-e657-4074-b87e-98fb4b332bc5@intel.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 22 Jan 2025 16:55:35 -0800
X-Gm-Features: AWEUYZn38aO3gbBobICsavjrrG_eWbicKKw6upB7w6XyQYvBTZ14xKIW2s4UHF8
Message-ID: <CAGdbjmJtBaBt9p3-Kk=XdZZW9LAgz4nuWSDOUdPQ2jY=MpFa2w@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] x86, lib: Add WBNOINVD helper functions
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, ubizjak@gmail.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, manalinandan@google.com, 
	szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 4:36=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 1/22/25 16:24, Kevin Loughlin wrote:
> > +static __always_inline void wbnoinvd(void)
> > +{
> > +     /*
> > +      * WBNOINVD is encoded as 0xf3 0x0f 0x09. Making this
> > +      * encoding explicit ensures compatibility with older versions of
> > +      * binutils, which may not know about WBNOINVD.
>
> This kinda pokes at one of my pet peeves. It's writing a comment where
> code would do. I'd *much* rather write a function that explains to you
> in code that "WBNOINVD is encoded as 0xf3 0x0f 0x09":
>
> static __always_inline void native_wbnoinvd(void)
> {
>         asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
> }
>
> instead of writing out a comment. It's kinda silly to have to write out
> the encoding explicitly in a comment and then have to rewrite it in the
> code.

Yeah, I see your point. I will add this native_wbnoinvd() wrapper in v6; th=
anks!

