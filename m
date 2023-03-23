Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9396C69B6
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCWNkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjCWNju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:39:50 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F66A86B6
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:39:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h8so86659406ede.8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bjorling.me; s=google; t=1679578772;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y9uzroYoUExDQ2jI75bjOiGxOaAszHolPvbKLqpqwBM=;
        b=LWDH9CiO0wThc3aWkco+/q8tXbNskD9nog2zNw05+zwDyOjy85W+nqiSMI37+RHAsp
         jmILNRyZkeMEJkI/OfpV6VDGKuwKiOA9fi5YFl4CHRdk5FXeRQJpd2iwPvUImhEKWgUD
         DFJoOTDWFFhlEuIW64o0J8e+mMb4kiD79gnMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679578772;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9uzroYoUExDQ2jI75bjOiGxOaAszHolPvbKLqpqwBM=;
        b=UiWsEz0nEcpLCR2IG7rucrqoLZstPOolTrloHyr+OJdxB8R/SPQ/jZcv39kfC8mkvP
         1+nsDzigI+7eV2+1sh01FEx9J8hR9ul88i1EPqhTUXB/Kn5CuD/UpJ5AHfg1WB+V5yVb
         SFQv/9rNTMJwbMvu+F0lLcPhZfxWuLipZduIDiPAcTpQXdrcc2lkNLFyUpxg+sIjLJQU
         0f9EjHyeBTdP8jRWtNcziWQAlOdX9tICZ7lqOqjnED/pAtUJYYlcxaAt1DAy8EHiFmRP
         rnSN1KhO2wHLXupagE3/YJFgbN/o3EnM3Es7juCbi0eBJv+nfrQpTgKUJjbHlW8u1dLP
         VNwA==
X-Gm-Message-State: AO0yUKWcu6/4PoAbmlN4DHxADhqGQHqvrw+DU5yV6QLTcjOWliT2QL3J
        Vc+2SBNbHIANggw7aRhi8KrsPw==
X-Google-Smtp-Source: AK7set+TbVWcXUjnscdnvweBNkbOGo1ZQmcKbe14XcBe4sk9ebDf2tip1OGaRhMI9Nz2AjuG2Cv/ZQ==
X-Received: by 2002:a17:906:4e56:b0:930:d552:5c23 with SMTP id g22-20020a1709064e5600b00930d5525c23mr10972988ejw.56.1679578772386;
        Thu, 23 Mar 2023 06:39:32 -0700 (PDT)
Received: from [192.168.10.20] ([87.116.37.42])
        by smtp.gmail.com with ESMTPSA id g9-20020a056402320900b004fd219242a5sm9114055eda.7.2023.03.23.06.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 06:39:31 -0700 (PDT)
Message-ID: <a826f507-d216-adfb-1212-4d577db0ce9f@bjorling.me>
Date:   Thu, 23 Mar 2023 14:39:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v8 2/4] virtio-blk: add zoned storage emulation for zoned
 devices
Content-Language: en-US
To:     Sam Li <faithilikerun@gmail.com>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        damien.lemoal@opensource.wdc.com, kvm@vger.kernel.org,
        hare@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        dmitry.fomichev@wdc.com, Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20230323052828.6545-1-faithilikerun@gmail.com>
 <20230323052828.6545-3-faithilikerun@gmail.com>
From:   =?UTF-8?Q?Matias_Bj=c3=b8rling?= <m@bjorling.me>
In-Reply-To: <20230323052828.6545-3-faithilikerun@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/2023 06.28, Sam Li wrote:
> This patch extends virtio-blk emulation to handle zoned device commands
> by calling the new block layer APIs to perform zoned device I/O on
> behalf of the guest. It supports Report Zone, four zone oparations (open,
> close, finish, reset), and Append Zone.
> 
> The VIRTIO_BLK_F_ZONED feature bit will only be set if the host does
> support zoned block devices. Regular block devices(conventional zones)
> will not be set.
> 
> The guest os can use blktests, fio to test those commands on zoned devices.
> Furthermore, using zonefs to test zone append write is also supported.
> 
> Signed-off-by: Sam Li <faithilikerun@gmail.com>
> ---
>   hw/block/virtio-blk-common.c |   2 +
>   hw/block/virtio-blk.c        | 389 +++++++++++++++++++++++++++++++++++
>   2 files changed, 391 insertions(+)
> 
> diff --git a/hw/block/virtio-blk-common.c b/hw/block/virtio-blk-common.c
> index ac52d7c176..e2f8e2f6da 100644
> --- a/hw/block/virtio-blk-common.c
> +++ b/hw/block/virtio-blk-common.c
> @@ -29,6 +29,8 @@ static const VirtIOFeature feature_sizes[] = {
>        .end = endof(struct virtio_blk_config, discard_sector_alignment)},
>       {.flags = 1ULL << VIRTIO_BLK_F_WRITE_ZEROES,
>        .end = endof(struct virtio_blk_config, write_zeroes_may_unmap)},
> +    {.flags = 1ULL << VIRTIO_BLK_F_ZONED,
> +     .end = endof(struct virtio_blk_config, zoned)},
>       {}
>   };

