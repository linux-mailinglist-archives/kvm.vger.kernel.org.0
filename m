Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5B727AB2
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 11:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbjFHJBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 05:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbjFHJBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 05:01:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C19D1BF7
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 02:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686214814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzyYfOnKsXJhWqka2GXPTRk+SfXQjoxgzRvBZSqF8t0=;
        b=QyK6Wq2ZiINiVLxIFJGNOVxTMs8hN/xD7RNi7LumkB5hAnHl8qSWpb96eLM8TgCJLGZ/nv
        0RYDp1QpJSrah0UXwI8q0J0U5ctp+LtmK3fUIbEFpe4QeovEA1g5DvtlGPC2E/bm/LzPsD
        p3hiyvWYhO4qDOWWjqRz/11Kr9/AUaE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-95qtg_AZPjen2A7W_47gXw-1; Thu, 08 Jun 2023 05:00:13 -0400
X-MC-Unique: 95qtg_AZPjen2A7W_47gXw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b1d8fa4629so1853921fa.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 02:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686214811; x=1688806811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzyYfOnKsXJhWqka2GXPTRk+SfXQjoxgzRvBZSqF8t0=;
        b=lS827ojPDPX01A1zQI+34cOVRB+tNZRwz/LsnfpJaMySWGlYcImPv3e9r7cm9d+6rZ
         OjQvAghcYdRqHekpmG2affIsdgom2twDSuFNQHCfZGnGUjt7U6UhwjW6dt7I3p8nfFES
         j2Qi7BiG4YL7RSx92gVsCa7gX2oGVGm/7X+2khiRbhHNJUawar+V+0j+TGb7EtxZQ2sx
         A2xyNBtobA+jch63XQW6eW3noA6CbVQft3SVKj5auOsOg2MUQ8aoJ8q+bs0PBPH/5MHd
         7ZCeWsaSFnbm+eb+HJP6o3Mw73ntlOg4fkzTqcsBo+UX7Yx/y10I8ipefwdnx/u7DXAO
         freg==
X-Gm-Message-State: AC+VfDxc+yWUofqq35wXxILr7Ux38i+LG9GGMCvhBON5/6YkZXDo2Eau
        PNVsGjtuA7RdYQHAISTc3a++0o4KwrdmBEtID6b2Zjyk5DhjinhLbBnGOFt3mZCsqe2gypv+dJZ
        XsVnTZrI7oqQM1SKKGYSuFkfTYh1o
X-Received: by 2002:a2e:9d92:0:b0:2b1:d5d0:f164 with SMTP id c18-20020a2e9d92000000b002b1d5d0f164mr2990814ljj.13.1686214811726;
        Thu, 08 Jun 2023 02:00:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ42dp9oFqMNjmtk9ygZJuGKFls2xB2ZcerVr0s54Zb6HoT4b2b1dnhsynIrpNgW2uczqKVvzmVSMmlHN19CWwE=
X-Received: by 2002:a2e:9d92:0:b0:2b1:d5d0:f164 with SMTP id
 c18-20020a2e9d92000000b002b1d5d0f164mr2990804ljj.13.1686214811397; Thu, 08
 Jun 2023 02:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org> <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org> <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org> <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org> <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
In-Reply-To: <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 8 Jun 2023 17:00:00 +0800
Message-ID: <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 8, 2023 at 4:00=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
>
> [...]
>
> >> > > > > I have a question though, what if down the road there
> >> > > > > is a new feature that needs more changes? It will be
> >> > > > > broken too just like PACKED no?
> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
> >> > > > > to support?
> >> > > >
> >> > > > It looks like we had it, but we took it out (by the way, we were
> >> > > > enabling packed even though we didn't support it):
> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.g=
it/commit/?id=3D6234f80574d7569444d8718355fa2838e92b158b
> >> > > >
> >> > > > The only problem I see is that for each new feature we have to m=
odify
> >> > > > the kernel.
> >> > > > Could we have new features that don't require handling by vhost-=
vdpa?
> >> > > >
> >> > > > Thanks,
> >> > > > Stefano
> >> > >
> >> > > Jason what do you say to reverting this?
> >> >
> >> > I may miss something but I don't see any problem with vDPA core.
> >> >
> >> > It's the duty of the parents to advertise the features it has. For e=
xample,
> >> >
> >> > 1) If some kernel version that is packed is not supported via
> >> > set_vq_state, parents should not advertise PACKED features in this
> >> > case.
> >> > 2) If the kernel has support packed set_vq_state(), but it's emulate=
d
> >> > cvq doesn't support, parents should not advertise PACKED as well
> >> >
> >> > If a parent violates the above 2, it looks like a bug of the parents=
.
> >> >
> >> > Thanks
> >>
> >> Yes but what about vhost_vdpa? Talking about that not the core.
> >
> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
>
> Sorry, I'm getting lost...
> We were talking about the fact that vhost-vdpa doesn't handle
> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
> that series [1], no?
>
> The parents seem okay, but maybe I missed a few things.
>
> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon=
.nelson@amd.com/

Yes, more below.

>
> >
> >> Should that not have a whitelist of features
> >> since it interprets ioctls differently depending on this?
> >
> >If there's a bug, it might only matter the following setup:
> >
> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
> >
> >This seems to be broken since VDUSE was introduced. If we really want
> >to backport something, it could be a fix to filter out PACKED in
> >VDUSE?
>
> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
> I think VDUSE works fine with packed virtqueue using virtio-vdpa
> (I haven't tried), so why should we filter PACKED in VDUSE?

I don't think we need any filtering since:

PACKED features has been advertised to userspace via uAPI since
6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
would be very hard to restrict it again. For the userspace that tries
to negotiate PACKED:

1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works well
2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break silentl=
y

If we backport the fixes to -stable, we may break the application at
least in the case 1).

Thanks

>
> Thanks,
> Stefano
>

