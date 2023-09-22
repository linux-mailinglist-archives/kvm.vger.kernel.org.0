Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437FC7AA9D5
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 09:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjIVHMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 03:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjIVHML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 03:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706B1199
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 00:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695366673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFNwEiXcFSjpvjHc3z5XjBokxCgPL9Ikt3S3AYhjxmg=;
        b=FmQHIafpobTqayFpRy+5oIDYC8/Adz5OC6RwajSn15vbYlpPi698zVX+ZSZUM11P8L0wBn
        GVKye/i3jB/G3sQ8BaLiOGnLbu25Xp2eGCx8rDJnukh5xbaLywJM/UfsF88/NNBm/ccaoy
        5CDOKjyY1C6axobBDd+0Lg/k5hnYG4k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-wiLsQlLUNXWOmFSnbcyYjQ-1; Fri, 22 Sep 2023 03:11:12 -0400
X-MC-Unique: wiLsQlLUNXWOmFSnbcyYjQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30e4943ca7fso1199678f8f.3
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 00:11:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695366671; x=1695971471;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UFNwEiXcFSjpvjHc3z5XjBokxCgPL9Ikt3S3AYhjxmg=;
        b=Dlf0Vz8SmVSt7fQYbEQL5dWoWDsMNgwzUEZX1rEjiN3CmNNTquyZQIruvuOK0MayeV
         F+dBpAV8F/T9t0xuvCA5+pMnanIOIlWo7lhIhRSlx78SezvOG5523lDtTYgoZ00GrsUE
         C5FCuf5g0ndJaAFCo4S8zxAWR7xAq3i7a2vwiyvawaBKwvun6Rm+Xs3suthMrYg7UMjr
         rSn5Veg7sE/469gopTqRnGrkCFnXJXuXYFu30fQQLd6CX7Xazj7ugE/8DJwKLaSWI9Gv
         ZNUXbz1EfTuTN70RtrYNvXvScsunZEvCEynQN6qTW+bryU4jOyvQXIyxQunNjTgU9vIS
         khmA==
X-Gm-Message-State: AOJu0Yw4fIJz1SZKYQCducYOvuavGOU2P2+Y+pY6zhV6cKmcn71v4UGC
        NxYhl/U1ezizGZ3x4rDk8w32B2UmyCPk5c4qMg5PtlxKzpX69Xmp/2BW3LFaeeCFLbbqR0u7dFc
        qQZnHqX+XLryQ0E7v/lGb
X-Received: by 2002:a5d:674b:0:b0:321:56af:5ef9 with SMTP id l11-20020a5d674b000000b0032156af5ef9mr7141200wrw.70.1695366670866;
        Fri, 22 Sep 2023 00:11:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOeCSf8ZFg/EoCi9LkN9QWr/WmQE7XBq7TZBFIu93EVlLq6FjR1pA4a905mxBSMyORw9fylA==
X-Received: by 2002:a5d:674b:0:b0:321:56af:5ef9 with SMTP id l11-20020a5d674b000000b0032156af5ef9mr7141162wrw.70.1695366670485;
        Fri, 22 Sep 2023 00:11:10 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71a:7100:dfaf:df8b:54b9:7303? (p200300cbc71a7100dfafdf8b54b97303.dip0.t-ipconnect.de. [2003:cb:c71a:7100:dfaf:df8b:54b9:7303])
        by smtp.gmail.com with ESMTPSA id b9-20020a05600c11c900b003feef82bbefsm3817779wmi.29.2023.09.22.00.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 00:11:10 -0700 (PDT)
Message-ID: <9bf45e57-a1be-50c6-fecd-23bbfb8e7c62@redhat.com>
Date:   Fri, 22 Sep 2023 09:11:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 07/21] i386/pc: Drop pc_machine_kvm_type()
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
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
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-8-xiaoyao.li@intel.com>
 <b5ebeeac-9f0f-eb57-b5e2-4c03698e5ee4@redhat.com>
 <11ada91d-4054-2ce9-9a3b-4d182106e860@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <11ada91d-4054-2ce9-9a3b-4d182106e860@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.09.23 02:24, Xiaoyao Li wrote:
> On 9/21/2023 4:51 PM, David Hildenbrand wrote:
>> On 14.09.23 05:51, Xiaoyao Li wrote:
>>> pc_machine_kvm_type() was introduced by commit e21be724eaf5 ("i386/xen:
>>> add pc_machine_kvm_type to initialize XEN_EMULATE mode") to do Xen
>>> specific initialization by utilizing kvm_type method.
>>>
>>> commit eeedfe6c6316 ("hw/xen: Simplify emulated Xen platform init")
>>> moves the Xen specific initialization to pc_basic_device_init().
>>>
>>> There is no need to keep the PC specific kvm_type() implementation
>>> anymore.
>>
>> So we'll fallback to kvm_arch_get_default_type(), which simply returns 0.
>>
>>> On the other hand, later patch will implement kvm_type()
>>> method for all x86/i386 machines to support KVM_X86_SW_PROTECTED_VM.
>>>
>>
>> ^ I suggest dropping that and merging that patch ahead-of-time as a
>> simple cleanup.
> 
> I suppose the "that" here means "this patch", right?


With that I meant that paragraph "On the other hand, later patch ...".

-- 
Cheers,

David / dhildenb

