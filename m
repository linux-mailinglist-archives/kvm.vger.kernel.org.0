Return-Path: <kvm+bounces-64881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3E9C8F318
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 16:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0C4B24EFCA0
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 15:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0C75334C28;
	Thu, 27 Nov 2025 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sldNJaW/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E568C334C08
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764256026; cv=none; b=kd8/inQBJr0eUaNvsiXIRbl8p9PtRxSHPc8w7Of5o9ROHAm3B56ITV9KhADQh++sUM+ufarnC8RbS4mU/F8OoNet2gJmht0V/jOsjayfQLcgR34fNKqhKbB3rDpVaXt67ZAmro6TUIbEepurw9SWhbQR0S1YZ+0TqqdPkBn8t6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764256026; c=relaxed/simple;
	bh=O3Jl0TedBRVRfVhZgOJdrLKqQHfxK+5HmiN/P10lDXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kWCkBxR1M4x1pFBcozogUjLmcOObjFSmrUB4hY2ZoBp9CtNF21lpWzggx/e2qTwRzHD0YITo+z1T7hjEtf7oxV21CDtHV9GNXrRwjY4fBzbYZaPXBMZtsaOvQZm6fNS8kKNgfhXmCB+MpJwVPdIQSpvMO0nMiuBFKNAsfSDKRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sldNJaW/; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63f97ab5cfcso744608d50.0
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764256023; x=1764860823; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o9j9JckZewB0T/evvAwAYflbY/oMjYUWYlwvg8R/JAM=;
        b=sldNJaW/mtHUk78eRyP2lAEuPxOVWCzUy34HKQc/0B5GXWG56q2ha5vgocIRVwl74n
         /3dcW/6l7FjFIbfofeKt/0akG5TOwa0eP31I6hQ53kXoBexKm1WAwg4J103a+j2X3I2S
         2c+NuSx8sP3POpaNzZrv0c/kYzfrL8VJEcc4fT8V6Mm8DcChWlximDOZZoeymr8diehT
         V/kxDRBF1Y0mLoBCJf88TYLMNK7+kQj8Y7bqnfL+/DiZ/1xxmJ0J2A47JpWlb/PPvchH
         kmGVgaj5CMHQkL4CsUhepeDuuoaUd+ZhttYIDhHyoh7kcJYUshRM2EP1K5hzyb8e2op6
         yt6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764256023; x=1764860823;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9j9JckZewB0T/evvAwAYflbY/oMjYUWYlwvg8R/JAM=;
        b=sgDIH6GEmIsf24cK3DfWUNxSrMFi/4TERTx3dBmWAsf7qWa8X4iyq3im+uyocrv/Qi
         c9XjH1vKLRDmGeX3DWxBLqcvisr+ei26pd18TB1A2AVaZTCeHqnq/q5eDhkMgutFCr16
         lWFdE3jmc2MEOhq0GdANzyVpk9ZEFcbtB5VIrBS/d9Ql65tyiokYExfLQ/JGPULPIAQy
         hqCf4rMvExqWAK8oZrf09XQKyuKjFBkDR0WO+Mqi/9tfhu/wgNjSrEywEfa+r3HhrrBz
         WgTz/xN3saCBRNipRrI9PzinK3O0qMtdVBHdvyj7ofNjglE9EkwVErEUXWV5t1v57fdE
         Q2Sg==
X-Forwarded-Encrypted: i=1; AJvYcCUxEoIQaxpX68fl5F2rtdaSkoQRpYpN1Hepxgn/kM4sevoR0x5vf5Gi5lI8YnH+R1Cf2Jw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxALUc189+R07dNpx8UAwdwfA0d9Be6b13Vxlba2/Hp2IkMyDm3
	tU69OFJ6DHtIP4gJImfGNxD6OC66GlSuDEAf2voX4nbfn2EeFTMBYoG+1iuG/QZD9a7c4vvD17U
	6WmHKWuoPu1pthX1JXXfn/nw+fso5F1+AUN2lCorGhA==
