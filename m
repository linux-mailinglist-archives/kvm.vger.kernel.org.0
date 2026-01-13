Return-Path: <kvm+bounces-67958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B63D1A66E
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:50:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8805B3011985
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7506734DCFC;
	Tue, 13 Jan 2026 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z+DJ4Br7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6008E34CFCC
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768323045; cv=pass; b=EXWBMpBlci0jO8tKK1iZxtKzUYTxKs146aVqJ3RZQhB4rS2szuCCzi8r8NyIVpSsc1+3r2skuepSd0+FtWm1QA0Mmv2z/8y4dhA53Ri+nzQUT4DBrF68y46PjSJWEYvMwARplKQ2Kj1s3Z/tqttCgu7tqVX7idOA10dgsjb5gYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768323045; c=relaxed/simple;
	bh=HT2GOaDzp8BEGFcDqnXRCer52kKuMHtBAwckQWfI9/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NgOQj577btG325F4cYqXDq2zRAaqQJrqFSwKBRELNHwaAdLjICQUOojUR37sDIxm9t9fAGi99j6C0zXDo43Xr8rD9U3KEmTgxWF95UJ0j6QKzTI/UEE4ZwoGWHzagJgH7IrvsKrQZpy58rDGOkwDk7J5HDZ6ZOlABI4XcKijvGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z+DJ4Br7; arc=pass smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-11a247de834so9281c88.0
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 08:50:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768323043; cv=none;
        d=google.com; s=arc-20240605;
        b=bNZ9F0Wwe9nLZXFGcnbZdr/w/QAbntbGrqo9eBxlrt5mrUfzJ0Lh1+LQiq8GPgMwfX
         nVv7W3OqaRx9jbdn6O0cwz/4qVw620Xuj0c+h5FSw0ES6vTEsWBc/0JqNGwdoifaBSqa
         DzlIAMvzvW2P9UQz1cqH2lvAUlXaaXS6OefM0oHs7hUqsdoMk9u0Rg8fzp+JBgi3UHi0
         n63QseLdC1MbO1TGvXdUBp934lk/e1BDrIpPgGnD7K3WipuGhztVHoeW5+h69r46Nr0E
         ckpacwnFf8Z06KSEZ3Ubtmb2gmz+bBwPThAruJQzpBI1prd/EC1uOv/tjmt8eCWi1m5/
         2p5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ndWdK1kVtPq7SHdfUUwuM2BgCmtiLRR54Gv+PulJCUc=;
        fh=q2lNhXGyDHHx3I/MjIq49TVIAE1amL8TWFVRQe38gLI=;
        b=M3zLqwsDeY9wcnAizlDdXce7CRDNrjaom+k/xxZnZEjQmm3QThYA1g2t6Ra2fOwijK
         RDNeBCmFe3FAmvU8pWr+s3r8YNgJLT7e+ovMwfClmnsxAHZTRn9THtLRTi1Bj+Ye+Oac
         EDkmm/ADxqtJUedRslpo3vAqf9GwiM7WqpwiuoXSfxaEkXlYqj6SwWBLR1HRCgk0kqHD
         Lc1OugRMqc+Rn+4wa8MW4IzJXdUX40kt6tMNfPI1EvDicWd9ivoDhyL2oHE3DHBbBJM/
         6hcRKUdPo+0Stye+nc/dXnk6YzGPUStTgDerEkZ6rd3RHA2osntFRibPja3oLW9xHNuM
         Br+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768323043; x=1768927843; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ndWdK1kVtPq7SHdfUUwuM2BgCmtiLRR54Gv+PulJCUc=;
        b=Z+DJ4Br72qMEczdTzIq9MFM73U2GChXxVLIp5EsZ50TwhscJmr0E2/5OUJaprnd0AQ
         6Ls4lyMYbgRpujXtlR90u/CaUEROZSba0jJCGVSc36BU08mNTmEbQ4GixA3qdX0BGcQm
         n6ChIpWDZPzjPhq6wQ0MvWHK7BjdwWCilzJYroloZDeqiAxPJJFrxylzfzNlv3l7720N
         EYWx82iWwmNO/0D1qq9GneQ1zjDD9JWcbLwW8Gl3Of48xSQ5qQqqldqiIZUxJ0IWYZ9S
         5mZ4UFFOFYcTUgoMgznTtnf3nFHEK58HBI2Rz1jTZDE86Q2ckBAGEpDIzY2/uGHGrXeq
         vdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768323043; x=1768927843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ndWdK1kVtPq7SHdfUUwuM2BgCmtiLRR54Gv+PulJCUc=;
        b=bxbCM+1+dFDzQGYBK++6N0msldbUCVgKCKkTsrhNCqlSucXqUd+1xpMr9iT9x6Yr7j
         dpqrv3cWPJr7QcovxOBjiZpskXYqYBKDjbxIPSR0cFm3NR7iRZVtgVqczP+27XEtkEvZ
         7X+3D1VZXaNkP3fuJb36kDkrj4d38rzw7R8Ol7ML0aFrRViRNlOYq9M/BgbYWPlzJZL/
         Gj88SBpPECUXK7hmSsYPoA8rHkBZewH7/uL6eHUs+o7xr6ftcQ04ol0c0teQONIthZrG
         k6nuzkKrsAq33SRH8oSOEqVFDnh9R8DK9mULTMBADIOasP85CJnmc/qT5Cq4qPGPyeoe
         j2/g==
