Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650214B65C9
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 09:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbiBOISC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 03:18:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiBOIR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 03:17:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1826783026
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 00:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644913066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qBRCXHWRsfZFbcnR2e9NrL7AfQRDhw152q44tl2KQ8s=;
        b=Y1xO7kg9Qr2af+N7Hp06mbB9WXFDgiecc97+xiLCmbxubK6heOz+XnHJFvCkJ0AnQtEysd
        Y9u7fmSnt6d8bQC88bmYIh6jDE+y1agnuh7tYapVT0nr2OuP3K0acMoIlQ26eELtmaum91
        xLR/vSHxDXKYOHsfPQEbDvGp+ri3SHs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-iOGAqJ1YOHu9J2KRLIO2kA-1; Tue, 15 Feb 2022 03:17:44 -0500
X-MC-Unique: iOGAqJ1YOHu9J2KRLIO2kA-1
Received: by mail-ej1-f71.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso6945600eje.20
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 00:17:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qBRCXHWRsfZFbcnR2e9NrL7AfQRDhw152q44tl2KQ8s=;
        b=ifnZ+e7JJIbfYrfQ8neDBd3QycsHPK9kroVdAAQ6YJbdTtziFW/aOJ1TPdcC0tPKp6
         kx3a9MqexUpZp1XW8auYVNAj5hs/SmJxceWHCKqEI3ymRKqJIY+P0H25IQr/hDz2eF34
         mKQnycGbTUBojC/QN7XB4TcFYm/eScJR3k4K0yHbdh3XQAgR3hasnWmdW/jVlbyzKAvC
         uJS16IWugtdGlfuiUsMuQ1hVVOsOqqMHr159DjjMGtG09JkZw9A+JodYZq8K1cYfJz3e
         emo/AtrNSFqfJ8T/sZKCqaHR4MrGCnqdm4mB+S3QEtL/b4H2CjQ6pd+i3+DGuULoJcdd
         ZO2Q==
X-Gm-Message-State: AOAM532vCcyW/Zm0BRWjTIWSigJZuOazMc/s3r+gWM2sskho5hou/NGx
        0Z1e/2J6PG2JeHsF9oZLjQ+0FGqRWeX9hZqQjrBA/McQ2DHPNnB4X/SOWoVRlMgmG2Z4KetMlav
        nzG2TZCk7sx0f
X-Received: by 2002:a17:907:7da4:: with SMTP id oz36mr2014404ejc.59.1644913063043;
        Tue, 15 Feb 2022 00:17:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0DBXR1suAHvRGqXKUZ95AhNDbs3i7VJv4d2ibsn4zgLflwzJnWhNFJ9gXWskAS/wWxF17bg==
X-Received: by 2002:a17:907:7da4:: with SMTP id oz36mr2014392ejc.59.1644913062759;
        Tue, 15 Feb 2022 00:17:42 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j6sm16739438edl.98.2022.02.15.00.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 00:17:42 -0800 (PST)
Message-ID: <29e1edc7-9f9f-0663-997f-3416269b6a89@redhat.com>
Date:   Tue, 15 Feb 2022 09:17:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 12/12] KVM: x86: do not unload MMU roots on all role
 changes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-13-pbonzini@redhat.com> <YgavcP/jb5njjKKn@google.com>
 <5f42d1ef-f6b7-c339-32b9-f4cf48c21841@redhat.com>
 <YgqsU8j80M1ZpWPx@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgqsU8j80M1ZpWPx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 20:24, Sean Christopherson wrote:
> On Mon, Feb 14, 2022, Paolo Bonzini wrote:
>> On 2/11/22 19:48, Sean Christopherson wrote:
>>> On Wed, Feb 09, 2022, Paolo Bonzini wrote:
>>>> -	kvm_mmu_unload(vcpu);
>>>>    	kvm_init_mmu(vcpu);
>>>> +	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);
>>>
>>> This is too risky IMO, there are far more flows than just MOV CR0/CR4 that are
>>> affected, e.g. SMM transitions, KVM_SET_SREG, etc...
>
> I'm not concerned about the TLB flush aspects so much as the addition of
> kvm_mmu_new_pgd() in new paths.

Okay, yeah those are more complex and the existing ones are broken too.

>>>> -	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
>>>> +	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS) {
>>>> +		/* Flush the TLB if CR0 is changed 1 -> 0.  */
>>>> +		if ((old_cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PG))
>>>> +			kvm_mmu_unload(vcpu);
>>>
>>> Calling kvm_mmu_unload() instead of requesting a flush isn't coherent with respect
>>> to the comment, or with SMEP handling.  And the SMEP handling isn't coherent with
>>> respect to the changelog.  Please elaborate :-)
>>
>> Yep, will do (the CR0.PG=0 case is similar to the CR0.PCIDE=0 case below).
> 
> Oh, you're freeing all roots to ensure a future MOV CR3 with NO_FLUSH and PCIDE=1
> can't reuse a stale root.  That's necessary if and only if the MMU is shadowing
> the guest, non-nested TDP MMUs just need to flush the guest's TLB.  The same is
> true for the PCIDE case, i.e. we could optimize that too, though the main motivation
> would be to clarify why all roots are unloaded.

Yes.  Clarifying all this should be done before the big change to 
kvm_mmu_reset_context().

>> Using kvm_mmu_unload() avoids loading a cached root just to throw it away
>> immediately after,
> 
> The shadow paging case will throw it away, but not the non-nested TDP MMU case?

Yes, the TDP case is okay since the role is the same.  kvm_init_mmu() is 
enough.

>> but I can change this to a new KVM_REQ_MMU_UPDATE_ROOT flag that does
>>
>> 	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);
> 
> I don't think that's necessary, I was just confused by the discrepancy.

It may not be necessary but it is clearer IMO.  Let me post a new patch.

Paolo

