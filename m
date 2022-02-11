Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826A54B22C5
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 11:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348781AbiBKKIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 05:08:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348772AbiBKKIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 05:08:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E90C72D3
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 02:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644574079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gfGkA7Cm98mQQxNqLHSWcgGR5BEvRqLzjxzk/VgJxmM=;
        b=QgfI5LTT0nMBO/3np/vjnSFofQsFmwH8UFg/eNfit7ERaNOnbpyfjhI0F8GhOMlWeTp87f
        esCAB8BAfnta8fAkZjlVox4PKOJQySR46qlzTlW+rpX37kGg1DjOomBFRVbSUWTqzQxztX
        qOel18ssxNRA368ablMfAk8v2JdKsNM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-fCRjxz0yMkqRR6KtOrcUJA-1; Fri, 11 Feb 2022 05:07:57 -0500
X-MC-Unique: fCRjxz0yMkqRR6KtOrcUJA-1
Received: by mail-ed1-f72.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so5071586edb.2
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 02:07:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gfGkA7Cm98mQQxNqLHSWcgGR5BEvRqLzjxzk/VgJxmM=;
        b=APvbC5zEF1fWJr5Im/YTJlBAwPOUhJSuw9rdB/hlKv3l4F7dnNCDJP35PRbtFjXfm0
         itJ2+El9zOTz1j1tXRbArpxmhzzI7+GtthixwD3uC0NYbsbqfB0XmD/svgRq1hhqPnV1
         R9DDMIn903dj6WImFRprgo3L0HTKxtgQagIFK01KZJoq7xkWQTo+Pi19tAXD/owFhBCY
         e2IBUvwF4XUfiFhUtq7tCrYX+F+vRKyLBxXvKlD7Jcx6azlE5asG8HBGLiJcfjUAUzdy
         SfJaJdVjJ/TkxuSbLCX8hqw2c3jFd2FAXuFWG5Qa+OwhDl+QRTldpReDtLlaGrGhHO03
         /FKw==
X-Gm-Message-State: AOAM5311qYe8O6hweaW2Ls6GZhCAKWmSkrEUa750ddvq1kem1hW8BTWq
        hskT9J89YO9F3AvJy84LerYWjGyGoLudruHFCt0B5K0FJ/GUwMhbn1N97G86+IIo6KHzTetRWQS
        a8oacmpoviJiG
X-Received: by 2002:a17:906:c112:: with SMTP id do18mr757971ejc.472.1644574076537;
        Fri, 11 Feb 2022 02:07:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwSxBBvCyB7sNCA0jxUcGqy/Oa2XplQTQXcQusTsHvIPMzyxnX9ROCzac1cYFUj2oGOkQd3Q==
X-Received: by 2002:a17:906:c112:: with SMTP id do18mr757957ejc.472.1644574076322;
        Fri, 11 Feb 2022 02:07:56 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id eg11sm9365972edb.17.2022.02.11.02.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 02:07:55 -0800 (PST)
Message-ID: <4e05cfc5-55bb-1273-5309-46ed4fe52fed@redhat.com>
Date:   Fri, 11 Feb 2022 11:07:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 06/12] KVM: MMU: rename kvm_mmu_reload
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-7-pbonzini@redhat.com> <YgWtdUotsoBOOtXz@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgWtdUotsoBOOtXz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 01:27, Sean Christopherson wrote:
> On Wed, Feb 09, 2022, Paolo Bonzini wrote:
>> The name of kvm_mmu_reload is very confusing for two reasons:
>> first, KVM_REQ_MMU_RELOAD actually does not call it; second,
>> it only does anything if there is no valid root.
>>
>> Rename it to kvm_mmu_ensure_valid_root, which matches the actual
>> behavior better.
> 
> 100% agree that kvm_mmu_reload() is a terrible name, but kvm_mmu_ensure_valid_root()
> isn't much better, e.g. it sounds like a sanity check and nothing more.

I would have thought that would be more of a check_valid_root().  There 
are other functions in the kernel following the idea that "ensure" means 
idempotency: skb_ensure_writable, perf_cgroup_ensure_storage, 
btf_ensure_modifiable and libbpf_ensure_mem in libbpf.  I'm not a native 
speaker but, at least in computing, "ensure" seems to mean not just "to 
make certain that (something) will be true", but also taking steps if 
that's not already the case.

I also thought of "establish_valid_root", but it has the opposite 
problem---it does not convey well, if at all, that the root could be 
valid already.

Paolo

> 
> Maybe just be very literalal?
> 
>    kvm_mmu_load_if_necessary()
>    kvm_mmu_load_if_invalid()
> 
> Or follow cond_sched()?
> 
>    kvm_mmu_cond_load()
> 

