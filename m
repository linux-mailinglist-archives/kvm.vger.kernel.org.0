Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C5276E99B
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 15:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbjHCNJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 09:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbjHCNJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 09:09:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C072130
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 06:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691067933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qwoc3pf9uJ89LLqMiMJh16yMSgGITmRChYha7f0k8Qs=;
        b=Z8985cRHt3v5BROdKeW/FFaRfifa0juBa5SIMGHxEuzfg0VQX5rezDDUoX8fB4KqM44Kqi
        43mZzwMc4QIhMtNMA2m9FJ+TSUOds3DDHxMaV0Hc49wqt2tEo3ilYZL+HduiiNHcWx6ycF
        yvuAKnxqA7ph8oX6ijxCZeOD9+D1geU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-fNo_IQ2WPEm4Ov5Zx8oZaA-1; Thu, 03 Aug 2023 09:05:31 -0400
X-MC-Unique: fNo_IQ2WPEm4Ov5Zx8oZaA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-317955f1b5fso560253f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 06:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691067930; x=1691672730;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qwoc3pf9uJ89LLqMiMJh16yMSgGITmRChYha7f0k8Qs=;
        b=ft8IZS+/yJG7+hrSvJXZzpczmX8nZkNvQHRg1ZBxNShSS7ii1hiscnfm+yfmFll7lR
         eqIy9j2WIYCjKAtF71mwWTqAbn0h5KYfS0Tn+sh6tqNe1VRrRT8tMGkDETYOEungDQGE
         CuZzGsqvi/qqZqUXKsNAJKzvSDrjMClfK51/G+0EJyVWlMEEh0J+9si6UYhwbwI3wSTU
         9bMmnkIIiUXdjPJ345RRijzcNcH3tk87NhUXM6ZcWyR6KITiQr0NiksYyxwN1lj5OTkx
         YTi7hUR60VPfFXqPY7uK0QA6wQo3azqsGdRUiy2vQhVa0erzk/Dv+4ppT6jvvLDgvbOX
         vd4g==
X-Gm-Message-State: ABy/qLZcMc32NCWYlNiG8AZfba/tFJ1RWwMuqF8a9ISRBYSi3qieHyGt
        5U4yq3HYP5I2ORhQrOTR9FzOE6N7LKvtok9T2+XkE6tNhtw4eS8gIMcOmKLKhxPcejeXM/W+BoM
        hpHGL7wRRjN0z
X-Received: by 2002:a5d:460f:0:b0:315:9993:1caa with SMTP id t15-20020a5d460f000000b0031599931caamr5314377wrq.12.1691067930462;
        Thu, 03 Aug 2023 06:05:30 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH7GajLmBHd29WLWeB9cAZpW+rixqcOeEXLg2iQbWmZSODsf7unWiCX6sVwncZrmQDYkBj05g==
X-Received: by 2002:a5d:460f:0:b0:315:9993:1caa with SMTP id t15-20020a5d460f000000b0031599931caamr5314355wrq.12.1691067930012;
        Thu, 03 Aug 2023 06:05:30 -0700 (PDT)
Received: from ?IPV6:2003:cb:c718:9a00:a5f5:5315:b9fa:64df? (p200300cbc7189a00a5f55315b9fa64df.dip0.t-ipconnect.de. [2003:cb:c718:9a00:a5f5:5315:b9fa:64df])
        by smtp.gmail.com with ESMTPSA id p14-20020a1c740e000000b003fe20db88e2sm4281573wmc.18.2023.08.03.06.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Aug 2023 06:05:29 -0700 (PDT)
Message-ID: <f38cf29e-6a3a-dd71-c3ed-c33a9bb40aa3@redhat.com>
Date:   Thu, 3 Aug 2023 15:05:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-9-xiaoyao.li@intel.com>
 <f8e40f1a-729b-f520-299a-4132e371be61@redhat.com>
 <2addfff0-88bf-59aa-f2f3-8129366a006d@intel.com>
 <a154c33d-b24d-b713-0dc0-027d54f2340f@redhat.com>
 <20230802225318.GE1807130@ls.amr.corp.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 08/19] HostMem: Add private property to indicate to
 use kvm gmem
