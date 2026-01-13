Return-Path: <kvm+bounces-67936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E04D193CB
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 79671302B50A
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 13:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486CB392810;
	Tue, 13 Jan 2026 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GnVY2KNk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBD23921DB
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768312729; cv=none; b=Bpa4TgTNDMq5FZFVVAerw2TH+ITRyxDo1CDLUs1FDMiQikHYzIEwhcstZ/fqaBaexDp9tAF7LK74MX2J5pV65hyJKv0hLy4D4Jsig3CRQsy6bZCj+f0JdAZxLjPVaGAbtyKYCthtwbiZ3GfiuSp9v/fkuV8Lq2xFdT2ufhDr+Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768312729; c=relaxed/simple;
	bh=+swzV6rbWm8uXrJLnSTotFtu2rG8m+nlvKHDCv7el+U=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=bbutLJBGCwBxZ5gVfMOn4t07YF2VhPAWY3Vszo+DLlcsloepf3acXG3aqRarHtuMWH35gjTgARE5TR4kEyoMYgyYIXhQgzpWSGMLChEWr4LZYzG4azv4lihxCprqYQcMWWrdlyGSfRFvbtGo5WsCvwEWadt6ByCP1YuNnAHbMB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GnVY2KNk; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fb0fc5aa4so5648535f8f.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 05:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768312726; x=1768917526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WhGDknja7CQejJLDSeyhPCpGEnEpfpz6CPziZT1+0s=;
        b=GnVY2KNkP388I901YUjoI8RpNHSWU0SKySKnS4aZN/0CAwL3/mGkB9j3r8YfZKgaBB
         3wz68m0dh3tVYXMrpSMYIaTLl+2iCumTSiCiOJnRQB+9PB60FbVa7TGVsmDEPunuaggc
         JJl9D5nIPL16WdlCdFTL9reuT4kIoRv6tq6/vHxOyEo5F1DEhVBDfWLe3aBDIXOYeKdn
         9Jr0voCcF/884OnzrgE3zZNIKqbWLYhe6hh/axvr+JnXSQT7Z6OQrdi93Nz+pPyA2Hsz
         8Pq70caZGTf/zgfC2qyXkG0woBZCN1LIwe4zfs922QfjqfIbUQ3BcERIENkeqzct9RpF
         qVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768312726; x=1768917526;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6WhGDknja7CQejJLDSeyhPCpGEnEpfpz6CPziZT1+0s=;
        b=h40cils1TRnZeQvVTXiGuNIxAvmpg/CbEJTBArW3SzF7c3Ny5qvS3Tnd/r/+qoI5h4
         mQvxrNFMSxrNEUxffvE5H0k3vEiSjlxOd45ukOZMjAQRzcb2uDRBhpq85Btvw92u1pav
         7tLiHauzk61K6DAAZ5OEhnMgF2RJlst3btJscGk8hV/rEzBOX3efplF/B8E3HcN29EOy
         OMkzOo0eYJYhv/kOhDUxXsRbwGJfy8n+s28lkxjun/Df3Xqm8mOIn4DW1J8R179ehyxb
         tTKCesTL8qNGnOGE0UDO2ts9IeMuhsDGyUXM82fgb19xpE79Ww7BQ10U8DVxVWL54ZP7
         uxig==
X-Gm-Message-State: AOJu0YzgVTQR3T3EI6WDnj9g1u6cZUJxYxv/9FL8q4ywNwKYm3NRtoAx
	edNaG5vIRw4jmDLKK7/lN/TsuNe0ASfOFIGaYNbuOZrRYni4vq8n81RC9ITtww==
X-Gm-Gg: AY/fxX5bzeIt6lZJQQMBD/0WWstkEXQb6SFF+nVJ9IkUt38TucRH8khrgVRInbMGUo1
	0bh2Lx5i2K4IKdCgS5y/RIYWmpgZawL3VfJIOMqAIKfliXJGkveSrnMO5uh8QV9O1mTQnG4JMr7
	OeIyLXEHKMOgaYj75fN8klGG4nYq8DEd9L8R9jtqL0Ogv0jAYYy7Vo9t52YTVqFYmoNK32kFEsY
	THgl2hxzKpQs0hHYpiWEd4lhLbvZ5PDbR31AEiOAC8vbDaHKVcgZBRtaAvvVzYnM0v+WSq6Lnxp
	/B9ioal/WMv6ructymbCRiP9RhFVb1KxCsSykbUjhEgBv/qfpkdrv0bezLRVEL+3vbxuqxgUByS
	FCdA3eF/OSNe1M3WvX3ooTTLsYk2JnhIdKcrOpgYsMK0Y442I0YgycJokADo0pA9rhCo1npfwi3
	QdAiPIyNjaatCu+rg5b2+PNPEded3fUmNfhMNITZd3jmMDnRwon5XdfBiJ1l5Cg23fd4Lc8dD1
