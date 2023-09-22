Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004907AA9D1
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 09:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjIVHLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 03:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjIVHLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 03:11:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8641B5
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 00:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695366621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Td4/Q9tc/kCcThoBN9cPyeNhNr581R6+KIqYHVDADZA=;
        b=g/y/FLBqP1e7p3DtWibsBzuyQwrU+Amtb57cGth1hjDXvVCAFrQCA/56rq579jO980qc2Y
        XPsgUTwmporgKYl9Z6qGKudsWDW3Vz/sM3opOwfHeRtHtqMbDu37dCcWFXeSzugwEY3FkZ
        C9ioo+5yjAkvdqocgyvXpAZV6WQNmhs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-FMqwUMj5Maa_vUnQl0AqyQ-1; Fri, 22 Sep 2023 03:10:18 -0400
X-MC-Unique: FMqwUMj5Maa_vUnQl0AqyQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4030ae94fedso14195715e9.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 00:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695366617; x=1695971417;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Td4/Q9tc/kCcThoBN9cPyeNhNr581R6+KIqYHVDADZA=;
        b=VzAnVNwBuw5UG4+LZohoCF7y7krZCFt1K+l2KLDvLHH7rpl4EbcWhLo9F4xihWJO7e
         6Wm0kFgWHOdVUqSENTqBZod5IiWER9u1G2ssJkhaPDPSnieD8KiaznlpJe9miAfE1itP
         zZ8arZQzqZAryAjFTMwZXApxfNwk/QjBPuhLpywrrGMJHpqJUqO60a2vvOhzUpvDbcC4
         ayYu9SavjZvMHc5nxy4BTtfhcKava+xZOHhC0+HYB1pKndSh0YTJWVNugbMMUWVh9ZQE
         nKlRmdjXqKFOn9+IbRBQlCwSmvZKNlnvCa1rsgODQ9iC+2lY/H6yjuigIOIxSqNDPGLP
         OtWw==
X-Gm-Message-State: AOJu0Yxd7OlVI2UTka8U8wNzVUCLwK1o0l27ZVawRsMf75OTKEjPIGP5
        AAYPevaTtNGdpqGQA5Ij+DeXA+j00t0wAwcncnrUTr6tixjun3LPQdgwV2kQRsomOIW3BQSZCa2
        oZB+REdfUxMt4
X-Received: by 2002:a7b:c44c:0:b0:403:442:5421 with SMTP id l12-20020a7bc44c000000b0040304425421mr7139590wmi.4.1695366617217;
        Fri, 22 Sep 2023 00:10:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAxomf4h1ro8C6sRgiCNzMWwZXlyTRvBg3Cw4FUwNCPoMNI247nrTxr/f28pbjXF0e8BUUNw==
X-Received: by 2002:a7b:c44c:0:b0:403:442:5421 with SMTP id l12-20020a7bc44c000000b0040304425421mr7139571wmi.4.1695366616743;
        Fri, 22 Sep 2023 00:10:16 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71a:7100:dfaf:df8b:54b9:7303? (p200300cbc71a7100dfafdf8b54b97303.dip0.t-ipconnect.de. [2003:cb:c71a:7100:dfaf:df8b:54b9:7303])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c248b00b003fee567235bsm6718056wms.1.2023.09.22.00.10.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 00:10:16 -0700 (PDT)
Message-ID: <0ce93270-a1a9-df9a-761a-618b92ccef3b@redhat.com>
Date:   Fri, 22 Sep 2023 09:10:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 00/21] QEMU gmem implemention
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        isaku.yamahata@gmail.com, Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <fe9f3d19-df01-01e6-a253-f7fe5bdea41f@redhat.com>
 <ZQOu+OE8LWtLTyno@google.com>
 <103096a6-f4b5-d88a-2aac-07dcc86825d6@redhat.com>
 <ace06668-81fd-3153-5b93-30b0b82aea46@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ace06668-81fd-3153-5b93-30b0b82aea46@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.09.23 09:03, Xiaoyao Li wrote:
> On 9/21/2023 5:11 PM, David Hildenbrand wrote:
>>>>> 3. What is KVM_X86_SW_PROTECTED_VM going to look like? and do we
>>>>> need it?
>>>>>
>>>>
>>>> Why implement it when you have to ask others for a motivation? 😉
>>>>
>>>> Personally, I'm not sure if it is really useful, especially in this
>>>> state.
>>>
>>> Yeah, as of today, KVM_X86_SW_PROTECTED_VM is mainly a development
>>> vehicle,
>>> e.g. so that testing gmem doesn't require TDX/SNP hardware, debugging
>>> gmem guests
>>> isn't brutally painful, etc.
>>>
>>> Longer term, I have aspirations of being able to back most VMs with
>>> gmem, but
>>> that's going to require quite a bit more work, e.g. gmem needs to be
>>> mappable
>>> (when hardware allows it) so that gmem doesn't all but require double
>>> mapping,
>>> KVM obviously needs to be able to read/write gmem, etc.
>>>
>>> The value proposition is that having a guest-first memory type will
>>> allow KVM to
>>> optimize and harden gmem in ways that wouldn't be feasible for a more
>>> generic
>>> memory implementation.  E.g. memory isn't mapped into host userspace
>>> by default
>>> (makes it harder to accidentally corrupt the guest), the guest can
>>> have *larger*
>>> mappings than host userspace, guest memory can be served from a
>>> dedicated pool
>>> (similar-ish to hugetlb), the pool can be omitted from the direct map,
>>> etc.
>>>
>> Thanks for that information. Personally, I don't believe "to back most
>> VMs with gmem", but that's a different discussion.
>>
>> As a development vehicle to get TDX up and running it might be very
>> valuable indeed. But it doesn't necessarily have to be merged in QEMU
>> for that case -- especially in a semi-finished form.
> 
> It's true and I agree with it. I'll drop the KVM_X86_SW_PROTECTED_VM
> part in next version.
> 
> How would you like this series to proceed in next version? only the
> patches of gmem support without a user? or together with next QEMU TDX
> series?

Makes sense to me. GMEM series can be a prereq for QEMU TDX.

-- 
Cheers,

David / dhildenb

