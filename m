Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2327D4D8FE9
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 23:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343536AbiCNW4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 18:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbiCNW4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 18:56:23 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A237F36E2A
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 15:55:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b24so21940006edu.10
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 15:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=y2Q/inabtnNQGMD1STwoVXN1cYBrHr5EEIPdNdUQA8M=;
        b=B3Ph160SYsccuR00NVF/PocSGd5KiKeGpNJQ+RhhnFCFJnM/0IodWWwadeJcwcmY+1
         p7mK/8zR77h4sFn6DIJS4jdi8ycIdBa6GBZQ6BXKTb3vVVmexiMZjgQShP38GekQRhLR
         OFFa1yqM6ceyWSEt+cqGDYutIRVgD92f7oipq5Mg9BeeGJDwvUB0CNZczv+2oAKHL7RU
         XtPyTH4G288CVUiVrITqt6JutYE0Qb0TgEX3xgugz+3QvZ9/Wgx/vbThbekaqzBLCdmr
         djWEZim/YuTV6z1bWLbTLYuLWSD1hi3Ql3isNXnEieORmw90FONvnt5WSh0jULarEWnD
         mY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=y2Q/inabtnNQGMD1STwoVXN1cYBrHr5EEIPdNdUQA8M=;
        b=Oh7Z45Kpas59xPtAWvCycOI4ATrudFwtewh7UwfK0M2n4y/lwl/LrPUbMVpdFuwn5y
         AjmPBOrmTmvh9XeZDLPnAhyFxQ0HMykl/eYsP5ZSdESNYggOX40nlM9ecijYB8y3+07O
         /zesfMXGFlaW6H1F2fKLgmpbyK/XXhDkx2ntyuBRhUzT7TbNcRKDHtS6c+CbtbPnpasK
         opK/ZDK5hDnCROnqJHNn/EdBdp7GNu2TnkYKzO09psypKOtrHk94sTz21bCyuRvQqYjJ
         LWLhkGL9ZNrYntdpTW63GVSoMXIquYmtdbAjlywFViqe+2sivVHF7fV7ySemlIZmQTJS
         Pk3A==
X-Gm-Message-State: AOAM533LpEA5u+cp3LeVd3+UgHOCZGPAzuef7RwLWXRdan/IXHTMJUpV
        hteaoxjW4I0uOEnJyAxC+STsMQ==
X-Google-Smtp-Source: ABdhPJxuZxtDdnhy4Gj1uUNyNIF4Q1otKPH/l3hhaM0nWqHIIS9oPgWPUcws559h68k7pQArpUf2fg==
X-Received: by 2002:aa7:c6d7:0:b0:415:a0fc:1dcd with SMTP id b23-20020aa7c6d7000000b00415a0fc1dcdmr23455380eds.266.1647298511203;
        Mon, 14 Mar 2022 15:55:11 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id v5-20020a50c405000000b004161123bf7asm8674775edf.67.2022.03.14.15.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:55:10 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 47A0E1FFB7;
        Mon, 14 Mar 2022 22:55:09 +0000 (GMT)
References: <20220314160108.1440470-1-armbru@redhat.com>
 <20220314160108.1440470-4-armbru@redhat.com>
User-agent: mu4e 1.7.10; emacs 28.0.92
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?utf-8?Q?Herv=C3=A9?= Poussineau <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, xen-devel@lists.xenproject.org,
        qemu-ppc@nongnu.org, qemu-block@nongnu.org, haxm-team@intel.com,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH 3/3] Use g_new() & friends where that makes obvious sense
Date:   Mon, 14 Mar 2022 22:52:52 +0000
In-reply-to: <20220314160108.1440470-4-armbru@redhat.com>
Message-ID: <87y21c401e.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Markus Armbruster <armbru@redhat.com> writes:

> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
> for two reasons.  One, it catches multiplication overflowing size_t.
> Two, it returns T * rather than void *, which lets the compiler catch
> more type errors.
>
<snip>
> diff --git a/semihosting/config.c b/semihosting/config.c
> index 137171b717..6d48ec9566 100644
> --- a/semihosting/config.c
> +++ b/semihosting/config.c
> @@ -98,7 +98,7 @@ static int add_semihosting_arg(void *opaque,
>      if (strcmp(name, "arg") =3D=3D 0) {
>          s->argc++;
>          /* one extra element as g_strjoinv() expects NULL-terminated arr=
ay */
> -        s->argv =3D g_realloc(s->argv, (s->argc + 1) * sizeof(void *));
> +        s->argv =3D g_renew(void *, s->argv, s->argc + 1);

This did indeed break CI because s->argv is an array of *char:

../semihosting/config.c:101:17: error: assignment to =E2=80=98const char **=
=E2=80=99 from incompatible pointer type =E2=80=98void **=E2=80=99 [-Werror=
=3Dincompatible-pointer-types]
  101 |         s->argv =3D g_renew(void *, s->argv, s->argc + 1);
      |                 ^
cc1: all warnings being treated as errors

So it did the job of type checking but failed to build ;-)


--=20
Alex Benn=C3=A9e
