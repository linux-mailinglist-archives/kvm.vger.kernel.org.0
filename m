Return-Path: <kvm+bounces-32850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BDE69E0C3A
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:36:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DDD6282C72
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9871DE88C;
	Mon,  2 Dec 2024 19:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="RRYBhxz/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C754D1DB527
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 19:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733168203; cv=none; b=QrglLm0YJB1gn7Zj9jHhcRuKDlupt/MBXLwPkfDq2ewplYa9OpiqPHIU8n4+yIhwldSUI5Gk8hQzvPaGLQIkohXSxvitEH8vCpA2NpR1bYadPvJBloysQUDWGgpmUlyvb4iQm8FFC08W3gf3WvViUsgco+3I2hQO2Nn8XckV72I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733168203; c=relaxed/simple;
	bh=PMsUv+q/+JfREQxpfuAbt3/PvDuUR3+8vgcngJw4L0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tMyIIqH19eYCdwh8D8ov+B2XONdLJMSyqNk0y2yNeztwX2QRgo4+cFhM3Axmu0D2Xlm/NfncDZMHnKBP0Ho/3YMf/80J9uzcZkr2Zr0f1p1oMymi6R/614GGSRYJfOXapNPgIFDmJSyNMQxT0Qmwr1E+O45hyCKA3ZDigLNg/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=RRYBhxz/; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id F41B53F182
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733168197;
	bh=W6aZlMtP8KSsoitzGDR7wpyoQGNVRJRxSI2L2J9zakA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=RRYBhxz/VzaVyvozlEwzseCiVrxQKH8vMklgaItHTO30W8MIQ1et1tgHZ1ZFyIci5
	 26dExfxtYqwdeLMzfGxGWTNqG1cN3S0Z/KdO72eNKZLypOltU7Qk2IcUQNh6/pKPOy
	 xGQhdS0yEi1BwGJcganCGg5ooGvKNpn6ts+v/HHQjCBn+tvdphLAyDzM7oNDxCk6V3
	 tZ98GmaoSBdQ0VEzrZqCLxH0aTjiPzVdprolCMNOkPMm/A4yudpCpJo9YP5+G17iKS
	 7cOaGWN7zS36PKXdPhjfoNMeA+6AnQon1IO4LlBefrNpN7yw2q78NeQexBmkhb62No
	 +e9FqWD89/P/w==
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-53de65ce406so3931152e87.1
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 11:36:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733168196; x=1733772996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6aZlMtP8KSsoitzGDR7wpyoQGNVRJRxSI2L2J9zakA=;
        b=dazLajdG22yW37v3QN6t4MfVHVh2IeNTRD7Whp9Xr0FXJz4mKP7yWFiJfXROZOAldY
         /NcBNRRYq6V02pRjYniA5+nZ5GsdtzkZ0DFCNMeiKKcQ/jckA1mnWcJHBIJ0nqLMKEpa
         4GJnPzdVqM5DPeAElRQCknLS/bE/ACnfWILeuPGLCEOxZgQMz6xcvFN376qJBEg96j+7
         UmwAV+oUlOrluTz6WFrMqWMtESEgBJMFtC8ZFDS9j5PU9k3BIBBP/eSzlVRTHheOeyuI
         zqS3AT57NkFLiiHkP2g11sk3iH9w9Y0szs6I8KPy9ADq7EUWFkUmvCGJGJyZWADheekk
         eqRQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6lmpCatMSFdyprGCP3nfEEC75c5Hi1G4w9uhVOX3KFNt52iB/vNsdZSqH5IrbpgUlB/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YztJee3CppLppo5jXxxGhfEGHxxtigftQ/KjUPkCz3pjuKwTs+K
	0Dm2s9iln5fVn7NfjmSEcSStBjzYlp5r4SwCjZvQpvnf1Oj+uvFAsX7otYN49JMDoV+AMPKW+TH
	XwKvVpxX9886Il0YAAviVXengmW/uqCBR2v7mov63zM9p0y7nsf4+N5oWW0nq7z1U0ylRhRaEzp
	gsRCkjYYFYg1MGxR5Ti6n3rGqLgHxp5cCut9tChAUg
X-Gm-Gg: ASbGncto4VzXkOfeaPlIdQsMf2CrLKCSJsUyB+leYnWj2+P8JVU5CY5likcHnCsrhnJ
	0X3FvdBTG7y4Hwkc9fjpML6X1svTQ/A==
X-Received: by 2002:a05:6512:1249:b0:53d:b4ab:13ba with SMTP id 2adb3069b0e04-53df00d953cmr13276679e87.27.1733168196284;
        Mon, 02 Dec 2024 11:36:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGNSC28E6FM3qQ6WZTcAg556PxdrO7zI2Cs8OXWZhXXHB0JJrG1uq2dPIWuLVrFidClqbG+uIzIJVnnP73V5RM=
X-Received: by 2002:a05:6512:1249:b0:53d:b4ab:13ba with SMTP id
 2adb3069b0e04-53df00d953cmr13276668e87.27.1733168195915; Mon, 02 Dec 2024
 11:36:35 -0800 (PST)
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
 <20241127102243.57cddb78.alex.williamson@redhat.com>
In-Reply-To: <20241127102243.57cddb78.alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Mon, 2 Dec 2024 13:36:25 -0600
Message-ID: <CAHTA-uaGZkQ6rEMcRq6JiZn8v9nZPn80NyucuSTEXuPfy+0ccw@mail.gmail.com>
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM boot
 with passthrough of large BAR Nvidia GPUs on DGX H100
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, 
	Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks!

This approach makes sense to me - the only concern I have is that I
see this restriction in a comment in __pci_read_base():

`/* No printks while decoding is disabled! */`

At the end of __pci_read_base(), we do have several pci_info() and
pci_err() calls - so I think we would need to also print that info one
level up after the new decode enable if we do decide to move decode
disable/enable one level up. Let me know if you agree, or if there is
a more straightforward alternative that I am missing.

- Mitchell Augustin


On Wed, Nov 27, 2024 at 11:22=E2=80=AFAM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue, 26 Nov 2024 19:12:35 -0600
> Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
>
> > Thanks for the breakdown!
> >
> > > That alone calls __pci_read_base() three separate times, each time
> > > disabling and re-enabling decode on the bridge. [...] So we're
> > > really being bitten that we toggle decode-enable/memory enable
> > > around reading each BAR size
> >
> > That makes sense to me. Is this something that could theoretically be
> > done in a less redundant way, or is there some functional limitation
> > that would prevent that or make it inadvisable? (I'm still new to pci
> > subsystem debugging, so apologies if that's a bit vague.)
>
> The only requirement is that decode should be disabled while sizing
> BARs, the fact that we repeat it around each BAR is, I think, just the
> way the code is structured.  It doesn't take into account that toggling
> the command register bit is not a trivial operation in a virtualized
> environment.  IMO we should push the command register manipulation up a
> layer so that we only toggle it once per device rather than once per
> BAR.  Thanks,
>
> Alex
>


--=20
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

