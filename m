Return-Path: <kvm+bounces-53591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C8F5B1456C
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 02:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EDD27A8D83
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 00:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863EC16A94A;
	Tue, 29 Jul 2025 00:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DQ9vDLdS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D0036D
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 00:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753749950; cv=none; b=uXg8mf2gur80xdQkWKM8eiPfQVnFXpWh8VBRCcatunyYRT0GIqkumeVuj1+3A4+NJ5oGJ/NZhrv86PHpLWEBFT68VH4PLQdKDFQDaA0zA+pFgVqSiZi+u/1KpF/aP+0x5/39amN61M44fPqe0vUOcY16ksb2siaE7ZtpNgs9R6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753749950; c=relaxed/simple;
	bh=FVSgAjQsW2yVB/WUuYNhzHj0Wawpo/yDfI5diEgBqw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oO0B8z++wOJUwZNe6Zw5wIK0UkkUWVOply8F5YUKD5AVES+gmXKRk4oA36mI989iYERiVTaCB2r/s0UGwq2RWGTGpT5yzGIAa7And0Td/HjgGcZgft8tmBtQAinFfihSLTP0GoLS/ewKGJePJiTil1zFV1/RJisrPHVUoVkm9B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DQ9vDLdS; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24070ef9e2eso14655ad.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 17:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753749948; x=1754354748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=idV8jxKaJjGQpa1nXW+ddy6nKIpibOa5A25bwcsUkww=;
        b=DQ9vDLdS7cGngSsKoxmlqs+l6FmI/QmuUUJI2UIy2TFdC/EBkFUMrIJbIHp8d7+Uaa
         Xcj0639chEpR5JKew7LnJSQuX5lO4zy6uviS0cD1Qxxiw3IWji8uzEd4oQXMOLFQqLT/
         jFTR1ZhODZG9WpHKoeRVL2IrRW3lFW485Yc5llEJ5ydjZMhA3spLxd/GD0if9+FyLYG9
         9UDMUArI1MPz+Of5ADzjQN9sSSdRHE8NzDnHHrGBy5NddmskddouHC+HW6yVy4u1kGdv
         vtdIWVC1XNxLXQYjqeJBuv9agKYj9NdhkluS+4I5xqpTUaq/Hso1N+cbzc92MOAWbTjZ
         6SUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753749948; x=1754354748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=idV8jxKaJjGQpa1nXW+ddy6nKIpibOa5A25bwcsUkww=;
        b=Woi4jyGDg/8lJEVTN2UzTgQNJLcJbGbiCSR4hbNrbU7Lq2/6JxageAs9myiiD0HcIm
         s7+KY2RBnyCygt2w28961nCQbBMDM9BddUPiRsmZEqNtPP5KTdvRdWIWWoDcDrM8Y5BY
         E65I8wbQcWi0dKLArCCDM5CZEN8LFguH68QrY9m7Vawf8Tx//GtNZJDFRKhEgUSOtAXx
         Ubabys9aCIOUxdTldjFEZSbi2k7zxtnZL4vtJXr/aBDL+1FZuoC0GZvsF1Wlml+Be3Wr
         XesQjjhHD/iDFt6u2LfqxKCV0hmSd9RXAziNMUoeRWN51EGrAei+9RVnsCM4sz4WvIby
         woUA==
X-Forwarded-Encrypted: i=1; AJvYcCXZFX14e0vAvThNeR+UOHQgR6f8NGfUet+Y2OBzkVtUP6FStQADHOisgRUO7p4sT6cfE0M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKCGD38Al/lyO2rLMMqEnOrfPykwneBzx1o5IGDZzbLrUcbBPL
	P5r1Oejh74AOqUXsJ4fQhOyRhWb0LzkEgpjxtqkJWtfQz8+jC7ArMlD80PQ68AHenc47pAyM3AB
	rV+sEofQetDcJFLr4YesdFHjpJNsnZiC6TrTMDchv
