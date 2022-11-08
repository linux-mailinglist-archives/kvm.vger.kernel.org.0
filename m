Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B885F620CFE
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 11:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbiKHKSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 05:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiKHKSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 05:18:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722F75FBC
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 02:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667902671;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cF+8y1hQLR1XQYB6z4AKH7Ufuu5GHf8+qc+tJznnmzM=;
        b=OJmuV3HdNM/7V2dus3kjC5QminGNWNsLRdomaoD4ivzVDC2RI1FVGterYeObrNzBBg+uI4
        LpobILteEkz2NeudBbMlJjVHW/Jg1xK+XHOGi6aCJ7oYvaNHRsQ5Ps9oz6wyLzC7RQIhYm
        O39uX+W00n9vrG/OgItDxc5ftqfjLlE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-526-ke9NUBDBNj653NJDtkzFSg-1; Tue, 08 Nov 2022 05:17:50 -0500
X-MC-Unique: ke9NUBDBNj653NJDtkzFSg-1
Received: by mail-wm1-f70.google.com with SMTP id f26-20020a7bcc1a000000b003c03db14864so3681853wmh.6
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 02:17:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cF+8y1hQLR1XQYB6z4AKH7Ufuu5GHf8+qc+tJznnmzM=;
        b=cdWQKa+HCy1QcseLN90ViDnlvFzdczgpbhqSsfDml/KVXNkHy7OoLsJs6Ims2aP/nY
         QG5hGQTPManRvnnsFY8EbWlLA5rf/7OJuTR7Q55ADSMYrslbA55c9hSyVadLyifM4RtR
         iuxehpe7vR6QSOIxzfVbf6ktern/HeLe8ce9pOiPBdeySimkYx1xDw29RoHIxET62AwC
         UChMmhk9EqMiUyzAxS14baWL+fQz4b7zLGbObXGszPcSPCsRxrRjYpJY6b4fkl62MqZe
         NaMR67dx7Q/G9G+hB9yDZsYQnObi1HalN6p/qGgXHrJBVP58xputAzdonTbKiOCU5F/S
         7XDA==
X-Gm-Message-State: ACrzQf2teQP+XB0IVwo+P2xk3XSsdAsPNj3l7APEy5J06Sv3TsVPkXU5
        qdWl2SC/8AxWaDJ+sJLGCo4mMKss5Gh/Z2wbaRwa0c57coKt+FC0o+ixXxgUNtm7OYiLRzh3dO2
        WZqIUa6ZMMAgx
X-Received: by 2002:a05:600c:a47:b0:3a6:5848:4bde with SMTP id c7-20020a05600c0a4700b003a658484bdemr45840883wmq.189.1667902669069;
        Tue, 08 Nov 2022 02:17:49 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6qjMk7Q2aU+OW7rdNY0NXXzOdM9Qok9tzwuYqCSRhR1WPENKApNbIQikvl2g7GYLIb6cuaWw==
X-Received: by 2002:a05:600c:a47:b0:3a6:5848:4bde with SMTP id c7-20020a05600c0a4700b003a658484bdemr45840863wmq.189.1667902668850;
        Tue, 08 Nov 2022 02:17:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s1-20020a7bc381000000b003c6b874a0dfsm12609043wmj.14.2022.11.08.02.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 02:17:48 -0800 (PST)
Message-ID: <7105abc8-85d1-63a4-7f77-a2b3e0177b6f@redhat.com>
Date:   Tue, 8 Nov 2022 11:17:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC] vhost: Clear the pending messages on
 vhost_init_device_iotlb()
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
References: <20221107203431.368306-1-eric.auger@redhat.com>
 <20221107153924-mutt-send-email-mst@kernel.org>
 <b8487793-d7b8-0557-a4c2-b62754e14830@redhat.com>
 <20221107180022-mutt-send-email-mst@kernel.org>
 <CACGkMEsYyH5P2h6XkBgrW4O-xJXxdzzRa1+T2zjJ07OHiYObVA@mail.gmail.com>
 <20221108035142-mutt-send-email-mst@kernel.org>
 <CACGkMEtFhmgKrKwTT8MdQG26wbi20Z5cTn69ycBtE17V+Kupuw@mail.gmail.com>
 <20221108041820-mutt-send-email-mst@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20221108041820-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
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

Hi Michael, Jason,

