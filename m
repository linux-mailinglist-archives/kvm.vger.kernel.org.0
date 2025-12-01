Return-Path: <kvm+bounces-65033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B1EC98EF1
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 20:58:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EEC4A345BA4
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 19:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2C3258EE0;
	Mon,  1 Dec 2025 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jC+WLgz/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D35D245019
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764619100; cv=none; b=QkUwTnYD5zJeYvadag1mrWPuMa+JKfi8R+3XbNH1hDJqVefrJGCqtZJ/aMyt9aDIwyK+CZRhAJzUa4o2XTReeVtcv1ht3LrzEbhb1HTNvHwbw3MMJ2oxIGZXg+AI+OzgTUfJ3EoHG8Aqxqn+0fDGZ7fquiQanBhZaLzUNJ0zRig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764619100; c=relaxed/simple;
	bh=RvhQJ/RxnP8LMHIO2HlRZ/Evc3IhzrJOD7HOCowMNBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fn4uoWOKoUctyPTuiGLD7m+YjIJvrdOVHxEW63qmVzAuCWW/qrYj3bnxyqDqDIIsPrxawEcgD5YeUVXTUiLPmqm4vi/FN3/QoEDHQEeQtCq5GUd6pI4zVTHEV++fJcofMkYhFU5FfMXo+WEEgM33NpkjHepnCo/AFoMt24h9OQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jC+WLgz/; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7370698a8eso447911566b.0
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 11:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764619097; x=1765223897; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9NAUitM+MSWweUnE61BNoObWF/ar0jw0l8Av+72afE4=;
        b=jC+WLgz/NKVIWkZSxDLR12ri66xd3Kr+C9viCTNrImUa/bbj0MoDDpVUhE3RANmVCK
         gRWi1E1YO7uWZRkP9oANvxfBmTJAoj54ZwavIjC5bZVhNdhg7SSJeZRznwHxedWs7qZ/
         S269gcspefuhac2OTEd92rEZRpowhwBdh/Kj4HaQtkAQioa6fZPDdbL0bjfO9qnCa4dn
         GblfSvklyk/Ed2Vrby7qX2PCjYClxbNo68+RfociQn56AcaAUiWqWRJu753GAFNjhMdT
         VsJ1245dX9RHbMYU6TkGL2s/tlPczfUXRe2LSzuF9djPqW3mxkmgiRpO5IvQlzuYmkIQ
         hkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764619097; x=1765223897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9NAUitM+MSWweUnE61BNoObWF/ar0jw0l8Av+72afE4=;
        b=Ob37I0gyM/dpZDOMmplO11wFNb8h+BQT+sgJkzTufviGF7meARAUP/k4wus1Zx9yDS
         Z6J+oXljqNMQErSc1/DI74cGYBZOtpYObVH0Fg2SNqQLKT4yTUv5mH/xgGrn2Ts+hnNQ
         VJF1YjqOFFQzQSU2e9LO/9vvM3SgE4dJSWe0NK90i22Bige3pW1eyGptGd2e51ZBq1M2
         9+DKzjmUcO8+eoQDIosGqxEk2/ZDBtt5RieAvKM3G0+zlSRGSFX3KR8Vt9bCAqzg+G8T
         Gf0ZKDHeW6xgYVZYe15+W+s/SKL0B3bjB3EVxPkBjDg+1CfE4TT6oebUBVKHa1l8m2ly
         6ZVA==
X-Gm-Message-State: AOJu0YxrFhdB/ZuM+OWxXywQ1wlWaj91LF7xYwDie71ZPUXNRjoH8udG
	VNpeLvRy4bEm4vaN/P5JTWJP3rYOIvG/K+5PRU2UYQuOsWScME+BIlS/SO0iqddcofonNVT/oQo
	sOHlCEq4Z
X-Gm-Gg: ASbGnctQq0LFeq08VOyFZzhjCdMlsofGIB6AsZn4uAzFSz0C1B0Ymaj2wRkUXjVtVCX
	lZyVNledA0bP3aZL3/0U0n+/05m0hfuSM4N9+oO/6yv0FN+yYLYz+cb/IdvKnJFFvsTndgkaV4w
	jS1aKzO29xgvujR9yk/aafi2qKVJI1fUYeBCRQ1cVrMiS+TdgPr7zp5hAwg3pA9yQfkGnV9V+8x
	DePKbgGQf2CIZTITljcdndZneyCWn/wvE9fvglP3ase38s5F1SZ+vNOGMBx8gO7IBRi223DWYdW
	KVXOPN9hpq6X5GBsQqBDclOvaQaU1KJi/ZUCdkkN0g5VCrpDp+Qvoks1/1YAkFkyGYyT+lOIBB5
	5qAW6p2TwgEyUGERlKnXrrCNf7BZD4lhb0jdbvCm45xgiVkBboz32+3rUoD6J+61ue1+luGJ34r
	eidgQMgT4qPixbqwXPD/bYotJtL/rbWTvZqUL7jJa4eU+FxCvBMqVByg==
