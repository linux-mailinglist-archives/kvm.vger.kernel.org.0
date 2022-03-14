Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1049C4D8C3E
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbiCNTX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiCNTX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:23:28 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419141AF1E
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:22:18 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gb39so35960726ejc.1
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=tycv6HJZUTnQM7on2TavcKhNCFhbcZz1vxyWXIQR71o=;
        b=A0oYLouNRVTZ4V9w3HZxOkB6cJW9hiI3hbFyTqQMx9TKG2yR59woJojs96yqxoBIuC
         YUMI4L32csrMTrJ97Quu8vYBMDdCkobHf+Ilop8Mi2A98XMYLmS6xUm59zLvi0olWvPO
         epYH0BSvosR26pLIH2BGasEfulC8lnKJcQI5bMuiy0mk3M9L7uraIExkoDhzQ+YH/Qiu
         wf7HJSEQuk606ZD7pnYWZGLuoUahygOlfF++b9QAxAvINlDfnwldYbX0i0mMsTl+PIPZ
         X4cBbVK210OAe7WBg8X3EeM3L2anNSTnuu/JTD1/Av9oTe1rBpyrU9Wnoq81+J1uK0F+
         fZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=tycv6HJZUTnQM7on2TavcKhNCFhbcZz1vxyWXIQR71o=;
        b=7Ao7EIjMk5o3mUsyHMuz9n3rkpDN++Rvai+0MhcRLtXDGi8jIgOmLeRWRlNYr523gi
         ZKtVto08s8SqS21EfqzJrEczKWTmJVCKvMxH8zjJ3F1J5Jtuk0fo3DfAIo5krVyv7XA/
         k4y9qJnP0FpFlp9353RkDCSmjSUO4TIPf3BelJRV1kJ40tgOFrdlVpfq6xfrVRENStpP
         umlzC3fr4snikYpt2j8+4cDUIaZhTBN7YoAuF5OeRWXmTVX1cHw8iFE/oNkI0CI+my14
         FO+wiStIDfoALv0pqxSSSGz40ipvQxNKu0RGBfIdsgRR4LBtEC81QJty/wpML1+R+pRb
         vL5w==
X-Gm-Message-State: AOAM531aUDwlaKbVCjfM30nOD/CYQI20nyuwdtU/LLbvwxo8/ni58zIW
        XqN7s9HNI9xHGumFnBW7XiESjw==
X-Google-Smtp-Source: ABdhPJyZ40YA2iaGpfjLcmHdGtDuwx2DfuZnNx8jf0MEbsTZ0XgePOcHoiB/af+Q2Qg2ulb58S7BPg==
X-Received: by 2002:a17:907:a42a:b0:6db:c8f4:b732 with SMTP id sg42-20020a170907a42a00b006dbc8f4b732mr7894612ejc.284.1647285736816;
        Mon, 14 Mar 2022 12:22:16 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id zb5-20020a17090687c500b006ce2a98f715sm7060263ejb.117.2022.03.14.12.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:22:15 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 0921D1FFB7;
        Mon, 14 Mar 2022 19:22:15 +0000 (GMT)
References: <20220314160108.1440470-1-armbru@redhat.com>
 <20220314160108.1440470-2-armbru@redhat.com>
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
Subject: Re: [PATCH 1/3] scripts/coccinelle: New use-g_new-etc.cocci
Date:   Mon, 14 Mar 2022 19:22:09 +0000
In-reply-to: <20220314160108.1440470-2-armbru@redhat.com>
Message-ID: <87ilsg5ogp.fsf@linaro.org>
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

> This is the semantic patch from commit b45c03f585 "arm: Use g_new() &
> friends where that makes obvious sense".
>
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
