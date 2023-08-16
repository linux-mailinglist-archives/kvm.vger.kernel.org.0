Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E610C77DB54
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242456AbjHPHod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242439AbjHPHo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:44:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E291BFE
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 00:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692171824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UpE1Wk6RtuDhxL6BBbhMSsceHjp56cBYmdiTeUYHIMA=;
        b=dsJJ19GFtJyYrPANtmjUeTL2rChQA3Qf6SeqAuGiPeVTw2PTtLi8194uRYSZ44gLvOJCqF
        wn9QtsRVbQRsO9e7hL+E5A8r2CI93ySqp7I+Ky0D7EDV/5VnVWkdysSgEu0YO1qiUv+8Wm
        S/N0cJFEH5E1V+qxwEfpZx+yfT0cyiI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-DJToJuzZPyGACzZ8MR7-nQ-1; Wed, 16 Aug 2023 03:43:43 -0400
X-MC-Unique: DJToJuzZPyGACzZ8MR7-nQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-317d5b38194so2861292f8f.0
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 00:43:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692171822; x=1692776622;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UpE1Wk6RtuDhxL6BBbhMSsceHjp56cBYmdiTeUYHIMA=;
        b=Zsd4ES3/aeS2x6GV2DF2usvIaqw8x9Eh4TW8myHhxeHMGrceV0fBv0Sn8+YcYgUnvo
         16RnE9rCSt6Ru8ie/fo8v5a5wi3dngyLRalccuN/pCt2cSjXlsJYZ4FE5TiPAZUeWbFd
         9u/vSJSVOXCPf8kkwSWqKO0CcjjcdD5a1QvAMqA3DmZmJHU2X2I7CEWCNuSPpll396vH
         5/sCW1Me0HkSNJv5WTKJcdjfRw0+uSYgMN8woT9AYv0C1EQEqF84660HIFGJhaTxbPdu
         jKzet94zAufIYlBqgQB2rvnGJE5HcyatLlOTg4Mf1fUosMNJov5P5BFZeehA6PEDXta9
         ZbTg==
X-Gm-Message-State: AOJu0YxmLHPAouhKv+Y25oXCIyjuJwW3XCNbOxwJHCr1zPWXX6DW/boQ
        fqskdQVBdpY+PfgNCL7jkTiMv1J55VfHCK97M1mxQrMREl4/vxpH+emtw5xIkEvQLIlucWy2Gjj
        x5WxYR5YaQ+0P
X-Received: by 2002:adf:e749:0:b0:316:f4b9:a952 with SMTP id c9-20020adfe749000000b00316f4b9a952mr2948470wrn.31.1692171822264;
        Wed, 16 Aug 2023 00:43:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoxs2uyCX8yiPq64wznfoV64WTc9z+A6YDeGesjPO6fW3H11bdDvj+MzomGCloxPcmqbtE4Q==
X-Received: by 2002:adf:e749:0:b0:316:f4b9:a952 with SMTP id c9-20020adfe749000000b00316f4b9a952mr2948445wrn.31.1692171821805;
        Wed, 16 Aug 2023 00:43:41 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:8b00:5520:fa3c:c527:592f? (p200300cbc74b8b005520fa3cc527592f.dip0.t-ipconnect.de. [2003:cb:c74b:8b00:5520:fa3c:c527:592f])
        by smtp.gmail.com with ESMTPSA id o6-20020adfeac6000000b0031aca6cc69csm444421wrn.2.2023.08.16.00.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 00:43:41 -0700 (PDT)
Message-ID: <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
Date:   Wed, 16 Aug 2023 09:43:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     John Hubbard <jhubbard@nvidia.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        mike.kravetz@oracle.com, apopple@nvidia.com, jgg@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com,
        Mel Gorman <mgorman@techsingularity.net>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
In-Reply-To: <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.08.23 04:34, John Hubbard wrote:
> On 8/14/23 02:09, Yan Zhao wrote:
> ...
>>> hmm_range_fault()-based memory management in particular might benefit
>>> from having NUMA balancing disabled entirely for the memremap_pages()
>>> region, come to think of it. That seems relatively easy and clean at
>>> first glance anyway.
>>>
>>> For other regions (allocated by the device driver), a per-VMA flag
>>> seems about right: VM_NO_NUMA_BALANCING ?
>>>
>> Thanks a lot for those good suggestions!
>> For VMs, when could a per-VMA flag be set?
>> Might be hard in mmap() in QEMU because a VMA may not be used for DMA until
>> after it's mapped into VFIO.
>> Then, should VFIO set this flag on after it maps a range?
>> Could this flag be unset after device hot-unplug?
>>
> 
> I'm hoping someone who thinks about VMs and VFIO often can chime in.

At least QEMU could just set it on the applicable VMAs (as said by Yuan 
Yao, using madvise).

BUT, I do wonder what value there would be for autonuma to still be 
active for the remainder of the hypervisor. If there is none, a prctl() 
would be better.

We already do have a mechanism in QEMU to get notified when 
longterm-pinning in the kernel might happen (and, therefore, 
MADV_DONTNEED must not be used):
* ram_block_discard_disable()
* ram_block_uncoordinated_discard_disable()


-- 
Cheers,

David / dhildenb