X-Google-Smtp-Source: AGHT+IHz3/MZq5IE1wUR5QXf+2IHt/MHhR2WlMb82Jjaiy4vcro767CKSZ9wAVL85Hpc2XOy6zo8xg==
X-Received: by 2002:a5d:5d13:0:b0:430:f58d:40d7 with SMTP id ffacd0b85a97d-432c374f477mr29322767f8f.13.1768312725842;
        Tue, 13 Jan 2026 05:58:45 -0800 (PST)
Received: from ehlo.thunderbird.net (dynamic-002-242-220-137.2.242.pool.telefonica.de. [2.242.220.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dadcfsm43551328f8f.3.2026.01.13.05.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 05:58:45 -0800 (PST)
Date: Tue, 13 Jan 2026 13:58:44 +0000
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_11/32=5D_kvm/i386=3A_reload?=
 =?US-ASCII?Q?_firmware_for_confidential_guest_reset?=
In-Reply-To: <20260112132259.76855-12-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-12-anisinha@redhat.com>
Message-ID: <1840E5EB-CFD2-478E-B6CB-242B46FD5166@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 12=2E Januar 2026 13:22:24 UTC schrieb Ani Sinha <anisinha@redhat=2Ecom=
>:
>When IGVM is not being used by the confidential guest, the guest firmware=
 has
>to be reloaded explictly again into memory=2E This is because, the memory=
 into
>which the firmware was loaded before reset was encrypted and is thus lost
>upon reset=2E When IGVM is used, it is expected that the IGVM will contai=
n the
>guest firmware and the execution of the IGVM directives will set up the g=
uest
>firmware memory=2E
>
>Signed-off-by: Ani Sinha <anisinha@redhat=2Ecom>
>---
> target/i386/kvm/kvm=2Ec | 28 ++++++++++++++++++++++++++++
> 1 file changed, 28 insertions(+)
>
>diff --git a/target/i386/kvm/kvm=2Ec b/target/i386/kvm/kvm=2Ec
>index 4fedc621b8=2E=2E46c4f9487b 100644
>--- a/target/i386/kvm/kvm=2Ec
>+++ b/target/i386/kvm/kvm=2Ec
>@@ -51,6 +51,8 @@
> #include "qemu/config-file=2Eh"
> #include "qemu/error-report=2Eh"
> #include "qemu/memalign=2Eh"
>+#include "qemu/datadir=2Eh"
>+#include "hw/core/loader=2Eh"
> #include "hw/i386/x86=2Eh"
> #include "hw/i386/kvm/xen_evtchn=2Eh"
> #include "hw/i386/pc=2Eh"
>@@ -3267,6 +3269,22 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
>=20
> static int xen_init_wrapper(MachineState *ms, KVMState *s);
>=20
>+static void reload_bios_rom(X86MachineState *x86ms)
>+{
>+    int bios_size;
>+    const char *bios_name;
>+    char *filename;
>+
>+    bios_name =3D MACHINE(x86ms)->firmware ?: "bios=2Ebin";
>+    filename =3D qemu_find_file(QEMU_FILE_TYPE_BIOS, bios_name);
>+
>+    bios_size =3D get_bios_size(x86ms, bios_name, filename);
>+
>+    void *ptr =3D memory_region_get_ram_ptr(&x86ms->bios);
>+    load_image_size(filename, ptr, bios_size);
>+    x86_firmware_configure(0x100000000ULL - bios_size, ptr, bios_size);
>+}

All code in this function is already present in x86-common=2Ec=2E Can we m=
ove this function there (possibly renaming it to x86_bios_rom_reload()) and=
 export it? This way, we could avoid code duplication and we didn't need to=
 export additional functions like in the previous patch=2E

Best regards,
Bernhard

>+
> int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
> {
>     Error *local_err =3D NULL;
>@@ -3285,6 +3303,16 @@ int kvm_arch_vmfd_change_ops(MachineState *ms, KVM=
State *s)
>             error_report_err(local_err);
>             return ret;
>         }
>+        if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
>+            X86MachineState *x86ms =3D X86_MACHINE(ms);
>+            /*
>+             * If an IGVM file is specified then the firmware must be pr=
ovided
>+             * in the IGVM file=2E
>+             */
>+            if (!x86ms->igvm) {
>+                reload_bios_rom(x86ms);
>+            }
>+        }
>     }
>=20
>     ret =3D kvm_vm_enable_exception_payload(s);

