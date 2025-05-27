Return-Path: <kvm+bounces-47832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3EEAC5DA0
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 01:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E79801BA43EC
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 23:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B550C218AB0;
	Tue, 27 May 2025 23:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WrDFKAa8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284E61DF247
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748387484; cv=none; b=E/33U9NvHOiCUmKdBiBMi0J0CrF/DMcJtlCver2ZY4n45efXOxN2Fe5YFqnUpg9LlQUsIDRoI3XfW+TJh/aiiBkhbzouqy9WCWxgG/rDIcUVZbFEbra6Mx6lf9R9bNp8GY939mcPk1opmjZCFE0wBzRcZX6Vbaazx/TZYndXm5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748387484; c=relaxed/simple;
	bh=wWohLDGmT8iJUd0Xc26xp5rrOi36srxot9x4n4vpflA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q87bbqn/4QgaBHfZDgbgJLz7BUGaqYTtVKE2nK2J8IsJk4glSa4GFqA7wYv+ZXGblBXi/U5NssFyKprIh2S61NrmMAiMVFKoQjmz1OmL1Enc+hfcyJaM8G3Vl/0o0+I4AA+e55LuEUnAoQlhu6gwIT2HpngACZy8jXkjv2gOkIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WrDFKAa8; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5532a30ac45so368214e87.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 16:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748387481; x=1748992281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3LwtnDMt6Fa1alafGForXCbUPJ0sUq88edMBKwK9gLs=;
        b=WrDFKAa8kjX40wZ99cXYk8PW4rfSd6ktyUCXFuNeu1WaUe1AV/9+wZbQ34tWembgY3
         vnxcYSZ7Kvw+kh9+RlvwZtMmTRcw0FO3owrKsqAzPeIeCLgqSlCReaWOZ4ZGPy876l/k
         LpwgxfM3b19piGY841D0sa2UdK0lapr31+FSAQehUWzIm/9mH4HAD9iN1G3ZSAB7Qw/Q
         zMVMkwC/gfa0rbG9sU0advqy8TVT2rKN6lCnY/SI30SIIXz3Y2pe2/eNgUYoUZ4yk/Jl
         PqWimuxgQoPLnKyzh+yYk7ncdNdFesq7AqqH5B/Iy68KQ5VUSBPHf5Sg6wUnogfIbnJB
         WVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748387481; x=1748992281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3LwtnDMt6Fa1alafGForXCbUPJ0sUq88edMBKwK9gLs=;
        b=cWZH6UNERTkn+Oi4WlfqeCFWHkkxaEMWZy6xFp7dSiheLEj8NX4JX5r7bNngMuumCL
         5QrhjvSWxB4vDCIqhhP4pV5N7wBUTfhoQE65xNyFCg5I6EML5jtyWc/brdHLAmMPB0gt
         41kNRmxy64Txvl6ay0qbSqcuP1PMLPmWXBrP9AvgOaLln/LQICAflwuUexuQDKQyT65l
         vTYeL/0NXxxAdn+iJ1oBjg8/XFokKWioVDNaBpClCIee+lHE5i1U5o5/vDIRgTWU6Huz
         sNxt5ztm5Ke0iIo5PH7/G2qniEWiuoNQUpsjWO+/+o1TX9lC3WdqjsompdrkC1/dhdut
         LKjA==
X-Forwarded-Encrypted: i=1; AJvYcCWN3/Xb3bWeb4iNgZDDRbBH+L/VrkTc/ybGgVMT3le/TjDZ3JKEQfpWM4SKK9LTt0RCzBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlrI7FcJY+DhMc28tbj4XECZR5v6PSbJP7CzbMyvj9VY6rurJk
	GYpesqOzTozxw70P4bm2RJkhE2SrAhOyGeNmnNyyOhtgOzhqAVVydUBdOZxEpTNlYKmKxilU6GG
	5jk+9R/RswWVCS5ajo0Cy3Vcm0ACcQ0PxMRkcDNv7
X-Gm-Gg: ASbGncvwxnPm9kyEPsTuXkudFQOCmS9OXohCvkCxz92XI1cz8o/eZQF9k6Zut4MSsB6
	VBenqppNdIYIC1ZPATtVyoWE/aNYKMO1zr7NZCMqsmYrSVORedeADZqufHI1B8v7fwjUTaaQtsD
	P2EN0pAnE8Hdsd0iSPRqJXCo9GK89/NTxHMwivVC7FByc=
X-Google-Smtp-Source: AGHT+IHiXsqnruv/2rB00gwLR+xOmcmEFuqjHd7uPpNdbi2GcXiMOFNAkhyqO8xulbQpe4o3eG2qHobAXmAjXHLMCEg=
X-Received: by 2002:a05:6512:4029:b0:550:e2ac:6550 with SMTP id
 2adb3069b0e04-5532cda83eemr832185e87.1.1748387480868; Tue, 27 May 2025
 16:11:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com> <20250523233018.1702151-14-dmatlack@google.com>
 <20250526171814.GG61950@nvidia.com>
In-Reply-To: <20250526171814.GG61950@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 27 May 2025 16:10:52 -0700
X-Gm-Features: AX0GCFuq1Bp_bfOZNEFj00D44j62fe4QgatxulQExjKGj6yYBs6S8vB306_IUqA
Message-ID: <CALzav=fqcgXLmp0Jo=CQ1YgaLxhRCk_JGMde2+t7vTX7rLrSKg@mail.gmail.com>
Subject: Re: [RFC PATCH 13/33] tools headers: Import drivers/dma/ioat/{hw.h,registers.h}
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

On Mon, May 26, 2025 at 10:18=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Fri, May 23, 2025 at 11:29:58PM +0000, David Matlack wrote:
> > Import drivers/dma/ioat/{hw.h,registers.h} into tools/include/ so that
> > they can be used in VFIO selftests to interact with Intel CBDMA devices=
.
> >
> > Changes made when importing:
> >  - Drop system_has_dca_enabled() prototype from hw.h
> >
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  tools/include/drivers/dma/ioat/hw.h        | 270 +++++++++++++++++++++
> >  tools/include/drivers/dma/ioat/registers.h | 251 +++++++++++++++++++
> >  2 files changed, 521 insertions(+)
> >  create mode 100644 tools/include/drivers/dma/ioat/hw.h
> >  create mode 100644 tools/include/drivers/dma/ioat/registers.h
>
> I think you'd be better to not duplicate the code but just #include a
> shared header from  drivers/dma/ioat/ and so on for the other patches
> too

I think that makes sense for drivers/ headers and maybe
linux/pci_ids.h if the relevant maintainers are ok with it. The
changes needed to the headers in the kernel would be pretty minimal.

But it starts to get complicated when kernel headers include other
kernel headers, and/or contain a lot of code that can't be compiled in
tools/, e.g. asm-generic/io.h [1]. For those headers, duplicating
seemed like the cleanest option.

[1] https://lore.kernel.org/kvm/20250523233018.1702151-11-dmatlack@google.c=
om/

