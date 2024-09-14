Return-Path: <kvm+bounces-26888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D4D978CCD
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 04:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58446B2432B
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 02:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FBB11187;
	Sat, 14 Sep 2024 02:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Hll38PE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80E01103
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 02:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726281322; cv=none; b=bcfPwy23XoS9uaep/BC9nIHNtJ2NvUUBogKjfifLTqtwfpPKOY9WERJYt4oIVaK64BvB0ze3X8+2Z25G/m++ePz7wyga+3/XbG2/Nv3IKzyGosB9UTdvNApdXqcHjI9cX5Hsym231dI3EuGjWwWn0MQYVLEApkp2wmOeFk12J+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726281322; c=relaxed/simple;
	bh=Zxg5otL1B6i1olA/BBrcKApvmjoPUf88u7JkfqEzASo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cZtyAmLGX9BZWNIbGPp2w2lk6m8ymA+kTp558is7HmIN4gt7pCKXDsjO6b6k0/VxPL0Y19OvWnoBI0V7v7zvMmahDrjqBPutwmANWzywUdORsQpiKwVdZOWVgKAiE1WbtGuwJ5kVewHjniyJJqZl2of3qWDCrBW6kWpuBjw6e3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Hll38PE; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a098a4796dso15015ab.1
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 19:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726281320; x=1726886120; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQULOfyh/DJvaScdxz940oydRSf0WRZPwFZKMmWALzE=;
        b=0Hll38PEUw2ci9LiQLmAcrY6Qevb8ArAMdqa9ypnhbjpm9QnvZ75KDwmdpp8kM4tL7
         hQsUr3u5O39jnMr/sU7JpLOTMAk7uNtz3ChakK6w0mSAF583oIfLYvIw4EZ4y9pu9iQj
         /AdOiTop8C6gYRmZoqzjcsASMaTsvQT7LiW5+dhd4f5nGi31dalJn71qAEhrk+G56sfy
         uen7TRA1pFe2n67nQh+mGEvpzyciiKYY/xAw+Npwz/GID7u03jSqeynogBCstFoEJ5Cd
         ivJF6e1vrnCD5WctcZBHkA5m5n9h2vILFqys4ntm6GcPlNX5uwRF9mOBx2UMegFycm9M
         Lvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726281320; x=1726886120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQULOfyh/DJvaScdxz940oydRSf0WRZPwFZKMmWALzE=;
        b=fMeR8tR9OEkdTuyEidqJcPKJh1MQXBEZb30ZQG0IR6jFzzjdM2zq1aMyfUeaQQEfkb
         y2QX4BSs6ibY2+ln1TvnR54reQ0chccJz+DtyIazxzEwISUHuFo8IamJWcpGw4NCZeOY
         WM1JB01QSf2fz68zCX4WfuOazUIyNmv64s4Cf7WwbAd876sMmmOG93b8P4Wo3ZCFEESd
         GXD09PAduID1BYstka/YoFjr9NnButxHXIhgG6lI6iqXl3ls4ntGzIGW/rLdpxOyb+/1
         I2o+B5/kbu4GC+3y5ExAnz5WymC0ehvjUHBX9oRJHfYkJeH7IXHVf4jm/hooKyDiCT+D
         P3AQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr61W1acPsq5eu6pC1NA1/i/8w0DqLuuHR6iY8V6Xi2MX1j8uQt9HX3gJBEgHH+Cf+nQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg8OziqCar11E9opzSGhamcaUWX9BkWZPlNayyeqBZXN19Azim
	GXaL7UoPqS5qR0oLMDiTMNO7GoPSBjcqyIW5Fr/bMnb6eA7KpEW93P0Kd1vVmh5p+HaVe0yE+h6
	btSpUmW2mHmh6wlqyhJlSrtONCS57+FHHQvRQ
X-Google-Smtp-Source: AGHT+IFMUAlaPADSOJhXfO70nksqOL+i8glvUTYqOQodqAIKD4Lb4U7ImJZrC/sVwjXk0MI4qk+PZjZt/Lvfp1Mm5sY=
X-Received: by 2002:a92:c249:0:b0:375:bb49:930d with SMTP id
 e9e14a558f8ab-3a0856d2141mr9417565ab.23.1726281319987; Fri, 13 Sep 2024
 19:35:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912141156.231429-1-jon@nutanix.com> <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com> <20240912162440.be23sgv5v5ojtf3q@desk>
 <ZuPNmOLJPJsPlufA@intel.com> <CALMp9eRDtcYKsxqW=z6m=OqF+kB6=GiL-XaWrVrhVQ_2uQz_nA@mail.gmail.com>
 <CALMp9eTQUznmXKAGYpes=A0b1BMbyKaCa+QAYTwwftMN3kufLA@mail.gmail.com> <20240914001623.fzpc2dunmpidi47a@desk>
In-Reply-To: <20240914001623.fzpc2dunmpidi47a@desk>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Sep 2024 19:35:08 -0700
Message-ID: <CALMp9eRvoY5NH3sW6tc+=mP=7ZtuC05HQJUrZdvDAdt27B2cZw@mail.gmail.com>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for 'spectre_bhi=vmexit'
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Jon Kohler <jon@nutanix.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, 
	"kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024 at 5:16=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Fri, Sep 13, 2024 at 04:04:56PM -0700, Jim Mattson wrote:
> > > The IA32_SPEC_CTRL mask and shadow fields should be perfect for this.
> >
> > In fact, this is the guidance given in
> > https://www.intel.com/content/www/us/en/developer/articles/technical/so=
ftware-security-guidance/technical-documentation/branch-history-injection.h=
tml:
> >
> > The VMM should use the =E2=80=9Cvirtualize IA32_SPEC_CTRL=E2=80=9D VM-e=
xecution
> > control to cause BHI_DIS_S to be set (see the VMM Support for
> > BHB-clearing Software Sequences section) whenever:
> > o The VMM is running on a processor for which the short software
> > sequence may not be effective:
> >   - Specifically, it does not enumerate BHI_NO, but does enumerate
> > BHI_DIS_S, and is not an Atom-only processor.
> >
> > In other words, the VMM should set bit 10 in the IA32_SPEC_CTRL mask
> > on SPR. As long as the *effective* guest IA32_SPEC_CTRL value matches
> > the host value, there is no need to write the MSR on VM-{entry,exit}.
>
> With host setting the effective BHI_DIS_S for guest using virtual
> SPEC_CTRL, there will be no way for guest to opt-out of BHI mitigation.
> Or if the guest is mitigating BHI with the software sequence, it will
> still get the hardware mitigation also.
>
> To overcome this, the guest and KVM need to implement
> MSR_VIRTUAL_MITIGATION_CTRL to allow guest to opt-out of hardware
> mitigation.

I don't think there is much value in this additional complexity. If
the guest opts out of BHI mitigation, it will pay dearly for it,
because then the effective value of the guest IA32_SPEC_CTRL will not
be the same as the host value, and KVM will have to write the MSR on
every VM-{entry,exit}. That's likely to be a higher cost than
BHI_DIS_S in VMX non-root operation.

> > There is no need to disable BHI_DIS_S on the host and use the TSX
> > abort sequence in its place.
>
> Exactly.

