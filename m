Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE13625477
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 08:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiKKHfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 02:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiKKHfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 02:35:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8752BC14
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 23:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668152079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGYDSX0Y4IYL9or7FMcFJ9UytPGX9IsysVtxZpm3ad0=;
        b=ZHoRb26eqjxPVfmqsxWxhKyxGFdfBjR41T8848QkdJAoeh4/qV9RkRdU3frHVC/OAeJhua
        shTLmc7ETRBZPS8KzPNyhUzcfcRE+oH/PzSf5rzangP6dnAkXAdhpEeXcE3VsxkZ8pyJub
        BRr7Ftq7Ydw+oKIkrk13DJHTr/cAAa8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-SEmSmAbPOzijRgWqALC4QA-1; Fri, 11 Nov 2022 02:34:38 -0500
X-MC-Unique: SEmSmAbPOzijRgWqALC4QA-1
Received: by mail-pj1-f71.google.com with SMTP id bt19-20020a17090af01300b00213c7cd1083so2362992pjb.8
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 23:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGYDSX0Y4IYL9or7FMcFJ9UytPGX9IsysVtxZpm3ad0=;
        b=L0iMS30IMTZrwL2zC14xDAbmx/weDqbd2q8xrnk63zW7aHluVEFuFU1oolTdroLy+W
         TXyahakjaEdfMTRIIpgdll0UcnknFpI6va/UemSxHA+Xfaxc/U/+r5L4POUeaMnyAWOi
         JpjBydFJoP8pU1tYmGITIg6FxAdqvbJv4MT2mXDOlob+np8SN5Dj8reFUxTdZnyGIQiE
         IliYRGpYFfUckhXHHfN7jaIaoXkmDn0NlgLq23gYUkAzLbDDjT9VxCCkt76Eyzcn7je6
         SQsCZRoSOHjhKomaVUtG47wfvjYHF7UQv4WrQ69yZ+x23wKvGB72ksSRapMmvpcxcBHH
         AYcA==
X-Gm-Message-State: ANoB5pnKJmmXMTfc2MeZEEvUzfM4Jyi/sUM+STRLoQ6/Km1MIK1aX8b1
        9w9SrnXIFd0fTJhyPXpnjOZ5ri4o0i+ltdUEp8VtZkDTSidHBxLOaD6zFBeJZ4XKrm63LE6zEXI
        hLfD1TUrpGX6n
X-Received: by 2002:a17:90b:3145:b0:212:f2be:bc38 with SMTP id ip5-20020a17090b314500b00212f2bebc38mr574434pjb.175.1668152077637;
        Thu, 10 Nov 2022 23:34:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf43RBsCDrmxjkG9XvIleloJWaJ/Zm4WzbrO3ZsCmosi3TsYDSPMckV8W+AQBMGU+kE2S6nNGA==
X-Received: by 2002:a17:90b:3145:b0:212:f2be:bc38 with SMTP id ip5-20020a17090b314500b00212f2bebc38mr574415pjb.175.1668152077294;
        Thu, 10 Nov 2022 23:34:37 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s18-20020a170903215200b00186a6b6350esm913916ple.268.2022.11.10.23.34.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 23:34:36 -0800 (PST)
Message-ID: <aa82783b-b1f5-a82b-5136-1f7f7725a433@redhat.com>
Date:   Fri, 11 Nov 2022 15:34:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v6 05/10] vdpa: move SVQ vring features check to net/
Content-Language: en-US
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221108170755.92768-1-eperezma@redhat.com>
 <20221108170755.92768-6-eperezma@redhat.com>
 <56bfad97-74d2-8570-c391-83ecf9965cfd@redhat.com>
 <CAJaqyWd47QdBoSm9RdF2yx21hKv_=YRp3uvP13Qb9PaVksss7Q@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CAJaqyWd47QdBoSm9RdF2yx21hKv_=YRp3uvP13Qb9PaVksss7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/11/10 21:09, Eugenio Perez Martin 写道:
