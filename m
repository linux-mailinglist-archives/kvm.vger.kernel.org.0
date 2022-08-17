Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A53859693A
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 08:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbiHQGOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 02:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiHQGOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 02:14:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96334F66E
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 23:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660716852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5WXq38uVdbQKLKQ0vvxjz7mVWhtnqhwlhqcqZU+NRQ=;
        b=eBpHt8DiqUmfkv/Yhb5/RMXDdAUk3zRoGFAvV3MKSyHYsBChAumoGZlF7SupXreD9lQAUb
        iZwluOHv4PPdhzxPqDYag6jwg91s85/FY/7vkDixWTll4g7Z3KnTs+KqcKvjhB2MdnXCCz
        8TVS5dRIrslhWzgjxxsmyhsq0j5F0Bc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-251-2EpSgBA-NRKAaZ9c-T6QCA-1; Wed, 17 Aug 2022 02:14:11 -0400
X-MC-Unique: 2EpSgBA-NRKAaZ9c-T6QCA-1
Received: by mail-wr1-f72.google.com with SMTP id i29-20020adfa51d000000b002251fd0ff14so420564wrb.16
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 23:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=b5WXq38uVdbQKLKQ0vvxjz7mVWhtnqhwlhqcqZU+NRQ=;
        b=yire7W0NqzbFkBk9r4S06xTrsV8SyynZMvjb5TQDhrbq/EsxCuyGOTCwpSooH+4iRU
         bscmzrJci4dNRrRUSREKRc9fQPgBqyq6Hury8zKmPbR19k+aEJiHwyPc49gtucs2dXfY
         bHhkaqYm1AxHBUfeen+DpfHiav2XMcaesO0723zyNOel+EhC7Si7Lyn3JjKFOHiQPBxU
         Po0/GfyA6JU4XOQTwXMEWVmHUv4QpdS/LrN4Ao3uzWEUcGqZSnZN+MkQKMEtcZwlKs9k
         iplk4NK+4nND3Y8kCQq2pNjjkPwOzlBlI6G+oQn0LY7zG1x+X1DdvfxA6WEiQhq6GZfo
         wxBw==
X-Gm-Message-State: ACgBeo0QnEgcCi28OLuyTwFxazlhPJx+BPiJ3XHrfvEtoW3bsg2u+m6B
        I4z8nKF5BGzIhN9+9WgCD4Xo3JURY32TU7uQNjgt4aO90PctRkcYaoSqZVDjs49oZqE+6P2Y/vA
        5sMVU6N3BhYWc
X-Received: by 2002:a5d:60c4:0:b0:225:25a0:fc9d with SMTP id x4-20020a5d60c4000000b0022525a0fc9dmr614846wrt.117.1660716850294;
        Tue, 16 Aug 2022 23:14:10 -0700 (PDT)
X-Google-Smtp-Source: AA6agR730vle8jBvBqewXF5R967Qxjsub/mx4PScY4o2gdmAV6NnwPQs2WenMM7iE6HcStcrtn+/eQ==
X-Received: by 2002:a5d:60c4:0:b0:225:25a0:fc9d with SMTP id x4-20020a5d60c4000000b0022525a0fc9dmr614834wrt.117.1660716850019;
        Tue, 16 Aug 2022 23:14:10 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003a4eea0aa48sm1116280wmr.0.2022.08.16.23.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 23:14:08 -0700 (PDT)
Date:   Wed, 17 Aug 2022 02:14:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, jasowang@redhat.com
Subject: Re: [PATCH V5 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Message-ID: <20220817021324-mutt-send-email-mst@kernel.org>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812104500.163625-5-lingshan.zhu@intel.com>
 <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
 <f2864c96-cddd-129e-7dd8-a3743fe7e0d0@intel.com>
 <2cbec85b-58f6-626f-df4a-cb1bb418fec1@oracle.com>
 <a488a17a-b716-52aa-cc31-2e51f8f972d2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a488a17a-b716-52aa-cc31-2e51f8f972d2@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 10:11:36AM +0800, Zhu, Lingshan wrote:
> 
> 
> On 8/17/2022 6:48 AM, Si-Wei Liu wrote:
> 
> 
> 
>     On 8/16/2022 1:29 AM, Zhu, Lingshan wrote:
> 
> 
> 
>         On 8/16/2022 3:41 PM, Si-Wei Liu wrote:
> 
>             Hi Michael,
> 
>             I just noticed this patch got pulled to linux-next prematurely
>             without getting consensus on code review, am not sure why. Hope it
>             was just an oversight.
> 
>             Unfortunately this introduced functionality regression to at least
>             two cases so far as I see:
> 
>             1. (bogus) VDPA_ATTR_DEV_NEGOTIATED_FEATURES are inadvertently
>             exposed and displayed in "vdpa dev config show" before feature
>             negotiation is done. Noted the corresponding features name shown in
>             vdpa tool is called "negotiated_features" rather than
>             "driver_features". I see in no way the intended change of the patch
>             should break this user level expectation regardless of any spec
>             requirement. Do you agree on this point?
> 
>         I will post a patch for iptour2, doing:
>         1) if iprout2 does not get driver_features from the kernel, then don't
>         show negotiated features in the command output
> 
>     This won't work as the vdpa userspace tool won't know *when* features are
>     negotiated. There's no guarantee in the kernel to assume 0 will be returned
>     from vendor driver during negotiation. On the other hand, with the supposed
>     change, userspace can't tell if there's really none of features negotiated,
>     or the feature negotiation is over. Before the change the userspace either
>     gets all the attributes when feature negotiation is over, or it gets
>     nothing when it's ongoing, so there was a distinction.This expectation of
>     what "negotiated_features" represents is established from day one, I see no
>     reason the intended kernel change to show other attributes should break
>     userspace behavior and user's expectation.
> 
> User space can only read valid *driver_features* after the features negotiation
> is done, *device_features* does not require the negotiation.
> 
> If you want to prevent random values read from driver_features, here I propose
> a fix: only read driver_features when the negotiation is done, this means to
> check (status & VIRTIO_CONFIG_S_FEATURES_OK) before reading the
> driver_features.
> Sounds good?
> 
> @MST, if this is OK, I can include this change in my next version patch series.
> 
> Thanks,
> Zhu Lingshan

