Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BF76DE513
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 21:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjDKTnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 15:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDKTnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 15:43:42 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4896819AB;
        Tue, 11 Apr 2023 12:43:41 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4ec83ae6138so125441e87.0;
        Tue, 11 Apr 2023 12:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681242219; x=1683834219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1TnsQ9wjUJl0G46e4cb8CsfvxjviIIz6J6pY4yX954=;
        b=qG4NMge0Vy33i1Z9O4LV/mcYQvPi83dyiun8LPgjIJz+6SfA65xJyj3ad47biJyUlm
         9Od87fDBQ0dAC51rDv11EngokB7iIa+VLqXp8SHGb0GmKEfWtXgeqDon8dYyiEC1UQGG
         Xxb+SuXiDOogsqbECNVgsBkM7d/wEfa/aanKV/7UB8r9g/DD5XgiAJy8quUUdGAWPyi+
         sm0tg4wZOW/EZLb48xCj/x4CUCH64uWvMcM8XzUK/30cT01+bHaI2mJ2sLgyMEwZV64+
         /s4lXqrEgQAaGGk6OOrNbBw4zeN3s3KjQsMHkvp0Ps+d5QX2fDJ8p4/ACH0kkGpzhW2L
         920w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681242219; x=1683834219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1TnsQ9wjUJl0G46e4cb8CsfvxjviIIz6J6pY4yX954=;
        b=moCkw3c8WnXseVxn9a+t+rV+itEqAcep7XaNPgfeP/YzlBwdHpVv4m7fKWgE1ALAHZ
         q/gxsqCRKLfcUzgFWSMbhaOntUMbuShoOg13t/qd5PjkYi92yzJCAOt6VZ4w+2ke4RIf
         8qy4I1hmj8os5F0r9/AXN8rIr+UEv9d+AI1YvjcgB/3o/0oUzPT852cEeRerMg3vd0QP
         U/yvEgrjYeyRjWvdgG4me8NN7P9zVOKOu5geZ4sNgk0Fd3K7EVtRK+g0ymS+e4ksGFU8
         /Cox+5f+PpQ/n9y9YLCL0YxIddDLURTD/vCMIAUVAXyQKYX6/VeXXUd3K2cFdXhok4Kv
         yojg==
X-Gm-Message-State: AAQBX9eGP/JBXZbuKxBAkgIZGu9ntVWHPd/LayjfX7ic87W4AB5swByl
        MN9K4bVO4YviWKdNk43EE7c=
X-Google-Smtp-Source: AKy350YbMcr621QQlpdxzGafvMmNEwL92ZsmsUyPGg3PVqUZUpqKdom+drTz7UwEFbdrKH+f35IIsQ==
X-Received: by 2002:a05:651c:1613:b0:2a7:805e:b0e6 with SMTP id f19-20020a05651c161300b002a7805eb0e6mr1718959ljq.2.1681242219161;
        Tue, 11 Apr 2023 12:43:39 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id q12-20020ac24a6c000000b004eaf55936eesm2638471lfp.233.2023.04.11.12.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 12:43:39 -0700 (PDT)
Date:   Tue, 11 Apr 2023 22:43:37 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
        =?ISO-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: SVM: add some info prints to SEV init
Message-ID: <20230411224337.000015ce.zhi.wang.linux@gmail.com>
In-Reply-To: <20230404122652.275005-3-aleksandr.mikhalitsyn@canonical.com>
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
        <20230404122652.275005-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  4 Apr 2023 14:26:52 +0200
Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com> wrote:

> Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
> enabling a little bit handier for users. Right now it's too hard
> to guess why SEV/SEV-ES are failing to enable.
>=20
> There are a few reasons.
> SEV:
> - npt is disabled (module parameter)
     ^NPT
> - CPU lacks some features (sev, decodeassists)
> - Maximum SEV ASID is 0
>=20
> SEV-ES:
> - mmio_caching is disabled (module parameter)
> - CPU lacks sev_es feature
> - Minimum SEV ASID value is 1 (can be adjusted in BIOS/UEFI)
>=20
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: St=E9phane Graber <stgraber@ubuntu.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
>  arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a42536a0681a..14cbb8f14c6b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2168,17 +2168,24 @@ void __init sev_hardware_setup(void)
>  	bool sev_es_supported =3D false;
>  	bool sev_supported =3D false;
> =20
> -	if (!sev_enabled || !npt_enabled)
> +	if (!sev_enabled)
>  		goto out;
> =20
> +	if (!npt_enabled) {
> +		pr_info("Failed to enable AMD SEV as it requires Nested Paging to be e=
nabled\n");
> +		goto out;

Shouldn't we use pr_err() for error message?

> +	}
> +
>  	/*
>  	 * SEV must obviously be supported in hardware.  Sanity check that the
>  	 * CPU supports decode assists, which is mandatory for SEV guests to
>  	 * support instruction emulation.
>  	 */
>  	if (!boot_cpu_has(X86_FEATURE_SEV) ||
> -	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)))
> +	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS))) {
> +		pr_info("Failed to enable AMD SEV as it requires decodeassists and sev=
 CPU features\n");
>  		goto out;
> +	}
> =20
>  	/* Retrieve SEV CPUID information */
>  	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
> @@ -2188,8 +2195,10 @@ void __init sev_hardware_setup(void)
> =20
>  	/* Maximum number of encrypted guests supported simultaneously */
>  	max_sev_asid =3D ecx;
> -	if (!max_sev_asid)
> +	if (!max_sev_asid) {
> +		pr_info("Failed to enable SEV as the maximum SEV ASID value is 0.\n");
>  		goto out;
> +	}
> =20
>  	/* Minimum ASID value that should be used for SEV guest */
>  	min_sev_asid =3D edx;
> @@ -2234,16 +2243,22 @@ void __init sev_hardware_setup(void)
>  	 * instead relies on #NPF(RSVD) being reflected into the guest as #VC
>  	 * (the guest can then do a #VMGEXIT to request MMIO emulation).
>  	 */
> -	if (!enable_mmio_caching)
> +	if (!enable_mmio_caching) {
> +		pr_info("Failed to enable SEV-ES as it requires MMIO caching to be ena=
bled\n");
>  		goto out;
> +	}
> =20
>  	/* Does the CPU support SEV-ES? */
> -	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
> +	if (!boot_cpu_has(X86_FEATURE_SEV_ES)) {
> +		pr_info("Failed to enable SEV-ES as it requires sev_es CPU feature\n");
>  		goto out;
> +	}
> =20
>  	/* Has the system been allocated ASIDs for SEV-ES? */
> -	if (min_sev_asid =3D=3D 1)
> +	if (min_sev_asid =3D=3D 1) {
> +		pr_info("Failed to enable SEV-ES as the minimum SEV ASID value is 1.\n=
");
>  		goto out;
> +	}
> =20
>  	sev_es_asid_count =3D min_sev_asid - 1;
>  	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))

As this patch is making sev_hardware_setup()more informative, it would be
better to print both ASID range and count (instead of only ASID count in
the current code). I was suspecting there seems a bug of ASID range allocat=
ion
in the current code, but I don't have the HW to test yet...=20