> On Thu, Nov 10, 2022 at 6:40 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2022/11/9 01:07, Eugenio Pérez 写道:
>>> The next patches will start control SVQ if possible. However, we don't
>>> know if that will be possible at qemu boot anymore.
>>
>> If I was not wrong, there's no device specific feature that is checked
>> in the function. So it should be general enough to be used by devices
>> other than net. Then I don't see any advantage of doing this.
>>
> Because vhost_vdpa_init_svq is called at qemu boot, failing if it is
> not possible to shadow the Virtqueue.
>
> Now the CVQ will be shadowed if possible, so we need to check this at
> device start, not at initialization.


Any reason we can't check this at device start? We don't need 
driver_features and we can do any probing to make sure cvq has an unique 
group during initialization time.


>   To store this information at boot
> time is not valid anymore, because v->shadow_vqs_enabled is not valid
> at this time anymore.


Ok, but this doesn't explain why it is net specific but vhost-vdpa specific.

Thanks


>
> Thanks!
>
>> Thanks
>>
>>
>>> Since the moved checks will be already evaluated at net/ to know if it
>>> is ok to shadow CVQ, move them.
>>>
>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>> ---
>>>    hw/virtio/vhost-vdpa.c | 33 ++-------------------------------
>>>    net/vhost-vdpa.c       |  3 ++-
>>>    2 files changed, 4 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
>>> index 3df2775760..146f0dcb40 100644
>>> --- a/hw/virtio/vhost-vdpa.c
>>> +++ b/hw/virtio/vhost-vdpa.c
>>> @@ -402,29 +402,9 @@ static int vhost_vdpa_get_dev_features(struct vhost_dev *dev,
>>>        return ret;
>>>    }
>>>
>>> -static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
>>> -                               Error **errp)
>>> +static void vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v)
>>>    {
>>>        g_autoptr(GPtrArray) shadow_vqs = NULL;
>>> -    uint64_t dev_features, svq_features;
>>> -    int r;
>>> -    bool ok;
>>> -
>>> -    if (!v->shadow_vqs_enabled) {
>>> -        return 0;
>>> -    }
>>> -
>>> -    r = vhost_vdpa_get_dev_features(hdev, &dev_features);
>>> -    if (r != 0) {
>>> -        error_setg_errno(errp, -r, "Can't get vdpa device features");
>>> -        return r;
>>> -    }
>>> -
>>> -    svq_features = dev_features;
>>> -    ok = vhost_svq_valid_features(svq_features, errp);
>>> -    if (unlikely(!ok)) {
>>> -        return -1;
>>> -    }
>>>
>>>        shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
>>>        for (unsigned n = 0; n < hdev->nvqs; ++n) {
>>> @@ -436,7 +416,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
>>>        }
>>>
>>>        v->shadow_vqs = g_steal_pointer(&shadow_vqs);
>>> -    return 0;
>>>    }
>>>
>>>    static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
>>> @@ -461,11 +440,7 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
>>>        dev->opaque =  opaque ;
>>>        v->listener = vhost_vdpa_memory_listener;
>>>        v->msg_type = VHOST_IOTLB_MSG_V2;
>>> -    ret = vhost_vdpa_init_svq(dev, v, errp);
>>> -    if (ret) {
>>> -        goto err;
>>> -    }
>>> -
>>> +    vhost_vdpa_init_svq(dev, v);
>>>        vhost_vdpa_get_iova_range(v);
>>>
>>>        if (!vhost_vdpa_first_dev(dev)) {
>>> @@ -476,10 +451,6 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
>>>                                   VIRTIO_CONFIG_S_DRIVER);
>>>
>>>        return 0;
>>> -
>>> -err:
>>> -    ram_block_discard_disable(false);
>>> -    return ret;
>>>    }
>>>
>>>    static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *dev,
>>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
>>> index d3b1de481b..fb35b17ab4 100644
>>> --- a/net/vhost-vdpa.c
>>> +++ b/net/vhost-vdpa.c
>>> @@ -117,9 +117,10 @@ static bool vhost_vdpa_net_valid_svq_features(uint64_t features, Error **errp)
>>>        if (invalid_dev_features) {
>>>            error_setg(errp, "vdpa svq does not work with features 0x%" PRIx64,
>>>                       invalid_dev_features);
>>> +        return false;
>>>        }
>>>
>>> -    return !invalid_dev_features;
>>> +    return vhost_svq_valid_features(features, errp);
>>>    }
>>>
>>>    static int vhost_vdpa_net_check_device_id(struct vhost_net *net)

