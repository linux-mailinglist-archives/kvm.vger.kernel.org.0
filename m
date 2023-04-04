Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BA96D6713
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbjDDPUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbjDDPUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:20:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052FD1727
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680621561;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9h0qe2de4wpUWOB28748KnL4bo+TUsPB4FwOqLcCkxY=;
        b=GyD4aNWDKMgCqfiIEKS6R8yBIaNkuVrFWrEi2MCJ8H1kQahZhaf7fhNKZH7KS+smuH5Qhs
        EoNaINUQUoLvjgM77HE276X/GOT3Et1/aVlaGTK+Pz3SSN24Kcd6EbXdnjtitQQE4rfS+b
        8mvGpJ4k7wnSxloNhx00z5cRGSxdyRQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-ReLj1XzzM9ifLucEzXVSwA-1; Tue, 04 Apr 2023 11:19:11 -0400
X-MC-Unique: ReLj1XzzM9ifLucEzXVSwA-1
Received: by mail-qv1-f71.google.com with SMTP id g6-20020ad45426000000b005a33510e95aso14808799qvt.16
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 08:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680621540;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9h0qe2de4wpUWOB28748KnL4bo+TUsPB4FwOqLcCkxY=;
        b=ZZPLksyjg7WgFhkQO2M5tEMu+8M+qCfK3NYdXvy8N7Uw7GNo9vZLkXmFAwotWNkidx
         CgCkA7K3irn7HImuod5t0qoN51VhXEcsXqkcPdhk2zZ4PU1wHUcGVbEfRarkX3zRAkRb
         efxyPRHnhmPqQMXwdJGrD4g7qPWDDFYaviODqI4QyYBTxUjlzUvSY7k4ll/rxUWMSOC8
         R9BPQYawIXt/JJiL1vj/VeXZwMytlfKLL536BTqAW+VsXM4PSMjxLQUGnGZeODpk9Yxd
         yCO2FjwCpmQbZ1jYY60r5ZDRoEH662FHilVd6o3kq+ppNUSEbNayw8fasl/vk6Rf/Wv9
         RN4A==
X-Gm-Message-State: AAQBX9dLxV9uEdk96MGCUgg5mjF7D3O+UucUnm9ggCjgPJSxjBRe5A0R
        7B7xZhafWUMeFarKfxXhSJIEpzK7Z+2+o23OgtTTLqTCZ8RwDJ9Lh90j5o5vvrVQWCW6J2f9OBO
        NkmqdzuDAyQ7V
X-Received: by 2002:a05:6214:c6b:b0:5d5:11b4:ad6 with SMTP id t11-20020a0562140c6b00b005d511b40ad6mr4092544qvj.5.1680621539861;
        Tue, 04 Apr 2023 08:18:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350b/pUGHnnzAa/Is2PTZjxccUTN1xIqWGh6dFWoPmFhMxxL0nmFn4Q7QHgQ+QfiC+fi7gOde3g==
X-Received: by 2002:a05:6214:c6b:b0:5d5:11b4:ad6 with SMTP id t11-20020a0562140c6b00b005d511b40ad6mr4092477qvj.5.1680621539415;
        Tue, 04 Apr 2023 08:18:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ea7-20020ad458a7000000b005dd8b9345a7sm3427407qvb.63.2023.04.04.08.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 08:18:57 -0700 (PDT)
Message-ID: <fc87191d-2e79-83c3-b5ba-7f8b1083988a@redhat.com>
Date:   Tue, 4 Apr 2023 17:18:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 02/12] vfio/pci: Only check ownership of opened devices
 in hot reset
Content-Language: en-US
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-3-yi.l.liu@intel.com>
 <844faa5c-2968-2a4f-8a70-900f359be1a0@redhat.com>
 <DS0PR11MB75290339DD0FD467146D4655C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <DS0PR11MB75290339DD0FD467146D4655C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/4/23 16:37, Liu, Yi L wrote:
> Hi Eric,
>
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: Tuesday, April 4, 2023 10:00 PM
>>
>> Hi YI,
>>
>> On 4/1/23 16:44, Yi Liu wrote:
>>> If the affected device is not opened by any user, it's safe to reset it
>>> given it's not in use.
>>>
>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>> ---
>>>  drivers/vfio/pci/vfio_pci_core.c | 14 +++++++++++---
>>>  include/uapi/linux/vfio.h        |  8 ++++++++
>>>  2 files changed, 19 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>>> index 65bbef562268..5d745c9abf05 100644
>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>> @@ -2429,10 +2429,18 @@ static int vfio_pci_dev_set_hot_reset(struct
>> vfio_device_set *dev_set,
>>>  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
>>>  		/*
>>> -		 * Test whether all the affected devices are contained by the
>>> -		 * set of groups provided by the user.
>>> +		 * Test whether all the affected devices can be reset by the
>>> +		 * user.
>>> +		 *
>>> +		 * Resetting an unused device (not opened) is safe, because
>>> +		 * dev_set->lock is held in hot reset path so this device
>>> +		 * cannot race being opened by another user simultaneously.
>>> +		 *
>>> +		 * Otherwise all opened devices in the dev_set must be
>>> +		 * contained by the set of groups provided by the user.
>>>  		 */
>>> -		if (!vfio_dev_in_groups(cur_vma, groups)) {
>>> +		if (cur_vma->vdev.open_count &&
>>> +		    !vfio_dev_in_groups(cur_vma, groups)) {
>>>  			ret = -EINVAL;
>>>  			goto err_undo;
>>>  		}
>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>> index 0552e8dcf0cb..f96e5689cffc 100644
>>> --- a/include/uapi/linux/vfio.h
>>> +++ b/include/uapi/linux/vfio.h
>>> @@ -673,6 +673,14 @@ struct vfio_pci_hot_reset_info {
>>>   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
>>>   *				    struct vfio_pci_hot_reset)
>>>   *
>>> + * Userspace requests hot reset for the devices it uses.  Due to the
>>> + * underlying topology, multiple devices can be affected in the reset
>> by the reset
>>> + * while some might be opened by another user.  To avoid interference
>> s/interference/hot reset failure?
> I don’t think user can really avoid hot reset failure since there may
> be new devices plugged into the affected slot. Even user has opened
I don't know the legacy wrt that issue but this sounds a serious issue,
meaning the reset of an assigned device could impact another device
belonging to another group not not owned by the user?
> all the groups/devices reported by VFIO_DEVICE_GET_PCI_HOT_RESET_INFO,
> the hot reset can fail if new device is plugged in and has not been
> bound to vfio or opened by another user during the window of
> _INFO and HOT_RESET.
with respect to the latter isn't the dev_set lock held during the hot
reset and sufficient to prevent any new opening to occur?
>
> maybe the whole statement should be as below:
>
> To avoid interference, the hot reset can only be conducted when all
> the affected devices are either opened by the calling user or not
> opened yet at the moment of the hot reset attempt.

OK

Eric
>
>>> + * the calling user must ensure all affected devices, if opened, are
>>> + * owned by itself.
>>> + *
>>> + * The ownership is proved by an array of group fds.
>>> + *
>>>   * Return: 0 on success, -errno on failure.
>>>   */
>>>  struct vfio_pci_hot_reset {
> Regards,
> Yi Liu

