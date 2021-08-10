Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978F13E5813
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 12:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbhHJKPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 06:15:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239778AbhHJKPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 06:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628590482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A42WvvsgdwjkwZlZk69nEpIcOnUU9ZyOs8J0bgwxJg8=;
        b=Ss4fy/PLexcOVUleBPG0nv+WatgqfFkYJYOXspN9Unv0MHnJsnWCukCd+7D/wf5oqxUAHq
        QQnxF6pNKHdR6PPtzjOtVQtsqpWSjghEcDVRlL7JWEpJUrt6DO9aabyT84jujnErzHBoQk
        n8uMlnSPpWNjQJTAlRb0J6SKzoPCCeY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-w1Pu_FoLMK2DdPwe5MhkQQ-1; Tue, 10 Aug 2021 06:14:41 -0400
X-MC-Unique: w1Pu_FoLMK2DdPwe5MhkQQ-1
Received: by mail-ed1-f70.google.com with SMTP id y22-20020a0564023596b02903bd9452ad5cso10500355edc.20
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 03:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A42WvvsgdwjkwZlZk69nEpIcOnUU9ZyOs8J0bgwxJg8=;
        b=Fcz6lid1Y9pQkLpInXpfV2p2/sFu6zlvO4T7repi5aKb6lIcNobhsHAFf2tyyhQXa1
         fQq5vsD/Fv2cUbvmMrlSpVQnU/5j4j6auQ/OZ3PvlMyNWUXOJlsBB08UoE/yoMka+VLN
         ndpTP+HJGPGzAqY/IwD16N3D2gdHJIpEM7pH11QkEdyVvxG1cS8tUzLHDZP3+ulj0uhx
         2UquUZydMxSbG1lyvng3VKrewQ+W4+ZHiSS5GY74J4RC9+c7NJiUIHE38EZrlT7K7te7
         h7ku1sMOWs1LU8urkn1K1zpuGgMZH0khv9CwoCu++K+fSkLvkzirLgT4HDShR5ijUWN0
         JxLw==
X-Gm-Message-State: AOAM532W/ErtezKoabcBSfdTtvIg7iy8oW4QZOkqlJYRQfMFAxzsyHpy
        M99TMX6E7PQdbZdJjS5ABdCyCcHfbvw+GSv8VepmSggmmZxpJQoCQ/C6WyMZSei039s82wM2gG+
        TczB9S52NIaYrLUH//RqbT70uz+FtXUupza2w1n5nr/Rj1FE7PIZvaTuWTeFsU8tj
X-Received: by 2002:a17:906:410c:: with SMTP id j12mr4943743ejk.553.1628590479608;
        Tue, 10 Aug 2021 03:14:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPsmFryraUujm14vlfLq082aKn28Q0FPYdy2YVFyu0Ghw/NOtkyi4/HcVIa689iLhOoNqCng==
X-Received: by 2002:a17:906:410c:: with SMTP id j12mr4943712ejk.553.1628590479302;
        Tue, 10 Aug 2021 03:14:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id bm1sm6713471ejb.38.2021.08.10.03.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 03:14:38 -0700 (PDT)
Subject: Re: [PATCH V2 3/3] KVM: X86: Reset DR6 only when
 KVM_DEBUGREG_WONT_EXIT
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <YRFdq8sNuXYpgemU@google.com>
 <20210809174307.145263-1-jiangshanlai@gmail.com>
 <20210809174307.145263-3-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f07b99f1-5a25-a246-9ef9-2b875d960675@redhat.com>
Date:   Tue, 10 Aug 2021 12:14:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809174307.145263-3-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 19:43, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> The commit efdab992813fb ("KVM: x86: fix escape of guest dr6 to the host")
> fixed a bug by reseting DR6 unconditionally when the vcpu being scheduled out.
> 
> But writing to debug registers is slow, and it can be shown in perf results
> sometimes even neither the host nor the guest activate breakpoints.
> 
> It'd be better to reset it conditionally and this patch moves the code of
> reseting DR6 to the path of VM-exit and only reset it when
> KVM_DEBUGREG_WONT_EXIT which is the only case that DR6 is guest value.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/x86.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d2aa49722064..f40cdd7687d8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4309,12 +4309,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   
>   	static_call(kvm_x86_vcpu_put)(vcpu);
>   	vcpu->arch.last_host_tsc = rdtsc();
> -	/*
> -	 * If userspace has set any breakpoints or watchpoints, dr6 is restored
> -	 * on every vmexit, but if not, we might have a stale dr6 from the
> -	 * guest. do_debug expects dr6 to be cleared after it runs, do the same.
> -	 */
> -	set_debugreg(0, 6);
>   }
>   
>   static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
> @@ -9630,6 +9624,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
>   		kvm_update_dr0123(vcpu);
>   		kvm_update_dr7(vcpu);
> +		/* Reset Dr6 which is guest value. */
> +		set_debugreg(DR6_RESERVED, 6);
>   	}
>   
>   	/*
> 

... and this should also be done exclusively for VMX, in vmx_sync_dirty_debug_regs:

     KVM: VMX: Reset DR6 only when KVM_DEBUGREG_WONT_EXIT
     
     The commit efdab992813fb ("KVM: x86: fix escape of guest dr6 to the host")
     fixed a bug by resetting DR6 unconditionally when the vcpu being scheduled out.
     
     But writing to debug registers is slow, and it can be visible in perf results
     sometimes, even if neither the host nor the guest activate breakpoints.
     
     Since KVM_DEBUGREG_WONT_EXIT on Intel processors is the only case
     where DR6 gets the guest value, and it never happens at all on SVM,
     the register can be cleared in vmx.c right after reading it.
     
     Reported-by: Lai Jiangshan <laijs@linux.alibaba.com>
     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 21a3ef3012cf..3a91302d05c0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5110,6 +5110,12 @@ static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
  
  	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
  	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
+
+	/*
+	 * do_debug expects dr6 to be cleared after it runs, avoid that it sees
+	 * a stale dr6 from the guest.
+	 */
+	set_debugreg(DR6_RESERVED, 6);
  }
  
  static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbc536b21585..04c393551fb0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4313,12 +4313,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
  
  	static_call(kvm_x86_vcpu_put)(vcpu);
  	vcpu->arch.last_host_tsc = rdtsc();
-	/*
-	 * If userspace has set any breakpoints or watchpoints, dr6 is restored
-	 * on every vmexit, but if not, we might have a stale dr6 from the
-	 * guest. do_debug expects dr6 to be cleared after it runs, do the same.
-	 */
-	set_debugreg(0, 6);
  }
  
  static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,


Paolo

