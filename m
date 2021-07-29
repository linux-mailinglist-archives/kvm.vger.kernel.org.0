Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA993D99DA
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 02:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhG2AEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 20:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhG2AEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 20:04:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DE2C061765
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:04:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l19so7730235pjz.0
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CW8QUk9P9o2UEGEcBhQxw6hUF2SB0nBvDvcAFREKWG0=;
        b=p1HVDJ84ai7K3pcXHqczT0rOendqQSnKDQIkJGEQG94mnqrTbD0jqM3+xkRmHP3wi6
         DhxPuvPyJjrnCSKldBYopwhFtYIMXRt6Lv7S78/8cFIhPn+WDc9vK6g3oFIb+hSoGElQ
         KsQ+C6PRajcED+FgMfkZbBD0ZDi5whtifzZKg+rzwtiEO4o71BBsabs9TaHD0S6/2Ims
         2wWv0D6Z/rG4Pvq67KOxGEJ0UNTgpYWxl8hPWriw1A2EoUY0sR+SMVnuZU+NMxxc6Wmk
         tGs4VPywB7ceEtZKcEpQpilJKwdrBTCWhQ5xvKLijSnv/FelikOMx13QCBYu/ysF/7w9
         ATJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CW8QUk9P9o2UEGEcBhQxw6hUF2SB0nBvDvcAFREKWG0=;
        b=tX+gmkwZg93SVOrf9lENwWhHbKNwhblx8i5V8jA25CCrsddScS3AJ8KfTu1vvCQTB8
         9qDth7b8ZNNPeOq8sSfcNb1XJOHOXENlo+tidiDCwDa01t8Bu57tscgZ+ZrQgabwkth2
         f0nuykWLVbSuO+K9WPp5fXckl9snVii6JZYNiYXnt/nCl85cBOTzl8FZl9rcfuwU2Xzd
         Y8B4c4ZjtvMNJ2EPPLfHUdcAVhHk6JZE6s3PRE9ePEbDhwIac9KdsFo1f4xzbllmkAxs
         ke4wBeCLkjIhBsxYKcVOqedeA9LbsybczlaXFx9B9XMOoy9F/rslR6oYP84EG4Lu0Bb6
         ra2Q==
X-Gm-Message-State: AOAM530kPXqH7AKYL5PHZ+6KcR9IgBjOZ5epFW/jHsTh2F2rnBlf+5da
        ooPVTwzNAE9iOFaCZ2DgzCD6wA==
X-Google-Smtp-Source: ABdhPJwDDRusLfZvjJMLfqtso2qpQV/CB8c/tUNekSFj6j2EXCUX/AkxCcm3tJJLABPyZtQ1trwVcw==
X-Received: by 2002:aa7:8d56:0:b029:327:6dc:d254 with SMTP id s22-20020aa78d560000b029032706dcd254mr2268607pfe.69.1627517040296;
        Wed, 28 Jul 2021 17:04:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u19sm1183457pfi.4.2021.07.28.17.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 17:03:59 -0700 (PDT)
Date:   Thu, 29 Jul 2021 00:03:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH 3/6] KVM: VMX: Detect Tertiary VM-Execution control when
 setup VMCS config
Message-ID: <YQHwa42jixqPPvVm@google.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-4-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716064808.14757-4-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021, Zeng Guang wrote:
> @@ -4204,6 +4234,13 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
>  #define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
>  	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
>  
> +static void vmx_compute_tertiary_exec_control(struct vcpu_vmx *vmx)
> +{
> +	u32 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;

This is incorrectly truncating the value.

> +
> +	vmx->tertiary_exec_control = exec_control;
> +}
> +
>  static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  {
>  	struct kvm_vcpu *vcpu = &vmx->vcpu;
> @@ -4319,6 +4356,11 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
>  	}
>  
> +	if (cpu_has_tertiary_exec_ctrls()) {
> +		vmx_compute_tertiary_exec_control(vmx);
> +		tertiary_exec_controls_set(vmx, vmx->tertiary_exec_control);

IMO, the existing vmx->secondary_exec_control is an abomination that should not
exist.  Looking at the code, it's actually not hard to get rid, there's just one
annoying use in prepare_vmcs02_early() that requires a bit of extra work to get
rid of.

Anyways, for tertiary controls, I'd prefer to avoid the same mess and instead
follow vmx_exec_control(), both in functionality and in name:

  static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
  {
	return vmcs_config.cpu_based_3rd_exec_ctrl;
  }

and:

	if (cpu_has_tertiary_exec_ctrls())
		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));

and then the next patch becomes:

  static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
  {
	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;

	if (!kvm_vcpu_apicv_active(vcpu))
		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;

	return exec_control;
  }


And I'll work on a patch to purge vmx->secondary_exec_control.

> +	}
> +
>  	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
>  		vmcs_write64(EOI_EXIT_BITMAP0, 0);
>  		vmcs_write64(EOI_EXIT_BITMAP1, 0);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 945c6639ce24..c356ceebe84c 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -266,6 +266,7 @@ struct vcpu_vmx {
>  	u32		      msr_ia32_umwait_control;
>  
>  	u32 secondary_exec_control;
> +	u64 tertiary_exec_control;
>  
>  	/*
>  	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
> -- 
> 2.25.1
> 
