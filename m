Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FD6597569
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 19:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbiHQRxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 13:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbiHQRxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 13:53:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA52031208
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660758822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SQOVouI0K9iJWnYSVBtpjkA3WVldpQ/o4YTxV/vt74M=;
        b=OjDxCM1eIEnL+4fTMGvGGB2oaS/l/orgtk9MpM/+In6BQ1QyhGwtFUBCtyFXc6tmrh/Sk6
        dqoSJ9tArPjswYWHeU6edfzfqNp0TkFZyQYloTo3uUk3L2Z1/39fBi6p28yWB65qudvEqH
        fQmm3kI5AVF6TrJjTW1uScVR/iJduF0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-Y04Hwh4eOIOoLir778wiNA-1; Wed, 17 Aug 2022 13:53:41 -0400
X-MC-Unique: Y04Hwh4eOIOoLir778wiNA-1
Received: by mail-wm1-f72.google.com with SMTP id f18-20020a05600c4e9200b003a5f81299caso3474284wmq.7
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 10:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=SQOVouI0K9iJWnYSVBtpjkA3WVldpQ/o4YTxV/vt74M=;
        b=CMzDum2gIwfSx0JweBGZ1L/0ScEn+SvM5ScRi/Zl2OHCWelaOL6e0mB61qJQZ8KkP9
         pcmOwniFMu02PNILTezBIyvPVlvjAfI20eynYbnKPLtGaVfTSxR6Lffl5tgzt9bXy9JC
         lOYkT8xw7m+6JDZJ6op6xWG5121VwCokU3WfgLWqVzF8n6l05enKW5iBf0j4Vw6mDsdE
         C4EccSRkmug8HBEjeJyvBjo650Bfj9xjFXxaS1PE1/f/6zA9SRPKhi56IXXnKbbbcbmU
         yqSWuqA1lvW5FHFpYk62KYSArM/rECyQM9GrVs2fHj4lCtHiPjQgIB9XWEsSCKMjqvq8
         5++A==
X-Gm-Message-State: ACgBeo0DAuNMFyJBhkrCN/B4FX4smPC6NnLqyi+UY4xYmuXkemi4E/DD
        tkEHk4PVmGEAPoNICHsZdTfUrM8w57m00mHz/YKICidqIXHOaFTavLXZ3Si8DqaZ2eRTZDGS6xY
        D3SIYv+4zqpm8
X-Received: by 2002:a05:6000:4083:b0:21f:fb6:9293 with SMTP id da3-20020a056000408300b0021f0fb69293mr14792295wrb.303.1660758820164;
        Wed, 17 Aug 2022 10:53:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4ONxUsrUHKKEaZOO44Ixn5LdAH2Y94mokPuvnN34a8r6PY+eKWeMnaGAVNXB2YU7T+If8QUw==
X-Received: by 2002:a05:6000:4083:b0:21f:fb6:9293 with SMTP id da3-20020a056000408300b0021f0fb69293mr14792286wrb.303.1660758819888;
        Wed, 17 Aug 2022 10:53:39 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id y11-20020adfe6cb000000b00220592005edsm1060157wrm.85.2022.08.17.10.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:53:39 -0700 (PDT)
Date:   Wed, 17 Aug 2022 13:53:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <20220817135311-mutt-send-email-mst@kernel.org>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220817025250-mutt-send-email-mst@kernel.org>
 <YvtmYpMieMFb80qR@bullseye>
 <20220817130044-mutt-send-email-mst@kernel.org>
 <Yvt6nxUYMfDrLd/A@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yvt6nxUYMfDrLd/A@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 11:08:26AM +0000, Bobby Eshleman wrote:
> On Wed, Aug 17, 2022 at 01:02:52PM -0400, Michael S. Tsirkin wrote:
> > On Tue, Aug 16, 2022 at 09:42:51AM +0000, Bobby Eshleman wrote:
> > > > The basic question to answer then is this: with a net device qdisc
> > > > etc in the picture, how is this different from virtio net then?
> > > > Why do you still want to use vsock?
> > > > 
> > > 
> > > When using virtio-net, users looking for inter-VM communication are
> > > required to setup bridges, TAPs, allocate IP addresses or setup DNS,
> > > etc... and then finally when you have a network, you can open a socket
> > > on an IP address and port. This is the configuration that vsock avoids.
> > > For vsock, we just need a CID and a port, but no network configuration.
> > 
> > Surely when you mention DNS you are going overboard? vsock doesn't
> > remove the need for DNS as much as it does not support it.
> > 
> 
> Oops, s/DNS/dhcp.

That too.

-- 
MST

