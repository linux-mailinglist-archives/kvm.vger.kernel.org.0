Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B2A498327
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 16:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240539AbiAXPKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 10:10:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240550AbiAXPK2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 10:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643037027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oC+kZYxunT62Tn6ecl24Q4N+v2y0DrmKFuUG0aDL2m4=;
        b=YgTJSQvXBhrn/0hCRYJZThPtFRQndv6yYbOWOEVuglVOw/ZYf5XTvF8aKbeLwqwouMmec9
        9UWMfJKOh4qu2GYeIxekzjcdU8+wkHnPjWAuzYvSApyavtSgg1AY+yiH6F3I2nbDCIySAf
        0szygra6lSPaDWBoan+00chKYKMWAt8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-zPrLJ2gbOkCG2FBEJ3GCEA-1; Mon, 24 Jan 2022 10:10:25 -0500
X-MC-Unique: zPrLJ2gbOkCG2FBEJ3GCEA-1
Received: by mail-wm1-f72.google.com with SMTP id bg16-20020a05600c3c9000b0034bea12c043so15099678wmb.7
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 07:10:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oC+kZYxunT62Tn6ecl24Q4N+v2y0DrmKFuUG0aDL2m4=;
        b=717qy2ea5tnon6vNMD4TqQB98M3jitma/MsS/JedIPW9uL6iVXUYimJe2N8PKyDUdl
         0f5Ns+5UVBXF+dJ2Sz4xvI+/DvxD+UijDx7oYp4kVFKTmIEl5K2AZ9deMPVTuU1nt1+U
         GoCz7vQ6c3+JQqW3kNKma7WbDPzw0YcXFMWM8AsB5rnN3FRStabRNDVn5sVoCVPRx1lZ
         SQbXlhmG3M35sam0xIUhkFeEINlO409C7A8Cj62rx/JdBxFukWjlP/j3s36/ElvwyNFV
         0VC9kpBw+FnAh06tk/uXTQWlG9AotC2mCmxfmiPnrRq7a+6xPKAFhUak9CGf+LB1Br7Y
         uB1w==
X-Gm-Message-State: AOAM530MmzseIBZLnNRl3PDUAGkl6FTVKAujq6Z7D8Xp2BavuE89lrXG
        Bra7o4/RCvnCvHiVw/fepnKZ4JVTo5pr7Ou+0MUEi8l0JZg6I1SMfd1ztnIay4Gfinz9JHOsOEr
        hOzS+l9O4XoJn
X-Received: by 2002:a1c:9a14:: with SMTP id c20mr2210882wme.146.1643037024001;
        Mon, 24 Jan 2022 07:10:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxU2vLVGgQ3gVv+oBMMqqPhsunml8TDWg+adWMY6Ne+76AVF+o5GKjix3JCNDuzORVGJb19Aw==
X-Received: by 2002:a1c:9a14:: with SMTP id c20mr2210870wme.146.1643037023769;
        Mon, 24 Jan 2022 07:10:23 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b62sm12934670wmb.16.2022.01.24.07.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 07:10:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Use memcmp in kvm_cpuid_check_equal()
In-Reply-To: <95f63ed6-743b-3547-dda1-4fe83bc39070@redhat.com>
References: <20220124103606.2630588-1-vkuznets@redhat.com>
 <20220124103606.2630588-3-vkuznets@redhat.com>
 <95f63ed6-743b-3547-dda1-4fe83bc39070@redhat.com>
Date:   Mon, 24 Jan 2022 16:10:22 +0100
Message-ID: <87bl01i2zl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 1/24/22 11:36, Vitaly Kuznetsov wrote:
>> kvm_cpuid_check_equal() should also check .flags equality but instead
>> of adding it to the existing check, just switch to using memcmp() for
>> the whole 'struct kvm_cpuid_entry2'.
>> 
>> When .flags are not checked, kvm_cpuid_check_equal() may allow an update
>> which it shouldn't but kvm_set_cpuid() does not actually update anything
>> and just returns success.
>> 
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 13 ++-----------
>>   1 file changed, 2 insertions(+), 11 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 89d7822a8f5b..7dd9c8f4f46e 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -123,20 +123,11 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>>   static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>>   				 int nent)
>>   {
>> -	struct kvm_cpuid_entry2 *orig;
>> -	int i;
>> -
>>   	if (nent != vcpu->arch.cpuid_nent)
>>   		return -EINVAL;
>>   
>> -	for (i = 0; i < nent; i++) {
>> -		orig = &vcpu->arch.cpuid_entries[i];
>> -		if (e2[i].function != orig->function ||
>> -		    e2[i].index != orig->index ||
>> -		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
>> -		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
>> -			return -EINVAL;
>> -	}
>> +	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(*e2)))
>> +		return -EINVAL;
>
> Hmm, not sure about that due to the padding in struct kvm_cpuid_entry2. 
>   It might break userspace that isn't too careful about zeroing it.

FWIW, QEMU zeroes the whole thing before setting individual CPUID
entries. Legacy KVM_SET_CPUID call is also not afffected as it copies
entries to a newly allocated "struct kvm_cpuid_entry2[]" and explicitly
zeroes padding.

Do we need to at least add a check for ".flags"?

>
> Queued patch 1 though.
>
> Paolo
>

-- 
Vitaly

