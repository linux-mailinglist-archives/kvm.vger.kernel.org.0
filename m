Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859F450479A
	for <lists+kvm@lfdr.de>; Sun, 17 Apr 2022 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiDQKd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Apr 2022 06:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiDQKdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Apr 2022 06:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 188D536167
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 03:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650191449;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PHbbU62HAo+2yn1QoC2sAt1GJpPAVVxoGsvADElQIEc=;
        b=CT/435o8DDm00mHHEve5qXzqfRS691lfAYn5wEc5yFA05uo7uTlKdL0bH9lGW/zOqZOPHE
        9/iFck/li1o2N5WgmDLsQTGVqb5maJJBhQ7MYfMHMOSGA0kyNHp+nQNMS+sNoZJ4GmFBGV
        CBvU6Z38c57boc0GvPVJ020sBas2J2U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-Z5DrtzGSO3u2NsXOEZYsUw-1; Sun, 17 Apr 2022 06:30:48 -0400
X-MC-Unique: Z5DrtzGSO3u2NsXOEZYsUw-1
Received: by mail-wm1-f70.google.com with SMTP id p21-20020a1c5455000000b0038ff4f1014fso3435393wmi.7
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 03:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=PHbbU62HAo+2yn1QoC2sAt1GJpPAVVxoGsvADElQIEc=;
        b=dkvvPdpxEjkVK+pa+UHfv5Ml7Z7uj01w2FN6yIoZgaoI274wMpfPdCQj3Ar8s5Iwyz
         regikMnZrdep7yA5mENSqf2DCqxrix2ijyTTOFZfPjcbxXo+mFMP9UX07nCT+nORrzw8
         +N8FeypLOr9ySWgWyDaITL8NMi1V/HegO2aRyzPBacmkztzmkEPwfrgiogJpV6AVMbHA
         kX2+cr+d7359NwMpgKlQ7JGxlLiu2ZjmYw9Q5fwAvtRS7XjvXLgRkCR5la+wT3dIbhfA
         hAymZbwV0XCActypvLO0QL862c/Gr+4vT5U49wy5DOGMwDY0F3LAvy7NYk+/JHvlUXHM
         pi4g==
X-Gm-Message-State: AOAM5307it1NhMlyH08tb4cz0GmgwW9nsB1niGEs1mwO7Xeeh9T40QZR
        WyjKfgOKTmXRhFCo2gBzdF00QyORzYoN2S9klMuJBwYyMuBvV8XDy+8U77AztZ+ebxdNjguzCmV
        YHht1VmH71tzA
X-Received: by 2002:adf:90e9:0:b0:204:2ee:7d5 with SMTP id i96-20020adf90e9000000b0020402ee07d5mr4979502wri.536.1650191444799;
        Sun, 17 Apr 2022 03:30:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOgepzP0Qhj28I9+rO7u9OMUqOzXLmpTBzQujGVxXvsSse5itwwDWFec5f51/YFzPF3NP6sQ==
X-Received: by 2002:adf:90e9:0:b0:204:2ee:7d5 with SMTP id i96-20020adf90e9000000b0020402ee07d5mr4979488wri.536.1650191444545;
        Sun, 17 Apr 2022 03:30:44 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q16-20020adff950000000b00205aa05fa03sm7776205wrr.58.2022.04.17.03.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 03:30:43 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
To:     Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        thuth@redhat.com, farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <Ylku1VVsbYiAEALZ@Asurada-Nvidia>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <16ea3601-a3dd-ba9b-a5bc-420f4ac20611@redhat.com>
Date:   Sun, 17 Apr 2022 12:30:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Ylku1VVsbYiAEALZ@Asurada-Nvidia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nicolin,

On 4/15/22 10:37 AM, Nicolin Chen wrote:
> Hi,
>
> Thanks for the work!
>
> On Thu, Apr 14, 2022 at 03:46:52AM -0700, Yi Liu wrote:
>  
>> - More tests
> I did a quick test on my ARM64 platform, using "iommu=smmuv3"
> string. The behaviors are different between using default and
> using legacy "iommufd=off".
>
> The legacy pathway exits the VM with:
>     vfio 0002:01:00.0:
>     failed to setup container for group 1:
>     memory listener initialization failed:
>     Region smmuv3-iommu-memory-region-16-0:
>     device 00.02.0 requires iommu MAP notifier which is not currently supported
>
> while the iommufd pathway started the VM but reported errors
> from host kernel about address translation failures, probably
> because of accessing unmapped addresses.
>
> I found iommufd pathway also calls error_propagate_prepend()
> to add to errp for not supporting IOMMU_NOTIFIER_MAP, but it
> doesn't get a chance to print errp out. Perhaps there should
> be a final error check somewhere to exit?

thank you for giving it a try.

vsmmuv3 + vfio is not supported as we miss the HW nested stage support
and SMMU does not support cache mode. If you want to test viommu on ARM
you shall test virtio-iommu+vfio. This should work but this is not yet
tested.

I pushed a fix for the error notification issue:
qemu-for-5.17-rc6-vm-rfcv2-rc0 on my git https://github.com/eauger/qemu.git

Thanks

Eric
>
> Nic
>

