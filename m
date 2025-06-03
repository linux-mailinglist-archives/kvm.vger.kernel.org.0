Return-Path: <kvm+bounces-48328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6489ACCC08
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 19:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 273CE1746AF
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E554C1EF094;
	Tue,  3 Jun 2025 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UfFT8bG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7EE1E493C
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 17:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748971479; cv=none; b=YOLosU5zL6Indzfb/fjmjKyJuyFVl1y4+U3ircKDk4ynakgq7PNx+nMD6OgOYzoEPkSBW4ZkFIf1zNDVuWTMQxZQgBBDQd6FY3IPP/AUttO21b+AgAD6tY7bvMHHLX7CZDJFD3HzgctEAuNLUJOPHuLRzyS2pCkbOv5n2KOpwRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748971479; c=relaxed/simple;
	bh=ySsgpW5ka/uC6dRIJs+rY+QI0WpcQ4iz58g6inVPOIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rRTJlTSTQMkOHlLD/uiJI/PYzsmF2ulIvoDLluoUBjyLkwgoW4YOtcb2/pjz2FjwJsATI8r4TslpyXFQiKRtbow1yffVNf/71YbfptmSp+sGuHB79c+GunGwXB4qa9SdHHnN0n364OC6eN1lsqbCPQQ0QmZ8dTr6R6gP0GFd2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UfFT8bG8; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55342bca34eso3683669e87.2
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 10:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748971475; x=1749576275; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySsgpW5ka/uC6dRIJs+rY+QI0WpcQ4iz58g6inVPOIs=;
        b=UfFT8bG8aM6FWc2PaGXN/HuLVMNcAHVl/Brm8NN6gefLisImRUSCxdR1wvLa7gQqxQ
         bpo91M0QudHcdbOBWEwCJ7y87h5xdSu1mTcPdLP9OHNt+B1i4ElMRAyFAV0wvBV0qMI+
         9KkLZkOqmX21NizsC/bprRfKXCWZFZk3DPMiHBDVv2T192Vr5I4WIIJvdvjMBB6sc5qn
         gyIrMDQkTaFpzdwehLq6eVCbbcD/RWwtwcm0qVirJhSzlSD6/7fBlIBbBToXrbmMt6As
         8YhCCdoWNTORe0Sc4/p61Ln0vJLHUbjgN2dfO5Y1LhdT797DWjyEygrjUICMTGt6PqyA
         gnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748971475; x=1749576275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ySsgpW5ka/uC6dRIJs+rY+QI0WpcQ4iz58g6inVPOIs=;
        b=BWrfGokq2hzDV1gytJZR5auzQxam91gNZoAMurbKM51FJgQzbv5ufzRjG+xu5wsW1B
         hC4SocIY7h3wkEs69uBqxDEcBrxntlQGZ1T4y5IAn4EkC8EJHgAY7cQH1Khor4snKp30
         qTURfCbeuE+OD5MVGBUpwzGsL78Q+m7j5v5/LnlRXjBpZYy9hg8fsdvjygjE+Kul2wy/
         jdHDL+YWZn5KNnO3LKW7enifjsKaNdK0tDSi6EtPBvX3W460jUEVLlP/C2c1aChyJ9lc
         8/aXOMUBpqM87txC8PPs89VTfAoulL0O9J9JoiXAb6EJ1rjpkG1NOXdLXIFiZ5g+UbLc
         mnNA==
X-Forwarded-Encrypted: i=1; AJvYcCWS+0vRJtYsdGiVZis2Za5/tf0zdR6OIuofkG8ls47gShfdxWtkgD5AuYX0sgfyaW2coOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBGuYG1LJUT93EzZYICuydzw2O7wROc5IH9hAf4MVruhK97ugU
	DS8pxWbGWEJetPRivMlkLQHGZcymS9/OCRaudmm1T6edQaPw9cfpplvcG565VNKFQKTlM9n3yOL
	OwmQLhcDhDEnDGdyIwtllR30qqekPy0SXj40k/m8l
X-Gm-Gg: ASbGncuUkJhpKvkkUnfrxLa0Zx/BcELPz8l9UKdxb9kfMZEFMR7dm55R25QBqCansvj
	FaGReBabEk2rNt/gyuvjhJY1dRUMQ0AyEvUr2feMJnDqAGL7+s0HhtZhZRr8nKQe0zAkZtochaz
	irGgu36EHnORa6KfO3N4G1x6+C7OP8xDoK7dvzbn8nfDM=
X-Google-Smtp-Source: AGHT+IGrMMtGkdwf5JFNF3Pzrh11cbTBjeZpSmZE+gwi0dsa2Rbm8adxEWaqRd2fU8o5CMygeQfW3lDSweb5vjibyTw=
X-Received: by 2002:a05:6512:e8c:b0:553:2bf7:77ac with SMTP id
 2adb3069b0e04-55343183569mr3841340e87.41.1748971475200; Tue, 03 Jun 2025
 10:24:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com> <20250523233018.1702151-30-dmatlack@google.com>
 <20250526172039.GH61950@nvidia.com>
In-Reply-To: <20250526172039.GH61950@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 3 Jun 2025 10:24:07 -0700
X-Gm-Features: AX0GCFsT8ASeM00SMYLu9sA_EQ60DLN9ZK5pbEBMXX7-pMY3zMiIYBr_tLlerds
Message-ID: <CALzav=c+AecGwy-K2_g8+toZRkSkCocWNLj8dBLQVHhBJaQBXg@mail.gmail.com>
Subject: Re: [RFC PATCH 29/33] vfio: selftests: Make iommufd the default iommu_mode
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 10:20=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Fri, May 23, 2025 at 11:30:14PM +0000, David Matlack wrote:
> > Now that VFIO selftests support iommufd, make it the default mode.
> > IOMMUFD is the successor to VFIO_TYPE1{,v2}_IOMMU and all new features
> > are being added there, so it's a slightly better fit as the default
> > mode.
>
> As before, the tests should run through all combinations on their own,
> use a fixture.

Ack, I'll rework the series so that tests automatically run
through all IOMMU modes.

> It would be much better to fix the kselftests so you could regex
> select the tests to run and use that as the commandline way to choose
> what test combination to use.

