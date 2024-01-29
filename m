Return-Path: <kvm+bounces-7378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5E48410AF
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 18:30:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 531801C23ECC
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE37215CD6A;
	Mon, 29 Jan 2024 17:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EzeWOlq9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HxUJGU4k";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EzeWOlq9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HxUJGU4k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68346158D87
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548817; cv=none; b=sBBcXRx9OwDQIGdj88ouePvd99HT08tQe/3yeK0ktUbtxGC948rfk3RhLfwR8XacmUgDWEdU1AnVU/CttZaEJDPZ7dO1wWVdl+JwgOPbl7COh94DBfjAn5DIeV8v+8INJ4h6YXUMe94903i0z5zNOFqxqWSEHm+tdYU9wrn0em0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548817; c=relaxed/simple;
	bh=0FoQPt+naq/pt1Tlo5toioJU+ePr1xLFagqTogjO/lE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NAS/xKE+4ibEZlVv1Hm2UkriM8xwAwOIKoLR0QLW7U9EKL+Fcbvxk6Z0UzcuH3y7L1ht+hNezbf6ErLo5ibnsUUrQUqL55C6GAmKkLwMJKNkFLiuMXiD75bkutOPZWE24x4XTYjZLNHVH7pD1cuD3Hold0bt9ScnVNI52k8oZSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EzeWOlq9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HxUJGU4k; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EzeWOlq9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HxUJGU4k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 806A721F92;
	Mon, 29 Jan 2024 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706548812; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6hJMzhBEMCKpgRG4wxS8YBfobz37mSA/+BPbvKdU2Cs=;
	b=EzeWOlq9VkVrwwH9GXp4K8ejxz2nkDG+xFDKopp/2Z/HdEXm+JF+FMOFCZpltwlG2DPrK6
	QjSeMqdDJtqdRJfEWeR0YC2iVb8dP6eSHjrYiYg31MnxcnjV3j58FuQvKWDdWGLDiGx0w5
	NPrE7dM9E4wqNPscMMJdgkg5CtHYsFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706548812;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6hJMzhBEMCKpgRG4wxS8YBfobz37mSA/+BPbvKdU2Cs=;
	b=HxUJGU4k19XN2tMk8ujL7WdjtgWi0jOESt8JFbQVTXJivzIUv7TyGvRNR6rG4/848s44FS
	HA/zBFkYs069aYBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706548812; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6hJMzhBEMCKpgRG4wxS8YBfobz37mSA/+BPbvKdU2Cs=;
	b=EzeWOlq9VkVrwwH9GXp4K8ejxz2nkDG+xFDKopp/2Z/HdEXm+JF+FMOFCZpltwlG2DPrK6
	QjSeMqdDJtqdRJfEWeR0YC2iVb8dP6eSHjrYiYg31MnxcnjV3j58FuQvKWDdWGLDiGx0w5
	NPrE7dM9E4wqNPscMMJdgkg5CtHYsFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706548812;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6hJMzhBEMCKpgRG4wxS8YBfobz37mSA/+BPbvKdU2Cs=;
	b=HxUJGU4k19XN2tMk8ujL7WdjtgWi0jOESt8JFbQVTXJivzIUv7TyGvRNR6rG4/848s44FS
	HA/zBFkYs069aYBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDA5313647;
	Mon, 29 Jan 2024 17:20:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hRlBLkvet2VxYAAAD6G6ig
	(envelope-from <farosas@suse.de>); Mon, 29 Jan 2024 17:20:11 +0000
