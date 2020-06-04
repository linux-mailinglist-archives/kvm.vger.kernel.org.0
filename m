Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6D51EE855
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgFDQLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:11:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30411 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729681AbgFDQLw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 12:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591287110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dom5eGta2pQmQUnTqOXq4K4sf1uWRficZzHfpAMZOrw=;
        b=LKzRDiCNgcr+5b11EOTbLSBS0cAn9MY5UnqStENFCxRqBfiZj8r05sGpMNPrGz+8xiCBnE
        gYWuMVBowgcmdtrKjhYb1NUx4TlQfCoHtXpQtBSGtW9CjO7pB0BWS/+S8jC7czSQ+ksN2w
        rdjJpqGYv61xxtYGyJy4ctPfn+qJY6U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-ntJxE0XuN9KNA_qPJA7Vgg-1; Thu, 04 Jun 2020 12:11:32 -0400
X-MC-Unique: ntJxE0XuN9KNA_qPJA7Vgg-1
Received: by mail-wr1-f72.google.com with SMTP id n6so2622176wrv.6
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 09:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dom5eGta2pQmQUnTqOXq4K4sf1uWRficZzHfpAMZOrw=;
        b=pxELjWSkBkbFw/hiGdewgo4kIyFzC2LKg1B3Sb2nmSo+8hmAGeP66uexNvK2amOWNn
         WV5poqX5wOMZhgh7sU6O0bAfTeoUVt52Q2de8h6RN/nwI9cPdsgZ/BSsWqpkjjfxw0b0
         Gp2rgOyyy45WptRWh8d7ErJQiCjH8hPfossBJ9U9xI8PMuAz1xDUYXAn9hhvF76Jv1kd
         U8Ko6AWrq9q1DBDYqpqIXp1lG0tk8o6Nx5+6ewRqIHxN+AuUm1DNzTxwMLWjeHubINNo
         wqp91FXou8O00OwaUsDBGMfJz7Qp732ybvP8jmUM6uUet1W5VAV5MsQ8LDP7GcGnCGno
         FULg==
X-Gm-Message-State: AOAM530+D0MSwUuwNI5ce9C17+ubUnFUwrAgUBkyj7hWRR52N8Dv+iMS
        4QlwgtCEEbqq9fJY6hNYGzyXNLbtZ7ylaTzzQGNJ6UF97PsfKBRMip1AuImdUxq8g1ivtVRGR3B
        hq6iWoyzRWcRd
X-Received: by 2002:a7b:c201:: with SMTP id x1mr4648714wmi.58.1591287091537;
        Thu, 04 Jun 2020 09:11:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjgyAoyYkfHMyfTvXJbIRNsIJaJAUwfxy3jqaHsrs3O4bDwqeK0yyVeTB2SC/oAhP6Agoijw==
X-Received: by 2002:a7b:c201:: with SMTP id x1mr4648683wmi.58.1591287091236;
        Thu, 04 Jun 2020 09:11:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id y17sm8774089wrn.12.2020.06.04.09.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 09:11:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Inject #GP when nested_vmx_get_vmptr() fails
 to read guest memory
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200604143158.484651-1-vkuznets@redhat.com>
 <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com>
 <20200604145357.GA30223@linux.intel.com>
 <87k10meth6.fsf@vitty.brq.redhat.com>
 <20200604160253.GF30223@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dff2bbe0-60b1-8367-b033-ce7b1eb79354@redhat.com>
Date:   Thu, 4 Jun 2020 18:11:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200604160253.GF30223@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 18:02, Sean Christopherson wrote:
> On Thu, Jun 04, 2020 at 05:33:25PM +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>>
>>> On Thu, Jun 04, 2020 at 04:40:52PM +0200, Paolo Bonzini wrote:
>>>> On 04/06/20 16:31, Vitaly Kuznetsov wrote:
>>>
>>> ...
>>>
>>>>> KVM could've handled the request correctly by going to userspace and
>>>>> performing I/O but there doesn't seem to be a good need for such requests
>>>>> in the first place. Sane guests should not call VMXON/VMPTRLD/VMCLEAR with
>>>>> anything but normal memory. Just inject #GP to find insane ones.
>>>>>
>>
>> ...
>>
>>>>
>>>> looks good but we need to do the same in handle_vmread, handle_vmwrite,
>>>> handle_invept and handle_invvpid.  Which probably means adding something
>>>> like nested_inject_emulation_fault to commonize the inner "if".
>>>
>>> Can we just kill the guest already instead of throwing more hacks at this
>>> and hoping something sticks?  We already have one in
>>> kvm_write_guest_virt_system...
>>>
>>>   commit 541ab2aeb28251bf7135c7961f3a6080eebcc705
>>>   Author: Fuqian Huang <huangfq.daxian@gmail.com>
>>>   Date:   Thu Sep 12 12:18:17 2019 +0800
>>>
>>>     KVM: x86: work around leak of uninitialized stack contents
>>>
>>
>> Oh I see...
>>
>> [...]
>>
>> Let's get back to 'vm_bugged' idea then? 
>>
>> https://lore.kernel.org/kvm/87muadnn1t.fsf@vitty.brq.redhat.com/
> 
> Hmm, I don't think we need to go that far.  The 'vm_bugged' idea was more
> to handle cases where KVM itself (or hardware) screwed something up and
> detects an issue deep in a call stack with no recourse for reporting the
> error up the stack.
> 
> That isn't the case here.  Unless I'm mistaken, the end result is simliar
> to this patch, except that KVM would exit to userspace with
> KVM_INTERNAL_ERROR_EMULATION instead of injecting a #GP.

Indeed, all these functions are very high on the call stack and what
Sean has scribbled below would apply to all cases.

Thanks,

Paolo

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9c74a732b08d..e13d2c0014e2 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4624,6 +4624,20 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>         }
>  }
> 
> +static int nested_vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int ret,
> +                                           struct x86_exception *e)
> +{
> +       if (r == X86EMUL_PROPAGATE_FAULT) {
> +               kvm_inject_emulated_page_fault(vcpu, &e);
> +               return 1;
> +       }
> +
> +       vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +       vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +       vcpu->run->internal.ndata = 0;
> +       return 0;
> +}
> +
>  static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
>  {
>         gva_t gva;
> @@ -4634,11 +4648,9 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
>                                 sizeof(*vmpointer), &gva))
>                 return 1;
> 
> -       if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
> -               kvm_inject_emulated_page_fault(vcpu, &e);
> -               return 1;
> -       }
> -
> +       r kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
> +       if (r)
> +               return nested_vmx_handle_memory_failure(r, &e);
>         return 0;
>  }
> 
> 
> 
> Side topic, I have some preliminary patches for the 'vm_bugged' idea.  I'll
> try to whip them into something that can be posted upstream in the next few
> weeks.
> 

