Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4490815A253
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 08:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgBLHo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 02:44:29 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58320 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728311AbgBLHo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 02:44:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581493466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g67JW6PCjzPFY0JeUKVhTRxxURvlw/u8govktNjV/gc=;
        b=CSpQ1l3F0bbmbNHjnjjO6saGetaEI9+o60pDlpoEPtWpPlHNI2+KAYnmio7GEiI9sreu/y
        mwQfB8gUeI/L3i+O4Zm7Q26OA48cjmS43VFz2R5RfDxQFpIDL6C23z2xSkU1usz/H7j7ud
        HfpeJ7fmrP14kFa7aDIrpdJnnMPawYs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-ePP7S-TkOhKPIxj8ioGpgQ-1; Wed, 12 Feb 2020 02:44:23 -0500
X-MC-Unique: ePP7S-TkOhKPIxj8ioGpgQ-1
Received: by mail-wr1-f70.google.com with SMTP id w6so461919wrm.16
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 23:44:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g67JW6PCjzPFY0JeUKVhTRxxURvlw/u8govktNjV/gc=;
        b=Qm+uEnRbiI8wk/9UvfNsc/NFVpRRjquA3fZm/kw7w7WPE1+kF5ptHMi41aJozVCGF9
         vvibTYD4gy37ZH9B7UlYNy0yw8gm+RR+JSUXYJk7u162Tt9xexn9oor/htdb7cegHBlU
         yD1i47ZdF5Pl8Yrn9Kn/Ih/hVpZpnzunyFqD6HKFRTANhoJ7m+HjaDQ1iPfdErTQIhzU
         9JTyqyAkcbuc3Io9rU275fnWhN21Rfv9aF2Pw1lRviEhKygIz5/Q/du4yQLHlclkfqvq
         Qy/8QJ4u/pwNp69x98dhj4iKmG73JcU4fCOGSvPoMt77Vi4OxrI309Z8lJnuKIrJUNAA
         +Qxw==
X-Gm-Message-State: APjAAAVKfbnsF5mzLmDNAzD0ItJfQSs9VYDrOmwAmLTe8cG7peODIjJF
        Th6jni4mb4qHutbzYeIHvElCdwsc3r95JbOALExTYC1UJyx72ceRwaoOgUG2B4CmXXE5QiPjFO6
        WXsIv/H/DjPlr
X-Received: by 2002:a1c:4e01:: with SMTP id g1mr10562977wmh.12.1581493462618;
        Tue, 11 Feb 2020 23:44:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqyRHiPRH64HlUiSRMYtcJAOFfNmBT5P+vp6Nwrf0t8K92gPacb6XCWJ/IyVdUV+r6f8oytxyg==
X-Received: by 2002:a1c:4e01:: with SMTP id g1mr10562225wmh.12.1581493454694;
        Tue, 11 Feb 2020 23:44:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id r3sm8820670wrn.34.2020.02.11.23.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 23:44:14 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: do not reset microcode version on INIT or RESET
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1581444279-10033-1-git-send-email-pbonzini@redhat.com>
 <20200211223837.GC21526@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <988c9422-52d2-f544-c703-b3ec6274e2be@redhat.com>
Date:   Wed, 12 Feb 2020 08:44:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200211223837.GC21526@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/02/20 23:38, Sean Christopherson wrote:
> On Tue, Feb 11, 2020 at 07:04:39PM +0100, Paolo Bonzini wrote:
>> The microcode version should be set just once, since it is essentially
>> a CPU feature; so do it on vCPU creation rather than reset.
> I wouldn't call it a CPU feature, CPU features generally can't be
> arbitrarily changed while running.

That was true of CPUID bits too until microcode started adding and
removing them, but I see your point. :)  What I was trying to convey as
"CPU feature" is that KVM will not change it arbitrarily when running;
it can only change as a result of userspace actions, KVM_SET_MSRS in
this case.  But yes, I will improve the text based on your version:

---
Do not initialize the microcode version at RESET or INIT, only on vCPU
creation.   Microcode updates are not lost during INIT, and exact
behavior across a warm RESET is not specified by the architecture.

Since we do not support a microcode update directly from the hypervisor,
but only as a result of userspace setting the microcode version MSR,
it's simpler for userspace if we do nothing in KVM and let userspace
emulate behavior for RESET as it sees fit.
---

Thanks,

Paolo

> I'd prefer to have a changelog that
> at least somewhat ties the change to hardware behavior. 
> 
>   Do not initialize the microcode version at RESET or INIT.   Microcode
>   updates are not lost during INIT, and exact behavior across a warm RESET
>   is microarchitectural, i.e. defer to userspace to emulate behavior for
>   RESET as it sees fit.
> 
> For the code:

