Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1567C5EBD81
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 10:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiI0Ig5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 04:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiI0IgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 04:36:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2F71FCCB
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 01:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664267749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AM7Ag3R1FhhmxAI1wRPUG0RaWTwM4UqjFY6j2yTgwJQ=;
        b=JrUHYIPVk2MIpY8G3ZUnl5lMwHZmjtj1/79OJp2kLUnSh30ViSiDn807YlQ6FJELQY7Zwv
        HA7PrgLnxaUEnfi4vbfQbykjdqQJ3TLNWT6YiLT8z6BcKaviuIsOfioI9WA7qkULL7K1Pc
        t2Z3J4ViKEzgHMS/85JvOdArU3lF4as=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-531-i_ELWD8-PwCGtcQ1OJGB_g-1; Tue, 27 Sep 2022 04:35:48 -0400
X-MC-Unique: i_ELWD8-PwCGtcQ1OJGB_g-1
Received: by mail-qv1-f69.google.com with SMTP id dw19-20020a0562140a1300b004a8eee124b4so5418166qvb.21
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 01:35:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=AM7Ag3R1FhhmxAI1wRPUG0RaWTwM4UqjFY6j2yTgwJQ=;
        b=zCPv7g2KDZYmtxvC23rAFBF51/HsJc9DYAhORj5mkJJIseYUfIhxensm1T9D4G5ceP
         mSL2CSNrdsaBB68YhhGBbLQDkuBSPmYjA6Eqtw55d/g7wDA3YE+JtpN2b+P9MXMSEbSm
         uuhPTZ2cexfoG9Cb2p8SIzhPNmGZUxf4sHiOA32v2YewDCDTeafbgqE6LKgT3kt2Hvlm
         GXB6q22hErkwozj9Ki810skQDsQlCIFsQeEsVwtfsKnNdjmAQl2ctxPqlozmRK6sjefp
         B7ObDf6MYcaSkk5q18bBfGzs9EeoFmKmkW42KRGxuQ5AJSk2B0C09icUCl9bNF3Y0GeD
         qr1Q==
X-Gm-Message-State: ACrzQf3/lWh8K1mtSjPNtg2UXJaGmIvREaI0Mz73oor+s69OxjSQK5qV
        68d2uvRAHJ7MilfbEec36kb+5A0z+vlKcv6DPIC9yeTTqGvSnODTorxzQlEDgZLrFKxANtvXsG2
        /LS64iBqOHYw3
X-Received: by 2002:a05:620a:b51:b0:6cf:68b2:d86e with SMTP id x17-20020a05620a0b5100b006cf68b2d86emr16329433qkg.176.1664267747427;
        Tue, 27 Sep 2022 01:35:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5MALcAfa3QgOA5vjMb3lzeNy2EAYRtu/tLCNJjqEezFwM7HOiQUF2wu8EvBKTjJ3BOkTmxCw==
X-Received: by 2002:a05:620a:b51:b0:6cf:68b2:d86e with SMTP id x17-20020a05620a0b5100b006cf68b2d86emr16329418qkg.176.1664267747218;
        Tue, 27 Sep 2022 01:35:47 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id f2-20020ac86ec2000000b0035d420c4ba7sm466320qtv.54.2022.09.27.01.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 01:35:46 -0700 (PDT)
Message-ID: <07014070-5186-ca95-7028-82f77612dedd@redhat.com>
Date:   Tue, 27 Sep 2022 10:35:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 9/9] kvm_main.c: handle atomic memslot update
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-10-eesposit@redhat.com>
 <cde8be9d-64c0-80e5-7663-4302d075dcbc@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <cde8be9d-64c0-80e5-7663-4302d075dcbc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 27/09/2022 um 09:46 schrieb David Hildenbrand:
> On 09.09.22 12:45, Emanuele Giuseppe Esposito wrote:
>> When kvm_vm_ioctl_set_memory_region_list() is invoked, we need
>> to make sure that all memslots are updated in the inactive list
>> and then swap (preferreably only once) the lists, so that all
>> changes are visible immediately.
>>
>> The only issue is that DELETE and MOVE need to perform 2 swaps:
>> firstly replace old memslot with invalid, and then remove invalid.
>>
> 
> I'm curious, how would a resize (grow/shrink) or a split be handled?
> 

There are only 4 operations possible in KVM: KVM_MR_{DELETE, MOVE,
CREATE, FLAGS_ONLY}.

A resize should be implemented in QEMU as DELETE+CREATE.

Therefore a resize on memslot X will be implemented as:
First pass on the userspace operations:
	invalidate memslot X;
	swap_memslot_list(); // NOW it is visible to the guest

What guest sees: memslot X is invalid, so MMU keeps retrying the page fault

Second pass:
	create new memslot X
	delete old memslot X


What guest sees: memslot X is invalid, so MMU keeps retrying the page fault

Third pass:
	swap() // 1 for each address space affected

What guest sees: new memslot replacing the old one



A split is DELETE+CREATE+CREATE, so it's the same:

First pass on the userspace operations:
	invalidate memslot X;
	swap_memslot_list(); // NOW it is visible to the guest

What guest sees: memslot X is invalid, so MMU keeps retrying the page fault

Second pass:
	delete old memslot X
	create new memslot X1
	create new memslot X2

What guest sees: memslot X is invalid, so MMU keeps retrying the page fault

Third pass:
	swap() // 1 for each address space affected

What guest sees: two new memslots replacing the old one

