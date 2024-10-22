Return-Path: <kvm+bounces-29317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6E39A94F5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 02:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCF101F22F88
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 00:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A51148FEB;
	Tue, 22 Oct 2024 00:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MnB+tgdG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBED7381AF
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 00:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729556729; cv=none; b=lFAoS3CdNCd8OmOYoApsFvkRrU0WzKMpSYBptaB+ukLOZH1JOktvuozAw8RB+Ghk3s7GI0iEo3LdaeJ3QSj7BadzmUM0n5zAKZhrOhUHB9ygW0iJ8OU2viEhic6b5IhPuW4buY8x8KFaVQ/YQeRqPFCkxSZO5Atv7TO6f7TPD/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729556729; c=relaxed/simple;
	bh=Wwk9dyFtDwuEQQqz0hmWJyU/DQRTYfyP+Ipucu+Wmy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H5+wpWyRpbTa/plp7GFTWxemKPToMEen2MyRZZaXqxmd9S55rCuV9Rvh3TQd1IPf2qHkrHzoa3d7DOi4s/h/d7ooGB7d8XpWyub7fS9w/sVmueJb7BLyM6dKfwbXTETM/3MjgD2FiXin8xSA8Urk+1IeeTj9AbT3X8MrJd/5uKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MnB+tgdG; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e17bb508bb9so8765554276.2
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 17:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729556727; x=1730161527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MsmHAIiTKT1PsAHJrcn3wc4lWOtEN6U6cuZlArYcGvA=;
        b=MnB+tgdGLReNlA4KEjpVCLIj6z8w8awI0i9a3sx6+jZblv+50MQgjAouTqZ2aPZc05
         Tj8MaMnAzVDds9kIB3by6YraN1PiaDEqXQhfu1knp56VmW2qHZ4pNOt1wvkNHAF1H1vM
         15Oh12H+8GxJlu/UFODeS16wIlUfyxpnlPoR+NPMHFoTTRePnpuwweVXeIsD7ETmEC+Q
         m6I2RFDuOz4ve6Akcb4YZbiabtw5ROaEvgX3aQFCf91BH+Cj5vnaN7RIiB/KHsnDjvVA
         ZHSigZtjSwnwLGUp5kIE5DJqbAN2fjOdNIQI6E6G28BG7CYWXkBnVEtECNQ2AZzAZNU+
         znmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729556727; x=1730161527;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MsmHAIiTKT1PsAHJrcn3wc4lWOtEN6U6cuZlArYcGvA=;
        b=dKxIsyPqLhnU0YS9KhlLlX/AlMWgYmfTRcjorRP1vjR1jmjVxnq7svsxtkSsi3qTx/
         hhGYSnkPBKLcDlz+1LJVYiCUzi8OdWuOCd/PUxmMMzqkRQYUP4vEQP0ogUWDEq9NLZ54
         rq424FMZ/9jBMq5DR+LZlmJl98KQj4CzOGKW5o3+ZJ/8gx8ojrhttBxGEPaZPJTK1/qZ
         yY8NW84hd+OelY/4JBLrqw+A9TbpLX7WzQ0go2JKLgexrYcKEhDY0DXpH9SCyVMzwrSr
         feFo1U4G8SFLTFlN6I7D4vhiljPI/5Nc5nu7rNqxnfwTSOExPlLtO6QpJffbvO+2fMt/
         Tzfg==
X-Forwarded-Encrypted: i=1; AJvYcCV0d+hI5F2qUoYfbeg+gL5jToGfeKt/Y2X5/D74HfrhDTgKeaigcBjvqNUjss8TAHwt9T0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyVdsN836Pni1/w+uYpKZSoPFEvYlEtW3IJ/4+tTE7eF9UAhgR
	jIIxD6TgcCBds/sDxB4UBH2Gz30O53U1VqdGSI/OfGsBZ7+rBh5ONyGUM/pyd9OzOkEzdUz1Ys+
	UVw==
X-Google-Smtp-Source: AGHT+IFt751p/7pq+BSWT0h/wj8dy6pof7dpapFjoV1RFsMPc4iJ6WxDdC7RwTVAow0VYtv4igk8p4vJkHM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:aae9:0:b0:e29:1893:f461 with SMTP id
 3f1490d57ef6-e2bb0feddc7mr22594276.0.1729556726690; Mon, 21 Oct 2024 17:25:26
 -0700 (PDT)
Date: Mon, 21 Oct 2024 17:25:25 -0700
In-Reply-To: <CABgObfbQW-3vp=mNcR4giUGZ_gxhuRykvKj8gzBDY7pOg6xdBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com> <CABgObfbQW-3vp=mNcR4giUGZ_gxhuRykvKj8gzBDY7pOg6xdBQ@mail.gmail.com>
Message-ID: <Zxbw9XcFCHYR1Ald@google.com>
Subject: Re: [PATCH v13 00/85] KVM: Stop grabbing references to PFNMAP'd pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
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
	"Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024, Paolo Bonzini wrote:
> On Thu, Oct 10, 2024 at 8:24=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > v13:
> >  - Rebased onto v6.12-rc2
> >  - Collect reviews. [Alex and others]
> >  - Fix a transient bug in arm64 and RISC-V where KVM would leak a page
> >    refcount. [Oliver]
> >  - Fix a dangling comment. [Alex]
> >  - Drop kvm_lookup_pfn(), as the x86 that "needed" it was stupid and is=
 (was?)
> >    eliminated in v6.12.
> >  - Drop check_user_page_hwpoison(). [Paolo]
> >  - Drop the arm64 MTE fixes that went into 6.12.
> >  - Slightly redo the guest_memfd interaction to account for 6.12 change=
s.
>=20
> Here is my own summary of the changes:

Yep, looks right to me.

> patches removed from v12:
> 01/02 - already upstream
> 09 - moved to separate A/D series [1]
> 34 - not needed due to new patch 36
> 35 - gone after 620525739521376a65a690df899e1596d56791f8
>=20
> patches added or substantially changed in v13:
> 05/06/07 - new, suggested by Yan Zhao
> 08 - code was folded from mmu_spte_age into kvm_rmap_age_gfn_range
> 14 - new, suggested by me in reply to 84/84 (yuck)
> 15 - new, suggested by me in reply to 84/84
> 19 - somewhat rewritten for new follow_pfnmap API
> 27 - smaller changes due to new follow_pfnmap API
> 36 - rewritten, suggested by me
> 45 - new, cleanup
> 46 - much simplified due to new patch 45
>=20
> Looks good to me, thanks and congratulations!! Should we merge it in
> kvm/next asap?

That has my vote, though I'm obvious extremely biased :-)

