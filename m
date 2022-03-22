Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC0F4E3D74
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiCVLW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiCVLW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:22:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 161B47EA36
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 04:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647948090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bx3w8/lhlewJ7oUWvr/1eh6laDl4Abf2g0d4r2c9J7s=;
        b=IQsjzdeoayze1e0tU6B+hxMqXEDpVLMjmLFwKfSjC5T8VFOQSnX4PYsXTj+z92k4T7gkth
        Oh71BBhaOCs8tMbxVOLcj/LWQCoaAzkLqdITYzfWYcTgF06FgRet1t8soimR5YCEGKCc+q
        zfAm2DzlCcZjyAk0PdY/AutD+jYjjco=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-f2gm2QN5P0KyTeVEcwAqiA-1; Tue, 22 Mar 2022 07:21:28 -0400
X-MC-Unique: f2gm2QN5P0KyTeVEcwAqiA-1
Received: by mail-ed1-f69.google.com with SMTP id b10-20020a50e38a000000b00418cd24fd27so10399238edm.8
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 04:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bx3w8/lhlewJ7oUWvr/1eh6laDl4Abf2g0d4r2c9J7s=;
        b=0wGur7pB6w0IKZsiIEQcrwyxLGVHA4AQv9LpKK7HY+MpthP6BHygv04BtYVXAG0kQ2
         nU2kWr3Z+VfNLYqh6gp+UTXOeJAtt/cnhsTpMj9jhMlzP42ob+sBndZjIVD8ewIA+DT5
         Bw/BBhkI4UPPjIw2DN/r/RKmG5Il1zsn7QgVqvr0k6ZeaPI477B2ylFynoy9ORfx1n2p
         YRwK5HUxlHEAtdJ6/2HDuChwiV8SKJZ0ncXxVrkBgcKhW5KJ1+UoX570P+OEGN2c6As8
         Lq/XUel1xkAKnWW36SUq/nQvNLp9E6OW6B/Mi25jSB7YBXzBFgvjoPhB0kCuoARSQg0+
         5VAQ==
X-Gm-Message-State: AOAM531ktaxPyLtb1BTtZwNIgU1o4URusoOqtNxIxLbY3r4ZL20yf9T7
        KNVUaElK9rTWxebjbriFwgDcM8Cp8MEmeEie7Z+lGVtX3rNgZwMQTBcp2IkKkS2S8PbygzmFGDH
        WHgzDLa0HNCVu
X-Received: by 2002:a05:6402:5243:b0:419:4ce2:cb5c with SMTP id t3-20020a056402524300b004194ce2cb5cmr6931904edd.151.1647948087530;
        Tue, 22 Mar 2022 04:21:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiCZtBiS5tBYkHXW9CYVzlZ6xWEpBQiuxdMrs5J8/gCaIPyAwbOSsr9vx7UIAZ7GGLmjEZiA==
X-Received: by 2002:a05:6402:5243:b0:419:4ce2:cb5c with SMTP id t3-20020a056402524300b004194ce2cb5cmr6931812edd.151.1647948087187;
        Tue, 22 Mar 2022 04:21:27 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id hs12-20020a1709073e8c00b006dfd7dee980sm4080173ejc.30.2022.03.22.04.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:21:26 -0700 (PDT)
Date:   Tue, 22 Mar 2022 12:21:24 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?B?SGVydsOp?= Poussineau <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?B?Q8Op?= =?UTF-8?B?ZHJpYw==?= Le Goater 
        <clg@kaod.org>, Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
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
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
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
Subject: Re: [PATCH v2 3/3] Use g_new() & friends where that makes obvious
 sense
Message-ID: <20220322122124.4f1d76e9@redhat.com>
In-Reply-To: <20220315144156.1595462-4-armbru@redhat.com>
References: <20220315144156.1595462-1-armbru@redhat.com>
        <20220315144156.1595462-4-armbru@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Mar 2022 15:41:56 +0100
Markus Armbruster <armbru@redhat.com> wrote:

> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
> for two reasons.  One, it catches multiplication overflowing size_t.
> Two, it returns T * rather than void *, which lets the compiler catch
> more type errors.
>=20
> This commit only touches allocations with size arguments of the form
> sizeof(T).
>=20
> Patch created mechanically with:
>=20
>     $ spatch --in-place --sp-file scripts/coccinelle/use-g_new-etc.cocci \
> 	     --macro-file scripts/cocci-macro-file.h FILES...
>=20
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
> Reviewed-by: C=C3=A9dric Le Goater <clg@kaod.org>
> Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>


for */i386/*
Reviewed-by: Igor Mammedov <imammedo@redhat.com>


nit:
possible miss, see below=20

[...]
> diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
> index cf8e500514..0731f70410 100644
> --- a/hw/i386/xen/xen-hvm.c
> +++ b/hw/i386/xen/xen-hvm.c

missed:

 pfn_list =3D g_malloc(sizeof (*pfn_list) * nr_pfn);


> @@ -396,7 +396,7 @@ go_physmap:
> =20
>      mr_name =3D memory_region_name(mr);
> =20
> -    physmap =3D g_malloc(sizeof(XenPhysmap));
> +    physmap =3D g_new(XenPhysmap, 1);
> =20
>      physmap->start_addr =3D start_addr;
>      physmap->size =3D size;
> @@ -1281,7 +1281,7 @@ static void xen_read_physmap(XenIOState *state)
>          return;
> =20
>      for (i =3D 0; i < num; i++) {
> -        physmap =3D g_malloc(sizeof (XenPhysmap));
> +        physmap =3D g_new(XenPhysmap, 1);
>          physmap->phys_offset =3D strtoull(entries[i], NULL, 16);
>          snprintf(path, sizeof(path),
>                  "/local/domain/0/device-model/%d/physmap/%s/start_addr",
> @@ -1410,7 +1410,7 @@ void xen_hvm_init_pc(PCMachineState *pcms, MemoryRe=
gion **ram_memory)
>      xen_pfn_t ioreq_pfn;
>      XenIOState *state;
> =20
> -    state =3D g_malloc0(sizeof (XenIOState));
> +    state =3D g_new0(XenIOState, 1);
> =20
>      state->xce_handle =3D xenevtchn_open(NULL, 0);
>      if (state->xce_handle =3D=3D NULL) {
> @@ -1463,7 +1463,7 @@ void xen_hvm_init_pc(PCMachineState *pcms, MemoryRe=
gion **ram_memory)
>      }
> =20
>      /* Note: cpus is empty at this point in init */
> -    state->cpu_by_vcpu_id =3D g_malloc0(max_cpus * sizeof(CPUState *));
> +    state->cpu_by_vcpu_id =3D g_new0(CPUState *, max_cpus);
> =20
>      rc =3D xen_set_ioreq_server_state(xen_domid, state->ioservid, true);
>      if (rc < 0) {
> @@ -1472,7 +1472,7 @@ void xen_hvm_init_pc(PCMachineState *pcms, MemoryRe=
gion **ram_memory)
>          goto err;
>      }
> =20
> -    state->ioreq_local_port =3D g_malloc0(max_cpus * sizeof (evtchn_port=
_t));
> +    state->ioreq_local_port =3D g_new0(evtchn_port_t, max_cpus);

[...]

