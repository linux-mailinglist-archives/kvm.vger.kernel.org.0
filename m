Return-Path: <kvm+bounces-32551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DBB59DA036
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 02:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B4A0168DCB
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 01:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8400417BA2;
	Wed, 27 Nov 2024 01:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="SuyDNn85"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE55D517
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 01:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732669978; cv=none; b=N6fe1jV68n7tCIC1No9Ihvwz37vO61KzOrR6KhrWWwjoS9XHP252oUR3NeBKeHAY+eu8WVGYTtoG0sta/YTSuIc3WGhWZmhJEZKcElnzKnNnriIpMQpLyxPUuKb62vtMGH47LTBisO/uMI6qc9go+1NV/sTIzjr+jMX9Mq2bYrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732669978; c=relaxed/simple;
	bh=rlw6BsP41qktvgONAhckkofkmHGNuVpuOiku3TqLoyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IYg4ysPuTJXCUTlI2qQat7sfymfuQII+Dw46s0uSB0kof6UOETqpIMjWtE9wLQ98rkj4mN/FRRqYo151hghF/Wdl3qB1ZnXyDLaNkB7KrHVHh5Tg2//UWVZNwcy/ZsrtD+vZx0y/zevIrQyPmqt72wDidWSLBiYQcVUYRH0OVH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=SuyDNn85; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id ADED63F84E
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 01:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1732669967;
	bh=emLdlzV24ZXPWmM+1uTUzl+E1HasPXmzXxKP0BDcmLY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=SuyDNn85L0/ednnoGs8G+goA6Msc0ucNCSK8M+PSGoi+AXaWjxJcKUhI7L1xz5V2O
	 1GhPHEdf6bu/a68I0kTQSylYixSaNE/Ea8UepQY5JKvgSlaxvJGj7yUTeqH/WcGI65
	 0jDldm1bAFUZbqxgwk+tb18GvZApukmHif4LyDeVIXZS7CwJmBaIAlBWGE3crfKmHf
	 jascIecvsEn8Ep0RTII0is0USlmClN+WXXJ4QJy7iBsF+B2mjgQWaqIMMcK/LcZ63M
	 X7aJsEJkym1LaW7NcW492+ovzfWQiXg22aevNezWvogYMSA11u+gBG/aD/EU2E7RBw
	 qPVxpql13YXFQ==
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5cfbceb7c95so4359466a12.1
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 17:12:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732669967; x=1733274767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=emLdlzV24ZXPWmM+1uTUzl+E1HasPXmzXxKP0BDcmLY=;
        b=t+uVN01OOqrhnZdk2kTF372ZAeb1Jm/xHvh41Y/fMYmcoNOzqodlqNhVtY4T0rWjhV
         pgEsClCoSjYrTAGlN7ZegfGFj8JpR90g4Ai96ushA+BKkyaJ7mPGSPACJT6a0/PGaW/D
         /ef8JVm1fRf39N2wCozQQ96GB/b+xp1CM2WsyIkMgZQnyv8S/PJiCTdGKdhi1K3q1C2y
         /RZc8NlWjLoklN3znlipTM2zDJBl0sOxWXxBnS/B/WsWLWKsJdEgUCT9xuFqeM2qCbaY
         DihOLxSGf+GmBdjDa6RdzNoQY1Q5kXQtAQz9pT5tmU2ASfiQOXaubBvInYvaMkCeaS6y
         FifA==
X-Forwarded-Encrypted: i=1; AJvYcCVH1cJDYPFyF+zA/uoIewdQTe0gPq+l/HwMxtdxsxtumf/Z6fKbvrJz2OkKpsqD1aPf+gQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLIBhdoPLiIeng4omO/4HtKKup8de9Pf8QFMb6hYNG7QMqjMhW
	r0Qxbt4nZ7ei+j12O8HzsphQjwKKWiUvzBEQ7qwMTrIj3xVhWPqlNn5B7e7P1MID7rp/BXxlPU8
	33yKn+64GNrmAyqhzKHMGL7/Ig2ie5n8PN87NCzGwi8tKq8VHanO2GkYpt+5YYKYox9Uqex7PgN
	8Fy4RXp0rIu+wP0VHIj08iktaiN4qAQgatZrGZ6J0x
