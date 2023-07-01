Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54461744839
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 11:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjGAJ0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 05:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjGAJ01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 05:26:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7096A1FE7
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 02:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688203542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nM2gJH27BA1TX1GMcZ4aVIIbGI0tWJqJTUWx2rBsc7Y=;
        b=SDqNKL3VogUNUe2kve6IUzARwtyTImauBH8aMZBSJOMJ+YpJz7SgxuGS3/cI7aCixYHM2i
        mfJ6dHr0om3tBzByT7UrhGJUgFZMgcwNJRA8LaMWhs04CBn10aJ6PtID92YIUs9gsrvS4i
        tairWStGz3gPzZzMAHf9Noc6/Mk9THA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-q_eEpb26NOKlUY1CKglp9Q-1; Sat, 01 Jul 2023 05:25:41 -0400
X-MC-Unique: q_eEpb26NOKlUY1CKglp9Q-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fbb18e9bd9so12683215e9.0
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 02:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688203540; x=1690795540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nM2gJH27BA1TX1GMcZ4aVIIbGI0tWJqJTUWx2rBsc7Y=;
        b=X7i2jpXU8kmOe5kp1ma1hqqT/VCnsiv7zq04ryHeeP780QcwVaIrIEJyG1Te7gtmWl
         +8CasDwGxoQW85htOrzb267RDZwuv2Bx7t03oG/uTcxFUZo+Pi6uuIhaAfTQiI0+wp0/
         3gxdVlY1bpIiTuJQ9YpL/eTRVYPf+H1+68hTjY1qsJUjFkEJk+uO7Wa6oRb/OHV2Q8vz
         yNjCRuoEMILZPBbFb1lewn+yinwyY9ydPDtMH9R3IYKR7/+IweovD4iztYeuYJIhDNFx
         tibu1vD4s2RpSYdlQcumOwxZrNNYlyKPL+SuLjBjXYMEA/NrKrSw5UDfVFbEM2Y5acP5
         LhqQ==
X-Gm-Message-State: AC+VfDxuGMiAlvLdOM0X9KfEdnDDXU8lLvo1EtDv1hXcDzT7ew6756vV
        65wyRVZR+clPEtkuW3R0DU/3ChJCXGanmqxgnZok4+r99FGG461iczHICg6c8tTsRHTaIkxXEgc
        FJ75EgymmfAjLXCy/Tti4Pr3HcY0J
X-Received: by 2002:a1c:7704:0:b0:3f7:e7a2:25f6 with SMTP id t4-20020a1c7704000000b003f7e7a225f6mr4603085wmi.17.1688203540068;
        Sat, 01 Jul 2023 02:25:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5KzgKvHpVpKm2J9bTSz5FU00R9I8bsGrKxINJmgolQkkcaBACIb7a7IhgcPxRbwrkEM1Oxeq1bSGVq3ZuXx0s=
X-Received: by 2002:a1c:7704:0:b0:3f7:e7a2:25f6 with SMTP id
 t4-20020a1c7704000000b003f7e7a225f6mr4603078wmi.17.1688203539779; Sat, 01 Jul
 2023 02:25:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230628065919.54042-1-lulu@redhat.com> <20230628065919.54042-2-lulu@redhat.com>
 <CACGkMEvTyxvEkdMbYqZG3T4ZGm2G36hYqPidbTNzLB=bUgSr0A@mail.gmail.com>
In-Reply-To: <CACGkMEvTyxvEkdMbYqZG3T4ZGm2G36hYqPidbTNzLB=bUgSr0A@mail.gmail.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Sat, 1 Jul 2023 17:24:57 +0800
Message-ID: <CACLfguWx2hjNyyVC_JM1VBCGj3AqRZsygHJ3JGcb8erknBo-sA@mail.gmail.com>
Subject: Re: [RFC 1/4] vduse: Add the struct to save the vq reconnect info
To:     Jason Wang <jasowang@redhat.com>
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

On Wed, Jun 28, 2023 at 4:04=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Wed, Jun 28, 2023 at 2:59=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
> >
> > From: Your Name <you@example.com>
>
> It looks to me your git is not properly configured.
>
> >
> > this struct is to save the reconnect info struct, in this
> > struct saved the page info that alloc to save the
> > reconnect info
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_use=
r/vduse_dev.c
> > index 26b7e29cb900..f845dc46b1db 100644
> > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -72,6 +72,12 @@ struct vduse_umem {
> >         struct page **pages;
> >         struct mm_struct *mm;
> >  };
> > +struct vdpa_reconnect_info {
> > +       u32 index;
> > +       phys_addr_t addr;
> > +       unsigned long vaddr;
> > +       phys_addr_t size;
> > +};
>
> Please add comments to explain each field. And I think this should be
> a part of uAPI?
>
> Thanks
>
Will add the new ioctl for this information
Thanks
Cindy
> >
> >  struct vduse_dev {
> >         struct vduse_vdpa *vdev;
> > @@ -106,6 +112,7 @@ struct vduse_dev {
> >         u32 vq_align;
> >         struct vduse_umem *umem;
> >         struct mutex mem_lock;
> > +       struct vdpa_reconnect_info reconnect_info[64];
> >  };
> >
> >  struct vduse_dev_msg {
> > --
> > 2.34.3
> >
>

