Return-Path: <kvm+bounces-32964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F18AA9E2FC3
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 00:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 657A9B2D5A4
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 23:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018BF20B1E1;
	Tue,  3 Dec 2024 23:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="jQtG7Bkf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A18207A3E
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 23:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733267365; cv=none; b=UwHTgesqGYYRAt/U2w+eP0b4otQ28g8WHYctl9DBTJNADaTcr3fEpYNXrJWNBkwljMni+oVaKHoW1OlW91o/qiXLnJuH2tP5PxY/k6G7k7HH9z/kTU7MnvRLIr6PCNPpXmrkDHT0po9UwA7RsXTuMlfi2GH87bYrFyljh+Hl3Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733267365; c=relaxed/simple;
	bh=463OO+a1qAHyjW2ZZ+OYe+cOM0s/qFghP2piUoJLCsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GYpvyMh1dxNL4hJXVBKg7S1Hhlbr2z/JWfLx8BOBkkuVUjlxqJ2tHK4Lb62fQ6Kaz/35RZhqLbwaOF8X9WMelHYDCTYIlbj6Yhu5D+5rvXlCX0EJRnB5w45V7Q8un4V3nBmbDBxoFnrWnc1PuHo2V2Wv3cjoXig2Egbp8o/+0uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=jQtG7Bkf; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 50C593F5AA
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 23:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733267360;
	bh=vfjen1DyciWCYS6b4BMbyu8Mff3purGah6xy+CqllBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=jQtG7BkfBICgNklYxKa+ZM8aPCUmG5WLb8QSldYBHNu8/nyel2gm6zHG/AuiYqNsx
	 BGKayFhimxVDteqIMT+YkbfNJK7TYaxkBiiOIhV4G/4qBoS0k/WdGb3JKe56Wttt6/
	 +Q6gcYQrRl5RP/LLrzGxBWQ+E6Q7dwXatimMBE0dSmQDacShPJIwG5PXCqf/jKykJ6
	 NSQDO0zpoBr/KWRJhD1HZTzoQomVGz76+oizg3bJ/70Ry7LwFk60SVudvV3VvvJL0m
	 dm1nqwUicrZPZHXX46yRUdOXwewg7D0tTXk+LZA9Kc8gpoxyEZwCdJP7MT/GM17QvS
	 GoN5eHZZHv0Lw==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa529e35844so28135066b.0
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 15:09:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733267359; x=1733872159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfjen1DyciWCYS6b4BMbyu8Mff3purGah6xy+CqllBA=;
        b=nbMtW+WOVhoyPKRh89Ho8VR6zg8W5gmBlhS0sy/FzTG0mGhZ0kQXa4UWulpvdxu/1L
         K3Tndu9dK+t5zBqBT41zzCID8Gpi2WWF25cBv5E8b8dqmwTUTUMqaT0YzVZR0wBRy1+F
         0IcxRCT47jN9eWQSeje7Y6g5PFP5qI7zeJxaxBtCEygdVn0I//NlI8vzRaQAqQajpNOH
         ghznKl3OF+0gETM5XeR7AxCbcFtRiuEha/xUJ9F+/uKw5rEbEuC95NZe1742LWQmY7Uj
         7H0PTLUv8nQk4T+gOynJvpg97O9w68BS4qdtHzhKomubls4CMQ+um/dGKo9DtmZQRorI
         ZgAA==
X-Forwarded-Encrypted: i=1; AJvYcCXWTvDUvA+KlC7CJ0RckRjziCqGlNFS466IjCPUKJ+OgZ0XP/ZWqa07Ov8YkqXwiQN7KPU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1erkAWUxYz56qaeL+tFOnK8YCcHJBuKYD4oRBPt4Sr1eR70bN
	dwBPnK/uHuGWPXZF8E3Zc7bqnqCLDmpekvAdeMftaHrXiuWDdYUAPKqFT/LkWpt5dPnvHMXNUXC
	DmaHLm7BNuBpogF6ilvKt51EqXdLjmkpQrI8mK7eVe7gvdvPqK/OZ4pxP/CT7emmiOlRCQCal5J
	jzFRvOBnYvKy7f81WcE9pjFH55UitYOmIU8rrFo3UE
X-Gm-Gg: ASbGncu8YVc4FSEky/qGJxPVjkjFaeaF5rGo+C9drrvj4d5z+dhw7EQklNP8NSvcdbO
	R/BLMuQuNvVxc2PIIA8BFi3UguTM0sA==
