Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0BA219270F
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 12:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgCYLZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 07:25:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:32887 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726658AbgCYLZP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 07:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585135514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=toouf1VcPqoKWzF0uloLZOST0OLlsiAbB9Xc6GTlTTc=;
        b=A594z0QU04LBy3nhaIJ/rn1Yj+LzQ/DR0BMWtuWXogG+cvI8ad9xxdFqGxZn6fAeFT5muX
        xNxxPxm+q//ZXssug64VU9l2hJFsdG24CFTt0JBJ5Gfb/K+G0JeAAw0e1/7W05/q6bDoq3
        v8FPqUYodtkkgbBo/5iaWuqD6Y243vc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-bwF2Onl_Po-rOuq4RNvCAQ-1; Wed, 25 Mar 2020 07:25:13 -0400
X-MC-Unique: bwF2Onl_Po-rOuq4RNvCAQ-1
Received: by mail-wm1-f69.google.com with SMTP id s15so577740wmc.0
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 04:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=toouf1VcPqoKWzF0uloLZOST0OLlsiAbB9Xc6GTlTTc=;
        b=ZM6cNrYc6pdM5o4M6zVG5G4zULA7D/Nzd6TIDR4Wj9SJsQxHlrOutYKSc3ynRMhndX
         ALuZlTeUnr09aFmaPv8PWz4/JyAI7d5iGO2vqFeDG5YGpADSxygEUzyE2uuhS6An0Mxp
         ci+g+yE6ArfpcA90o3omoQ2FnJq9LpoS/fJAekz3isZkhwtEZQSe0Nv/FQiUNEjRlPwr
         oMWPOUnxtvzPL/sqtq2D3+2q61VWtquChK5mR5p086YRsefmOuW45yKjVfo6cy0J6bm7
         75rwQnw/+WpBkt19ZcEquwav6WAaeOScNU2osY1XUq3n6tDLNHKgFsELcMu2FXfnQ731
         tAew==
X-Gm-Message-State: ANhLgQ3guovkT+2TYgIKzcPPbe0ctGS9fro4QukZ/E+iFMhGEcr3lXmr
        5YYp4BWgzYRhN6iIeLCzRtHQbGBugZgFGN2wxlhs7munY90g7A9xJYY5b8hcx8M3ofOv/T+xqdq
        D1nI9nyLjT8gh
X-Received: by 2002:a05:600c:257:: with SMTP id 23mr3070970wmj.155.1585135512020;
        Wed, 25 Mar 2020 04:25:12 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsJSQTRA98YX35iNWvD6a6KCjeDYNTNy8tWPfrPqFaCiOYjbOM2uTb5t1LUJ4AovLllT6FF0g==
X-Received: by 2002:a05:600c:257:: with SMTP id 23mr3070939wmj.155.1585135511814;
        Wed, 25 Mar 2020 04:25:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d9sm5232553wmb.21.2020.03.25.04.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 04:25:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 18/37] KVM: VMX: Move vmx_flush_tlb() to vmx.c
In-Reply-To: <20200320212833.3507-19-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-19-sean.j.christopherson@intel.com>
Date:   Wed, 25 Mar 2020 12:25:09 +0100
Message-ID: <87tv2c65ii.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move vmx_flush_tlb() to vmx.c and make it non-inline static now that all
> its callers live in vmx.c.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h | 25 -------------------------
>  2 files changed, 25 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 477bdbc52ed0..c6affaaef138 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2849,6 +2849,31 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
>  
>  #endif
>  
> +static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	/*
> +	 * Flush all EPTP/VPID contexts, as the TLB flush _may_ have been
> +	 * invoked via kvm_flush_remote_tlbs().  Flushing remote TLBs requires
> +	 * all contexts to be flushed, not just the active context.
> +	 *
> +	 * Note, this also ensures a deferred TLB flush with VPID enabled and
> +	 * EPT disabled invalidates the "correct" VPID, by nuking both L1 and
> +	 * L2's VPIDs.
> +	 */
> +	if (enable_ept) {
> +		ept_sync_global();
> +	} else if (enable_vpid) {
> +		if (cpu_has_vmx_invvpid_global()) {
> +			vpid_sync_vcpu_global();
> +		} else {
> +			vpid_sync_vcpu_single(vmx->vpid);
> +			vpid_sync_vcpu_single(vmx->nested.vpid02);
> +		}
> +	}
> +}
> +
>  static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
>  {
>  	/*
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index bab5d62ad964..571249e18bb6 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -503,31 +503,6 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
>  
>  u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
>  
> -static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -
> -	/*
> -	 * Flush all EPTP/VPID contexts, as the TLB flush _may_ have been
> -	 * invoked via kvm_flush_remote_tlbs().  Flushing remote TLBs requires
> -	 * all contexts to be flushed, not just the active context.
> -	 *
> -	 * Note, this also ensures a deferred TLB flush with VPID enabled and
> -	 * EPT disabled invalidates the "correct" VPID, by nuking both L1 and
> -	 * L2's VPIDs.
> -	 */
> -	if (enable_ept) {
> -		ept_sync_global();
> -	} else if (enable_vpid) {
> -		if (cpu_has_vmx_invvpid_global()) {
> -			vpid_sync_vcpu_global();
> -		} else {
> -			vpid_sync_vcpu_single(vmx->vpid);
> -			vpid_sync_vcpu_single(vmx->nested.vpid02);
> -		}
> -	}
> -}
> -
>  static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
>  {
>  	vmx->current_tsc_ratio = vmx->vcpu.arch.tsc_scaling_ratio;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

