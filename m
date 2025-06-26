Return-Path: <kvm+bounces-50855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1333AEA389
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:32:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13D671C44413
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 16:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D072ED87B;
	Thu, 26 Jun 2025 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j+kHMsd2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665622264C6
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 16:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750955391; cv=none; b=nW7TepEy3KRqX32RoQiNfdYx1A613CsQkUXP+9eEMk0FAiOybGL+3jAXxtZfw+NbZ1arJ4wg9x+URdfx2jgCuBpogmWGF3a6Xiz6MIGl8pwy0iUmbkqkh/JzLKqL9hlyA0mxGj4WRVvc+jT6LGNdH1/9WX8Qhdm6f7FqdBuFP7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750955391; c=relaxed/simple;
	bh=AgCtIvqoexub9Qv7N/AgH5wxwMGGGs/6YulBNCxbeCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B9j0AbAsotVxUF9xn2707J8DPdMmJPYy6AW4arVwVF2SUr9pecdJg7BeQy8avIWhIwumuDFdKEllBPfaxm+e5AHhcvXAz/+eeWBx/nINsG7Db3s+P4BaeaiDDBpiUaaoNpH1GfxqTpQXHQP0tMb62iTY5kAJ0+7GPssUHaPNbxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j+kHMsd2; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-553b60de463so1340837e87.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 09:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750955388; x=1751560188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IhgWMpVftN0BXlOXEuQTKXHJQDcbuJWCCJBvXCzzlws=;
        b=j+kHMsd28pa2eEUT5k7m2NZt/ZYbHThGKY2Gc38l8n/zflNGyorZYxKAY08FzUTPv0
         jS+acmTxaThxS6o1SDFjXyCJw6Bq5AesRY/hGPjzZQFvQMIu6Frw3qbO9EtbYTrWi5YD
         CLL4kBT4xsSGpItx98cFM1E6CAy6JgrS0XY1BOUTleTSU7HUD/svSvg2FLqjK58TXad9
         hIWcAYnsWPpgQ4FGvf8YsnLfpslaj3hqZcgbMuMz+kIbDSCJtKj4c3OIpDKjaL9n7nld
         4i9uImBbIHzgen3TSbbjfJI404hM1o3h6ViVKDHnmAaXBwTprsgueR0806w+AxfCQNWn
         e+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750955388; x=1751560188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IhgWMpVftN0BXlOXEuQTKXHJQDcbuJWCCJBvXCzzlws=;
        b=bCoAQjwpczfIxTmUkp1D+TLflcTlConSdSPOxEswx4EqcxQfmuI9iir8inoiTxJhJ8
         py++LPbpJqoZpDvtAmln1i8QC/9pZfE0wJ/ADYX3dU4ZOEZ3LD/9p1ruSKI8Q7WJeFvs
         bnX9pCJnQfFDSftVhSyjVEEonAhDK8ui2LlbODlxZbidwzSwaYyAbvkzzsgUDZz0V8nx
         kqgn20exujTYEswdneoVKDtYKKLCJwHhME0zKgeaVSqYTTCHh9M4CK8oeNIvUAIGKRJr
         wZ5+inKb0lSxIxzE8StYk0Dk4EjIXaMnUryk+NPmHAOK8f0AM0rnj3iX8ZXtDlGDGK8o
         UVCA==
X-Forwarded-Encrypted: i=1; AJvYcCUbB2jym6/OveAl8ln9q9BmxhXZeUb+YLXSZB/ynwQ8F0alf+GXPOhSBgMybBdnp9WF9ok=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPOPYeOBCIcJ2gZkkw8BtJh9CNIOKgRArxR/mPlgmcrroctXfD
	JR17UNGm/b7aSMkX8aZIgWvjfDxAABymMyH8xMEp0hqPgo2m1YxNass5KqVcsSllAQQjHGGhfzW
	za3DxihfPNhUoQm8gm5lnfv2rrRGTaURAAbPGOzxz
