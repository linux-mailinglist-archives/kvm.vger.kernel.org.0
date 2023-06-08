Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C032D7281AA
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 15:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbjFHNrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 09:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbjFHNrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 09:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9219426AD
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 06:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686231996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=73nshEeWhw2n5gdRpaAAi9lUSo+UIEZBfmddmf0WSo8=;
        b=QW7DacbZLKltZ0A87clNL628uRPcUz25ngxSTalGoe4kh7W4hThrZprVZLTvrIdxlZUHY6
        a8WjDEgQNGAeZG5Aqw4qqIt77yKZeliVZY+QfZ89uZI3X7orHm3cTBfUL6At2rRJmZIQVB
        srdwxCfB446gOJaEpjTBRohRdZOixrs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-SdbZFRiWOkWEroZ97xW-9w-1; Thu, 08 Jun 2023 09:46:35 -0400
X-MC-Unique: SdbZFRiWOkWEroZ97xW-9w-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30aeef6f601so256277f8f.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 06:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686231994; x=1688823994;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73nshEeWhw2n5gdRpaAAi9lUSo+UIEZBfmddmf0WSo8=;
        b=g9Sfjyn7ascEia4bRJfZct4Esy4EFoaGIeivigYuHqcvYmzvaHUoW1QAaRwrYIJl7M
         o2ui1Ex261F+Z7F8bKy2IGTqJxzuEZDcaLZ4oGGClNrz0sn45J/wqZtiaexzkW2mKXNl
         leyFcPaCNmoMOB1s9vEcRDyL3Lrbi68UmPKgyApli2aPa9Kucanu/ld74oQFa07gmMN5
         NukaPyG1iATKOLBc5f+VEoJvfXYmiWLuhhGxyCBvIyUpPMxp4xRC++XqiQ/Xe09iid4u
         St9m/cC3EoWDFUtjTGTFw0qnt+Y7dSHCDwW/ylRn4J2cTM9v5R9NPDmb6+we0Rfwsdh7
         SfQA==
X-Gm-Message-State: AC+VfDxgME6EU7kQtr1LmZiNv1YV8DEJByN+9Taa8+SdkkoRJIu6P2nz
        C/2YxVDJ0Qmf27ICLvOwF8vC2m7dchDW3rAwdvPdDhOG7y7yX7JfF5KYpLe2xphecQtNQny8xYO
        fdGz9f3DVgQwY
X-Received: by 2002:adf:f547:0:b0:309:38af:91c6 with SMTP id j7-20020adff547000000b0030938af91c6mr7519234wrp.68.1686231994184;
        Thu, 08 Jun 2023 06:46:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6nvd4pWYZsLG/t7CXB3KRL7ulTzo9Pl/yJm2BKU29KvWQFi9FA8ZY1S13xxeI6s5mULDgI/w==
X-Received: by 2002:adf:f547:0:b0:309:38af:91c6 with SMTP id j7-20020adff547000000b0030938af91c6mr7519218wrp.68.1686231993887;
        Thu, 08 Jun 2023 06:46:33 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id i1-20020adfefc1000000b0030647449730sm1671162wrp.74.2023.06.08.06.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:46:33 -0700 (PDT)
Date:   Thu, 8 Jun 2023 09:46:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230608094528-mutt-send-email-mst@kernel.org>
References: <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
> On Thu, Jun 8, 2023 at 4:00 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
> >
> > [...]
> >
> > >> > > > > I have a question though, what if down the road there
> > >> > > > > is a new feature that needs more changes? It will be
> > >> > > > > broken too just like PACKED no?
> > >> > > > > Shouldn't vdpa have an allowlist of features it knows how
> > >> > > > > to support?
> > >> > > >
> > >> > > > It looks like we had it, but we took it out (by the way, we were
> > >> > > > enabling packed even though we didn't support it):
> > >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
> > >> > > >
> > >> > > > The only problem I see is that for each new feature we have to modify
> > >> > > > the kernel.
> > >> > > > Could we have new features that don't require handling by vhost-vdpa?
> > >> > > >
> > >> > > > Thanks,
> > >> > > > Stefano
> > >> > >
> > >> > > Jason what do you say to reverting this?
> > >> >
> > >> > I may miss something but I don't see any problem with vDPA core.
> > >> >
> > >> > It's the duty of the parents to advertise the features it has. For example,
> > >> >
> > >> > 1) If some kernel version that is packed is not supported via
> > >> > set_vq_state, parents should not advertise PACKED features in this
> > >> > case.
> > >> > 2) If the kernel has support packed set_vq_state(), but it's emulated
> > >> > cvq doesn't support, parents should not advertise PACKED as well
> > >> >
> > >> > If a parent violates the above 2, it looks like a bug of the parents.
> > >> >
> > >> > Thanks
> > >>
> > >> Yes but what about vhost_vdpa? Talking about that not the core.
> > >
> > >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
> >
> > Sorry, I'm getting lost...
> > We were talking about the fact that vhost-vdpa doesn't handle
> > SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
> > that series [1], no?
> >
> > The parents seem okay, but maybe I missed a few things.
> >
> > [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> 
> Yes, more below.
> 
> >
> > >
> > >> Should that not have a whitelist of features
> > >> since it interprets ioctls differently depending on this?
> > >
> > >If there's a bug, it might only matter the following setup:
> > >
> > >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
> > >
> > >This seems to be broken since VDUSE was introduced. If we really want
> > >to backport something, it could be a fix to filter out PACKED in
> > >VDUSE?
> >
> > mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
> > I think VDUSE works fine with packed virtqueue using virtio-vdpa
> > (I haven't tried), so why should we filter PACKED in VDUSE?
> 
> I don't think we need any filtering since:
> 
> PACKED features has been advertised to userspace via uAPI since
> 6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
> would be very hard to restrict it again. For the userspace that tries
> to negotiate PACKED:
> 
> 1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works well
> 2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break silently
> 
> If we backport the fixes to -stable, we may break the application at
> least in the case 1).
> 
> Thanks


I am less concerned about stable, and much more concerned about the
future. Assume we add a new ring format. It will be silently passed
to vhost-vdpa and things break again.
This is why I think we need an allowlist in vhost-vdpa.


> >
> > Thanks,
> > Stefano
> >

