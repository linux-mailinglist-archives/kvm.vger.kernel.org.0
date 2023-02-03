Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9359D68A106
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 18:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjBCR6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 12:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbjBCR56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 12:57:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6B71EFDC
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 09:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675447030;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/L3xQge9a5Ec5fO+C6nReyrV0+o9EA7agOtUfXx62n8=;
        b=DWfp/yDnfV9c8Dd2DlgsoqWGxdgwqoawBb8IoazDJJAqYLvsBCiSDbyLIqMVBD9qk/ymX7
        +kthXXOsFwXYr5cvJI/EACMw2+96FtQ9OFktjqliObTazoYGbkrPrHyGCNrkZ+iAfoufu8
        grxLgSLnvlu534wqgTSnje4mMIMR06g=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-CpYWISSCOUS6mEFa4Ozj4w-1; Fri, 03 Feb 2023 12:57:09 -0500
X-MC-Unique: CpYWISSCOUS6mEFa4Ozj4w-1
Received: by mail-qv1-f69.google.com with SMTP id jh2-20020a0562141fc200b004c74bbb0affso3154219qvb.21
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 09:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/L3xQge9a5Ec5fO+C6nReyrV0+o9EA7agOtUfXx62n8=;
        b=7fpzNCpl4OOm5iKJz3rTcic/NiaJ66zVeDNyrOM8Fa40QZmymaHW4f6nSxNt4JKPM9
         1uOp6muHtSjgJusdRnZdShLR+IDGk4of8wA2QCyHoHUFC2PBcpOLJAA3Be6S2U7OUwfu
         shkaWCV4f08TAdCJX49p+M9Rih3ooIEAkfd+PyRhgGfjEpIa8tiGgVsip0MKE4ue/xGa
         6q1SeeQXHGuEQ8TkOs6+IHOZlW1KWQOSEWEFpvc7v46wDlooBuHBGIPDas7EKvcCEdNL
         D9dDGjO1t/zN2JILHnFYR4XqES1IQYtthf3MayAQoYsv1aOpoEWFZlVBLnDItHsuJDqo
         L+Aw==
X-Gm-Message-State: AO0yUKW8PusYMhPI2qzbn/ubI9EcFkwJM3L2ivP95DjSJtSIjYdeCFrf
        pO575FC7DkvangIw8ai40HuB461+xoNYnjNQy76+HJvOlNx6CQQK6dx9Z4kkkL358mChk0Qg8qS
        5BK07amdJ3mIg
X-Received: by 2002:a05:622a:2d6:b0:3b8:6c5f:4ac0 with SMTP id a22-20020a05622a02d600b003b86c5f4ac0mr20731464qtx.46.1675447029141;
        Fri, 03 Feb 2023 09:57:09 -0800 (PST)
X-Google-Smtp-Source: AK7set8EbAbc95VhGloJFwOZ2JnsXI2vvSEEJYVu9nj0HJw+CT9jxjv+niBcOkgAGfnaC+brvV015A==
X-Received: by 2002:a05:622a:2d6:b0:3b8:6c5f:4ac0 with SMTP id a22-20020a05622a02d600b003b86c5f4ac0mr20731433qtx.46.1675447028891;
        Fri, 03 Feb 2023 09:57:08 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p1-20020ac84081000000b003a530a32f67sm1917010qtl.65.2023.02.03.09.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 09:57:07 -0800 (PST)
Message-ID: <3ddad294-69f7-3067-1420-e1438cf017cb@redhat.com>
Date:   Fri, 3 Feb 2023 18:57:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v3 18/18] vfio/as: Allow the selection of a given iommu
 backend
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     eric.auger.pro@gmail.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        alex.williamson@redhat.com, clg@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, nicolinc@nvidia.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <20230131205305.2726330-19-eric.auger@redhat.com>
 <Y90DOL2pnYxHHNzL@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Y90DOL2pnYxHHNzL@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2/3/23 13:51, Jason Gunthorpe wrote:
> On Tue, Jan 31, 2023 at 09:53:05PM +0100, Eric Auger wrote:
>> Now we support two types of iommu backends, let's add the capability
>> to select one of them. This depends on whether an iommufd object has
>> been linked with the vfio-pci device:
>>
>> if the user wants to use the legacy backend, it shall not
>> link the vfio-pci device with any iommufd object:
>>
>> -device vfio-pci,host=0000:02:00.0
>>
>> This is called the legacy mode/backend.
>>
>> If the user wants to use the iommufd backend (/dev/iommu) it
>> shall pass an iommufd object id in the vfio-pci device options:
>>
>>  -object iommufd,id=iommufd0
>>  -device vfio-pci,host=0000:02:00.0,iommufd=iommufd0
>>
>> Note the /dev/iommu device may have been pre-opened by a
>> management tool such as libvirt. This mode is no more considered
>> for the legacy backend. So let's remove the "TODO" comment.
> The vfio cdev should also be pre-openable like iommufd?

where does the requirement come from?

Thanks

Eric
>
> Jason
>

