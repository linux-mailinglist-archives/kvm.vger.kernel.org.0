Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63FE727B76
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 11:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbjFHJcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 05:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbjFHJby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 05:31:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B57E2D6A
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 02:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686216612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7hoCCHwyZ78t8MhfigepGi6we5dYHokO9yNVTkJZRY=;
        b=Zf4b3AvSO0spHfFARSKfqYld3v6wIYr8JMmvSqBpmWvScZdVB5otvriYQyGBcy7JIHJXEY
        Gs+SyvLLfo5g79x1pQnSdMK6VtjQGExkA0EN9iKMNwHLYz3+lmRT8r1U/1icO4axiW3AP0
        40C3P4W0A38YCidiGbuTzVbuLP+J28Y=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-pMAtSKHBNkGipEKpcSlmsg-1; Thu, 08 Jun 2023 05:30:11 -0400
X-MC-Unique: pMAtSKHBNkGipEKpcSlmsg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b1fa7c9f06so1964501fa.1
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 02:30:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686216609; x=1688808609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7hoCCHwyZ78t8MhfigepGi6we5dYHokO9yNVTkJZRY=;
        b=cljlN7cOXhiF4zF0owUtV8Kr6XK0wwDWfODkl5BiXxiiwd6Tr3+NRlB01q1Uw9rdHG
         6v9JN6r1ARSjf6EHZjr91Vnmc0DDkDE2/v+DlFoM/IhMVrEZahlljvou7C+mSWSsZbNg
         jd74cEuxON5gfAlMLToOkyXnFWdidPKFfZiVPbDKLOwrgOc1P4DbGiDldGmQupTUjgyj
         j0ie9hX0NGBkQouBH3qUy1QnG+jB+vy8hkKdbAl0uVwfJMNJBshdGzAY3Jk8HRd7ygvy
         chAVb2f06KKvQmVQRY1MtIzrlYDEI7/dHmzM+VBcptx8WYxDpSIfI0ZlXQseHePb6kF4
         6Bdg==
X-Gm-Message-State: AC+VfDxT1grfukQ3BPYNh0KtbbVDXoHN1lvnBnM99CfTBzAh1XEP0Rye
        W3ok2Ur76k1tKK7XXiM/LRSfGxMm4X+IaTjPNDPvA5TSurcis2t+mqBcmsJoavmSASgtDSTCmWn
        vIWE/Y4Z0wFFUCVzmz90r+GAeLMwsy/4NmlxX
X-Received: by 2002:a2e:7c01:0:b0:2b0:45ff:7952 with SMTP id x1-20020a2e7c01000000b002b045ff7952mr2937344ljc.46.1686216609603;
        Thu, 08 Jun 2023 02:30:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5UZCodSXe8QJG9qyQ8hxilMfqcB032BMizZjc3X/xA2bZal/+MGVVGoUXxdh3KL+1mGFUZIjOMQh01hn/DswI=
X-Received: by 2002:a2e:7c01:0:b0:2b0:45ff:7952 with SMTP id
 x1-20020a2e7c01000000b002b045ff7952mr2937333ljc.46.1686216609317; Thu, 08 Jun
 2023 02:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org> <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org> <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org> <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com> <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
In-Reply-To: <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 8 Jun 2023 17:29:58 +0800
Message-ID: <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 8, 2023 at 5:21=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
> >On Thu, Jun 8, 2023 at 4:00=E2=80=AFPM Stefano Garzarella <sgarzare@redh=
at.com> wrote:
> >>
> >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
> >>
> >> [...]
> >>
> >> >> > > > > I have a question though, what if down the road there
> >> >> > > > > is a new feature that needs more changes? It will be
> >> >> > > > > broken too just like PACKED no?
> >> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
> >> >> > > > > to support?
> >> >> > > >
> >> >> > > > It looks like we had it, but we took it out (by the way, we w=
ere
> >> >> > > > enabling packed even though we didn't support it):
> >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linu=
x.git/commit/?id=3D6234f80574d7569444d8718355fa2838e92b158b
> >> >> > > >
> >> >> > > > The only problem I see is that for each new feature we have t=
o modify
> >> >> > > > the kernel.
> >> >> > > > Could we have new features that don't require handling by vho=
st-vdpa?
> >> >> > > >
> >> >> > > > Thanks,
> >> >> > > > Stefano
> >> >> > >
> >> >> > > Jason what do you say to reverting this?
> >> >> >
> >> >> > I may miss something but I don't see any problem with vDPA core.
> >> >> >
> >> >> > It's the duty of the parents to advertise the features it has. Fo=
r example,
> >> >> >
> >> >> > 1) If some kernel version that is packed is not supported via
> >> >> > set_vq_state, parents should not advertise PACKED features in thi=
s
> >> >> > case.
> >> >> > 2) If the kernel has support packed set_vq_state(), but it's emul=
ated
> >> >> > cvq doesn't support, parents should not advertise PACKED as well
> >> >> >
> >> >> > If a parent violates the above 2, it looks like a bug of the pare=
nts.
> >> >> >
> >> >> > Thanks
> >> >>
> >> >> Yes but what about vhost_vdpa? Talking about that not the core.
> >> >
> >> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
> >>
> >> Sorry, I'm getting lost...
> >> We were talking about the fact that vhost-vdpa doesn't handle
> >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
> >> that series [1], no?
> >>
> >> The parents seem okay, but maybe I missed a few things.
> >>
> >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shan=
non.nelson@amd.com/
> >
> >Yes, more below.
> >
> >>
> >> >
> >> >> Should that not have a whitelist of features
> >> >> since it interprets ioctls differently depending on this?
> >> >
> >> >If there's a bug, it might only matter the following setup:
> >> >
> >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
> >> >
> >> >This seems to be broken since VDUSE was introduced. If we really want
> >> >to backport something, it could be a fix to filter out PACKED in
> >> >VDUSE?
> >>
> >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
> >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
> >> (I haven't tried), so why should we filter PACKED in VDUSE?
> >
> >I don't think we need any filtering since:
> >
> >PACKED features has been advertised to userspace via uAPI since
> >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
> >would be very hard to restrict it again. For the userspace that tries
> >to negotiate PACKED:
> >
> >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works wel=
l
> >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break sile=
ntly
> >
> >If we backport the fixes to -stable, we may break the application at
> >least in the case 1).
>
> Okay, I see now, thanks for the details!
>
> Maybe instead of "break silently", we can return an explicit error for
> SET_VRING_BASE/GET_VRING_BASE in stable branches.
> But if there are not many cases, we can leave it like that.

A second thought, if we need to do something for stable. is it better
if we just backport Shannon's series to stable?

>
> I was just concerned about how does the user space understand that it
> can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a given
> kernel or not.

My understanding is that if packed is advertised, the application
should assume SET/GET_VRING_BASE work.

Thanks

>
> Thanks,
> Stefano
>

