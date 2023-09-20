Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE367A79FB
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 13:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbjITLFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 07:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbjITLFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 07:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A35D9E
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 04:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695207892;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahtJkwToX+gB0wPcAKOa7MVDuR+PCwMr7nVDiRruhNI=;
        b=NUn+t1jSQST3GaeG/06BNKrf0JgGh5MTut5+FhlU/ewmG23Oa3gBAm7uSXvrTwlsmcI0qn
        NrdHnIIE0mytIDg+u82mAFzdQmDkA48TuVnDWcTx66UhDW7EuSTs5/sDOeBtwGlsvtcvJ6
        Ly0yCwhFMk48ZouF10veEK2YnpFJ4Aw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-eaIZR8izO0ivNZ313-sjWA-1; Wed, 20 Sep 2023 07:04:51 -0400
X-MC-Unique: eaIZR8izO0ivNZ313-sjWA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-31dc8f0733dso4324884f8f.3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 04:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695207890; x=1695812690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ahtJkwToX+gB0wPcAKOa7MVDuR+PCwMr7nVDiRruhNI=;
        b=ip1ooqbTPOKHlFEJbCac6t/TYTgV+Yk+4Xxmh9kdL7Bc46kf83/ws5TqN0ES+0V//M
         6PH0hPKlNZhH7CRtE4HvuQ4d++PpzynDp872d/+0ILNazwZQtfYsTPZt68Y+3zowF/2o
         Mxfzkz6/77LGswTkJOuoswSXIObehLi8eyv/0yW3mfMELHi9OmNA5Ig3opkyZmK0vpb8
         dD6IrSySiKf+tZFaAF11DglSDv/HFhUcLHT6kgOZblWqRskum7o4URjViC6pIDbR6e4w
         1IoXAudhtgUSJes/YMdx7Oc/cLF+z6TTQrbokzJI1knlLbMyug2MoiWfXCAUAh7yLVHP
         9nww==
X-Gm-Message-State: AOJu0YzHWJhuWFdfJktqM1G6LhdXmBZPuO4FvKprURbHfqshgPAUkvFg
        S8dc45wDRyl9VChzM7PX6c2dIgbL3KMee0sW6f4yjeUbLeUuzGQWiGO8vrk8RBSnQAR0gmnUZ28
        GqWELsIfFGtRO
X-Received: by 2002:a5d:60c5:0:b0:31f:a16a:aecd with SMTP id x5-20020a5d60c5000000b0031fa16aaecdmr1850207wrt.68.1695207890182;
        Wed, 20 Sep 2023 04:04:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmr6nhjKgmEx0i5kOODCEXzANRvBEgJrn3HC07NT0/VXCXCr35gI8CixJIPA297KRi7x86Xg==
X-Received: by 2002:a5d:60c5:0:b0:31f:a16a:aecd with SMTP id x5-20020a5d60c5000000b0031fa16aaecdmr1850186wrt.68.1695207889833;
        Wed, 20 Sep 2023 04:04:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t8-20020a5d42c8000000b00317a04131c5sm11313590wrr.57.2023.09.20.04.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 04:04:48 -0700 (PDT)
Message-ID: <d191634a-1734-f446-8b7e-affe4ec195f4@redhat.com>
Date:   Wed, 20 Sep 2023 13:04:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v1 02/22] Update linux-header to support iommufd cdev and
 hwpt alloc
Content-Language: en-US
To:     "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "clg@redhat.com" <clg@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20230830103754.36461-1-zhenzhong.duan@intel.com>
 <20230830103754.36461-3-zhenzhong.duan@intel.com>
 <c2fb72a1-2e83-d266-c428-72dcfcd95a75@redhat.com>
 <SJ0PR11MB6744FE3F0DBD0E5A69EC37FF92F6A@SJ0PR11MB6744.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <SJ0PR11MB6744FE3F0DBD0E5A69EC37FF92F6A@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/15/23 05:02, Duan, Zhenzhong wrote:
> Hi Eric,
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: Thursday, September 14, 2023 10:46 PM
>> Subject: Re: [PATCH v1 02/22] Update linux-header to support iommufd cdev and
>> hwpt alloc
>>
>> Hi Zhenzhong,
>>
>> On 8/30/23 12:37, Zhenzhong Duan wrote:
>>> From https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git
>>> branch: for_next
>>> commit id: eb501c2d96cfce6b42528e8321ea085ec605e790
>> I see that in your branch you have now updated against v6.6-rc1. However
>> you should run a full ./scripts/update-linux-headers.sh,
>> ie. not only importing the changes in linux-headers/linux/iommufd.h as
>> it seems to do but also import all changes brought with this linux version.
> Found reason. The base is already against v6.6-rc1, [PATCH v1 01/22] added
> Iommufd.h into script and this patch added it.
> I agree the subject is confusing, need to be like "Update iommufd.h to linux-header"
> I'll fix the subject in next version, thanks for point out.

OK I see
da3c22c74a3c  linux-headers: Update to Linux v6.6-rc1 (8 days ago)
<Thomas Huth>
now. So you need to add the sha1 against which you ran
./scripts/update-linux-headers.sh and in that case you can precise that
given [PATCH v1 01/22] scripts/update-linux-headers: Add iommufd.h added
iommufd export and given Thomas' patch, only
iommufd.h is added.

Thanks

Eric
>
> BR.
> Zhenzhong
>

