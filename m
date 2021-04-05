Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4719D354516
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhDEQZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbhDEQZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 12:25:23 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84E2C061756
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 09:25:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bg21so3281539pjb.0
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 09:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A7LZA9QoojiBRaV4UEcfyib9CO/RnpEZ7js5c5RemHs=;
        b=gpoaz/1x3/ohY9AD//Na6vxPnPb5AOV7aKRjkDS5rZL7wTTV29yotwJZAtnTqVc5QW
         +4F1UHut39wl/HVXjeSIswIz3xp9k1X803Oln6S8TdTXb2aE5V0XRpxvpQPj5unoKXAr
         +fHney/A20ywpW8mCxUYEUln0CYKhHaklTH2Zsctr/bzxrDWpQdLiSJzFQEc5zWtFBPc
         HvrvEWcDo4Cg6sc5ZJ9GjHExN/4YTCl3bDyjcxwkihKs8c8xBdzXLgliWhUzJAbUKbwA
         hO2jU6FMr/QxVfgWCi+Fk5o//eVh89bKx5hdOBNgVSsVYrS3qKNysgR13MWRaRbzy/8v
         +WEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A7LZA9QoojiBRaV4UEcfyib9CO/RnpEZ7js5c5RemHs=;
        b=aYiRsAv+vEJm9uFF75iA83FEaQxn3igRO+eUqlx6WThy3lhEdexH+23R/Xj3wOiRWF
         AVii4cRLxpkYuU5DogYbhGqfXjU0vIaT4kvoPhVuTP2jesGQf27cQ2FTbG2uGWYaSZ/6
         Kx52KMvyRE9GgjUmkW2rU/7qgjANfH/cWE/cyVCSfbF8gFS1QZLROvRKrcTbZ17+3Wjf
         lvFJ/yTNZkImXEqPMxRu3g4I87PoDuBSEOimU8vx3L/3O5NaV9uudwvJu5E5MADHB5LN
         TPFpyGGkbPGrqtkFV5QY/zSNNBudC9D0+Dsb/YMpD40e5Q7jpsy9GmLVYHP1qgCJ3/o+
         w/kQ==
X-Gm-Message-State: AOAM531F/iehwOaaZcH6adpptDiRZ5I1ule99IfpKEB6Bq61kx2uz7bi
        X7rRKrxuY75IbrY+tHzXI79OaA==
X-Google-Smtp-Source: ABdhPJz8mGA3h1jTbLHyRFa/saD6DJmZcqa+aPRUy8JSkIdF0pndROuTMDrKpHNzaVn80GR5WnE4BQ==
X-Received: by 2002:a17:90a:9404:: with SMTP id r4mr26863520pjo.64.1617639915153;
        Mon, 05 Apr 2021 09:25:15 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r1sm15679982pjo.26.2021.04.05.09.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 09:25:14 -0700 (PDT)
Date:   Mon, 5 Apr 2021 16:25:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Subject: Re: [RFC PATCH 05/12] kvm/vmx: Add KVM support on KeyLocker
 operations
Message-ID: <YGs557flJQr1Cbkb@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
 <1611565580-47718-6-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611565580-47718-6-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Robert Hoo wrote:
> On each VM-Entry, we need to resotre vCPU's IWKey, stored in kvm_vcpu_arch.

...

> +static int get_xmm(int index, u128 *mem_ptr)
> +{
> +	int ret = 0;
> +
> +	asm ("cli");
> +	switch (index) {
> +	case 0:
> +		asm ("movdqu %%xmm0, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 1:
> +		asm ("movdqu %%xmm1, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 2:
> +		asm ("movdqu %%xmm2, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 3:
> +		asm ("movdqu %%xmm3, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 4:
> +		asm ("movdqu %%xmm4, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 5:
> +		asm ("movdqu %%xmm5, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 6:
> +		asm ("movdqu %%xmm6, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 7:
> +		asm ("movdqu %%xmm7, %0" : : "m"(*mem_ptr));
> +		break;
> +#ifdef CONFIG_X86_64
> +	case 8:
> +		asm ("movdqu %%xmm8, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 9:
> +		asm ("movdqu %%xmm9, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 10:
> +		asm ("movdqu %%xmm10, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 11:
> +		asm ("movdqu %%xmm11, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 12:
> +		asm ("movdqu %%xmm12, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 13:
> +		asm ("movdqu %%xmm13, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 14:
> +		asm ("movdqu %%xmm14, %0" : : "m"(*mem_ptr));
> +		break;
> +	case 15:
> +		asm ("movdqu %%xmm15, %0" : : "m"(*mem_ptr));
> +		break;
> +#endif
> +	default:
> +		pr_err_once("xmm index exceeds");

That error message is not remotely helpful.  If this theoretically reachable,
make it a WARN.

> +		ret = -1;
> +		break;
> +	}
> +	asm ("sti");a

Don't code IRQ disabling/enabling.  Second, why are IRQs being disabled in this
low level helper?

> +
> +	return ret;
> +}
> +
> +static void vmx_load_guest_iwkey(struct kvm_vcpu *vcpu)
> +{
> +	u128 xmm[3] = {0};
> +
> +	if (vcpu->arch.iwkey_loaded) {

Loading the IWKey is not tied to the guest/host context switch.  IIUC, the intent
is to leave the IWKey in hardware while the host is running.  I.e. KVM should be
able to track which key is current resident in hardware separately from the
guest/host stuff.

And loading the IWKey only on VM-Enter iff the guest loaded a key means KVM is
leaking one VM's IWKey to all other VMs with KL enabled but that haven't loaded
their own IWKey. To prevent leaking a key, KVM would need to load the new vCPU's
key, even if it's "null", if the old vCPU _or_ the new vCPU has loaded a key.

> +		bool clear_cr4 = false;
> +		/* Save origin %xmm */
> +		get_xmm(0, &xmm[0]);
> +		get_xmm(1, &xmm[1]);
> +		get_xmm(2, &xmm[2]);
> +
> +		asm ("movdqu %0, %%xmm0;"
> +		     "movdqu %1, %%xmm1;"
> +		     "movdqu %2, %%xmm2;"
> +		     : : "m"(vcpu->arch.iwkey.integrity_key),
> +		     "m"(vcpu->arch.iwkey.encryption_key[0]),
> +		     "m"(vcpu->arch.iwkey.encryption_key[1]));
> +		if (!(cr4_read_shadow() & X86_CR4_KEYLOCKER)) {

Presumably this should assert that CR4.KL=0, otherwise it means the guest's key
is effectively being leaked to userspace.

> +			cr4_set_bits(X86_CR4_KEYLOCKER);
> +			clear_cr4 = true;
> +		}
> +		asm volatile(LOADIWKEY : : "a" (0x0));
> +		if (clear_cr4)
> +			cr4_clear_bits(X86_CR4_KEYLOCKER);
> +		/* restore %xmm */
> +		asm ("movdqu %0, %%xmm0;"
> +		     "movdqu %1, %%xmm1;"
> +		     "movdqu %2, %%xmm2;"
> +		     : : "m"(xmm[0]),
> +		     "m"(xmm[1]),
> +		     "m"(xmm[2]));
> +	}
> +}
> +
>  void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -1260,6 +1361,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  #endif
>  
>  	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
> +
> +	vmx_load_guest_iwkey(vcpu);
> +
>  	vmx->guest_state_loaded = true;
>  }
>  
