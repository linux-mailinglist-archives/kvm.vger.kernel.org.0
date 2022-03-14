Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3834D8C48
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbiCNTYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbiCNTYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:24:23 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062F82ED
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:23:13 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y8so16288593edl.9
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=vwsEf23SGv9uU5Z5WKKS3nYhdclo4TxJUctKhcssOgU=;
        b=qvTNjBOvKwjtOKZE7TV+144NPqDHMdIuTMR2L4vLzrDFbF50W8MgId7xWklR7gQ7ee
         m1QhfAaSvZnLn66ax1xooADuhGrNNgCne1BBid6u3Gh0LdRB3DCFqDiSzHPBkvSQU7/1
         ARfBXBv6cFzOjaWh+JerzOI2v5WTvgqMRdwX3XRYHJOQ/bMo0EPsBvdMJlCcZ2qiedRE
         03E/08n9fH/SPMmg8wDKXE3wezITjh0Ku7x2GHRQJxOB28dnC8WtnI6ZBWinc58SZVuy
         SMn1h1Gw/QOgZrbW+ApQnfN+ZY7XwXBwNNPCZU9vR3Re+TkWn2jpxFHrOTbRTUk37cfE
         AgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=vwsEf23SGv9uU5Z5WKKS3nYhdclo4TxJUctKhcssOgU=;
        b=u2rVrPDJNhKBAmtYX9NNhQNzsgVfSEtfP00Qi0zt15B/sjkhVR4bU6aPH1B+Ltmkyz
         NC/Muy24IGIFQPfRG7AFMoBnxFyOhkK3uJZ7N3FPxLcPYIAV16/rb0K1LO9x9fWsBs0k
         hC/5CmisHMIlc5GrGiooBvmSqc+EvqJ2+zgiTejb2v3zi3tKy4SwFLN1Ydvd2F4wccqP
         hP+d+638EWARxEk/8yF6QO+eJ4vBxL3ubqyuJYrWcNgfSDyJjPowHfS7GV/R5oS9WzKP
         IXsM/1+LeEdXpNbigL7c9LDiY02R444YU5JNiUROE0mlY8AuxdoU+Yhdok+R6qbIZIOx
         qKSw==
X-Gm-Message-State: AOAM531xjy0mtyo7sUIKrVz3PKBrAmq1TydfeZ2518rGQvHbLMbQ64gS
        GMeanLZ5vngr4i+zBOKXblXSsg==
X-Google-Smtp-Source: ABdhPJwNs9tcech+y/8j0Yw458DeBsLSMUwfihI2IUAIQnPTFMDhF1YpmG7INQr4s5JSlndz7olNXA==
X-Received: by 2002:a05:6402:4311:b0:416:6a08:a9 with SMTP id m17-20020a056402431100b004166a0800a9mr21900173edc.346.1647285791528;
        Mon, 14 Mar 2022 12:23:11 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id l20-20020a1709066b9400b006dabdbc8350sm7157034ejr.30.2022.03.14.12.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:23:10 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 117581FFB7;
        Mon, 14 Mar 2022 19:23:10 +0000 (GMT)
References: <20220314160108.1440470-1-armbru@redhat.com>
 <20220314160108.1440470-3-armbru@redhat.com>
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
Subject: Re: [PATCH 2/3] 9pfs: Use g_new() & friends where that makes
 obvious sense
Date:   Mon, 14 Mar 2022 19:23:04 +0000
In-reply-to: <20220314160108.1440470-3-armbru@redhat.com>
Message-ID: <87ee345of5.fsf@linaro.org>
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
> This commit only touches allocations with size arguments of the form
> sizeof(T).
>
> Patch created mechanically with:
>
>     $ spatch --in-place --sp-file scripts/coccinelle/use-g_new-etc.cocci \
> 	     --macro-file scripts/cocci-macro-file.h FILES...
>
> Except this uncovers a typing error:
>
>     ../hw/9pfs/9p.c:855:13: warning: incompatible pointer types assigning=
 to 'QpfEntry *' from 'QppEntry *' [-Wincompatible-pointer-types]
> 	    val =3D g_new0(QppEntry, 1);
> 		^ ~~~~~~~~~~~~~~~~~~~
>     1 warning generated.
>
> Harmless, because QppEntry is larger than QpfEntry.  Fix to allocate a
> QpfEntry instead.
>
> Cc: Greg Kurz <groug@kaod.org>
> Cc: Christian Schoenebeck <qemu_oss@crudebyte.com>
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