X-Gm-Gg: ASbGncuk6DcP9cSU/2RjXOIncqnK/D2UrCKmFxlB1zrOyrMXEzgAjE8T9TAshRap+QL
	0BfRbR4/08Se+G9ftgqRT8hgKIjcyRA==
X-Received: by 2002:a05:6402:40c6:b0:5cf:e022:24f5 with SMTP id 4fb4d7f45d1cf-5d080b82618mr1080518a12.2.1732669967160;
        Tue, 26 Nov 2024 17:12:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6W121jcxkpFUg90yrNTWdDCba+5ztEdVQdxcMY2Qr3+0ktsSwG+kJX5oFFVSbUt+54ChMm8gsKjDWnlyeV24=
X-Received: by 2002:a05:6402:40c6:b0:5cf:e022:24f5 with SMTP id
 4fb4d7f45d1cf-5d080b82618mr1080507a12.2.1732669966755; Tue, 26 Nov 2024
 17:12:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
 <20241126103427.42d21193.alex.williamson@redhat.com> <CAHTA-ubXiDePmfgTdPbg144tHmRZR8=2cNshcL5tMkoMXdyn_Q@mail.gmail.com>
 <20241126154145.638dba46.alex.williamson@redhat.com> <CAHTA-uZp-bk5HeE7uhsR1frtj9dU+HrXxFZTAVeAwFhPen87wA@mail.gmail.com>
 <20241126170214.5717003f.alex.williamson@redhat.com>
In-Reply-To: <20241126170214.5717003f.alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Tue, 26 Nov 2024 19:12:35 -0600
Message-ID: <CAHTA-uY3pyDLH9-hy1RjOqrRR+OU=Ko6hJ4xWmMTyoLwHhgTOQ@mail.gmail.com>
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM boot
 with passthrough of large BAR Nvidia GPUs on DGX H100
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, 
	Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the breakdown!

> That alone calls __pci_read_base() three separate times, each time disabl=
ing and re-enabling decode on the bridge. [...] So we're really being bitte=
n that we toggle decode-enable/memory enable around reading each BAR size

