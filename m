Return-Path: <kvm+bounces-51038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3814AEC2E1
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 01:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52C334A149C
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 23:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AC428F92F;
	Fri, 27 Jun 2025 23:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PX0DqBZo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C59F284671
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 23:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751065713; cv=none; b=eKRjLuRCWWu9nexe0wRb5HwOQQTK2qP7LOpM1t30u5I3OY8aMolgjgXCyOrCTf3bXZtve5k9hLrG9zt2FWXkb40pCobybfd3dsxh434CxSMdcRtaoR9JCF+hDRwBAzoUHaCajtJ+gE0UT45dsZINCkcnGXuQ+NXpF+VTJPcPpC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751065713; c=relaxed/simple;
	bh=c/Of0xutA+Kk8MDQftdKz5UrDWZnct4kULqWe9XInJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZmNCXPncXce9FS+sAxGMaTWdt6rxzG/wOU8U0ZivnJ4VwB+YX6A7PCBpzIc4bQyPjIXcbmHAFeZM5E0GjeZt4Q4zUDDcWKmnXPZjyKPXz4rRPeYI3uL6pLPQMIvo+w6PpORQwd45i6QsHt9qzZtcQm8phROqBudfrtdn2taQ9go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PX0DqBZo; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-553b9eb2299so3312943e87.0
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 16:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751065710; x=1751670510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HCmg79c12dA4cXhbdn+5ySYQM1Q/m3EZoakXslQDFMQ=;
        b=PX0DqBZoY5I+KaNfCc+Gm3izoHzxObSak1pD3+7fuISeigqm3DO3G4uXiquTOlnzFK
         ZzSYJgNGb8AsnXrVhL4xiwkJwjNAc4KRhK9qpLrDw+oRNoUIJ7RwF9OGIr9BW4yObr8j
         3y5XyaGQB1yi3E0TLjiw1f7lYIjLTtvMX0HlzG8dgyL/lNSN7e/joVINg+Nd1eDC5sYw
         B3uZ4fiqN2qz9zoFwNj6QVfrd0vi/iod9SvVOtvZnx8ESrwydSYDrxv6k4RgXFo8ioMo
         jjvqKG2B7eb6SUSTVFRnQvYhBYE97QWUhXmz7VI+tqiygoBThdx/UgfXfxMvnajGT5ri
         Godg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751065710; x=1751670510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HCmg79c12dA4cXhbdn+5ySYQM1Q/m3EZoakXslQDFMQ=;
        b=aEiJd5NhLFGkt4Y4BabviNbo3dxdsotnCna7g3t9qYdu0X1Mq1TyWB9G8iv+f1OlwG
         WncPhcRGbY6MdeIW2yjsb9kIg1BYzv2/1vjDmVIq+J9N/HRfsO7VGDKmnfDZOBAp3DXs
         rtSjFrkUHMrePNvKqIFUve8eG1wiEpfOeBZxcjo2br+jHhAk577FurjV4g4CwiDoFPkk
         i75oq1BEEvEgT1UZ2B7QNbJCPaERO6qa7xnYzPdO9CqhwgCgxWHDa3gqw5rnMHUhnLHB
         QtBXkZArjmcUx3k+J/HBc1FdTxWfE3MPilHB6goOH15VWVLLw986sNAobWzhJcIUcU2X
         m3Nw==
X-Forwarded-Encrypted: i=1; AJvYcCXOms4u4q2cpKSQfEJ/5eD2QkDxvcpuVRabahWeqqK+/j8m1kRp0QREI+uCVf2ZxpiMmA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwD1kLhilGaS/SdzoEmbfOMa0FiRB2bTbSYejpJjECBhPhSBc1X
	kfT3HdpTN6KGoshJOhGNlR3z4NAkIET7sbTLOxFFGjUynqFccjXw7sgBGM7b6FYyufxr2HyFQE2
	vnieSML2pAWPSwgOjJgcK7NyhwAij45oXcOI11Uhj
X-Gm-Gg: ASbGncsWwVK4083uhczbPdw59DyOJw+hCDAwruyhMmiEqxDF+vUivQ+Mw1ptWJGc1p6
	VOMgJQttpIW+XgKDIofiPQezx32IZ6+pHW5vV5X/EHOdzeFGYyP0MB53/qleDXJqlOkSBjyB9ZF
	+uJZBBS2Yuwpkl8VNfDbUuWVoHW+a82x/ykJ0em06+QKQ=