From: Fabiano Rosas <farosas@suse.de>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org, qemu-s390x@nongnu.org, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-arm@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Zhao Liu
 <zhao1.liu@intel.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 "Michael S. Tsirkin" <mst@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, =?utf-8?Q?C=C3=A9dric?= Le Goater
 <clg@kaod.org>, Nicholas
 Piggin <npiggin@gmail.com>, =?utf-8?B?RnLDqWTDqXJpYw==?= Barrat
 <fbarrat@linux.ibm.com>, Alex
 =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Viresh Kumar
 <viresh.kumar@linaro.org>,
 mzamazal@redhat.com, Stefano Stabellini <sstabellini@kernel.org>, Anthony
 Perard <anthony.perard@citrix.com>, Paul Durrant <paul@xen.org>, Peter Xu
 <peterx@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Cameron
 Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>, Laurent
 Vivier <laurent@vivier.eu>, Daniel Henrique Barboza
 <danielhb413@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, Alistair
 Francis <alistair.francis@wdc.com>, Bin Meng <bin.meng@windriver.com>,
 Weiwei Li <liwei1518@gmail.com>, Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 01/29] bulk: Access existing variables initialized to
 &S->F when available
In-Reply-To: <20240129164514.73104-2-philmd@linaro.org>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-2-philmd@linaro.org>
Date: Mon, 29 Jan 2024 14:20:09 -0300
Message-ID: <875xzcoy46.fsf@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EzeWOlq9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HxUJGU4k
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 TO_DN_SOME(0.00)[];
	 R_RATELIMIT(0.00)[to_ip_from(RLur6zqgge5zak3uenq87ipfaa)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[35];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,linaro.org:email,suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FREEMAIL_CC(0.00)[nongnu.org,redhat.com,vger.kernel.org,linaro.org,intel.com,ilande.co.uk,gmail.com,kaod.org,linux.ibm.com,kernel.org,citrix.com,xen.org,apple.com,ddn.com,vivier.eu,dabbelt.com,wdc.com,windriver.com,linux.alibaba.com,lists.xenproject.org];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 806A721F92
X-Spam-Flag: NO

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> When a variable is initialized to &struct->field, use it
> in place. Rationale: while this makes the code more concise,
> this also helps static analyzers.
>
> Mechanical change using the following Coccinelle spatch script:
>
>  @@
>  type S, F;
>  identifier s, m, v;
>  @@
>       S *s;
>       ...
>       F *v =3D &s->m;
>       <+...
>  -    &s->m
>  +    v
>       ...+>
>
> Inspired-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Acked-by: Fabiano Rosas <farosas@suse.de>

> ---
>  hw/display/ati.c              |  2 +-
>  hw/misc/macio/pmu.c           |  2 +-
>  hw/misc/pvpanic-pci.c         |  2 +-
>  hw/pci-bridge/cxl_root_port.c |  2 +-
>  hw/ppc/pnv.c                  | 20 ++++++++++----------
>  hw/virtio/vhost-user-gpio.c   |  8 ++++----
>  hw/virtio/vhost-user-scmi.c   |  6 +++---
>  hw/virtio/virtio-pci.c        |  2 +-
>  hw/xen/xen_pt.c               |  6 +++---
>  migration/multifd-zlib.c      |  2 +-
>  target/arm/cpu.c              |  4 ++--
>  target/arm/kvm.c              |  2 +-
>  target/arm/machine.c          |  6 +++---
>  target/i386/hvf/x86hvf.c      |  2 +-
>  target/m68k/helper.c          |  2 +-
>  target/ppc/kvm.c              |  8 ++++----
>  target/riscv/cpu_helper.c     |  2 +-
>  17 files changed, 39 insertions(+), 39 deletions(-)
>
> diff --git a/hw/display/ati.c b/hw/display/ati.c
> index 569b8f6165..8d2501bd82 100644
> --- a/hw/display/ati.c
> +++ b/hw/display/ati.c
> @@ -991,7 +991,7 @@ static void ati_vga_realize(PCIDevice *dev, Error **e=
rrp)
>      }
>      vga_init(vga, OBJECT(s), pci_address_space(dev),
>               pci_address_space_io(dev), true);
> -    vga->con =3D graphic_console_init(DEVICE(s), 0, s->vga.hw_ops, &s->v=
ga);
> +    vga->con =3D graphic_console_init(DEVICE(s), 0, s->vga.hw_ops, vga);
>      if (s->cursor_guest_mode) {
>          vga->cursor_invalidate =3D ati_cursor_invalidate;
>          vga->cursor_draw_line =3D ati_cursor_draw_line;
> diff --git a/hw/misc/macio/pmu.c b/hw/misc/macio/pmu.c
> index e9a90da88f..7fe1c4e517 100644
> --- a/hw/misc/macio/pmu.c
> +++ b/hw/misc/macio/pmu.c
> @@ -737,7 +737,7 @@ static void pmu_realize(DeviceState *dev, Error **err=
p)
>      timer_mod(s->one_sec_timer, s->one_sec_target);
>=20=20
>      if (s->has_adb) {
> -        qbus_init(&s->adb_bus, sizeof(s->adb_bus), TYPE_ADB_BUS,
> +        qbus_init(adb_bus, sizeof(s->adb_bus), TYPE_ADB_BUS,
>                    dev, "adb.0");
>          adb_register_autopoll_callback(adb_bus, pmu_adb_poll, s);
>      }
> diff --git a/hw/misc/pvpanic-pci.c b/hw/misc/pvpanic-pci.c
> index c01e4ce864..83be95d0d2 100644
> --- a/hw/misc/pvpanic-pci.c
> +++ b/hw/misc/pvpanic-pci.c
> @@ -48,7 +48,7 @@ static void pvpanic_pci_realizefn(PCIDevice *dev, Error=
 **errp)
>      PVPanicPCIState *s =3D PVPANIC_PCI_DEVICE(dev);
>      PVPanicState *ps =3D &s->pvpanic;
>=20=20
> -    pvpanic_setup_io(&s->pvpanic, DEVICE(s), 2);
> +    pvpanic_setup_io(ps, DEVICE(s), 2);
>=20=20
>      pci_register_bar(dev, 0, PCI_BASE_ADDRESS_SPACE_MEMORY, &ps->mr);
>  }
> diff --git a/hw/pci-bridge/cxl_root_port.c b/hw/pci-bridge/cxl_root_port.c
> index 8f97697631..2cf2f7bf5f 100644
> --- a/hw/pci-bridge/cxl_root_port.c
> +++ b/hw/pci-bridge/cxl_root_port.c
> @@ -175,7 +175,7 @@ static void cxl_rp_realize(DeviceState *dev, Error **=
errp)
>=20=20
>      cxl_cstate->dvsec_offset =3D CXL_ROOT_PORT_DVSEC_OFFSET;
>      cxl_cstate->pdev =3D pci_dev;
> -    build_dvsecs(&crp->cxl_cstate);
> +    build_dvsecs(cxl_cstate);
>=20=20
>      cxl_component_register_block_init(OBJECT(pci_dev), cxl_cstate,
>                                        TYPE_CXL_ROOT_PORT);
> diff --git a/hw/ppc/pnv.c b/hw/ppc/pnv.c
> index 0297871bdd..202a569e27 100644
> --- a/hw/ppc/pnv.c
> +++ b/hw/ppc/pnv.c
> @@ -1257,11 +1257,11 @@ static void pnv_chip_power8_realize(DeviceState *=
dev, Error **errp)
>      }
>=20=20
>      /* Processor Service Interface (PSI) Host Bridge */
> -    object_property_set_int(OBJECT(&chip8->psi), "bar", PNV_PSIHB_BASE(c=
hip),
> +    object_property_set_int(OBJECT(psi8), "bar", PNV_PSIHB_BASE(chip),
>                              &error_fatal);
> -    object_property_set_link(OBJECT(&chip8->psi), ICS_PROP_XICS,
> +    object_property_set_link(OBJECT(psi8), ICS_PROP_XICS,
>                               OBJECT(chip8->xics), &error_abort);
> -    if (!qdev_realize(DEVICE(&chip8->psi), NULL, errp)) {
> +    if (!qdev_realize(DEVICE(psi8), NULL, errp)) {
>          return;
>      }
>      pnv_xscom_add_subregion(chip, PNV_XSCOM_PSIHB_BASE,
> @@ -1292,7 +1292,7 @@ static void pnv_chip_power8_realize(DeviceState *de=
v, Error **errp)
>      }
>      pnv_xscom_add_subregion(chip, PNV_XSCOM_OCC_BASE, &chip8->occ.xscom_=
regs);
>      qdev_connect_gpio_out(DEVICE(&chip8->occ), 0,
> -                          qdev_get_gpio_in(DEVICE(&chip8->psi), PSIHB_IR=
Q_OCC));
> +                          qdev_get_gpio_in(DEVICE(psi8), PSIHB_IRQ_OCC));
>=20=20
>      /* OCC SRAM model */
>      memory_region_add_subregion(get_system_memory(), PNV_OCC_SENSOR_BASE=
(chip),
> @@ -1543,12 +1543,12 @@ static void pnv_chip_power9_realize(DeviceState *=
dev, Error **errp)
>                              &chip9->xive.xscom_regs);
>=20=20
>      /* Processor Service Interface (PSI) Host Bridge */
> -    object_property_set_int(OBJECT(&chip9->psi), "bar", PNV9_PSIHB_BASE(=
chip),
> +    object_property_set_int(OBJECT(psi9), "bar", PNV9_PSIHB_BASE(chip),
>                              &error_fatal);
>      /* This is the only device with 4k ESB pages */
> -    object_property_set_int(OBJECT(&chip9->psi), "shift", XIVE_ESB_4K,
> +    object_property_set_int(OBJECT(psi9), "shift", XIVE_ESB_4K,
>                              &error_fatal);
> -    if (!qdev_realize(DEVICE(&chip9->psi), NULL, errp)) {
> +    if (!qdev_realize(DEVICE(psi9), NULL, errp)) {
>          return;
>      }
>      pnv_xscom_add_subregion(chip, PNV9_XSCOM_PSIHB_BASE,
> @@ -1571,7 +1571,7 @@ static void pnv_chip_power9_realize(DeviceState *de=
v, Error **errp)
>      }
>      pnv_xscom_add_subregion(chip, PNV9_XSCOM_OCC_BASE, &chip9->occ.xscom=
_regs);
>      qdev_connect_gpio_out(DEVICE(&chip9->occ), 0, qdev_get_gpio_in(
> -                              DEVICE(&chip9->psi), PSIHB9_IRQ_OCC));
> +                              DEVICE(psi9), PSIHB9_IRQ_OCC));
>=20=20
>      /* OCC SRAM model */
>      memory_region_add_subregion(get_system_memory(), PNV9_OCC_SENSOR_BAS=
E(chip),
> @@ -1586,7 +1586,7 @@ static void pnv_chip_power9_realize(DeviceState *de=
v, Error **errp)
>      pnv_xscom_add_subregion(chip, PNV9_XSCOM_SBE_MBOX_BASE,
>                              &chip9->sbe.xscom_mbox_regs);
>      qdev_connect_gpio_out(DEVICE(&chip9->sbe), 0, qdev_get_gpio_in(
> -                              DEVICE(&chip9->psi), PSIHB9_IRQ_PSU));
> +                              DEVICE(psi9), PSIHB9_IRQ_PSU));
>=20=20
>      /* HOMER */
>      object_property_set_link(OBJECT(&chip9->homer), "chip", OBJECT(chip),
> @@ -1627,7 +1627,7 @@ static void pnv_chip_power9_realize(DeviceState *de=
v, Error **errp)
>                                          PNV9_XSCOM_I2CM_SIZE,
>                                  &chip9->i2c[i].xscom_regs);
>          qdev_connect_gpio_out(DEVICE(&chip9->i2c[i]), 0,
> -                              qdev_get_gpio_in(DEVICE(&chip9->psi),
> +                              qdev_get_gpio_in(DEVICE(psi9),
>                                                 PSIHB9_IRQ_SBE_I2C));
>      }
>  }
> diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
> index a83437a5da..6d4e9200ff 100644
> --- a/hw/virtio/vhost-user-gpio.c
> +++ b/hw/virtio/vhost-user-gpio.c
> @@ -79,9 +79,9 @@ static int vu_gpio_start(VirtIODevice *vdev)
>       * set needed for the vhost configuration. The backend may also
>       * apply backend_features when the feature set is sent.
>       */
> -    vhost_ack_features(&gpio->vhost_dev, feature_bits, vdev->guest_featu=
res);
> +    vhost_ack_features(vhost_dev, feature_bits, vdev->guest_features);
>=20=20
> -    ret =3D vhost_dev_start(&gpio->vhost_dev, vdev, false);
> +    ret =3D vhost_dev_start(vhost_dev, vdev, false);
>      if (ret < 0) {
>          error_report("Error starting vhost-user-gpio: %d", ret);
>          goto err_guest_notifiers;
> @@ -94,7 +94,7 @@ static int vu_gpio_start(VirtIODevice *vdev)
>       * enabling/disabling irqfd.
>       */
>      for (i =3D 0; i < gpio->vhost_dev.nvqs; i++) {
> -        vhost_virtqueue_mask(&gpio->vhost_dev, vdev, i, false);
> +        vhost_virtqueue_mask(vhost_dev, vdev, i, false);
>      }
>=20=20
>      /*
> @@ -114,7 +114,7 @@ static int vu_gpio_start(VirtIODevice *vdev)
>  err_guest_notifiers:
>      k->set_guest_notifiers(qbus->parent, gpio->vhost_dev.nvqs, false);
>  err_host_notifiers:
> -    vhost_dev_disable_notifiers(&gpio->vhost_dev, vdev);
> +    vhost_dev_disable_notifiers(vhost_dev, vdev);
>=20=20
>      return ret;
>  }
> diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
> index 918bb7dcf7..300847e672 100644
> --- a/hw/virtio/vhost-user-scmi.c
> +++ b/hw/virtio/vhost-user-scmi.c
> @@ -56,9 +56,9 @@ static int vu_scmi_start(VirtIODevice *vdev)
>          goto err_host_notifiers;
>      }
>=20=20
> -    vhost_ack_features(&scmi->vhost_dev, feature_bits, vdev->guest_featu=
res);
> +    vhost_ack_features(vhost_dev, feature_bits, vdev->guest_features);
>=20=20
> -    ret =3D vhost_dev_start(&scmi->vhost_dev, vdev, true);
> +    ret =3D vhost_dev_start(vhost_dev, vdev, true);
>      if (ret < 0) {
>          error_report("Error starting vhost-user-scmi: %d", ret);
>          goto err_guest_notifiers;
> @@ -71,7 +71,7 @@ static int vu_scmi_start(VirtIODevice *vdev)
>       * enabling/disabling irqfd.
>       */
>      for (i =3D 0; i < scmi->vhost_dev.nvqs; i++) {
> -        vhost_virtqueue_mask(&scmi->vhost_dev, vdev, i, false);
> +        vhost_virtqueue_mask(vhost_dev, vdev, i, false);
>      }
>      return 0;
>=20=20
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index 1a7039fb0c..cb6940fc0e 100644
> --- a/hw/virtio/virtio-pci.c
> +++ b/hw/virtio/virtio-pci.c
> @@ -1929,7 +1929,7 @@ static void virtio_pci_device_plugged(DeviceState *=
d, Error **errp)
>      bool modern_pio =3D proxy->flags & VIRTIO_PCI_FLAG_MODERN_PIO_NOTIFY;
>      uint8_t *config;
>      uint32_t size;
> -    VirtIODevice *vdev =3D virtio_bus_get_device(&proxy->bus);
> +    VirtIODevice *vdev =3D virtio_bus_get_device(bus);
>=20=20
>      /*
>       * Virtio capabilities present without
> diff --git a/hw/xen/xen_pt.c b/hw/xen/xen_pt.c
> index 36e6f93c37..10ddf6bc91 100644
> --- a/hw/xen/xen_pt.c
> +++ b/hw/xen/xen_pt.c
> @@ -710,7 +710,7 @@ static void xen_pt_destroy(PCIDevice *d) {
>      uint8_t intx;
>      int rc;
>=20=20
> -    if (machine_irq && !xen_host_pci_device_closed(&s->real_device)) {
> +    if (machine_irq && !xen_host_pci_device_closed(host_dev)) {
>          intx =3D xen_pt_pci_intx(s);
>          rc =3D xc_domain_unbind_pt_irq(xen_xc, xen_domid, machine_irq,
>                                       PT_IRQ_TYPE_PCI,
> @@ -759,8 +759,8 @@ static void xen_pt_destroy(PCIDevice *d) {
>          memory_listener_unregister(&s->io_listener);
>          s->listener_set =3D false;
>      }
> -    if (!xen_host_pci_device_closed(&s->real_device)) {
> -        xen_host_pci_device_put(&s->real_device);
> +    if (!xen_host_pci_device_closed(host_dev)) {
> +        xen_host_pci_device_put(host_dev);
>      }
>  }
>  /* init */
> diff --git a/migration/multifd-zlib.c b/migration/multifd-zlib.c
> index 37ce48621e..237ee49928 100644
> --- a/migration/multifd-zlib.c
> +++ b/migration/multifd-zlib.c
> @@ -75,7 +75,7 @@ static int zlib_send_setup(MultiFDSendParams *p, Error =
**errp)
>  err_free_zbuff:
>      g_free(z->zbuff);
>  err_deflate_end:
> -    deflateEnd(&z->zs);
> +    deflateEnd(zs);
>  err_free_z:
>      g_free(z);
>      error_setg(errp, "multifd %u: %s", p->id, err_msg);
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index b60e103046..60ab8f3242 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -2087,7 +2087,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Err=
or **errp)
>       * We rely on no XScale CPU having VFP so we can use the same bits i=
n the
>       * TB flags field for VECSTRIDE and XSCALE_CPAR.
>       */
> -    assert(arm_feature(&cpu->env, ARM_FEATURE_AARCH64) ||
> +    assert(arm_feature(env, ARM_FEATURE_AARCH64) ||
>             !cpu_isar_feature(aa32_vfp_simd, cpu) ||
>             !arm_feature(env, ARM_FEATURE_XSCALE));
>=20=20
> @@ -2129,7 +2129,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Err=
or **errp)
>      }
>=20=20
>      if (cpu->cfgend) {
> -        if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
> +        if (arm_feature(env, ARM_FEATURE_V7)) {
>              cpu->reset_sctlr |=3D SCTLR_EE;
>          } else {
>              cpu->reset_sctlr |=3D SCTLR_B;
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 81813030a5..ab85d628a8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1888,7 +1888,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          cpu->psci_version =3D QEMU_PSCI_VERSION_0_2;
>          cpu->kvm_init_features[0] |=3D 1 << KVM_ARM_VCPU_PSCI_0_2;
>      }
> -    if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
> +    if (!arm_feature(env, ARM_FEATURE_AARCH64)) {
>          cpu->kvm_init_features[0] |=3D 1 << KVM_ARM_VCPU_EL1_32BIT;
>      }
>      if (!kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PMU_V3)) {
> diff --git a/target/arm/machine.c b/target/arm/machine.c
> index 9d7dbaea54..b2b39b2475 100644
> --- a/target/arm/machine.c
> +++ b/target/arm/machine.c
> @@ -773,7 +773,7 @@ static int cpu_pre_load(void *opaque)
>      env->irq_line_state =3D UINT32_MAX;
>=20=20
>      if (!kvm_enabled()) {
> -        pmu_op_start(&cpu->env);
> +        pmu_op_start(env);
>      }
>=20=20
>      return 0;
> @@ -871,11 +871,11 @@ static int cpu_post_load(void *opaque, int version_=
id)
>      }
>=20=20
>      if (!kvm_enabled()) {
> -        pmu_op_finish(&cpu->env);
> +        pmu_op_finish(env);
>      }
>=20=20
>      if (tcg_enabled()) {
> -        arm_rebuild_hflags(&cpu->env);
> +        arm_rebuild_hflags(env);
>      }
>=20=20
>      return 0;
> diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
> index 3b1ef5f49a..be2c46246e 100644
> --- a/target/i386/hvf/x86hvf.c
> +++ b/target/i386/hvf/x86hvf.c
> @@ -408,7 +408,7 @@ bool hvf_inject_interrupts(CPUState *cs)
>      if (!(env->hflags & HF_INHIBIT_IRQ_MASK) &&
>          (cs->interrupt_request & CPU_INTERRUPT_HARD) &&
>          (env->eflags & IF_MASK) && !(info & VMCS_INTR_VALID)) {
> -        int line =3D cpu_get_pic_interrupt(&x86cpu->env);
> +        int line =3D cpu_get_pic_interrupt(env);
>          cs->interrupt_request &=3D ~CPU_INTERRUPT_HARD;
>          if (line >=3D 0) {
>              wvmcs(cs->accel->fd, VMCS_ENTRY_INTR_INFO, line |
> diff --git a/target/m68k/helper.c b/target/m68k/helper.c
> index 14508dfa11..a812f328a1 100644
> --- a/target/m68k/helper.c
> +++ b/target/m68k/helper.c
> @@ -972,7 +972,7 @@ bool m68k_cpu_tlb_fill(CPUState *cs, vaddr address, i=
nt size,
>          access_type |=3D ACCESS_SUPER;
>      }
>=20=20
> -    ret =3D get_physical_address(&cpu->env, &physical, &prot,
> +    ret =3D get_physical_address(env, &physical, &prot,
>                                 address, access_type, &page_size);
>      if (likely(ret =3D=3D 0)) {
>          tlb_set_page(cs, address & TARGET_PAGE_MASK,
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 26fa9d0575..b95a0b4928 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -635,8 +635,8 @@ static int kvm_put_fp(CPUState *cs)
>=20=20
>          for (i =3D 0; i < 32; i++) {
>              uint64_t vsr[2];
> -            uint64_t *fpr =3D cpu_fpr_ptr(&cpu->env, i);
> -            uint64_t *vsrl =3D cpu_vsrl_ptr(&cpu->env, i);
> +            uint64_t *fpr =3D cpu_fpr_ptr(env, i);
> +            uint64_t *vsrl =3D cpu_vsrl_ptr(env, i);
>=20=20
>  #if HOST_BIG_ENDIAN
>              vsr[0] =3D float64_val(*fpr);
> @@ -704,8 +704,8 @@ static int kvm_get_fp(CPUState *cs)
>=20=20
>          for (i =3D 0; i < 32; i++) {
>              uint64_t vsr[2];
> -            uint64_t *fpr =3D cpu_fpr_ptr(&cpu->env, i);
> -            uint64_t *vsrl =3D cpu_vsrl_ptr(&cpu->env, i);
> +            uint64_t *fpr =3D cpu_fpr_ptr(env, i);
> +            uint64_t *vsrl =3D cpu_vsrl_ptr(env, i);
>=20=20
>              reg.addr =3D (uintptr_t) &vsr;
>              reg.id =3D vsx ? KVM_REG_PPC_VSR(i) : KVM_REG_PPC_FPR(i);
> diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
> index c7cc7eb423..791435d628 100644
> --- a/target/riscv/cpu_helper.c
> +++ b/target/riscv/cpu_helper.c
> @@ -1200,7 +1200,7 @@ hwaddr riscv_cpu_get_phys_page_debug(CPUState *cs, =
vaddr addr)
>      CPURISCVState *env =3D &cpu->env;
>      hwaddr phys_addr;
>      int prot;
> -    int mmu_idx =3D cpu_mmu_index(&cpu->env, false);
> +    int mmu_idx =3D cpu_mmu_index(env, false);
>=20=20
>      if (get_physical_address(env, &phys_addr, &prot, addr, NULL, 0, mmu_=
idx,
>                               true, env->virt_enabled, true)) {

