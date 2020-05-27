Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156391E3C3C
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388165AbgE0Ijm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:39:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32646 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387858AbgE0Ijk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 04:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590568779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5CtVNmzXXKb/GJnyK3cmtp2ErHYUKsptEP9TQUHQbxw=;
        b=G6qMI0JXsaEA95oPVcjzNX79Go3SDGiFDpal7vxbO2y4h8ho3U/KFii69k6zYtjqj9VLdg
        HnXc3RqgI2/u9p6fwj8gdtrYyxrK1ybmE9SZvFudCMKjaRVksrvo8A3SEl6mMIHNvDeU4H
        NoEqqriNzM/HOfwc43jpJ0sAAofe5E8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-__1FLqqZOHyotCzWkENa8g-1; Wed, 27 May 2020 04:39:37 -0400
X-MC-Unique: __1FLqqZOHyotCzWkENa8g-1
Received: by mail-ej1-f70.google.com with SMTP id ng1so8498846ejb.22
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 01:39:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5CtVNmzXXKb/GJnyK3cmtp2ErHYUKsptEP9TQUHQbxw=;
        b=o+/5yZXlEAEe2yxFeOIOMQQjQ9Tv1ErlA3w0HmvCOGSPPLugALKRrd4X1Dx4PXeqIS
         +vZACq0ZShuvO7BFiM2Dz3W6u256+6RqkUBJu7pa5FdKCc25FegKdJDIQ4nAve7iwPeo
         2gKIqyVrqpnJv24eNB3ikHxQ88PrtMdzfBq0XpIK3vk5LIdhhhF6lV+RNtR36+MNAOFv
         5smtSjr5f4WH5dlWfKA8qVKzoiRXNgt80LhDam9ueICmEhYb/K2ZV8Vq18ygm/ZWMl/b
         UcSNgabP/qsrQMPPPnPsy9PQItz5FAY/dQYGPJDrd2hy98yLZ2ZiLgoIq8Xi/riWWcvQ
         BslA==
X-Gm-Message-State: AOAM532Ry2RRvFBvs6xYnFKXF/3kn/X5Uf2YvgiB1hezAzGLCtcs0q4Y
        4ISyUGUBqWwyvmn3wJHseRA3FUlMEYsKIuAAPlB+fh2pE7qyUkY6CHDeJf+KfQJ2QZNpccBi0pe
        kWElAf30dG6BE
X-Received: by 2002:a17:906:3b9a:: with SMTP id u26mr4827600ejf.456.1590568776132;
        Wed, 27 May 2020 01:39:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwp2aIsA3XEwQ6IIPY4EvLkOvUOmXFr3P4IIB2DE6c8rBlbscdO/yOITd5hElHhUs1XcB7/yQ==
X-Received: by 2002:a17:906:3b9a:: with SMTP id u26mr4827580ejf.456.1590568775832;
        Wed, 27 May 2020 01:39:35 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s19sm2124076eja.91.2020.05.27.01.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 01:39:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 02/16] x86/kvm: Introduce KVM memory protection feature
In-Reply-To: <20200527050350.GK31696@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com> <20200522125214.31348-3-kirill.shutemov@linux.intel.com> <87d06s83is.fsf@vitty.brq.redhat.com> <20200525151525.qmfvzxbl7sq46cdq@box> <20200527050350.GK31696@linux.intel.com>
Date:   Wed, 27 May 2020 10:39:33 +0200
Message-ID: <87eer56abe.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, May 25, 2020 at 06:15:25PM +0300, Kirill A. Shutemov wrote:
>> On Mon, May 25, 2020 at 04:58:51PM +0200, Vitaly Kuznetsov wrote:
>> > > @@ -727,6 +734,15 @@ static void __init kvm_init_platform(void)
>> > >  {
>> > >  	kvmclock_init();
>> > >  	x86_platform.apic_post_init = kvm_apic_init;
>> > > +
>> > > +	if (kvm_para_has_feature(KVM_FEATURE_MEM_PROTECTED)) {
>> > > +		if (kvm_hypercall0(KVM_HC_ENABLE_MEM_PROTECTED)) {
>> > > +			pr_err("Failed to enable KVM memory protection\n");
>> > > +			return;
>> > > +		}
>> > > +
>> > > +		mem_protected = true;
>> > > +	}
>> > >  }
>> > 
>> > Personally, I'd prefer to do this via setting a bit in a KVM-specific
>> > MSR instead. The benefit is that the guest doesn't need to remember if
>> > it enabled the feature or not, it can always read the config msr. May
>> > come handy for e.g. kexec/kdump.
>> 
>> I think we would need to remember it anyway. Accessing MSR is somewhat
>> expensive. But, okay, I can rework it MSR if needed.
>
> I think Vitaly is talking about the case where the kernel can't easily get
> at its cached state, e.g. after booting into a new kernel.  The kernel would
> still have an X86_FEATURE bit or whatever, providing a virtual MSR would be
> purely for rare slow paths.
>
> That being said, a hypercall plus CPUID bit might be better, e.g. that'd
> allow the guest to query the state without risking a #GP.

We have rdmsr_safe() for that! :-) MSR (and hypercall to that matter)
should have an associated CPUID feature bit of course.

Yes, hypercall + CPUID would do but normally we treat CPUID data as
static and in this case we'll make it a dynamically flipping
bit. Especially if we introduce 'KVM_HC_DISABLE_MEM_PROTECTED' later.

>
>> Note, that we can avoid the enabling algother, if we modify BIOS to deal
>> with private/shared memory. Currently BIOS get system crash if we enable
>> the feature from time zero.
>
> Which would mesh better with a CPUID feature bit.
>

And maybe even help us to resolve 'reboot' problem.

-- 
Vitaly