X-Google-Smtp-Source: AGHT+IGyz5q0RhPpn/ScF6uUOqoExc8ghpVJZBd8nzvZju8riiCqw0LWDRBGrMxS92sf/w55QchtXypcuYtqc+wZVE0=
X-Received: by 2002:a05:6512:3503:b0:553:2308:1ac5 with SMTP id
 2adb3069b0e04-5550c2bfcc3mr1620682e87.4.1751065709349; Fri, 27 Jun 2025
 16:08:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com> <20250620232031.2705638-4-dmatlack@google.com>
 <fe4b1d31-e910-40a1-ab83-d9fd936d1493@amd.com> <4aef95a0-a0de-4bd5-b4ec-5289f0bc0ab1@amd.com>
 <CALzav=fZcLpQ+9J=XOZ-=Cr1UA8qKa5NHXB1dJpqhCp7pee7Ow@mail.gmail.com> <62734f4d-8883-4145-a483-5bf2c462fad5@amd.com>
In-Reply-To: <62734f4d-8883-4145-a483-5bf2c462fad5@amd.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Jun 2025 16:08:02 -0700
X-Gm-Features: Ac12FXyTcrgDJdVB_77mHHx-sYwBV57IJqE7J_O2KVHhqynIMx5PWakjwvLcb0w
Message-ID: <CALzav=eYD85ydnpAwYsTArDHbxOLd+D-BtYWaiYQxeJ1tGGp7A@mail.gmail.com>
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
	Wei Yang <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>, 
	Santosh Shukla <santosh.shukla@amd.com>, Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025 at 9:57=E2=80=AFPM Sairaj Kodilkar <sarunkod@amd.com> =
wrote:
>
>
>
> On 6/26/2025 9:59 PM, David Matlack wrote:
> > On Thu, Jun 26, 2025 at 4:44=E2=80=AFAM Sairaj Kodilkar <sarunkod@amd.c=
om> wrote:
> >> On 6/26/2025 4:57 PM, Sairaj Kodilkar wrote:
> >>> On 6/21/2025 4:50 AM, David Matlack wrote:
> >>>> +/*
> >>>> + * Limit the number of MSIs enabled/disabled by the test regardless
> >>>> of the
> >>>> + * number of MSIs the device itself supports, e.g. to avoid hitting
> >>>> IRTE limits.
> >>>> + */
> >>>> +#define MAX_TEST_MSI 16U
> >>>> +
> >>>
> >>> Now that AMD IOMMU supports upto 2048 IRTEs per device, I wonder if w=
e
> >>> can include a test with max MSIs 2048.
> >
> > That sounds worth doing. I originally added this because I was hitting
> > IRTE limits on an Intel host and a ~6.6 kernel.
> >
> > Is there some way the test can detect from userspace that the IOMMU
> > supports 2048 IRTEs that we could key off to decide what value of
> > MAX_TEST_MSI to use?
> >
>
> The feature is published to userspace through
>
> $ cat /sys/class/iommu/ivhd0/amd-iommu/features
> 25bf732fa2295afe:53d
>
> The output is in format "efr1:efr2". The Bit 9-8 of efr2 shows the
> support for 2048 interrupts (efr2 & 0x300).
>
> Please refer 3.4.13 Extended Feature 2 Register of IOMMU specs [1] for
> more details.
>
> [1]
> https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/spec=
ifications/48882_IOMMU.pdf
>
> Note that, when device is behind PCIe-PCI bridge the IOMMU may hit IRTE
> limit early as multiple devices share same IRTE table. (But this is a
> corner case and I doubt that 2K capable device is kept behind the
> bridge).

Thanks. We could definitely read that and allow up to 2048 MSIs in
this test. Would you be ok if we defer that to a future commit though?
This series is already quite big :)

>
> >>>> +
> >>>> +    vfio_pci_dma_map(self->device, iova, size, mem);
> >>>> +    printf("Mapped HVA %p (size 0x%lx) at IOVA 0x%lx\n", mem, size,
> >>>> iova);
> >>>> +    vfio_pci_dma_unmap(self->device, iova, size);
> >>>
> >>>
> >>> I am slightly confused here. Because You are having an assert on munm=
ap
> >>> and not on any of the vfio_pci_dma_(map/unmap). This test case is not
> >>> testing VFIO.
> >>
> >> I missed to see ioctl_assert. Please ignore this :) Sorry about that.
> >
> > No worries, it's not very obvious :)
> >
> > vfio_pci_dma_map() and vfio_pci_dma_unmap() both return void right now
> > and perform internal asserts since all current users of those
> > functions want to assert success.
> >
> > If and when we have a use-case to assert that map or unmap fails
> > (which I think we'll definitely have) we can add __vfio_pci_dma_map()
> > and __vfio_pci_dma_unmap() variants that return int instead of void.
>
> Yep we can. Another question, why do we need assert on mmunmap ? If
> mmunmap fails then its not really a fault of VFIO.

You're right, it's very unlikely (almost impossible) to be VFIO's
fault if munmap() fails. But it would be a sign of a bug in the test,
so it is still good to detect so we can fix it.

