Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D358BB1C5
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 11:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407449AbfIWJ6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 05:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404970AbfIWJ6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 05:58:01 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8260C055673
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 09:58:00 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id v18so4614132wro.16
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 02:58:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wzehYQ/q/Unr9ua1VQFlkvwitkghryuoSUrqvQKWtys=;
        b=DokUPw0P6D/DjA0u+PjUXXXjpRxBDHs2ZTS+/mvtFX88pyRQe2gBcgrIoB8t3lFCmq
         +ziH6iHKQqFWXZbOcgPZM4OFPVnOrftZiwSwWZce9HdZUgBJok3u4SeVRHBnu2SVLv01
         r8Z/9y6cCnMyjOLtvFPivW39kcb2nqWzyZY9mOEDhUSquq4roc45pAqK+m0AKw4vybXb
         XXeGDKBvmuqfrqVn6rtau6IYBIiGV3McryXnWgir2TurzFcR/eyd2KSraVFIfbCPMkiZ
         t9n4L7G626OkbN9xPzrc2BTYZr3HExxMGUIr2w0FWQ7Q42xvvMOvN9D+Kh2WshmCYuzd
         3zbw==
X-Gm-Message-State: APjAAAXJF8aP7M+NKZNvdcEOvcXmTXhrg6XquhfwckBaNhENy/jvDZQR
        8vad/Ui5vYdCI04IkwJjZfqllm5hdvzCU7LHSgOO5ME0g/ykq7xlQWahVOoIohpukyos03qZ/yE
        RQ1T5U7Hbot9A
X-Received: by 2002:adf:f9c9:: with SMTP id w9mr19828669wrr.172.1569232679351;
        Mon, 23 Sep 2019 02:57:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw+R47KLkJmnU7l8Zxf4zZxqnGS/qkxsg/JQjqPn/GlshVIlfYKQ2eupxBkl7MdJyTJq5f6zQ==
X-Received: by 2002:adf:f9c9:: with SMTP id w9mr19828652wrr.172.1569232679116;
        Mon, 23 Sep 2019 02:57:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id c1sm8310783wmk.20.2019.09.23.02.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 02:57:58 -0700 (PDT)
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
Date:   Mon, 23 Sep 2019 11:57:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87o8zb8ik1.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/19 11:31, Vitaly Kuznetsov wrote:
> +#ifdef CONFIG_RETPOLINE
> +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> +			return handle_wrmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> +			return handle_preemption_timer(vcpu);
> +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> +			return handle_interrupt_window(vcpu);
> +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +			return handle_external_interrupt(vcpu);
> +		else if (exit_reason == EXIT_REASON_HLT)
> +			return handle_halt(vcpu);
> +		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
> +			return handle_pause(vcpu);
> +		else if (exit_reason == EXIT_REASON_MSR_READ)
> +			return handle_rdmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_CPUID)
> +			return handle_cpuid(vcpu);
> +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> +			return handle_ept_misconfig(vcpu);
> +#endif
>  		return kvm_vmx_exit_handlers[exit_reason](vcpu);

Most of these, while frequent, are already part of slow paths.

I would keep only EXIT_REASON_MSR_WRITE, EXIT_REASON_PREEMPTION_TIMER,
EXIT_REASON_EPT_MISCONFIG and add EXIT_REASON_IO_INSTRUCTION.

If you make kvm_vmx_exit_handlers const, can the compiler substitute for
instance kvm_vmx_exit_handlers[EXIT_REASON_MSR_WRITE] with handle_wrmsr?
 Just thinking out loud, not sure if it's an improvement code-wise.

Paolo

Paolo
