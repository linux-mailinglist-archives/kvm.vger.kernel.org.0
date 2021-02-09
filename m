Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5473149B0
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 08:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhBIHse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 02:48:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhBIHsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 02:48:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612856808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60Yl/vDmWhz8mPXWE8Nyh/nzPl1IEHtsGhYX5nxRI0s=;
        b=G5fkCsmoHIDPioNq5xYyC3EIboZ+URIKYJSQ4DyVNhMpPW2+lHHWejZHi3eJWHvOXzv6e7
        K70RMVs+fOFDbZ8O/9dwW/duSSLqrzde2A6CCdDlRoY2nQFHY+xDWfN6ywA1OKWtchqGBv
        XAY/Hzo9MrMZdcc89xEG4kxdcV9Qkew=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-oDnbKQnrOGGFaOoLhH2pfA-1; Tue, 09 Feb 2021 02:46:46 -0500
X-MC-Unique: oDnbKQnrOGGFaOoLhH2pfA-1
Received: by mail-wm1-f71.google.com with SMTP id y9so1797312wmj.7
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 23:46:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60Yl/vDmWhz8mPXWE8Nyh/nzPl1IEHtsGhYX5nxRI0s=;
        b=CNgMwyHylkEA/FFuxHu0e+XpYAtHwbuhrdQ9UJzLKkzQ3RWySqdBERPiqpMF+Ilbs5
         7u0GXoyhpEpF4Atak8+CLw7DmqnC3yFL7GknyZkhm6Xtax9LReElpXOL8ZJhxCLZTr02
         1ufPLSVSzdmXbX+ISSq2cSu3zRwBgdMqJkOHX+vJTt/WkTBD+/OyQ6KMG7MOdk5Fi/dV
         TMhTZhnJSoU9FyVoqrvv2xpPvE8SIvuJwcLdyTYGMc6g9FjUzkpHZ09khttJ3L2iApwG
         uo+VLI4JssRCgOkCBVePFE3yrAf8otnByU1Fox7T1dWgTuE+yd+ns+pcCTQtg8k/uHQz
         DBKw==
X-Gm-Message-State: AOAM531KWoUn4C3b7qvUjyB6NY0ww+GOS0PFt7Hm9fQ69YSYsp62l7CE
        Jh5gJBn1P7TxSirmtnkKNKodQ6Jv2EH0bwWZF67UAXU9NGHJKnFA675tdnle6sTMqsIOj8qybSf
        oPdTfqP90P5ve
X-Received: by 2002:a1c:7f4a:: with SMTP id a71mr2150312wmd.92.1612856805052;
        Mon, 08 Feb 2021 23:46:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwj6liW9hyxjHByLK8Qc6qMnvgWOabUHGWBhV1hhcFdO2HPRd3a01X3y3tPTQLMty+2i3lDHA==
X-Received: by 2002:a1c:7f4a:: with SMTP id a71mr2150288wmd.92.1612856804802;
        Mon, 08 Feb 2021 23:46:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u14sm2837840wmq.45.2021.02.08.23.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 23:46:43 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86/MMU: Do not check unsync status for root SP.
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
References: <20210207122254.23056-1-yu.c.zhang@linux.intel.com>
 <671ae214-22b9-1d89-75cb-0c6da5230988@redhat.com>
 <20210208134923.smtvzeonvwxzdlwn@linux.intel.com>
 <404bce5c-19ef-e103-7b68-5c81697d2a1f@redhat.com>
 <20210209033319.w6nfb4s567zuly2c@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6ca2d73c-703a-9964-48ae-e3d910bebc48@redhat.com>
Date:   Tue, 9 Feb 2021 08:46:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210209033319.w6nfb4s567zuly2c@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/21 04:33, Yu Zhang wrote:
> On Mon, Feb 08, 2021 at 05:47:22PM +0100, Paolo Bonzini wrote:
>> On 08/02/21 14:49, Yu Zhang wrote:
>>> On Mon, Feb 08, 2021 at 12:36:57PM +0100, Paolo Bonzini wrote:
>>>> On 07/02/21 13:22, Yu Zhang wrote:
>>>>> In shadow page table, only leaf SPs may be marked as unsync.
>>>>> And for non-leaf SPs, we use unsync_children to keep the number
>>>>> of the unsynced children. In kvm_mmu_sync_root(), sp->unsync
>>>>> shall always be zero for the root SP, , hence no need to check
>>>>> it. Instead, a warning inside mmu_sync_children() is added, in
>>>>> case someone incorrectly used it.
>>>>>
>>>>> Also, clarify the mmu_need_write_protect(), by moving the warning
>>>>> into kvm_unsync_page().
>>>>>
>>>>> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
>>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>>
>>>> This should really be more of a Co-developed-by, and there are a couple
>>>> adjustments that could be made in the commit message.  I've queued the patch
>>>> and I'll fix it up later.
>>>
>>> Indeed. Thanks for the remind, and I'll pay attention in the future. :)
>>
>> Also:
>>
>> arch/x86/kvm/mmu/mmu.c: In function ‘mmu_sync_children’:
>> arch/x86/kvm/mmu/mmu.c:2002:17: error: ‘sp’ is used uninitialized in this
>> function [-Werror=uninitialized]
>>    WARN_ON_ONCE(sp->unsync);
> 
> Oops. This is wrong. Should be WARN_ON_ONCE(parent->unsync);
> 
>>
>> so how was this tested?
>>
> 
> I ran access test in kvm-unit-test for previous version, which hasn't
> this code(also in my local repo "enable_ept" was explicitly set to
> 0 in order to test the shadow mode). But I did not test this one. I'm
> truely sorry for the negligence - even trying to compile should make
> this happen!
> 
> Should we submit another version? Any suggestions on the test cases?

Yes, please send v3.

The commit message can be:

In shadow page table, only leaf SPs may be marked as unsync; instead, 
for non-leaf SPs, we store the number of unsynced children in 
unsync_children.  Therefore, in kvm_mmu_sync_root(), sp->unsync
shall always be zero for the root SP and there is no need to check
it.  Remove the check, and add a warning inside mmu_sync_children() to 
assert that the flags are used properly.

While at it, move the warning from mmu_need_write_protect() to 
kvm_unsync_page().

Paolo

