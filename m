Return-Path: <kvm+bounces-33182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E07949E61C6
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 01:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B761B165E15
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 00:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22F153A7;
	Fri,  6 Dec 2024 00:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="bItsGeZk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193A51FDD
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 00:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733443763; cv=none; b=agGZYhEysUxLCmsBoL2VjH4KWkECGM8bPwAKZeuU6ZcuS1d1FZXz1AU8WKnPzGjHrpOTm7Wu8/yKBTKvPxlmQjfhN+xD5ruCEyPFPXWPWDILNN8fh7fiYD1SAyzr7QtGpcXYPthqmYry3FNFZhizURCyqDG4MQbEp8JYL4UBcdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733443763; c=relaxed/simple;
	bh=dBA47SUie5SwFd03yBmEyKgEIejEfXGA+UqqvehwusI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DLsAnnhJdQU9uRl0hhYBA4F68BFQOiCBS1q7UEsHjSXHY6RdeW4CnRyDAHladrx0UhgtEtA6mRc5myC81wRS6kSKuCtkljHlCDnYW8ld1Ke6+eh3Yb1Ed8Mxu+HSs7x6SHUh+SE+HEne2FH9Xqa6VFZ0xjSaF9JFIAqs0X7qhNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=bItsGeZk; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 668D540CE4
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 00:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733443760;
	bh=sMurqy6Z4XssLascAqYWalpe3jcOC1OWrus+pdaK60E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=bItsGeZkQk2QihqDXKQmGXwFzGQIM6iTmVa/ZWLaMimwsamNsR5rFuSPdt0Jq19V+
	 mQiK0dCOxO7y5A7Ld0UftNWgJ/a021OsNs6oLOnmti/pU1fcdjvHQBPvqFOiRUjxZ5
	 3tiq6jvmo0DX6DteowQ7aCE0QDQBinpDwHM1QSedCIEWM44YDeiLpIWCH4Qq57w0YS
	 WJHvkHXcs/CZ8xhCWtGm0yiECwxuHB91MhwDGYqCzy6G/5i4ixVpQOpBCF7+/2GHjn
	 D7ZfJw3UY3BEiY+v9OX5AMWa5yVqATSkJvT0F7UzE/Hm6zz9eKfGH+fk0d1r+TsEpT
	 CY3CLD5kx6rOA==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5d3c284eba0so141203a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 16:09:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733443759; x=1734048559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sMurqy6Z4XssLascAqYWalpe3jcOC1OWrus+pdaK60E=;
        b=MDNf10gmUBsUI0sWzOiIqlwGsi4c01mJ6RCtCaBE9/x7p9/USVTKPI0vsjNCb9kFn1
         klKVqoJvXVHfZKUBbkEUJp3Uf88UnIP6WO16DK7NZyu1rHUZeRxUHYLmGh6o7x56m4+M
         XRf6IZ6V1UXK4+SGKnME12CJTDpHnt2Ppyg3nQIB7tzaTKYYiALcVsVbhVVRng4njE8s
         Hcz/fiMI5jBr4jA9nYDZ34A2H5hLs82RdlC5iebeGdtESSPvhTcIO9cr+Je7wcoXJIbe
         lYVFLDB0rxeF2IodSXZ8yDOLdsdnfMepvBkXaJkCsizXCK/mtJDy946Y+B32+HXYsAGz
         8jug==
X-Forwarded-Encrypted: i=1; AJvYcCVaEn5J25NM8i8LVqIWzdKLUtPL9rzJiW2byOPO+PGPmrjHUeY6gmDIew7+QRk3zgdlGWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpnHzdQ0ZdILI5D2ZMWHd8Gi9eCWZKpGEuYZc8yD543vnreOZU
	KhXYid2vlTRISPGdjVCI5SiLrLwhcG12RDVTfcq3gJ4FRIwmJXqaoZfIjrzy2q0qmduPCmNA05w
	DJpiRrs25UUnmekxj4LSDk39gKjx2IOYo61Fcq537DigchQ6hlRIYepi+VFk6JSCLyaxCXCVbbu
	G6YmbCPPrSWCNs8Wxxw7XhdvG5aJAGFZDpIy7yD/DLo2c8gcfauSk=
