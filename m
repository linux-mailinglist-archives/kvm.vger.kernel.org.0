Return-Path: <kvm+bounces-54768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 482E6B277C6
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 06:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 325A1B61BB7
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 04:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA00D22B8C5;
	Fri, 15 Aug 2025 04:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ImAlz7yy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3DC214236
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 04:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755232169; cv=none; b=dCpobv/k5ObIMsrKTuK9dt68Xn2GxtBxSvBXGu+aXGqvZDFNUMG0GbBCCjfbRm0hvQ/dKsnlZvjMh1f60nqld07jeqs1SK9eECY/gxuQmmMCKHlD98mHFrojLRtt7MdPm9hRDNtiQRFOAyAow4aHh6Ho6pblQ4Wi/I4r2Qgy3kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755232169; c=relaxed/simple;
	bh=9qtLzM3OMwo2/FzKkbwn/dx6wo+sTX2QjA8OuyejtkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TsTHuOUIS3nE/CI0pIhGtK5QeM7h7Q3KJLYc+l22yIirXR6kFZYbgQQSCtvSJ1a99IVNOvlKTdV26XzC9iceaFtTDJuIjmxlzYPTyl+HDkUaqbJOSDzrmT4/f20C4haKO7b4dyEC8H+B1SC4ZeH52Np8PnjFQy0p2xlJSBIoGwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ImAlz7yy; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b0bf08551cso142801cf.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 21:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755232166; x=1755836966; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IWx+VXe6pkrLJ/ya8qipLPY+dN8/8pvnFFipbxwAgkE=;
        b=ImAlz7yy4s4FlecQsW83CBuE48y8zLOMoCGsBGvvMjcoedhzpMTD5UvefHfBtecAI0
         xojsP8jur9vpPR0v2uamD9eUiRfxW0E15Mx5yZeuKFvRBbHpuX4PeSLz2Sg2d/eNHHU2
         9Q882fJasrsKEWaKhzncnoFZALVAdRx7SaEtev89iMUcEEKFuhstetx3i7Nywp3Z/r2H
         mD1LOIh69gP6FBWrcutxhUjZg9YzZkao/GmghHixAbVx7QoiW8WnVs2pe2O1KW98zE7b
         8OvVe4/9jwGvpwHcT1Kl8zmbM6Lxvj5kbzeefPSK+mx5p5T57VIZkhU+hvAegv+5P2cM
         9HvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755232166; x=1755836966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWx+VXe6pkrLJ/ya8qipLPY+dN8/8pvnFFipbxwAgkE=;
        b=W0T5HhSi6sOqQENOJ7cWSylUGp2DUhT/T8QrkpRrdpXylQ5jBC39QfRyooPAbAIScO
         kVwgspWa32l3SPvNeROytd/fbrQxp3UPKB8aQNqs4OwlG6ezwiMeqaU/PTszWCKj8rbv
         TICeKV2OUm7HnS8cUJ3tw4MpE3xiWRazGCOeqnTv05nXe/MBIS9L8VDpR64krLkC7C/i
         o0XOD37PxinnA0FepAF7ayAkEe25gig2Kio6PbnuSAqhbbf7Qj1IjjzCJ1dVHqo9IbjH
         v0A4sWNlgQFc7zodaadi32htD3u08TI0hyW3bAxPsC/ULnAcLPnk0bkFtX8pPUg3k20u
         QB5A==
X-Forwarded-Encrypted: i=1; AJvYcCWFTjCeipcBjMwwRx+EllKVtdgOaU2tx3uF8poQydHrAwXVDDzP52rNAih1aBJC+0z1oYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YykhoE8Xgq9jpA8Sa1tEz7RhgWlw896xfQ/Z6wMtRnJ06vHuiYS
	7WPDyseASEaRoB2ypFl+SOt9q+v9bxukwIH2GpLghpxXVJLiGwCZ97WBiP3orB83QQi/BbZ0SHs
	VsqYk5TBnLhZnCAkrfpY/ii7jv4OK65YaZ3MjAWFp
X-Gm-Gg: ASbGncs2zUjAowkwyYRLb/kOQ9XAti5uHIR4Fxa1tZPHyoW64F4KDtwes8s3ixBUNcY
	ibEGTK6QTX/r2fY7RfeUC3MR9pWweqTgSqOwko/UGhupCW1xKalKTpI/F+yDqwa2tg8ISfMxsFZ
	jyHsRpqF19DB0F7RZqhyaVe1/+buvuXTNo7tpv3q43c4fekkJWiPgOVigfLwgQ9YkmcpSI95OtU
	0SlsDc8oZzTzDN4buCRBjQJNAUZxdD/OsGFs+Cj1Eb+5w==
X-Google-Smtp-Source: AGHT+IGTtCmo/WAwL9qd6ot9c+qQQtNLBBQttgktMp1bBoCOYQo//YJrWIr7SF3H6IOFL2A8Yr9maEGnIsMwfMMHVkA=
X-Received: by 2002:a05:622a:3cf:b0:4a5:9af6:8f84 with SMTP id
 d75a77b69052e-4b119e98f42mr2662581cf.14.1755232166261; Thu, 14 Aug 2025
 21:29:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <20250807201628.1185915-5-sagis@google.com>
 <aJo1kNCUzAe2TFAz@google.com>
In-Reply-To: <aJo1kNCUzAe2TFAz@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 14 Aug 2025 23:29:15 -0500
X-Gm-Features: Ac12FXwmZv9OAmjGbMnmrilv68VWgFEkOUK30MUJ6RwqLVrDrhJagqwxaB4xWV0
Message-ID: <CAAhR5DGdCx9XzBc9ZpgV3ckG_-6NB-DvPT3QG8ScPj+EW-34uA@mail.gmail.com>
Subject: Re: [PATCH v8 04/30] KVM: selftests: Add vCPU descriptor table
 initialization utility
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2025 at 1:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Aug 07, 2025, Sagi Shahar wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > Turn vCPU descriptor table initialization into a utility for use by tes=
ts
> > needing finer control, for example for TDX TD creation.
>
> NAK.  "needing finer control" is not a sufficient explanation for why _th=
is_
> patch is necessary.  There's also zero argument made throughout any of th=
ese
> patches as to why this pattern:
>
>         vm =3D td_create();
>         td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
>         vcpu =3D td_vcpu_add(vm, 0, guest_io_writes);
>         td_finalize(vm);
>
> is the best approach.  IMO it is NOT the best approach.  I would much rat=
her we
> structure things so that creating TDs can use APIs like this:
>
> static inline struct kvm_vm *td_create_with_vcpus(uint32_t nr_vcpus,
>                                                   void *guest_code,
>                                                   struct kvm_vcpu *vcpus[=
])
> {
>         return __vm_create_with_vcpus(VM_SHAPE_TDX, nr_vcpus, 0, guest_co=
de, vcpus);
> }
>
> instead of open coding an entirely different set of APIs for creating TDs=
, which
> is not maintanable.

Dropping this patch in the next version.

