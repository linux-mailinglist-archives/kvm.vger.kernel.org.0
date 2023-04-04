Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E296D681C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbjDDQAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbjDDP77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:59:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458B31B8
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680623950;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OeMolX1SxNFCB7moKC067zOF/AMbVP1lQf1Wv5j6Xz8=;
        b=aJz8ojuRqPhcQbpM3bUtawBHjal3D4YyEWGEz83N21qUGZ0qPA0PRQg+vDhUm/zk8Thn6d
        2Vx95MgWVVkzeavBtSDdOoJNdAya7QC3DY0i9cA0xW+h2PYjsuIxlDU2C8o2WcJz+zEzlR
        kb/IUj5tJDJ2MJGUCwHmU1KWw7J7oek=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-XlpqAahTOZGXU_xVvoV3rg-1; Tue, 04 Apr 2023 11:59:08 -0400
X-MC-Unique: XlpqAahTOZGXU_xVvoV3rg-1
Received: by mail-qk1-f200.google.com with SMTP id p63-20020a374242000000b007468eaf866aso5445848qka.17
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 08:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680623948;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OeMolX1SxNFCB7moKC067zOF/AMbVP1lQf1Wv5j6Xz8=;
        b=Jm4F1i7g8Up2CEbeFrYgLPWP9IkDoKmsgK4qtImrk9ZbDFYltQwWkkjmicsRumTssx
         PstGnvbgArkWO4L8yzR38j0ioqPcmbA9MRLAn14FdOQRY+2LMqma8zl2uxTLLWyGdFLj
         sn/CBh1CP7EkodmU82zNSvrqAGgWbS9vLSqGOMn5mwG2C5vAFtubCWyrGCLzB6BBpP5+
         pLnkrpDEOTCC6iBo0xfKHugdo3J4vT9rGAvgde51wsrhB4KrB+ZtzaXG7lVK1XIrvIRu
         Hqz9OSkcldbAjWoUfBdQDxY6ILmb7a5jMdXndOEg/R60q5WUjhTpB1VsjsQ4Xe5Il+2Q
         QW1g==
X-Gm-Message-State: AAQBX9dUKX5ezPy7iR5Pium3Hr5n0tGt825dM+ddxVf0ihnQYEADXClh
        idhpoutEJk7OfwINpg9vEHQNDr6esX75JDQWrGyi9dE8OOuLX97Ho5hMrvnmr0CNcqTlhpERTn0
        xCTWg1GQDc/nD
X-Received: by 2002:a05:6214:21ef:b0:56b:eef6:6937 with SMTP id p15-20020a05621421ef00b0056beef66937mr3307096qvj.50.1680623948306;
        Tue, 04 Apr 2023 08:59:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350aE1kGETxiNn50t4CqJlkXH0s7kjlbQYgSms4cC9aLymjvrSVD/JeKgl7CVmeUlUbuRytDGDg==
X-Received: by 2002:a05:6214:21ef:b0:56b:eef6:6937 with SMTP id p15-20020a05621421ef00b0056beef66937mr3307074qvj.50.1680623948031;
        Tue, 04 Apr 2023 08:59:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bz16-20020ad44c10000000b005dd8b9345c0sm2073361qvb.88.2023.04.04.08.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 08:59:06 -0700 (PDT)
Message-ID: <5781064c-8742-d37d-57dc-7a7238e948d5@redhat.com>
Date:   Tue, 4 Apr 2023 17:59:01 +0200
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
 <fc87191d-2e79-83c3-b5ba-7f8b1083988a@redhat.com>
 <DS0PR11MB7529441450FE32DC9578C6B8C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <DS0PR11MB7529441450FE32DC9578C6B8C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
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