X-Received: by 2002:a05:6402:449b:b0:5d0:9c4f:4945 with SMTP id 4fb4d7f45d1cf-5d10c26d561mr4050277a12.11.1733267358885;
        Tue, 03 Dec 2024 15:09:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHN/ATHTPZJ9bM2/jaipzxIwMyq5dvGI0c6nWnaWDSNV62dClGUtj4eq9eqe8U0Ivpo7Px3/z2aGmqZ7bDCp6U=
X-Received: by 2002:a05:6402:449b:b0:5d0:9c4f:4945 with SMTP id
 4fb4d7f45d1cf-5d10c26d561mr4050267a12.11.1733267358506; Tue, 03 Dec 2024
 15:09:18 -0800 (PST)
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
 <20241203150620.15431c5c.alex.williamson@redhat.com>
In-Reply-To: <20241203150620.15431c5c.alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Tue, 3 Dec 2024 17:09:07 -0600
Message-ID: <CAHTA-uZD5_TAZQkxdJRt48T=aPNAKg+x1tgpadv8aDbX5f14vA@mail.gmail.com>
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM boot
 with passthrough of large BAR Nvidia GPUs on DGX H100
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, 
	Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the suggestions!

> The calling convention of __pci_read_base() is already changing if we're =
having the caller disable decoding

The way I implemented that in my initial patch draft[0] still allows
for __pci_read_base() to be called independently, as it was
originally, since (as far as I understand) the encode disable/enable
is just a mask - so I didn't need to remove the disable/enable inside
__pci_read_base(), and instead just added an extra one in
pci_read_bases(), turning the __pci_read_base() disable/enable into a
no-op when called from pci_read_bases(). In any case...

> I think maybe another alternative that doesn't hold off the console would=
 be to split the BAR sizing and resource processing into separate steps.

This seems like a potentially better option, so I'll dig into that approach=
.


Providing some additional info you requested last week, just for more conte=
xt:

> Do you have similar logs from that [hotplug] operation

Attached [1] is the guest boot output (boot was quick, since no GPUs
were attached at boot time)

Here is what I see when I enable a single GPU (takes 1-3 seconds):
[Dec 3 22:53] pci 0000:09:00.0: [10de:2330] type 00 class 0x030200 PCIe End=
point
[  +0.000526] pci 0000:09:00.0: BAR 0 [mem 0x00000000-0x00ffffff 64bit pref=
]
[  +0.000237] pci 0000:09:00.0: BAR 2 [mem 0x00000000-0x1fffffffff 64bit pr=
ef]
[  +0.000212] pci 0000:09:00.0: BAR 4 [mem 0x00000000-0x01ffffff 64bit pref=
]
[  +0.000275] pci 0000:09:00.0: Max Payload Size set to 128 (was 256, max 2=
56)
[  +0.000453] pci 0000:09:00.0: Enabling HDA controller
[  +0.003052] pci 0000:09:00.0: 252.048 Gb/s available PCIe bandwidth,
limited by 16.0 GT/s PCIe x16 link at 0000:00:02.0 (capable of 504.112
Gb/s with 32.0 GT/s PCIe x16 link)
[  +0.003327] pci 0000:09:00.0: BAR 2 [mem
0x384000000000-0x385fffffffff 64bit pref]: assigned
[  +0.000258] pci 0000:09:00.0: BAR 4 [mem
0x386000000000-0x386001ffffff 64bit pref]: assigned
[  +0.000311] pci 0000:09:00.0: BAR 0 [mem
0x386002000000-0x386002ffffff 64bit pref]: assigned
[  +0.000993] nvidia 0000:09:00.0: enabling device (0140 -> 0142)

And below[2] is the output of /proc/iomem after I have done that
process 4 times (GPUs are 0000:08, 0000:09, 0000:0a, 0000:0b)

[0] https://raw.githubusercontent.com/MitchellAugustin/script-dump-public/r=
efs/heads/main/slow-ovmf-case/patches/0001-Move-decode-disable-enable-up-on=
e-level-and-add-kern.patch
[1] https://pastebin.ubuntu.com/p/T4myPSQSJ5/
[2] https://pastebin.ubuntu.com/p/GD2WtkW9Gq/

