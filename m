Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355A273B85D
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 15:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjFWNFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 09:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjFWNFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 09:05:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5AE1FFD
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 06:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687525464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E6jWWQrwh2hHtedtzxrNhDIjAs17Rbx7BLQgx2TQ9mc=;
        b=VhZz1g8DoUztheVJkyNwStMKpOScXwxCOunKXpFdTEza69jAgKNd+kRUNN6fxCrYmcrasQ
        PExjbhuIt/zVEYUDaGSWcsf2UAoFlFQHblJtl8Y/Ev9jgO4hfuLX3uZdA5uhsZEO5X0PEA
        d3z6kYsoSwtLpnm9EZ7xM0+KHwDdIog=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-J4nWqOwxP2ybKvfFOjeMhQ-1; Fri, 23 Jun 2023 09:04:22 -0400
X-MC-Unique: J4nWqOwxP2ybKvfFOjeMhQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-763a3e3e760so74655985a.0
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 06:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687525461; x=1690117461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E6jWWQrwh2hHtedtzxrNhDIjAs17Rbx7BLQgx2TQ9mc=;
        b=G/05gPvvnDjV7jM3YZzQeqEZdj/5RudLq7uWigVIZYJKz+uZ5dwjK2w7NpKBuRa7qB
         MrEMugT58MAJ7tYpkHfHNZfveLDU77rsCbuarZWyLzTN7H9Zb6gQ7PHWQutB44J6saJk
         dhHdexhO73+2x3CkUi8YUrhBVNJiHyUCEOJYwDKbgN4EUtI80qOcxXzrQZMVk4WY0jqM
         kj45JnoBdYH+nBWfvmpB+NQbx7S8q+uzFBPU2UtG50w1ViIt9xDBvEE0O1kog7jb9jfq
         Iq2TYVIyWKlLZIfxp5bmP+T2/sZtmiEnPEmIXmaO8HnQ0DYbHsPNVPOORxGHVpSu20N+
         tNDw==
X-Gm-Message-State: AC+VfDwgvz3spfSdBOlmHvHwBZ7umewp0fZQWPHoBmbbd6U8HwRMnaeq
        csXfWXnqdW+qNiU9i4O1sY0WmB+PGS/EkVQFfVYvv0be5qR+Kv/dvcLGHU4oUY/HrlZtjEkMENa
        sazMH0UOiYf8Z
X-Received: by 2002:a05:620a:2a12:b0:765:4855:26db with SMTP id o18-20020a05620a2a1200b00765485526dbmr2333881qkp.10.1687525461490;
        Fri, 23 Jun 2023 06:04:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4fITNun0HWeriRaUUuh7u2rwGbcPWH3qyy+c0xKPKWKIGejgArsHRo+XF3UWsOU0qXZUi25Q==
X-Received: by 2002:a05:620a:2a12:b0:765:4855:26db with SMTP id o18-20020a05620a2a1200b00765485526dbmr2333855qkp.10.1687525461253;
        Fri, 23 Jun 2023 06:04:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id bs14-20020ac86f0e000000b003f6b58b986fsm36489qtb.41.2023.06.23.06.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 06:04:20 -0700 (PDT)
Message-ID: <62dcff6b-852d-4a85-dfd4-0ce1f324602e@redhat.com>
Date:   Fri, 23 Jun 2023 15:04:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, alex.williamson@redhat.com, aniketa@nvidia.com,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
        jhubbard@nvidia.com, danw@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230622030720.19652-1-ankita@nvidia.com>
 <46a79333-12f6-229f-86f9-1e79bdba7d11@redhat.com>
 <ZJWGbsaMzHvqqewi@nvidia.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <ZJWGbsaMzHvqqewi@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/23 13:47, Jason Gunthorpe wrote:
> On Fri, Jun 23, 2023 at 08:27:17AM +0200, Cédric Le Goater wrote:
>>> +	req_len = vma->vm_end - vma->vm_start;
>>> +	pgoff = vma->vm_pgoff &
>>> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>>> +	if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
>>> +		return -EINVAL;
>>
>> you cound introduce accessor macros for nvdev->mem_prop.mem_length and
>> nvdev->mem_prop.hpa
> 
> Accessors are not the usual style..

I meant something like

   #define nvgpu_mem_size(nvdev) (nvdev)->mem_prop.mem_length
   #define nvgpu_mem_pa_base(nvdev) (nvdev)->mem_prop.hpa

This is minor.

> 
>>> +static const struct pci_device_id nvgpu_vfio_pci_table[] = {
>>> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
>>> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2343) },
>>> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
>>
>> It would be good to add definitions for the PCI IDs.
> 
> The common form these days is to have a comment with the marketing
> name, we stopped putting constants for every device a while ago.

OK then.

Thanks,

C.

