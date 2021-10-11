Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0734A4292E2
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 17:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhJKPQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 11:16:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231839AbhJKPQE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 11:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633965243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JzSZRIiW+aXjnRDBWbHKvvrzYi/BoJ6tma0KiYAtr+s=;
        b=SDxbyLXQnllzm4U5ocvSr37ZPc8r3EU4qNYnoyJcjpB4GRap3UxMtyWWh3K22lFY7v/lhC
        J6I4/1hB+flZ7jyvMQAcz9lwnfp7mf2Bj7VfArDUulafvafJAgD9UIhhilb7ozrvebLm4R
        dvTRfihSb55mW5mKlUjeqGDa4tipxXc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-hABjS1nqMiW3OKWKXcmiNA-1; Mon, 11 Oct 2021 11:14:02 -0400
X-MC-Unique: hABjS1nqMiW3OKWKXcmiNA-1
Received: by mail-wr1-f70.google.com with SMTP id r25-20020adfab59000000b001609ddd5579so13533739wrc.21
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 08:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JzSZRIiW+aXjnRDBWbHKvvrzYi/BoJ6tma0KiYAtr+s=;
        b=zCKJsl03cH3F41k9QXjwi/72GvOqrXJm5/qaMP1Rx67o9FuHxxIVD/XgCHIu4/gpLf
         Ecez6cDn0OfBvMtxWQ+p3KRK0quIKGNZl2NSMEfAM/i9kYaMeLfQnt9LpAwdo0xBabvn
         uhGM3F4mNwumpVIXhp7zFegN2FFUAil1WzbIzGd9bWzj+Lximng3PmoGfL5M78//8RHI
         FdXaADKbshE3cd6RuqxX9AR6OdKnGPWD5EmrkCEuAn+NOOrvDefOFm/dd2fJ2YMNe5Gb
         xMA7UlFGPj1WI1Q3N2pzZuOINpUItCnpiG3xaR/kUrHy/i08u1wFyBTpmMG7cPLJooL4
         8qCQ==
X-Gm-Message-State: AOAM533j3WGh9F+Ma8XkutSRStFLpHhmdiUfL+pTJdYHSQPjxtY2/Mnr
        RdcESq2Ydwh3a9VUxJE2qN7vB/jRDzepZfbR8Io0iqLiR0oTeSJiqelA6EV++6bjPOeZ3QgxBlP
        7Axa4cyiNtv6G
X-Received: by 2002:adf:a31d:: with SMTP id c29mr24729865wrb.381.1633965241396;
        Mon, 11 Oct 2021 08:14:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT1w9tE08j6c6gdbrJzeNwlidfRMe/kQM/9ddAAAg0M+wpzHCkafgPVlinl4sjFJeJoSwBhg==
X-Received: by 2002:adf:a31d:: with SMTP id c29mr24729841wrb.381.1633965241174;
        Mon, 11 Oct 2021 08:14:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v4sm11244822wmh.23.2021.10.11.08.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 08:14:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: nVMX: Track whether changes in L0 require
 MSR bitmap for L2 to be rebuilt
In-Reply-To: <YWDaOf/10znebx5S@google.com>
References: <20211004161029.641155-1-vkuznets@redhat.com>
 <20211004161029.641155-4-vkuznets@redhat.com>
 <YWDaOf/10znebx5S@google.com>
Date:   Mon, 11 Oct 2021 17:13:59 +0200
Message-ID: <87zgrfzj9k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Oct 04, 2021, Vitaly Kuznetsov wrote:
>> Introduce a flag to keep track of whether MSR bitmap for L2 needs to be
>> rebuilt due to changes in MSR bitmap for L1 or switching to a different
>> L2. This information will be used for Enlightened MSR Bitmap feature for
>> Hyper-V guests.
>> 
>> Note, setting msr_bitmap_changed to 'true' from set_current_vmptr() is
>> not really needed for Enlightened MSR Bitmap as the feature can only
>> be used in conjunction with Enlightened VMCS but let's keep tracking
>> information complete, it's cheap and in the future similar PV feature can
>> easily be implemented for KVM on KVM too.
>> 
>> No functional change intended.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>
> ...
>
>>  void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 592217fd7d92..eb7a1697bec2 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -148,6 +148,12 @@ struct nested_vmx {
>>  	bool need_vmcs12_to_shadow_sync;
>>  	bool dirty_vmcs12;
>>  
>> +	/*
>> +	 * Indicates whether MSR bitmap for L2 needs to be rebuilt due to
>> +	 * changes in MSR bitmap for L1 or switching to a different L2.
>> +	 */
>> +	bool msr_bitmap_changed;
>
> This is misleading, and arguably wrong.  It's only accurate when used in conjuction
> with a paravirt L1 that states if a VMCS has a dirty MSR bitmap.  E.g. this flag
> will be wrong if L1 changes the address of the bitmap in the VMCS, and it's
> obviously wrong if L1 changes the MSR bitmap itself.
>
> The changelog kind of covers that, but those details will be completely lost to
> readers of the code.

Would it help if we rename 'msr_bitmap_changed' to something?

>
> Would it be illegal from KVM to simply clear the CLEAN bit in the eVMCS at the
> appropriate points?

It would probably be OK to do that while we're in L2, however, in case
we're running L1 things can get messy. E.g. MSR-bitmap for L1 is changed
and we clear the clean bit in the currently mapped eVMCS for L2. Later,
before L1 runs L2, it sets the bit back again indicating 'no changes in
MSR-bitmap-12' and we (erroneously) skip updating MSR-Bitmap-02.

-- 
Vitaly