Other info:
Guest:
ubuntu@testbox02:~$ cat /proc/cmdline
BOOT_IMAGE=3D/boot/vmlinuz-6.12.1
root=3DUUID=3Dfec1c9ae-0df3-419c-80dd-f3035049b845 ro console=3Dtty1
console=3DttyS0

Host (DGX H100):
$ cat /proc/cmdline
BOOT_IMAGE=3D/boot/vmlinuz-6.12.0+
root=3DUUID=3Dbb04f707-1c00-4806-8adb-cf9eb876786f ro
console=3DttyS0,115200n8 iommu=3Dpt init_on_alloc=3D0

-  Mitchell Augustin

On Tue, Dec 3, 2024 at 4:06=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue, 3 Dec 2024 14:33:10 -0600
> Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
>
> > Thanks.
> >
> > I'm thinking about the cleanest way to accomplish this:
> >
> > 1. I'm wondering if replacing the pci_info() calls with equivalent
> > printk_deferred() calls might be sufficient here. This works in my
> > initial test, but I'm not sure if this is definitive proof that we
> > wouldn't have any issues in all deployments, or if my configuration is
> > just not impacted by this kind of deadlock.
>
> Just switching to printk_deferred() alone seems like wishful thinking,
> but if you were also to wrap the code in console_{un}lock(), that might
> be a possible low-impact solution.
>
> > 2. I did also draft a patch that would just eliminate the redundancy
> > and disable the impacted logs by default, and allow them to be
> > re-enabled with a new kernel command line option
> > "pci=3Dbar_logging_enabled" (at the cost of the performance gains due t=
o
> > reduced redundancy). This works well in all of my tests.
>
> I suspect Bjorn would prefer not to add yet another pci command line
> option and as we've seen here, the logs are useful by default.
>
> > Do you think either of those approaches would work / be appropriate?
> > Ultimately I am trying to avoid messy changes that would require
> > actually propagating all of the info needed for these logs back up to
> > pci_read_bases(), if at all possible, since there seems like no
> > obvious way to do that without changing the signature of
> > __pci_read_base() or tracking additional state.
>
> The calling convention of __pci_read_base() is already changing if
> we're having the caller disable decoding and it doesn't have a lot of
> callers, so I don't think I'd worry about changing the signature.
>
> I think maybe another alternative that doesn't hold off the console
> would be to split the BAR sizing and resource processing into separate
> steps.  For example pci_read_bases() might pass arrays like:
>
>         u32 bars[PCI_STD_NUM_BARS] =3D { 0 };
>         u32 romsz =3D 0;
>
> To a function like:
>
> void __pci_read_bars(struct pci_dev *dev, u32 *bars, u32 *romsz,
>                      int num_bars, int rom)
> {
>         u16 orig_cmd;
>         u32 tmp;
>         int i;
>
>         if (!dev->mmio_always_on) {
>                 pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
>                 if (orig_cmd & PCI_COMMAND_DECODE_ENABLE) {
>                         pci_write_config_word(dev, PCI_COMMAND,
>                                 orig_cmd & ~PCI_COMMAND_DECODE_ENABLE);
>                 }
>         }
>
>         for (i =3D 0; i < num_bars; i++) {
>                 unsigned int pos =3D PCI_BASE_ADDRESS_0 + (i << 2);
>
>                 pci_read_config_dword(dev, pos, &tmp);
>                 pci_write_config_dword(dev, pos, ~0);
>                 pci_read_config_dword(dev, pos, &bars[i]);
>                 pci_write_config_dword(dev, pos, tmp);
>         }
>
>         if (rom) {
>                 pci_read_config_dword(dev, rom, &tmp);
>                 pci_write_config_dword(dev, rom, PCI_ROM_ADDRESS_MASK);
>                 pci_read_config_dword(dev, rom, romsz);
>                 pci_write_config_dword(dev, rom, tmp);
>         }
>
>         if (!dev->mmio_always_on && (orig_cmd & PCI_COMMAND_DECODE_ENABLE=
))
>                 pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
> }
>
> pci_read_bases() would then iterate in a similar way that it does now,
> passing pointers to the stashed data to __pci_read_base(), which would
> then only do the resource processing and could freely print.
>
> To me that seems better than blocking the console... Maybe there are
> other ideas on the list.  Thanks,
>
> Alex
>


--
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering
Email:mitchell.augustin@canonical.com
Location:United States of America


canonical.com
ubuntu.com

