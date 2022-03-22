Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45984E3FEC
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbiCVN6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiCVN6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:58:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 813EC3B00E
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 06:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647957394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEnlirW372nmB3J3wABai4eGIbIUqFnFLm6F038KosI=;
        b=JF8puVqyAhpSxztKthS7URRr/ng+0hMMbC0fZSUbQpoSKtUgeYMBvgVjGr3r5Jj9Lv75Fh
        9jidozhQ+vbMSTxaXljmMNTctQ+HNeVIbqCIT94ObpFMECa5wFWVxuB5gMYdCwkMYS9xFo
        AfKcAoGOQtBNVvnBFl7deNfGPE2NSwc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-07Fe7ic6NTaetCGdvKck6A-1; Tue, 22 Mar 2022 09:56:33 -0400
X-MC-Unique: 07Fe7ic6NTaetCGdvKck6A-1
Received: by mail-ed1-f72.google.com with SMTP id f2-20020a50d542000000b00418ed3d95d8so9946611edj.11
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 06:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rEnlirW372nmB3J3wABai4eGIbIUqFnFLm6F038KosI=;
        b=WgUkjFGNVbmFPSCrf+bJz5ac1apNh6m94rxdAGVo+jOONE7edAFOWltpAGyEwFYJZN
         Eg1JphsmwfDuTIEtGQGZ+tcwNtLkQpS5i1FWTXO6AkA/d9vwpUrtLddqMW3FftVKQY4W
         2HJioF8MDNkSDDO4uG/VTome946Vpa3TjLlfZfzOz0Jf7uvKhquutkHw2RBReeLuQVBu
         /l8weurYXVPl/GjG9CyXfxnvf/DkzKlEU7zfzluEGMUQ4AOVh/G9NruQadXhK2VeJAtE
         mA5nGFgOIcV1LhmxOrlcAjVLqAWqDYPs6J2FitqF0nwGFv6Tw262lwTghGKrXtfOYfL/
         f+kQ==
X-Gm-Message-State: AOAM533k9KaOvg8AhCl/QS/IRCjNmVFQSjqvYjfo+3b3ymh/i1CUzFE2
        YmFYLMkixhmvRkAGGTc2NvIv/flQ8IRZYuYbOSPXXqIwx3jqIvlsGy4lCTqicXA+SBHWJh0AMZA
        OeQw5456ZmTkr
X-Received: by 2002:a17:906:7307:b0:6da:92e1:9c83 with SMTP id di7-20020a170906730700b006da92e19c83mr26188100ejc.459.1647957391627;
        Tue, 22 Mar 2022 06:56:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqBDQ65WMaJo5YSmdmuEtqdEirNOnVZJFZPa01uqnSh7sZWzQZ74jeDQEobs73nT3uW/Wuyw==
X-Received: by 2002:a17:906:7307:b0:6da:92e1:9c83 with SMTP id di7-20020a170906730700b006da92e19c83mr26188081ejc.459.1647957391402;
        Tue, 22 Mar 2022 06:56:31 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o3-20020a17090637c300b006d8631b2935sm8268071ejc.186.2022.03.22.06.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 06:56:31 -0700 (PDT)
Date:   Tue, 22 Mar 2022 14:56:29 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= 
        <philippe.mathieu.daude@gmail.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [RFC PATCH-for-7.0 v4] target/i386/kvm: Free xsave_buf when
 destroying vCPU
Message-ID: <20220322145629.7e0b3b8c@redhat.com>
In-Reply-To: <20220322120522.26200-1-philippe.mathieu.daude@gmail.com>
References: <20220322120522.26200-1-philippe.mathieu.daude@gmail.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Mar 2022 13:05:22 +0100
Philippe Mathieu-Daud=C3=A9         <philippe.mathieu.daude@gmail.com> wrot=
e:

> From: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
>=20
> Fix vCPU hot-unplug related leak reported by Valgrind:
>=20
>   =3D=3D132362=3D=3D 4,096 bytes in 1 blocks are definitely lost in loss =
record 8,440 of 8,549
>   =3D=3D132362=3D=3D    at 0x4C3B15F: memalign (vg_replace_malloc.c:1265)
>   =3D=3D132362=3D=3D    by 0x4C3B288: posix_memalign (vg_replace_malloc.c=
:1429)
>   =3D=3D132362=3D=3D    by 0xB41195: qemu_try_memalign (memalign.c:53)
>   =3D=3D132362=3D=3D    by 0xB41204: qemu_memalign (memalign.c:73)
>   =3D=3D132362=3D=3D    by 0x7131CB: kvm_init_xsave (kvm.c:1601)
>   =3D=3D132362=3D=3D    by 0x7148ED: kvm_arch_init_vcpu (kvm.c:2031)
>   =3D=3D132362=3D=3D    by 0x91D224: kvm_init_vcpu (kvm-all.c:516)
>   =3D=3D132362=3D=3D    by 0x9242C9: kvm_vcpu_thread_fn (kvm-accel-ops.c:=
40)
>   =3D=3D132362=3D=3D    by 0xB2EB26: qemu_thread_start (qemu-thread-posix=
.c:556)
>   =3D=3D132362=3D=3D    by 0x7EB2159: start_thread (in /usr/lib64/libpthr=
ead-2.28.so)
>   =3D=3D132362=3D=3D    by 0x9D45DD2: clone (in /usr/lib64/libc-2.28.so)
>=20
> Reported-by: Mark Kanda <mark.kanda@oracle.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
> ---
> Based on a series from Mark:
> https://lore.kernel.org/qemu-devel/20220321141409.3112932-1-mark.kanda@or=
acle.com/
>=20
> RFC because currently no time to test
> ---
>  target/i386/kvm/kvm.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index ef2c68a6f4..e93440e774 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2072,6 +2072,8 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
>      X86CPU *cpu =3D X86_CPU(cs);
>      CPUX86State *env =3D &cpu->env;
> =20
> +    g_free(env->xsave_buf);
> +
>      if (cpu->kvm_msr_buf) {
>          g_free(cpu->kvm_msr_buf);
>          cpu->kvm_msr_buf =3D NULL;


shouldn't we do the same in hvf_arch_vcpu_destroy() ?

