Return-Path: <kvm+bounces-55014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E62CCB2C9D3
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 826301685FF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D8BF27586E;
	Tue, 19 Aug 2025 16:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WvKIlnsK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2AE25A626
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755621121; cv=none; b=HRghiKBfovfq2xWXDNOg96r/Zc7j57IIE1Wse9svi/26Jy1VRSgMfO4ajoCDK3Rd7zLyA198Yk+uFCBIBMmEKvxCJ/62LIELYrm1sBjcc91j0eEOaKbWaVPf0ATwX3YU05ViKZP1z8a+4Uc/YrK3gdmsHbRTH0+1w+4b77CyZe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755621121; c=relaxed/simple;
	bh=cJyL4HFGFISuvEGZWUWistyHRtKUWIye98ZZtuZrwNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VlgcPogKeZzP25igU9BC/U5SR7faJURKQU9l8W4GgVWjAQzls3Xg5n+kb1hxW+qvV62Z7hVdaCOeQ9T8zVUSYNQs0u7fcPdjWHJFz4Zxm4k1rdV9jqXftNaSXILyrcEwrUQnEnC+aMPt4pbt527kujdg3FfdZ2GtORs8RAy0MN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WvKIlnsK; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55ce5247da6so5802327e87.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755621118; x=1756225918; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uid2sLCe2fLbFbHk5A3JRr3795+bhaHijptEMore4t0=;
        b=WvKIlnsKDIffGsQDSkmbohpZGknofn6riVzl3zEzFv8NvPq2Z/vdF2b/wvXrV4RCwZ
         ooWTpRnS6qyCnzCfeMJXEnQMF8ri2TmRPvr3VL+/88IVSWQ9g5ri9vUxIp/9h/HXcvLg
         43EPHuWaeXIlCf7ie+9mzV45UMo6jkXO5mQ+rA3RE1GI8TaYzs3yqr+D0L2BKEhHpSIG
         tMSzsbJfoH0+db2cowunZ9Ci0uGIuGwGYbnA0f4sbCdtu9veWH25/xytpKMoZRFNWzgn
         yUhEGLqMm2fUGavjn2G8YOEpVB0FKMRpmjCfUHCEC6IOdeDy/6pS1+P10tO9pgv0JSWr
         K70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755621118; x=1756225918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uid2sLCe2fLbFbHk5A3JRr3795+bhaHijptEMore4t0=;
        b=vNXgpDxjSsfYQ3ZQdnqBYKbEsf5NdHOz/ywCZyN9ntZX5i4V01T/KMzBXOm/UsfPnT
         2u7kDkfbJGHVxbKAGOZQU+jwkaTAHmndh0OGDrKafivqAkwMaqSWh/tPImYG2Ix2+aT+
         VZRtBD/A75x2zErZmDbY7Lc6L5vNNoI9uIcJoDubwY0HZj2FF955cRrXY69B8wG+lfo4
         X9hcD+FkaS41tT8qk2oXDNrTu5LftoUwyszng+e3gAdew3psUmt4wUmkPdnton/hpnKT
         AwZ745nqhZ12Tuo2cUmDB796RPPEubRE4YnYIZlAwS9HDpF3Bac7020DOQuoYAM5W0r1
         vdPA==
X-Forwarded-Encrypted: i=1; AJvYcCW44MTAKdUeD+RqNGDmDF3Qz+Knjr9treDPbRxHNJxyumWJNUmGeFLOnroKS8ORhkOrq8c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw//xtDL7cntCMqdDENRZYoqOYF2YGzkOpcahitZPt+As+6tk73
	jg3dBS77YTogFN5m7K3/qPOw6M9Qhbvu2Uw8At26V/J0nwRQ2HaGebxt9ytkBgz0ILw6f2DifoA
	fnZ812oBjxDsu7DApRGyDdwv0FZYzW8NUcsT7esKj
X-Gm-Gg: ASbGncsroGvFzPi5w5c1uC8dU6CuC9RvKUiCpmLIYX8jAiDX98VZMMZsKxgJPtSkMKw
	atsp/xJ4hniM37bO/vDjpR74cXaoYQ1i97TR6xYn7OFxeUZp3/xyJXzJ4iiD56Xkm/D0otRxLTF
	lIFEprbAE10uAjzZhdWyl7w7UD6B6+CuMLo7KEbwBRKxln2hRSE0lEzUGrtJeaVtShfSTCcmvma
	m8eluX5mDW6019u8kTzhDS2
X-Google-Smtp-Source: AGHT+IG9LSQukP8L1OyXcAwDvQvV6AZS3ttTz4sGM7WhcvGtXa2X9Lc5cAjEjuGQBLz/JBJDdtyLVwih19LLEtI26SQ=
X-Received: by 2002:a05:6512:1287:b0:553:2c01:ff44 with SMTP id
 2adb3069b0e04-55e00756893mr851298e87.2.1755621117683; Tue, 19 Aug 2025
 09:31:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com> <20250620232031.2705638-23-dmatlack@google.com>
 <87a53w2o65.fsf@intel.com>
In-Reply-To: <87a53w2o65.fsf@intel.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 19 Aug 2025 09:31:30 -0700
X-Gm-Features: Ac12FXya_SwncPtupiaWHc47GwUOexOFH1Y3z4fRmAiEPe7hf7t_7YyPUGq3HJs
Message-ID: <CALzav=dPRfPxNAaVvbxSNz=Ss0DAGjxJQO2JnXLbZgwZmO0NBQ@mail.gmail.com>
Subject: Re: [PATCH 22/33] vfio: selftests: Add driver for Intel DSA
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
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
	Vipin Sharma <vipinsh@google.com>, Wei Yang <richard.weiyang@gmail.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 4:41=E2=80=AFPM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
> David Matlack <dmatlack@google.com> writes:
> > +
> > +static int dsa_probe(struct vfio_pci_device *device)
> > +{
> > +     if (!vfio_pci_device_match(device, PCI_VENDOR_ID_INTEL,
> > +                                PCI_DEVICE_ID_INTEL_DSA_SPR0))
>
> What are you thinking about adding support for multiple device ids?

I haven't given it much thought yet. But we could definitely support
fancier device matching (e.g. multiple acceptable device ids) if/when
a use-case for that arises.

> > +static int dsa_completion_wait(struct vfio_pci_device *device,
> > +                            struct dsa_completion_record *completion)
> > +{
> > +     u8 status;
> > +
> > +     for (;;) {
> > +             dsa_check_sw_err(device);
> > +
> > +             status =3D READ_ONCE(completion->status);
> > +             if (status)
> > +                     break;
> > +
> > +             usleep(1000);
>
> Another minor/thing to think about: using umonitor/umwait.

Thanks for the tip, I hadn't considered that. But I think for this
driver, keeping things as simple as possible is best. This code is
only used for testing so I don't think we care enough about efficiency
to justify using unmonitor/umwait here.

