Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328A126B8FA
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIPAxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIOLdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 07:33:01 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB110C0611C2;
        Tue, 15 Sep 2020 04:29:50 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s65so1860651pgb.0;
        Tue, 15 Sep 2020 04:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iZZZ3oSdKZd9z2ofzkCYRtX+OtJdA4mv0c01rJrSths=;
        b=jv8dD33sRnwy+w6PG//UZu01nl7dRKAtLflNirCAenTBNs0zJWHtuC0XeNZBTjcY9B
         B3pFVdc52HjZs14t8b3NV/mdEVzXjchN8eO9pNCieA9y6z9kKN/w0x36N743cpwPcY/E
         Jg4p7UlSe2LjP2wsDHRQX/k/L+LgzFvSjxiHLPb8WOUvmkDKJwhMrv4509UrYQo+92GM
         Yu27jbA7liZaDr3mCWDn/2NMb2EUxUKE861m1Ev4bHsXhlFsEy8tlJ4wv7MUiQlW3i11
         l+YekVbPJ7duGiQ3jnZOdTifuMfzx/M0ptzDV2C+SJasUgs6scSBb9R7bhX8VY5jb1ck
         DT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iZZZ3oSdKZd9z2ofzkCYRtX+OtJdA4mv0c01rJrSths=;
        b=Lg0X+xx2L//x6BfuhOVxYWk/BAIM24VPw5ROdPTcWsAZKzME6dlibIbSwvPO95si0V
         WAq650buTjlKsLnzwuNpeL90f03/Tje4Rsnvi5N58GjRf6fQN/k1iyc3OsjgGNgfwJ+6
         PviROsfTrJICLq5axE9cLHheQnedl+ttjMpnGwaWd1HGcHIZWKYdNhPqHQMePDUfKWrW
         LoY72/Ix/oZPRvIVx38RSe4l8voWWqMgg1AeGT/pUhC7b+CRY3YSqv8u3ZNR00C/dXp1
         EbCT1sQlscusXyUno0SA5J+/p+mYFP2r1vm3l01+Av0tLAaXpwj/4gamY3fx8TacMJUE
         K2CA==
X-Gm-Message-State: AOAM531J6ijCCupFyoXEGjTsjpS3uSjybpQlnpABjYgZUbvvyVX1Z0xx
        zIWVwpfToTLCG95bi2YgpQ==
X-Google-Smtp-Source: ABdhPJyDw2OdAE6/fq5yqY1r/0YtQZmGXQ3gKXOoGZh85/fWlcAMS/VqSw7pIupI6DvbkF5EVmd7OA==
X-Received: by 2002:a63:594a:: with SMTP id j10mr13332327pgm.402.1600169390285;
        Tue, 15 Sep 2020 04:29:50 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id q24sm13295090pfs.206.2020.09.15.04.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 04:29:49 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Analyze is_guest_mode() in svm_vcpu_run()
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1600066548-4343-1-git-send-email-wanpengli@tencent.com>
 <b39b1599-9e1e-8ef6-1b97-a4910d9c3784@oracle.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <425468c9-15f0-9486-d317-fd25c38a714a@gmail.com>
Date:   Tue, 15 Sep 2020 19:29:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <b39b1599-9e1e-8ef6-1b97-a4910d9c3784@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/9/15 04:43, Krish Sadhukhan wrote:
> 
> On 9/13/20 11:55 PM, Wanpeng Li wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> Analyze is_guest_mode() in svm_vcpu_run() instead of 
>> svm_exit_handlers_fastpath()
>> in conformity with VMX version.
>>
>> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> ---
>>   arch/x86/kvm/svm/svm.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 3da5b2f..009035a 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3393,8 +3393,7 @@ static void svm_cancel_injection(struct kvm_vcpu 
>> *vcpu)
>>   static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>>   {
>> -    if (!is_guest_mode(vcpu) &&
>> -        to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
>> +    if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
>>           to_svm(vcpu)->vmcb->control.exit_info_1)
>>           return handle_fastpath_set_msr_irqoff(vcpu);
>> @@ -3580,6 +3579,10 @@ static __no_kcsan fastpath_t 
>> svm_vcpu_run(struct kvm_vcpu *vcpu)
>>           svm_handle_mce(svm);
>>       svm_complete_interrupts(svm);
>> +
>> +    if (is_guest_mode(vcpu))
>> +        return EXIT_FASTPATH_NONE;
>> +
>>       exit_fastpath = svm_exit_handlers_fastpath(vcpu);
>>       return exit_fastpath;
> 
> Not related to your changes, but should we get rid of the variable 
> 'exit_fastpath' and just do,
> 
>          return svm_exit_handler_fastpath(vcpu);
> 
> It seems the variable isn't used anywhere else and svm_vcpu_run() 
> doesn't return from anywhere else either.
> 
> Also, svm_exit_handlers_fastpath() doesn't have any other caller. Should 
> we get rid of it as well ?

I will do this soon, thanks.
