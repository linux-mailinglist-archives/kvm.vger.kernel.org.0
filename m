Return-Path: <kvm+bounces-67077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A2DCF5669
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 20:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC87530BC49C
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 19:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37683320A2C;
	Mon,  5 Jan 2026 19:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ajbg0yk0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9FE30F921
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767641827; cv=none; b=HhAALwG3IuzQyuYvZGWtVSziwLY7hSSkRL692pKhj/9bzSH0VIb25pz2zxZ0cA+kKFcu6zOgLlnnwxvjT8kVxMMZdjke/ke1W5raJQoej9ubOSS6Ta7K1vUk6PKp04TVYxKHKPmwSdtHdz/sxi1WIwHgcdf3hZo82WfDRzHya0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767641827; c=relaxed/simple;
	bh=31nHIbc+OoEch6rFi62gumFXT6IIRy4ioDA3iDcRDZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sPtdNUc6I5X51khqVFVGXPChFHDNSorESkHfcqruRctk9es84ZuN9ni6Ko7u8kOgu1PyPFWUF1vDt42Qn+vhAG4jHloPu5YlKB2kvFIv6JbEHZKaXB07KgwV1ClFjvQz7ziWDyJs6vkEn/0EcHBgz80fL967OyfdlU/QkAHmDAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ajbg0yk0; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-93f500ee7b8so131629241.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 11:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767641824; x=1768246624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31nHIbc+OoEch6rFi62gumFXT6IIRy4ioDA3iDcRDZU=;
        b=Ajbg0yk0iCH+eMrDb9WtbFJuUFosK/ByW25rNVSSJKGvD3ZVUQKlYkHlmfOuq4WoSB
         EBdw+4BlpbNX8Sa5nR1SHTctrpiLlt2UWuO4usmPQpJ0BozsHEH328xGLpogUZeShmoe
         CiYWGtGV1Wju/VQP72mzzSNk6qoaZjlFMQ9jzgEt+95ROM5jkuQ9fE22znhkN/MpCwqy
         jLUMIkY2WMUmokMIbRDc8q7nApi0S90nOg+NzaKvDlaK329doGOHqqF1mILXvIlO6Se0
         +rkPaUnUJfpnPFIiScERaXvmw+wy2vo4W1H/iz8LVOXxmRI72eljpsbRV8T/sZds6qcn
         JX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767641824; x=1768246624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=31nHIbc+OoEch6rFi62gumFXT6IIRy4ioDA3iDcRDZU=;
        b=GdkaCh0xsAq9pHUfLXe9RRCKfcwh5JfeXgOgQNwB49cmqm2Nnnt8esEMC/lETTlWbq
         Z8uX5T61ZNlMGpfhB890ql8suHrth7JvkNsIr7AiCOZBagjPe4Snn3gONc5Ooz4IxGot
         OTyUyiWM7Pz0wESLV2egWAFHU0NeVvgHYD9Fq7i9KyO7SzWgOvy0k/Vxl+fu69DI6I7y
         yZcczTieIaiHLRoDSew28xc1viY5V5DdizneJZrf+9x0xbTsC7guQF9G69POCVcwSBN5
         aosqrPmbhpPibhn9pgZBYoQwxov/OoYbW7SNiW0qphSWD9pc+fk18dQOpzA2cL8yn04C
         hKzg==
X-Forwarded-Encrypted: i=1; AJvYcCXcC8+E5hPXfj1MO7PQBgDI5Ba5pl+G26PYU1cqmpq+VIxW0z8O69XYI7TjuMjzdpoZuks=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbgUX3kXrySDiInhSOerZ+TGnDKIFEyIoH/yMi75Oo+Ya6jNiw
	njzNxldIJ27fj5tQTtT6pYurMSrUtPtv2lQyDuuHd9zfYj6vmWj+yXJWrI1ZzoTSzO6hRC6eqnd
	9/I7ngb/Us42Dbqyfpq0p101IQ4lIL5HqvTPkixOP