X-Forwarded-Encrypted: i=1; AJvYcCUa6sjIFdMjb+c6NaAY1LE7fuW//jLXfX9pO5sBU0Yy/1/xYXmP8Bdlf8bh7Ii3ChMmSp4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3/lSfBrXQUHndBHznP0H6FmB7JC8hyTEyR4kwC6eN45YBbU37
	SU3ittnc5SyPm8gjFGfLNhOTDLFZFzKLYZlVztyt/JAkV/RP5r9+xUduSoxNY0PYzOLBQmfmQ5c
	9Y6D0RurArBsuneEIetl6cg1mtjCA8l9sSgouk1K4
X-Gm-Gg: AY/fxX4kuIv7cggHIvlQ1crHz4iOwexYIyyja1ceApHXUJ3TiABLzzZsymp/AkmI9Gs
	5JrLpWzJ/1DfG9QyKbuZcOPL11t3V5sV7CgBrGRZKFdKph+UkVJrXEMMjvsZTDuyNzm/R6MfIct
	UAvL0GZ5AHlE0u73axFza76XSf+M5nSPcrJ3berCoqlY9LZnyDg/Ub2AxLKQ5ZE/Hp+RspMTuJq
	idco3taG7JXelXZswO6g4nekesmlqZYZ4Xzl0NSx1g8NUkMsZTWWvjqzJOl9yhMIYwIIHsqJeaU
	NknMnCA89fNpsaSewIMBTuvBv5a6
X-Received: by 2002:a05:7022:388:b0:120:5719:1856 with SMTP id
 a92af1059eb24-1232bef3656mr167497c88.20.1768323042979; Tue, 13 Jan 2026
 08:50:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com> <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
 <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com> <aWBxFXYPzWnkubNH@yzhao56-desk.sh.intel.com>
 <CAEvNRgHtDJx52+KU3dZfhOMjvWxjX7eJ7WdX8y+kN+bNqpspeg@mail.gmail.com> <aWRfVOZpTUdYJ+7C@yzhao56-desk.sh.intel.com>
In-Reply-To: <aWRfVOZpTUdYJ+7C@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 13 Jan 2026 08:50:30 -0800
X-Gm-Features: AZwV_Qhh1kG5lJR4XXx8Pf8xEVfNQb5mu9jspJicQMFZHnkx6PHsukE1Y22YU18
Message-ID: <CAGtprH_h-oWaZgF2Gkpb0Cf_CLhk8MSyN7wQgX2D6cFvv1Stgw@mail.gmail.com>
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com, 
	seanjc@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, kas@kernel.org, tabba@google.com, 
	michael.roth@amd.com, david@kernel.org, sagis@google.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, nik.borisov@suse.com, pgonda@google.com, 
	fan.du@intel.com, jun.miao@intel.com, francescolavra.fl@gmail.com, 
	jgross@suse.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, kai.huang@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 6:44=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> > > The WARN_ON_ONCE() serves 2 purposes:
> > > 1. Loudly warn of subtle KVM bugs.
> > > 2. Ensure "page_to_pfn(base_page + i) =3D=3D (page_to_pfn(base_page) =
+ i)".
> > >
> >
> > I disagree with checking within TDX code, but if you would still like t=
o
> > check, 2. that you suggested is less dependent on the concept of how th=
e
> > kernel groups pages in folios, how about:
> >
> >   WARN_ON_ONCE(page_to_pfn(base_page + npages - 1) !=3D
> >                page_to_pfn(base_page) + npages - 1);
> >
> > The full contiguity check will scan every page, but I think this doesn'=
t
> > take too many CPU cycles, and would probably catch what you're looking
> > to catch in most cases.
> As Dave said,  "struct page" serves to guard against MMIO.
>
> e.g., with below memory layout, checking continuity of every PFN is still=
 not
> enough.
>
> PFN 0x1000: Normal RAM
> PFN 0x1001: MMIO
> PFN 0x1002: Normal RAM
>

I don't see how guest_memfd memory can be interspersed with MMIO regions.

Is this in reference to the future extension to add private MMIO
ranges? I think this discussion belongs in the context of TDX connect
feature patches. I assume shared/private MMIO assignment to the guests
will happen via completely different paths. And I would assume EPT
entries will have information about whether the mapped ranges are MMIO
or normal memory.

i.e. Anything mapped as normal memory in SEPT entries as a huge range
should be safe to operate on without needing to cross-check sanity in
the KVM TDX stack. If a hugerange has MMIO/normal RAM ranges mixed up
then that is a much bigger problem.

> Also, is it even safe to reference struct page for PFN 0x1001 (e.g. with
> SPARSEMEM without SPARSEMEM_VMEMMAP)?
>
> Leveraging folio makes it safe and simpler.
> Since KVM also relies on folio size to determine mapping size, TDX doesn'=
t
> introduce extra limitations.
>

