Return-Path: <kvm+bounces-51778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2538AFCE31
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14295177657
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4EA1C861A;
	Tue,  8 Jul 2025 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vc3FcvVV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5432DAFDF
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751986145; cv=none; b=EmweePRHlhLgvgEumLQe8eZrOi1xhO3S0T5DtJDTc6CRl3cE5aQiRfxoRLbJenIzABjzfBfCCD512NCQrrngk3BNhH7VQ6Vd3hDPQjhzWI/2qQ3+4GsutQ+1eT2ZRnZFEmxxF0nq6NH4DONsLzFf0IfVP3nydJTTHquxAT01r3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751986145; c=relaxed/simple;
	bh=q8spVkoLv2r7TKyH2WL1jNBqws9fnH4WQcFK7oE9C1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EeKyl+ehCxinH5tWNsngUKPWg6j7sCbPkW+o8W0cyX6ADXM4Iq3A+spa8wiwlxkCkUEKH9TEvvgFRJQspVs9qmVh7SlAkHBV6r3U07pvI/8ezUZH3VsuMUAd7zgmne+3sTUwoWpGnuwLJKbcKYoS3R8vnBNEIXXEZEa+Xo6RF5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vc3FcvVV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751986143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ilLnM1nkDK5EG4IlWePIEBnogI1MpE46KJsgpSIvj2E=;
	b=Vc3FcvVVuuNO2J1oh2SUHtg4W3P3QeaFz3+tRl1ds7+1dfG+ncsg6f9bqxRyxjUFmaVXXy
	AYNGk94NKO1yVHK2IPkMYrAWQ23vjB32CyQ5iRnMEZis9/2n0U6q+QmguGIGCLGMFsfSX9
	9pMmlYjW+D/3t4lI6EM4vIGPo+QnlgQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-VQ8-z4bjNUWswrGf1CeOxA-1; Tue, 08 Jul 2025 10:49:02 -0400
X-MC-Unique: VQ8-z4bjNUWswrGf1CeOxA-1
X-Mimecast-MFC-AGG-ID: VQ8-z4bjNUWswrGf1CeOxA_1751986141
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4eb6fcd88so2820636f8f.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751986141; x=1752590941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilLnM1nkDK5EG4IlWePIEBnogI1MpE46KJsgpSIvj2E=;
        b=UNUm1sm/rgqCH2+mfA8P9pMB6WvU4fXoQCUseHVmaA/qQIiRPUiy5D9C+Ue9jAJJ8p
         OC715diJe0theFd1hX54I4hKTV3XaWrMOhoOfJcQRSBkjKikU8Bi0gloaCar9Ssv6HTU
         HVUYh0v5978aLx7RMBDDmRb8MaVXMlmk8iDJ1w6cEKUYBa4k4RtxLzAPwfJWFNzVAHFr
         l/dLhxcElnVwQ+iG16wNx3+RcXUjrPvMt4h7H8ZH5wV3s/mWPfr+HIwJ1ZR75SkdStrA
         XeQ2bvx3YtgfF6Z2PZqMcGlcs16M1WMpkH220WHHWWUJDonpQ4TwGDnrtuRZ1shIZIRR
         zFdA==
X-Forwarded-Encrypted: i=1; AJvYcCW+ikKdKos0JVrFABHcncXCLs7IK9U5ShtKiVb7Y1Kp7Mbpjb3G1HLVz6GDafzyZOC6SFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWo6kqX7OExBTGJxu2UC+UAbpyZNij2brREn2ZnTvf8z93zo1U
	kqNI52wco+dEZvQT8t1DJ0z5FT0Pu3Gt4153EBlcF6SXh8J0pJSp7VE5s3Ab8N4ZVwWW6t+J+CD
	6J9iBC3UCaRoDXDuUPHzDXG1g93TjMg8OAgVnqIVQcxIDHwqGwLrHeoNoao8rRe6mVyZVC6a+96
	93EXl12wsJJwCut1AT7rM38vIW0Vop
X-Gm-Gg: ASbGncvv3vOz052IXbES4LLv6P9DZsEEWl1hGeYT7djtnaOkCyvGzIqIyp+hxoY6KeL
	DbE474pygJCSWebEd0+ro7K4R02qzsv0zRnI/owVGXvvbPtscCnz4dDgSvReM1HsNJ2hrIbhuJl
	OxQw==
X-Received: by 2002:a05:6000:2281:b0:3b4:4876:9088 with SMTP id ffacd0b85a97d-3b49702e7e1mr13523184f8f.46.1751986140859;
        Tue, 08 Jul 2025 07:49:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNmhF5tEibNLSO4zklVeukkffwYibjFI3qCmoKoreWsosWzDc7FRBfrG9K0f+Z6MixAgDUVST4ozCaCvN0Rx0=
X-Received: by 2002:a05:6000:2281:b0:3b4:4876:9088 with SMTP id
 ffacd0b85a97d-3b49702e7e1mr13523163f8f.46.1751986140408; Tue, 08 Jul 2025
 07:49:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703100544.947908-1-maz@kernel.org>
In-Reply-To: <20250703100544.947908-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Jul 2025 16:48:48 +0200
X-Gm-Features: Ac12FXyc1eDwUfgvyIyyq8lMwH--Dkal7I5XoAdK2HIbjIFxeLbn23IfObIwnEg
Message-ID: <CABgObfafDC6m303YirQvgYdfZxZ6fL0LmU4H0gKdkGGv9QvVeA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #5
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 12:08=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> The one-fixes-PR-per-week trend continues, with ever decreasing levels
> of severity.
>
> This time, we drop some leftovers from past fixes, removing the EL1 S1
> mapping of the host FPSIMD state, and stop advertising bogus S2 base
> granule sizes to the guest.
>
> I expect you will bundle this with the kvmarm-fixes-6.16-4 PR from
> last week.

Indeed.  It'll get to Linus tomorrow after the KVM community call.

Paolo


