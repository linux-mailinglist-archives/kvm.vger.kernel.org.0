Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548BF13CBEC
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgAOSRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:17:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44347 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728921AbgAOSRd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 13:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579112252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MTOIMdw+nQ/QCfAVH0L+SryIoSP15eSfsBn1/tpu/8g=;
        b=b2aJ78p/NxBfAHL2PMA33kWQGhYelx90fWos+qtXVBqKlEO7MIuMqki2GuE4KTf87uwHVd
        XhtyB+Y0qQcbHDZ8rZclirgWlqFdlRe/7wB+XLRuuZBEodHlzLkY6kUcdjqsU3Km4eFv+q
        ZGr4F8+GX0nXzUG4Ku62XN/L4quwb7Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-BhzG-HTrPaixDdZSBgepwQ-1; Wed, 15 Jan 2020 13:17:31 -0500
X-MC-Unique: BhzG-HTrPaixDdZSBgepwQ-1
Received: by mail-wr1-f70.google.com with SMTP id o6so8258920wrp.8
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:17:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MTOIMdw+nQ/QCfAVH0L+SryIoSP15eSfsBn1/tpu/8g=;
        b=lnsGQJbOCDufgXWzaz6coKNCmYKSTHR8EtlOrm0kUJKYj5WtEdqcpsUd63MrUVkduV
         d6aBaxHWv+Z+U4FQRIinv5r6VaaalSiObVs1N7tmHBgGbIwbQ3ZOCVPUlvU4ra7N/+qx
         vklbunyxGs+RMBMzf8sIkdK6EOX5ezwOhHQyjp1EItvh1XK5I2sgpQlpe4dzDzOnKxgV
         a6Ba39qHzDh4ymfAjYf5SFPjnmHUsWo/fuhuODKwMOmNkG+5LGHdJ0sX5FFxXLRZ8agh
         nz6k4MUnRX2sJH4d9d+3QScrSEW1nzWFGaTEVyE+ncov3d/gJnU4hWbFdq/EMX7MlLKg
         YxSA==
X-Gm-Message-State: APjAAAURQiw/Xb2v7vjKNl2xjVNSLSFVpqA9MuIVdgdADrouU/+u0fJO
        yFiI/c8Pl2koxNkTBFY0+DDfsOrKtjwSdlIKBE8WX0iTx3tIiMyQmC5tJG+GLYBkrGPy9JkSlLh
        64pu3UiFaUaLf
X-Received: by 2002:a05:600c:2c08:: with SMTP id q8mr1231100wmg.45.1579112249940;
        Wed, 15 Jan 2020 10:17:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqzztdIBb2gpjavGfEL7Yhh3wdfSdVaRcFOFyEfxNfeJzsz4JhL1QN6fYW1ZxvEuy8od6HLJqA==
X-Received: by 2002:a05:600c:2c08:: with SMTP id q8mr1231084wmg.45.1579112249757;
        Wed, 15 Jan 2020 10:17:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id j12sm25880146wrt.55.2020.01.15.10.17.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:17:29 -0800 (PST)
Subject: Re: [PATCH v2 2/2] KVM: x86/mmu: Micro-optimize nEPT's bad
 memptype/XWR checks
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        Arvind Sankar <nivedita@alum.mit.edu>
References: <20200109230640.29927-1-sean.j.christopherson@intel.com>
 <20200109230640.29927-3-sean.j.christopherson@intel.com>
 <878smfr18i.fsf@vitty.brq.redhat.com>
 <20200110160453.GA21485@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f23a2801-d33d-4c2d-290e-60b0fa142cb5@redhat.com>
Date:   Wed, 15 Jan 2020 19:17:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200110160453.GA21485@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/20 17:04, Sean Christopherson wrote:
> Ya, I don't love the code, but it was the least awful of the options I
> tried, in that it's the most readable without being too obnoxious.
> 
> 
> Similar to your suggestion, but it avoids evaluating __is_bad_mt_xwr() if
> reserved bits are set, which is admittedly rare.
> 
> 	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level)
> #if PTTYPE == PTTYPE_EPT
> 	       || __is_bad_mt_xwr(&mmu->guest_rsvd_check, gpte)
> #endif
> 	       ;
> 
> Or macrofying the call to keep the call site clean, but IMO this obfuscates
> things too much.
> 
> 	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level) ||
> 	       IS_BAD_MT_XWR(&mmu->guest_rsvd_check, gpte);

I think what you posted is the best (David's comes second).

Queued, thanks.

Paolo

