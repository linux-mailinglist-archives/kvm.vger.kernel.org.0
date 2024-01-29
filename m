Return-Path: <kvm+bounces-7392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D8B8413BE
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 974FD1C21FE9
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2376F08D;
	Mon, 29 Jan 2024 19:52:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA7A4C619
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 19:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706557922; cv=none; b=J/JqsdgCmV5Y2VSsaOpSaRvOBDV9a6dCmjc8PjI8HQzaYNu/39CrPcMSTQ7mVTRL5RWvUiQ3X3umidFUvkQk8YmZCqbT6qz9CG6KLvDu9fM5vxaexAuQrg4A4XVSXmImMrVnVctjRRpemrp/5Q6NEqXnlxRf9lBW1/pmdDXGwjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706557922; c=relaxed/simple;
	bh=iW/68hBuEHjyyBWb2MT6mypQgvP1TvbfsWnvOm0NwsI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sDvgvuaMBLux2BjUQA9sU2hRRF+j1GAAPYZymmYikxvGDs9uEQMVeD9tOHEfWHcv97hLN+/UqnMHs23TcDtDx/5KESUcjXoGHnzs6Ktzwo958xzPA4idJZPUBuXrL0M9nuRO/o4Tq2AokbUNKJKzh63wzRFdVrou0M5djPP+Wgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 9FB514E6012;
	Mon, 29 Jan 2024 20:46:43 +0100 (CET)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
	by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id JX1PHC9kVR1W; Mon, 29 Jan 2024 20:46:41 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 99D024E6006; Mon, 29 Jan 2024 20:46:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 966427456B4;
	Mon, 29 Jan 2024 20:46:41 +0100 (CET)
Date: Mon, 29 Jan 2024 20:46:41 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>
cc: qemu-devel@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org, 
    Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
    qemu-ppc@nongnu.org, qemu-arm@nongnu.org, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Zhao Liu <zhao1.liu@intel.com>, 
    Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, 
    "Michael S. Tsirkin" <mst@redhat.com>, 
    Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
    =?ISO-8859-15?Q?C=E9dric_Le_Goater?= <clg@kaod.org>, 
    Nicholas Piggin <npiggin@gmail.com>, 
    =?ISO-8859-15?Q?Fr=E9d=E9ric_Barrat?= <fbarrat@linux.ibm.com>, 
    =?ISO-8859-15?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, 
    Viresh Kumar <viresh.kumar@linaro.org>, mzamazal@redhat.com, 
    Stefano Stabellini <sstabellini@kernel.org>, 
    Anthony Perard <anthony.perard@citrix.com>, Paul Durrant <paul@xen.org>, 
    Peter Xu <peterx@redhat.com>, Fabiano Rosas <farosas@suse.de>, 
    Peter Maydell <peter.maydell@linaro.org>, 
    Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>, 
    Laurent Vivier <laurent@vivier.eu>, 
    Daniel Henrique Barboza <danielhb413@gmail.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, 
    Alistair Francis <alistair.francis@wdc.com>, 
    Bin Meng <bin.meng@windriver.com>, Weiwei Li <liwei1518@gmail.com>, 
    Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 01/29] bulk: Access existing variables initialized to
 &S->F when available
In-Reply-To: <20240129164514.73104-2-philmd@linaro.org>
Message-ID: <fd790685-a98f-9cd5-c117-dac96564a71b@eik.bme.hu>
References: <20240129164514.73104-1-philmd@linaro.org> <20240129164514.73104-2-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-1985250681-1706557601=:22604"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-1985250681-1706557601=:22604
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 29 Jan 2024, Philippe Mathieu-Daudé wrote:
> When a variable is initialized to &struct->field, use it
> in place. Rationale: while this makes the code more concise,
> this also helps static analyzers.
>
> Mechanical change using the following Coccinelle spatch script:
>
> @@
> type S, F;
> identifier s, m, v;
> @@
>      S *s;
>      ...
>      F *v = &s->m;
>      <+...
> -    &s->m
> +    v
>      ...+>
>
> Inspired-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
> hw/display/ati.c              |  2 +-
> hw/misc/macio/pmu.c           |  2 +-
> hw/misc/pvpanic-pci.c         |  2 +-
> hw/pci-bridge/cxl_root_port.c |  2 +-
> hw/ppc/pnv.c                  | 20 ++++++++++----------
> hw/virtio/vhost-user-gpio.c   |  8 ++++----
> hw/virtio/vhost-user-scmi.c   |  6 +++---
> hw/virtio/virtio-pci.c        |  2 +-
> hw/xen/xen_pt.c               |  6 +++---
> migration/multifd-zlib.c      |  2 +-
> target/arm/cpu.c              |  4 ++--
> target/arm/kvm.c              |  2 +-
> target/arm/machine.c          |  6 +++---
> target/i386/hvf/x86hvf.c      |  2 +-
> target/m68k/helper.c          |  2 +-
> target/ppc/kvm.c              |  8 ++++----
> target/riscv/cpu_helper.c     |  2 +-
> 17 files changed, 39 insertions(+), 39 deletions(-)
>
> diff --git a/hw/display/ati.c b/hw/display/ati.c
> index 569b8f6165..8d2501bd82 100644
> --- a/hw/display/ati.c
> +++ b/hw/display/ati.c
> @@ -991,7 +991,7 @@ static void ati_vga_realize(PCIDevice *dev, Error **errp)
>     }
>     vga_init(vga, OBJECT(s), pci_address_space(dev),
>              pci_address_space_io(dev), true);
> -    vga->con = graphic_console_init(DEVICE(s), 0, s->vga.hw_ops, &s->vga);
> +    vga->con = graphic_console_init(DEVICE(s), 0, s->vga.hw_ops, vga);
>     if (s->cursor_guest_mode) {
>         vga->cursor_invalidate = ati_cursor_invalidate;
>         vga->cursor_draw_line = ati_cursor_draw_line;
> diff --git a/hw/misc/macio/pmu.c b/hw/misc/macio/pmu.c
> index e9a90da88f..7fe1c4e517 100644
> --- a/hw/misc/macio/pmu.c
> +++ b/hw/misc/macio/pmu.c
> @@ -737,7 +737,7 @@ static void pmu_realize(DeviceState *dev, Error **errp)
>     timer_mod(s->one_sec_timer, s->one_sec_target);
>
>     if (s->has_adb) {
> -        qbus_init(&s->adb_bus, sizeof(s->adb_bus), TYPE_ADB_BUS,
> +        qbus_init(adb_bus, sizeof(s->adb_bus), TYPE_ADB_BUS,

Probably should change to use sizeof(*adb_bus) too. Although the next line 
is the only place the adb_bus local is used so maybe can drop the local 
and chnage next line to use &s->adb_bus instead.

Regards,
BALATON Zoltan

>                   dev, "adb.0");
>         adb_register_autopoll_callback(adb_bus, pmu_adb_poll, s);
>     }
--3866299591-1985250681-1706557601=:22604--

