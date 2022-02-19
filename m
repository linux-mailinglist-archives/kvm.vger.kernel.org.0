Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCF04BC777
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 11:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbiBSKEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 05:04:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiBSKEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 05:04:11 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8E74F9F4;
        Sat, 19 Feb 2022 02:03:52 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c6so16866711edk.12;
        Sat, 19 Feb 2022 02:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e8sLN6vkZrz7khSRwbfrA2x7wxsnzRm53OM6VfGG9Ts=;
        b=dqfgGPL9Inj94Y03GiY39z2k92/jaNO8XsInxdyb90ADDo0ZnLZl8OALy2xrARDhIH
         bHDrlMkuHcmEktY/E5z+QeNMwAFGYTUUvf2yiGDEp0WQMQwRxtrpDjCjdOu4ylpiYlKM
         pOvTK3I1ZnxC4WUZVhB/uK9mxtLSrjRM8RXDjGxXgo3jN7AXupAYrwBblr2I1l6Xs38s
         S53+M6id7Fu58rNF8/f63u2ZdNCASa23o3ytZzchZglZ+XACgHug908ERD5dvTcTFvQ/
         ZWZiIU5Uu/hcUjwh8PN7Kh6/0KcsM7fo84M9t06n1Pw6bazJx4Rdm6kWv0Bc+Zk9rcol
         L+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e8sLN6vkZrz7khSRwbfrA2x7wxsnzRm53OM6VfGG9Ts=;
        b=0i/m763cJ90I6nI7+CeiXeY2dwizwFw59NJfo8s3j6fSNHPhQ/H14U1pBIyvwKWz1k
         8u23jxHVjshGSaRpx1iz3hLQJksdS7+NP5rRigD7M3n5DFjIh9VWfw21PhoIkb+BqwXp
         5P5JQLZl5bDg8nsXvqm3lIJlc/n6Xylg3S/QlgFetoWGjwQXR+Oc+LS/jS6QtvEcSvqa
         FPIIVATNl4gKyUYQ1kOeowU/J8BOHhBPxFADZtaBcLBfUmL3KjhSXsZ0V9leRJsUxJcF
         gZ9ZME3VoHaloj2Ka3xad5QRVRRlkGlzWkqMflv7hmYkRe9sfypImwDunCke6J/C828a
         HI/A==
X-Gm-Message-State: AOAM532jfYarMk3FbnP6J6TNlhL4N4arB568KKgmjHOhMHQfQCz71yg1
        qnmYxBoveYYrj1lcQhUVSAc=
X-Google-Smtp-Source: ABdhPJwYTq/zuccUutieRVqseJ1kObi/ppnw9r/8MTAdtkU1qc5An4S35BM4Q2IKvnGmxml5rAFc7Q==
X-Received: by 2002:aa7:d3d9:0:b0:410:7a81:c0cf with SMTP id o25-20020aa7d3d9000000b004107a81c0cfmr12150696edr.177.1645265031366;
        Sat, 19 Feb 2022 02:03:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z11sm6194528edd.75.2022.02.19.02.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Feb 2022 02:03:50 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <55ef796b-6433-b72f-6f5c-b7499284c9a4@redhat.com>
Date:   Sat, 19 Feb 2022 11:03:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 14/18] KVM: x86/mmu: avoid indirect call for get_cr3
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-15-pbonzini@redhat.com> <YhAB1d1/nQbx6yvk@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YhAB1d1/nQbx6yvk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 21:30, Sean Christopherson wrote:
> On Thu, Feb 17, 2022, Paolo Bonzini wrote:
>> Most of the time, calls to get_guest_pgd result in calling
>> kvm_read_cr3 (the exception is only nested TDP).  Hardcode
>> the default instead of using the get_cr3 function, avoiding
>> a retpoline if they are enabled.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/mmu.h             | 13 +++++++++++++
>>   arch/x86/kvm/mmu/mmu.c         | 15 +++++----------
>>   arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>>   arch/x86/kvm/x86.c             |  2 +-
>>   4 files changed, 20 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 1d0c1904d69a..1808d6814ddb 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -116,6 +116,19 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>>   					  vcpu->arch.mmu->shadow_root_level);
>>   }
>>   
>> +static inline gpa_t __kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>> +{
> 
> I'd prefer to do what we do for page faults.  That approach avoids the need for a
> comment to document NULL and avoids a conditional when RETPOLINE is not enabled.
> 
> Might be worth renaming get_cr3 => get_guest_cr3 though.

I did it this way to avoid a slightly gratuitous extern function just 
because kvm_mmu_get_guest_pgd and kvm_read_cr3 are both inline.  But at 
least it's not an export since there are no callers in vmx/svm, so it's 
okay to do it as you suggested.

> #ifdef CONFIG_RETPOLINE
> 	if (mmu->get_guest_pgd = get_guest_cr3)
> 		return kvm_read_cr3(vcpu);
> #endif
> 	return mmu->get_guest_pgd(vcpu);
> 
> 
>> +	if (!mmu->get_guest_pgd)
>> +		return kvm_read_cr3(vcpu);
>> +	else
>> +		return mmu->get_guest_pgd(vcpu);
>> +}
>> +
>> +static inline gpa_t kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu)
>> +{
>> +	return __kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
> 
> I'd much prefer we don't provide an @vcpu-only variant and force the caller to
> provide the mmu.

No problem.

Paolo
