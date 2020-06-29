Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9ED20D234
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 20:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgF2Sri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 14:47:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727838AbgF2Srg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 14:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593456454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=is53wqYM+DH4GlUOLl6eyQhk3j5Rkm24u9IsygULR3E=;
        b=GxauVzyQtrQIIUd2O6H6OByChCMIQRNojC8fysrQGmM2GRz+lcW5rrRYhDwa0R1i0yLZCL
        r5Oz5NJypK8f2YvSI1CSU72TIMf1mhZaIPwHxLLs9GH4iLpDkXmLMeLYzLv52l+uiCap2Z
        PJkXTEplIeIghUzvhfv8vBFGPhLCiZI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-6w0RQewhM-GzfA-EMII1Lw-1; Mon, 29 Jun 2020 09:46:47 -0400
X-MC-Unique: 6w0RQewhM-GzfA-EMII1Lw-1
Received: by mail-ed1-f71.google.com with SMTP id da18so14172334edb.13
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 06:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=is53wqYM+DH4GlUOLl6eyQhk3j5Rkm24u9IsygULR3E=;
        b=PVzBp9f7wA6HYkvyXQTuwHuzNoSKUdmCbglA7sjqP3NqVBakORg7p0dejuL8jIO7OJ
         XzKnPzKfA2g4s92owXDc8D1CHHU7a1zFFPcYGtnaVtJtHOUN2gyaNEelmyilNjonKs1T
         4yWa6MMrN4NnfrjmHkERW9jvy9r8PdqfgLRpgt8Gv7tR9bRagrb3D/Ul3qKOYmmkTdIQ
         SGOPatWIXdo59CotH1DS+I99AhW/xCks2V1cjUK+YVnMlQT9IS/Sre/VcFkzg/VhC4Ax
         FKw4NIHckgIKsnJkROmN3O/D4rbYD1fxOH50ZHYM+aLYc+YLlqcGQl6HWaOyMquJfP4u
         6/mg==
X-Gm-Message-State: AOAM532906lhQaQJt6DAN8K8PmU6xORnWvPfTOGbTqbGgs3cGhYuEHtO
        gesmbDjHIJAV0KqEN521E1OMa8BE4MUmXzY2uC31wCgkgwhZEPeeRr/atpFTPQK1DN80LhQCfNj
        j9/hNGVuvLD7v
X-Received: by 2002:a17:906:8607:: with SMTP id o7mr13831834ejx.142.1593438405505;
        Mon, 29 Jun 2020 06:46:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxewVMMB60DfYI8z+2p9BsuKt4Mh3TKFrImVLPlOVRyz+wPv5CMtmyRSbX5oxgxbsyu8yAeIg==
X-Received: by 2002:a17:906:8607:: with SMTP id o7mr13831812ejx.142.1593438405243;
        Mon, 29 Jun 2020 06:46:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d12sm54628edx.80.2020.06.29.06.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 06:46:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Fix async pf caused null-ptr-deref
In-Reply-To: <1593426391-8231-1-git-send-email-wanpengli@tencent.com>
References: <1593426391-8231-1-git-send-email-wanpengli@tencent.com>
Date:   Mon, 29 Jun 2020 15:46:43 +0200
Message-ID: <877dvqc7cs.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Syzbot reported that:
>
>   CPU: 1 PID: 6780 Comm: syz-executor153 Not tainted 5.7.0-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   RIP: 0010:__apic_accept_irq+0x46/0xb80
>   Call Trace:
>    kvm_arch_async_page_present+0x7de/0x9e0
>    kvm_check_async_pf_completion+0x18d/0x400
>    kvm_arch_vcpu_ioctl_run+0x18bf/0x69f0
>    kvm_vcpu_ioctl+0x46a/0xe20
>    ksys_ioctl+0x11a/0x180
>    __x64_sys_ioctl+0x6f/0xb0
>    do_syscall_64+0xf6/0x7d0
>    entry_SYSCALL_64_after_hwframe+0x49/0xb3
>  
> The testcase enables APF mechanism in MSR_KVM_ASYNC_PF_EN with ASYNC_PF_INT 
> enabled w/o setting MSR_KVM_ASYNC_PF_INT before, what's worse, interrupt 
> based APF 'page ready' event delivery depends on in kernel lapic, however, 
> we didn't bail out when lapic is not in kernel during guest setting 
> MSR_KVM_ASYNC_PF_EN which causes the null-ptr-deref in host later. 
> This patch fixes it.
>
> Reported-by: syzbot+1bf777dfdde86d64b89b@syzkaller.appspotmail.com
> Fixes: 2635b5c4a0 (KVM: x86: interrupt based APF 'page ready' event delivery)

Thanks!

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2..1c0b4f5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2693,6 +2693,9 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  	if (data & 0x30)
>  		return 1;
>  
> +	if (!lapic_in_kernel(vcpu))
> +		return 1;
> +

I'm not sure how much we care about !lapic_in_kernel() case but this
change should be accompanied with userspace changes to not expose
KVM_FEATURE_ASYNC_PF_INT or how would the guest know that writing a
legitimate value will result in #GP?

Alternatively, we may just return '0' here: guest will be able to check
what's in the MSR to see if the feature was enabled. Normally, guests
shouldn't care about this but maybe there are cases when they do?

>  	vcpu->arch.apf.msr_en_val = data;
>  
>  	if (!kvm_pv_async_pf_enabled(vcpu)) {

-- 
Vitaly