Sorry I don't get it. Is there going to be a new version? Do you want me
to revert this one and then apply a new one? It's ok if yes.


>         2) process and decoding the device features.
> 
> 
>             2. There was also another implicit assumption that is broken by
>             this patch. There could be a vdpa tool query of config via
>             vdpa_dev_net_config_fill()->vdpa_get_config_unlocked() that races
>             with the first vdpa_set_features() call from VMM e.g. QEMU. Since
>             the S_FEATURES_OK blocking condition is removed, if the vdpa tool
>             query occurs earlier than the first set_driver_features() call from
>             VMM, the following code will treat the guest as legacy and then
>             trigger an erroneous vdpa_set_features_unlocked(... , 0) call to
>             the vdpa driver:
> 
>              374         /*
>              375          * Config accesses aren't supposed to trigger before
>             features are set.
>              376          * If it does happen we assume a legacy guest.
>              377          */
>              378         if (!vdev->features_valid)
>              379                 vdpa_set_features_unlocked(vdev, 0);
>              380         ops->get_config(vdev, offset, buf, len);
> 
>             Depending on vendor driver's implementation, L380 may either return
>             invalid config data (or invalid endianness if on BE) or only config
>             fields that are valid in legacy layout. What's more severe is that,
>             vdpa tool query in theory shouldn't affect feature negotiation at
>             all by making confusing calls to the device, but now it is possible
>             with the patch. Fixing this would require more delicate work on the
>             other paths involving the cf_lock reader/write semaphore.
> 
>             Not sure what you plan to do next, post the fixes for both issues
>             and get the community review? Or simply revert the patch in
>             question? Let us know.
> 
>         The spec says:
>         The device MUST allow reading of any device-specific configuration
>         field before FEATURES_OK is set by
>         the driver. This includes fields which are conditional on feature bits,
>         as long as those feature bits are offered
>         by the device.
> 
>         so whether FEATURES_OK should not block reading the device config
>         space. vdpa_get_config_unlocked() will read the features, I don't know
>         why it has a comment:
>                 /*
>                  * Config accesses aren't supposed to trigger before features
>         are set.
>                  * If it does happen we assume a legacy guest.
>                  */
> 
>         This conflicts with the spec.
> 
>         vdpa_get_config_unlocked() checks vdev->features_valid, if not valid,
>         it will set the drivers_features 0, I think this intends to prevent
>         reading random driver_features. This function does not hold any locks,
>         and didn't change anything.
> 
>         So what is the race?
>    
>     You'll see the race if you keep 'vdpa dev config show ...' running in a
>     tight loop while launching a VM with the vDPA device under query.
> 
>     -Siwei
> 
> 
> 
>        
>         Thanks
> 
>        
> 
>             Thanks,
>             -Siwei
> 
> 
>             On 8/12/2022 3:44 AM, Zhu Lingshan wrote:
> 
>                 Users may want to query the config space of a vDPA device,
>                 to choose a appropriate one for a certain guest. This means the
>                 users need to read the config space before FEATURES_OK, and
>                 the existence of config space contents does not depend on
>                 FEATURES_OK.
> 
>                 The spec says:
>                 The device MUST allow reading of any device-specific
>                 configuration
>                 field before FEATURES_OK is set by the driver. This includes
>                 fields which are conditional on feature bits, as long as those
>                 feature bits are offered by the device.
> 
>                 Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>                 ---
>                   drivers/vdpa/vdpa.c | 8 --------
>                   1 file changed, 8 deletions(-)
> 
>                 diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>                 index 6eb3d972d802..bf312d9c59ab 100644
>                 --- a/drivers/vdpa/vdpa.c
>                 +++ b/drivers/vdpa/vdpa.c
>                 @@ -855,17 +855,9 @@ vdpa_dev_config_fill(struct vdpa_device
>                 *vdev, struct sk_buff *msg, u32 portid,
>                   {
>                       u32 device_id;
>                       void *hdr;
>                 -    u8 status;
>                       int err;
>                         down_read(&vdev->cf_lock);
>                 -    status = vdev->config->get_status(vdev);
>                 -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>                 -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>                 completed");
>                 -        err = -EAGAIN;
>                 -        goto out;
>                 -    }
>                 -
>                       hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family,
>                 flags,
>                                 VDPA_CMD_DEV_CONFIG_GET);
>                       if (!hdr) {
> 
> 
> 
> 
> 
> 
> 
> 