In-Reply-To: <20230802225318.GE1807130@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.08.23 00:53, Isaku Yamahata wrote:
> On Wed, Aug 02, 2023 at 04:14:29PM +0200,
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 02.08.23 10:03, Xiaoyao Li wrote:
>>> On 8/2/2023 1:21 AM, David Hildenbrand wrote:
>>>> On 31.07.23 18:21, Xiaoyao Li wrote:
>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>
>>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>> ---
>>>>>     backends/hostmem.c       | 18 ++++++++++++++++++
>>>>>     include/sysemu/hostmem.h |  2 +-
>>>>>     qapi/qom.json            |  4 ++++
>>>>>     3 files changed, 23 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/backends/hostmem.c b/backends/hostmem.c
>>>>> index 747e7838c031..dbdbb0aafd45 100644
>>>>> --- a/backends/hostmem.c
>>>>> +++ b/backends/hostmem.c
>>>>> @@ -461,6 +461,20 @@ static void
>>>>> host_memory_backend_set_reserve(Object *o, bool value, Error **errp)
>>>>>         }
>>>>>         backend->reserve = value;
>>>>>     }
>>>>> +
>>>>> +static bool host_memory_backend_get_private(Object *o, Error **errp)
>>>>> +{
>>>>> +    HostMemoryBackend *backend = MEMORY_BACKEND(o);
>>>>> +
>>>>> +    return backend->private;
>>>>> +}
>>>>> +
>>>>> +static void host_memory_backend_set_private(Object *o, bool value,
>>>>> Error **errp)
>>>>> +{
>>>>> +    HostMemoryBackend *backend = MEMORY_BACKEND(o);
>>>>> +
>>>>> +    backend->private = value;
>>>>> +}
>>>>>     #endif /* CONFIG_LINUX */
>>>>>     static bool
>>>>> @@ -541,6 +555,10 @@ host_memory_backend_class_init(ObjectClass *oc,
>>>>> void *data)
>>>>>             host_memory_backend_get_reserve,
>>>>> host_memory_backend_set_reserve);
>>>>>         object_class_property_set_description(oc, "reserve",
>>>>>             "Reserve swap space (or huge pages) if applicable");
>>>>> +    object_class_property_add_bool(oc, "private",
>>>>> +        host_memory_backend_get_private,
>>>>> host_memory_backend_set_private);
>>>>> +    object_class_property_set_description(oc, "private",
>>>>> +        "Use KVM gmem private memory");
>>>>>     #endif /* CONFIG_LINUX */
>>>>>         /*
>>>>>          * Do not delete/rename option. This option must be considered
>>>>> stable
>>>>> diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
>>>>> index 39326f1d4f9c..d88970395618 100644
>>>>> --- a/include/sysemu/hostmem.h
>>>>> +++ b/include/sysemu/hostmem.h
>>>>> @@ -65,7 +65,7 @@ struct HostMemoryBackend {
>>>>>         /* protected */
>>>>>         uint64_t size;
>>>>>         bool merge, dump, use_canonical_path;
>>>>> -    bool prealloc, is_mapped, share, reserve;
>>>>> +    bool prealloc, is_mapped, share, reserve, private;
>>>>>         uint32_t prealloc_threads;
>>>>>         ThreadContext *prealloc_context;
>>>>>         DECLARE_BITMAP(host_nodes, MAX_NODES + 1);
>>>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>>>> index 7f92ea43e8e1..e0b2044e3d20 100644
>>>>> --- a/qapi/qom.json
>>>>> +++ b/qapi/qom.json
>>>>> @@ -605,6 +605,9 @@
>>>>>     # @reserve: if true, reserve swap space (or huge pages) if applicable
>>>>>     #     (default: true) (since 6.1)
>>>>>     #
>>>>> +# @private: if true, use KVM gmem private memory
>>>>> +#           (default: false) (since 8.1)
>>>>> +#
>>>>
>>>> But that's not what any of this does.
>>>>
>>>> This patch only adds a property and doesn't even explain what it intends
>>>> to achieve with that.
>>>>
>>>> How will it be used from a user? What will it affect internally? What
>>>> will it modify in regards of the memory backend?
>>>
>>> How it will be used is in the next patch, patch 09.
>>>
>>> for kvm_x86_sw_protected_vm type VM, it will allocate private gmem with
>>> KVM ioctl if the memory backend has property "private" on.
>>
>> It feels wired up the wrong way.
>>
>> When creating/initializing the memory backend, we should also take care of
>> allocating the gmem_fd, for example, by doing some gmem allocation callback,
>> ideally *internally* creating the RAM memory region / RAMBlock.
>>
>> And we should fail if that is impossible (gmem does not apply to the VM) or
>> creating the gmem_fd failed for other reason.
>>
>> Like passing a RAM_GMEM flag to memory_region_init_ram_flags_nomigrate() in
>> ram_backend_memory_alloc(), to then handle it internally, failing if there
>> is an error.
> 
> KVM gmem is tied to VM. not before creating VM. We have to delay of the
> allocation of kvm gmem until VM initialization.

In vl.c, the flow is

1) Create machine: qemu_create_machine()
2) Configure KVM: configure_accelerators()
3) Create backends: qemu_create_late_backends()

Staring at object_create_early(), "memory-backend-" area always late.

So maybe, at the time memory backends are created+initialized, 
everything you need  is already in place.

> 
> Hmm, one options is to move gmem_fd from RAMBlock to KVMSlot.  Handle the
> allocation of KVM gmem (issuing KVM gmem ioctl) there. i.e. in
> kvm_set_phys_mem() or kvm_region_add() (or whatever functions of KVM memory
> listener).  Maybe we can drop ram_block_convert_range() and can have KVM
> specific logic instead.

Might be doable as well.

> 
> We still need a way for user to specify which guest memory region is subject
> to KVM gmem, though.

Let's minimize the gmem hacks and come up with something clean.

-- 
Cheers,

David / dhildenb

