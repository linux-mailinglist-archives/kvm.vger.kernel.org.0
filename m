Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35B768A124
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 19:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbjBCSEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 13:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBCSEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 13:04:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796B81554E
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 10:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675447438;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8KsgSK8Okdkgqu/pylo49YSVsl161ef+KFwE9qE+scc=;
        b=b/ZUYOUIXjK1Fy7wvsnkpVPR+v65i3yDiB6qZdNObV2zQMkormupLy4uhP9c1lIi/Qrmhw
        Xe5UHFM5UA9ne2nILWy6+6GPv/BZWGRT/avRsktxP2KkECCPrlVMdqOSubyGvwUdk+FUh8
        YSwjpISApC3qhLRNdq7h2JVSW9lgTcA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-599-nmHNofN9MW68YDlvIILsSw-1; Fri, 03 Feb 2023 13:03:57 -0500
X-MC-Unique: nmHNofN9MW68YDlvIILsSw-1
Received: by mail-qk1-f198.google.com with SMTP id u11-20020a05620a430b00b007052a66d201so3770792qko.23
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 10:03:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8KsgSK8Okdkgqu/pylo49YSVsl161ef+KFwE9qE+scc=;
        b=JPQmSyqGJh35wC3OERyZXIa7FWf44nTX/ErY1TTCsl5FCWqKEVE5Tnp9mupIz7XDx1
         +8S/mk7kmz/A7CklgJNXClFW5s98eQPSgGFbksQp6Cg+gh5RTYLUmkaL+tA/DxA6gNy3
         BT9J41sGhXFs884/qORi1AoIktavo/5FVNTYCbFrc+d88SiPa5jHw/yeW+gwOtf4CO6K
         UDeZl82ycyGwxdCvWie97zLG4+cs0EK1SpI3wTnRiFMFnPo8TuaEWhEiVWnkAws2xRTM
         GKI5bRWFpimi20haXs6/UF9xLKZFpjLJ/3fk712zsoZ0tk5nPxZuewQAl8OrN6cxacSA
         iKEA==
X-Gm-Message-State: AO0yUKVyR5gZ7YPsOX3/ByIXjfQwz/ZOkSNqp6YDF24BsKS0yFhk/XtC
        0MdowqQZdgsqa3FMe7D+yZQmsIykspNjgpw/igZebMM/y5PIYVIyIV6M9WsCwyzsH4Z1HJQg5WH
        6dgqRxrGUGQ8V
X-Received: by 2002:a05:622a:1047:b0:3b8:6ae9:b100 with SMTP id f7-20020a05622a104700b003b86ae9b100mr21011467qte.7.1675447436936;
        Fri, 03 Feb 2023 10:03:56 -0800 (PST)
X-Google-Smtp-Source: AK7set9Go1OnlalGty2/hqPRFSwNpTDV9MXDTM7zhF4ynViVl1Ds1n2q2n7vezvQk9M2j534qtGuTg==
X-Received: by 2002:a05:622a:1047:b0:3b8:6ae9:b100 with SMTP id f7-20020a05622a104700b003b86ae9b100mr21011421qte.7.1675447436604;
        Fri, 03 Feb 2023 10:03:56 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h13-20020ac8714d000000b003b9dca4cdf4sm1939793qtp.83.2023.02.03.10.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 10:03:55 -0800 (PST)
Message-ID: <fc6271e1-ee1e-41d5-0710-007f780e653b@redhat.com>
Date:   Fri, 3 Feb 2023 19:03:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v3 00/18] vfio: Adopt iommufd
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
 <Y90EvdM0CZlr51ug@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Y90EvdM0CZlr51ug@nvidia.com>
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



On 2/3/23 13:57, Jason Gunthorpe wrote:
> On Tue, Jan 31, 2023 at 09:52:47PM +0100, Eric Auger wrote:
>> Given some iommufd kernel limitations, the iommufd backend is
>> not yuet fully on par with the legacy backend w.r.t. features like:
>> - p2p mappings (you will see related error traces)
>> - coherency tracking
> You said this was a qemu side limitation?
yes that's correct. This comment will be removed.
>
>> - live migration
> The vfio kernel interfaces are deprecated,  Avihai's series here adds
> live migration support:
>
> https://lore.kernel.org/qemu-devel/20230126184948.10478-1-avihaih@nvidia.com/
>
> And there will be another series for iommufd system iommu based live
> migration

OK thanks for the pointer.
>
>> - vfio pci device hot reset
> What is needed here?

we need to revisit the vfio_pci_hot_reset() implementation in hw/vfio/pci.c
It uses VFIO_DEVICE_GET_PCI_HOT_RESET_INFO and VFIO_DEVICE_PCI_HOT_RESET
uapis
which retrieves/passes the list of iommu groups involved in the reset.
The notion of group had initially disappeared from the the iommufd BE
but I am afraid that's not that simple.

Thanks

Eric
>
> Jason
>