X-Gm-Gg: ASbGncscM14dRmMsG/dzqlgzswXXGdEfEAJrSjg2jZqs0qh4DKQhrTb1E/uZMM/5I2y
	yCn2LNwAFsN70jOuYDwSff2iZVB1H0DjiWg==
X-Received: by 2002:a05:6402:380f:b0:5d0:849c:71c3 with SMTP id 4fb4d7f45d1cf-5d3be466d4fmr1063013a12.0.1733443759489;
        Thu, 05 Dec 2024 16:09:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXpaP6nHDJsgYgKmHtFKSLgJ8MxPTVUzP/aApdPIDtegMmgfU+nkDdyPlw7Ek4gZHguQ66qgFYOTW+lnJYTqI=
X-Received: by 2002:a05:6402:380f:b0:5d0:849c:71c3 with SMTP id
 4fb4d7f45d1cf-5d3be466d4fmr1062984a12.0.1733443759183; Thu, 05 Dec 2024
 16:09:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
 <20241126103427.42d21193.alex.williamson@redhat.com> <CAHTA-ubXiDePmfgTdPbg144tHmRZR8=2cNshcL5tMkoMXdyn_Q@mail.gmail.com>
 <20241126154145.638dba46.alex.williamson@redhat.com> <CAHTA-uZp-bk5HeE7uhsR1frtj9dU+HrXxFZTAVeAwFhPen87wA@mail.gmail.com>
 <20241126170214.5717003f.alex.williamson@redhat.com> <CAHTA-uY3pyDLH9-hy1RjOqrRR+OU=Ko6hJ4xWmMTyoLwHhgTOQ@mail.gmail.com>
 <20241127102243.57cddb78.alex.williamson@redhat.com> <CAHTA-uaGZkQ6rEMcRq6JiZn8v9nZPn80NyucuSTEXuPfy+0ccw@mail.gmail.com>
 <20241203122023.21171712.alex.williamson@redhat.com> <CAHTA-uZWGmoLr0R4L608xzvBAxnr7zQPMDbX0U4MTfN3BAsfTQ@mail.gmail.com>
 <20241203150620.15431c5c.alex.williamson@redhat.com> <CAHTA-uZD5_TAZQkxdJRt48T=aPNAKg+x1tgpadv8aDbX5f14vA@mail.gmail.com>
 <20241203163045.3e068562.alex.williamson@redhat.com>
In-Reply-To: <20241203163045.3e068562.alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Thu, 5 Dec 2024 18:09:08 -0600
Message-ID: <CAHTA-ua5g2ygX_1T=YV7Nf1pRzO8TuqS==CCEpK51Gez9Q5woA@mail.gmail.com>
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM boot
 with passthrough of large BAR Nvidia GPUs on DGX H100
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, 
	Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I submitted a patch that addresses this issue that I want to link to
in this thread:
https://lore.kernel.org/all/20241206000351.884656-1-mitchell.augustin@canon=
ical.com/
- everything looks good with it on my end.

-Mitchell Augustin


On Tue, Dec 3, 2024 at 5:30=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue, 3 Dec 2024 17:09:07 -0600
> Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
>
> > Thanks for the suggestions!
> >
> > > The calling convention of __pci_read_base() is already changing if we=
're having the caller disable decoding
> >
> > The way I implemented that in my initial patch draft[0] still allows
> > for __pci_read_base() to be called independently, as it was
> > originally, since (as far as I understand) the encode disable/enable
> > is just a mask - so I didn't need to remove the disable/enable inside
> > __pci_read_base(), and instead just added an extra one in
> > pci_read_bases(), turning the __pci_read_base() disable/enable into a
> > no-op when called from pci_read_bases(). In any case...
> >
> > > I think maybe another alternative that doesn't hold off the console w=
ould be to split the BAR sizing and resource processing into separate steps=
.
> >
> > This seems like a potentially better option, so I'll dig into that appr=
oach.
> >
> >
> > Providing some additional info you requested last week, just for more c=
ontext:
> >
> > > Do you have similar logs from that [hotplug] operation
> >
> > Attached [1] is the guest boot output (boot was quick, since no GPUs
> > were attached at boot time)
>
> I think what's happening here is that decode is already disabled on the
> hot-added device (vs enabled by the VM firmware on cold-plug), so in
> practice it's similar to your nested disable solution.  Thanks,
>
> Alex
>


--=20
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

