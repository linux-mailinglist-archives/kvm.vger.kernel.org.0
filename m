Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EC03E56C8
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbhHJJZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:25:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238988AbhHJJZ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 05:25:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628587534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RB6Pczk4vDPwq2uSGWS6COud14iPXuDOTUgBGUDVOs=;
        b=CUQi/Vwnyk3GKIC0Jl47AwPd/Oin74rdJ1iYgJm3AACg50M5gCsoxb759WlN0vwp6liUdJ
        LIedfvX5czi2HOjm0+8lKSJ8sFunx/PGbC32FkNxmtypccrjrzRRLHSY78G9odFMnbbN2c
        krpBuv/gxj7FpNJsFAt3ZYMc1uRQc18=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-EDpvg2_1PBKKyxJRMuqzhw-1; Tue, 10 Aug 2021 05:25:30 -0400
X-MC-Unique: EDpvg2_1PBKKyxJRMuqzhw-1
Received: by mail-ej1-f72.google.com with SMTP id h17-20020a1709070b11b02905b5ced62193so320986ejl.1
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 02:25:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9RB6Pczk4vDPwq2uSGWS6COud14iPXuDOTUgBGUDVOs=;
        b=WODNueZkVpbTfIO/SPX9rzJulWMWCzd7JwNnqVvAvO40Y+i71UN1lTGxs0lO2ZQ/BL
         qNe0OWRCjtCyQNyZZHv+5EgyH8j7u4xhUzrjIfW9rBhOYCK7lpeB89RMyv68hol1He3U
         NegtTMXRLq4NrYXOUfZbSDIT3iEz1miaH9XoXDATq81WPu6aciNrqaG8QuV1w90rQ69x
         NjIZwCETb7JjmEoX7puZigwnIXkLTHicd2sHDT13754Fv5VFNbWwVg42J40WfiOhkzuR
         Kzmh7rsqW3FfUjkT+sbQNL581BLTsGBzs/EdoPXEh7YSQOxH7PWci1dGhWUUxg7EHe8j
         iw4g==
X-Gm-Message-State: AOAM5315n73ttwYGnWG/qirvJ4MjyqUZplJNT5j8iSBMZhllID4Bz1Rk
        mBZBzrF8JsxrGGDgEA55barSqvnQGmC4xpP7UNBMm51BC+EKDnuq+GnHoP3jSLDgHfoXKzq/0ep
        nSII7qUUQt7FE
X-Received: by 2002:a17:906:1412:: with SMTP id p18mr403413ejc.545.1628587529793;
        Tue, 10 Aug 2021 02:25:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdtVhsz6duqdq2TK6WgLYxnxtIAyk8aZC40PfN4pZYSJW6GS3DgxOlNPPOp8fH24wM2t3hCA==
X-Received: by 2002:a17:906:1412:: with SMTP id p18mr403396ejc.545.1628587529632;
        Tue, 10 Aug 2021 02:25:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id c17sm844174edu.11.2021.08.10.02.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:25:28 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
To:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-2-wei.huang2@amd.com>
 <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
 <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
 <20210809042703.25gfuuvujicc3vj7@linux.intel.com>
 <73bbaac0-701c-42dd-36da-aae1fed7f1a0@amd.com>
 <20210809064224.ctu3zxknn7s56gk3@linux.intel.com>
 <YRFKABg2MOJxcq+y@google.com>
 <20210810074037.mizpggevgyhed6rm@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0ac41a07-beeb-161e-9e5d-e45477106c01@redhat.com>
Date:   Tue, 10 Aug 2021 11:25:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210810074037.mizpggevgyhed6rm@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/21 09:40, Yu Zhang wrote:
> About "host can't easily mirror L1's desired paging mode", could you please elaborate?
> Thanks!

Shadow pgae tables in KVM will always have 3 levels on 32-bit machines 
and 4/5 levels on 64-bit machines.  L1 instead might have any number of 
levels from 2 to 5 (though of course not more than the host has).

Therefore, when shadowing 32-bit NPT page tables, KVM has to add extra 
fixed levels on top of those that it's shadowing.  See 
mmu_alloc_direct_roots for the code.

Paolo

