Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDBD3E57FE
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 12:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbhHJKIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 06:08:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239700AbhHJKIR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 06:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628590075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dEgg1B68UoULU6E/e8M+gSz3xhhWUJATUN4So/YGl3Y=;
        b=i7cs9mMqi6pNopsmG00nOwopPy39XcgZgKLDYX6ihcnlKr8KtIVmeT6of+QQTbfFHlfYwb
        e3EjxoLAxWEdurM6SELrgeeVUzwMKFsqs/Jmdw17wcHIEXI2ueFU/F3NZh5FLVeN672ELM
        LECJpUGZPFzqOctpI5KSS9DSzkx3QCA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-7fkOm9JGOiazs_Gqho19Iw-1; Tue, 10 Aug 2021 06:07:55 -0400
X-MC-Unique: 7fkOm9JGOiazs_Gqho19Iw-1
Received: by mail-ej1-f71.google.com with SMTP id k21-20020a1709062a55b0290590e181cc34so5409502eje.3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 03:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dEgg1B68UoULU6E/e8M+gSz3xhhWUJATUN4So/YGl3Y=;
        b=KvNCJdffPZfOy1ObPL4pT4/GBr7j+g4VwRe0DyqB+8xKa8ZyZoemqooQ93ncPUfXBI
         XXfvATBle2G31KWw7BLS+S28V6+/zJYRLvGyvzPuSdWOndyMgPqNAHtT0SAx1AA6tXqw
         H+MpVj32QllDdqx4ETWV2NbDNxjYW2tVClLs2QHbThcWmx9ztEAMRDIOgk9BsHOVXbT3
         CnoF9RthQye1if4GpSrspnQNPA7w7Hzf4qheEamOTK6WuW+7ZbQ415EkoHtEaSpq+AD8
         XgqCRE6wzQHAtxVG2maR9pbinff7lPhEPvBnqDuH18z0CJrkZxb+HqTxub2wcaBeAoCF
         kb7w==
X-Gm-Message-State: AOAM5326jQC9jqo3X55QkgC4MIj3UZhUrKfEsvM9eeETDVc/9/9wFJRh
        MqqyKMHkltTBWSkpzSbQw3npieEMLwW5OC2a1dUaIRpIfHmSjN+4oRsp9/WX/7HKJr5pprvkvFT
        jlFC7TGJ8O5VeIGq/8sluqLOWUsEEjNV5jIBhseKzNNGLTitzjfwdO3RHZypJ4BK4
X-Received: by 2002:aa7:d593:: with SMTP id r19mr3945133edq.372.1628590073493;
        Tue, 10 Aug 2021 03:07:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYqkxr4BqRE4gHuK0TVd5eV864l8peu17Yfal47wvKOtzFRGKt6JOM2SgOQK4q5WbXkMMQuQ==
X-Received: by 2002:aa7:d593:: with SMTP id r19mr3945098edq.372.1628590073248;
        Tue, 10 Aug 2021 03:07:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id e22sm9278995edu.35.2021.08.10.03.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 03:07:52 -0700 (PDT)
Subject: Re: [PATCH V2 2/3] KVM: X86: Set the hardware DR6 only when
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
 <20210809174307.145263-2-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <68ed0f5c-40f1-c240-4ad1-b435568cf753@redhat.com>
Date:   Tue, 10 Aug 2021 12:07:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809174307.145263-2-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 19:43, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Commit c77fb5fe6f03 ("KVM: x86: Allow the guest to run with dirty debug
> registers") allows the guest accessing to DRs without exiting when
> KVM_DEBUGREG_WONT_EXIT and we need to ensure that they are synchronized
> on entry to the guest---including DR6 that was not synced before the commit.
> 
> But the commit sets the hardware DR6 not only when KVM_DEBUGREG_WONT_EXIT,
> but also when KVM_DEBUGREG_BP_ENABLED.  The second case is unnecessary
> and just leads to a more case which leaks stale DR6 to the host which has
> to be resolved by unconditionally reseting DR6 in kvm_arch_vcpu_put().
> 
> We'd better to set the hardware DR6 only when KVM_DEBUGREG_WONT_EXIT,
> so that we can fine-grain control the cases when we need to reset it
> which is done in later patch.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/x86.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ad47a09ce307..d2aa49722064 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9598,7 +9598,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   		set_debugreg(vcpu->arch.eff_db[1], 1);
>   		set_debugreg(vcpu->arch.eff_db[2], 2);
>   		set_debugreg(vcpu->arch.eff_db[3], 3);
> -		set_debugreg(vcpu->arch.dr6, 6);
> +		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
> +		if (vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
> +			set_debugreg(vcpu->arch.dr6, 6);
>   	} else if (unlikely(hw_breakpoint_active())) {
>   		set_debugreg(0, 7);
>   	}
> 

Even better, this should be moved to vmx.c's vcpu_enter_guest.  This
matches the handling in svm.c:

         /*
          * Run with all-zero DR6 unless needed, so that we can get the exact cause
          * of a #DB.
          */
         if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
                 svm_set_dr6(svm, vcpu->arch.dr6);
         else
                 svm_set_dr6(svm, DR6_ACTIVE_LOW);

That is,

     KVM: X86: Set the hardware DR6 only when KVM_DEBUGREG_WONT_EXIT
     
     Commit c77fb5fe6f03 ("KVM: x86: Allow the guest to run with dirty debug
     registers") allows the guest accessing to DRs without exiting when
     KVM_DEBUGREG_WONT_EXIT and we need to ensure that they are synchronized
     on entry to the guest---including DR6 that was not synced before the commit.
     
     But the commit sets the hardware DR6 not only when KVM_DEBUGREG_WONT_EXIT,
     but also when KVM_DEBUGREG_BP_ENABLED.  The second case is unnecessary
     and just leads to a more case which leaks stale DR6 to the host which has
     to be resolved by unconditionally reseting DR6 in kvm_arch_vcpu_put().
     
     Even if KVM_DEBUGREG_WONT_EXIT, however, setting the host DR6 only matters
     on VMX because SVM always uses the DR6 value from the VMCB.  So move this
     line to vmx.c and make it conditional on KVM_DEBUGREG_WONT_EXIT.
     
     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae8e62df16dd..21a3ef3012cf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6625,6 +6625,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
  		vmx->loaded_vmcs->host_state.cr4 = cr4;
  	}
  
+	/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
+	if (vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
+		set_debugreg(vcpu->arch.dr6, 6);
+
  	/* When single-stepping over STI and MOV SS, we must clear the
  	 * corresponding interruptibility bits in the guest state. Otherwise
  	 * vmentry fails as it then expects bit 14 (BS) in pending debug
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a111899ab2b4..fbc536b21585 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9597,7 +9597,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
  		set_debugreg(vcpu->arch.eff_db[1], 1);
  		set_debugreg(vcpu->arch.eff_db[2], 2);
  		set_debugreg(vcpu->arch.eff_db[3], 3);
-		set_debugreg(vcpu->arch.dr6, 6);
  	} else if (unlikely(hw_breakpoint_active())) {
  		set_debugreg(0, 7);
  	}

Paolo

