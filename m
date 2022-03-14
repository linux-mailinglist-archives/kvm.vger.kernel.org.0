Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D4B4D8DE7
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 21:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243568AbiCNULF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 16:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243995AbiCNULE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 16:11:04 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD22713D0C
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:09:52 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g20so21505954edw.6
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=TyjIR8cu39wafofM+zk55pMOkvXNU/TH+17qM8XX/mo=;
        b=bXMVXacOlW6oQtjRy6EEwOPK02lVKTTyd6/63WJ9myEU1O9NELNBNQFwJwnU1Q+IV4
         a78TJqmzB0yQV61DcsiteBFtBrYAxi4UyScHw46RQ01k7cch+G5Ewh1QQePtNuyWlHgn
         vzFykmfP7UPG0DGfUPYpQGUs3MPI/Uz7x8ZBLCOnfYh841aN/yYy991ZkoY8y96vevQT
         rYgPvCHsucOivuwXVbuFg8WfMPJoEnRA0iEIV6Ki9rvqrDNfEdtjhtuyFT6UDnYOPX1z
         T77pzcl0RkLg4VymdgVZj8xTOFCCNeA8qOc10IeoZnUENHsGsyVB5/919v10tE9Dn4b+
         YYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=TyjIR8cu39wafofM+zk55pMOkvXNU/TH+17qM8XX/mo=;
        b=k1bTbxb3fi2r6dWi3/4/6ll8IATyeSrIpJLao8EYD7OUllMavajkzrUiX8t/VK1BjG
         v+X++Sp20Ar/EtvZMywE129UX5Ket/s3ff6I+fLJ/97R5lSvFfg7443d1AoWt1byzOKD
         fTAntORL0b3CF1PP4j8qiEgALkoQodEb2NqM7zDCLWLvzAJpDkPIHGYeQNs0a98CmMPJ
         YXZ2g539bEP5P8dOwdu7LR2vdqxZTqElG7G+NWXYDkUqi/pSMSRrxhuRhzXoMDD/6yjL
         GiVMokVdoaXZUyG/ZhPxw37qNFOLd/b4wl6PKgn5Gmov8klsMuESnFuyoqHQ0+aNtrCc
         f2rw==
X-Gm-Message-State: AOAM530q39d12wD3N+ruGim3oyTJrMmu+sEC7OcJcA4dFVVJqOyxavGG
        NQ0mafVfckNmyM7pf5rp738/ew==
X-Google-Smtp-Source: ABdhPJznYGtR95KUPe9viDQEiWUDwag47XoMVAUfo6SJ9261VlD5UsguQvpBts7G5RsM9cuR85zXaQ==
X-Received: by 2002:a05:6402:2915:b0:416:cad2:d619 with SMTP id ee21-20020a056402291500b00416cad2d619mr17345135edb.221.1647288591200;
        Mon, 14 Mar 2022 13:09:51 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id r23-20020aa7da17000000b00415a1431488sm8701634eds.4.2022.03.14.13.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 13:09:49 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 1FAB51FFB7;
        Mon, 14 Mar 2022 20:09:49 +0000 (GMT)
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
Date:   Mon, 14 Mar 2022 19:48:47 +0000
In-reply-to: <20220314160108.1440470-4-armbru@redhat.com>
Message-ID: <877d8w5m9e.fsf@linaro.org>
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
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
<snip>
> --- a/audio/jackaudio.c
> +++ b/audio/jackaudio.c
> @@ -97,9 +97,9 @@ static void qjack_buffer_create(QJackBuffer *buffer, in=
t channels, int frames)
>      buffer->used     =3D 0;
>      buffer->rptr     =3D 0;
>      buffer->wptr     =3D 0;
> -    buffer->data     =3D g_malloc(channels * sizeof(float *));
> +    buffer->data     =3D g_new(float *, channels);
>      for (int i =3D 0; i < channels; ++i) {
> -        buffer->data[i] =3D g_malloc(frames * sizeof(float));
> +        buffer->data[i] =3D g_new(float, frames);

Are these actually buffers of pointers to floats? I guess I leave that
to the JACK experts...

>      }
>  }
>=20=20
> @@ -453,7 +453,7 @@ static int qjack_client_init(QJackClient *c)
>      jack_on_shutdown(c->client, qjack_shutdown, c);
>=20=20
>      /* allocate and register the ports */
> -    c->port =3D g_malloc(sizeof(jack_port_t *) * c->nchannels);
> +    c->port =3D g_new(jack_port_t *, c->nchannels);
>      for (int i =3D 0; i < c->nchannels; ++i) {

I guess JACK just likes double indirection...

>=20=20
>          char port_name[16];
<snip>
> --- a/hw/pci/pcie_sriov.c
> +++ b/hw/pci/pcie_sriov.c
> @@ -177,7 +177,7 @@ static void register_vfs(PCIDevice *dev)
>      assert(sriov_cap > 0);
>      num_vfs =3D pci_get_word(dev->config + sriov_cap + PCI_SRIOV_NUM_VF);
>=20=20
> -    dev->exp.sriov_pf.vf =3D g_malloc(sizeof(PCIDevice *) * num_vfs);
> +    dev->exp.sriov_pf.vf =3D g_new(PCIDevice *, num_vfs);
>      assert(dev->exp.sriov_pf.vf);

So what I find confusing about the conversion of sizeof(foo *) is that
while the internal sizeof in g_new is unaffected I think the casting
ends up as

 foo **

but I guess the compiler would have complained so maybe I don't
understand the magic enough.

<snip>
> index 42130667a7..598e6adc5e 100644
> --- a/hw/rdma/vmw/pvrdma_dev_ring.c
> +++ b/hw/rdma/vmw/pvrdma_dev_ring.c
> @@ -41,7 +41,7 @@ int pvrdma_ring_init(PvrdmaRing *ring, const char *name=
, PCIDevice *dev,
>      qatomic_set(&ring->ring_state->cons_head, 0);
>      */
>      ring->npages =3D npages;
> -    ring->pages =3D g_malloc0(npages * sizeof(void *));
> +    ring->pages =3D g_new0(void *, npages);

At least here ring->pages agrees about void ** being the result.

<snip>

So other than my queries about the sizeof(foo *) which I'd like someone
to assuage me of my concerns it looks like the script has done a
thorough mechanical job as all good scripts should ;-)

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