On 11/8/22 10:31, Michael S. Tsirkin wrote:
> On Tue, Nov 08, 2022 at 05:13:50PM +0800, Jason Wang wrote:
>> On Tue, Nov 8, 2022 at 4:56 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>> On Tue, Nov 08, 2022 at 11:09:36AM +0800, Jason Wang wrote:
>>>> On Tue, Nov 8, 2022 at 7:06 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>> On Mon, Nov 07, 2022 at 10:10:06PM +0100, Eric Auger wrote:
>>>>>> Hi Michael,
>>>>>> On 11/7/22 21:42, Michael S. Tsirkin wrote:
>>>>>>> On Mon, Nov 07, 2022 at 09:34:31PM +0100, Eric Auger wrote:
>>>>>>>> When the vhost iotlb is used along with a guest virtual iommu
>>>>>>>> and the guest gets rebooted, some MISS messages may have been
>>>>>>>> recorded just before the reboot and spuriously executed by
>>>>>>>> the virtual iommu after the reboot. Despite the device iotlb gets
>>>>>>>> re-initialized, the messages are not cleared. Fix that by calling
>>>>>>>> vhost_clear_msg() at the end of vhost_init_device_iotlb().
>>>>>>>>
>>>>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>>>>> ---
>>>>>>>>  drivers/vhost/vhost.c | 1 +
>>>>>>>>  1 file changed, 1 insertion(+)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>>>>>>> index 40097826cff0..422a1fdee0ca 100644
>>>>>>>> --- a/drivers/vhost/vhost.c
>>>>>>>> +++ b/drivers/vhost/vhost.c
>>>>>>>> @@ -1751,6 +1751,7 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
>>>>>>>>    }
>>>>>>>>
>>>>>>>>    vhost_iotlb_free(oiotlb);
>>>>>>>> +  vhost_clear_msg(d);
>>>>>>>>
>>>>>>>>    return 0;
>>>>>>>>  }
>>>>>>> Hmm.  Can't messages meanwhile get processes and affect the
>>>>>>> new iotlb?
>>>>>> Isn't the msg processing stopped at the moment this function is called
>>>>>> (VHOST_SET_FEATURES)?
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> Eric
>>>>> It's pretty late here I'm not sure.  You tell me what prevents it.
>>>> So the proposed code assumes that Qemu doesn't process device IOTLB
>>>> before VHOST_SET_FEAETURES. Consider there's no reset in the general
>>>> vhost uAPI,  I wonder if it's better to move the clear to device code
>>>> like VHOST_NET_SET_BACKEND. So we can clear it per vq?
>>> Hmm this makes no sense to me. iommu sits between backend
>>> and frontend. Tying one to another is going to backfire.
>> I think we need to emulate what real devices are doing. Device should
>> clear the page fault message during reset, so the driver won't read
>> anything after reset. But we don't have a per device stop or reset
>> message for vhost-net. That's why the VHOST_NET_SET_BACKEND came into
>> my mind.
> That's not a reset message. Userspace can switch backends at will.
> I guess we could check when backend is set to -1.
> It's a hack but might work.
>
>>> I'm thinking more along the lines of doing everything
>>> under iotlb_lock.
>> I think the problem is we need to find a proper place to clear the
>> message. So I don't get how iotlb_lock can help: the message could be
>> still read from user space after the backend is set to NULL.
>>
>> Thanks
> Well I think the real problem is this.
>
> vhost_net_set_features does:
>
>         if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
>                 if (vhost_init_device_iotlb(&n->dev, true))
>                         goto out_unlock;
>         }
>
>
> so we get a new iotlb each time features are set.
>
> But features can be changes while device is running.
> E.g.
> 	VHOST_F_LOG_ALL
>
>
> Let's just say this hack of reusing feature bits for backend
> was not my brightest idea :(
>

Isn't vhost_init_device_iotlb() racy then, as d->iotlb is first updated with niotlb and later d->vqs[i]->iotlb is updated with niotlb. What does garantee this is done atomically?

Shouldn't we hold the dev->mutex to make all the sequence atomic and
include vhost_clear_msg()?  Can't the vhost_clear_msg() take the dev lock?

Thanks

Eric

>
>
>
>>>
>>>
>>>>> BTW vhost_init_device_iotlb gets enabled parameter but ignores
>>>>> it, we really should drop that.
>>>> Yes.
>>>>
>>>>> Also, it looks like if features are set with VIRTIO_F_ACCESS_PLATFORM
>>>>> and then cleared, iotlb is not properly cleared - bug?
>>>> Not sure, old IOTLB may still work. But for safety, we need to disable
>>>> device IOTLB in this case.
>>>>
>>>> Thanks
>>>>
>>>>>
>>>>>>>
>>>>>>>> --
>>>>>>>> 2.37.3

