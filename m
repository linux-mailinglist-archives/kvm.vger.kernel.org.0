Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4137227F7
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjFENzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbjFENzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:55:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B1C91
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 06:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685973304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jb5+j0WuGaWQLAokH8FJzOfd9IpoIc69UMNApn2Um/Q=;
        b=Dxfh8soU2MojWuonyjetGUN6NDhxhGjPNIx541Csp9cytow+8jMV4M1KsgpNbfIsppxZye
        fomarvyTa2/rJTiYf/5DOGjBv6+fpVUJd0PM9JlatWMcpvOBk99dv7q1JvSZHpss6J16+5
        +lJZtqzBXZUUP47rHKl/e++pVBY8D5A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665--JzdXTuUPFSJfJ6z3xEjoQ-1; Mon, 05 Jun 2023 09:55:03 -0400
X-MC-Unique: -JzdXTuUPFSJfJ6z3xEjoQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30ae42628cfso2203447f8f.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 06:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973302; x=1688565302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jb5+j0WuGaWQLAokH8FJzOfd9IpoIc69UMNApn2Um/Q=;
        b=fzxUhEkMRaFHpITY7GaYyg+f/atSfzji+xBp1jajQlNxKrreA3ALsCV2zSiRdKLfAZ
         H/hRqP14jwpIP9DtB8K33RBIewPEeIe3f/L9FWEWxsyLqfw6KcZMqnL3YvwxJiQR3Ku/
         cHT3triEXfee0Bjgx05R0H1gYmDmxmLCdCyBOA6kshwnDsv0IO3ebJMKM9MmOdQFqG+q
         LsG46Lsh/EUIzeqDwKEoESAG2MoPT2yi6s4BFE7SCjl3UaekrTnivSQTFo950p4QUj0m
         Mc034J/VnPN7Gl7m2yzZA8kh7HgtpKUp0P4q1rnQFK1S8yFnhN2hhnXOaAUVKUpOa+p6
         TqVw==
X-Gm-Message-State: AC+VfDyB+fBEMyHAlBdB24QJEIo/gZgyPWtaj5ubcoz9QPeWR24HLWc0
        8LCMX3MEt7PtDE6DuS0f22Ye3PZii909b+Y0JmTIJhgsx0gYfa7L9V4CgQMVl8qwRgqe+hHcSiG
        OPvaIhfdOuuO2
X-Received: by 2002:a5d:6203:0:b0:309:a4e:52d3 with SMTP id y3-20020a5d6203000000b003090a4e52d3mr5095729wru.5.1685973301861;
        Mon, 05 Jun 2023 06:55:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ZHD4gDUdlfGTiduMiqY+ojv/UUc0qqNDYq2hzP027LaDqgTMXJjGDzbnCN0fSb2MNMtWn6g==
X-Received: by 2002:a5d:6203:0:b0:309:a4e:52d3 with SMTP id y3-20020a5d6203000000b003090a4e52d3mr5095714wru.5.1685973301499;
        Mon, 05 Jun 2023 06:55:01 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600001d200b0030ae09c5efdsm9932198wrx.42.2023.06.05.06.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 06:55:00 -0700 (PDT)
Date:   Mon, 5 Jun 2023 09:54:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230605095404-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > > > don't support packed virtqueue well yet, so let's filter the
> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > > >
> > > > > This way, even if the device supports it, we don't risk it being
> > > > > negotiated, then the VMM is unable to set the vring state properly.
> > > > >
> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > ---
> > > > >
> > > > > Notes:
> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > > > >     better PACKED support" series [1] and backported in stable branches.
> > > > >
> > > > >     We can revert it when we are sure that everything is working with
> > > > >     packed virtqueues.
> > > > >
> > > > >     Thanks,
> > > > >     Stefano
> > > > >
> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > >
> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > > 
> > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > > also have to revert this patch.
> > > 
> > > I wasn't sure if you wanted to queue the series for this merge window.
> > > In that case do you think it is better to send this patch only for stable
> > > branches?
> > > > Does this patch make them a NOP?
> > > 
> > > Yep, after applying the "better PACKED support" series and being
> > > sure that
> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > > patch.
> > > 
> > > Let me know if you prefer a different approach.
> > > 
> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > > interprets them the right way, when it does not.
> > > 
> > > Thanks,
> > > Stefano
> > > 
> > 
> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > to merge in this window. Probably easier than the elaborate
> > mask/unmask dance.
> 
> CCing Shannon (the original author of the "better PACKED support"
> series).
> 
> IIUC Shannon is going to send a v3 of that series to fix the
> documentation, so Shannon can you also add the Fixes tags?
> 
> Thanks,
> Stefano

Well this is in my tree already. Just reply with
Fixes: <>
to each and I will add these tags.

If I start dropping and rebasing this won't make it in this window.

-- 
MST

