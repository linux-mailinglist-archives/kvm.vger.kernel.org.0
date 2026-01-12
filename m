Return-Path: <kvm+bounces-67790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D9BD1448D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D33E530281E1
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D668374190;
	Mon, 12 Jan 2026 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SrM9xKXR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nzeaheqq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBB130C35E
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237723; cv=none; b=jTIBdOrTDpbMNQIZRS8i7R0pY+GmSr0dysxOBb21bVaLgZE9r+AWjgsEtthue4oqOV848h0UicNZoUpuE2Iq+xPl+tcsEk6nP4kHO+nnkkIXXg+dIHbQ983zxYa7NUreAdKlsvhFhw/gG5DRvQBNc5dEOHiEeFyuKIfkz5HGyg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237723; c=relaxed/simple;
	bh=5gshPcqnoGhFh8Ce609XowkY1EeGBrE6vUMQxxkUghs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YPbB4p20172SVvon2uQ5/lD3xTiyU15JRzNavJeyimazSgroLWUFIFZaIZgFhWs94f8pStVHSH2thMk6iEAd8p9GSYzJHh9tytdlUecNADwI/+lp33950bPIUcQY2Axrco4VR+H24qSY+JSm8TyiWTHZbyA/yoOjqC02AcPP63U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SrM9xKXR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nzeaheqq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768237720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uehu+xQx7dj6E3RoenzKjj23QeiGyi5ZnRxyNtgQu2g=;
	b=SrM9xKXRpTzAqUdfX4Btt/iYkVLQe7Gx5VOfCCBkJGWLYQQBpXLn0tZkY/v5S2FgkKdpLG
	mw77R35v5LXX5WoyBwY43QjnQk8rsLkw9hyIe6kzmORf/WvXAvx2lTpjTC8MaFgCL5PPEv
	yjNym34d3O2uJD1paimrkGa7CP+DOck=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-bGqYT3VxMyCb5zCMeB-LAQ-1; Mon, 12 Jan 2026 12:08:38 -0500
X-MC-Unique: bGqYT3VxMyCb5zCMeB-LAQ-1
X-Mimecast-MFC-AGG-ID: bGqYT3VxMyCb5zCMeB-LAQ_1768237717
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so55324745e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768237716; x=1768842516; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uehu+xQx7dj6E3RoenzKjj23QeiGyi5ZnRxyNtgQu2g=;
        b=nzeaheqqdSTebjVB4v6PdsiounzZgzfqSc5WRPYZiyxRDdLE64PBbCJVhY2Ff99+Y2
         YoxcKaZIf0+TMScjb52+biJ8Ism/OMq2U4iNbj/Ra16a+vOtZM1MfFezHgfRpvcnqRfi
         al6XMgoey8x7wHREOwBBV/pa4h4d7ujvmXSeD99rU+CAgk0eeh88Z1S407Qgq39JhPcz
         0Erls8TOoFStoFrPu395CR/u7qWdG+KmOIfApgEjs1cx22NklSompMNstmYtW1WBPiga
         Tre2ph2XXe1tKhMhZqDT2YaS745bYyk4AU/1j0tgHiSR7ALcmBc+e8J3NBVeNw4VLgGV
         I24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768237716; x=1768842516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uehu+xQx7dj6E3RoenzKjj23QeiGyi5ZnRxyNtgQu2g=;
        b=jw4OptlqsltShZnnSUXcAzAUstm0e1sDV4T9D77czzRnO4lXh2WrpzjqNqASRwyCpn
         OHlFUPW/bN7RvQOWFWzXRcLCLoXpdMG8IUfwmN7iiek3uoF/X9OSYENdDVo9RgqAXF4N
         BCB0K2HxHEl4YEuJ0vnk9LX1TWHpeVGKmtIrR/0l5d+nkxmGUKD+0/1k53zUGVe0M0EJ
         p4mTOkDsHs0T9Uzum1KxjUnFiMofsF6fWazdqg3STk9q/x61Vg6VnLGdKwRvJYzoBeEn
         i9rVAcRMjdmX09eWRS+r1Y51rpa49SBfHERzHOqsTPLuyckJQYyQp0X+vxtXev69x1mD
         /tMw==
X-Forwarded-Encrypted: i=1; AJvYcCVK0FiAuBQA0QG8m/9vC74ehVClH3Fa/zD6fGpOPE3W5Dv2wSzQogTKM1mlzhb6ABp8+CM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG8EbBBjLmNqZPooTFr9l7wrYETAunsoPoUETnRc1TWhgPUwiP
	40HY47fsJOWGOXhXL48nA8Y33biVVuUP/cb881G+NkN+TTeESZH6keC6Xb9FBDX8EOlAZ+mSwNj
	uvbdMy6+ra4RraiIyaOLrde9aBtaGanTbBN0aSrikA4m+fwNkKAQIA4B3MnO5FYkgRiowUadlcJ
	2Qas3E9Sjw3CXLAzpoIMNeMud6RBELniTZkxBf3oE=
