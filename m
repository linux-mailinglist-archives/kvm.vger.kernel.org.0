Return-Path: <kvm+bounces-64985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 72564C9589F
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 02:48:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0A4EF4E14A9
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 01:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B73155757;
	Mon,  1 Dec 2025 01:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJU3l4KN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF6641C63
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 01:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553674; cv=none; b=t/cjkk/nnvdCAigRLNN28+vlHMDhp0Opzr0oEa8o1y2BfjFLmCxOF/WEuMFACrwJ4FLMobtMfpNTYpcE5vecUkf/vdC0EQXieaueu0uHGvI7V3JKgG+uVRqaAham6cVm5fPwhjDa2t3QcYIbwpPsv1X8bKCiLa6MEIvlt/WDv7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553674; c=relaxed/simple;
	bh=WkMG6KInPajZw+SCHLY6xyyqfgd7/gSlU2Diz+y04ck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C2jAGVD1fK9OF+ct+F50uo+2rECDGMjh39SAgWFemZq8ZIYMhPBTqd350tCgE1tDV592dTuyOlO6sHbE1Mma7J7YOz0OgrMtJFAZJ7MqByxKEolJd3tOz1I5Pvl65ZTCLFYekVwfJK9F9DYCKPaKhy/FModRabphbRoYZ+22wpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJU3l4KN; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29852dafa7dso623775ad.1
        for <kvm@vger.kernel.org>; Sun, 30 Nov 2025 17:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764553671; x=1765158471; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RubrtJY1nBr7co+TN5Cf36o/x/R4Bh4y+nkU3tUAkHg=;
        b=pJU3l4KN1ZBlhprAArEKzGUq4yKE+7cuRNn8ymR6JpB4ZTWEolAlwyMgm8Pp496Ld9
         WZRSfizxabijFcwLKQHlxWvaf8Z6SqmumAzK8wb0LQZy8VE2s/mvM1tu+2Ld3586gGza
         6L1im5lrYOIwbnlTXHuQuoXh6SRSHIgnDxJLceJgQSUVmqhUtQ90npVd4lunuvHqUzON
         knn+CByq9785fmwIqkdO2SgbIyQRk7wqSFmVQDpaMduIDrLz+ZE1W3DSeC8kDwl3LLwW
         OU4Ls0mSMm5hdXmkrif9JZxIo1zZe7Dwzy9KvKH7SleoVurWG1tu94EKF3uQr2isZ+CK
         6Mpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764553671; x=1765158471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RubrtJY1nBr7co+TN5Cf36o/x/R4Bh4y+nkU3tUAkHg=;
        b=tl6gqcI50s4SUy2aQaS+qsUTWqxcfJcPY+1zLRnquCgFtkDzn0+Ty7C1KNx6kg8X9i
         sibediVh4eabyuJy9VXc9iHyT9+ixhY60BshKBZOcjgABxhJxUh21yKxjagR5jovmeoT
         ZK8tChDaHdtukurFnip4qKDP+hk86lhsrpQPe5mmyOACAX5eyFB7HHYAZPz6ePCEwOMx
         lDUQNW+fhuCnqkf/GdD5lU6miy8YIKbnwBnI1EFfYlJUCs2OzGZ0h3aquPb3+RP4e4wP
         aJgaBh/ZUGEcUiJEJ1VJxzk0+LlQ39xHvLcB9kN2PVMx74tryqyKdcaJFKK+AioSIEYV
         TJ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0E9uaHRLnB9OxoSNediGKyfbQQGKknB+j/jnjMVhynG62alE5MWQkHpGZCbCKfCIhPh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YykG0CTR8xCUPLsJI0M5caCrXmOGLXb5uZsU3xBJ151l/9eIkpP
	6Ud6gN4UTWQRCbxK7O/sm9p4K/ZrANZnNrlJz+SQ5rxknz2gl2iedBGFHxCsyp0thGGzl8O9Qxz
	Tesb/nW3Nbz7wL18SyZz80L1tsAfFEXxqBNxLHmuZ
X-Gm-Gg: ASbGncs4yz8QOpREPX1HLE3Zc/MuVD9s+1NuYUa6oWN9lZlnubVxeP7amzblfFMi+Mb
	3kpzlBAdOzhKbpcNisRSuRJPALEW1rPUo+B+78mdb0mWxIhWOoZCMDfVxheKWUhA9aL6pdKGjdQ
	FTatPe2aWmHUKUL8b7VJqkLJmauOXaWXfPBrM6kurTuvCY/ZS4lD5BgNPVV4Vbpr7WXTcQcTler
	+1zEm55ple9a+LxBQHhdysFMf0FLTC74IknyHVIVGWrsyZSoeP95QCsTuN6Zd7GY8c19rKML7ne
	XlU9+lNTdZ4FPI2DQXoOr4xsA2i7
X-Google-Smtp-Source: AGHT+IGVKWbjRmm9tgU6uLDNVHu5xkhvGzmzSejdcqRBFvmWHeadfJ39slfnN2SFI/bj9haEVWPhElX75HTn7j06Rtw=
X-Received: by 2002:a05:7022:4a:b0:11a:fcc8:c311 with SMTP id
 a92af1059eb24-11dc9c5d1ffmr422435c88.5.1764553670544; Sun, 30 Nov 2025
 17:47:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com> <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com> <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
In-Reply-To: <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sun, 30 Nov 2025 17:47:37 -0800
X-Gm-Features: AWmQ_bndv783uhaZZ_oV6Xm0iV6cY4XqsD5JvxFNZOjPYdlSyliY7wOlOHpUWNk
Message-ID: <CAGtprH9_yo4P+oTaGzhHkC3gSdFPTYkvwHkwN66gQhQXX9fhRQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 1:34=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> > > > +                 if (src_offset) {
> > > > +                         src_vaddr =3D kmap_local_pfn(page_to_pfn(=
src_pages[i + 1]));
> > > > +
> > > > +                         memcpy(dst_vaddr + PAGE_SIZE - src_offset=
, src_vaddr, src_offset);
> > > > +                         kunmap_local(src_vaddr);
> > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > src could be 0x7fea82684100, with src_offset=3D0x100, while npages co=
uld be 512.
> > >
> > > Then it looks like the two memcpy() calls here only work when npages =
=3D=3D 1 ?
> >
> > src_offset ends up being the offset into the pair of src pages that we
> > are using to fully populate a single dest page with each iteration. So
> > if we start at src_offset, read a page worth of data, then we are now a=
t
> > src_offset in the next src page and the loop continues that way even if
> > npages > 1.
> >
> > If src_offset is 0 we never have to bother with straddling 2 src pages =
so
> > the 2nd memcpy is skipped on every iteration.
> >
> > That's the intent at least. Is there a flaw in the code/reasoning that =
I
> > missed?
> Oh, I got you. SNP expects a single src_offset applies for each src page.
>
> So if npages =3D 2, there're 4 memcpy() calls.
>
> src:  |---------|---------|---------|  (VA contiguous)
>           ^         ^         ^
>           |         |         |
> dst:      |---------|---------|   (PA contiguous)
>
>
> I previously incorrectly thought kvm_gmem_populate() should pass in src_o=
ffset
> as 0 for the 2nd src page.
>
> Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> snp_launch_update() to simplify the design?
>

IIUC, this ship has sailed, as asserting this would break existing
userspace which can pass unaligned userspace buffers.