X-Google-Smtp-Source: AGHT+IH2zdDJmxuV1Kx70hy1xujwpWhYPpBA15ctZSpVUkxE7sUPJ7uI1HDSh04+fVoYPr2+q+18ZA==
X-Received: by 2002:a17:907:6d13:b0:b77:18a0:3c8b with SMTP id a640c23a62f3a-b7718a03cd2mr1349980566b.1.1764619096714;
        Mon, 01 Dec 2025 11:58:16 -0800 (PST)
Received: from google.com (214.44.34.34.bc.googleusercontent.com. [34.34.44.214])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f519d883sm1298814466b.17.2025.12.01.11.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 11:58:16 -0800 (PST)
Date: Mon, 1 Dec 2025 19:58:13 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Prevent FWD_TO_USER of SMCCC to pKVM
Message-ID: <oim4q3obyy7jh2juw2qngl4xti6hjg6pavfnm3u3fppa4ao6dq@x7sanj32ttsi>
References: <20251201-smccc-filter-v1-1-b4831416f8a3@google.com>
 <86ms42ox67.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ms42ox67.wl-maz@kernel.org>

Hi Marc,

Thanks for your quick review!

On Mon, Dec 01, 2025 at 06:48:48PM +0000, Marc Zyngier wrote:
> On Mon, 01 Dec 2025 18:19:52 +0000,
> "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com> wrote:
> > 
> > With protected VMs, forwarding guest HVC/SMCs happens at two interfaces:
> > 
> >      pKVM [EL2] <--> KVM [EL1] <--> VMM [EL0]
> > 
> > so it might be possible for EL0 to successfully register with EL1 to
> > handle guest SMCCC calls but never see the KVM_EXIT_HYPERCALL, even if
> > the calls are properly issued by the guest, due to EL2 handling them so
> > that (host) EL1 never gets a chance to exit to EL0.
> > 
> > Instead, avoid that confusing situation and make userspace fail early by
> > disallowing KVM_ARM_VM_SMCCC_FILTER-ing calls from protected guests in
> > the KVM FID range (which pKVM re-uses).
> > 
> > DEN0028 defines 65536 "Vendor Specific Hypervisor Service Calls":
> > 
> > - the first ARM_SMCCC_KVM_NUM_FUNCS (128) can be custom-defined
> > - the following 3 are currently standardized
> > - the rest is "reserved for future expansion"
> > 
> > so reserve them all, like commit 821d935c87bc ("KVM: arm64: Introduce
> > support for userspace SMCCC filtering") with the Arm Architecture Calls.
> 
> I don't think preventing all hypercalls from reaching userspace is
> acceptable from an API perspective. For example, it is highly expected
> that the hypercall that exposes the various MIDR/REVIDR/AIDR that the
> guest can be expected to run on is handled in userspace.
> 
> Given that this hypercall is critical to the correct behaviour of a
> guest in an asymmetric system, you can't really forbid it. If you
> don't want it, that's fine -- don't implement it in your VMM.
> 
> But I fully expect pKVM to inherit the existing APIs by virtue of
> being a KVM backend.
> 
> > Alternatively, we could have only reserved the ARM_SMCCC_KVM_NUM_FUNCS
> > (or even a subset of it) and the "Call UID Query" but that would have
> > risked future conflicts between that uAPI and an extension of the SMCCC
> > or of the pKVM ABI.
> 
> I disagree. The only ones you can legitimately block are the ones that
> are earmarked for pKVM itself (2-63), and only these. Everything else
> should make it to userspace if the guest and the VMM agree to do so.

Sounds good, I'll limit v2 to these FIDs and the "Call UID Query" (unavoidable).

> 
> This is part of the KVM ABI, and pKVM should be fixed.

I agree. In particular on not restricting {S,G}ET_ONE_REG to a point where the
KVM uAPI for SMCCC filtering can't be supported, as some experimental Linux
forks might [1] have done! I couldn't find the corresponding patches on LKML to
contribute this feedback to, so something to keep in mind when they come in :)

[1]: https://r.android.com/q/I1c7bc93ebe0bfb597cca5c4284ceb7fd53e4713c

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks!

-- 
Pierre

