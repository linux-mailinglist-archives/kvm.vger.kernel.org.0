Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7438E7A70A3
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 04:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjITCje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 22:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjITCjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 22:39:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAC8C9
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 19:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695177524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mltdWUrYuG2mZM3mBsS3pkG+K6kdQVfPyUFr6/Wteqo=;
        b=R7c0jaPKMU5hj2dC78civt/wwgzmWA16bZOaNQUzfutqCU2JzCPz/xMrP/Q6bKZ7SQeg8k
        bqtcy17CZ0ujrD5SMG21JaxMjDUQvqjVFl6C/siKrnRTEoeV3GYLrXQvt33SWunOuanyK9
        5UOO9D+dmOy4BdQzC7jyzkp9RpNN3jk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-MpJwxToVPN2WlZ-vTsmSRA-1; Tue, 19 Sep 2023 22:38:40 -0400
X-MC-Unique: MpJwxToVPN2WlZ-vTsmSRA-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c0165b5c5cso31672141fa.1
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 19:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695177519; x=1695782319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mltdWUrYuG2mZM3mBsS3pkG+K6kdQVfPyUFr6/Wteqo=;
        b=IqdSgJexE7/5PtCbyu559Uiy0umby8CufA5bP7kuD4dKM81HjS/2X+/4rnxeEGpGjr
         U4LnrcdOlEgSysGimL2xM81von8l8gzE2Pe9y/x9ogek7NrWygoJLRkSVmBr2kxs3aUS
         H15yLxrQ+YEiURyzI8wJP4gB0gzNcq9gvqhGqMkODCqNh9BfWOdp3Gfi+VQUXba4vgMs
         a213bOrk857lxMxlV8IkbPGpIUfH5nQsJwC0bcJ82mBsqoiIs252h1c+FfuT7rDRt55S
         vYz9c4HkPMo3hxCIrtm+zIXf7zUUZpFoWsIipO8fMFCGLyKn74yjfWHwJe1cesJItmhP
         GYbg==
X-Gm-Message-State: AOJu0YzWED5qpKFiCa/Kwr0e6jNkR5Iij+cwF/26ks7vXiqH01JxOmH0
        y620uREx8AfnpRLRpgXW/CepbNN6qQ4NN/Tkj+3F5irlNuNcDOH4iLE6VXB+KP/mzGidsgOIZnU
        8V0kvIGEd6QC3
X-Received: by 2002:a2e:a3cd:0:b0:2bc:c557:84a0 with SMTP id w13-20020a2ea3cd000000b002bcc55784a0mr928156lje.30.1695177519197;
        Tue, 19 Sep 2023 19:38:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwXnlVNVhmJOWz1liAl5cY3Hket0qS/kxuaMrxgmSZwkofhhqlaN8M29TK4O/sX6epr0sArA==
X-Received: by 2002:a2e:a3cd:0:b0:2bc:c557:84a0 with SMTP id w13-20020a2ea3cd000000b002bcc55784a0mr928135lje.30.1695177518840;
        Tue, 19 Sep 2023 19:38:38 -0700 (PDT)
Received: from redhat.com ([2.52.26.122])
        by smtp.gmail.com with ESMTPSA id r11-20020a170906350b00b009a5f1d1564dsm8531069eja.126.2023.09.19.19.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 19:38:37 -0700 (PDT)
Date:   Tue, 19 Sep 2023 22:38:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Arseniy Krasnov <avkrasnov@salutedevices.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v9 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Message-ID: <20230919223700-mutt-send-email-mst@kernel.org>
References: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
 <b5873e36-fe8c-85e8-e11b-4ccec386c015@salutedevices.com>
 <yys5jgwkukvfyrgfz6txxzqc7el5megf2xntnk6j4ausvjdgld@7aan4quqy4bs>
 <a5b25ee07245125fac4bbdc3b3604758251907d2.camel@redhat.com>
 <hq67e2b3ljfjikvbaneczdve3fzg3dl5ziyc7xtujyqesp6dzm@fh5nqkptpb4n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hq67e2b3ljfjikvbaneczdve3fzg3dl5ziyc7xtujyqesp6dzm@fh5nqkptpb4n>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 19, 2023 at 03:35:51PM +0200, Stefano Garzarella wrote:
> On Tue, Sep 19, 2023 at 03:19:54PM +0200, Paolo Abeni wrote:
> > On Tue, 2023-09-19 at 09:54 +0200, Stefano Garzarella wrote:
> > > On Mon, Sep 18, 2023 at 07:56:00PM +0300, Arseniy Krasnov wrote:
> > > > Hi Stefano,
> > > >
> > > > thanks for review! So when this patchset will be merged to net-next,
> > > > I'll start sending next part of MSG_ZEROCOPY patchset, e.g. AF_VSOCK +
> > > > Documentation/ patches.
> > > 
> > > Ack, if it is not a very big series, maybe better to include also the
> > > tests so we can run them before merge the feature.
> > 
> > I understand that at least 2 follow-up series are waiting for this, one
> > of them targeting net-next and the bigger one targeting the virtio
> > tree. Am I correct?
> 
> IIUC the next series will touch only the vsock core
> (net/vmw_vsock/af_vsock.c), tests, and documentation.
> 
> The virtio part should be fully covered by this series.
> 
> @Arseniy feel free to correct me!
> 
> > 
> > DaveM suggests this should go via the virtio tree, too. Any different
> > opinion?
> 
> For this series should be fine, I'm not sure about the next series.
> Merging this with the virtio tree, then it forces us to do it for
> followup as well right?
> 
> In theory followup is more on the core, so better with net-next, but
> it's also true that for now only virtio transports support it, so it
> might be okay to continue with virtio.
> 
> @Michael WDYT?
> 
> Thanks,
> Stefano

I didn't get DaveM's mail - was this off-list?
I think net-next is easier because the follow up belongs in net-next.
But if not I can take it, sure. Let me know.

-- 
MST

