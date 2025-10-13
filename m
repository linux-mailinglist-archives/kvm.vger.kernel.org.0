Return-Path: <kvm+bounces-59948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B5DBD69D3
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 00:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00C6518A3AFC
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 22:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92ED30507F;
	Mon, 13 Oct 2025 22:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LckEC/Dp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7273376026
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 22:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394690; cv=none; b=i8essHfGJthxX6ioJRBnnaNheRtuuLNST9lyehkJKa3vhm5Af6iviuzyl7ot4K2CPVvMuMgOMIXcXBja/OkqiS+LlD4VJyUEjMBZgswClzkrrcGaVjdQLSo9fYmWXIAh/Q7TFLL/IpUMMReUTXHksplFBUPtx+YiVxw3Nv5p2Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394690; c=relaxed/simple;
	bh=+ySgBYKp5sgJmpYv5oyU08u88544UwIMJoZQjMVM5Cw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rBTKgPEnjqN8jz9S5g9SjLpz+DYvPLNNzey2/3kcYx7Cwo+bjpyLb3Q1QBjzWRYhLbM53MHzyqRo7tlD3zTn9Anr/8ABleeyV8ia9O9Zn73/KLW4gipMqmU+NKGkTJPPelKBY6aDtNT6L1ygvPFwm0hEyKGMnZDCJZm619cBkPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LckEC/Dp; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so25271a12.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760394686; x=1760999486; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcR8QYF3LC3OedvBD3xFc4hECJtuzfDK+Smhc5CK5JA=;
        b=LckEC/DpZUdn3iSxlOAC+5XPRPkUHjC4nlO2Ou0FXFBbQxNWE/58BPjVWkfEnTvo9N
         tgOpuX4/FfcCRKBmvz0FfC2OcvqtqdpVTusX/gdLEFZSDKOi6auvEVscac6/cdW63Lz4
         9mG8nu0U3fqdwb22G9TeJLeKH0ws1oFvjz15wtGib1koWlQwUZiDIoEmwfYSVgf1eWvr
         cjb1WqqMqzD4H7CgxcTFs+KOgwFqs9XjYOhQNd4gpHQ0Xixn96LoqB3pUVQJ5Ta3V43W
         Pfqv7WGM7RTL52L891/Y6lQXrBDtUQxikcIXRQNsyXlXAU5+GrVo51MfAJyryjRYlJZ8
         vIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760394686; x=1760999486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YcR8QYF3LC3OedvBD3xFc4hECJtuzfDK+Smhc5CK5JA=;
        b=VNh8ZYZS7Fsa7uUZ1zUHnN7R+0NPY4E+7bj456XA8RJaKmDfhOsOJC7kGlQximKpND
         0pbD22AC13cO7TJm2VQTOaGuRpoO5PEA1xPoa30uj+qvGBmlJtc7lhUmqGPZ40/HyxvK
         OIE2uPggd5Midkxrz2rQny+rZTIHKIENtiR/qzLeL4s+PeEpRvSIVG0rtvxYC0SbSKd/
         80mnQclSqW9ofX5WWMv+lTRCK0WisECwl78nlGnOXNmylHYY1BXiUFZCzwzYtEXzASOY
         Xm/h1SBSU+pnhrkJxM0VwZ5zXIGT9Wg+rZSDWnVx9DfXxObYdzHcrqoZCesEKdZknUel
         MX9w==
X-Forwarded-Encrypted: i=1; AJvYcCW54ZDAjNcZ4ZtCJbQfLLh3IRvqvVrCa+mnPSpoHwSUJXEvozfoBeecBxwoDecNGb35Od0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxRXHfFgdjORxNmslR2yeSKe1c51ccuXSCtHFKqddHPfrckK/C
	huSzlybdvf8XUvM5T/7eOaU+k7OjCgrbV0D2zcNvC6nOVDoIPrF/KydeIdNiE9YgR82I8MWFgUn
	+70KXhnShC1s+Px4bHbqyBIBUFqvZSHiTapBYu23s
X-Gm-Gg: ASbGncuuYXT91JTDAzoGoQgZ9k1gWfw+BJKM4eVfA8EKFOeTh96rRz8rHQkv4Q2UNPy
	zKSyLIf64pbvCLWB/GUznvYazYy64dYywRhH1V2DL/OruoIVdPSmVoFK8038TWj4xAU3e6eUez+
	s1Z4BSQ0YQ3Mnnhx1k/rk1Vky/HJcYrTUia4z391xes8bbFkPt+gqqqT/LhwTqIeAjbvBo2FK/I
	MRHHDC960ss0nPw9W/062xBiOP2fbpRUFEk3PJBzsA=
X-Google-Smtp-Source: AGHT+IHmNmEO8UjVvewqClbQGgSN+TsvobxIhiIwo9csw6fcanDJv8mEWMQbIpvQc5+JpEPlcVIyIMZhpv/3rMzG93k=
X-Received: by 2002:aa7:d889:0:b0:634:90ba:2361 with SMTP id
 4fb4d7f45d1cf-639d52e9f0emr650243a12.7.1760394686126; Mon, 13 Oct 2025
 15:31:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922162935.621409-1-jmattson@google.com> <aO11A4mzwqLzeXN9@google.com>
In-Reply-To: <aO11A4mzwqLzeXN9@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 13 Oct 2025 15:31:14 -0700
X-Gm-Features: AS18NWCUVfXmqLoMJQM4_72eVGSE-rWiwIwZWPFi4AijdWXJ2AtP924z8ut-JgM
Message-ID: <CALMp9eQN9b-EkysBHDj127p2s4m9jnicjMd+9GKWdFfaxBToQg@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Aggressively clear vmcb02 clean bits
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 2:54=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Sep 22, 2025, Jim Mattson wrote:
> > It is unlikely that L1 will toggle the MSR intercept bit in vmcb02,
> > or that L1 will change its own IA32_PAT MSR. However, if it does,
> > the affected fields in vmcb02 should not be marked clean.
> >
> > An alternative approach would be to implement a set of mutators for
> > vmcb02 fields, and to clear the associated clean bit whenever a field
> > is modified.
>
> Any reason not to tag these for stable@?  I can't think of any meaningful
> downsides, so erring on the side of caution seems prudent.

SGTM. Do you want a new version?