I used the qemu monitor to expect the state of the devices, and on the 
zoned block device specific entries, the zoned device feature shows up 
in the "unknown-features" field (info virtio-status <device>)

What is missing is an entry in the blk_feature_map structure within 
hw/virtio/virtio-qmp.c. The below fixes it up.

diff --git i/hw/virtio/virtio-qmp.c w/hw/virtio/virtio-qmp.c
index b70148aba9..3efa529bab 100644
--- i/hw/virtio/virtio-qmp.c
+++ w/hw/virtio/virtio-qmp.c
@@ -176,6 +176,8 @@ static const qmp_virtio_feature_map_t 
virtio_blk_feature_map[] = {
              "VIRTIO_BLK_F_DISCARD: Discard command supported"),
      FEATURE_ENTRY(VIRTIO_BLK_F_WRITE_ZEROES, \
              "VIRTIO_BLK_F_WRITE_ZEROES: Write zeroes command supported"),
+    FEATURE_ENTRY(VIRTIO_BLK_F_ZONED, \
+            "VIRTIO_BLK_F_ZONED: Zoned block device"),
  #ifndef VIRTIO_BLK_NO_LEGACY
      FEATURE_ENTRY(VIRTIO_BLK_F_BARRIER, \
              "VIRTIO_BLK_F_BARRIER: Request barriers supported"),

Which then lets qemu report the support like this:

(qemu) info virtio-status /machine/peripheral/virtblk0/virtio-backend
/machine/peripheral/virtblk0/virtio-backend:
   device_name:             virtio-blk
   device_id:               2
   vhost_started:           false
   bus_name:                (null)
   broken:                  false
   disabled:                false
   disable_legacy_check:    false
   started:                 true
   use_started:             true
   start_on_kick:           false
   use_guest_notifier_mask: true
   vm_running:              true
   num_vqs:                 4
   queue_sel:               3
   isr:                     1
   endianness:              little
   status:
         VIRTIO_CONFIG_S_ACKNOWLEDGE: Valid virtio device found,
         VIRTIO_CONFIG_S_DRIVER: Guest OS compatible with device,
         VIRTIO_CONFIG_S_FEATURES_OK: Feature negotiation complete,
         VIRTIO_CONFIG_S_DRIVER_OK: Driver setup and ready
   Guest features:
         VIRTIO_RING_F_EVENT_IDX: Used & avail. event fields enabled,
         VIRTIO_RING_F_INDIRECT_DESC: Indirect descriptors supported,
         VIRTIO_F_VERSION_1: Device compliant for v1 spec (legacy)
         VIRTIO_BLK_F_CONFIG_WCE: Cache writeback and ...,
         VIRTIO_BLK_F_FLUSH: Flush command supported,
         VIRTIO_BLK_F_ZONED: Zoned block device,
         VIRTIO_BLK_F_WRITE_ZEROES: Write zeroes command supported,
         VIRTIO_BLK_F_MQ: Multiqueue supported,
         VIRTIO_BLK_F_TOPOLOGY: Topology information available,
         VIRTIO_BLK_F_BLK_SIZE: Block size of disk available,
         VIRTIO_BLK_F_GEOMETRY: Legacy geometry available,
         VIRTIO_BLK_F_SEG_MAX: Max segments in a request is seg_max
   unknown-features(0x0000010000000000)
   Host features:
         VIRTIO_RING_F_EVENT_IDX: Used & avail. event fields enabled,
         VIRTIO_RING_F_INDIRECT_DESC: Indirect descriptors supported,
         VIRTIO_F_VERSION_1: Device compliant for v1 spec (legacy),
         VIRTIO_F_ANY_LAYOUT: Device accepts arbitrary desc. layouts,
         VIRTIO_F_NOTIFY_ON_EMPTY: Notify when device ...,
         VHOST_USER_F_PROTOCOL_FEATURES: Vhost-user protocol ...,
         VIRTIO_BLK_F_CONFIG_WCE: Cache writeback and w...,
         VIRTIO_BLK_F_FLUSH: Flush command supported,
         VIRTIO_BLK_F_ZONED: Zoned block device,
         VIRTIO_BLK_F_WRITE_ZEROES: Write zeroes command supported,
         VIRTIO_BLK_F_MQ: Multiqueue supported,
         VIRTIO_BLK_F_TOPOLOGY: Topology information available,
         VIRTIO_BLK_F_BLK_SIZE: Block size of disk available,
         VIRTIO_BLK_F_GEOMETRY: Legacy geometry available,
         VIRTIO_BLK_F_SEG_MAX: Max segments in a request is seg_max
   unknown-features(0x0000010000000000)
   Backend features:

Cheers, Matias
