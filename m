Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5C41457E1
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAVOdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:33:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59370 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbgAVOdM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 09:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579703591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gRFnpY3I1mQxECqBRA9YuD/Lzsy9AbE9ywfF+lfpJFA=;
        b=MzbnTDh2bIIBjP76ji5lWlWOkKIH4Ahie33GNw3vlbpKkTg3p7ztghlJJrHWNTFCwa+j/0
        iP+DvB+8vvQHDTnMkTirAaXaN7XXyxVGDzPPEWdSrFUaa3pA1gIWCxcqfWtbxlmD4eMh6+
        bcl1X3ryT0dyOTLV5xMvGFeIQleCVg4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-jUu2KQWZPYiTmVdXY8YyZQ-1; Wed, 22 Jan 2020 09:33:09 -0500
X-MC-Unique: jUu2KQWZPYiTmVdXY8YyZQ-1
Received: by mail-wr1-f70.google.com with SMTP id t3so3110106wrm.23
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 06:33:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gRFnpY3I1mQxECqBRA9YuD/Lzsy9AbE9ywfF+lfpJFA=;
        b=qWSBfw3j3USG+klCxhVGYuxowjQOtDP1iEE4NiklGaVH/i1msdfLIX25umum14D7Vm
         EmURYWRc/NLmok1nOsHWhH/ialF+Bo+8M8eg46gbhADTWRW/ArfgJIdbCfq8DCAfYt/S
         15naCxeWmwS0Q1fr7TkWVziC3Q55oFtOV7hAOIJjXbDrafxWlmw8Qoh7WBFLLYmuVx2t
         ZY9vTLUQE4/LcoLuFLmlBnijRQIFVqRhurXP5UGBmHNIgiOU5bUbtBaDdZ4njn/9WzdC
         FQthTZfxN9RwjiSznepALjJlVvooE3ybnBjkPGxqcxovOQwA/M6zJi5Fv7rbEKSaM1C9
         n/Fw==
X-Gm-Message-State: APjAAAVLPEm71kMdck8hrxcgpWm8YoNEa+7WSoimrMBIEhtNzUCWkgBy
        oot+XWUDcN9jooHPKOAmoK2rr/We7w9vHoOLOmgZlpKr2NPoHtFDBXfQ1H0aZUTc6Mh3k+nH87J
        H7I7mFmnDEaO5
X-Received: by 2002:adf:fa43:: with SMTP id y3mr11489093wrr.65.1579703588394;
        Wed, 22 Jan 2020 06:33:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqy493qQHDX3PVeoY+2xNICZ5ZfX0FyYZCJQKPOoeu08Z68D031Gpyxu56Wp6q6abn1GUU0+Ww==
X-Received: by 2002:adf:fa43:: with SMTP id y3mr11489067wrr.65.1579703588121;
        Wed, 22 Jan 2020 06:33:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id e12sm57096696wrn.56.2020.01.22.06.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:33:07 -0800 (PST)
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
 <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com>
 <20200122054724.GD18513@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com>
Date:   Wed, 22 Jan 2020 15:33:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200122054724.GD18513@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/20 06:47, Sean Christopherson wrote:
>> Yes, it most likely is and it would be nice if Microsoft fixed it, but I
>> guess we're stuck with it for existing Windows versions.  Well, for one
>> we found a bug in Hyper-V and not the converse. :)
>>
>> There is a problem with this approach, in that we're stuck with it
>> forever due to live migration.  But I guess if in the future eVMCS v2
>> adds an apic_address field we can limit the hack to eVMCS v1.  Another
>> possibility is to use the quirks mechanism but it's overkill for now.
>>
>> Unless there are objections, I plan to apply these patches.
> Doesn't applying this patch contradict your earlier opinion?  This patch
> would still hide the affected controls from the guest because the host
> controls enlightened_vmcs_enabled.

It does.  Unfortunately the key sentence is "we're stuck with it for
existing Windows versions". :(

> Rather than update vmx->nested.msrs or filter vmx_get_msr(), what about
> manually adding eVMCS consistency checks on the disallowed bits and handle
> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES as a one-off case by simply
> clearing it from the eVMCS?  Or alternatively, squashing all the disallowed
> bits.

Hmm, that is also a possibility.  It's a very hacky one, but I guess
adding APIC virtualization to eVMCS would require bumping the version to
2.  Vitaly, what do you think?

Paolo

