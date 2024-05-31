Return-Path: <kvm+bounces-18533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE6B8D60B2
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DF181F23C8C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDEBB15748B;
	Fri, 31 May 2024 11:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XDiK3siC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBBD156654
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717154875; cv=none; b=axptM2NKuWpKDtL4iG25SRrejGZncVffYieeaXQjnbAgBL6AicS9MwHQcxFxcz09TTTpyHVP/HG+3wQl3sAhja4CJfjk0RhOoldMQz30EWC9DFo/n7HIsFD0hO0LFUrBD4bF62JCFkV3Q++vyZlVBymJEXiYgm7FGb9AZOhVRPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717154875; c=relaxed/simple;
	bh=VHUrpfLuGlDmZC0wF7t0YayAlCmwVqvB0TLYMVJT7cY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EQrNZedmwYjO12KT7FZUu+5cuJmKrzCeMNXlT2GtxmZJnWOyZLEO0onr/PISChYXlfZNBOmfsKzuCo6oiWqjzgFXoRDYLiw1bsppEveFsim16RYDXROla7h629gqKJ93pO4SX3SxXEO9rUAuwZR1h8Px2I7hRTDRP+oorxXthQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XDiK3siC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717154872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQXLkmaihewQQ+Q3DK3T/I1QdWmZfEA3y+2sPA08/tU=;
	b=XDiK3siC4+WHNeu/eyppdmiG5fCLhC/pbhtNvXu1dAnSgk+V1HZc4SX9mjOkBLQr5+MziU
	wQpnRtD4U3MQV+/Etuf7bQECACEJEvj46Gdp6RbeRzIAjnI+FC3sowd5m0/ecO9h+9gske
	j3PWfvdP/5Loibc64/T8RpAYlkFodww=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-Tvh3d5p1P1KSGwh2qwe4Zw-1; Fri, 31 May 2024 07:27:51 -0400
X-MC-Unique: Tvh3d5p1P1KSGwh2qwe4Zw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35dca4a8f2dso990195f8f.3
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:27:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717154870; x=1717759670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQXLkmaihewQQ+Q3DK3T/I1QdWmZfEA3y+2sPA08/tU=;
        b=cHoDjT+wpSVoZX+MrTvz5AbUeARmYSeCliD8fOaDGkxIYfS0i/W/t0aAhDcWJLqFEn
         oeqi0FQZQJMKx0lCG2baaHQLaxh4mUm5Ive89BRQn8/SWUFIdEPy2zuaqfBU6kUIV7kv
         QQYrEKfTc8jPVOM25KlW7tRTNKXkgoe6QbbCUkRFM4RNXZWghpwJ9gPBe9xYZpCxeig8
         8H0Wc69OJi6mLBvvGeHZtkHcfsuz21wPj9fQcNPTx/AjY/YZDBqcXxy3u/mXRvvoP8WM
         kxeELrvztVAGYn1j4BSiAtoc9exKbZGq9dVrV55CQRfBFVVN9B9sUxHoFlVaeqedxF9O
         7C3w==
X-Forwarded-Encrypted: i=1; AJvYcCUe0XmIc931uoFj/MwEWinDAuAyQ1AP8oVT57x4baFetHKIV0FW1xu7IicDYOzu+qYakkm8XSFJ5lMnPKW/dW23gsmX
X-Gm-Message-State: AOJu0YzGMCPnlrK9DnLf29Kv/s0Jb2IZxdIZnLniZvNOEbYITFusNIZK
	zi8qCWIbp/62TDF2PGzPkwOENXF5/5CBISBCboX+7SZAS+fsPRMBLRnt5FDxW+8+oN6iGLyA2AN
	FFiXpah8UrHqqees0IhAPse0ybo3uOkOMomHifwVe5EnzyLvhupNXyBN7+4o6DHGbUo4Nz6rSOp
	YkcSWebvdYBUjvV3dIk+v8eoA6
X-Received: by 2002:a5d:5388:0:b0:355:3cc:485f with SMTP id ffacd0b85a97d-35e0f26e9bfmr1067081f8f.21.1717154869820;
        Fri, 31 May 2024 04:27:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEh2AwYrrRRWkZx282BhkBX/chfbWOE/90tS5yY6z39+zH4RCTmIFYdxi76wrQjyOesvxCcffaKzl7ahUeX8LE=
X-Received: by 2002:a5d:5388:0:b0:355:3cc:485f with SMTP id
 ffacd0b85a97d-35e0f26e9bfmr1067061f8f.21.1717154869422; Fri, 31 May 2024
 04:27:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-28-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-28-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:27:36 +0200
Message-ID: <CABgObfZ48ukQ5UaLqi01Xc7Rs+Lo+iiKkFcSMd4qq_RFz1+-TA@mail.gmail.com>
Subject: Re: [PATCH v4 27/31] hw/i386/sev: Use guest_memfd for legacy ROMs
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
>
> From: Michael Roth <michael.roth@amd.com>
>
> Current SNP guest kernels will attempt to access these regions with
> with C-bit set, so guest_memfd is needed to handle that. Otherwise,
> kvm_convert_memory() will fail when the guest kernel tries to access it
> and QEMU attempts to call KVM_SET_MEMORY_ATTRIBUTES to set these ranges
> to private.
>
> Whether guests should actually try to access ROM regions in this way (or
> need to deal with legacy ROM regions at all), is a separate issue to be
> addressed on kernel side, but current SNP guest kernels will exhibit
> this behavior and so this handling is needed to allow QEMU to continue
> running existing SNP guest kernels.

[...]

>  #ifdef CONFIG_XEN_EMU
> @@ -1022,10 +1023,15 @@ void pc_memory_init(PCMachineState *pcms,
>      pc_system_firmware_init(pcms, rom_memory);
>
>      option_rom_mr =3D g_malloc(sizeof(*option_rom_mr));
> -    memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
> -                           &error_fatal);
> -    if (pcmc->pci_enabled) {
> -        memory_region_set_readonly(option_rom_mr, true);
> +    if (sev_snp_enabled()) {

Using sev_snp_enabled() here however is pretty ugly...

Fortunately we can fix machine_require_guest_memfd(), which I think is
initialized later (?), so that it is usable here too (and the code is
cleaner). To do so, just delegate machine_require_guest_memfd() to the
ConfidentialGuestSupport object (see patch at
https://patchew.org/QEMU/20240531112636.80097-1-pbonzini@redhat.com/)
and then initialize the new field in SevSnpGuest's instance_init
function:

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1c5e2e7a1f9..a7574d1c707 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -2328,8 +2328,11 @@ sev_snp_guest_class_init(ObjectClass *oc, void *data=
)
 static void
 sev_snp_guest_instance_init(Object *obj)
 {
+    ConfidentialGuestSupport *cgs =3D CONFIDENTIAL_GUEST_SUPPORT(obj);
     SevSnpGuestState *sev_snp_guest =3D SEV_SNP_GUEST(obj);

+    cgs->require_guest_memfd =3D true;
+
     /* default init/start/finish params for kvm */
     sev_snp_guest->kvm_start_conf.policy =3D DEFAULT_SEV_SNP_POLICY;
 }


Paolo


