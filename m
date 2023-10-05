Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396AE7BA67E
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbjJEQfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjJEQdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:33:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB0519AA
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 09:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696522509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgTSYvwD64rrKsF1XVIJOmlwzW/iji6FtMxmxAcVjHg=;
        b=IgZJisMeWKGhRZl63aRMQ3HTgnk2p822J16lS8wBVmA9SUz/ZYzl21jFKifC4baMlU+K5f
        e7CpkZAZuxdIHCa1M/eKPkmhWiJeqdi/FqAvwzd2x7BYl9eTNQkRDCoVh1w8kj6/+ttgQQ
        Ln5LqgVXIwNJtVXGdNZYVNrhdie/B7E=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-tHfbG02XMZuliXkPH1pNwQ-1; Thu, 05 Oct 2023 12:15:08 -0400
X-MC-Unique: tHfbG02XMZuliXkPH1pNwQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9ae0bf9c0a9so90390066b.3
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 09:15:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696522507; x=1697127307;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xgTSYvwD64rrKsF1XVIJOmlwzW/iji6FtMxmxAcVjHg=;
        b=LjgWe3VWjY0HgmATJQAt45NYkVUqPBNuoq0umR72zL4Kriux4f6rYKV5rJBpoycMOv
         mKvt0yGjVH559pgL3TKAZ/FzsdhoyYjmxemH3vtsFtCkmG1y7zooia7BP2zJzQ2K61ho
         Xk7w6U4tkJqI/loqakQWsTxXOdOXO9/fG6tOlMHQn9gAAmsnWphGfRIL6LIGATRr3n7x
         oOnb14Gpz+EZflQzFRfU42MqnD1yQhDqr1b50HVIrwXA2Peu5zGBJEvEe2JWDriOSLQ4
         BYafvyIBXu0o+tv+GQbpzcuRCUw++RGNU3CbDrrVu2bAmftTOO4UBy8By58b/wqdK1vl
         frZA==
X-Gm-Message-State: AOJu0Yyv8FR19ft7MpwP4qT4yYLU7qx8XJIb5ClkQeA8W73gGRcLC5Ko
        mCcXSF/KhrrTyjJv6rMne89/qDO4LeIDc4Ki681urEiuo/1cKLBcSCU5GJTV42Pg5x6k6K5cqiI
        z+O/tDX7XfPVT
X-Received: by 2002:a17:906:2253:b0:9a1:debe:6b9b with SMTP id 19-20020a170906225300b009a1debe6b9bmr5105423ejr.35.1696522506883;
        Thu, 05 Oct 2023 09:15:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFcfUv5fTrG6MXf9M+oBt4Emd8GtKHsED+SgB8EkyegVBvHzKPW5E4hVWEpIzriQi7HM9VGw==
X-Received: by 2002:a17:906:2253:b0:9a1:debe:6b9b with SMTP id 19-20020a170906225300b009a1debe6b9bmr5105406ejr.35.1696522506501;
        Thu, 05 Oct 2023 09:15:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n2-20020a1709061d0200b009a0955a7ad0sm1399088ejh.128.2023.10.05.09.15.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 09:15:05 -0700 (PDT)
Message-ID: <ce8984c3-fd68-ae38-4eb6-4b4d3571b142@redhat.com>
Date:   Thu, 5 Oct 2023 18:15:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     "Mancini, Riccardo" <mancio@amazon.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Teragni, Matias" <mteragni@amazon.com>,
        "Batalov, Eugene" <bataloe@amazon.com>
References: <9d5ddfbe407940afa02567262a22fa4c@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
In-Reply-To: <9d5ddfbe407940afa02567262a22fa4c@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/23 17:08, Mancini, Riccardo wrote:
> Hi,
> 
> when a 4.14 guest runs on a 5.10 host (and later), it cannot use APF (despite
> CPUID advertising KVM_FEATURE_ASYNC_PF) due to the new interrupt-based
> mechanism 2635b5c4a0 (KVM: x86: interrupt based APF 'page ready' event delivery).
> Kernels after 5.9 won't satisfy the guest request to enable APF through
> KVM_ASYNC_PF_ENABLED, requiring also KVM_ASYNC_PF_DELIVERY_AS_INT to be set.
> Furthermore, the patch set seems to be dropping parts of the legacy #PF handling
> as well.
> I consider this as a bug as it breaks APF compatibility for older guests running
> on newer kernels, by breaking the underlying ABI.
> What do you think? Was this a deliberate decision?

Yes, this is intentional.  It is not a breakage because the APF 
interface only tells how asynchronous page faults are delivered; it 
doesn't promise that they are actually delivered.  However, I admit that 
the change was unfortunate.

Apart from the concerns about reentrancy, there were two more issues 
with the old API:

- the page-ready notification lacked an acknowledge mechanism if many 
pages became ready at the same time (see commit 557a961abbe0, "KVM: x86: 
acknowledgment mechanism for async pf page ready notifications").  This 
delayed the notifications of pages after the first.  The new API uses 
MSR_KVM_ASYNC_PF_ACK to fix the problem.

- the old API confused synchronous events (exceptions) with asynchronous 
events (interrupts); this created a unique case where a page fault was 
generated on a page that is not accessed by the instruction.  (The new 
API only fixes half of this, because it also has a bogus CR2, but it's a 
bit better).  It also meant that page-ready events were suppressed by 
disabled interrupts---but they were not necessarily injected when IF 
became 1, because KVM did not enable the interrupt window.  This is 
solved automatically by just injecting an interrupt.  On the theoretical 
side, it's also just ugly that page-ready events could only be 
enabled/disabled with CLI/STI and not APIC (TPR).

> Was this already reported in the past (I couldn't find anything in the mailing list
> but I might have missed it!)?
> Would it be much effort to support the legacy #PF based mechanism for older
> guests that choose to only set KVM_ASYNC_PF_ENABLED?

It is not hard.  However, I don't think we should accept such a patch 
upstream.

I do have a question for you.  Can you describe the context in which you 
are using APF, and would you be interested in ARM support?  We (Red Hat, 
not me the maintainer :)) have been trying to understand for a long time 
if cloud providers use or need APF.

Paolo

> The reason this is an issue for us now is that not having APF for older guests
> introduces a significant performance regression on 4.14 guests when paired to
> uffd handling of "remote" page-faults (similar to a live migration scenario)
> when we update from a 4.14 host kernel to a 5.10 host kernel.