X-Gm-Gg: ASbGncsGv9QM7MJOz7Jm7XdO/01M0Wek0ehlxcSCF7lf8xib4Mw8nK2IEXjeyGzIM20
	QmlbdGQALXBrgjUg74tjiRLfUQXMdKwdBHKtyAt/yKf2a+GaLfnGutdzFcARj/Ml+OESGDDBqUc
	VKQ7ArNU94O86C4iDfCbSdM7hAXWjW5nZ714x5QWw6A9NLsjJIQeEGBcSeauBImNCkfrSgfNz7H
	r1E36Fj75aOwASoJovH2fC7Mtr90w9g7wsDhw==
X-Google-Smtp-Source: AGHT+IHE7l3xX6sUV12T493CHFe/Ja1/xSMoi9Loe1WMOuwZttzm73nQI30sKftDFqPiytNd9d2Q9GVFXqa1ViJGHqg=
X-Received: by 2002:a17:902:d4c5:b0:240:6076:20cd with SMTP id
 d9443c01a7336-2406e89d0c7mr779305ad.15.1753749947893; Mon, 28 Jul 2025
 17:45:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709232103.zwmufocd3l7sqk7y@amd.com> <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk> <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com> <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com> <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com> <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com>
In-Reply-To: <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 28 Jul 2025 17:45:35 -0700
X-Gm-Features: Ac12FXwKOgddUPpS3-HKtqI2MRpTg7acm9VtOQG375Esp2PTHAb8ATUIbEWumlM
Message-ID: <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, ira.weiny@intel.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 2:49=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Fri, Jul 18, 2025 at 08:57:10AM -0700, Vishal Annapurve wrote:
> > On Fri, Jul 18, 2025 at 2:15=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > >
> > > On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > > > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote=
:
> > > > > > >         folio =3D __kvm_gmem_get_pfn(file, slot, index, &pfn,=
 &is_prepared, &max_order);
> > > > > > If max_order > 0 is returned, the next invocation of __kvm_gmem=
_populate() for
> > > > > > GFN+1 will return is_prepared =3D=3D true.
> > > > >
> > > > > I don't see any reason to try and make the current code truly wor=
k with hugepages.
> > > > > Unless I've misundertood where we stand, the correctness of hugep=
age support is
> > > > Hmm. I thought your stand was to address the AB-BA lock issue which=
 will be
> > > > introduced by huge pages, so you moved the get_user_pages() from ve=
ndor code to
> > > > the common code in guest_memfd :)
> > > >
> > > > > going to depend heavily on the implementation for preparedness.  =
I.e. trying to
> > > > > make this all work with per-folio granulartiy just isn't possible=
, no?
> > > > Ah. I understand now. You mean the right implementation of __kvm_gm=
em_get_pfn()
> > > > should return is_prepared at 4KB granularity rather than per-folio =
granularity.
> > > >
> > > > So, huge pages still has dependency on the implementation for prepa=
redness.
> > > Looks with [3], is_prepared will not be checked in kvm_gmem_populate(=
).
> > >
> > > > Will you post code [1][2] to fix non-hugepages first? Or can I pull=
 them to use
> > > > as prerequisites for TDX huge page v2?
> > > So, maybe I can use [1][2][3] as the base.
> > >
> > > > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > > > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
>
> From the PUCK, looks Sean said he'll post [1][2] for 6.18 and Michael wil=
l post
> [3] soon.
>
> hi, Sean, is this understanding correct?
>
> > IMO, unless there is any objection to [1], it's un-necessary to
> > maintain kvm_gmem_populate for any arch (even for SNP). All the
> > initial memory population logic needs is the stable pfn for a given
> > gfn, which ideally should be available using the standard mechanisms
> > such as EPT/NPT page table walk within a read KVM mmu lock (This patch
> > already demonstrates it to be working).
> >
> > It will be hard to clean-up this logic once we have all the
> > architectures using this path.
> >
> > [1] https://lore.kernel.org/lkml/CAGtprH8+x5Z=3DtPz=3DNcrQM6Dor2AYBu3ji=
Zdo+Lg4NqAk0pUJ3w@mail.gmail.com/
> IIUC, the suggestion in the link is to abandon kvm_gmem_populate().
> For TDX, it means adopting the approach in this RFC patch, right?

Yes, IMO this RFC is following the right approach as posted.

>
> > > [3] https://lore.kernel.org/lkml/20250613005400.3694904-2-michael.rot=
h@amd.com,