On 4/4/23 17:29, Liu, Yi L wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: Tuesday, April 4, 2023 11:19 PM
>>
>> Hi Yi,
>>
>> On 4/4/23 16:37, Liu, Yi L wrote:
>>> Hi Eric,
>>>
>>>> From: Eric Auger <eric.auger@redhat.com>
>>>> Sent: Tuesday, April 4, 2023 10:00 PM
>>>>
>>>> Hi YI,
>>>>
>>>> On 4/1/23 16:44, Yi Liu wrote:
>>>>> If the affected device is not opened by any user, it's safe to reset it
>>>>> given it's not in use.
>>>>>
>>>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
>>>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>>>> ---
>>>>>  drivers/vfio/pci/vfio_pci_core.c | 14 +++++++++++---
>>>>>  include/uapi/linux/vfio.h        |  8 ++++++++
>>>>>  2 files changed, 19 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>>>>> index 65bbef562268..5d745c9abf05 100644
>>>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>>> @@ -2429,10 +2429,18 @@ static int vfio_pci_dev_set_hot_reset(struct
>>>> vfio_device_set *dev_set,
>>>>>  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
>>>>>  		/*
>>>>> -		 * Test whether all the affected devices are contained by the
>>>>> -		 * set of groups provided by the user.
>>>>> +		 * Test whether all the affected devices can be reset by the
>>>>> +		 * user.
>>>>> +		 *
>>>>> +		 * Resetting an unused device (not opened) is safe, because
>>>>> +		 * dev_set->lock is held in hot reset path so this device
>>>>> +		 * cannot race being opened by another user simultaneously.
>>>>> +		 *
>>>>> +		 * Otherwise all opened devices in the dev_set must be
>>>>> +		 * contained by the set of groups provided by the user.
>>>>>  		 */
>>>>> -		if (!vfio_dev_in_groups(cur_vma, groups)) {
>>>>> +		if (cur_vma->vdev.open_count &&
>>>>> +		    !vfio_dev_in_groups(cur_vma, groups)) {
>>>>>  			ret = -EINVAL;
>>>>>  			goto err_undo;
>>>>>  		}
>>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>>> index 0552e8dcf0cb..f96e5689cffc 100644
>>>>> --- a/include/uapi/linux/vfio.h
>>>>> +++ b/include/uapi/linux/vfio.h
>>>>> @@ -673,6 +673,14 @@ struct vfio_pci_hot_reset_info {
>>>>>   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
>>>>>   *				    struct vfio_pci_hot_reset)
>>>>>   *
>>>>> + * Userspace requests hot reset for the devices it uses.  Due to the
>>>>> + * underlying topology, multiple devices can be affected in the reset
>>>> by the reset
>>>>> + * while some might be opened by another user.  To avoid interference
>>>> s/interference/hot reset failure?
>>> I don’t think user can really avoid hot reset failure since there may
>>> be new devices plugged into the affected slot. Even user has opened
>> I don't know the legacy wrt that issue but this sounds a serious issue,
>> meaning the reset of an assigned device could impact another device
>> belonging to another group not not owned by the user?
> but the hot reset shall fail as the group is not owned by the user.

sure it shall but I fail to understand if the reset fails or the device
plug is somehow delayed until the reset completes.
>
>>> all the groups/devices reported by VFIO_DEVICE_GET_PCI_HOT_RESET_INFO,
>>> the hot reset can fail if new device is plugged in and has not been
>>> bound to vfio or opened by another user during the window of
>>> _INFO and HOT_RESET.
>> with respect to the latter isn't the dev_set lock held during the hot
>> reset and sufficient to prevent any new opening to occur?
> yes. new open needs to acquire the dev_set lock. So when hot reset
> acquires the dev_set lock, then no new open can occur. 
>
> Regards,
> Yi Liu
>
>>> maybe the whole statement should be as below:
>>>
>>> To avoid interference, the hot reset can only be conducted when all
>>> the affected devices are either opened by the calling user or not
>>> opened yet at the moment of the hot reset attempt.
>> OK
>>
>> Eric
>>>>> + * the calling user must ensure all affected devices, if opened, are
>>>>> + * owned by itself.
>>>>> + *
>>>>> + * The ownership is proved by an array of group fds.
>>>>> + *
>>>>>   * Return: 0 on success, -errno on failure.
>>>>>   */
>>>>>  struct vfio_pci_hot_reset {
>>> Regards,
>>> Yi Liu

