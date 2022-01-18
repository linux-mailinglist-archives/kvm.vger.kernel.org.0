Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA506492884
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245344AbiAROhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:37:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245283AbiAROhG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 09:37:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642516625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I1Roh1bswl/1psuf+8JsW8+b4eb0eTKZBCJnJTJbWm4=;
        b=hU14JOWQazlp+1RIFocZI5sUk3bmw1qYGvxho7DmafrT+4T6huboIG5WGlK6FdudRe88nm
        xm9dkKkrDXeOBs6Dh0PuRhmfRxfBYkRa8lShSAEgPKdWEpbnuVE7RN4E67r1Ak7ymyQUDJ
        ENfKeR8F/FToWvmtEgo8jksVQxSFZpw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-qIRx8rEhPD-H1eUBV8Z3Xw-1; Tue, 18 Jan 2022 09:37:04 -0500
X-MC-Unique: qIRx8rEhPD-H1eUBV8Z3Xw-1
Received: by mail-ed1-f69.google.com with SMTP id bm21-20020a0564020b1500b00402c34373f9so5020913edb.2
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 06:37:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=I1Roh1bswl/1psuf+8JsW8+b4eb0eTKZBCJnJTJbWm4=;
        b=rC96pV9FPBJhzCO3QqvwTvQO6jRfFVbXYZNweHzYTH7cOcXjOXUthispcAm7Y14Wg3
         6gL5hTU+3KWVu9GOfcyVRVniVbQ1PeQNyTD6ABqj03F/xuxvRJmPEC9KMiuzjjDt16NK
         Es8njXB2EubcxZoC9wqngbmXzBpqWh7aPJQ5f5tjxgvoTBahUCMQKu1Eyp4aV6ybyluh
         u/cgfekdSVBzdlGF/ZQW/mZfehoQhzDn9XxTdPh2U2Y2oENqDG5S/45Hy/LqairthpJd
         HuKqzsRAz9rqD+NQyU/DBc4zB+elXTiacCpKlzy2T0QefejkQTTDUOby4d+Poe6UYExG
         QvtQ==
X-Gm-Message-State: AOAM531NZgycUVEqkTv99d8lsn8uISLlzIZjQWWXsex8EC0k7z93R5ui
        hEFalUPGZwZUjT92YThi1Z4wWar35dYzi2h59ovvXT+anV37zeGuJWBayHDKdymqeUccBvBhbSf
        kCY9gg/rvcsJy
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr20555829ejc.696.1642516622860;
        Tue, 18 Jan 2022 06:37:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJziAnMIo7Ue83WoM483kFpdpRDcWL4HxXt+a5HKtfJ+yVSF2XwVc5D5V3zdoybTJ7oVrJEw==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr20555817ejc.696.1642516622684;
        Tue, 18 Jan 2022 06:37:02 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id sh38sm5304355ejc.70.2022.01.18.06.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 06:37:02 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: x86: Partially allow KVM_SET_CPUID{,2}
 after KVM_RUN
In-Reply-To: <87pmopl9m2.fsf@redhat.com>
References: <20220117150542.2176196-1-vkuznets@redhat.com>
 <20220117150542.2176196-3-vkuznets@redhat.com>
 <c427371c-474e-1233-4e57-66210bfc5687@redhat.com>
 <87pmopl9m2.fsf@redhat.com>
Date:   Tue, 18 Jan 2022 15:37:01 +0100
Message-ID: <87h7a1kt4i.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Paolo Bonzini <pbonzini@redhat.com> writes:
>
>> On 1/17/22 16:05, Vitaly Kuznetsov wrote:
>>>   
>>> +/* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
>>> +static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>>> +				 int nent)
>>> +{
>>> +	struct kvm_cpuid_entry2 *best;
>>> +	int i;
>>> +
>>> +	for (i = 0; i < nent; i++) {
>>> +		best = kvm_find_cpuid_entry(vcpu, e2[i].function, e2[i].index);
>>> +		if (!best)
>>> +			return -EINVAL;
>>> +
>>> +		if (e2[i].eax != best->eax || e2[i].ebx != best->ebx ||
>>> +		    e2[i].ecx != best->ecx || e2[i].edx != best->edx)
>>> +			return -EINVAL;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> What about this alternative implementation:
>>
...
>>
>> avoiding the repeated calls to kvm_find_cpuid_entry?
>>
>
> My version is a bit more permissive as it allows supplying CPUID entries
> in any order, not necessarily matching the original. I *guess* this
> doesn't matter much for the QEMU problem we're trying to workaround,
> I'll have to check.

I tried this with QEMU and nothing blew up, during CPU hotplug entries
come in the same order as the original. v3 which I've just sent
implements this suggestion.

-- 
Vitaly

