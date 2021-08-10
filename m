Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558073E8129
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhHJR4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:56:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235858AbhHJRwj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 13:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628617937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STMh8gJqmKyXOQZo1gdtsUy8eb0agOWAa3MJ0LNn1RE=;
        b=NpDIi5NEc0yDgfK5F+k+rsv96cM1VbkTtQSd1e3Gnf1NFngvfwjzPB6BhuFK2KNpWs9J1F
        Bj+zvMG2KNX8TzxPQ6JONK+/LtB+Ki5uyifqzLVKJyari0BkNmUrg1c/1tBIoLn6k6PKzz
        ypwTQqhdrqOfb7OuKBm2VJ8Pn2Hwryw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-DTntFms1NROyQxCfjNgNaw-1; Tue, 10 Aug 2021 13:52:16 -0400
X-MC-Unique: DTntFms1NROyQxCfjNgNaw-1
Received: by mail-ed1-f71.google.com with SMTP id b25-20020a05640202d9b02903be7281a80cso2555029edx.3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=STMh8gJqmKyXOQZo1gdtsUy8eb0agOWAa3MJ0LNn1RE=;
        b=TEuj+lHNdKst+5guPXeK3y65zIRBY08SX33SKlrPwDwTlZku5WxcNtTbTiJIGBBJHP
         komiqskiJHQsqgkzKFlAAYOVcvi21S10RJhXqTEti/si6FtEflD00FbGRV/ELT0nkR6j
         YKWfsIEygvRpjuaQpC3gEcVgRJEwDdpTuD6EeVxVsWaVpS6Pfve9kiv7zPUxZEB7BrEi
         WCNEkyCxuti/IftpXfAyI7/hZw1EaMUT6RyRRRNDUFogNvz8i0ayUatT8bCxVtrLfHZJ
         nzkFWjMYqYI8CCv9xIsGC0I8N6D8Sq1oRChVvuTgAIey6xZOOj2StPNY5HlOm7uuN3cY
         lZaw==
X-Gm-Message-State: AOAM532Wtj0jyFaxBPIPtJU6Oc4uF2zal/kzWutdjmjVrjB5Je8Td1v3
        BJhT8Lnj2O2hGrdgcpYMUfirZcFIQRxnKVtEEQZuRPoI33rjKYdTbgcFSSwMlrYGkQZgGZnX8nN
        tEsTEg03i2u7C
X-Received: by 2002:a05:6402:4246:: with SMTP id g6mr6309751edb.95.1628617934728;
        Tue, 10 Aug 2021 10:52:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfuWR9wDNg3t60511GwMmS+ZqGMITxl1D6QPxpaO//aeJlWTd08Bjy2Rt419y8hVgcbKKvzQ==
X-Received: by 2002:a05:6402:4246:: with SMTP id g6mr6309705edb.95.1628617934516;
        Tue, 10 Aug 2021 10:52:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a3sm2173658edu.46.2021.08.10.10.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:52:13 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, bgardon@google.com,
        pshier@google.com
References: <20210806222229.1645356-1-junaids@google.com>
 <YRG7U3b3ZM17ggp4@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: vmx: Sync all matching EPTPs when injecting nested
 EPT fault
Message-ID: <89c2d9da-590b-fb03-405c-4b16f2aff090@redhat.com>
Date:   Tue, 10 Aug 2021 19:52:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRG7U3b3ZM17ggp4@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/21 01:33, Sean Christopherson wrote:
> On Fri, Aug 06, 2021, Junaid Shahid wrote:
>> When a nested EPT violation/misconfig is injected into the guest,
>> the shadow EPT PTEs associated with that address need to be synced.
>> This is done by kvm_inject_emulated_page_fault() before it calls
>> nested_ept_inject_page_fault(). However, that will only sync the
>> shadow EPT PTE associated with the current L1 EPTP. Since the ASID
> 
> For the changelog and the comment, IMO using "vmcs12 EPTP" instead of "L1 EPTP"
> would add clarity.  I usually think of "L1 EPTP" as vmcs01->eptp and "L2 EPTP"
> as vmcs02->EPTP.  There are enough EPTPs in play with nested that it'd help to
> be very explicit.

Or more briefly "EPT12".

>> is based on EP4TA rather than the full EPTP, so syncing the current
>> EPTP is not enough. The SPTEs associated with any other L1 EPTPs
>> in the prev_roots cache with the same EP4TA also need to be synced.
> 
> No small part of me wonders if we should disallow duplicate vmcs12 EP4TAs in a
> single vCPU's root cache, e.g. purge existing roots with the same pgd but
> different role.  INVEPT does the right thing, but that seems more coincidental
> than intentional.
> 
> Practically speaking, this only affects A/D bits.  Wouldn't a VMM need to flush
> the EP4TA if it toggled A/D enabling in order to have deterministic behavior?
> In other words, is there a real world use case for switching between EPTPs with
> same EP4TAs but different properties that would see a performance hit if KVM
> purged unusable cached roots with the same EP4TA?

Probably not, but the complexity wouldn't be much different.

Paolo