X-Gm-Gg: AY/fxX5w+m3lIDDjpbkRZFgTOqWej/Y/6Gbb74Xf/3PvpOYlmZ8NEM2XujVwRf1+YWq
	c6xtvkPEUm+E0oTq/cUYM4D/MqM/7HBabRSEnVa/PMfwBSRLXCbvRSr0TV0nflxMLWhcVMEGRT/
	ExA1KCgvb3M+ytNK1RrkZ/89j0fYIkJvEL9LSHTenJKZk2Z/VJ6r2Q+iEdG9IbETICeevZbROQg
	mPKD9PvZgYO/AALsi8CuqPXNw1f2g2P30WXgkBhLCBH3bcw3bC8QKjf3wXs6/BRhvqdUC2g
X-Google-Smtp-Source: AGHT+IFLLXIahWuru+z9SkpMRM3sHLVo7NrlH1Mjxow1zn4qQrZcpS4x0MJzKxLtwOeRaJ4ixsEbZXL/xv5IJXhF0EQ=
X-Received: by 2002:a05:6102:3e10:b0:5db:f15a:5394 with SMTP id
 ada2fe7eead31-5ec74326090mr212110137.2.1767641824437; Mon, 05 Jan 2026
 11:37:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223230044.2617028-1-aaronlewis@google.com>
 <20251223230044.2617028-2-aaronlewis@google.com> <aUtLrp2smpXZPpBO@nvidia.com>
 <CAAAPnDEcAGEBexGfC92pS=t9iYQRJFyFE9yPUU916T92Y465qw@mail.gmail.com>
 <20251230011241.GA23056@nvidia.com> <CALzav=c32W4d=_WtXHWDmjfQaJDyzdxWXS9_kVHvseUsqh=+NQ@mail.gmail.com>
 <20260105190121.GA193546@nvidia.com>
In-Reply-To: <20260105190121.GA193546@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 5 Jan 2026 11:36:35 -0800
X-Gm-Features: AQt7F2oAzGnd0K3oFWLzaZanmBHR9s1V9aE6-qPsev1LczAfV192OhZzVW2VFWM
Message-ID: <CALzav=eR=mu1VzA4YnWqR2Yi7pYCjN7krYQ3TdwqcCKuXSgDHA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] vfio: Improve DMA mapping performance for huge pages
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Aaron Lewis <aaronlewis@google.com>, alex.williamson@redhat.com, kvm@vger.kernel.org, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 11:01=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Mon, Jan 05, 2026 at 10:31:14AM -0800, David Matlack wrote:
>
> > Ack on the feedback that this is not a general solution and we should
> > switch to iommufd with memfd pinning for our use-case. But I think
> > Google will need to carry an optimization locally to type1 until we
> > can make that switch to meet our goals.
> >
> > For HugeTLB mappings specifically, can it be assumed the VMA contains
> > the entire folio? I'm wondering what is the safest way to achieve
> > performance close to what Aaron achieved in his patch in type1 for
> > HugeTLB and DevDAX. (Not for upstream, just internally.)
>
> If you are certain the address range in question is a single VMA and
> that VMA is one of the special memfd-like types then you should be
> able to do that.
>
> The issue here is that VFIO doesn't have any idea about VMAs and
> pin_user_pages_fast() doesn't check them. So you need to give up
> pin_user_pages_fast() and have vfio code bound the work to actual VMAs
> under a lock with the table read to make this solution work fully
> properly.

If the page returned by pin_user_pages_fast() is PageHuge(), then I
think VFIO can assume that the folio is within a single VMA? HugeTLB
does not support mmap() smaller than the huge page size.

Userspace could of course slice the HugeTLB page in
VFIO_IOMMU_MAP_DMA, but that's easy to check for in VFIO.

> Of course for your very special use case the VMM isn't creating sliced
> up VMAs and trying to attack the kernel with them so the simple
> solution here is workable with VMM co-operation. (though it opens a
> sort of security problem of course)

For DevDAX we might have to go down a path like this... or add
restrictions to mmap() similar to HugeTLB.

> But I wouldn't want to see such hackery in upstream.

Ack, we'll keep the type1 code to ourselves :). Thanks for your help though=
.

