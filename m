Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117A87AA00E
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjIUUbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjIUUbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:31:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865AA897DC
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695318001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=az+fkq8hztpdEGjaiUXR8BZ89IZXFCcBlHnioJmRZy0=;
        b=gZdsevXlKwqfmzh7SRY0G4/35hbT1Q2tBhVqGF+gvVJDOy27b/olkQF7AXyH4Vd679gry9
        d96/eHjKjT3NlTTIEAwOhD9Rm6izrrtvB0GwZd6HzFnabXIouFArzU5qWANkQdQJQ2hoWE
        N8uNUgz41CjvunHeLBGSomN2v8snKG8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-DgfooHjWNFifDHz4rBwIzQ-1; Thu, 21 Sep 2023 05:11:09 -0400
X-MC-Unique: DgfooHjWNFifDHz4rBwIzQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5007f3d3255so1027926e87.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 02:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695287468; x=1695892268;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=az+fkq8hztpdEGjaiUXR8BZ89IZXFCcBlHnioJmRZy0=;
        b=HFf4FSkBo5yj1WJwckT6ckRga80Pmp8/0Q/mligLjCoJ/isRHEeimKX6mqHlaIFL51
         hlVUdbvCGdS0t+lrPFua1nkqvhzwnMpdlScFNVwYrWwccCifcK+d0Oc9JBCcbvLjRRwR
         iC89OpXK4YUDLPvX3BjA7sC4X81IExrUhrDSKNdtN0rLwPDciY1lMo0yJD5m7TPmwzMC
         Rjy0DpgFf0DG36O4yMK3fcTjB/xUpveanVrIkxfliKcOgF++gyS1AkuGLJT6dhq7pFBW
         rfGaGaX9lv8gf5C6MpxUTXt0zgYMeuKZpConcL5ynNNG8jiDQgNcv/6DnyApD+qHCiG5
         tjRw==
X-Gm-Message-State: AOJu0YyJnDCuweI88bg7FIQNEs1h41snNn+E+zPzJmAYqVKXlGbrDw7f
        xvWPssOrNbaZ/E882LYDn6+JfRbljkfiBc/SBCTqQXqQQFZnV47wMfDvsnIvay1dG3AftqyeREP
        VWtMVCj85UNFDBeH0XcwN
X-Received: by 2002:a05:6512:a8b:b0:502:ff3b:7670 with SMTP id m11-20020a0565120a8b00b00502ff3b7670mr5755816lfu.4.1695287467707;
        Thu, 21 Sep 2023 02:11:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWmfjgoq5vKLj4RywvmULLa91iZtxpjvElgwPt0f/+WqP0cNm4IOHYLQMqaUKq/fG0fBrmIQ==
X-Received: by 2002:a05:6512:a8b:b0:502:ff3b:7670 with SMTP id m11-20020a0565120a8b00b00502ff3b7670mr5755797lfu.4.1695287467295;
        Thu, 21 Sep 2023 02:11:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:3c00:9eab:fce5:e6f3:e626? (p200300cbc70d3c009eabfce5e6f3e626.dip0.t-ipconnect.de. [2003:cb:c70d:3c00:9eab:fce5:e6f3:e626])
        by smtp.gmail.com with ESMTPSA id t10-20020adff60a000000b003143c9beeaesm1187087wrp.44.2023.09.21.02.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 02:11:06 -0700 (PDT)
Message-ID: <103096a6-f4b5-d88a-2aac-07dcc86825d6@redhat.com>
Date:   Thu, 21 Sep 2023 11:11:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 00/21] QEMU gmem implemention
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZQOu+OE8LWtLTyno@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> 2. hugepage support.
>>>
>>>      KVM gmem can be allocated from hugetlbfs. How does QEMU determine
> 
> Not yet it can't.  gmem only supports THP, hugetlbfs is a future thing, if it's
> ever supported.  I wouldn't be at all surprised if we end up going down a slightly
> different route and don't use hugetlbfs directly.

Agreed. Certainly future work.

> 
>>>      when to allocate KVM gmem with KVM_GUEST_MEMFD_ALLOW_HUGEPAGE. The
>>>      easiest solution is create KVM gmem with KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
>>>      only when memory backend is HostMemoryBackendFile of hugetlbfs.
>>
>> Good question.
>>
>> Probably "if the memory backend uses huge pages, also use huge pages for the
>> private gmem" makes sense.
>>
>> ... but it becomes a mess with preallocation ... which is what people should
>> actually be using with hugetlb. Andeventual double memory-consumption ...
>> but maybe that's all been taken care of already?
>>
>> Probably it's best to leave hugetlb support as future work and start with
>> something minimal.
>>
>>>
>>> 3. What is KVM_X86_SW_PROTECTED_VM going to look like? and do we need it?
>>>
>>
>> Why implement it when you have to ask others for a motivation? ;)
>>
>> Personally, I'm not sure if it is really useful, especially in this state.
> 
> Yeah, as of today, KVM_X86_SW_PROTECTED_VM is mainly a development vehicle,
> e.g. so that testing gmem doesn't require TDX/SNP hardware, debugging gmem guests
> isn't brutally painful, etc.
> 
> Longer term, I have aspirations of being able to back most VMs with gmem, but
> that's going to require quite a bit more work, e.g. gmem needs to be mappable
> (when hardware allows it) so that gmem doesn't all but require double mapping,
> KVM obviously needs to be able to read/write gmem, etc.
> 
> The value proposition is that having a guest-first memory type will allow KVM to
> optimize and harden gmem in ways that wouldn't be feasible for a more generic
> memory implementation.  E.g. memory isn't mapped into host userspace by default
> (makes it harder to accidentally corrupt the guest), the guest can have *larger*
> mappings than host userspace, guest memory can be served from a dedicated pool
> (similar-ish to hugetlb), the pool can be omitted from the direct map, etc.
>
Thanks for that information. Personally, I don't believe "to back most 
VMs with gmem", but that's a different discussion.

As a development vehicle to get TDX up and running it might be very 
valuable indeed. But it doesn't necessarily have to be merged in QEMU 
for that case -- especially in a semi-finished form.

-- 
Cheers,

David / dhildenb