X-Gm-Gg: ASbGncupkH1w+TQk+SaZBphwty14EFWoSCjVzsrO6US8kRvqJkv/lHuS3ntVlkN9d+7
	hJOxvsAwf8vDO5TxpawTzAPQMazl2hNnRavBcnYnANieLTD8ayDYk14QNmuqd6/fN/0Xbi2xkYO
	ZfYEqYtVNj4nR1xcqX7z0RhaGVfhOURL/wmNV4ShKlKxg=
X-Google-Smtp-Source: AGHT+IEEwFR4Q1I48a+7OABIyBDRSlZA5tbdQsFM85tiZhc32of4fKA/nSlskPFcjFXcvfWw+C300VPrlQj8CDH2vFU=
X-Received: by 2002:a05:6512:3d0d:b0:553:2159:8718 with SMTP id
 2adb3069b0e04-5550b9e9f76mr68343e87.40.1750955387360; Thu, 26 Jun 2025
 09:29:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com> <20250620232031.2705638-4-dmatlack@google.com>
 <fe4b1d31-e910-40a1-ab83-d9fd936d1493@amd.com> <4aef95a0-a0de-4bd5-b4ec-5289f0bc0ab1@amd.com>
In-Reply-To: <4aef95a0-a0de-4bd5-b4ec-5289f0bc0ab1@amd.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 26 Jun 2025 09:29:20 -0700
X-Gm-Features: Ac12FXxh3iVx0ijncX4D0ghMn9yxTN7axomwuLA6jqvWOXSFOfPrvAPiEnHLUx4
Message-ID: <CALzav=fZcLpQ+9J=XOZ-=Cr1UA8qKa5NHXB1dJpqhCp7pee7Ow@mail.gmail.com>
Subject: Re: [PATCH 03/33] vfio: selftests: Introduce vfio_pci_device_test
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Bibo Mao <maobibo@loongson.cn>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, dmaengine@vger.kernel.org, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Wei Yang <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025 at 4:44=E2=80=AFAM Sairaj Kodilkar <sarunkod@amd.com> =
wrote:
> On 6/26/2025 4:57 PM, Sairaj Kodilkar wrote:
> > On 6/21/2025 4:50 AM, David Matlack wrote:
> >> +/*
> >> + * Limit the number of MSIs enabled/disabled by the test regardless
> >> of the
> >> + * number of MSIs the device itself supports, e.g. to avoid hitting
> >> IRTE limits.
> >> + */
> >> +#define MAX_TEST_MSI 16U
> >> +
> >
> > Now that AMD IOMMU supports upto 2048 IRTEs per device, I wonder if we
> > can include a test with max MSIs 2048.

That sounds worth doing. I originally added this because I was hitting
IRTE limits on an Intel host and a ~6.6 kernel.

Is there some way the test can detect from userspace that the IOMMU
supports 2048 IRTEs that we could key off to decide what value of
MAX_TEST_MSI to use?

> >> +
> >> +    vfio_pci_dma_map(self->device, iova, size, mem);
> >> +    printf("Mapped HVA %p (size 0x%lx) at IOVA 0x%lx\n", mem, size,
> >> iova);
> >> +    vfio_pci_dma_unmap(self->device, iova, size);
> >
> >
> > I am slightly confused here. Because You are having an assert on munmap
> > and not on any of the vfio_pci_dma_(map/unmap). This test case is not
> > testing VFIO.
>
> I missed to see ioctl_assert. Please ignore this :) Sorry about that.

No worries, it's not very obvious :)

vfio_pci_dma_map() and vfio_pci_dma_unmap() both return void right now
and perform internal asserts since all current users of those
functions want to assert success.

If and when we have a use-case to assert that map or unmap fails
(which I think we'll definitely have) we can add __vfio_pci_dma_map()
and __vfio_pci_dma_unmap() variants that return int instead of void.

