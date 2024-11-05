Return-Path: <kvm+bounces-30818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C033A9BD800
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 23:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FFD3283D9A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 22:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95617216A09;
	Tue,  5 Nov 2024 21:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wh82oD+E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02972161F6
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 21:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843790; cv=none; b=m+js8D4hrJ0qkm240r46JBek2RqAFOcEawNrhl18MBmrRqV7UvU5ZtGiulbMUb9S+bSbaB+swXPpj9oBjyCPKI/v/Q6nRASFT+kT1WcgwQXbEtOKN81vKhvkv6vvB5cBm1Aeg0G6ApYso2BGDmPAR+Dw9mL6qioGkQM81Hbq8TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843790; c=relaxed/simple;
	bh=pVej0gBt4tUYgFnrRPfvfJ1Kuat+zoGImUSeqO9gRwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=unpkMQWeUd+uXWBvuiK8L00CGjE3pU22CLgzwfKsGE13I9HwHdosBiZSWP9xDv10E8EclMWcCzgKMcC+WA813GTBAnlJNeOEJUyhWQmyZnVgK18CyTbXdPpn0yPQplYyhdnR9eX2HbEaqsb//w2lMguIeaJzjbckf7mjZhc1Y1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wh82oD+E; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539f72c8fc1so6185028e87.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 13:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730843787; x=1731448587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wXtAUZpo/eZv9N34VGkN0x5RoW3L2kZwJ65Z3JqvyA=;
        b=wh82oD+EedRwKpPmY6lE/xH5FmurbIC1hGDqLxCmF+Y2xb3m7y7/rMmXV1pDx8S7ge
         ApAx05d4ps01bOq0yt7dP+GgNBjPpTEYaSKsOjwsHSdb057WODK1ii7oBGQ6h8KM113o
         vVXgKvrgR+pnXwZrFLz6wwsmEK3BgfrskFl6O4zUpsNN5jXKhtg+0bmUxieDL44PU382
         8GDcIALNnukLmxL1QT0QKikA/2nrBGR370mxciY5Z1/wCtrjsAyQnPzdc9kbEJFGRuhQ
         ve7lZKeqx04Ejm6ez3+dGBg+nDzUHMWvlXZHmHFtWVZcSR9J2K99nAE2wnnok3KyGifl
         mfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730843787; x=1731448587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5wXtAUZpo/eZv9N34VGkN0x5RoW3L2kZwJ65Z3JqvyA=;
        b=c8uQYB+On8z++uPVKg6o/KW7jnIJGpW5ixsglBsLGmm+DDuBjQC06VilrilyL7xG2q
         LomRK+btA/syvSrPX/V0od82AxcyLNrtkei33pOsZpAsJTHEadZm9x8R8NqlHKFmSuUO
         vjxRHsnB0EAThZ+xmmXINC8JB/PaQycIGeYPQYjywyM0TDAsVat2mmuGK2NS8+IpIr7M
         Rv2ezIeOy+QbpE249E6jK/OVFBCPKlVMth5DwPEbAC80QwO6cyNNAmiYwR15cDaPcRmV
         d/LcxOHDIOOj7SwagKoyG9ChUtNqwsI4CLvl6ycybKSQu2m7BA2g16bVv0JdrX+TbUmb
         bdqw==
X-Gm-Message-State: AOJu0Yw9PjMx7eCAU3cZjjb8KsGXcoyHu3JrI3xbopZ5AH+a3alLTLtr
	meRg2Gd1bnoQdDb5d851KP/rTxRq+etSD9kLBzxy3BbBOKMop4sszeaDubMj7O5QXnRis1Ankx1
	vGoM14Nso0+dch9Ve6mZzdEYw5zSlCC1N0AQP
X-Google-Smtp-Source: AGHT+IG1+f/ZA6qSL99d7qn8w74pDe+0ftoUHGp5Hxjh0+8ykvXijLN2604KYOE83QwClmrIDEAPur/UKnYI6c3tcfY=
X-Received: by 2002:a05:6512:31cc:b0:531:4c6d:b8ef with SMTP id
 2adb3069b0e04-53b7ecd5232mr14841438e87.6.1730843786817; Tue, 05 Nov 2024
 13:56:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105193422.1094875-1-jingzhangos@google.com> <ZyqPMdH4anLEIq8G@linux.dev>
In-Reply-To: <ZyqPMdH4anLEIq8G@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 5 Nov 2024 13:56:14 -0800
Message-ID: <CAAdAUthd+c71BTSEvQvCZoYE2vQPHabofK=947MspU1hUbZd+w@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] Fix a bug in VGIC ITS tables' save/restore
To: Oliver Upton <oliver.upton@linux.dev>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 1:33=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Jing,
>
> On Tue, Nov 05, 2024 at 11:34:18AM -0800, Jing Zhang wrote:
> > The core issue stems from the static linked list implementation of DTEs=
/ITEs,
> > requiring a full table scan to locate the list head during restoration.=
 This
> > scan increases the likelihood of encountering orphaned entries.  To rec=
tify
> > this, the patch series introduces a dummy head to the list, enabling im=
mediate
> > access to the list head and bypassing the scan. This optimization not o=
nly
> > resolves the bug but also significantly enhances restore performance,
> > particularly in edge cases where valid entries reside at the end of the=
 table.
>
> I think we need a more targeted fix (i.e. Kunkun's patch) to stop the
> bleeding + backport it to stable.
>
> Then we can have a separate discussion about improving the save/restore
> performance with your approach.

Yes, I'll respin Kunkun's patch soon. This patch series has the
selftest which we can use for verification.

>
> --
> Thanks,
> Oliver

Thanks,
Jing

