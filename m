Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB3A6DAA81
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 10:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbjDGI5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 04:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240136AbjDGI5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 04:57:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D8749C3
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 01:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680857809;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zm0x3qIRJGoq5IUNwNsG2TAdBWo5E6P2pw0Wr6/J6xU=;
        b=gygHWpzhklOzFnKD2IAqbEvcPu/wmXcsY6RjNw7KZ6n1TKSbjkVM01qLU5eubMXzPsgrVz
        T1ykgFfAFMeIjuVQ61g0J+68oBB7IiMpdKFOv/e1ylpzYo1pClEuVrTWteiNh1GecCeNhx
        iB1sQqaxoIFOCgxc9Jbh3PaQHwD7cMs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-_vrxDPoIMTmnOV0wezQbqA-1; Fri, 07 Apr 2023 04:56:47 -0400
X-MC-Unique: _vrxDPoIMTmnOV0wezQbqA-1
Received: by mail-wm1-f72.google.com with SMTP id n19-20020a05600c3b9300b003ef63ef4519so17956717wms.3
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 01:56:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680857806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zm0x3qIRJGoq5IUNwNsG2TAdBWo5E6P2pw0Wr6/J6xU=;
        b=0OvY+3EYk8791bCSvQeWPwjkJsESpCSSSIKnpU0wmWzyZIPeXy2Q/5WvgXrN6doEav
         g5ONJuXSTdx7jg9VT24vSTqXt7rfh0jVCM2OhNTMos2pGY47N7l1NnnvQujL+z7VpViZ
         v3mpnsXRjZxkxeDrzBehAfkisDG5au3cKu53ILZ7xJFBd8OlRxYGhUfQctD43wh29HJ1
         ijrVHHW+/pec7cZed1xID+TS+aWrjL6uKKKe64T7VYljP7siDEHeqVEN2MwrbEuTcPNz
         grbAoNY37qKgWkQAo1Q1Kkr0Md9ptXKlcnPJ+MS9cqGjJgiTTYcPE8EGe24n3DihhziS
         /s/Q==
X-Gm-Message-State: AAQBX9c3tdgAcNHBFePaQiH198LxqsVNfKoFaFfb4+G6Bd16e+4HIrKo
        o3UhAeR5ANmhuluzoaZf9FdxauTvqOG76Y66bZVNpWwlY57oi7uS5zC4N1GgqyNwh6I92goQ+eR
        ibARx/PUeMxlT
X-Received: by 2002:a05:600c:4f45:b0:3ee:93d2:c915 with SMTP id m5-20020a05600c4f4500b003ee93d2c915mr915232wmq.6.1680857806779;
        Fri, 07 Apr 2023 01:56:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350bKstcvpy21T/+Sur+wGdRQ6MZEvGuCCMZJzNceYWbo9B1mTkijQltP94h5JEaS1eDfNwFqwg==
X-Received: by 2002:a05:600c:4f45:b0:3ee:93d2:c915 with SMTP id m5-20020a05600c4f4500b003ee93d2c915mr915208wmq.6.1680857806468;
        Fri, 07 Apr 2023 01:56:46 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t6-20020a05600c450600b003ee2a0d49dbsm7785542wmo.25.2023.04.07.01.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 01:56:45 -0700 (PDT)
Message-ID: <5f8d9e23-8a4c-3f97-8f22-01eaa4eddfbb@redhat.com>
Date:   Fri, 7 Apr 2023 10:56:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 06/25] kvm/vfio: Accept vfio device file from userspace
Content-Language: en-US
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-7-yi.l.liu@intel.com>
 <8fb5a0b3-39c6-e924-847d-6545fcc44c08@redhat.com>
 <DS0PR11MB7529B8DC835A6EADDB815C04C3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406125730.55bfa666.alex.williamson@redhat.com>
 <DS0PR11MB752903283C1E02708EC13848C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <DS0PR11MB752903283C1E02708EC13848C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/7/23 05:42, Liu, Yi L wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Friday, April 7, 2023 2:58 AM
>>>> You don't say anything about potential restriction, ie. what if the user calls
>>>> KVM_DEV_VFIO_FILE with device fds while it has been using legacy
>> container/group
>>>> API?
>>> legacy container/group path cannot do it as the below enhancement.
>>> User needs to call KVM_DEV_VFIO_FILE before open devices, so this
>>> should happen before _GET_DEVICE_FD. So the legacy path can never
>>> pass device fds in KVM_DEV_VFIO_FILE.
>>>
>>>
>> https://lore.kernel.org/kvm/20230327102059.333d6976.alex.williamson@redhat.com
>> /#t
>>
>> Wait, are you suggesting that a comment in the documentation suggesting
>> a usage policy somehow provides enforcement of that ordering??  That's
>> not how this works.  Thanks,
> I don't know if there is a good way to enforce this order in the code. The
> vfio_device->kvm pointer is optional. If it is NULL, vfio just ignores it.
> So vfio doesn't have a good way to tell if the order requirement is met or
> not. Perhaps just trigger NULL pointer dereference when kvm pointer is used
> in the device drivers like kvmgt if this order is not met.
>
> So that's why I come up to document it here. The applications uses kvm
> should know this and follow this otherwise it may encounter error.
>
> Do you have other suggestions for it? This order should be a generic
> requirement. is it? group path also needs to follow it to make the mdev
> driver that refers kvm pointer to be workable.

In the same way as kvm_vfio_file_is_valid() called in kvm_vfio_file_add()
can't you have a kernel API that checks the fd consistence?

Thanks

Eric
>
> Thanks,
> Yi Liu
>
>>>>> -The GROUP_ADD operation above should be invoked prior to accessing the
>>>>> +The FILE/GROUP_ADD operation above should be invoked prior to accessing the
>>>>>  device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
>>>>>  drivers which require a kvm pointer to be set in their .open_device()
>>>>> -callback.
>>>>> +callback.  It is the same for device file descriptor via character device
>>>>> +open which gets device access via VFIO_DEVICE_BIND_IOMMUFD.  For such file
>>>>> +descriptors, FILE_ADD should be invoked before
>> VFIO_DEVICE_BIND_IOMMUFD
>>>>> +to support the drivers mentioned in prior sentence as well.
>>> just as here. This means device fds can only be passed with KVM_DEV_VFIO_FILE
>>> in the cdev path.
>>>
>>> Regards,
>>> Yi Liu

