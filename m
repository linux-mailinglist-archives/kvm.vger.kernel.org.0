Return-Path: <kvm+bounces-63381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C004BC64467
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 14:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 65ED5385BA9
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BEE645;
	Mon, 17 Nov 2025 12:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EaWpTp7w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481B113D8B1
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 12:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763384083; cv=none; b=JmzXYOYySSq4ERv11DXsRwXUue7S7+LawEneKDoW3Z374PUdpSakchMqebg9I4ugu6CB/PUk5mlCVAVt3K2WD2YHgBLH11L4blhV1iVXAH1BBrRuisnpN5iYfA204CtoDsMnBvvmPycN3D6xrxTeHSG3BSZsnP4TyVLOYLZu+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763384083; c=relaxed/simple;
	bh=nl0HsCOCplgzTdFedqXiVjLN/5t+82gffsxQe1egsWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a/WjvLX7gl6VBwBrGCgO6WbvqFD8eavT6UhtuQKmftUcBNiqYf6+v2pMApjmjSt9nTFE4vD99NA6VH1/cr9CxJ8I1MXqbYpg65rMRdb/NArVSF3yid+wRH8D6rkdrPSmX5pZHNFfLyHnnr5Fa5490ZyEJBBzeVi4dsBFAjUETCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EaWpTp7w; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4edb8d6e98aso694511cf.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 04:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763384081; x=1763988881; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j0PeYkxx4r+5jJsF9hbC2hTxYP/y6FVcRV15IQ6oSzc=;
        b=EaWpTp7wo8P0OYD4RoNQRJmboPLGZ660DSKqytQEwQk2G9mq1j2S4e6+ryXEGWe974
         LPkg9sk+YIpT5QUpNo1DdSUJLmmeuQaKPekbfNt1QTj1SCoWE7NvJsytnz2EYLj4L3C+
         1IKkjOQBDwmK/deWCh2SQaK09NFOztsKFqKQKatz0RuUBuyAIUgpI+OvSQIFFOsN5+Rg
         3RyQKT1jEcHMIxzha/v6t2N4NmM7lLspvd00ldl46Yqxvou7ltkPv/S0DHeg7zG2khrT
         DumEcogKSacoSV1ZfgfVffPg9NOlon5yWKSsolmdpWVb0sWmP2qhpf9dEc+fZZ1k4KOM
         t5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763384081; x=1763988881;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0PeYkxx4r+5jJsF9hbC2hTxYP/y6FVcRV15IQ6oSzc=;
        b=uSMWWHLsYKhoEvRkowCTtlEd34ss7TDF5+BqREHat5qLGTauxkjeBp5huR5+CAq3Ye
         YKdCuuWURpasejIHHwCl/8yIJ4YhLlqNupzjIO4QumwpMXrATW+RUpc7cbk5P1A4+xUW
         P1wJZ0OvDF7b9nthzVaJG/bpITv8mcA6GHJb9uo7uhmgVWw7ZCstTn1k2weyNJ5228K5
         E9AUmW2qmvtD3R4Jeia/bEXkTSYty5/n4c5RSSsdT67jFuqGiSuxqk5MFvoKOjpZMaPR
         w9q9ifnbTox4ZiZWz0Jk+duBlU4FZ7EzHGle12SNbX8KGWhwn8V2Os3kIHoinduDDAa3
         s3tA==
X-Forwarded-Encrypted: i=1; AJvYcCUJM8t+5oz0AEI4N2h+dEHrNg7Zp7YI5DuKvJauLQr0iSFOwGoxbgpw/vatsnAkGZjaJ6M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx48IakM+7eVJ+Zz3VEgZziGIhJI/iuDTwyoaXnzPQ46Wly7XB
	vUIav+S8kZqyyy1IAETCnmqlQ0SFF9Qinmsi+8kQSJnCMPqVqFadbc52yOj8Ew24ju3TnFn1ymU
	Q7spgB0EiCuQ4sO6ovsq6bXzRdHGInkaU7A/yz47k
X-Gm-Gg: ASbGnctVauOPaVzSB3JnZkwVthblF97ie4oL1JC3SuzUD+4ckwT7odjsgst7RZW4lrt
	Ael0W3j4QGBwOPPKKWbm7FtFnvGwQeOJme5ab2qq+c2jnczKO+4Y4RYAgk7AKbLlAatuhYGGAy9
	m8QYsQ4YVLPjXEEMpgYxmo5jP0hK9y3Ws0cW8Ue/AW0R00Egw0CfMv40gXD+aJUnV+s3QUjkimP
	qAvOCf8+oH2ujdpKdUgn0rYoZ+QX2rhWUgVXkLzkqGp8dXS7IlLfz4i+MZDjc0JXmWylRsaDlPs
	ExYn7w==
X-Google-Smtp-Source: AGHT+IGyUPT3wn6gNyvpaQ2io1rn1H6hCVd0hgtsdhKIadTArqZSFCNMUbFtSog8erGv//K0RpdAaxu0Wib8dQEX/+I=
X-Received: by 2002:a05:622a:1a23:b0:4e6:eaea:af3f with SMTP id
 d75a77b69052e-4ee029e00ddmr10626351cf.3.1763384080849; Mon, 17 Nov 2025
 04:54:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <CA+EHjTzudrep2hEno4RPwh8H88txiVYFoU7AyJYVWG9SFSk87Q@mail.gmail.com>
 <867bvpt25u.wl-maz@kernel.org> <CA+EHjTyLGFUDbyr_B1uj5ZpxQA9ypCBy0ZUNRQ8M8VdLmXimnw@mail.gmail.com>
In-Reply-To: <CA+EHjTyLGFUDbyr_B1uj5ZpxQA9ypCBy0ZUNRQ8M8VdLmXimnw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 12:54:04 +0000
X-Gm-Features: AWmQ_bmjMm1Pn-peAzaMdg9UHlblAmHGoqWm7U5eN4zTrXFoNWlFVMWvJb4f2Ww
Message-ID: <CA+EHjTx=sqkOfvoXO-gtAP9oZ+HJnfqFWzeughu+sTv9uJx7zw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 10:18, Fuad Tabba <tabba@google.com> wrote:
>
> Hi Marc,
>
> On Mon, 17 Nov 2025 at 09:54, Marc Zyngier <maz@kernel.org> wrote:
> >
> > Hi Fuad,
> >
> > On Mon, 17 Nov 2025 09:40:47 +0000,
> > Fuad Tabba <tabba@google.com> wrote:
> > >
> > > Hi Marc,
> > >
> > > On Mon, 17 Nov 2025 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > This is a follow-up to the original series [1] (and fixes [2][3])
> > > > with a bunch of bug-fixes and improvements. At least one patch has
> > > > already been posted, but I thought I might repost it as part of a
> > > > series, since I accumulated more stuff:
> > >
> > > I'd like to test this series as well. Do you have it applied in one of
> > > your branches at
> > > https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
> > > , or which commit is it based on?
> >
> > I just pushed a new branch
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vgic-lr-overflow-fixes
> >
> > that is based on -rc5, kvmarm/next, kvmarm-fixes-6.18-rc3 plus these
> > patches. Let me know how this fares for you.
>
> Great! I've applied the pKVM patches on top of it. So far so good.
> I'll test this series more thoroughly and review it as well. Stay tuned...

For this series, and the series that it sits on top of (i.e.,
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vgic-lr-overflow-fixes):

Tested-by: Fuad Tabba <tabba@google.com>

On QEMU, nVHE, hVHE protected mode, and protected VMs (with the latest
Android pKVM patches applied on top).

Thanks,
/fuad

> Cheers,
> /fuad
>
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.

