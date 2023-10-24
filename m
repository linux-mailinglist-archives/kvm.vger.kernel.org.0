Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7437D567F
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbjJXPdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbjJXPdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:33:40 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D357BD
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:33:38 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-507e85ebf50so5004188e87.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698161616; x=1698766416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgn7DZOjqiLKpDeJIAWXRIPQaKWXfmUlyU40rW5Vul0=;
        b=LP8mIvd6pNUI+WoUxG+xVoaGgOKUkBkSO05U9rTpVqP9U2mKtmxWB+m2rD0tXEaCX0
         /Q9lqUoU9vHKap8KqtAOSam7LTL4nUwWS3M7axmunOZdMulWks07JEU0xQ+yIdNu78JW
         iGkhZ2Gci2SIwOA8ivCct3d9uvZ+rXep9SCHY9OjtsEVGdfIApWf90eDrjP7hIRw4GJp
         b22ZEkqw1jW6fWy9kv14q29FCz6r5BVD6ROzBIaMP9KfEqkT70Su0pwTEr8R9JUUwSfB
         AmB7N6tpDbzoWqTdrM3iptkr+DX2G+RqDN8a+PSiw2fpSBoaFeJS3RXMvQrjPPGzeBsy
         zrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698161616; x=1698766416;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pgn7DZOjqiLKpDeJIAWXRIPQaKWXfmUlyU40rW5Vul0=;
        b=T2XDq+Wm+1MkYyWaVz+BxGshttYX5o8PuBBcoYiQs4yAIPec4bilziX0FO/2xPatvR
         K/kfZ1114uDbevNdIxihlTwdW38swxEMZbhn7innV3hi9ggmGA69ZwjbXas5bFTGpzp2
         B0cucs5AAJvdBlGurG+lV9kfgYeD/XZXc498X8GApnw2XOq2SubfuNp69gvq2n66/mNq
         Bfvf1OQnAQSooGKrSIavZuOIxmHPIG3eB37JTJCYvG7iAIop2mXefM4mlLRTxnxboiaq
         12TDXX0xKNhihkIij2hmyyfpN//VrfIO8qor/WQ1c9/knJK67lDMv+n69Maa6rUsgIyq
         /QGw==
X-Gm-Message-State: AOJu0Yy5e5OCGZru+5SlQLHjJoq9mCXCvOOd5Zv0ru486UTUXX4ye2iV
        c8wf9zfQdRx6J6xfNF8qM63cNQ==
X-Google-Smtp-Source: AGHT+IERaAXJZu/NEaGGq5i9CuYFrG2wQ65+x8yTDScZaEY7DCl2PsKOOkex2LHV25CK2hUsLxDFYA==
X-Received: by 2002:a05:6512:3156:b0:507:a3ae:3252 with SMTP id s22-20020a056512315600b00507a3ae3252mr8565102lfi.27.1698161616310;
        Tue, 24 Oct 2023 08:33:36 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id s3-20020adfea83000000b0031980783d78sm10119502wrm.54.2023.10.24.08.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 08:33:35 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 5E4B91FFBB;
        Tue, 24 Oct 2023 16:33:35 +0100 (BST)
References: <20231016151909.22133-1-dwmw2@infradead.org>
User-agent: mu4e 1.11.22; emacs 29.1.90
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/12] Get Xen PV shim running in qemu
Date:   Tue, 24 Oct 2023 16:24:48 +0100
In-reply-to: <20231016151909.22133-1-dwmw2@infradead.org>
Message-ID: <877cnc2fxs.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


David Woodhouse <dwmw2@infradead.org> writes:

> I hadn't got round to getting the PV shim running yet; I thought it would
> need work on the multiboot loader. Turns out it doesn't. I *did* need to
> fix a couple of brown-paper-bag bugs in the per-vCPU upcall vector suppor=
t,
> and implement Xen console support though. Now I can test PV guests:
>
>  $ qemu-system-x86_64 --accel kvm,xen-version=3D0x40011,kernel-irqchip=3D=
split \
>    -chardev stdio,mux=3Don,id=3Dchar0 -device xen-console,chardev=3Dchar0=
 \
>    -drive file=3D${GUEST_IMAGE},if=3Dxen -display none -m 1G \
>    -kernel ~/git/xen/xen/xen -initrd ~/git/linux/arch/x86/boot/bzImage
>  \

So this is a KVM guest running the Xen hypervisor (via -kernel) and a
Dom0 Linux guest (via -initrd)?

Should this work for any Xen architecture or is this x86 specific? Does
the -M machine model matter?

Would it be possible to have some sort of overview document in our
manual for how Xen guests are supported under KVM?

>    -append "loglvl=3Dall -- console=3Dhvc0 root=3D/dev/xvda1"
>
<snip>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
