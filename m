Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2E873BB1A
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 17:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjFWPIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 11:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbjFWPIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 11:08:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0DE19B
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 08:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687532866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PIj9TpY/vUG69vHRfBGHuyDPvaqSQMBDxHTno+lgUQ=;
        b=JNS6K2tkd1qIbNh2xvooKOymfxRiHIeCI+z5jNpmLdjOsp/Ny7841hV1CLopD5infjytdy
        Mh4W0xVYBFsZzUygkZ/qu8fCwt4bFclx6kpFZ7DbRu02CQX8F7MVJ+BK5W3ciJO9ac/3E5
        Xck2pabYczyN05P9z3fbcSDTsPHrVLg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-JCcZZKPmPvGQ8g566RPnow-1; Fri, 23 Jun 2023 11:07:44 -0400
X-MC-Unique: JCcZZKPmPvGQ8g566RPnow-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fa72092f95so4232435e9.1
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 08:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687532859; x=1690124859;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9PIj9TpY/vUG69vHRfBGHuyDPvaqSQMBDxHTno+lgUQ=;
        b=Hfbu5rq2atvr3YdUcDsLQQVxSvxGwqmwPM4W9sGqZ1BMk8NB/TFkwLnbovWR7JM0Wc
         8ad1KZKfq4DnzdmIBTxQ0Oi9lAkxlNv3eHTXmLbjaZv2wBQ8TIRs7IIzS4nNnHApXi3B
         KlPNS+u8NXg26pQ6hjgvsc1Sch7Y5PMqyhPO6CinwAuuZkuIusT59sBbXTRW4ZKMGObV
         6dVHuy2Pd4EOjftUo1QMPMbCs3DvxO7MDPinOj7bvnUcjzBkkICfxVmFGcWKX5WWjZBX
         zLVgq8uwWN3kwJEgoQlP3Y7doqS3qLCYKVbocCHIhbbLkrHIWxPCIuknxeU6AsffR5RQ
         3Pcg==
X-Gm-Message-State: AC+VfDxse3ln8Rj5DBZmwuYsr/nT04M2o6Kd7hsG5MWA3O9HGrv+V3yO
        H9PtqH81b1HvU1ILCnW3HLGV6saGsfb424OCsD3xmzD9q7zYVp/gzgjNfgrKDkTiTJzLsBSDpt0
        +5+6f3IEc4ZGR
X-Received: by 2002:a05:600c:d8:b0:3f9:c9f4:acf1 with SMTP id u24-20020a05600c00d800b003f9c9f4acf1mr6588437wmm.7.1687532859076;
        Fri, 23 Jun 2023 08:07:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6WXIbrUL9JSjkw/UFxJT6YFthXdXUKVwIUcrfrH+yxajncKJhmhAgmQRL80+Hfyqowot7zFQ==
X-Received: by 2002:a05:600c:d8:b0:3f9:c9f4:acf1 with SMTP id u24-20020a05600c00d800b003f9c9f4acf1mr6588413wmm.7.1687532858781;
        Fri, 23 Jun 2023 08:07:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id l19-20020a1c7913000000b003f8d0308616sm2570438wme.32.2023.06.23.08.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 08:07:38 -0700 (PDT)
Message-ID: <4b0f4def-e2bd-b7b2-7c70-1df741780e1c@redhat.com>
Date:   Fri, 23 Jun 2023 17:07:37 +0200
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
 <62dcff6b-852d-4a85-dfd4-0ce1f324602e@redhat.com>
 <ZJWZA8ogUlGegx2C@nvidia.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <ZJWZA8ogUlGegx2C@nvidia.com>
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

On 6/23/23 15:07, Jason Gunthorpe wrote:
> On Fri, Jun 23, 2023 at 03:04:17PM +0200, Cédric Le Goater wrote:
>> On 6/23/23 13:47, Jason Gunthorpe wrote:
>>> On Fri, Jun 23, 2023 at 08:27:17AM +0200, Cédric Le Goater wrote:
>>>>> +	req_len = vma->vm_end - vma->vm_start;
>>>>> +	pgoff = vma->vm_pgoff &
>>>>> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>>>>> +	if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
>>>>> +		return -EINVAL;
>>>>
>>>> you cound introduce accessor macros for nvdev->mem_prop.mem_length and
>>>> nvdev->mem_prop.hpa
>>>
>>> Accessors are not the usual style..
>>
>> I meant something like
>>
>>    #define nvgpu_mem_size(nvdev) (nvdev)->mem_prop.mem_length
>>    #define nvgpu_mem_pa_base(nvdev) (nvdev)->mem_prop.hpa
>>
>> This is minor.
> 
> Yeah, this is what I thought you ment, I'm against this kind of
> obfuscation in the kernel without a very strong purpose, and if you do
> something like this it should be a static inline function.

OK. We could drop the intermediate struct attribute instead then.

Thanks,

C.

