Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28CF627542
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 05:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbiKNE1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 23:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiKNE1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 23:27:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D627E626F
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668399980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vwym0ZaFelNCQ7K3dR9+z21gGG1Ur/tpkn5XSY0qAN8=;
        b=eS7j43vw4EE9nvtPt/nVkFPdL+e0Ew3p2m/zvxaVjszOC09fRs4RW492lGRFVgku4C/RRk
        xhusc/2sPdQM+63hSP7itunxYxS2QZ0VWIVeyVOddo7cl7tXQuCxzflf+ysFgmucVcB64T
        xeg/govFfJ1gApj2oaTf8/1mKkhad9E=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-rZMp3L9ZP_akfsZU0w9xrw-1; Sun, 13 Nov 2022 23:26:18 -0500
X-MC-Unique: rZMp3L9ZP_akfsZU0w9xrw-1
Received: by mail-pl1-f197.google.com with SMTP id o7-20020a170902d4c700b001868cdac9adso8137913plg.13
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 20:26:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwym0ZaFelNCQ7K3dR9+z21gGG1Ur/tpkn5XSY0qAN8=;
        b=ZV6Thl3ePtqH7NQxC1pf6ElYAFvXytUe0rGFLjh0L4NMPKO/s5JruUj8qs8BGBs+3g
         EKj53B+ZHneV0Gzqt1wM7TQSSUfy2xqlv1Qxap1VgpSxE9xevbbhmWo2RwWV0XAeP/XG
         P1Nce2epBJsPef7jDeA+GUlpx47nSzsB5nTkiPLLexLTEQRJxQUDgOFlWx+OH6p5kqqa
         9mL/GVK8XCj3Swun8YHJ4SYyeMX4QHvP5GEUwds6EtDY2vVfCT1MD3RlMUC0FhoPAuD6
         tF+p4nWUjGRJLppc34ygvUQw9TlswAddkaO6I6vh0rVQPe+3UxsKQELnhNlSBiw5a89v
         3OiQ==
X-Gm-Message-State: ANoB5pkrn+DlgoCzyL9DnGs3f9GOGtDPu69OWZeb9qlLiW3hk9eChwhh
        RsBSmFzWlx328Wc7nkKW+lqRoCYpeWvmzFV8h9eHR0pUSszLcWcpDpNoJLBR45NbGEoCF5+FOhX
        rbDj92ascUbAF
X-Received: by 2002:a17:902:e805:b0:186:880c:167e with SMTP id u5-20020a170902e80500b00186880c167emr12038593plg.7.1668399976933;
        Sun, 13 Nov 2022 20:26:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7V1CaAibhTcmpSTUJLQDa3kEhEiSXrPV4yQY+AFmfwR5pL+Nr3nm56v/oWbybsXnEOi1sJvA==
X-Received: by 2002:a17:902:e805:b0:186:880c:167e with SMTP id u5-20020a170902e80500b00186880c167emr12038568plg.7.1668399976575;
        Sun, 13 Nov 2022 20:26:16 -0800 (PST)
Received: from [10.72.13.180] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r23-20020aa79637000000b0056b95260b91sm5570576pfg.67.2022.11.13.20.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Nov 2022 20:26:16 -0800 (PST)
Message-ID: <72179a7d-2303-7f11-7ebc-e4d9c8d5392f@redhat.com>
Date:   Mon, 14 Nov 2022 12:26:00 +0800
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
 <aa82783b-b1f5-a82b-5136-1f7f7725a433@redhat.com>
 <CAJaqyWfmTn1_o2z2S_o=bu2mD=r0+T=1+dh_WOwbpQaYQK0YSQ@mail.gmail.com>
 <CACGkMEvQm_0VqF5q2XtWmaHXmSj0Xjg7br3ydOQVVcHJ0yb_GA@mail.gmail.com>
 <CAJaqyWfYN_Y6OQ-ugdH3d4VRGBJufMLBhH47dfB0rLg=MEt47g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CAJaqyWfYN_Y6OQ-ugdH3d4VRGBJufMLBhH47dfB0rLg=MEt47g@mail.gmail.com>
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


