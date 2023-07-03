Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2A2745579
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 08:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjGCG0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 02:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjGCG0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 02:26:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBCBC5
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 23:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688365540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tpk/m1ehmImz7zaLy3aO5+IqtB88CsrdqBSdTDk04so=;
        b=L21xEHAP78Z+Silct1kf4hjqkR84vUVrWJUGwlcdxBAyj60v54e8ckZr2T55Bc+74RHRVI
        0Ix2naKtmyVvsVyBdGbKfdnqNAk5yVLtuJjnd0ItoCtEEXu0r87tCNiS6DKrcWABTgjHYo
        T4UUMqitC2DoJJwKU8SHB02HP3MiDLY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-a1xRi7O8MV2xJ-w9Oigc4Q-1; Mon, 03 Jul 2023 02:25:38 -0400
X-MC-Unique: a1xRi7O8MV2xJ-w9Oigc4Q-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b6a679df26so35376981fa.2
        for <kvm@vger.kernel.org>; Sun, 02 Jul 2023 23:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688365537; x=1690957537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tpk/m1ehmImz7zaLy3aO5+IqtB88CsrdqBSdTDk04so=;
        b=K9YYmjsm4/KTdVkUvpsCbCE2wE166K2r23F7JPJmD1AgH8A1zgQGFrHY30D3iNKIZf
         8LrX7cQfP/p9jGeWEW5DYgGQkvbW7+8G43AKfdYmATW4Fuz1t+FGOcZ5DfebL/pp1GsT
         XidTP8k342Sa4PvDsw7HwMBbYPD1T0L9dsDhfGyztD6u2ERAY7AmGtbYvM9I2gORAYqx
         OfN3jcbFaYSqKvWKAv4F/W70hgWPfBKcWDqQf77GJw/R+Ln3DEytO31JZkMhPMJhmTPk
         mksG/R95CIAA6FY6m0kVEoxeq2H9v7MkN+ykliTbn76AyZ0srDMhItVqdwjyvskcL/i6
         ClDQ==
X-Gm-Message-State: ABy/qLZK9MZf/RQe2sboGTXQjjehOwDcnlADToQoHnhWDgJdsG1TQKON
        TF83ugRaEiDXc1WvbLldAMVTM4s1dnKU0kWqc9ESuBCMXksxakdSl4LYPkOQc2o19EU4xAEboRt
        vUwg1M7LIkVgjgufTjC4EchYX8hjh
X-Received: by 2002:a2e:3a0f:0:b0:2b6:decf:5cbf with SMTP id h15-20020a2e3a0f000000b002b6decf5cbfmr2575349lja.32.1688365537528;
        Sun, 02 Jul 2023 23:25:37 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEtiFAUSLVKli3ZwlIzEtafXVEMpeIGVKp2Qav8LglWDEDQNJ63BHWuk/72EPyDX1VfTOgZd7pUWMPp5sL01kw=
X-Received: by 2002:a2e:3a0f:0:b0:2b6:decf:5cbf with SMTP id
 h15-20020a2e3a0f000000b002b6decf5cbfmr2575331lja.32.1688365537255; Sun, 02
 Jul 2023 23:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230628065919.54042-1-lulu@redhat.com> <20230628065919.54042-2-lulu@redhat.com>
 <CACGkMEvTyxvEkdMbYqZG3T4ZGm2G36hYqPidbTNzLB=bUgSr0A@mail.gmail.com> <CACLfguWx2hjNyyVC_JM1VBCGj3AqRZsygHJ3JGcb8erknBo-sA@mail.gmail.com>
In-Reply-To: <CACLfguWx2hjNyyVC_JM1VBCGj3AqRZsygHJ3JGcb8erknBo-sA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 3 Jul 2023 14:25:25 +0800
Message-ID: <CACGkMEtowYUowpsBvkYe3AUADwYgOcxbHW=-f=45u2vNTz9CUA@mail.gmail.com>
Subject: Re: [RFC 1/4] vduse: Add the struct to save the vq reconnect info
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 1, 2023 at 5:25=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> On Wed, Jun 28, 2023 at 4:04=E2=80=AFPM Jason Wang <jasowang@redhat.com> =
wrote:
> >
> > On Wed, Jun 28, 2023 at 2:59=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrot=
e:
> > >
> > > From: Your Name <you@example.com>
> >
> > It looks to me your git is not properly configured.
> >
> > >
> > > this struct is to save the reconnect info struct, in this
> > > struct saved the page info that alloc to save the
> > > reconnect info
> > >
> > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > ---
> > >  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_u=
ser/vduse_dev.c
> > > index 26b7e29cb900..f845dc46b1db 100644
> > > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > @@ -72,6 +72,12 @@ struct vduse_umem {
> > >         struct page **pages;
> > >         struct mm_struct *mm;
> > >  };
> > > +struct vdpa_reconnect_info {
> > > +       u32 index;
> > > +       phys_addr_t addr;
> > > +       unsigned long vaddr;
> > > +       phys_addr_t size;
> > > +};
> >
> > Please add comments to explain each field. And I think this should be
> > a part of uAPI?
> >
> > Thanks
> >
> Will add the new ioctl for this information

I may miss something but having this to be part of the uAPI seems more
than enough.

Or what would this new ioctl do?

Thanks

> Thanks
> Cindy
> > >
> > >  struct vduse_dev {
> > >         struct vduse_vdpa *vdev;
> > > @@ -106,6 +112,7 @@ struct vduse_dev {
> > >         u32 vq_align;
> > >         struct vduse_umem *umem;
> > >         struct mutex mem_lock;
> > > +       struct vdpa_reconnect_info reconnect_info[64];
> > >  };
> > >
> > >  struct vduse_dev_msg {
> > > --
> > > 2.34.3
> > >
> >
>

