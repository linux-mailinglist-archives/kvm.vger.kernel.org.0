Return-Path: <kvm+bounces-65022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E4EC98A7F
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 19:08:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9B146345052
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 18:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6886338917;
	Mon,  1 Dec 2025 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PzQLz69l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3725B337BA1
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764612479; cv=none; b=nS2FF/3Ylk9+qtSKzit6UMYwhZUZM0psdSfFypCB7o/VZ3Cpepph9qAlgVK79jWCF3gRFUniDJXhqj32catIT/NIqZi7XEi8WA6EHwpkH73KKrFMoDxo6UkiZt2PSDgqMqLvz2RXKhYIc5vQSFNRJ7oWRQHVUc/6NrntXo9j028=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764612479; c=relaxed/simple;
	bh=8rsROMn92J41TVNBjy3cP4TH9efYQIu1NyuM3KAZho4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YW4YSjwdqnAhFLyP0yRc6wvLi/V5yKzXQ8uFAjNZcmSuo1k4t4fB3P06TgWxfZXUwlwCXS228I4EATEyI9Hv6mkUjmD+XTQzS20L1ZfGo8vdJALv5FxA96DhtK4Ny+DlMRY8cab4qewhoasrz7epCtzXkvHUhNn5MuzzNik7sE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PzQLz69l; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37b935df7bfso42626011fa.2
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 10:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764612476; x=1765217276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHR2b1tdnReLGK2rMPeAJ5tNK3FsFx1mTEmh9YttTBY=;
        b=PzQLz69l264KeGRPYi4nVtOpPUD9jsr4xmYhrLrWSRbV9lp/1tkgftFWRJ56qUlzIB
         Wy8LCIk++bvz4pR7djsRXLfcHu6I+e/h8a06OqdLl8pdBPb+lUYMN/s3CG6kYEEgseCD
         vr3Y87lc7HKoyEoeLWv/mK0m6yI9Skj/p1SDfGEdScwMSycLGUcQtwIM74wmDVno31H4
         Pk7/uKtzI0WlFBvJlQUhco9DKmWPRk29wZ5ecYJfPiOFBxZlJIyhxhdbG8m17LfS6YPV
         KywnXwEtK5iVkxDTpKpqx0rc9Z3wvvaI6d8SiTLAZFwCAQPcGp/ziTSR3iVGclBQjyXf
         nB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764612476; x=1765217276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kHR2b1tdnReLGK2rMPeAJ5tNK3FsFx1mTEmh9YttTBY=;
        b=VhRI7c9HCFXvYGiEWVvkJxjM3mSEHwJ7wZVUKC0mCH8NgMt0XYcGJ2Th3YSYP5ikvQ
         mYAxxcbVBeub1ltZh4ah2ZXuwEt18MXZVKoTMif7YACI9dfvDm21wl5+yZ/qdXNy4tNN
         4lflqox1gLGp75Fpd4XyuYK2xT9PCdkLLlZ8ZIT5vZnWHBZz0lAxUAO4MurR2HH8uClT
         +9XO2N4w8OtHuaQL64PTfGePzhPqFVpltp9Zz2fP/F87YPO1qPc3aUDal1e4T+WWNNfS
         C+ZjVaQXUH9YKDcdreXC1fzCTvwhCZPF1apIButeEbr5ToFXBxIIX44/FkzqQe6BYpFi
         o9qw==
X-Forwarded-Encrypted: i=1; AJvYcCVVD/TL5TeNmwpLJeh791vyG+ZzIAPtHdWipLx0yQEfL22OXPD9B1AjWlFrrIFC1AGQEMY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6rbZZv59ylsG8b++jzwh9vzZ1dh/ttGKSSt9vNvJoVr8chbhk
	chrTzSyrJ62CpiCdDvseIhIjBtnJC/xMI9+A+2UPV/TecNo2klNVpHb8S31SBR//+zQfyrNPCTR
	A1lZwe8lrdhB1qzFTSU9tUtAOtwW3qcER7zm6PB9H
X-Gm-Gg: ASbGncviYE7XWrNv7KlaEuNlJyaJYh5w3y37Yjgvf0lSiERmwthK5JmdBwsBloESPYk
	lQvsIl0hyygHR/HipPcAKDKzO0Hsdejqr3zXfTxJtVkMDbLfSzIARPzAF7v9QrGucX/oE3Kv9rc
	086zM+KqBHOIg1l0cOcn6M3CHyb9Uu3/wlEe350I06mVAle5JssHE4+sMkI+dRYMcVdoX69chnG
	UfgPkuDkDkx1uPR3Wtm5R+XmBYOzaZ7ioES5EmUwVYjEXZqiOw639OrbTzA18WCvknzfq7Z
X-Google-Smtp-Source: AGHT+IEN3e+8GrhdE9mAKq6M6O36EXV0rwfuSn04+F/nQOmCWX8I0XUdBirEHvrMIu0J0E0PqjGTqNWM7KtX/bHjIWU=
X-Received: by 2002:a2e:87c9:0:b0:37b:ba96:ce07 with SMTP id
 38308e7fff4ca-37cd91b6896mr84496801fa.15.1764612476135; Mon, 01 Dec 2025
 10:07:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <20251126193608.2678510-3-dmatlack@google.com>
 <CA+CK2bDhr-ymK7mKxYpA-_XJ9t4jEr3dMQH-5c8=jbtwVvNSKQ@mail.gmail.com>
In-Reply-To: <CA+CK2bDhr-ymK7mKxYpA-_XJ9t4jEr3dMQH-5c8=jbtwVvNSKQ@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 1 Dec 2025 10:07:28 -0800
X-Gm-Features: AWmQ_bkomNF3J9A1FiK-AgqV8WToT7JD_nfz6VIh1V5NsvSQRYZQicK6wnjcmD4
Message-ID: <CALzav=evA12+-4mOjUMLin=E=STKSW9JCpT12poyvW=N8jh8Cg@mail.gmail.com>
Subject: Re: [PATCH 02/21] PCI: Add API to track PCI devices preserved across
 Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Philipp Stanner <pstanner@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 12:15=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> > +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> > +{
> > +       struct pci_ser *ser =3D args->obj;
> > +       struct folio *folio =3D virt_to_folio(ser);
> > +
> > +       WARN_ON_ONCE(ser->nr_devices);
> > +       kho_unpreserve_folio(folio);
> > +       folio_put(folio);
>
> Here, and in other places in this series, I would use:
> https://lore.kernel.org/all/20251114190002.3311679-4-pasha.tatashin@solee=
n.com
>
> kho_alloc_preserve(size_t size)
> kho_unpreserve_free(void *mem)
> kho_restore_free(void *mem)

Will do, thanks for the suggestion.

