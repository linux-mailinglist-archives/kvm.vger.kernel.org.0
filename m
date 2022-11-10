Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC04962425A
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 13:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiKJM1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 07:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKJM1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 07:27:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DB82AFA
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 04:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668083121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q9sOq3ArB3nGOxvV39adhirp0xPiw6BD46Br6A3jim4=;
        b=f0hy8ucXxMdtyqARk53CWI67tT6S/0Il9/vrlvnT1rpDyTzPFAPDPJ1lGuT5OpIl8pSzVG
        zoR1kS90yM3MD15Mu7bxFke/vLow4AQdqb9KszcDyoEKw7jM37SKGlo51+STlsXw730AAq
        M1hz6KtypT7QJNhIxYF+zwpwvQA7Hoo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-443-W9h4xBR6NSennr-lLXtvCQ-1; Thu, 10 Nov 2022 07:25:20 -0500
X-MC-Unique: W9h4xBR6NSennr-lLXtvCQ-1
Received: by mail-wr1-f69.google.com with SMTP id j20-20020adfb314000000b002366d9f67aaso308399wrd.3
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 04:25:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9sOq3ArB3nGOxvV39adhirp0xPiw6BD46Br6A3jim4=;
        b=Er8hMEmo0L6glihieBk7FHxmPk+7hj92AblEoRcWry4ns4nWld7Auot5Nm2/fwcv5K
         QO+ciQ+G0gry8ceC6YB0TawvZnlGhXllb4t7pLXjkCorCL55tGPPIdPVlqL5lfSQYkKN
         PHF0j+EEfIVIoww54KBdL12lAUnGneIyptjC4fkjOx/XFhcKQHmq8kIvAUKcrELZlRLr
         FzVjRx8Dlg1efcBIXVoXNggNXKPnaWmA14fsyE46tD9A305CBowMJt1hT/a3DQa5ZLrE
         uB8SVlj1/Xn04YWUQganYmZogVWszH9yvEhxhOmL4/rVZ7vxZkfsUX5Hf1UH0LubBOKj
         ro/Q==
X-Gm-Message-State: ACrzQf3P89OEBHQkLkhzzaCNv7wetxH5EoyOSST/qm0HkeHlzbeBIPoR
        Bj6VioPuJZ0NQ2wywEHqeQuRlJFq4iOOK+VJfW5LbkHoXBjbby3//z/E5aES6auBTHR97j05WaR
        PVYA2p7SddafE
X-Received: by 2002:a5d:524e:0:b0:236:6a61:3b92 with SMTP id k14-20020a5d524e000000b002366a613b92mr41610096wrc.328.1668083119156;
        Thu, 10 Nov 2022 04:25:19 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5VfDGphCWD0wa/3ITH7C2PrQKLc6MdsOLKLzBuXOa0/FOieRvBzvsJePXHxj/NtZCzwdRbIA==
X-Received: by 2002:a5d:524e:0:b0:236:6a61:3b92 with SMTP id k14-20020a5d524e000000b002366a613b92mr41610077wrc.328.1668083118894;
        Thu, 10 Nov 2022 04:25:18 -0800 (PST)
Received: from redhat.com ([2.52.3.250])
        by smtp.gmail.com with ESMTPSA id g4-20020a5d5404000000b00228d52b935asm16032641wrv.71.2022.11.10.04.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 04:25:18 -0800 (PST)
Date:   Thu, 10 Nov 2022 07:25:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 00/10] ASID support in vhost-vdpa net
Message-ID: <20221110072455-mutt-send-email-mst@kernel.org>
References: <20221108170755.92768-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221108170755.92768-1-eperezma@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 06:07:45PM +0100, Eugenio Pérez wrote:
> Control VQ is the way net devices use to send changes to the device state, like
> the number of active queues or its mac address.
> 
> QEMU needs to intercept this queue so it can track these changes and is able to
> migrate the device. It can do it from 1576dbb5bbc4 ("vdpa: Add x-svq to
> NetdevVhostVDPAOptions"). However, to enable x-svq implies to shadow all VirtIO
> device's virtqueues, which will damage performance.
> 
> This series adds address space isolation, so the device and the guest
> communicate directly with them (passthrough) and CVQ communication is split in
> two: The guest communicates with QEMU and QEMU forwards the commands to the
> device.
> 
> Comments are welcome. Thanks!


This is not 7.2 material, right?

> v6:
> - Do not allocate SVQ resources like file descriptors if SVQ cannot be used.
> - Disable shadow CVQ if the device does not support it because of net
>   features.
> 
> v5:
> - Move vring state in vhost_vdpa_get_vring_group instead of using a
>   parameter.
> - Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID
> 
> v4:
> - Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
> - Squash vhost_vdpa_cvq_group_is_independent.
> - Do not check for cvq index on vhost_vdpa_net_prepare, we only have one
>   that callback registered in that NetClientInfo.
> - Add comment specifying behavior if device does not support _F_ASID
> - Update headers to a later Linux commit to not to remove SETUP_RNG_SEED
> 
> v3:
> - Do not return an error but just print a warning if vdpa device initialization
>   returns failure while getting AS num of VQ groups
> - Delete extra newline
> 
> v2:
> - Much as commented on series [1], handle vhost_net backend through
>   NetClientInfo callbacks instead of directly.
> - Fix not freeing SVQ properly when device does not support CVQ
> - Add BIT_ULL missed checking device's backend feature for _F_ASID.
> 
> Eugenio Pérez (10):
>   vdpa: Use v->shadow_vqs_enabled in vhost_vdpa_svqs_start & stop
>   vhost: set SVQ device call handler at SVQ start
>   vhost: Allocate SVQ device file descriptors at device start
>   vdpa: add vhost_vdpa_net_valid_svq_features
>   vdpa: move SVQ vring features check to net/
>   vdpa: Allocate SVQ unconditionally
>   vdpa: Add asid parameter to vhost_vdpa_dma_map/unmap
>   vdpa: Store x-svq parameter in VhostVDPAState
>   vdpa: Add listener_shadow_vq to vhost_vdpa
>   vdpa: Always start CVQ in SVQ mode
> 
>  include/hw/virtio/vhost-vdpa.h     |  10 +-
>  hw/virtio/vhost-shadow-virtqueue.c |  35 +-----
>  hw/virtio/vhost-vdpa.c             | 114 ++++++++++---------
>  net/vhost-vdpa.c                   | 171 ++++++++++++++++++++++++++---
>  hw/virtio/trace-events             |   4 +-
>  5 files changed, 222 insertions(+), 112 deletions(-)
> 
> -- 
> 2.31.1
> 

