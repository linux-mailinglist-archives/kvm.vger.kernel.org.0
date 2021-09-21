Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DAD413946
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhIURzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:55:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231818AbhIURzy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 13:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632246865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9i/9hjImBidlUHv+Kt5Nf7id/F15Vwrv4hNmN253GQ0=;
        b=JAOvQSZo4Grwl3n56Csfc25ViVFE7Vq3AHwO7oc5L4QCDvtDV/ixYcR4kK3K6wr3qOwY9D
        k5DOPSwOlUzrGWZgsB7NKRQTxMTjC0lQNV0PQnaVxnP95ZLr2eCMtOwuQa5sK2ZInmbC07
        tTvW4j9Bs2bJ37yHkxerPfOCOJUrCQs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-tcONvmZHNn2GoX7O0si0VQ-1; Tue, 21 Sep 2021 13:54:22 -0400
X-MC-Unique: tcONvmZHNn2GoX7O0si0VQ-1
Received: by mail-ed1-f69.google.com with SMTP id n5-20020a05640206c500b003cf53f7cef2so17116768edy.12
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9i/9hjImBidlUHv+Kt5Nf7id/F15Vwrv4hNmN253GQ0=;
        b=pHaaMpe5Q5Um9NSwMYvlvmSj8a5Uvvrq/GU9uSPijKs0DiRKnFhsHgQnAsmlfvV8mU
         PrGxlpeiSVc/0Woro9i5dIArk+o1sSJqgb99/zd+giazyCfzPVI48vPi9zXXEWopn8yo
         1awep7tHZ5IyQGFcblb+J20SF0aTYfneVfj124Tx+TST1/wamkar5wwrNi22+AGMdrXc
         3peJ4denet6W7j55kEs69o6U90DZ5ntPbsVWVLBi/lFu0+rIGrU5qAaHDZqrotqF6inN
         k0PBENRSgobqiu7qtWChOOmnGC8wtY/LWCTFynvHnzWJ1aqVr4JxFBg+VY38CZrllHBt
         xWiA==
X-Gm-Message-State: AOAM5332CMoGGTlNO6j+ccVy/pYLE78+RqYfM+QtAI3Xo+Ot9PSXO4PL
        mRQwsG2a/C9Fbg7O6b0tf9zjiCQNl/TJKC2hfpL/8mB5Wg5Qav+pfC11Cobjw6fphoLs9ocm+yV
        S7sY6atScWMyD
X-Received: by 2002:a50:d948:: with SMTP id u8mr16796364edj.306.1632246861544;
        Tue, 21 Sep 2021 10:54:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOjMELjYB1Evm+oOb7Gu1LV3uiN5hAVZ06ur7zauhxhMyiCDnQPAztydd+/wqsXO8qjmXehg==
X-Received: by 2002:a50:d948:: with SMTP id u8mr16796349edj.306.1632246861323;
        Tue, 21 Sep 2021 10:54:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r23sm6462323edw.39.2021.09.21.10.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 10:54:20 -0700 (PDT)
Subject: Re: [PATCH V2] KVM: SEV: Acquire vcpu mutex when updating VMSA
To:     Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20210915171755.3773766-1-pgonda@google.com>
 <CAA03e5E=qi4+4c0SUv7u4P4ouJOTN9XUmD_Q2h-kBtBhwKLVDA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f911af87-ba9e-fca4-7950-61c636499c7d@redhat.com>
Date:   Tue, 21 Sep 2021 19:54:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAA03e5E=qi4+4c0SUv7u4P4ouJOTN9XUmD_Q2h-kBtBhwKLVDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/21 00:40, Marc Orr wrote:
> On Wed, Sep 15, 2021 at 10:18 AM Peter Gonda <pgonda@google.com> wrote:
>>
>> Adds vcpu mutex guard to the VMSA updating code. Refactors out
>> __sev_launch_update_vmsa() function to deal with per vCPU parts
>> of sev_launch_update_vmsa().
> 
> Can you expand the changelog, and perhaps add a comment into the
> source code as well, to explain what grabbing the mutex protects us
> from? I assume that it's a poorly behaved user-space, rather than a
> race condition in a well-behaved user-space VMM, but I'm not certain.
> 
> Other than that, the patch itself seems fine to me.

I added this:

The update-VMSA ioctl touches data stored in struct kvm_vcpu, and
therefore should not be performed concurrently with any VCPU ioctl
that might cause KVM or the processor to use the same data.

Paolo

>>
>> Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
>>
>> Signed-off-by: Peter Gonda <pgonda@google.com>
>> Cc: Marc Orr <marcorr@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>> Cc: kvm@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>
>> V2
>>   * Refactor per vcpu work to separate function.
>>   * Remove check to skip already initialized VMSAs.
>>   * Removed vmsa struct zeroing.
>>
>> ---
>>   arch/x86/kvm/svm/sev.c | 53 ++++++++++++++++++++++++------------------
>>   1 file changed, 30 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 75e0b21ad07c..766510fe3abb 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -595,43 +595,50 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>          return 0;
>>   }
>>
>> -static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>> +                                   int *error)
>>   {
>> -       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>          struct sev_data_launch_update_vmsa vmsa;
>> +       struct vcpu_svm *svm = to_svm(vcpu);
>> +       int ret;
>> +
>> +       /* Perform some pre-encryption checks against the VMSA */
>> +       ret = sev_es_sync_vmsa(svm);
>> +       if (ret)
>> +               return ret;
>> +
>> +       /*
>> +        * The LAUNCH_UPDATE_VMSA command will perform in-place encryption of
>> +        * the VMSA memory content (i.e it will write the same memory region
>> +        * with the guest's key), so invalidate it first.
>> +        */
>> +       clflush_cache_range(svm->vmsa, PAGE_SIZE);
>> +
>> +       vmsa.reserved = 0;
>> +       vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
>> +       vmsa.address = __sme_pa(svm->vmsa);
>> +       vmsa.len = PAGE_SIZE;
>> +       return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
>> +}
>> +
>> +static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +{
>>          struct kvm_vcpu *vcpu;
>>          int i, ret;
>>
>>          if (!sev_es_guest(kvm))
>>                  return -ENOTTY;
>>
>> -       vmsa.reserved = 0;
>> -
>> -       kvm_for_each_vcpu(i, vcpu, kvm) {
>> -               struct vcpu_svm *svm = to_svm(vcpu);
>> -
>> -               /* Perform some pre-encryption checks against the VMSA */
>> -               ret = sev_es_sync_vmsa(svm);
>> +       kvm_for_each_vcpu(i, vcpu, kvm) {
>> +               ret = mutex_lock_killable(&vcpu->mutex);
>>                  if (ret)
>>                          return ret;
>>
>> -               /*
>> -                * The LAUNCH_UPDATE_VMSA command will perform in-place
>> -                * encryption of the VMSA memory content (i.e it will write
>> -                * the same memory region with the guest's key), so invalidate
>> -                * it first.
>> -                */
>> -               clflush_cache_range(svm->vmsa, PAGE_SIZE);
>> +               ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);
>>
>> -               vmsa.handle = sev->handle;
>> -               vmsa.address = __sme_pa(svm->vmsa);
>> -               vmsa.len = PAGE_SIZE;
>> -               ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa,
>> -                                   &argp->error);
>> +               mutex_unlock(&vcpu->mutex);
>>                  if (ret)
>>                          return ret;
>> -
>> -               svm->vcpu.arch.guest_state_protected = true;
>>          }
>>
>>          return 0;
>> --
>> 2.33.0.464.g1972c5931b-goog
>>
> 

