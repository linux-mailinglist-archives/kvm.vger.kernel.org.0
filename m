Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292C018B0E3
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 11:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgCSKFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 06:05:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:25691 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726802AbgCSKFV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 06:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584612320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=biS3cShpXl2Aq0UEQn21ymKBE/YmvTY+/p2BtT5ta1k=;
        b=DaICgVaiolpt7aK7OUJmCWpBw3hPXvtHqKOOiCaau+8ifb0SftcxPfT52aDmk+xVgQayI5
        on5gxiVfrBrYISHGgRMeUTDMDzMGD5ZREagHeCaf6AXMuP7Tc/BID0X1MtisXs+HExp7nd
        9s6V4wIl4es47lRP7Yvd4USX+vXqqf8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-P3KqnMCtNouSE2-XTbvpaQ-1; Thu, 19 Mar 2020 06:05:18 -0400
X-MC-Unique: P3KqnMCtNouSE2-XTbvpaQ-1
Received: by mail-wm1-f70.google.com with SMTP id a11so777031wmm.9
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 03:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=biS3cShpXl2Aq0UEQn21ymKBE/YmvTY+/p2BtT5ta1k=;
        b=o59CtHXB7DrdExMychZbFZiU+AkdSBQxZzZz4pGjfFJsZ0h9KG3TRaqrknpWg+ppJV
         BOGdE64rtnVhJXH/aTVhfcn5hpUFqR7Qoz0GBGUgw71RMCSUGaaMwY1cOPWuTLqypWRm
         TyqTpT/URaDgBM6JiIZMAJjrOzDhRc/tta+uRCrDiD0x6FbwmwcSr7eh3Ukh5HyTw39g
         WG+VeVgJMVmM223e7S0BLtHOyup+nSMqy/fGnid5tCzfvtn3t4zaHyOBY8TJUSQrN/cK
         yrqsLVdnARijvxANjlSbc3sQToqRBcwiI0+F5qV666lJKN2G6u5Qvgarbe3Z4cxnotnf
         McZg==
X-Gm-Message-State: ANhLgQ3fPhdcqLfn2pSFIx6ICkZ6FUcpmLncS/ji3rRJFBzg2CCkOsYo
        qSHGsL4dZq4vpXQr88yp/NMkgcWbUi4ifO+cUWWb7QecSDUDrGbkZriBa2kHrVTJbGWr1YLHotz
        TMVABtnnuvZz6
X-Received: by 2002:a05:600c:2c0f:: with SMTP id q15mr2657230wmg.64.1584612317514;
        Thu, 19 Mar 2020 03:05:17 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vteptDrM0Sa4MuQRsMwkR4OkaNbZvD0oN0fqzKGp8th+KLIwNuYkrMPUb6mOK28WU/CULOflA==
X-Received: by 2002:a05:600c:2c0f:: with SMTP id q15mr2657206wmg.64.1584612317270;
        Thu, 19 Mar 2020 03:05:17 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id t126sm2628652wmb.27.2020.03.19.03.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 03:05:16 -0700 (PDT)
Subject: Re: [PATCH] KVM: nSVM: check for EFER.SVME=1 before entering guest
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1584535300-6571-1-git-send-email-pbonzini@redhat.com>
 <b5cb03b1-9840-f8f5-843a-1eab680d5e8e@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6426c98d-d206-aeb7-93fa-da62b77df21a@redhat.com>
Date:   Thu, 19 Mar 2020 11:05:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <b5cb03b1-9840-f8f5-843a-1eab680d5e8e@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/20 19:40, Krish Sadhukhan wrote:
> 
> On 3/18/20 5:41 AM, Paolo Bonzini wrote:
>> EFER is set for L2 using svm_set_efer, which hardcodes EFER_SVME to 1
>> and hides
>> an incorrect value for EFER.SVME in the L1 VMCB.  Perform the check
>> manually
>> to detect invalid guest state.
>>
>> Reported-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/svm.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 08568ae9f7a1..2125c6ae5951 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -3558,6 +3558,9 @@ static bool nested_svm_vmrun_msrpm(struct
>> vcpu_svm *svm)
>>     static bool nested_vmcb_checks(struct vmcb *vmcb)
>>   {
>> +    if ((vmcb->save.efer & EFER_SVME) == 0)
>> +        return false;
>> +
>>       if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
>>           return false;
>>   
> 
> Ah! This now tells me that I forgot the KVM fix that was supposed to
> accompany my patchset.

Heh, indeed.  I was puzzled for a second after applying it, then decided
I would just fix it myself. :)

> Do we need this check in software ? I wasn't checking the bit in KVM and
> instead I was just making sure that L0 sets that bit based on the
> setting in nested vmcb:

The only effect of the function below over svm_set_efer is to guarantee
a vmrun error to happen.  Doing the test in nested_vmcb_checks is more
consistent with other must-be-one bits such as the VMRUN intercept, and
it's also a smaller patch.

Paolo

> 
> +static void nested_svm_set_efer(struct kvm_vcpu *vcpu, u64
> nested_vmcb_efer)
> +{
> +       svm_set_efer(vcpu, nested_vmcb_efer);
> +
> +       if (!(nested_vmcb_efer & EFER_SVME))
> +               to_svm(vcpu)->vmcb->save.efer &= ~EFER_SVME;
> +}
> +
>  static int is_external_interrupt(u32 info)
>  {
>         info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
> @@ -3554,7 +3562,7 @@ static void enter_svm_guest_mode(struct vcpu_svm
> *svm, u64
>         svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
>         svm->vmcb->save.idtr = nested_vmcb->save.idtr;
>         kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
> -       svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
> +       nested_svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
>         svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
>         svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
>         if (npt_enabled) {
> 

