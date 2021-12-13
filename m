Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD9D472BD8
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 13:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbhLMMAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 07:00:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34570 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbhLMMAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 07:00:36 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639396834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=risZnaVcZe9oeVlIXObZYM8AUPdYjg7GB0KMq5+o648=;
        b=Z7BIR/3xkeQ1+hfLzGihhRhTWl+wzq6RNcc3XmTYaNZZzczrlacPVqNB7JHh/9lDeEAJ0g
        Wp3f3q3LKPHlJNq8X5E3CqgcmKgODxpAjigBwv0o47g5GRnlKmdloRHkRhPYpmqqTRUZnK
        kWxvghYb4ikzSYcTC6Km6IdPnW8Ynj7ho8KQJyj5mPzIrRW622Md9q7wqQRCSByw6uo4Gb
        daBn72yDApo8LMl66TzrPPdWMwjKuhu3X9sty1vp9TGUEgRAIsmpH8WU9Cm07kz8GkK1bQ
        2iRGQtUUHO/NchQqjwdPhRfRS39ywd4lnK8zIw1rL1LpAFc5EQ6xzYNTU2+8FQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639396834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=risZnaVcZe9oeVlIXObZYM8AUPdYjg7GB0KMq5+o648=;
        b=SRpLAmiIEJ7HG7R4OVXjuYAdeV8lDtNmtFAZ+nRH5DCxDqXJAherlRINBnZaDMHM2U4jLY
        0KOvFLdx6ZkQDCAw==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
Subject: Re: [PATCH 02/19] x86/fpu: Prepare KVM for dynamically enabled states
In-Reply-To: <dae6cc09-2464-f1f5-c909-2374d33c75b5@redhat.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-3-yang.zhong@intel.com>
 <dae6cc09-2464-f1f5-c909-2374d33c75b5@redhat.com>
Date:   Mon, 13 Dec 2021 13:00:34 +0100
Message-ID: <878rwovhnh.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13 2021 at 10:12, Paolo Bonzini wrote:
> On 12/8/21 01:03, Yang Zhong wrote:
>>    - user_xfeatures
>> 
>>      Track which features are currently enabled for the vCPU
>
> Please rename to alloc_xfeatures

That name makes no sense at all. This has nothing to do with alloc.

>>    - user_perm
>> 
>>      Copied from guest_perm of the group leader thread. The first
>>      vCPU which does the copy locks the guest_perm
>
> Please rename to perm_xfeatures.

All of that is following the naming conventions in the FPU code related
to permissions etc.

>>    - realloc_request
>> 
>>      KVM sets this field to request dynamically-enabled features
>>      which require reallocation of @fpstate
>
> This field should be in vcpu->arch, and there is no need for 
> fpu_guest_realloc_fpstate.  Rename __xfd_enable_feature to 
> fpu_enable_xfd_feature and add it to the public API, then just do
>
> 	if (unlikely(vcpu->arch.xfd_realloc_request)) {
> 		u64 request = vcpu->arch.xfd_realloc_request;
> 		ret = fpu_enable_xfd(request, enter_guest);
> 	}
>
> to kvm_put_guest_fpu.

Why? Yet another export of FPU internals just because?

Also what clears the reallocation request and what is the @enter_guest
argument supposed to help with?

I have no idea what you are trying to achieve.

Thanks,

        tglx
