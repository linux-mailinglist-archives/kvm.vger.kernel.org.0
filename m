Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC87C283530
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 13:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgJELvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 07:51:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbgJELvP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 07:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601898673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BjE3q5SqsZGBQmpmhfatyBhIujQJSM42VjvWFiS2jTU=;
        b=Kf2B1lJIVGrSSE3J6H+tOvgeWPsmxbgd6NCtuBFhdS8R62tL8+YmUldRr/xw3vMpEM6vji
        NCC/Gt6JDYD3gImiQInimz0DZZwqKm073qLauGHjkRh6CKdR2XLuXy89mx+VI+FbAjld/t
        XezpvaDoQU6gEOqq72Qbkb5UsZV3j+g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-iijJwU2QNTOKmKl3DRGCZQ-1; Mon, 05 Oct 2020 07:51:11 -0400
X-MC-Unique: iijJwU2QNTOKmKl3DRGCZQ-1
Received: by mail-wr1-f72.google.com with SMTP id w7so3925086wrp.2
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 04:51:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BjE3q5SqsZGBQmpmhfatyBhIujQJSM42VjvWFiS2jTU=;
        b=cO7+7hkOKtGz/l6x2KJ4T2yi6pKEaLvZGsTAPZEqhFByhp7RWICwOMLMrVq0a0BXj8
         dTd1ORZukcaE8QApg4/o9lxVtVxok6NhQArDtvuMy9pcguU1E28j9D2EDqmGGXvuYL2A
         xAdqVuBZ1Fp8w4SMKKxmyfWs4a0Agz2ff6GotnD7RP22xHdEBfnDBBSLjaNYHWTMx4p1
         rYCicCjmbXBGydHoIrcgbcIRtEqT+6D2Kx136512YB+bkHab13Qh39IFe6vGqe0IyD/W
         f23ng6vaSKdOMEc6twxyHfNvI3FXN3THrHRKP2axGGllDBTD3KBiXuvP5B85DaRhORaZ
         Uk5Q==
X-Gm-Message-State: AOAM532O/Bkm3brIisUwqwHVgYqvTPrlyYI6hidR0rbm29jZZysLPKFv
        QC+5ecnXqhbg5t/1Yl7rHpA+SsgJf8Zmenc0GIAOVUf03ya/TJlQpuAQKB4jpbrwyw7B1+HMHx1
        dTY+77fEtvYI3
X-Received: by 2002:a5d:660d:: with SMTP id n13mr17748666wru.308.1601898670432;
        Mon, 05 Oct 2020 04:51:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsx0tvR3zXziRScmcFCgsrWruPUl1whTfR7CXCpYhCWp+/X1cjmCctlOWkVPmlvRCMBb7e1Q==
X-Received: by 2002:a5d:660d:: with SMTP id n13mr17748636wru.308.1601898670087;
        Mon, 05 Oct 2020 04:51:10 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u81sm9460790wmg.43.2020.10.05.04.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 04:51:09 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: disconnect kvm_check_cpuid() from vcpu->arch.cpuid_entries
In-Reply-To: <85c31c92e6775b9d8ccd088e3f61659cac1c8cae.camel@redhat.com>
References: <20201001130541.1398392-1-vkuznets@redhat.com> <20201001130541.1398392-2-vkuznets@redhat.com> <85c31c92e6775b9d8ccd088e3f61659cac1c8cae.camel@redhat.com>
Date:   Mon, 05 Oct 2020 13:51:08 +0200
Message-ID: <87imbo99hv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Thu, 2020-10-01 at 15:05 +0200, Vitaly Kuznetsov wrote:
>> As a preparatory step to allocating vcpu->arch.cpuid_entries dynamically
>> make kvm_check_cpuid() check work with an arbitrary 'struct kvm_cpuid_entry2'
>> array.
>> 
>> Currently, when kvm_check_cpuid() fails we reset vcpu->arch.cpuid_nent to
>> 0 and this is kind of weird, i.e. one would expect CPUIDs to remain
>> unchanged when KVM_SET_CPUID[2] call fails.
> Since this specific patch doesn't fix this, maybe move this chunk to following patches,
> or to the cover letter?

Basically, this kind of pairs with what's after 'No functional change
intended' below: we admit the problem but don't fix it because we can't
(yet) and then in PATCH3 we do two things at once. It would be great to
separate these two changes but this doesn't seem to be possible without
an unneeded code churn.

That said, I'm completely fine with dropping this chunk from the commit
message if it sound inapropriate here.

>
>> 
>> No functional change intended. It would've been possible to move the updated
>> kvm_check_cpuid() in kvm_vcpu_ioctl_set_cpuid2() and check the supplied
>> input before we start updating vcpu->arch.cpuid_entries/nent but we
>> can't do the same in kvm_vcpu_ioctl_set_cpuid() as we'll have to copy
>> 'struct kvm_cpuid_entry' entries first. The change will be made when
>> vcpu->arch.cpuid_entries[] array becomes allocated dynamically.
>> 
>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/cpuid.c | 38 +++++++++++++++++++++++---------------
>>  1 file changed, 23 insertions(+), 15 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 37c3668a774f..529348ddedc1 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -54,7 +54,24 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>>  
>>  #define F feature_bit
>>  
>> -static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>> +static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
>> +	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
>> +{
>> +	struct kvm_cpuid_entry2 *e;
>> +	int i;
>> +
>> +	for (i = 0; i < nent; i++) {
>> +		e = &entries[i];
>> +
>> +		if (e->function == function && (e->index == index ||
>> +		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
>> +			return e;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>>  {
>>  	struct kvm_cpuid_entry2 *best;
>>  
>> @@ -62,7 +79,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>>  	 * The existing code assumes virtual address is 48-bit or 57-bit in the
>>  	 * canonical address checks; exit if it is ever changed.
>>  	 */
>> -	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
>> +	best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
>>  	if (best) {
>>  		int vaddr_bits = (best->eax & 0xff00) >> 8;
>>  
>> @@ -220,7 +237,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>>  		vcpu->arch.cpuid_entries[i].padding[2] = 0;
>>  	}
>>  	vcpu->arch.cpuid_nent = cpuid->nent;
>> -	r = kvm_check_cpuid(vcpu);
>> +	r = kvm_check_cpuid(vcpu->arch.cpuid_entries, cpuid->nent);
>>  	if (r) {
>>  		vcpu->arch.cpuid_nent = 0;
>>  		kvfree(cpuid_entries);
>> @@ -250,7 +267,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>>  			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
>>  		goto out;
>>  	vcpu->arch.cpuid_nent = cpuid->nent;
>> -	r = kvm_check_cpuid(vcpu);
>> +	r = kvm_check_cpuid(vcpu->arch.cpuid_entries, cpuid->nent);
>>  	if (r) {
>>  		vcpu->arch.cpuid_nent = 0;
>>  		goto out;
>> @@ -940,17 +957,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>>  					      u32 function, u32 index)
>>  {
>> -	struct kvm_cpuid_entry2 *e;
>> -	int i;
>> -
>> -	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
>> -		e = &vcpu->arch.cpuid_entries[i];
>> -
>> -		if (e->function == function && (e->index == index ||
>> -		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
>> -			return e;
>> -	}
>> -	return NULL;
>> +	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
>> +				 function, index);
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
>>  
>
> Other than minor note to the commit message, this looks fine, so
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>

Thanks!

-- 
Vitaly

