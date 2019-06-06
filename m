Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF4C3796C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFFQYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:24:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34622 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729137AbfFFQYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:24:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so2201468wmd.1
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 09:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rSluPI56btHwkT0UmP6XbLUpQr210NLppBe3qmle39k=;
        b=DpUIiywVr3TEyRkEqCNrNwfw03eixz013BuCwcgwiz9d2xUcSw8IZd1s/y0jruCmw+
         9MF7LeiGY9MCY9Nalz1k3ndXxgcjxplI7Vo4lqGnoMRysjLkihsJ6+zlqybmEsXKnmOV
         vYqC9QgMWH+rdXPAVENMTJO+eV9CZ+ZN6KCyF3NqcNpzn7KEW3M2IrZSfVvXVWeWZ9un
         tjGK3waehWxygSV9sandHX+pYNZenaDoBwA0WDfQmKN9sefSyO5YU5mxVPqsuTrzLeoB
         kUthT3teJ1tTIOwgOEd4IypGXmDW2QTCVJS4YNZrLtBq+MWvXT7Ra4V/6Jph+wMUzs25
         PcTQ==
X-Gm-Message-State: APjAAAVB8er8MIKzRRdb+Ogifnrcqi8YzlOfW9WnXPLdqyJfeCzS327M
        4Lulu+rTP2OLdA+8rUkEl43R2/l4rC0=
X-Google-Smtp-Source: APXvYqxwXhRpwL6d6s+IWU4LBjBD6NeqQRsEkYuhoRGUtxKAPnSiGqmOZ/abTcAszWEguHiWQEfQDg==
X-Received: by 2002:a1c:ed07:: with SMTP id l7mr558128wmh.148.1559838285427;
        Thu, 06 Jun 2019 09:24:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id g11sm2230567wrq.89.2019.06.06.09.24.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:24:44 -0700 (PDT)
Subject: Re: [PATCH 06/15] KVM: nVMX: Don't "put" vCPU or host state when
 switching VMCS
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-7-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <79ac3a1c-8386-3f5a-2abd-eb284407abb7@redhat.com>
Date:   Thu, 6 Jun 2019 18:24:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507160640.4812-7-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 18:06, Sean Christopherson wrote:
> When switching between vmcs01 and vmcs02, KVM isn't actually switching
> between guest and host.  If guest state is already loaded (the likely,
> if not guaranteed, case), keep the guest state loaded and manually swap
> the loaded_cpu_state pointer after propagating saved host state to the
> new vmcs0{1,2}.
> 
> Avoiding the switch between guest and host reduces the latency of
> switching between vmcs01 and vmcs02 by several hundred cycles, and
> reduces the roundtrip time of a nested VM by upwards of 1000 cycles.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 18 +++++++++++++-
>  arch/x86/kvm/vmx/vmx.c    | 52 ++++++++++++++++++++++-----------------
>  arch/x86/kvm/vmx/vmx.h    |  3 ++-
>  3 files changed, 48 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a30d53823b2e..4651d3462df4 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -241,15 +241,31 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct vmcs_host_state *src;
> +	struct loaded_vmcs *prev;
>  	int cpu;
>  
>  	if (vmx->loaded_vmcs == vmcs)
>  		return;
>  
>  	cpu = get_cpu();
> -	vmx_vcpu_put(vcpu);
> +	prev = vmx->loaded_cpu_state;
>  	vmx->loaded_vmcs = vmcs;
>  	vmx_vcpu_load(vcpu, cpu);
> +
> +	if (likely(prev)) {
> +		src = &prev->host_state;
> +
> +		vmx_set_host_fs_gs(&vmcs->host_state, src->fs_sel, src->gs_sel,
> +				   src->fs_base, src->gs_base);
> +
> +		vmcs->host_state.ldt_sel = src->ldt_sel;
> +#ifdef CONFIG_X86_64
> +		vmcs->host_state.ds_sel = src->ds_sel;
> +		vmcs->host_state.es_sel = src->es_sel;
> +#endif
> +		vmx->loaded_cpu_state = vmcs;
> +	}
>  	put_cpu();

I'd like to extract this into a separate function:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 438fae1fef2a..83e436f201bf 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -248,34 +248,40 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(&vmx->nested.vmcs02);
 }
 
+static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx)
+{
+	struct loaded_vmcs *prev = vmx->loaded_cpu_state;
+	struct loaded_vmcs *cur;
+	struct vmcs_host_state *dest, *src;
+
+	if (unlikely(!prev))
+		return;
+
+	cur = &vmx->loaded_vmcs;
+	src = &prev->host_state;
+	dest = &cur->host_state;
+
+	vmx_set_host_fs_gs(dest, src->fs_sel, src->gs_sel, src->fs_base, src->gs_base);
+	dest->ldt_sel = src->ldt_sel;
+#ifdef CONFIG_X86_64
+	dest->ds_sel = src->ds_sel;
+	dest->es_sel = src->es_sel;
+#endif
+	vmx->loaded_cpu_state = cur;
+}
+
 static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct vmcs_host_state *src;
-	struct loaded_vmcs *prev;
 	int cpu;
 
 	if (vmx->loaded_vmcs == vmcs)
 		return;
 
 	cpu = get_cpu();
-	prev = vmx->loaded_cpu_state;
 	vmx->loaded_vmcs = vmcs;
 	vmx_vcpu_load(vcpu, cpu);
-
-	if (likely(prev)) {
-		src = &prev->host_state;
-
-		vmx_set_host_fs_gs(&vmcs->host_state, src->fs_sel, src->gs_sel,
-				   src->fs_base, src->gs_base);
-
-		vmcs->host_state.ldt_sel = src->ldt_sel;
-#ifdef CONFIG_X86_64
-		vmcs->host_state.ds_sel = src->ds_sel;
-		vmcs->host_state.es_sel = src->es_sel;
-#endif
-		vmx->loaded_cpu_state = vmcs;
-	}
+	vmx_sync_vmcs_host_state(vmx);
 	put_cpu();
 
 	vm_entry_controls_reset_shadow(vmx);

Paolo