在 2022/11/11 20:58, Eugenio Perez Martin 写道:
> On Fri, Nov 11, 2022 at 9:07 AM Jason Wang <jasowang@redhat.com> wrote:
>> On Fri, Nov 11, 2022 at 3:56 PM Eugenio Perez Martin
>> <eperezma@redhat.com> wrote:
>>> On Fri, Nov 11, 2022 at 8:34 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>
>>>> 在 2022/11/10 21:09, Eugenio Perez Martin 写道:
>>>>> On Thu, Nov 10, 2022 at 6:40 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> 在 2022/11/9 01:07, Eugenio Pérez 写道:
>>>>>>> The next patches will start control SVQ if possible. However, we don't
>>>>>>> know if that will be possible at qemu boot anymore.
>>>>>> If I was not wrong, there's no device specific feature that is checked
>>>>>> in the function. So it should be general enough to be used by devices
>>>>>> other than net. Then I don't see any advantage of doing this.
>>>>>>
>>>>> Because vhost_vdpa_init_svq is called at qemu boot, failing if it is
>>>>> not possible to shadow the Virtqueue.
>>>>>
>>>>> Now the CVQ will be shadowed if possible, so we need to check this at
>>>>> device start, not at initialization.
>>>>
>>>> Any reason we can't check this at device start? We don't need
>>>> driver_features and we can do any probing to make sure cvq has an unique
>>>> group during initialization time.
>>>>
>>> We need the CVQ index to check if it has an independent group. CVQ
>>> index depends on the features the guest's ack:
>>> * If it acks _F_MQ, it is the last one.
>>> * If it doesn't, CVQ idx is 2.
>>>
>>> We cannot have acked features at initialization, and they could
>>> change: It is valid for a guest to ack _F_MQ, then reset the device,
>>> then not ack it.
>> Can we do some probing by negotiating _F_MQ if the device offers it,
>> then we can know if cvq has a unique group?
>>
> What if the guest does not ack _F_MQ?
>
> To be completed it would go like:
>
> * Probe negotiate _F_MQ, check unique group,
> * Probe negotiate !_F_MQ, check unique group,


I think it should be a bug if device present a unique virtqueue group 
that depends on a specific feature. That is to say, we can do a single 
round of probing instead of try it twice here.


> * Actually negotiate with the guest's feature set.
> * React to failures. Probably the same way as if the CVQ is not
> isolated, disabling SVQ?
>
> To me it seems simpler to specify somehow that the vq must be independent.


It's just a suggestion, if you think doing it at the start, I'm fine. 
But we need document the reason with a comment maybe.

Thanks


