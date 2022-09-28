Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C465EE322
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 19:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiI1R3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 13:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiI1R32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 13:29:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F174E86FE5
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664386166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YM6qjwCkh2H9OE1aBHkRCrRvD9Zqt2YLUCUgTTQKZuY=;
        b=RctrEQK8AceVZdHOiAvC3j0STIzY6X/u5nHn+KhNopuUYLNcT1GuObPKhqflEM9mazlfFH
        f2rXQiDseMqoDVxOlxq0AdlIOM3eFH5igYNNriUpo1s0eC4TGnfjk7rJ39WS7HHRNrBRrS
        /gqkNtDJF/3I1XVe4iSslTq2s9q3Vlg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-moos7msSOgCx5WZuBaWMOg-1; Wed, 28 Sep 2022 13:29:25 -0400
X-MC-Unique: moos7msSOgCx5WZuBaWMOg-1
Received: by mail-ej1-f71.google.com with SMTP id dm10-20020a170907948a00b00781fa5e140fso5931995ejc.21
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YM6qjwCkh2H9OE1aBHkRCrRvD9Zqt2YLUCUgTTQKZuY=;
        b=GqShcQqwITrMEpM/UTn0FhMvxO/Yg4+kXCG4grN0RVlPqInogVO8vJ4R6oWfH24IIl
         LBLz2Q3olp0yXKGgTXuXPupUkp5YvU4DwgpN9Kh8DOL1uyhVa0IHiaQ/MUcxRCTN2D9/
         Tm/Ny8Tq6ewyHiqbXjsDoWPLRXZldwSLDqVUs131H5Kp05QQQP8SfoOQMamX7U3J5iFb
         JVgUAP03kJ4qoKj/xaFrcsVXL/9/YGZ5ZSO1tJwJoPWL3kHqCEivPcgqW7d5ttoljqf4
         EDDvvLc1eDVOK9L25sNk+BgV9nFIqVqTgb+okwqEz5QZNQbpwlhMD4WPoypu+dZjf86m
         1MvQ==
X-Gm-Message-State: ACrzQf0OG/1jpNO7XPqJ9TlHqm1HPVIhCoC88ZUeTw4ZSMEUuC/SmIWH
        s52cvwn1YeF1EKKZlSxDckUsiWsPo9ybs5/FxyNqQC4/BKk9mEP0SBKMG/WpV7lZZg7eLBJPhdQ
        YAwFGQeam7D3+
X-Received: by 2002:a17:907:2cd8:b0:776:64a8:1adf with SMTP id hg24-20020a1709072cd800b0077664a81adfmr28547539ejc.151.1664386164494;
        Wed, 28 Sep 2022 10:29:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM49Zx192F3WqwwKeOxNbNV66Dczc1omWuvvjN/XHk+9G7wC0Jx1Zlri9Wj3NR9gRtpD4a/4Vg==
X-Received: by 2002:a17:907:2cd8:b0:776:64a8:1adf with SMTP id hg24-20020a1709072cd800b0077664a81adfmr28547509ejc.151.1664386164248;
        Wed, 28 Sep 2022 10:29:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id g5-20020a170906868500b0073c74bee6eesm2673719ejx.201.2022.09.28.10.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 10:29:23 -0700 (PDT)
Message-ID: <2f80a561-a338-cdb3-e641-d8803b859ce0@redhat.com>
Date:   Wed, 28 Sep 2022 19:29:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-10-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 9/9] kvm_main.c: handle atomic memslot update
In-Reply-To: <20220909104506.738478-10-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 9/9/22 12:45, Emanuele Giuseppe Esposito wrote:
> @@ -1782,7 +1782,8 @@ static void kvm_update_flags_memslot(struct kvm *kvm,
>   
>   /*
>    * Takes kvm->slots_arch_lock, and releases it only if
> - * invalid_slot allocation or kvm_prepare_memory_region failed.
> + * invalid_slot allocation, kvm_prepare_memory_region failed
> + * or batch->is_move_delete is true.
>    */

This _is_ getting out of hand, though. :)  It is not clear to me why you 
need to do multiple swaps.  If you did a single swap, you could do all 
the allocations of invalid slots in a separate loop, called with 
slots_arch_lock taken and not released until the final swap.  In other 
words, something like

	mutex_lock(&kvm->slots_arch_lock);
	r = create_invalid_slots();
	if (r < 0)
		return r;

	replace_old_slots();

	// also handles abort on failure
	prepare_memory_regions();
	if (r < 0)
		return r;
	swap();
	finish_memslots();

where each function is little more than a loop over the corresponding 
function called by KVM_SET_MEMORY_REGION.

Paolo

