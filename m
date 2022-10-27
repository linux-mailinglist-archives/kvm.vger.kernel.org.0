Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182EE60FF3D
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 19:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiJ0RW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 13:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiJ0RW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 13:22:57 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BDA18C42F
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:22:56 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q1so2127143pgl.11
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xdt63SxEY4K5w2+Q3gX7B2Gg/JGFNAEvy1g4Fz6Bigs=;
        b=mwkBETp7Xvfd3Q3OLg0X9IIOB8LNnUSkzSnhm0OTfyWbWfN3oK5uf763RGar2BdjU5
         arLT/eHJrhVQNpkaStEFQ8+BhVfxgEUuRLlZNdORyEC8cwD+Q+4aJFnISlD+1pjt8xTW
         1WtykhcYzWwr06eGi4SxRq8RPtQ7eXJB/ATOYTAhhlDOm472lps2aPwfx62D4B3bTbUm
         LLHQYK4KQ0xgFz+1KIYEUdzCUCnk5AAkQyX7nqE14H28sG8mvHjo1kXzAb/QB3DsP5rJ
         i/iYDj4qmdat4AeBPb/AT1PY2E8R7snjgQsaRSIrl0hMaMzHrj1tD2/9JLCoJsOHfCEE
         m4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdt63SxEY4K5w2+Q3gX7B2Gg/JGFNAEvy1g4Fz6Bigs=;
        b=KE1RrAVLJMJftnb0ouA6JNT5cEr5MOsW98gWqaN2mIUnUtWa4R3LyDjQFDEg+ib9r9
         LOd7Vko62+T4S6b3L3SjKkp9abRfzi0Flak/cwFSDLIy/doUwfyE8OMCpAEtpewGql1h
         mKgmBTb0rdpGfl75/dWR3MnI45zWqk9uWn3f1IrTAPyrr420nvXosVpoTIR+y8YdFk7i
         Phd4dNAZuKieWxExWqvsjLjljCp6HUVRAu4MZYXK1bxaQiQwk8QgOfepAcN9kKI6isyg
         WGVU29UMCbrhLIuVTDGa+Rep8R5S38IFu4867N+LMPjS+TnTtUlhxpTc7G3HE33WmZhb
         821A==
X-Gm-Message-State: ACrzQf1EnEubyEMpoyV0GJf1zz98V+vZbd3WbL/iwIfHydUU5v4ak6kk
        yF6SOE4U869mm2O0qbcGiziTxuWUoE7C8w==
X-Google-Smtp-Source: AMsMyM4Va5X7EVlPPmVuN2nFXHsVirgEyHnheYF9OPRkjs0ttBzH9CwemB+VfbK3vYt9XDKlEtPGUA==
X-Received: by 2002:a63:1a07:0:b0:46b:2825:f9cf with SMTP id a7-20020a631a07000000b0046b2825f9cfmr44154524pga.370.1666891375310;
        Thu, 27 Oct 2022 10:22:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i26-20020aa796fa000000b0056b8e788acesm1412983pfq.82.2022.10.27.10.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 10:22:54 -0700 (PDT)
Date:   Thu, 27 Oct 2022 17:22:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mhal@rbox.co
Subject: Re: [PATCH 03/16] KVM: x86: set gfn-to-pfn cache length consistently
 with VM word size
Message-ID: <Y1q+a3gtABqJPmmr@google.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
 <20221027161849.2989332-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027161849.2989332-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, Paolo Bonzini wrote:
> So, use the short size at activation time as well.  This means
> re-activating the cache if the guest requests the hypercall page
> multiple times with different word sizes (this can happen when
> kexec-ing, for example).

I don't understand the motivation for allowing a conditionally valid GPA.  I see
a lot of complexity and sub-optimal error handling for a use case that no one
cares about.  Realistically, userspace is never going to provide a GPA that only
works some of the time, because doing otherwise is just asking for a dead guest.

> +static int kvm_xen_reactivate_runstate_gpcs(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (vcpu->arch.xen.runstate_cache.active) {

This is not safe when called from kvm_xen_write_hypercall_page(), which doesn't
acquire kvm->lock and thus doesn't guard against a concurrent call via
kvm_xen_vcpu_set_attr().  That's likely a bug in itself, but even if that issue
is fixed, I don't see how this is yields a better uAPI than forcing userspace to
provide an address that is valid for all modes.

If the address becomes bad when the guest changes the hypercall page, the guest
is completely hosed through no fault of its own, whereas limiting the misaligned
detection to KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR means that any "bad" address
will result in immediate failure, i.e. makes it so that errors are 100% userspace
misconfiguration bugs.

> +			int r = kvm_xen_activate_runstate_gpc(vcpu,
> +					vcpu->arch.xen.runstate_cache.gpa);
> +			if (r < 0)

Returning immediately is wrong, as later vCPUs will have a valid, active cache
that hasn't been verified for 64-bit mode.

> +				return r;
> +		}
> +	}
> +	return 0;
> +}
> +
>  void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>  {
>  	struct kvm_vcpu_xen *vx = &v->arch.xen;
> @@ -212,11 +243,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>  	if (!vx->runstate_cache.active)
>  		return;
>  
> -	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
> -		user_len = sizeof(struct vcpu_runstate_info);
> -	else
> -		user_len = sizeof(struct compat_vcpu_runstate_info);
> -
> +	user_len = kvm_xen_runstate_info_size(v->kvm);
>  	read_lock_irqsave(&gpc->lock, flags);
>  	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
>  					   user_len)) {
> @@ -461,7 +488,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  			mutex_lock(&kvm->lock);
>  			kvm->arch.xen.long_mode = !!data->u.long_mode;
>  			mutex_unlock(&kvm->lock);
> -			r = 0;
> +			r = kvm_xen_reactivate_runstate_gpcs(kvm);

Needs to be called under kvm->lock.  This path also needs to acquire kvm->srcu.

>  		}
>  		break;
>  
> @@ -596,9 +623,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  			break;
>  		}
>  
> -		r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
> -				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
> -				     sizeof(struct vcpu_runstate_info));
> +		r = kvm_xen_activate_runstate_gpc(vcpu, data->u.gpa);
>  		break;
>  
>  	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
> @@ -843,9 +868,13 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>  	u32 page_num = data & ~PAGE_MASK;
>  	u64 page_addr = data & PAGE_MASK;
>  	bool lm = is_long_mode(vcpu);
> +	int r;
>  
>  	/* Latch long_mode for shared_info pages etc. */
>  	vcpu->kvm->arch.xen.long_mode = lm;
> +	r = kvm_xen_reactivate_runstate_gpcs(kvm);
> +	if (r < 0)
> +		return 1;

Aren't we just making up behavior at this point?  Injecting a #GP into the guest
for what is a completely legal operation from the guest's perspective seems all
kinds of wrong.
