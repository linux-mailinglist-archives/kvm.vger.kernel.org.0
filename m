Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C385F1A4525
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 12:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgDJKWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 06:22:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55276 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgDJKWP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Apr 2020 06:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586514134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myq4A86h+72R4CEen1ctYlXgwxnk1bi4qAeKXQag11M=;
        b=WUKp0uE4WwhNern0DcF/dJ4nR5d47zJb8kDcqxRwvjzUPb95kG/yCREFesbujiAXnOL0X8
        mMWc1++nm7g4pkQTfXmlWAieKWkqpESvL1e5DVZJa8TKQBBPVIA6VvtRYkL1mzr42kTjy0
        ZlWHz8HjD0ZCHRVWmIfmlqcxAdFpy64=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-Bxz2VyNgPsq1R0G2oY4DBg-1; Fri, 10 Apr 2020 06:22:11 -0400
X-MC-Unique: Bxz2VyNgPsq1R0G2oY4DBg-1
Received: by mail-wr1-f70.google.com with SMTP id w12so899225wrl.23
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 03:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=myq4A86h+72R4CEen1ctYlXgwxnk1bi4qAeKXQag11M=;
        b=h75hxUGO4qJvIrjOwYahJ7sJsak4/zFNPi93lld49x5LNBfMBaDVQmrywOPgeiBUbA
         n6L2xw295lRk166tQ9x0IXPeHtr92lM3Csr2brkPQRJBKXcju5SQLgP168TqGw/3rmBp
         nCrKv/FFU15HSM71Ot3hIWKX/vEl5ZdwxUhtAQ56hRntChIR5/mfRgirvs4O1/9bROkM
         ke+X2V1fOBUts7nGDrfTDtlC9CwhszDkVdp7835F2ZEVaLp5IDI9XYbGM9SRSlcbm+R+
         ooFL6o9SCcRqJch91lvWPIAK3shS5AcXfjh2C+2hlDsc2fxRTbaD+9VUh/Y/eQ75Tdnq
         CL5Q==
X-Gm-Message-State: AGi0Pub68D5xKDWVhxkanz7K95e9nwW6BPPJ8TSbpAnsCD+raJurcB3Y
        xnpJP0R8xuzIMHzOFtSbeovyc/TyUGmCn8TPy9z7EDgTP0psua/K4y45EIXtssLeXNCQRg4ob1E
        aMs4DuunhrTFH
X-Received: by 2002:a5d:53ca:: with SMTP id a10mr3542880wrw.388.1586514130022;
        Fri, 10 Apr 2020 03:22:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypJnXEjma3SKgBTV5y3pd6mdJeWcBhmmfkn0ZTkl5TBS8W40HyiVAny9dCityJ0DdFx1CQ8z+g==
X-Received: by 2002:a5d:53ca:: with SMTP id a10mr3541020wrw.388.1586514099906;
        Fri, 10 Apr 2020 03:21:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e8a3:73c:c711:b995? ([2001:b07:6468:f312:e8a3:73c:c711:b995])
        by smtp.gmail.com with ESMTPSA id b199sm2443439wme.23.2020.04.10.03.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 03:21:39 -0700 (PDT)
Subject: Re: [PATCH 2/3] x86/split_lock: Refactor and export
 handle_user_split_lock() for KVM
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
 <20200402155554.27705-3-sean.j.christopherson@intel.com>
 <87v9mhn7nf.fsf@nanos.tec.linutronix.de>
 <20200402171946.GH13879@linux.intel.com>
 <87mu7tn1w8.fsf@nanos.tec.linutronix.de>
 <716f5824-8d47-24cc-4935-c2dd32ed4629@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <283c549a-423f-a85e-c208-8a80d682ef77@redhat.com>
Date:   Fri, 10 Apr 2020 12:21:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <716f5824-8d47-24cc-4935-c2dd32ed4629@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/04/20 06:39, Xiaoyao Li wrote:
> 
>   +static bool guest_handles_ac(struct kvm_vcpu *vcpu)
> +{
> +    /*
> +     * If guest has alignment checking enabled in CR0 and activated in
> +     * eflags, then the #AC originated from CPL3 and the guest is able
> +     * to handle it. It does not matter whether this is a regular or
> +     * a split lock operation induced #AC.
> +     */
> +    if (vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
> +        kvm_get_rflags(vcpu) & X86_EFLAGS_AC)
> +        return true;
> +
> +    /* Add guest SLD handling checks here once it's supported */
> +    return false;
> +}
> +
>   static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   {
>       struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -4630,6 +4647,7 @@ static int handle_exception_nmi(struct k
>       u32 intr_info, ex_no, error_code;
>       unsigned long cr2, rip, dr6;
>       u32 vect_info;
> +    int err;
>         vect_info = vmx->idt_vectoring_info;
>       intr_info = vmx->exit_intr_info;
> @@ -4688,9 +4706,6 @@ static int handle_exception_nmi(struct k
>           return handle_rmode_exception(vcpu, ex_no, error_code);
>         switch (ex_no) {
> -    case AC_VECTOR:
> -        kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
> -        return 1;
>       case DB_VECTOR:
>           dr6 = vmcs_readl(EXIT_QUALIFICATION);
>           if (!(vcpu->guest_debug &
> @@ -4719,6 +4734,29 @@ static int handle_exception_nmi(struct k
>           kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
>           kvm_run->debug.arch.exception = ex_no;
>           break;
> +    case AC_VECTOR:
> +        if (guest_handles_ac(vcpu)) {
> +            kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
> +            return 1;
> +        }
> +        /*
> +         * Handle #AC caused by split lock detection. If the host
> +         * mode is sld_warn, then it warns, marks current with
> +         * TIF_SLD and disables split lock detection. So the guest
> +         * can just continue.
> +         *
> +         * If the host mode is fatal, the handling code warned. Let
> +         * qemu kill itself.
> +         *
> +         * If the host mode is off, then this #AC is bonkers and
> +         * something is badly wrong. Let it fail as well.
> +         */
> +        err = handle_ac_split_lock(kvm_rip_read(vcpu));
> +        if (!err)
> +            return 1;
> +        /* Propagate the error type to user space */
> +        error_code = err == -EFAULT ? 0x100 : 0x200;
> +        fallthrough;


Acked-by: Paolo Bonzini <pbonzini@redhat.com>

