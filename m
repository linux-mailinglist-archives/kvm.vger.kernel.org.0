Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B4D5B0CF3
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 21:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIGTPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 15:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIGTPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 15:15:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC871707B
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 12:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662578098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2hl65/5BHZV+h8ft7hHxLgHBBHzGCSnWLOyF+9Pr+8=;
        b=U3NwU6PSfplSlk43GsylcPwMz//4YVhFZoPxSiVvV1Y4hhtYDayBkFieYq0bwk6P0SmEtw
        nXYy8dkRSeLi9CQ0clqq3+7LzCFjgrFJ/1LWIn1Xal9ooLfwjWD82phZdRS62BmJ8+Hbwi
        TcTkFPQqolDfYK5D2P/Doaro4WTQZjQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-226-uLzUV2OHPTeGje98XqM-xg-1; Wed, 07 Sep 2022 15:14:57 -0400
X-MC-Unique: uLzUV2OHPTeGje98XqM-xg-1
Received: by mail-wr1-f71.google.com with SMTP id h2-20020adfa4c2000000b00228db7822cbso2122509wrb.19
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 12:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=F2hl65/5BHZV+h8ft7hHxLgHBBHzGCSnWLOyF+9Pr+8=;
        b=cuKrEJ/AgFgwRT6QRZzwxv3aQPps39jq0zFnCaXbEm9c1oXWQgfpZ7iYyO1z1qXzzR
         CeFF5hY+NHIXzTOFUM2kYodRI8e0pv5loMffG4au8tWK1muDX17JIz9+o6LiFSaA5Xy/
         zxcbOIBwxD0oLSgTIgAU5Y8R7azMqq4F2eeHpm2nZ82W2IjkSu2g+AK3piuv4UDmavGd
         KYnTDqxNh33j22uW8yTpW6skLFVsSTkes/FHkfvIBJEmV+6p1QgOJiOb7wS86sOxSJE1
         bqaAx35n1DydLtLWDsyKHfOLD7yci4F/2U+rnfdG/JIAaZCRapmTfHJXVpPyc8jqAVHB
         qo3A==
X-Gm-Message-State: ACgBeo3Lj+P7KfTOqDZpMfz9DzknP6/jFYaERAHhwDiAPW8V+24WnkRT
        a1wcfo28O+nfhV0IEX1Osk5u8ayDUMxeYYBNgLludSAskEjM8jW1eQFPxzjCGeG9cO+8E44QmMh
        RQ/CPfUbwDFjX
X-Received: by 2002:a05:6000:cf:b0:228:e37b:361b with SMTP id q15-20020a05600000cf00b00228e37b361bmr2599743wrx.374.1662578096102;
        Wed, 07 Sep 2022 12:14:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Mej1JLF8Idc5qNLyIzkfO5zK2VWFm2c7LZq5/eJiJrZnnv9hvkXiOQaSwnEjKeK//Gm5oog==
X-Received: by 2002:a05:6000:cf:b0:228:e37b:361b with SMTP id q15-20020a05600000cf00b00228e37b361bmr2599728wrx.374.1662578095776;
        Wed, 07 Sep 2022 12:14:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0d:ba00:c951:31d7:b2b0:8ba0? (p200300d82f0dba00c95131d7b2b08ba0.dip0.t-ipconnect.de. [2003:d8:2f0d:ba00:c951:31d7:b2b0:8ba0])
        by smtp.gmail.com with ESMTPSA id m18-20020adff392000000b00228b3ff1f5dsm13553530wro.117.2022.09.07.12.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 12:14:54 -0700 (PDT)
Message-ID: <7ed97088-b4f0-e36f-c935-87cd1e94c574@redhat.com>
Date:   Wed, 7 Sep 2022 21:14:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
 <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com> <YxfX+kpajVY4vWTL@ziepe.ca>
 <b365f30b-da58-39c0-08e9-c622cc506afa@redhat.com> <YxiTOyGqXHFkR/DY@ziepe.ca>
 <20220907095552.336c8f34.alex.williamson@redhat.com>
 <YxjJlM5A0OLhaA7K@ziepe.ca>
 <20220907125627.0579e592.alex.williamson@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220907125627.0579e592.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.09.22 20:56, Alex Williamson wrote:
> On Wed, 7 Sep 2022 13:40:52 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
>> On Wed, Sep 07, 2022 at 09:55:52AM -0600, Alex Williamson wrote:
>>
>>>> So, if we go back far enough in the git history we will find a case
>>>> where PUP is returning something for the zero page, and that something
>>>> caused is_invalid_reserved_pfn() == false since VFIO did work at some
>>>> point.
>>>
>>> Can we assume that?  It takes a while for a refcount leak on the zero
>>> page to cause an overflow.  My assumption is that it's never worked, we
>>> pin zero pages, don't account them against the locked memory limits
>>> because our is_invalid_reserved_pfn() test returns true, and therefore
>>> we don't unpin them.
>>
>> Oh, you think it has been buggy forever? That is not great..
>>   
>>>> IHMO we should simply go back to the historical behavior - make
>>>> is_invalid_reserved_pfn() check for the zero_pfn and return
>>>> false. Meaning that PUP returned it.
>>>
>>> We've never explicitly tested for zero_pfn and as David notes,
>>> accounting the zero page against the user's locked memory limits has
>>> user visible consequences.  VMs that worked with a specific locked
>>> memory limit may no longer work.
>>
>> Yes, but the question is if that is a strict ABI we have to preserve,
>> because if you take that view it also means because VFIO has this
>> historical bug that David can't fix the FOLL_FORCE issue either.
>>
>> If the view holds for memlock then it should hold for cgroups
>> also. This means the kernel can never change anything about
>> GFP_KERNEL_ACCOUNT allocations because it might impact userspace
>> having set a tight limit there.
>>
>> It means we can't fix the bug that VFIO is using the wrong storage for
>> memlock.
>>
>> It means qemu can't change anything about how it sets up this memory,
>> ie Kevin's idea to change the ordering.
>>
>> On the other hand the "abi break" we are talking about is that a user
>> might have to increase a configured limit in a config file after a
>> kernel upgrade.
>>
>> IDK what consensus exists here, I've never heard of anyone saying
>> these limits are a strict ABI like this.. I think at least for cgroup
>> that would be so invasive as to immediately be off the table.
> 
> I thought we'd already agreed that we were stuck with locked_vm for
> type1 and any compatibility mode of type1 due to this.  Native iommufd
> support can do the right thing since userspace will need to account for
> various new usage models anyway.
> 
> I've raised the issue with David for the zero page accounting, but I
> don't know what the solution is.  libvirt automatically adds a 1GB
> fudge factor to the VM locked memory limits to account for things like
> ROM mappings, or at least the non-zeropage backed portion of those
> ROMs.  I think that most management tools have adopted similar, so the
> majority of users shouldn't notice.  However this won't cover all
> users, so we certainly risk breaking userspace if we introduce hard
> page accounting of zero pages.
> 
> I think David suggested possibly allowing some degree of exceeding
> locked memory limits for zero page COWs.  Potentially type1 could do
> this as well; special case handling with some heuristically determined,
> module parameter defined limit.  We might also consider whether we
> could just ignore zero page mappings, maybe with a optional "strict"
> mode module option to generate an errno on such mappings.  Thanks,

So far I played with the ideas

a) allow slightly exceeding the limit and warn

b) weird vfio kernel parameter to control the zeropage behavior (old vs.
    new)

I certainly have in mind that we might need some toggle for vfio.

-- 
Thanks,

David / dhildenb

