Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3942716188C
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 18:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgBQRKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 12:10:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728054AbgBQRKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 12:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581959400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dKdVT8bRLOqfrghOOP85NA3ZzmuO0wXacH6v6RS7LrU=;
        b=b2UgQN3wXgwLnswxC7ljGq4esKhRUY1FuoCH8vCH1/0ZRV03lL+eQkPHB1oNCAIvoNM71g
        QtgMABZxj9uyih4RljklvpWuTtYMbcQnYpuh3stS4/NyNfAe6H/cF423XudvYJwkv+uV7J
        +mTs1aXVLK6759W2ZVpOQRLsU12iHn4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-InMj36oKMQiliG_DUeC7dQ-1; Mon, 17 Feb 2020 12:09:58 -0500
X-MC-Unique: InMj36oKMQiliG_DUeC7dQ-1
Received: by mail-wm1-f69.google.com with SMTP id y125so160684wmg.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:09:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKdVT8bRLOqfrghOOP85NA3ZzmuO0wXacH6v6RS7LrU=;
        b=DB4mAsk0H9rAJdTbi1Bj4XouO0Fqui0b+c4/SyQYO77m1Huukr9pmNFTDuO3BG5PI0
         xPM4Iu6djSblHc3guYOIwJ2W3A9vLekAMK1oHHoyAJ/s5tjLteh42ycX3jrez34qrCgM
         GZCrAVAi8pmiSId5GyCC1obTduMZeFs8tmUWn4LXMuKKmmf4zr+vQlbvISJuHzpp56S3
         fjPYHfSBxNB7DEMU59pSNvZrjLFg/9eAC6y87LNPbK9liYPeJldvMlk4KN1giKSqIPwR
         y36ofZBV/wd7uh8w2CDt6CRejyhc4SCPKUbwuIG9Hv31KV9Cxo3j279EYeA3TsY30EKo
         azFw==
X-Gm-Message-State: APjAAAWVy4vJwWQIBWXUVNU4qEn7gNeedAkfqiecxE33MjfHj5ztE+xd
        +M0BcbmvKGK/pY23EYlYXHTDJ7kCiPxBOTM8M1qq/kduc0mrfTKgA3lGuKctmhvmzIGuD0Vt9Od
        k7igdR5vb6RZO
X-Received: by 2002:a1c:a947:: with SMTP id s68mr16693wme.61.1581959397058;
        Mon, 17 Feb 2020 09:09:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqz5LZQUFABHRqpxPIJl3DpcZMbukV6Rr7zd91TH2C4JFxzOGYddQrP10qAoHbdfwFb8f5uHNA==
X-Received: by 2002:a1c:a947:: with SMTP id s68mr16668wme.61.1581959396816;
        Mon, 17 Feb 2020 09:09:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id h128sm82143wmh.33.2020.02.17.09.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:09:56 -0800 (PST)
Subject: Re: [PATCH v3 2/2] KVM: nVMX: Hold KVM's srcu lock when syncing
 vmcs12->shadow
To:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <CANRm+Cx2ifbbQWk0yAm=W5Us69GybSdtO8uLYXx-qe9F=jNeeQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <70229f0d-ad94-741c-44fe-32ff6e953f5e@redhat.com>
Date:   Mon, 17 Feb 2020 18:09:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CANRm+Cx2ifbbQWk0yAm=W5Us69GybSdtO8uLYXx-qe9F=jNeeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/20 11:37, Wanpeng Li wrote:
> From: wanpeng li <wanpengli@tencent.com>
> 
> For the duration of mapping eVMCS, it derefences ->memslots without holding
> ->srcu or ->slots_lock when accessing hv assist page. This patch fixes it by
> moving nested_sync_vmcs12_to_shadow to prepare_guest_switch, where the SRCU
> is already taken.
> 
> It can be reproduced by running kvm's evmcs_test selftest.
> 
>   =============================
>   warning: suspicious rcu usage
>   5.6.0-rc1+ #53 tainted: g        w ioe
>   -----------------------------
>   ./include/linux/kvm_host.h:623 suspicious rcu_dereference_check() usage!
> 
>   other info that might help us debug this:
> 
>    rcu_scheduler_active = 2, debug_locks = 1
>   1 lock held by evmcs_test/8507:
>    #0: ffff9ddd156d00d0 (&vcpu->mutex){+.+.}, at:
> kvm_vcpu_ioctl+0x85/0x680 [kvm]
> 
>   stack backtrace:
>   cpu: 6 pid: 8507 comm: evmcs_test tainted: g        w ioe     5.6.0-rc1+ #53
>   hardware name: dell inc. optiplex 7040/0jctf8, bios 1.4.9 09/12/2016
>   call trace:
>    dump_stack+0x68/0x9b
>    kvm_read_guest_cached+0x11d/0x150 [kvm]
>    kvm_hv_get_assist_page+0x33/0x40 [kvm]
>    nested_enlightened_vmentry+0x2c/0x60 [kvm_intel]
>    nested_vmx_handle_enlightened_vmptrld.part.52+0x32/0x1c0 [kvm_intel]
>    nested_sync_vmcs12_to_shadow+0x439/0x680 [kvm_intel]
>    vmx_vcpu_run+0x67a/0xe60 [kvm_intel]
>    vcpu_enter_guest+0x35e/0x1bc0 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x40b/0x670 [kvm]
>    kvm_vcpu_ioctl+0x370/0x680 [kvm]
>    ksys_ioctl+0x235/0x850
>    __x64_sys_ioctl+0x16/0x20
>    do_syscall_64+0x77/0x780
>    entry_syscall_64_after_hwframe+0x49/0xbe
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * update Subject
>  * move the check above
>  * add the WARN_ON_ONCE
> 
>  arch/x86/kvm/vmx/vmx.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3be25ec..9a6797f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1175,6 +1175,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>                         vmx->guest_msrs[i].mask);
> 
>      }
> +
> +    if (vmx->nested.need_vmcs12_to_shadow_sync)
> +        nested_sync_vmcs12_to_shadow(vcpu);
> +
>      if (vmx->guest_state_loaded)
>          return;
> 
> @@ -6482,8 +6486,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>          vmcs_write32(PLE_WINDOW, vmx->ple_window);
>      }
> 
> -    if (vmx->nested.need_vmcs12_to_shadow_sync)
> -        nested_sync_vmcs12_to_shadow(vcpu);
> +    WARN_ON_ONCE(vmx->nested.need_vmcs12_to_shadow_sync);
> 
>      if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
>          vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
> --
> 2.7.4
> 

Queued, thanks.  But the whitespace in the patch is messed up.

Paolo

