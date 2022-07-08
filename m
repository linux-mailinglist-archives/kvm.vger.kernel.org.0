Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF05056B9F3
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 14:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbiGHMo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 08:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237889AbiGHMo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 08:44:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2B2C5593
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 05:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657284266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=og2F5W6+9WT1C1Kw9t/+eCrqcYEdBDo/kmOC6lhEAFQ=;
        b=EQEf6RzwVQ+IxlRxeOGrkT0IU4FTEcZiKXvIBLHubIKugtP/2NPWqULR++pusaW9+ZEvEM
        xK/kt8xy+cCG9uR47aEa41NsQwVub+kk27ixVV1DT3y0yVS94gL883DHp13mXBewgCwZcl
        yJ7+ubJF1SF2T+fPPrOh4kKRORy2WaY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-MPCLPC-bN4GRzLnItov1Zw-1; Fri, 08 Jul 2022 08:44:25 -0400
X-MC-Unique: MPCLPC-bN4GRzLnItov1Zw-1
Received: by mail-wm1-f71.google.com with SMTP id m17-20020a05600c3b1100b003a04a2f4936so953020wms.6
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 05:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=og2F5W6+9WT1C1Kw9t/+eCrqcYEdBDo/kmOC6lhEAFQ=;
        b=OiY6zQGxW2nmMy6c/3Jwb5ezoBA9ae+i1fjHEDvde6jZ+ocUgNAkM+FpQY8XNkg8YL
         X7QX7XIBAGe+lHtVL4oAbUqz2ksfMbD50b/2ElDWRrvctXXBr2dy7sJT97QuKr35cOh5
         H8rHUkOSujcarS0yXMGQjtssaU+bxLLd1eZzApTKGOh4FPN3IVRJUiogi9Nl2MQA2+Le
         bwlS4GDzaS1yFePf2UUPSpaIGrGDZbstErZX660EduvVHieN04YrrC8S2q6aHowxi85r
         Z98Xq2hOk9mc8JluxW+IJMN5ceOYCo00oawEEclG9lpCgaGR9vl9B48P5Bv5ueN3Un+G
         qnHQ==
X-Gm-Message-State: AJIora+CoB9B4RpaVY7QNI/pY5ldaZQZjau7XJkrHZksOJ0n6zMCO9Dj
        b8zvw880M5FeaJBJqIJWguyCn5+rWOHkywEmhiEPSsxPLhfCqgnnVBeY6WGnUTxDrUbWS/AMuZU
        E+OnhcOmaoQK2
X-Received: by 2002:a7b:c3cd:0:b0:3a1:95b6:3fd0 with SMTP id t13-20020a7bc3cd000000b003a195b63fd0mr3477618wmj.75.1657284263780;
        Fri, 08 Jul 2022 05:44:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ujgsgeIbwU5waLbajwPocytxadwSUtOmLGxGcjzp1zhfqje44S6b5BwhXOgjW+1K914IxbSg==
X-Received: by 2002:a7b:c3cd:0:b0:3a1:95b6:3fd0 with SMTP id t13-20020a7bc3cd000000b003a195b63fd0mr3477584wmj.75.1657284263262;
        Fri, 08 Jul 2022 05:44:23 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l5-20020a05600c4f0500b003a04e6410e0sm1980040wmq.33.2022.07.08.05.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 05:44:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fully initialize 'struct kvm_lapic_irq' in
 kvm_pv_kick_cpu_op()
In-Reply-To: <YscZMCBpuoJUlQ+H@google.com>
References: <20220628133057.107344-1-vkuznets@redhat.com>
 <YscZMCBpuoJUlQ+H@google.com>
Date:   Fri, 08 Jul 2022 14:44:21 +0200
Message-ID: <87r12vpye2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jun 28, 2022, Vitaly Kuznetsov wrote:
>> 'vector' and 'trig_mode' fields of 'struct kvm_lapic_irq' are left
>> uninitialized in kvm_pv_kick_cpu_op(). While these fields are normally
>> not needed for APIC_DM_REMRD, they're still referenced by
>> __apic_accept_irq() for trace_kvm_apic_accept_irq(). Fully initialize
>> the structure to avoid consuming random stack memory.
>> 
>> Fixes: a183b638b61c ("KVM: x86: make apic_accept_irq tracepoint more generic")
>> Reported-by: syzbot+d6caa905917d353f0d07@syzkaller.appspotmail.com
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/x86.c | 18 ++++++++++--------
>>  1 file changed, 10 insertions(+), 8 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 567d13405445..8a98608dad4f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9340,15 +9340,17 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
>>   */
>>  static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
>>  {
>> -	struct kvm_lapic_irq lapic_irq;
>> -
>> -	lapic_irq.shorthand = APIC_DEST_NOSHORT;
>> -	lapic_irq.dest_mode = APIC_DEST_PHYSICAL;
>> -	lapic_irq.level = 0;
>> -	lapic_irq.dest_id = apicid;
>> -	lapic_irq.msi_redir_hint = false;
>> +	struct kvm_lapic_irq lapic_irq = {
>> +		.vector = 0,
>> +		.delivery_mode = APIC_DM_REMRD,
>> +		.dest_mode = APIC_DEST_PHYSICAL,
>> +		.level = false,
>> +		.trig_mode = 0,
>> +		.shorthand = APIC_DEST_NOSHORT,
>> +		.dest_id = apicid,
>> +		.msi_redir_hint = false
>> +	};
>
> What if we rely on the compiler to zero-initialize omitted fields?  E.g.
>
> 	/*
> 	 * All other fields are unused for APIC_DM_REMRD, but may be consumed by
> 	 * common code, e.g. for tracing.  Defer initialization to the compiler.
> 	 */
> 	struct kvm_lapic_irq lapic_irq = {
> 		.delivery_mode = APIC_DM_REMRD,
> 		.dest_mode = APIC_DEST_PHYSICAL,
> 		.shorthand = APIC_DEST_NOSHORT,
> 		.dest_id = apicid,
> 	};
>
> KVM doesn't actually care about the vector, level, trig_mode, etc... for its magic
> magic DM_REMRD, i.e. using 0/false is completely arbitrary.  

Honestly, I just always forget whether zero-initializing of omitted
fields is a de-facto or de-jure standard. We don't care much whether
these fields are zero of not but some random values in tracing may
confuse an unprepared reader.

I'll send v2 with your amendment.

>
>>  
>> -	lapic_irq.delivery_mode = APIC_DM_REMRD;
>>  	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
>>  }
>>  
>> -- 
>> 2.35.3
>> 
>

-- 
Vitaly

