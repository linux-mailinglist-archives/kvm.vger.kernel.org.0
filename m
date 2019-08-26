Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7CB9CD9A
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 12:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfHZKui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 06:50:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbfHZKuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 06:50:37 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C43D185537
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 10:50:36 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id m25so6481933wml.6
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 03:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1Zd1SFIjARqEumU71Skb4c1w5TinyEiEoSENVD4g+JE=;
        b=B40lGGj/9kYzO7KaqfDwVjxdBRn5yyGyLgbQ9iluKVMdS9KNIufktEjF1G+ClMsXlB
         J2WQHrRLxMno/hr8i9Wfhvcm/wEnEIn1seKIRkz9jh7vLv3uxSixnaAlNjLCY7Atqh6+
         1ED/3z9oXo7mmS/WZpQBsbbTQ58CpfAC8t7Ya2WuJ7bjq1GKLIvqNxZNyLzgnuogvqk8
         oDO6holtZwoQlQDGX909LCjsxrLXI4VAi0WHK9U6nrfO+zagdO5a/E0spWwDnD1wlsOd
         sk1U+gtbuRxOFtUVgU5d/t5MmyouDL+EjnYq9mC+NyWFr2r4eM2DogYmSBzvEXu6W+wb
         /+CQ==
X-Gm-Message-State: APjAAAWAuSkaAFiAK0OYoIVyAumMzSn7P8ZgB0yyjniCRIcofxvWtSwB
        bfOUBVGR8F3WngYjeFofcsSIgO7BeU+YcBTJmv9GDwFuR7nBpftTMQTrRiw79E2s/4bDzjKKYcH
        la0Kuc/AahoCK
X-Received: by 2002:a7b:c318:: with SMTP id k24mr22191909wmj.113.1566816635141;
        Mon, 26 Aug 2019 03:50:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwNLISElPFa9RfDqfkOwD64OEYXplD5yOIndEND6/Pu2V5tgxY/YQVufDioJj8+fQWCg61s0w==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr22191887wmj.113.1566816634886;
        Mon, 26 Aug 2019 03:50:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 2sm20126403wrg.83.2019.08.26.03.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 03:50:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Return to userspace with internal error on unexpected exit reason
In-Reply-To: <20190826101643.133750-1-liran.alon@oracle.com>
References: <20190826101643.133750-1-liran.alon@oracle.com>
Date:   Mon, 26 Aug 2019 12:50:33 +0200
Message-ID: <87wof0mc92.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

> Receiving an unexpected exit reason from hardware should be considered
> as a severe bug in KVM. Therefore, instead of just injecting #UD to
> guest and ignore it, exit to userspace on internal error so that
> it could handle it properly (probably by terminating guest).

While "this should never happen" on real hardware, it is a possible
event for the case when KVM is running as a nested (L1)
hypervisor. Misbehaving L0 can try to inject some weird (corrupted) exit
reason.

>
> In addition, prefer to use vcpu_unimpl() instead of WARN_ONCE()
> as handling unexpected exit reason should be a rare unexpected
> event (that was expected to never happen) and we prefer to print
> a message on it every time it occurs to guest.
>
> Furthermore, dump VMCS/VMCB to dmesg to assist diagnosing such cases.
>
> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>  arch/x86/kvm/svm.c       | 11 ++++++++---
>  arch/x86/kvm/vmx/vmx.c   |  9 +++++++--
>  include/uapi/linux/kvm.h |  2 ++
>  3 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d685491fce4d..6462c386015d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5026,9 +5026,14 @@ static int handle_exit(struct kvm_vcpu *vcpu)
>  
>  	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
>  	    || !svm_exit_handlers[exit_code]) {
> -		WARN_ONCE(1, "svm: unexpected exit reason 0x%x\n", exit_code);
> -		kvm_queue_exception(vcpu, UD_VECTOR);
> -		return 1;
> +		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", exit_code);
> +		dump_vmcb(vcpu);
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->internal.suberror =
> +			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> +		vcpu->run->internal.ndata = 1;
> +		vcpu->run->internal.data[0] = exit_code;
> +		return 0;
>  	}
>  
>  	return svm_exit_handlers[exit_code](svm);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 42ed3faa6af8..b5b5b2e5dac5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5887,8 +5887,13 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  	else {
>  		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>  				exit_reason);
> -		kvm_queue_exception(vcpu, UD_VECTOR);
> -		return 1;
> +		dump_vmcs();
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->internal.suberror =
> +			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> +		vcpu->run->internal.ndata = 1;
> +		vcpu->run->internal.data[0] = exit_reason;
> +		return 0;
>  	}
>  }
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5e3f12d5359e..42070aa5f4e6 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -243,6 +243,8 @@ struct kvm_hyperv_exit {
>  #define KVM_INTERNAL_ERROR_SIMUL_EX	2
>  /* Encounter unexpected vm-exit due to delivery event. */
>  #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
> +/* Encounter unexpected vm-exit reason */
> +#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
>  
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {

-- 
Vitaly
