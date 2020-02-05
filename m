Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1A01535AF
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 17:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgBEQzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 11:55:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35070 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727471AbgBEQzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 11:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580921752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k4MVBpJvu2dSV+rRvdIP9GW4lozYekAvYZ8weTGnL0Q=;
        b=gdGShX0JztpDvtezh/AwOu5deKmpDgKkHvkcQMMAebcAuYYCAoJm943VZ+SjB4sDeQ8PyU
        8UyHGViJF8sOGPARi8E3xNpRO6bq9QJTUgM3o1pMhraJk5OvNiqMM3YlpBYAxKJImqvvtD
        CYK+jcm7KtOkNHgL5UktEvgZpLT33NI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-sSQuxdHxMjmPBOzXAKdjTg-1; Wed, 05 Feb 2020 11:55:35 -0500
X-MC-Unique: sSQuxdHxMjmPBOzXAKdjTg-1
Received: by mail-wm1-f69.google.com with SMTP id l11so2175998wmi.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 08:55:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k4MVBpJvu2dSV+rRvdIP9GW4lozYekAvYZ8weTGnL0Q=;
        b=Gl5JIPkq4CcrSiRaPdSC7bvv4X5ZUX12fTvsvnbrVzMKUjLNmKFAYLl399r58e2ESZ
         uoLl1Klt99AyNznBa+3XGJOP+YegRbUOwXydFaFMKDeSs8nRsaYWswxZM6DLMcgHXi2O
         J7tlSjFbDZHFhlKOvwbfAHVMzmnZCoKIeZAXXs6qNMqwND1rIUdx2MkZGXhkV+KhOw3A
         bU9tnrEm0ZNi98cKSDf7dXOlGVg7zhXenY7lQb/vcxxJVKFAeD5vyhNcyoiduQYkhbQY
         sS/YATbDTpUSo33WFMjmbSUIL/A/IWh5JqQ++zndMVQvKCORHXBSAS2GDEptv3wNfPFk
         qR+g==
X-Gm-Message-State: APjAAAVQnPfuN4SwTPmZZ3y8vObOkqymL6OxQ5Jnpm1jAs72IpTmXVMT
        q/CCWuZrpirwDA5ccstILz7CF4yRan2WbdaPtw1HTjONPrzTsqMz0ZKFlg8bAiMWUGZYrQwwk/L
        apz1wLCn9IMZa
X-Received: by 2002:a5d:5345:: with SMTP id t5mr31667144wrv.0.1580921734228;
        Wed, 05 Feb 2020 08:55:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQQGZFn8f+vjgX1oOiNfRFBunHlzYyc7eIL09p/fJ5XAIKuxHd5/z7XrQWRsaDossHo7DJAg==
X-Received: by 2002:a5d:5345:: with SMTP id t5mr31667128wrv.0.1580921734068;
        Wed, 05 Feb 2020 08:55:34 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 18sm209330wmf.1.2020.02.05.08.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 08:55:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/26] KVM: x86: Add a kvm_x86_ops hook to query virtualized MSR support
In-Reply-To: <20200205153508.GD4877@linux.intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com> <20200129234640.8147-5-sean.j.christopherson@intel.com> <87eev9ksqy.fsf@vitty.brq.redhat.com> <20200205145923.GC4877@linux.intel.com> <8736bpkqif.fsf@vitty.brq.redhat.com> <20200205153508.GD4877@linux.intel.com>
Date:   Wed, 05 Feb 2020 17:55:32 +0100
Message-ID: <87tv45j7nf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Wed, Feb 05, 2020 at 04:22:48PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > On Wed, Feb 05, 2020 at 03:34:29PM +0100, Vitaly Kuznetsov wrote:
>> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> >> 
>> >> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> >
>> > Stooooooop!  Everything from this point on is obsoleted by kvm_cpu_caps!
>> >
>> 
>> Oops, this was only a week old series! Patches are rottening fast
>> nowadays!
>
> Sorry :-(
>
> I dug deeper into the CPUID crud after posting this series because I really
> didn't like the end result for vendor-specific leafs, and ended up coming
> up with (IMO) a much more elegant solution.
>
> https://lkml.kernel.org/r/20200201185218.24473-1-sean.j.christopherson@intel.com/
>
> or on patchwork
>
> https://patchwork.kernel.org/cover/11361361/
>

Thanks, I saw it. I tried applying it to kvm/next earlier today but
failed. Do you by any chance have a git branch somewhere? I'll try to
review it and test at least AMD stuff (if AMD people don't beat me to it
of course).

-- 
Vitaly

