Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2668652EFE5
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 18:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351257AbiETQCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 12:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351232AbiETQCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 12:02:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FFBE54BEB
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 09:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653062522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y5W2xTr9o/WCMRQhu6HKw55eZlY0lilMNQ9iTu4k2L4=;
        b=Z9LPrbySd/beQJT+j4aXIAO5ShKXq9mDcVNcey7gSYOQ1L8ZD3kpzN5sQg8bmywKrxtsgs
        Uxk+k5ZWW4AcpVmzIKd5RBzvqfbBpAZ9O7C8mhWT//v3Fqixrct4SuBIL71vxyKAoN2jfJ
        Me2Lhsd47biKdckwUc1soI1I5Yx0XLw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479--ed9heWvNAKCUnjoV49dIw-1; Fri, 20 May 2022 12:02:01 -0400
X-MC-Unique: -ed9heWvNAKCUnjoV49dIw-1
Received: by mail-ej1-f69.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso4233735ejs.12
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 09:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=y5W2xTr9o/WCMRQhu6HKw55eZlY0lilMNQ9iTu4k2L4=;
        b=X/x+6euISk5lXb44RpqH6psBcuU/0mGHxgx0agbezF/aEeS1ju/Ja13o7i/0jdcgi8
         Mk8L8TAOGyZsJKcR5+9dY+eel6s4dmyGhF4ItN3KfFS1/B8TpMAJgv/Al5e9YNs+p5gn
         5/llwOBfxYqcCUf39JKSXRyGuovdUKiTipXaZMI+W7taS6pinfTnlrbQTDIwq8CWnjsj
         Dg56FqGaCt9GfWRAKOlJK3SEqLM375gQ/l6B25qZzy9F1nsucWyQdGZAiFBrICBwa2yi
         DNw2UqTB+fgbiJV7IOx0YFvtIT3G6c/N759qBizR1vXJ6M4C9Y/n4v+1F1u1Y17Nx2iR
         cKVA==
X-Gm-Message-State: AOAM533oLJmst3fCT+/1X0FTTAB8JHu+VznE9jn0kFwKN1/pvk15eLf4
        AvXb8ytimbvJuQKKt6DzSF45JLhUWuebXWsSUyIP57LH4jO1UuA5pJ1fVq8yHKKQVUdfvzpX8hH
        Y6keAHRj6vWpp
X-Received: by 2002:a05:6402:1e8d:b0:426:9:6ec with SMTP id f13-20020a0564021e8d00b00426000906ecmr11585687edf.55.1653062520124;
        Fri, 20 May 2022 09:02:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhHj6YIfLUk5rBhSx8O43idJGflulEgbY7ruZxdZu6XCMWwTYJfiqcAApD4G3IdesiPSCSdw==
X-Received: by 2002:a05:6402:1e8d:b0:426:9:6ec with SMTP id f13-20020a0564021e8d00b00426000906ecmr11585653edf.55.1653062519920;
        Fri, 20 May 2022 09:01:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id w5-20020aa7cb45000000b0042aa7e0f892sm4493657edt.15.2022.05.20.09.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 09:01:58 -0700 (PDT)
Message-ID: <667d0690-0391-1173-c65c-5b0316587553@redhat.com>
Date:   Fri, 20 May 2022 18:01:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>
References: <20220429210025.3293691-1-seanjc@google.com>
 <20220429210025.3293691-7-seanjc@google.com>
 <d84d9853-d055-50b6-669f-de2f24304f15@redhat.com>
 <Yoe5fkBzmnABpn2G@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 6/8] KVM: Fully serialize gfn=>pfn cache refresh via
 mutex
In-Reply-To: <Yoe5fkBzmnABpn2G@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/22 17:53, Sean Christopherson wrote:
>> Does kvm_gfn_to_pfn_cache_unmap also need to take the mutex, to avoid the
>> WARN_ON(gpc->valid)?
> I don't know What WARN_ON() you're referring to, but there is a double-free bug
> if unmap() runs during an invalidation.  That can be solved without having to
> take the mutex though, just reset valid/pfn/khva before the retry.

I was thinking of this one:

	/*
	 * Other tasks must wait for _this_ refresh to complete before
	 * attempting to refresh.
	 */
	WARN_ON_ONCE(gpc->valid);

but unmap sets gpc->valid to false, not true. ಠ_ಠ

Still, as you point out unmap() and refresh() can easily clash.  In 
practice they probably exclude each other by different means (e.g. 
running in a single vCPU thread), but then in practice neither is a fast 
path.  It seems easier to just make them thread-safe the easy way now 
that there is a mutex.

> When searching to see how unmap() was used in the original series (there's no
> other user besides destroy...), I stumbled across this likely-related syzbot bug
> that unfortunately didn't Cc KVM:-(

To give an example, VMCLEAR would do an unmap() if the VMCS12 was mapped 
with a gfn-to-pfn cache.

Paolo