X-Gm-Gg: ASbGncvy3/O5kaRBU5UYOSaD4n58bJmxft2UWAv4CYkPf22RQSxZgFK9o78dU3zLm4r
	iJB2vqe35LeuaB5gc9uXC8F/ARPoU1GErveNh493mfO2OimtQwx7AXTTtPaxN0Pwvs7SjRK6FK7
	LrQmuzc0MF0HIykVh8Nl5P4mYc4KtJP0UdOfF3l1P5IX/1Xhb9Zn6wf5bsUYCHeARcJVofoGfIu
	+cvYDycv59kHcNil/mvNynGTGiWLYzmiC1V+eDauVdPa9hKQksaqFO66dnr/NlldXjkyKmR
X-Google-Smtp-Source: AGHT+IHOZv1XVUaCpJ1GafgJ+Q4ufaODDINZzVe7OUjEEvUjTH0ObsXn/Gn7AJqtRSZdFMpWXb50BEdfVotDE3qezIw=
X-Received: by 2002:a05:690e:1581:10b0:641:f5bc:68d3 with SMTP id
 956f58d0204a3-6432940d24amr6552660d50.80.1764256022644; Thu, 27 Nov 2025
 07:07:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902-kvm-arm64-sme-v8-0-2cb2199c656c@kernel.org>
 <20250902-kvm-arm64-sme-v8-11-2cb2199c656c@kernel.org> <CAFEAcA_GJ7gzn7aMCZYxHnJWvx4tHSHBKsOxtQ7NTb4gPjkMJQ@mail.gmail.com>
 <df712591-397e-422b-b9c9-fbf080cad9aa@sirena.org.uk>
In-Reply-To: <df712591-397e-422b-b9c9-fbf080cad9aa@sirena.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 27 Nov 2025 15:06:50 +0000
X-Gm-Features: AWmQ_blQNCtlqrFl6oR-29ayIeVzxjSMrcpdxqL32ABrh38kpa7m6Xz9ardxRBI
Message-ID: <CAFEAcA8LGwm-6JEhtKTq1E_da-T=H-aBX9-8LMJOAQpK5J+NfQ@mail.gmail.com>
Subject: Re: [PATCH v8 11/29] KVM: arm64: Document the KVM ABI for SME
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Nov 2025 at 20:13, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Nov 24, 2025 at 03:48:06PM +0000, Peter Maydell wrote:
> > On Tue, 2 Sept 2025 at 12:45, Mark Brown <broonie@kernel.org> wrote:
>
> > > SME, the Scalable Matrix Extension, is an arm64 extension which adds
> > > support for matrix operations, with core concepts patterned after SVE.
>
> > I haven't actually tried writing any code that uses this proposed
> > ABI, but mostly it looks OK to me. I have a few nits below, but
> > my main concern is the bits of text that say (or seem to say --
> > maybe I'm misinterpreting them) that various parts of how userspace
> > accesses the guest state (e.g. the fp regs) depend on the current
> > state of the vcpu, rather than being only a function of how the
> > vcpu was configured. That seems to me like it's unnecessarily awkward.
> > (More detail below.)
>
> That was deliberate and I agree it is awkward, it was introduced as a
> result of earlier review comments.  I had originally implemented an ABI
> where the VL for the vector registers was the maximum of the SVE and SME
> VLs but the feedback was that the ABI should instead follow what the
> architecture does with the vector length and potentially presence of the
> vector registers depending on the current streaming mode configuration.
> It sounds like you would prefer something more like what was there
> originally?

Yes, that's what I would prefer. The "varies by current CPU state"
approach seems to me to be not the way we do things right now,
and to be awkward for the VMM side, so it ought to have a really
strong justification for why we need it.

Generally the VMM doesn't care about the actual current state of the
CPU, it just wants all the data (e.g. to send for migration). We don't
make the current SVE accessors change based on what the current SVE
vq length is or whether the guest has set the SVE enable bits -- we
have "if the vcpu supports SVE at all, data is always accessed via
the SVE accessors, and it's always the max_vq length, regardless of
how the vcpu has set its current vq length".

What's the benefit of making the way KVM exposes the data
bounce around based on the current CPU state? Does that
make things easier for the kernel internally?

-- PMM

