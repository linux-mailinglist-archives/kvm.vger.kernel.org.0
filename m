Return-Path: <kvm+bounces-48719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C99AD18A2
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 08:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3E3C7A4008
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 06:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3282280320;
	Mon,  9 Jun 2025 06:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBWkMh4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EDD2459F9;
	Mon,  9 Jun 2025 06:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749450984; cv=none; b=T1YJsglfaQoIJCzwDRsWT7kpBk1Vwq6UoP2CPuaMaV1aUY7uUXeVbnajWJ58/VU5iAqjmuhhzcOWcO5yQFsIPy0eF80VRnRMkYDIYtyftJgvFUBpImT/FoSRpGcddRTswpKv4FRhpUYkiCad+WxyLUDURx5lfwLtgpOcmvL89DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749450984; c=relaxed/simple;
	bh=bQgR2qHC11zuqIG01E8qJWkBL1w+nt/76di6qyxrPAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kvlGXgVQsZQQ5xfMRNaya5IVim69vKph7Ps2fpTsPgmmSAC4QqU4qjVj7cOAVcw4zKYxJ8lsuCK0NzI0AO7xsr1/eYPk6mK2HxN5tz+ZPJSRMAlVrcPeNy5zGZ1xEgeZmy5oRUdRIOTeTV7jH2za/juf3m0E00toHSZ7kWZ0QQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BBWkMh4O; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-306bf444ba2so3284169a91.1;
        Sun, 08 Jun 2025 23:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749450983; x=1750055783; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQgR2qHC11zuqIG01E8qJWkBL1w+nt/76di6qyxrPAk=;
        b=BBWkMh4OHXqT6Gj5VEo1pkAOy53uMO0HLz7QmyKk/CCiPjo8IqebwHDtVDQf47M5pb
         u/RzFKQHHmxkw+T/vFWzDcDnLu7FtObrzsaEy2tzpG05MFcG06IQMx68LjMdKpI6kyfu
         55eaxLcDxKvusYk0Q49piUs9cp1nfC47n2sHnPqqAw1dWA92Bcsl81GEwpcT3rtsxmLb
         lYJ/lFD+MgB+gKdW0HhASX2UfGk05Kuyfag0J9ZWaiSNmOBkD/w56H2bW+DMaxWANqJ+
         yviJvAbcvPrAxhPUYwWODGDcdCMSgbr38WN0oskCyMBbeJGeq4EEDPpVjKnXa/iePO3S
         UGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749450983; x=1750055783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bQgR2qHC11zuqIG01E8qJWkBL1w+nt/76di6qyxrPAk=;
        b=s2uF4D2378KrOsizRe5t7cBdGZjQt7xscoDaVtlGoB7JXn3dvXx6lHFVP/0p3PkWml
         uE3dNi+LT936G34Xiy9Nw+7bjZOaatDeI2880QDeVh3gw7TFT9D0SEuSLZyE2SgoW3vD
         YsTA373Yl3gpdPX2t9jlH5n1EFELOJVdNCNJXthqgWIltKZovoKbCRpIPHANesGw4J+j
         tu3SLH2xwn/lnWlYCxi2pOMRuHwjqAcVNEbFsiZ5wX3swnhY2EjI9iYWOGPC5jGctLg5
         D/hj9mBhtFMZiob3nsFZWP3dUU2JQqpy38qKCZtiyRK/V3W3KkCbydi5EbId9uNfaNxS
         78ag==
X-Forwarded-Encrypted: i=1; AJvYcCV5FrE4Ng9XFwjgavvBcjZOvjSFYpp9s7kPqUHdF/eH3+bSjRkZcWNNbbXoLzca+ek7cnU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7LiOqdYOyzR5D2e75L/Jx/ntSMOjv/QTZKC+X1ZYHyYEdXMkS
	18Ff4Jy1RhBmoQCvtIFHHLxG5R0XVpIEEyU0qvvKcoNhttqGcVvcFcFiN4EgM+NuRfkz1GTYYNA
	4fZcgjKGb4p7A/rmzK9wI3znZZPqO3nw=
X-Gm-Gg: ASbGncuDDifqhgxBrJnOB9hh36WuORw218oAHCDHace8/DnvmKLun5lRmdrYbA9QJHB
	zSHLrzwp0ry8lX/KEDGWLkWHB2KQ8dZk+I0fXh9DCf1E1U7JSdhZKfrint21FPklfrcqpmZ5pB+
	woYCaNojYbW4n6H+ki/XUpyly/Wtsq4XzEYrn4b5iKytZ1L4aAejfqjmPWOjIlQw==
X-Google-Smtp-Source: AGHT+IEGpAaKrYchHV6Xkg3MH6wD1n4OHQHppWkVrFsI7AL45gMZKDLHyubRtISR6Lk3mUUky01NFZ9EA0Yxb3/UAVA=
X-Received: by 2002:a17:90b:4b46:b0:312:b4a:6342 with SMTP id
 98e67ed59e1d1-3134788faefmr17249740a91.33.1749450982775; Sun, 08 Jun 2025
 23:36:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com> <20250514071803.209166-10-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250514071803.209166-10-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Mon, 9 Jun 2025 14:35:46 +0800
X-Gm-Features: AX0GCFso8zKgugi5MDGk-VUWQw1D_bArK162jwiFvFrRqJCA3za2FZ7DUrgOEtI
Message-ID: <CAMvTesChrj1gDMTBUZ83oVA0WqjY9jE9dRU2f8QBdSGO+ahXAg@mail.gmail.com>
Subject: Re: [RFC PATCH v6 09/32] x86/apic: Rename 'reg_off' to 'reg'
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 3:23=E2=80=AFPM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Rename the 'reg_off' parameter of apic_{set|get}_reg() to 'reg' to
> match other usages in apic.h.
>
> No functional changes intended.
>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

--=20
Thanks
Tianyu Lan