X-Gm-Gg: AY/fxX7Ep7vAcoTLQ5uIkk1lxuyZB5yrcMpR0rd9uGLnEb9FvNN35AJpTCiBHxMvJo6
	JKGbO6Ad+PoZ6e7UVABBJrzldg+teXbkD2JJMQz70rEJcN3Gn5gxY6/zqIn4avYx8/+WVTBG00B
	upSVI53KVRc322hXF7f0IN9AumECTIa0pdQWAKQcE4wVBlDhJ6MupDEW55Pc0t338JcFO2CI1hp
	d1CJ4EOv7yxSiH2pHJ96zp7KRnC5mvt5JUzZTlNKdSTn72yMVRnm5rD0b0gEYFBk8A3pg==
X-Received: by 2002:a05:600c:a10a:b0:477:7bd2:693f with SMTP id 5b1f17b1804b1-47d869a6980mr158250785e9.6.1768237716584;
        Mon, 12 Jan 2026 09:08:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwqW31gAMuXtSnKzztCB1SmpWewS7W/AbC9ckMxuoVKmqTODiapV67ShTxTW1baaqumEt+ZHydA0H+XVesmGg=
X-Received: by 2002:a05:600c:a10a:b0:477:7bd2:693f with SMTP id
 5b1f17b1804b1-47d869a6980mr158250425e9.6.1768237716133; Mon, 12 Jan 2026
 09:08:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-12-anisinha@redhat.com>
In-Reply-To: <20260112132259.76855-12-anisinha@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Jan 2026 18:08:23 +0100
X-Gm-Features: AZwV_QiZz31TiQz1u2tp1nj0kN-UTTKgWLW2HYrCutr-qZ2aUaQJVSNiddvSnbA
Message-ID: <CABgObfZTjvfhb7DnNSu74PVUUZ6kBXw6_Y1pv_0mgpoxys+h+g@mail.gmail.com>
Subject: Re: [PATCH v2 11/32] kvm/i386: reload firmware for confidential guest reset
To: Ani Sinha <anisinha@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 2:24=E2=80=AFPM Ani Sinha <anisinha@redhat.com> wro=
te:
>
> When IGVM is not being used by the confidential guest, the guest firmware=
 has
> to be reloaded explictly again into memory. This is because, the memory i=
nto
> which the firmware was loaded before reset was encrypted and is thus lost
> upon reset. When IGVM is used, it is expected that the IGVM will contain =
the
> guest firmware and the execution of the IGVM directives will set up the g=
uest
> firmware memory.
>
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  target/i386/kvm/kvm.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 4fedc621b8..46c4f9487b 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -51,6 +51,8 @@
>  #include "qemu/config-file.h"
>  #include "qemu/error-report.h"
>  #include "qemu/memalign.h"
> +#include "qemu/datadir.h"
> +#include "hw/core/loader.h"
>  #include "hw/i386/x86.h"
>  #include "hw/i386/kvm/xen_evtchn.h"
>  #include "hw/i386/pc.h"
> @@ -3267,6 +3269,22 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
>
>  static int xen_init_wrapper(MachineState *ms, KVMState *s);
>
> +static void reload_bios_rom(X86MachineState *x86ms)
> +{
> +    int bios_size;
> +    const char *bios_name;
> +    char *filename;
> +
> +    bios_name =3D MACHINE(x86ms)->firmware ?: "bios.bin";
> +    filename =3D qemu_find_file(QEMU_FILE_TYPE_BIOS, bios_name);
> +
> +    bios_size =3D get_bios_size(x86ms, bios_name, filename);
> +
> +    void *ptr =3D memory_region_get_ram_ptr(&x86ms->bios);
> +    load_image_size(filename, ptr, bios_size);
> +    x86_firmware_configure(0x100000000ULL - bios_size, ptr, bios_size);
> +}
> +
>  int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
>  {
>      Error *local_err =3D NULL;
> @@ -3285,6 +3303,16 @@ int kvm_arch_vmfd_change_ops(MachineState *ms, KVM=
State *s)
>              error_report_err(local_err);
>              return ret;
>          }
> +        if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
> +            X86MachineState *x86ms =3D X86_MACHINE(ms);
> +            /*
> +             * If an IGVM file is specified then the firmware must be pr=
ovided
> +             * in the IGVM file.
> +             */
> +            if (!x86ms->igvm) {
> +                reload_bios_rom(x86ms);
> +            }
> +        }

Does this have to be done here, as opposed to in its own notifier or
anyway a notifier owned by the machine?

In any case, this can be done after the part in common with kvm_arch_init()=
.

Paolo


