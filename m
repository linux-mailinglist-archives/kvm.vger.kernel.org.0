Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E7A32B5B9
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446082AbhCCHTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381222AbhCBTmT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:42:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSnNe9ZPgO5E0WpOmTYQKeyWN6kgimAwSV4Hm5qeUs4=;
        b=iy1HO4PPXOJ1pGVg1CIRyXxYNkiz6t/rBU2nEZVvyEJo1UYrC35qxvp/Mbm+n/+3M/m4lN
        DWkC5oTSbi5Peej0oUZt7Eacnx8mBVE9MNnTG2Qp8I5yVG2WLtCI8C+a5p6o4PnngTQQ4Q
        uGzVp+OE9ms7lM5Jxpga+32Rl9yMKoY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-Wu7dq87aMFeUzUJsIAd2sw-1; Tue, 02 Mar 2021 14:39:32 -0500
X-MC-Unique: Wu7dq87aMFeUzUJsIAd2sw-1
Received: by mail-wr1-f71.google.com with SMTP id h30so11622816wrh.10
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 11:39:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cSnNe9ZPgO5E0WpOmTYQKeyWN6kgimAwSV4Hm5qeUs4=;
        b=WvO/7Pd0KUSYwzPR0OpKAvqGrdLOXkCZLZpLa0SKHraLiLWhQUzX8i59/gE9x8lv/q
         wx4mJUf8RqDm99xbPe25OIutYEr4xWyKl1++kCys/bd/9fJEkM5WVMnSpcKjjrvBzRue
         EYDSXY6+0rhUnzSMNe40MpLwytHtjNe9vZzLCf/cvRaF1ccA+8lHerpNmgUsTeY9QyDk
         5xBhT1PtnYeHUStAbu8Fah13spwhq+DzGilUg25Ufhtg/8sJ/X6D4RCpSIColwbjvKYb
         jWle4pppqLzHqv/sKbhmGaySBHE8epul+dUtsdrGCsm9PDwxXUfVPS11kYxEVMvRaXp2
         kVGw==
X-Gm-Message-State: AOAM530CseVgcRyrL7UIKtbNn8Py18otacw1AhtGxu7CD70JmmB4iaZz
        yDA+271IUVDYYXFIuC7pUT6p5xTYFJ5jeSFgt3NhuDfGOi0ULrrlXz1+i8+0CyZ/Id35WVZH57Z
        i6odpe9Mhq3Op
X-Received: by 2002:adf:b355:: with SMTP id k21mr23901239wrd.156.1614713970667;
        Tue, 02 Mar 2021 11:39:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcX+o0N0KVQBN6n2wK/GxJzWg1PiwtIfJxXLOWMn7SvlPUiFri43p4z/7EOeEDrXOMtOkqqg==
X-Received: by 2002:adf:b355:: with SMTP id k21mr23901212wrd.156.1614713970208;
        Tue, 02 Mar 2021 11:39:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a124sm3518464wmh.39.2021.03.02.11.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 11:39:29 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Clear the CR4 register on reset
To:     Babu Moger <babu.moger@amd.com>
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, seanjc@google.com,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
References: <161471109108.30811.6392805173629704166.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <454cb7d4-9f50-42e1-6908-d659491ba140@redhat.com>
Date:   Tue, 2 Mar 2021 20:39:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <161471109108.30811.6392805173629704166.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/21 19:51, Babu Moger wrote:
> This problem was reported on a SVM guest while executing kexec.
> Kexec fails to load the new kernel when the PCID feature is enabled.
> 
> When kexec starts loading the new kernel, it starts the process by
> resetting the vCPU's and then bringing each vCPU online one by one.
> The vCPU reset is supposed to reset all the register states before the
> vCPUs are brought online. However, the CR4 register is not reset during
> this process. If this register is already setup during the last boot,
> all the flags can remain intact. The X86_CR4_PCIDE bit can only be
> enabled in long mode. So, it must be enabled much later in SMP
> initialization.  Having the X86_CR4_PCIDE bit set during SMP boot can
> cause a boot failures.
> 
> Fix the issue by resetting the CR4 register in init_vmcb().
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>   arch/x86/kvm/svm/svm.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c636021b066b..baee91c1e936 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1200,6 +1200,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>   	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
>   	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
>   
> +	svm_set_cr4(&svm->vcpu, 0);
>   	svm_set_efer(&svm->vcpu, 0);
>   	save->dr6 = 0xffff0ff0;
>   	kvm_set_rflags(&svm->vcpu, X86_EFLAGS_FIXED);
> 

Queued, thanks.

Paolo

