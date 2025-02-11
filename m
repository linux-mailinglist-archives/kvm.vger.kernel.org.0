Return-Path: <kvm+bounces-37845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F5AAA30AE9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89D761883D80
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503B81FAC30;
	Tue, 11 Feb 2025 11:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Fje2bCxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5791FA14B
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275140; cv=none; b=ibW1mvft6LUjhrZzqxf5HMgGZJ62HtL3nsXm+aJPiNkc/BrpVfjVuK5LF7Y3yNwhGcX/F0UjKyJEsY1FPKAlIxPV//+A3WmY0MjT3zTi5mtxxq+k2xG3B0v5Lf9DWdLx1uFXR6WNRDpChFfrSAmfy/WiEi1Epx84VZB1XriIbsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275140; c=relaxed/simple;
	bh=RBJj/x87ZvDrlal8HeZb6AZ8qHTfBLQ6KjdgHSJgU9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FrdePxknF99Bl8XksNszYcB9OmNNlyutj69gEujLsX9lgdwnrFJhhO3RbRgURgUD3P4fK3XT7jz9kj5ANbPyexvs5SCoNttWVQ/vRDIS7xsDozEVNtA/HW+f2/UTd20R6mD/vT6WvUr1t4LTm7FMQvMZkKbtYEB6O9so360eWdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Fje2bCxZ; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54506b54268so2491689e87.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 03:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739275136; x=1739879936; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfrJOs3nOC/uZQWBsu2L0oE9KdKFjO9EW7o+/+NgYt8=;
        b=Fje2bCxZo86Gsetf1nJ8NjwMtDVNYb6m39BmnuTGYCz7HTqOz4ykPS2fvXSTDOxEhU
         q00Z+Oo6Vw/+tIO/TilvCw+NeCucvdL2y6WX2iwWZlUNP1WsKxGFv7qWBbIdMInUVeGp
         AVcdxh0KIJTu9EDGRhpOsoNDrAuXJLCG8T5ePVbf6LeTDuuHQ3SN39ffySguJxnTRg3N
         SWrQ263rzYCWwOTEsynARIFSfUwDqjd8CltMtVmUCNKVUwDxeSE0OXVfdPHgZWz60aQD
         X7KDoJOtkFGJbmdoqbxoUmD3gOybqKyLaVf5ucXR0zBdApBw/VsP4q6cW6mLbB2BYsGL
         MCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739275136; x=1739879936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YfrJOs3nOC/uZQWBsu2L0oE9KdKFjO9EW7o+/+NgYt8=;
        b=Qfr+JMKkUVlXZcoSyaiTGzczQhkX0Ll5j100y+/ZeSi+aAErUvmLokncCbFqOyDPGS
         hdx64mSgLWiFA0YhILG2gUJUTiqwB4QFsMI4GB8gDXuFpMmlyxabdhm9/z9q3U+zn+m3
         +ans0ShFC2vMX+cymn7Exakc7XAUFCF8SaRigDx24ITlsKgCqyWyjEoCS2AX2nErb297
         DqhVXJoKLiLNQUoGHIp27i7vTHfDImFwhTfpJEIuX45bmbNBAO1DJkIJBIz+shUG8wPn
         lxwSXOl63d+t6XAm2rPAVWLGeYyzyujm3Soi6l2fXS6SRcZVZIQ6akHfIxVftuP2xuyq
         ej/A==
X-Forwarded-Encrypted: i=1; AJvYcCXit1seRjjSnVkiEQjuzKDpnd1tD7b+BIzQ8Q36HYJj6hw366ZXeThAdgI0qWz6+ATMWes=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaIShGw/N+1dIEK4gF7xmaq8izpK1ItLFV+oJo8w0NITzOowAI
	99DPdWMQB3eZfjmFmNz6/Grt4KpLSIgxkd+IySqDRFmLkjMUvH1pPGlNI3TPBnSG0Y54SsgNV56
	3OlwG+78GDMHsyR2teTGHS4Hwos9Fnw5KzBj1UQ==
X-Gm-Gg: ASbGncutLgh9QT+GINnD2alLhzD4D5mOoDmrnszmV0e0JU6wNTYsh44Aoc4uRAMM592
	ad9jlo9s1YW/D02atgxF029F0++SjNlA8m9SE6b1qQ/P7MZS32voiYXDB0z8VGejfConoEbVPlA
	==
X-Google-Smtp-Source: AGHT+IHi9fRc7g4LXLMTTrfhBpjvIDawNVLbxz/VrpF9Ym/YVJUnNi9Ybh2IY4Q2sYmZ++mmturgtiMZM7nnBID564I=
X-Received: by 2002:a05:6512:2316:b0:543:9a61:a2e5 with SMTP id
 2adb3069b0e04-54414aa87c8mr5949576e87.23.1739275136403; Tue, 11 Feb 2025
 03:58:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127132424.339957-1-apatel@ventanamicro.com>
 <20250127132424.339957-3-apatel@ventanamicro.com> <20250211114018.GB8965@willie-the-truck>
In-Reply-To: <20250211114018.GB8965@willie-the-truck>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 11 Feb 2025 17:28:43 +0530
X-Gm-Features: AWEUYZkAL12uMf-9Tj-TWkSprxk8wj7zzxxQgrdbCiYSyAP6uq0zWoQGQGyineM
Message-ID: <CAK9=C2VPs=VLPWupSjzz_y4QRtL56eQC3DCJVEjrREy-qmbHVQ@mail.gmail.com>
Subject: Re: [kvmtool PATCH 2/6] Add __KERNEL_DIV_ROUND_UP() macro
To: Will Deacon <will@kernel.org>
Cc: julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2025 at 5:10=E2=80=AFPM Will Deacon <will@kernel.org> wrote=
:
>
> On Mon, Jan 27, 2025 at 06:54:20PM +0530, Anup Patel wrote:
> > The latest virtio_pci.h header from Linux-6.13 kernel requires
> > __KERNEL_DIV_ROUND_UP() macro so define it conditionally in
> > linux/kernel.h.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  include/linux/kernel.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 6c22f1c..df42d63 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -8,6 +8,9 @@
> >  #define round_down(x, y)     ((x) & ~__round_mask(x, y))
> >
> >  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> > +#ifndef __KERNEL_DIV_ROUND_UP
> > +#define __KERNEL_DIV_ROUND_UP(n,d)   DIV_ROUND_UP(n,d)
> > +#endif
>
> I'm happy to take this for now, but perhaps we should be pulling
> in the uapi const.h header instead of rolling this ourselves? Ideally,
> kernel.h would disappear altogether.
>

Sure, next time I will try to pull the uapi const.h header into kvmtool.

Thanks,
Anup