>
> Thanks!
>
>>>>>    To store this information at boot
>>>>> time is not valid anymore, because v->shadow_vqs_enabled is not valid
>>>>> at this time anymore.
>>>>
>>>> Ok, but this doesn't explain why it is net specific but vhost-vdpa specific.
>>>>
>>> We can try to move it to a vhost op, but we have the same problem as
>>> the svq array allocation: We don't have the right place in vhost ops
>>> to check this. Maybe vhost_set_features is the right one here?
>> If we can do all the probing at the initialization phase, we can do
>> everything there.
>>
>> Thanks
>>
>>> Thanks!
>>>
>>>> Thanks
>>>>
>>>>
>>>>> Thanks!
>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>> Since the moved checks will be already evaluated at net/ to know if it
>>>>>>> is ok to shadow CVQ, move them.
>>>>>>>
>>>>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>>>>> ---
>>>>>>>     hw/virtio/vhost-vdpa.c | 33 ++-------------------------------
>>>>>>>     net/vhost-vdpa.c       |  3 ++-
>>>>>>>     2 files changed, 4 insertions(+), 32 deletions(-)
>>>>>>>
>>>>>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
>>>>>>> index 3df2775760..146f0dcb40 100644
>>>>>>> --- a/hw/virtio/vhost-vdpa.c
>>>>>>> +++ b/hw/virtio/vhost-vdpa.c
>>>>>>> @@ -402,29 +402,9 @@ static int vhost_vdpa_get_dev_features(struct vhost_dev *dev,
>>>>>>>         return ret;
>>>>>>>     }
>>>>>>>
>>>>>>> -static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
>>>>>>> -                               Error **errp)
>>>>>>> +static void vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v)
>>>>>>>     {
>>>>>>>         g_autoptr(GPtrArray) shadow_vqs = NULL;
>>>>>>> -    uint64_t dev_features, svq_features;
>>>>>>> -    int r;
>>>>>>> -    bool ok;
>>>>>>> -
>>>>>>> -    if (!v->shadow_vqs_enabled) {
>>>>>>> -        return 0;
>>>>>>> -    }
>>>>>>> -
>>>>>>> -    r = vhost_vdpa_get_dev_features(hdev, &dev_features);
>>>>>>> -    if (r != 0) {
>>>>>>> -        error_setg_errno(errp, -r, "Can't get vdpa device features");
>>>>>>> -        return r;
>>>>>>> -    }
>>>>>>> -
>>>>>>> -    svq_features = dev_features;
>>>>>>> -    ok = vhost_svq_valid_features(svq_features, errp);
>>>>>>> -    if (unlikely(!ok)) {
>>>>>>> -        return -1;
>>>>>>> -    }
>>>>>>>
>>>>>>>         shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
>>>>>>>         for (unsigned n = 0; n < hdev->nvqs; ++n) {
>>>>>>> @@ -436,7 +416,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
>>>>>>>         }
>>>>>>>
>>>>>>>         v->shadow_vqs = g_steal_pointer(&shadow_vqs);
>>>>>>> -    return 0;
>>>>>>>     }
>>>>>>>
>>>>>>>     static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
>>>>>>> @@ -461,11 +440,7 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
>>>>>>>         dev->opaque =  opaque ;
>>>>>>>         v->listener = vhost_vdpa_memory_listener;
>>>>>>>         v->msg_type = VHOST_IOTLB_MSG_V2;
>>>>>>> -    ret = vhost_vdpa_init_svq(dev, v, errp);
>>>>>>> -    if (ret) {
>>>>>>> -        goto err;
>>>>>>> -    }
>>>>>>> -
>>>>>>> +    vhost_vdpa_init_svq(dev, v);
>>>>>>>         vhost_vdpa_get_iova_range(v);
>>>>>>>
>>>>>>>         if (!vhost_vdpa_first_dev(dev)) {
>>>>>>> @@ -476,10 +451,6 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
>>>>>>>                                    VIRTIO_CONFIG_S_DRIVER);
>>>>>>>
>>>>>>>         return 0;
>>>>>>> -
>>>>>>> -err:
>>>>>>> -    ram_block_discard_disable(false);
>>>>>>> -    return ret;
>>>>>>>     }
>>>>>>>
>>>>>>>     static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *dev,
>>>>>>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
>>>>>>> index d3b1de481b..fb35b17ab4 100644
>>>>>>> --- a/net/vhost-vdpa.c
>>>>>>> +++ b/net/vhost-vdpa.c
>>>>>>> @@ -117,9 +117,10 @@ static bool vhost_vdpa_net_valid_svq_features(uint64_t features, Error **errp)
>>>>>>>         if (invalid_dev_features) {
>>>>>>>             error_setg(errp, "vdpa svq does not work with features 0x%" PRIx64,
>>>>>>>                        invalid_dev_features);
>>>>>>> +        return false;
>>>>>>>         }
>>>>>>>
>>>>>>> -    return !invalid_dev_features;
>>>>>>> +    return vhost_svq_valid_features(features, errp);
>>>>>>>     }
>>>>>>>
>>>>>>>     static int vhost_vdpa_net_check_device_id(struct vhost_net *net)

