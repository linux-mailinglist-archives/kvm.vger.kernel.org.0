Return-Path: <kvm+bounces-61187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 58410C0F410
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 77BE64E7CAA
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039D430C609;
	Mon, 27 Oct 2025 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j+wUHCxh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34DD274FE8
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761582150; cv=none; b=WuB5A/DhPgV47ghE/tsFIHiR/0vi/X9ATCUsqfmCzulj1JCv7HKgxaKt1LG8mtH0EhcclpMhSqMQfSkyWB+BnGQmwLoRwyXBlC758ual+xPsc4FVDMsTQEHk0Y5lDX7m7lisZotAgVy9wU5sV2bw8Eb5+0VBmAF+x09WOLffwUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761582150; c=relaxed/simple;
	bh=Hq6dozn7FneYm8LJqxCxNTRrCSLVacWOEp7uCLzn7Kg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SWpnMkX4hUVZFDObPmSC46/3CuC5wCjxtRtEEhFdwppor8vRZiTn80SeQh8HYxRS3ktumZvno2OZ9L1P3HK5D3tEF+Mk1N5WL4+wP+xLQ20LaR+1IRaGaOXN0XvokaMx0MulvXTOwCh1ckjIRDdEkY7T0Zwlyxg2/fZQFPELklE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j+wUHCxh; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-5d967b66fedso2915986137.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761582147; x=1762186947; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/u/w9SxrB2FtY9FzvVjTdXFlfFnuHfCkL2t+cpOlC4=;
        b=j+wUHCxhjAe6F3cX8QjphNx93lczt8k3uywIoC3oIvb53T9vNUBPHRcdrlWUHD+9eA
         thwDhOq19Qr3Gm5hsay5XzPBpfhpcHpPdUsCNIwquSKbE/VMxZgF0sMJ1qXGFh5nP7KX
         80wnTULW4h760YWAl7Mx/PNO8MBD/HNBV7+jkqYpn+vuXkc2wAAIse2JrcDSNTKb2YeK
         zeTahTtAKVC+ELziITrGvt3GimmJWelFoWDiCrRCVC2ohq028CNOwo4rEu1Y9u8mD232
         1sb3ifqiHTuOgBwNaFworgnCmXv1gjToaILhkQLa/P7eEECqcCHVkA8sGxvYTTBREC/D
         Xhow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761582147; x=1762186947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e/u/w9SxrB2FtY9FzvVjTdXFlfFnuHfCkL2t+cpOlC4=;
        b=skLmDoYHm73J+qC7o3Ebqw6z/TmvR5s/TmHbUqlRiNZIk4I1SoA1iAud1aXGcbWPhY
         TeFm6lICabV7TZxQEj8nNcWhsHxjsTosj5hxxAF53xU/dDOU13/yRFhEj5CdborF7cX+
         lWkhZN9v9n9KlLwSLFVhiU0+zhxc0HyPd/uNMCMHBusMN6EeAZye7AWkamRBg4iF7Irl
         A51fN8iaGXNI/e7UzUnw2bHuVk/r5D0TsoDFTx/KJdoZ//udO4NTuMqDDJYJ98PifeeG
         KI6c+wbk1gEfhVpeMspbwZqME6z0dJpg2mPh64UnJYXjPPAyxZW1RqrbMEv0ZUf6Yu70
         TCrg==
X-Forwarded-Encrypted: i=1; AJvYcCV7aiLK8aP8AgtlMdzzTcTzBkVmgt0X78HQ3ZkiYN+WzVKUmw7P9JwIiBIsCV81+6I04oQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpzGlK4ktWJiWx5nvYgYmsgprjT0vNtqMdugpdCMPQtsaBRyuz
	NjXyZ93mpDSp8d/+kLHFwwLgkUGFGWtillMeKUc5pqfGVrPD9VAqFiffkCmD1181cHzFu2s7W/O
	brEnMd3VKAy9J5autm2QecMpxnmaTp6okTpPzHKpy
X-Gm-Gg: ASbGncuYCj4fsxkv3ftAemo8AEQQWbOcDpBxCi3LL2YaZMaBKxQm4pUE9uf2kDZA5pR
	qDnUZWLqt2hhg99hI7A6C4FFI/KFVR0tUS8kMj/tuqxisOBxwHFvyXDf2PgI5YDlDH9kNiaY0uh
	j6WOOlIBJJLUTrlq8Js8fMgV2Y5RW9q0glfBSklQxBruBOaWkXxmdseO04+WKe90Tcm8UgadGB6
	0dEG4B9+KJZJAKawydiZUihFTZVu6tjQPcgewUQ0Pq9FVn55v3kYiC+g37gtlcqeP0GGbc=
X-Google-Smtp-Source: AGHT+IHAZbwKbu+D68b5wgpXSEZ1o0nlFzGswqi649Hy26Isjz/yTtHjLspSwQxQXofz69lTfGPDYsd1biSptoqbbXA=
X-Received: by 2002:a67:e707:0:b0:5a1:8e46:5c92 with SMTP id
 ada2fe7eead31-5db7ca99ff8mr240254137.14.1761582146356; Mon, 27 Oct 2025
 09:22:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com> <20251008232531.1152035-6-dmatlack@google.com>
In-Reply-To: <20251008232531.1152035-6-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 09:21:57 -0700
X-Gm-Features: AWmQ_bn2X6RtiVunitoMG-cs0h0eiL8d1Ff_hx4ExTBPyBZYyIiuxc1DyrZi5Cc
Message-ID: <CALzav=fZYTZOSwV_xac400YKkvj1=4H5n5M93m7pzXoCG=BQOw@mail.gmail.com>
Subject: Re: [PATCH 05/12] vfio: selftests: Support multiple devices in the
 same container/iommufd
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 8, 2025 at 4:26=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:

> For backwards compatibility with existing tests, and to keep
> single-device tests simple, vfio_pci_device_init() and
> vfio_pci_device_cleanup() remain unchanged.
>
> Multi-devices tests can now put multiple devices in the same
> container/iommufd like so:
>
>   iommu =3D iommu_init(iommu_mode);
>
>   device1 =3D __vfio_pci_device_init(bdf1, iommu);
>   device2 =3D __vfio_pci_device_init(bdf2, iommu);
>   device3 =3D __vfio_pci_device_init(bdf3, iommu);

After using this code internally for a few months, I think it would be
better to just require all tests to call iommu_init() and then
vfio_pci_device_init(). It is not really that much new code to add to
tests, and that will leave the function name __vfio_pci_device_init()
available for other use-cases (like [1]).

[1] https://lore.kernel.org/kvm/20251018000713.677779-20-vipinsh@google.com=
/

