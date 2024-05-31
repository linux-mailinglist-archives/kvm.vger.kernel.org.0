Return-Path: <kvm+bounces-18483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0439B8D597B
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2899288B56
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081C87E0F2;
	Fri, 31 May 2024 04:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="AqbnsYY+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCF77BB01
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130063; cv=none; b=l4Szo0kNbz91q96m9namDCgxgcWEApia4jrnZEBGcKFvUaAgi5bmee5/06rkG8kFmJKmFjBg1afSPfQmk5rgF6nrgFEyCu5gNB0SM03eP5Flw3GoM8pu0WzxOH/5OZBNR0RbSy8OO25UH7x+8nVeBYCdrfCwyrZN8vBTdgeNTAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130063; c=relaxed/simple;
	bh=JbXFS0Fgv/0TnV1TSruhy4/VftWuFz4YNvlVR+xTgiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EL2/eTOFIyLfP4a7kYLTUKD+3XWGKiLHAcFDgtnAAyoI72OZE0R0GSoMQb7pyYKylTB/zCT8Zt/igKiIkqYVAVPIrVjj1NtCFTocBHxJT597PRBZfpj/tyxtrpSlIfXJ8GfPeJtBE6VqDe9GXQynkYFEz+WartIZd7nxjlcrMms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=AqbnsYY+; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7e2119a1b82so52571439f.0
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 21:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1717130061; x=1717734861; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aojvCCZI7oDG8nQF+lVjR38DWbQN1/i4Dj6O/Uiios=;
        b=AqbnsYY+ZJqS25mKTXXbsEc+6PFAz4NGuL7fyC1LDyYey/h+41o2HgGplLyyvddlh4
         JE5CGhKsnv8T1HoLBWS0OY+pItTr/wOir+sr8Fd16+3dXLpnaQHED5wFD3WjCNpPfynM
         PEU1m3BHIWQSv8ZOTEStHfqMXZbxR71boo9DysqGQdH7JA+G0tkt1EfRcTRTN2w6un7w
         5LAZnJu1A5vOOR6kQbo9E3oZEfdwHxKd4rOcCdSUM9FtajBHgk4j1YifDa1DzUh41Fpu
         BzDbYHfymX6YGCkLomGatWYsPPBEPPZQuYNmYKxxh8WV9M9EVQNFNXfoBuIgYVBGuipB
         K2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717130061; x=1717734861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9aojvCCZI7oDG8nQF+lVjR38DWbQN1/i4Dj6O/Uiios=;
        b=oKNG84S8AePOZcvNq2yoD0vx1MRhn3F534+tsn+UsAYR4fw4IMTBEZ/kqKfsgW80T4
         VLjEiY8UC/53J1P+gCAUeaEVyI/N9XzJuqtW5MOw/eQqQRceNcDLcS+dvWFtuNMM0YCv
         pTl0Gi3NmYQ7VFNxX3w/u5IpXuRGYm1U3TmxUuuIyB7H4Ja2Ga0j2RAqcmNPMXUOa9eG
         pZeJsWldpFqiWrEPcG+1E4eETJeY6za5KQ/yLyUNpx2wdhvyJx1NQVADGhVWisYGfhtm
         /SZzpRljxZ60GO+A7DNrhqfnZ4ucz8LX7drEe0FrBOQq/TyxxTwWJ7s9CLJnJGhP9laN
         /OeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/IGQoxZ9/Fc9LSTw891oVX7W5TFgMDR9hZk9kZLWlxT/kmkiXiIjCPEtwlfMqAnLlVf0DAHlsS1Clzl5Po6Rkz97K
X-Gm-Message-State: AOJu0YzSPtn8FrNQK+pUNt2MhAQgDc9Ad1OJFHvgGhX6l6/2H11kNi6S
	nFveeuaJ8RgBnd+qZ+ycuFXQllhuVMzxsm/rJeVz4lZFMjOGX/3xc4ALI8pl6IiuShzkye1q2ju
	TeNXh+wvWpBq+hzq7U0GuEqrdOlG3c7gnjfdc7w==
X-Google-Smtp-Source: AGHT+IFumUwOVBhqm9jSSegtfTbBsWrL7+wRv2hHDnozjQHdKdEmqi3s7UpbRv2rHVzdr2XDkO13liv49fwxH13T3Ws=
X-Received: by 2002:a05:6602:3425:b0:7de:c59f:2151 with SMTP id
 ca18e2360f4ac-7eaffe71e50mr101316239f.3.1717130060742; Thu, 30 May 2024
 21:34:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240415064905.25184-1-yongxuan.wang@sifive.com>
In-Reply-To: <20240415064905.25184-1-yongxuan.wang@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 31 May 2024 10:04:09 +0530
Message-ID: <CAAhSdy0STe67n6TB2ZH1OYZCTQ+yPycmsQ+8Ay0KsorwVYEo6w@mail.gmail.com>
Subject: Re: [PATCH 1/1] RISC-V: KVM: No need to use mask when hart-index-bit
 is 0
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 12:19=E2=80=AFPM Yong-Xuan Wang
<yongxuan.wang@sifive.com> wrote:
>
> When the maximum hart number within groups is 1, hart-index-bit is set to
> 0. Consequently, there is no need to restore the hart ID from IMSIC
> addresses and hart-index-bit settings. Currently, QEMU and kvmtool do not
> pass correct hart-index-bit values when the maximum hart number is a
> power of 2, thereby avoiding this issue. Corresponding patches for QEMU
> and kvmtool will also be dispatched.
>
> Fixes: 89d01306e34d ("RISC-V: KVM: Implement device interface for AIA irq=
chip")
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>

Queued this patch for Linux-6.10-rcX fixes.

Thanks,
Anup

> ---
>  arch/riscv/kvm/aia_device.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 0eb689351b7d..5cd407c6a8e4 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -237,10 +237,11 @@ static gpa_t aia_imsic_ppn(struct kvm_aia *aia, gpa=
_t addr)
>
>  static u32 aia_imsic_hart_index(struct kvm_aia *aia, gpa_t addr)
>  {
> -       u32 hart, group =3D 0;
> +       u32 hart =3D 0, group =3D 0;
>
> -       hart =3D (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_SHIFT)) &
> -               GENMASK_ULL(aia->nr_hart_bits - 1, 0);
> +       if (aia->nr_hart_bits)
> +               hart =3D (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_S=
HIFT)) &
> +                      GENMASK_ULL(aia->nr_hart_bits - 1, 0);
>         if (aia->nr_group_bits)
>                 group =3D (addr >> aia->nr_group_shift) &
>                         GENMASK_ULL(aia->nr_group_bits - 1, 0);
> --
> 2.17.1
>

