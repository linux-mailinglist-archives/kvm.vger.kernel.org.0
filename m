Return-Path: <kvm+bounces-32180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD2A9D4041
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35334B36211
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7031531C0;
	Wed, 20 Nov 2024 16:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wl+GD1L5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F67714A630;
	Wed, 20 Nov 2024 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732119640; cv=none; b=KIjpzg7IPxaNykhTp9CtaCrZW/NBNuAgKBBVU68OTJrD8d8RQop7xl/8A33h4MUTGHm1ESbnR6bZJpo8QPWwQ/vaxEuVX5g1KRAJMdhMaZO5txhKaR2DSGU50f9Dhossmijljmm6h68W0ThdqGlAVpvvwlB36zNa18C5aBEQUGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732119640; c=relaxed/simple;
	bh=NkMlPuo43fHO0TgD1QYD9cIO7PO1KxGZkQheI8cp+JM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=btbG3fPqqcvdbLeOd1dO3uyx12SO/a+4acwkBfq4mIgZ5ppVHwgzwqP4bvZxQ/BBK79H3R+Ml5b9C09381HZXwM0TV3s5sed7KldSFi7Xgw6myg25d458wyH+0H27FohlbfwuARO6xcytI67JvvYAg5apHrMEzfabQrbUVOZgwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wl+GD1L5; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fb56cb61baso45553101fa.1;
        Wed, 20 Nov 2024 08:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732119636; x=1732724436; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ImSW+JuDhb3RgJw1o2hGS9mRoFnCl9ZYkL7+gfakSyM=;
        b=Wl+GD1L5nOaXU3W61R6cdsPrlTXAfMnNR2915tNug1wKKLsxUreHBQc1xYoK8LE7YK
         uvmAkGOe06QPB+oclB7lgJgFXUWHm52ez5IWCn8IEQK/XLfov7kd+7UK32f513x/BjOY
         SDpZwY+YqFqGYvNckGrFSSiCp274JF5V3H2AlVL1bIy6JdsNnnEkIi456HkcZiCEoeTW
         gCHZfTt8ghV0IZu9rYEOfZH3jZY19aFsXA6VEUIyeKmGC7bKdD0ew9Nm+PcDsfynX2yt
         0QumsBxIxcV+nmWKFffS2WhjAH3UwchpJN742FBiwARQzSNiqTO/KCfPVfrsDCXUSbyA
         crzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732119636; x=1732724436;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ImSW+JuDhb3RgJw1o2hGS9mRoFnCl9ZYkL7+gfakSyM=;
        b=lAXfRbZhdtyn1q9yj7UxlxmOdKO7uv0P8rPAGTa6lRPkqXpADmAOA86qoPLXrOdopL
         eXRppi027TirornubM/Ud7DVyglV6ZxVguz5ea0uGo4NFgGUwcnJs0NZF2c8MO8wNgrY
         F2LcKj6NCqjsdB4xw97litutR/mugGC2J3tFaDegUcqpazW2FvEso0glqeuCCKjgcswW
         PEL1DF/1naC8YKOOWLhv72UxZMwwrtSsdFyzBeNP0X4R/C62x9bL+sdaHNswkH8of48b
         eTEKGxcGNh/ZRTQ5O/npl8Id7jOPAuXItDJGGDpdCjm4w0ZjQmH137gS5j4FnegGWM2I
         9VlA==
X-Forwarded-Encrypted: i=1; AJvYcCWMzUxwJhHAyRXHKPeVvukS1qIJIOmQE9YSLQIR0R94A1xzES9FSE7X0tUtbOvCVONGK+E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz90156GAW9waZDBceAZap1i36QR8LX1LRiFBsmPUQWzZa08p9N
	ohDDrXe42pKCPcD+GZSTdEy683NOmzt/kcLjwLpAswuWz95aaBS43Tl+M/M5ugyPP/DRSflgnPM
	z/4DDBI7ahaIIi+Wjj0MiXyKjb/gKXQ==
X-Google-Smtp-Source: AGHT+IHNRQW/uxvLO+ngyUCL/BIFpVe/+hHdEEcutNrMQSMyWScoaAXP0lL3BqY9nHe93PE2jdPKH7UlnQJM0kusp+A=
X-Received: by 2002:a2e:a541:0:b0:2fb:5688:55c0 with SMTP id
 38308e7fff4ca-2ff8dcdcb27mr21196231fa.38.1732119635474; Wed, 20 Nov 2024
 08:20:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHP4M8VxL3GJx0Ofhk4_AToD-J0X+_20QmfZpq06DuN4CKc15w@mail.gmail.com>
In-Reply-To: <CAHP4M8VxL3GJx0Ofhk4_AToD-J0X+_20QmfZpq06DuN4CKc15w@mail.gmail.com>
From: Ajay Garg <ajaygargnsit@gmail.com>
Date: Wed, 20 Nov 2024 21:50:18 +0530
Message-ID: <CAHP4M8WMELcT8G1p7o5khEn5B9X+0UBkEMiScu9eD89qdpUbrw@mail.gmail.com>
Subject: Re: Queries regarding consolidated picture of virtualization and SPT/EPT/IOMMU/DMAR/PT
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org, 
	kvm@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi everyone.

Will be grateful for some insight if I am on the right path :)

On Mon, Nov 18, 2024 at 11:30=E2=80=AFPM Ajay Garg <ajaygargnsit@gmail.com>=
 wrote:
>
> Hi everyone.
>
> I understand in a para-virtualization environment, VMM maintains a
> shadow-page-table (SPT) per process per guest, for GVA =3D> HPA
> translation. The hardware/MMU is passed a single pointer to this
> shadow-page-table. The guest is aware that it is running in a
> virtualization environment, and communicates with VMM to help maintain
> the shadow-page-table.
>
> In full-virtualization/HVM virtualization, the guest is unaware that
> it is running in a virtualized environment, and all GVA =3D> GPA are
> private. The VMM is obviously aware of all HVA =3D> HPA mappings; plus
> GPA =3D> HVA is trivial as it's only an offset difference (Extended Page
> Table, EPT). The hardware/MMU is passed three things :
>
>         * Pointer to guest page-table, for GVA =3D> GPA.
>         * Offset, for GPA =3D> HVA.
>         * Pointer to host page-table, for HVA =3D> HPA.
>
> In both the above cases, DMA is a challenge (without IOMMU), as
> device-addresses would need to be physically-contiguous. This would in
> turn mean that all of  GPA needs to be physically-contiguous, which in
> turn means that the host would need to spawn guest-process with all of
> memory (HVA) which is physically-contiguous - very hard to meet
> generally.
>
> *_Kindly correct me if I have made a mistake so far at conceptual level._=
*
>
>
> Now, enters IOMMU, providing the ability to DMA with non-contiguous
> device-addresses.
> Now, my queries are simple :
>
> *
> Is IOMMU DMA-Remapping mode (DMAR) analogous to a para-virtualization
> environment (as per previous brief context)?
>
> *
> Is IOMMU Pass-through (PT) mode analogous to a HVM environment (as per
> previous brief context)?
>
>
> Many thanks in advance for your time; hopefully I have not been a
> complete idiot ..
>
>
> Thanks and Regards,
> Ajay