That makes sense to me. Is this something that could theoretically be
done in a less redundant way, or is there some functional limitation
that would prevent that or make it inadvisable? (I'm still new to pci
subsystem debugging, so apologies if that's a bit vague.)

> Do you have similar logs from that operation?

IIRC the log output from the hotplugs looked similar (and were much
faster), but I didn't save them. I will collect those and full guest
boot logs next time I am on the H100.

Thanks,

On Tue, Nov 26, 2024 at 6:02=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue, 26 Nov 2024 17:08:07 -0600
> Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
>
> > > If the slowness is confined to the guest kernel boot, can you share t=
he log of that boot with timestamps?
> >
> > It is confined to the guest. On hand, I have this log section from a
> > past guest boot:
> >
> > [    3.965790] pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000
> > conventional PCI endpoint
> > [    3.967800] pci 0000:00:01.0: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [    3.974590] pci 0000:00:01.0: BAR 0 [mem 0x81c8e000-0x81c8efff]
> > [    3.980780] pci 0000:00:01.0: PCI bridge to [bus 01]
> > [    3.984128] pci 0000:00:01.0:   bridge window [mem 0x81a00000-0x81bf=
ffff]
> > [    3.985915] pci 0000:00:01.0:   bridge window [mem
> > 0x38e800000000-0x38efffffffff 64bit pref]
> > [    3.988884] pci 0000:00:01.1: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [    3.992771] pci 0000:00:01.1: BAR 0 [mem 0x81c8d000-0x81c8dfff]
> > [    3.999361] pci 0000:00:01.1: PCI bridge to [bus 02]
> > [    4.000276] pci 0000:00:01.1:   bridge window [mem 0x81800000-0x819f=
ffff]
> > [    4.001849] pci 0000:00:01.1:   bridge window [mem
> > 0x38f000000000-0x38f7ffffffff 64bit pref]
> > [    4.009442] pci 0000:00:01.2: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [    4.012772] pci 0000:00:01.2: BAR 0 [mem 0x81c8c000-0x81c8cfff]
> > [    4.016781] pci 0000:00:01.2: PCI bridge to [bus 03]
> > [    4.020299] pci 0000:00:01.2:   bridge window [mem 0x81600000-0x817f=
ffff]
> > [    4.021780] pci 0000:00:01.2:   bridge window [mem
> > 0x38f800000000-0x38ffffffffff 64bit pref]
> > [    4.024680] pci 0000:00:01.3: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [    4.027299] pci 0000:00:01.3: BAR 0 [mem 0x81c8b000-0x81c8bfff]
> > [    4.036781] pci 0000:00:01.3: PCI bridge to [bus 04]
> > [    4.037646] pci 0000:00:01.3:   bridge window [mem 0x81400000-0x815f=
ffff]
> > [    4.040806] pci 0000:00:01.3:   bridge window [mem
> > 0x390000000000-0x3907ffffffff 64bit pref]
> > [    4.046317] pci 0000:00:01.4: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [    4.049673] pci 0000:00:01.4: BAR 0 [mem 0x81c8a000-0x81c8afff]
> > [    4.053625] pci 0000:00:01.4: PCI bridge to [bus 05]
> > [    4.056830] pci 0000:00:01.4:   bridge window [mem 0x81200000-0x813f=
ffff]
> > [    4.059022] pci 0000:00:01.4:   bridge window [mem
> > 0x390800000000-0x390fffffffff 64bit pref]
> > [    4.061614] pci 0000:00:01.5: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
>
> The above line is printed from pci_setup_device() which calls
>
> pci_read_bases(dev, 2, PCI_ROM_ADDRESS1);
>
> That alone calls __pci_read_base() three separate times, each time
> disabling and re-enabling decode on the bridge.
>
> > [    7.616784] pci 0000:00:01.5: BAR 0 [mem 0x81c89000-0x81c89fff]
>
> I think this is printed at the end of the first call to
> __pci_read_base(), so nearly 3.5s once through.  Twice again for about
> another 7s puts us at 14+s below.
>
> > [   14.140789] pci 0000:00:01.5: PCI bridge to [bus 06]
> > [   14.142240] pci 0000:00:01.5:   bridge window [mem 0x81000000-0x811f=
ffff]
> > [   17.432805] pci 0000:00:01.5:   bridge window [mem
> > 0x380000000000-0x382002ffffff 64bit pref]
>
> I think the prefetchable window on the bridge gets disabled and
> re-enabled here, that's another.
>
> So that's 4 times per calling pci_setup_device() on the bridge that
> we're re-mapping the device's 128G BAR back into the VM address space,
> that's 12-14s, times 4 GPUs and we're already approaching a minute.
>
> > [   17.436775] pci 0000:00:01.6: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [   20.656786] pci 0000:00:01.6: BAR 0 [mem 0x81c88000-0x81c88fff]
> > [   27.044792] pci 0000:00:01.6: PCI bridge to [bus 07]
> > [   27.048775] pci 0000:00:01.6:   bridge window [mem 0x80e00000-0x80ff=
ffff]
> > [   30.240811] pci 0000:00:01.6:   bridge window [mem
> > 0x384000000000-0x386002ffffff 64bit pref]
> > [   30.244777] pci 0000:00:01.7: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [   33.676789] pci 0000:00:01.7: BAR 0 [mem 0x81c87000-0x81c87fff]
> > [   40.524791] pci 0000:00:01.7: PCI bridge to [bus 08]
> > [   40.526249] pci 0000:00:01.7:   bridge window [mem 0x80c00000-0x80df=
ffff]
> > [   43.876807] pci 0000:00:01.7:   bridge window [mem
> > 0x388000000000-0x38a002ffffff 64bit pref]
> > [   43.880776] pci 0000:00:02.0: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [   47.184786] pci 0000:00:02.0: BAR 0 [mem 0x81c86000-0x81c86fff]
> > [   53.796794] pci 0000:00:02.0: PCI bridge to [bus 09]
> > [   53.798349] pci 0000:00:02.0:   bridge window [mem 0x80a00000-0x80bf=
ffff]
> > [   57.104809] pci 0000:00:02.0:   bridge window [mem
> > 0x38c000000000-0x38e002ffffff 64bit pref]
> > [   57.109300] pci 0000:00:02.1: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [   57.112270] pci 0000:00:02.1: BAR 0 [mem 0x81c85000-0x81c85fff]
> > [   57.115960] pci 0000:00:02.1: PCI bridge to [bus 0a]
> > [   57.116535] pci 0000:00:02.1:   bridge window [mem 0x80800000-0x809f=
ffff]
> > [   57.121443] pci 0000:00:02.1:   bridge window [mem
> > 0x391000000000-0x3917ffffffff 64bit pref]
> > [   57.123113] pci 0000:00:02.2: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [   57.125263] pci 0000:00:02.2: BAR 0 [mem 0x81c84000-0x81c84fff]
> > [   57.128168] pci 0000:00:02.2: PCI bridge to [bus 0b]
> > [   57.128713] pci 0000:00:02.2:   bridge window [mem 0x80600000-0x807f=
ffff]
> > [   57.129619] pci 0000:00:02.2:   bridge window [mem
> > 0x391800000000-0x391fffffffff 64bit pref]
> > [   57.133671] pci 0000:00:02.3: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [   57.135884] pci 0000:00:02.3: BAR 0 [mem 0x81c83000-0x81c83fff]
> > [   57.138198] pci 0000:00:02.3: PCI bridge to [bus 0c]
> > [   57.138749] pci 0000:00:02.3:   bridge window [mem 0x80400000-0x805f=
ffff]
> > [   57.139975] pci 0000:00:02.3:   bridge window [mem
> > 0x392000000000-0x3927ffffffff 64bit pref]
> > [   57.141558] pci 0000:00:02.4: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [   57.146325] pci 0000:00:02.4: BAR 0 [mem 0x81c82000-0x81c82fff]
> > [   57.148744] pci 0000:00:02.4: PCI bridge to [bus 0d]
> > [   57.148795] pci 0000:00:02.4:   bridge window [mem 0x80200000-0x803f=
ffff]
> > [   57.149992] pci 0000:00:02.4:   bridge window [mem
> > 0x392800000000-0x392fffffffff 64bit pref]
> > [   57.151660] pci 0000:00:02.5: [1b36:000c] type 01 class 0x060400
> > PCIe Root Port
> > [   57.157365] pci 0000:00:02.5: BAR 0 [mem 0x81c81000-0x81c81fff]
> > [   57.159859] pci 0000:00:02.5: PCI bridge to [bus 0e]
> > [   57.160374] pci 0000:00:02.5:   bridge window [mem 0x80000000-0x801f=
ffff]
> > [   57.161268] pci 0000:00:02.5:   bridge window [mem
> > 0x393000000000-0x3937ffffffff 64bit pref]
> > [   57.176995] pci 0000:00:1f.0: [8086:2918] type 00 class 0x060100
> > conventional PCI endpoint
> > [   57.178146] pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by
> > ICH6 ACPI/GPIO/TCO
> > [   57.179162] pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601
> > conventional PCI endpoint
> > [   57.186370] pci 0000:00:1f.2: BAR 4 [io  0x6040-0x605f]
> > [   57.187830] pci 0000:00:1f.2: BAR 5 [mem 0x81c80000-0x81c80fff]
> > [   57.189464] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
> > conventional PCI endpoint
> > [   57.197117] pci 0000:00:1f.3: BAR 4 [io  0x6000-0x603f]
> > [   57.199155] acpiphp: Slot [0] registered
> > [   57.199695] pci 0000:01:00.0: [1af4:1041] type 00 class 0x020000
> > PCIe Endpoint
> > [   57.202062] pci 0000:01:00.0: BAR 1 [mem 0x81a00000-0x81a00fff]
> > [   57.205640] pci 0000:01:00.0: BAR 4 [mem
> > 0x38e800000000-0x38e800003fff 64bit pref]
> > [   57.213753] pci 0000:01:00.0: ROM [mem 0xfff80000-0xffffffff pref]
> > [   57.215477] pci 0000:00:01.0: PCI bridge to [bus 01]
> > [   57.216661] acpiphp: Slot [0-2] registered
> > [   57.216846] pci 0000:02:00.0: [1b36:000d] type 00 class 0x0c0330
> > PCIe Endpoint
> > [   57.218123] pci 0000:02:00.0: BAR 0 [mem 0x81800000-0x81803fff 64bit=
]
> > [   57.221585] pci 0000:00:01.1: PCI bridge to [bus 02]
> > [   57.225522] acpiphp: Slot [0-3] registered
> > [   57.226056] pci 0000:03:00.0: [1af4:1043] type 00 class 0x078000
> > PCIe Endpoint
> > [   57.228576] pci 0000:03:00.0: BAR 1 [mem 0x81600000-0x81600fff]
> > [   57.231435] pci 0000:03:00.0: BAR 4 [mem
> > 0x38f800000000-0x38f800003fff 64bit pref]
> > [   57.236846] pci 0000:00:01.2: PCI bridge to [bus 03]
> > [   57.238158] acpiphp: Slot [0-4] registered
> > [   57.238682] pci 0000:04:00.0: [1af4:1042] type 00 class 0x010000
> > PCIe Endpoint
> > [   57.241207] pci 0000:04:00.0: BAR 1 [mem 0x81400000-0x81400fff]
> > [   57.245502] pci 0000:04:00.0: BAR 4 [mem
> > 0x390000000000-0x390000003fff 64bit pref]
> > [   57.257182] pci 0000:00:01.3: PCI bridge to [bus 04]
> > [   57.258719] acpiphp: Slot [0-5] registered
> > [   57.259247] pci 0000:05:00.0: [1af4:1042] type 00 class 0x010000
> > PCIe Endpoint
> > [   57.261991] pci 0000:05:00.0: BAR 1 [mem 0x81200000-0x81200fff]
> > [   57.268026] pci 0000:05:00.0: BAR 4 [mem
> > 0x390800000000-0x390800003fff 64bit pref]
> > [   57.270867] pci 0000:00:01.4: PCI bridge to [bus 05]
> > [   57.272119] acpiphp: Slot [0-6] registered
> > [   57.272653] pci 0000:06:00.0: [10de:2330] type 00 class 0x030200
> > PCIe Endpoint
> > [   60.512788] pci 0000:06:00.0: BAR 0 [mem
> > 0x382002000000-0x382002ffffff 64bit pref]
>
> Now we've gotten to the device and it looks like one...
>
> > [   63.740786] pci 0000:06:00.0: BAR 2 [mem
> > 0x380000000000-0x381fffffffff 64bit pref]
>
> two...
>
> > [   66.956785] pci 0000:06:00.0: BAR 4 [mem
> > 0x382000000000-0x382001ffffff 64bit pref]
>
> three more disables at the command register.  So we're really being
> bitten that we toggle decode-enable/memory enable around reading each
> BAR size.  I'd expect though that these latter three would still be
> required during hotplug.  Do you have similar logs from that operation?
>
> > [   70.188836] pci 0000:06:00.0: Max Payload Size set to 128 (was 256, =
max 256)
>
> Looks like there might even be one more before we get here.  Thanks,
>
> Alex
>


--=20
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

