Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FBB6F89F4
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 22:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjEEUBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 16:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjEEUBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 16:01:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A67D1BFA
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 13:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683316851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ukBlLJAAZaQ/r1CAoE/M1VTZFpBfXgEo6B4FhT6NEws=;
        b=QWRGHq6brLRkY81n5TE4rw9xOP/ugb/Fkd68HiNIY+Ev3UJNrkJhHDAwdB1Wp8a8DrL0pY
        /Q1RVWblbQsOJPipGJMyh/YqmsJP1MF0B5id0H/FnkkC0NYxgwkcXU7cOHHDtaOCANbqZ4
        SxZKMgC8fWusqMcRdEjJO7F3fNjO8RQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-bC21FiL6MMiJMMNYMP55IA-1; Fri, 05 May 2023 16:00:48 -0400
X-MC-Unique: bC21FiL6MMiJMMNYMP55IA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f3fe2492c4so12687695e9.0
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 13:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683316847; x=1685908847;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukBlLJAAZaQ/r1CAoE/M1VTZFpBfXgEo6B4FhT6NEws=;
        b=iSLS84AspqWlnqyYy1wLRrKG4m3+WGO5+TdWKHkNvcffXXcUhePHLn6aPocZ56Z9i0
         DYA6PcIub/Vel7GbuFEmHe+4yCJJfZgJBgmWhERU6A5NxAXF5E0OzJe/i9jxXd40MmVK
         7rrH9Ja+GivmUntOti9bLLq1bbu68Oj72UY/U193n3X1MMvrHe/qWCZnRn3FkUhucCiU
         W/ZeflHT3gYdKeatqkavwPcpVi4SB2hJbjxc6QeoT3ptr61vs3kkVqlP/pb4IzpxGhH+
         apalw0mFnIe+9mV55P/6tNOxNxw52XA/Fxl30GewrNnpyadpu3ea5CHqfn2znEtDvE9c
         mC/g==
X-Gm-Message-State: AC+VfDwpz0tERslOAPIK6w9ODC62iKAbzs3wKK+7GmmrCB/zGmM4Ie4J
        1kMHxAN48Q7bnWqq545ao3xy5DXBGqFLFhWQGKYT3c2dlmBZkhaOANYAQSoakupyTBGtxERrZcb
        hLkX9UGMKARnQ
X-Received: by 2002:a7b:c8c3:0:b0:3f3:21f7:a3f5 with SMTP id f3-20020a7bc8c3000000b003f321f7a3f5mr1898741wml.34.1683316847031;
        Fri, 05 May 2023 13:00:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7AWMCmWZgMXJ3itkQkjvhLZgFXfiQcw67zZcDRqQM7ZUHVlWWfxUAlasyIVWHcBoHop640zA==
X-Received: by 2002:a7b:c8c3:0:b0:3f3:21f7:a3f5 with SMTP id f3-20020a7bc8c3000000b003f321f7a3f5mr1898726wml.34.1683316846698;
        Fri, 05 May 2023 13:00:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71f:6900:2b25:fc69:599e:3986? (p200300cbc71f69002b25fc69599e3986.dip0.t-ipconnect.de. [2003:cb:c71f:6900:2b25:fc69:599e:3986])
        by smtp.gmail.com with ESMTPSA id f23-20020a7bcd17000000b003ee443bf0c7sm8738510wmj.16.2023.05.05.13.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 13:00:46 -0700 (PDT)
Message-ID: <6db68140-0612-a7a3-2cec-c583b2ed3a61@redhat.com>
Date:   Fri, 5 May 2023 22:00:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com>
 <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <CS465PQZS77J.J1RP6AJX1CWZ@suppilovahvero>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CS465PQZS77J.J1RP6AJX1CWZ@suppilovahvero>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.04.23 15:28, Jarkko Sakkinen wrote:
> On Mon Apr 17, 2023 at 6:48 PM EEST, David Hildenbrand wrote:
>> On 17.04.23 17:40, Sean Christopherson wrote:
>>> What do y'all think about renaming "restrictedmem" to "guardedmem"?
>>
>> Yeay, let's add more confusion :D
>>
>> If we're at renaming, I'd appreciate if we could find a terminology that
>> does look/sound less horrible.
>>
>>>
>>> I want to start referring to the code/patches by its syscall/implementation name
>>> instead of "UPM", as "UPM" is (a) very KVM centric, (b) refers to the broader effort
>>> and not just the non-KVM code, and (c) will likely be confusing for future reviewers
>>> since there's nothing in the code that mentions "UPM" in any way.
>>>
>>> But typing out restrictedmem is quite tedious, and git grep shows that "rmem" is
>>> already used to refer to "reserved memory".
>>>
>>> Renaming the syscall to "guardedmem"...
>>
>> restrictedmem, guardedmem, ... all fairly "suboptimal" if you'd ask me ...
> 
> In the world of TEE's and confidential computing it is fairly common to
> call memory areas enclaves, even outside SGX context. So in that sense
> enclave memory would be the most correct terminology.

I was also thinking along the lines of isolated_mem or imem ... 
essentially, isolated from (unprivileged) user space.

... if we still want to have a common syscall for it.

-- 
Thanks,

David / dhildenb

