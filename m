Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58D3736C17
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 14:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjFTMkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 08:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjFTMkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 08:40:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486D410DD
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 05:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687264784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YzJ7108xTwIu88GLE/qRI+Iax0/CQlmT7pn76unR1PU=;
        b=I7Zc4XB5JrD1QvTtGh52zAVwbMSkpHXfiAG6AA8hIwDZiFlHnQvhf6gWL4yJpjhcWbLw1R
        GdRq6HGzAy03sqZCgjMTzO8YoMp6BX25f7460myCUSSqwmcmDtiB511cTrXSslAgThvAq4
        jJBtAfjRPxFThMKnB1B0ggpC6VaIoJY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-mEd9_Z2LPaaTK-A4LWEtlQ-1; Tue, 20 Jun 2023 08:39:43 -0400
X-MC-Unique: mEd9_Z2LPaaTK-A4LWEtlQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-30e4d85e1ffso7052459f8f.0
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 05:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687264782; x=1689856782;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YzJ7108xTwIu88GLE/qRI+Iax0/CQlmT7pn76unR1PU=;
        b=YpdV+jcymDZlDuoktLAGMV3GLqiLbYarNUmTyYEl5wZuQnW3LaW/GKpp/yRGpTC5ks
         iH317qqHrvKGKn3BxU3KAO0NgkfAX9AMPu+qCb6Y92SahmMcHzbxwsXgT+NtiVXYh2XB
         wG0853pWOKSx5m+s9E6ns2bKOQeG/G+ZiRVBRs/BeIZarYkgQyghB/j5Z3jSaSSnmrWv
         CRrfCrwIc/BKjw76hKK4sJlmxD2ApPHKfQh09lerHWkLYVe0e0BafOnUfVeh6MyO5FV0
         lLgLsdWDPBqUrzSJulA6gkg59GhzfLLFSbZzRe05NPT0grCp0pMhIpixSmAcJgtfmxeV
         ASPA==
X-Gm-Message-State: AC+VfDyfXW91nQXS42gQfl4oR/xxalxcGV0Owsjfso4/QievhDKW7Xfc
        mfchf8jOCUw0fgizFlkG+zBiJXVnsxQsOe9+v3paDOXvtEGScZW3dH7/FoyfeTDUYhI8MMzTdKh
        I1B1inHlx5kA7
X-Received: by 2002:adf:e6c4:0:b0:30f:b7be:4089 with SMTP id y4-20020adfe6c4000000b0030fb7be4089mr10806440wrm.3.1687264782090;
        Tue, 20 Jun 2023 05:39:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5HTHYlwgQ+xGObwBP48Z9IId+NXMyWjJ8wfh52wmpPzmLxdwzUG/6rLGEfs6iArIJAuGz4DQ==
X-Received: by 2002:adf:e6c4:0:b0:30f:b7be:4089 with SMTP id y4-20020adfe6c4000000b0030fb7be4089mr10806419wrm.3.1687264781695;
        Tue, 20 Jun 2023 05:39:41 -0700 (PDT)
Received: from ?IPV6:2003:cb:c739:d200:8745:c520:8bf6:b587? (p200300cbc739d2008745c5208bf6b587.dip0.t-ipconnect.de. [2003:cb:c739:d200:8745:c520:8bf6:b587])
        by smtp.gmail.com with ESMTPSA id f14-20020adfe90e000000b003111a9a8dbfsm1924320wrm.44.2023.06.20.05.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 05:39:41 -0700 (PDT)
Message-ID: <8ea65567-ec8a-3361-e78c-c51a1d8aad47@redhat.com>
Date:   Tue, 20 Jun 2023 14:39:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Content-Language: en-US
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <759e3af5-6aec-7e50-c432-c5e0a0c3cf36@redhat.com>
 <8e7d6b83347688bb013d7ebb660d0a74a1949d52.camel@intel.com>
 <20230620122012.mnlgko443qrpfrzg@box.shutemov.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230620122012.mnlgko443qrpfrzg@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 20.06.23 14:20, kirill.shutemov@linux.intel.com wrote:
> On Tue, Jun 20, 2023 at 10:37:16AM +0000, Huang, Kai wrote:
>>>> +	/*
>>>> +	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
>>>> +	 * the trap number.  Convert the trap number to the TDX error
>>>> +	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
>>>> +	 *
>>>> +	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
>>>> +	 * only accepts 32-bit immediate at most.
>>>
>>> Not sure if that comment is really helpful here. It's a common pattern
>>> for large immediates, no?
>>
>> I am not sure.  I guess I am not expert of x86 assembly but only casual writer.
>>
>> Hi Dave, Kirill,
>>
>> Are you OK to remove it?
> 
> I would rather keep it. I wanted to ask why separate MOV is needed here,
> before I read the comment. Also size of $TDX_SW_ERROR is not visible here,
> so it contributes to possible confusion without the comment.
> 

Fine with me, but I'd assume that the assembler will simply complain in 
case we'd try to use a large immediate.

-- 
Cheers,

David / dhildenb

