Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AEA573A65
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 17:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbiGMPpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 11:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiGMPp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 11:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C1464D17F
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657727127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZVY0K5yxBZ9KDDh5Uo4Ad2ghdbNkYwOVyUboikxAno4=;
        b=Gvgcq+J9m/4wb9NF53+gh+GCkfooLFdXWUGtjGaSnL4HWxSvoHbgd/EjYQw9Xa1CBovi+Z
        k4vEStkTEstKEOG2cu1iYs23kCEsu+FzZ4hywVii/jY+kbfCyh2atbIUYEpBbyC/Gv/vOx
        B3IQ4osTNZQ+d9iOsInVC6/ykldGUik=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-miQxPqAtOmqemApMYLpnqg-1; Wed, 13 Jul 2022 11:45:26 -0400
X-MC-Unique: miQxPqAtOmqemApMYLpnqg-1
Received: by mail-ej1-f71.google.com with SMTP id s4-20020a170906500400b006feaccb3a0eso3594438ejj.11
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 08:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZVY0K5yxBZ9KDDh5Uo4Ad2ghdbNkYwOVyUboikxAno4=;
        b=PN88suMIH+CZ/80zOmt0I98KcNwo5h0Zt2VpYAgVRPQItMvXC+u5RQg2eOhYKdklU6
         Pny+QGSrQxVKhq/IykwH+YAJmz5IX35ROdvfV8NjG4AyP0D8i1a2BqFcJIGdunRoro4P
         1dfuevtpeO8Wm3aTGH+T6qYAvPGF08ERuk7OV5N7uQpm8UZt9rWKjObJDojf3sXtSSOH
         YlPsps1HX1WayKB21tLvTz9EqFfnsgUc63KDT2Wv6g80OujWEtTjIRp6uWBrRqnFspDN
         tY2y0JMWOYpOUzEd8j3sWbFk9PHHctvRvvrZ7bcWGtDh1TfT3w38gIJtaYYN2hvInlI+
         Z7PA==
X-Gm-Message-State: AJIora90b+fhZtOaUfngsVhV3c8ZKyXovgTBBhcIROlzzrrqgNL4IKtr
        qfiY96qzv8LXBjkh4q34p08q2q8QdKc4ryw4q/rLEFz8QdF7moUd3l14GGbjBPi8YEZRhJ+NP9Z
        bK4imCx91Ox1L
X-Received: by 2002:aa7:df12:0:b0:43a:4991:1725 with SMTP id c18-20020aa7df12000000b0043a49911725mr5915128edy.55.1657727125228;
        Wed, 13 Jul 2022 08:45:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vqywBIarKeBDvJ/Os4B4nmMtiJdv7n72OU8I7PEmJFEsDhEcFdrgUnpf9fyhglCvafO0VOnw==
X-Received: by 2002:aa7:df12:0:b0:43a:4991:1725 with SMTP id c18-20020aa7df12000000b0043a49911725mr5915114edy.55.1657727125070;
        Wed, 13 Jul 2022 08:45:25 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o2-20020aa7dd42000000b0043ad162b5e3sm5991517edw.18.2022.07.13.08.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 08:45:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 06/25] KVM: x86: hyper-v: Cache
 HYPERV_CPUID_NESTED_FEATURES CPUID leaf
In-Reply-To: <26e7784ff4ee91a8d41d217dcb5f3e0e0ce6e470.camel@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
 <20220708144223.610080-7-vkuznets@redhat.com>
 <26e7784ff4ee91a8d41d217dcb5f3e0e0ce6e470.camel@redhat.com>
Date:   Wed, 13 Jul 2022 17:45:23 +0200
Message-ID: <87k08hnhik.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
>> KVM has to check guest visible HYPERV_CPUID_NESTED_FEATURES.EBX CPUID
>> leaf to know with Enlightened VMCS definition to use (original or 2022
>> update). Cache the leaf along with other Hyper-V CPUID feature leaves
>> to make the check quick.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 2 ++
>>  arch/x86/kvm/hyperv.c           | 9 +++++++++
>>  2 files changed, 11 insertions(+)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index de5a149d0971..077ec9cf3169 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -616,6 +616,8 @@ struct kvm_vcpu_hv {
>>  		u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
>>  		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
>>  		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
>> +		u32 nested_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
>> +		u32 nested_ebx; /* HYPERV_CPUID_NESTED_FEATURES.EBX */
>>  	} cpuid_cache;
>>  };
>>  
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index e08189211d9a..b666902da4d9 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -2030,6 +2030,15 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
>>  		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
>>  	else
>>  		hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
>> +
>> +	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_NESTED_FEATURES, 0);
>> +	if (entry) {
>> +		hv_vcpu->cpuid_cache.nested_eax = entry->eax;
>> +		hv_vcpu->cpuid_cache.nested_ebx = entry->ebx;
>> +	} else {
>> +		hv_vcpu->cpuid_cache.nested_eax = 0;
>> +		hv_vcpu->cpuid_cache.nested_ebx = 0;
>> +	}
>>  }
>>  
>>  int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
>
>
> Small Nitpick:
>
> If I understand correctly, the kvm_find_cpuid_entry can fail if the userspace didn't provide the
> cpuid entry.
>
> Since the code that deals with failback is now repeated 3 times, how about some wrapper function that
> will return all zeros for a non present cpuid entry?

I've opted for wiping the whole hv_vcpu->cpuid_cache with memset(), this
way we don't even need a new helper.

-- 
Vitaly

