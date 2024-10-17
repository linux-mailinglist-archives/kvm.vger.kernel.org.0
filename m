Return-Path: <kvm+bounces-29105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB699A2B2A
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8C05B290A9
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E0A1DFDAA;
	Thu, 17 Oct 2024 17:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JfDKBTN7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CEA1DF990
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 17:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729186825; cv=none; b=KddG8Hd/ahBIUcUOYQAY1tl+FRQ+lhyTvJTpEaxR5BmIANTygcxbAc5bbAdN9hSF+HbFe62ysu0nGjCpJHO255XGxcTq3K5Gw8i60bJlM01f7PnhjmHcBAykdHvkuZvB++81opHwlYf9r/eJ1p7Ck8IjRyqKsD0Qs2ZWOomfpWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729186825; c=relaxed/simple;
	bh=dLn9d36dm2CDpdmYI4TuowHAHoMiQT1DP6ItK2LTOeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VuKd316A7y1fXyJtunV+xGZbhjL5zYKTnZ7KqoJLQyj9KwLGKH9L0sOv2tNZArsib9KYlKd+KRSyDt+v6qguKKu3ajGBsCdnGlllcMSxQmvqgvQCgXZ1I7atW6w43i0O2lcF9FwyPjrqkR+5kopsxgb5H5jyNzTh98C69SYjKVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JfDKBTN7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729186820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Me+6kqYD5L+igZgkevVfUHfhQZBz6G5zZyQw2Dfa0gs=;
	b=JfDKBTN7EKK/7g00ZbFVAOFGAj+sX09EJtPKbT1THPVZu04ZswRCfPXhcSzgAHfWsJdEmo
	+7We6LKORBxOOwyFJOnzKJqG4ivYQ08lR1n3IEFl+JuOni0sHCZqcDyWTjNRj2eVqB6vOa
	xwMQ/v1Rer+86A6jIrUtOByGNFJNPmQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-4dAIlkk6PMOlel51bpaEBQ-1; Thu, 17 Oct 2024 13:40:18 -0400
X-MC-Unique: 4dAIlkk6PMOlel51bpaEBQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43151e4ef43so8349175e9.3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 10:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729186817; x=1729791617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Me+6kqYD5L+igZgkevVfUHfhQZBz6G5zZyQw2Dfa0gs=;
        b=YPjymcpXS33X6tHc2BzHF9GZOehORqyoL6bZC4fxzcpbx5BVGhwr1NY2CfYLYAC7Bo
         HklYFolTYHkfJODQkgDunCUereNrqR9/OzOmncYfHiP31F5EExip7jmGBvSu5XWposAK
         2UI1bSPVd1uYkz4Pc8d0M3ctmh8TjzoRaJ1O/s6BqVnrGWqWx/SSvaPsvZ2CM69EcYyW
         MDsqF6vCTWd9r/FniyQWWeQMT0fwL8MRzTBtdHhX09XSFUtOLzXK82FJYQCff00UL8oG
         uY5qXipLdkc8cimc6LhhJJUhjP/t5SVc/fGX4pjowjmLeIwmLDFJMX0JJM/Sp39r73+l
         bnhg==
X-Forwarded-Encrypted: i=1; AJvYcCVNodHbrbeZ3w5iia5of25yAK+bXEXEjIK8W5yDGK2jTeFZf9NYjnoFxMd6tjWMIDQJxsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfvVtrHWdwzrZ5u9JU32RhoTiv4eCpADGnkCNUpFVoAK/Izez0
	7TsKDyNuWKMIsfWborCb3HE8w/BfDiFRSN+Vuxs7r4nsqjAyEdfEtxCuN/Ha8V5oZT2wvyvGPeE
	Xc4hjFeuzg2aESONWtO9Y/4ALO0cg3Rja9ovQb4MgTTu6r0L7MbgWFMteNfPTSP+zcJNQcZ10id
	bmdmfG1Qqfc/YNvhjNJDKhioUT
X-Received: by 2002:a05:600c:1d8e:b0:431:57d2:d7b4 with SMTP id 5b1f17b1804b1-43157d2d7b9mr36507125e9.26.1729186817338;
        Thu, 17 Oct 2024 10:40:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJXjIUBFBzWhc81QoCH/SVoEivw8XmjKVFXrcy86zA+s4Bvx/9zH7hnQ9Z4/zbRof1LT4xgUF82luj5UeBHDI=
X-Received: by 2002:a05:600c:1d8e:b0:431:57d2:d7b4 with SMTP id
 5b1f17b1804b1-43157d2d7b9mr36506735e9.26.1729186816975; Thu, 17 Oct 2024
 10:40:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 17 Oct 2024 19:40:04 +0200
Message-ID: <CABgObfbQW-3vp=mNcR4giUGZ_gxhuRykvKj8gzBDY7pOg6xdBQ@mail.gmail.com>
Subject: Re: [PATCH v13 00/85] KVM: Stop grabbing references to PFNMAP'd pages
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Yan Zhao <yan.y.zhao@intel.com>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 8:24=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> v13:
>  - Rebased onto v6.12-rc2
>  - Collect reviews. [Alex and others]
>  - Fix a transient bug in arm64 and RISC-V where KVM would leak a page
>    refcount. [Oliver]
>  - Fix a dangling comment. [Alex]
>  - Drop kvm_lookup_pfn(), as the x86 that "needed" it was stupid and is (=
was?)
>    eliminated in v6.12.
>  - Drop check_user_page_hwpoison(). [Paolo]
>  - Drop the arm64 MTE fixes that went into 6.12.
>  - Slightly redo the guest_memfd interaction to account for 6.12 changes.

Here is my own summary of the changes:

patches removed from v12:
01/02 - already upstream
09 - moved to separate A/D series [1]
34 - not needed due to new patch 36
35 - gone after 620525739521376a65a690df899e1596d56791f8

patches added or substantially changed in v13:
05/06/07 - new, suggested by Yan Zhao
08 - code was folded from mmu_spte_age into kvm_rmap_age_gfn_range
14 - new, suggested by me in reply to 84/84 (yuck)
15 - new, suggested by me in reply to 84/84
19 - somewhat rewritten for new follow_pfnmap API
27 - smaller changes due to new follow_pfnmap API
36 - rewritten, suggested by me
45 - new, cleanup
46 - much simplified due to new patch 45

Looks good to me, thanks and congratulations!! Should we merge it in
kvm/next asap?

Paolo

[1] https://patchew.org/linux/20241011021051.1557902-1-seanjc@google.com/20=
241011021051.1557902-5-seanjc@google.com/


