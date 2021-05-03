Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF9537165B
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhECODu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:03:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231180AbhECODn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620050569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0u9t3tvEwE9PLg1X8/LPO9YVPO0/W0tDSZeTY8ystLo=;
        b=Yc2tF5gIVhs5QfRSVgKrdHVP8A7jjUy0dJ5526Gzct9cT3y2HTzuYUn4M3T721g/GLQEcA
        9Ld9f2EOJYYEtxeTvUVC5G4Sy6FUVc3AveMOGBkB0wbb7BkqyQkA+O+EC0ZzKSrGzT6cVm
        BOvjQ71MlNiqijGWsrNM5hX22EmEGfU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-huSS4zNPP_G8qQpkkCSYjg-1; Mon, 03 May 2021 10:02:45 -0400
X-MC-Unique: huSS4zNPP_G8qQpkkCSYjg-1
Received: by mail-ed1-f70.google.com with SMTP id q18-20020a0564025192b02903888712212fso4436428edd.19
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 07:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0u9t3tvEwE9PLg1X8/LPO9YVPO0/W0tDSZeTY8ystLo=;
        b=VY4gF4hvqAk6BGZtugpSHTXoh+aS6u4kB7jKQXGbsdLRLXLHmYTp9IRU6YDhQTZ4Fe
         qserKdmROJi9qDaxqt7NVLNYX6C6A5ni0TMUdqyLhWKeXd+P3HJh1Rek0kthsMbH4Q57
         8Kroe2XckI7xyAeqK4ZF5gWJIldArPx4jjym3H/W+5Nw2aq5wGouo2t1sNY6hhDo9N2B
         iFRskJ3lPtzVBVslPZ+2yqBPK1S1RwE5OYqXfdvbTLL2HJ7vazVly4q86wzyyeCoPNxG
         XAN/0vL1kBluC2IH5JXoKchdjd3WKIxhG4hnPNsua1Wf5vhBo+RNfx3glXdHwtGC461u
         SUBA==
X-Gm-Message-State: AOAM531m1TW7xaLTDBHUtNhlkbflLblEcw//ENxh6BBs54MJvUg+wtKC
        a5AtSvO8gPpZAmNIg+ZDiyPTp04aKR/8rDcPzDhdxsSgZ2xTge4P8dUH56S2pBl15BN1KZx9cqK
        wAYhT7QzhZT/h
X-Received: by 2002:a05:6402:4245:: with SMTP id g5mr20162356edb.306.1620050564197;
        Mon, 03 May 2021 07:02:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWUYZDCgERL1OTjYaUJd6HS9FQOec6Ixn67My045GQCSLXIuz0zhigWa57++bHd7d7mVQVKQ==
X-Received: by 2002:a05:6402:4245:: with SMTP id g5mr20162332edb.306.1620050564002;
        Mon, 03 May 2021 07:02:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q12sm11490307ejy.91.2021.05.03.07.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:02:43 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: nSVM: set a dummy exit reason in L1 vmcb when
 loading the nested state
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
 <20210503125446.1353307-6-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a3a08464-d67c-fe71-6b2a-01b9ee58312c@redhat.com>
Date:   Mon, 3 May 2021 16:02:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210503125446.1353307-6-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 14:54, Maxim Levitsky wrote:
> Since the nested migration is a result of a VMRUN, this makes it
> possible to keep a warning that L1 vmcb should always have
> VMRUN exit reason when switching back to it, which
> otherwise triggers incorrectly.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Does this fix "KVM: nSVM: If VMRUN is single-stepped, queue the #DB 
intercept in nested_svm_vmexit()"?  I don't like this, and also vmcb12 
is not initialized here (nested_load_control_from_vmcb12 is using the 
state passed in from userspace instead).

I think you should just remove the WARN instead.

Paolo

> ---
>   arch/x86/kvm/svm/nested.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 12a12ae940fa..146be4b5084b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1338,6 +1338,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   	svm->vmcb01.ptr->save.rip = save->rip;
>   	svm->vmcb01.ptr->save.cpl = 0;
>   
> +	/*
> +	 * For consistency sake, restore the L1 exit reason
> +	 * (that happened prior to the migration) to SVM_EXIT_VMRUN.
> +	 */
> +	svm->vmcb->control.exit_code = SVM_EXIT_VMRUN;
> +
>   	nested_load_control_from_vmcb12(svm, ctl);
>   
>   	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> 

