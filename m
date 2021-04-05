Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2E2354389
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 17:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238060AbhDEPo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 11:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbhDEPo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 11:44:58 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D2FC061756
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 08:44:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so8046678pjh.1
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 08:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QEBYV0bUd39idTTYmf9J3BR+9onSj5qnL2jn3y4hJB0=;
        b=YNMLStzmNd068sH1TZQgh018+Kiihsv5Rvxrl3UTOdfg2oBYa1Wq11s28Jwg5S3alu
         dmvYLUERbVIfDJ/274XnsrN7Q6nBp/RTIovFfvvgmsoZp9KvA2x8j+IwzLJIU/VJbqNI
         9/n2ML6CyNCzf9iqUQ/YzFYCiFPviniHy6eZsPrIp3y4q/O2+zEDUh86IMHO7De1y0Iu
         9sM14mnjy6vF6VaRwF/jwryBCaJOHE3t+Vd70KTJ0I/vH0q40l3ZdluHrhwubhgjAhCh
         rRskb+AuAsVVzQgEbY4YzmpSKMS6XjznLPk8G4oAc7Q3llStRYWuM5rlajDx78XJXJge
         2V2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QEBYV0bUd39idTTYmf9J3BR+9onSj5qnL2jn3y4hJB0=;
        b=SwnCC6lUZY/ep8YBGXqNAxyNjlWBv//mzwGqzxxsc8HbshkGYQda6ER78q2gNFa52X
         mTADmBgjqa5ywBhWLbgWIPX08QR3fyuMDRy818Py1K+wXWMgSuISLX8uSpYkskDtL8hi
         dRkVagkV/+UQ5WNqQQ6Pv4wCHEHRI0kqxUo+pa7k6+MoABHuU6dxOs2bt5H0+t2dmwSv
         k22JBbOMWuT6dPXEhzRPP//0uKuPIb2JLq5/J/nOEY1Kz7VmWFxRAMsJ4BkGj/tAh1pl
         RUYQqNMbk7579/bmyLy0jXrwyNadPEi9XWb1ig9XAkrO3wvAN5tGGX9/vRPhgEmoPtko
         LBFw==
X-Gm-Message-State: AOAM531QcUzeyxHjFQT/my1sbjNkT4Bulqh2vCbFrVPn/UoO9Nx1vQzS
        8a+QTBrALNtPL3RQqP1gZK6DUQ==
X-Google-Smtp-Source: ABdhPJxskKjeJMdIV2kp+vACm4/efVNAptexol8hBpPrNq2vGMtdDoiDDCNd7E87g085zCInXtTs+A==
X-Received: by 2002:a17:90a:ba05:: with SMTP id s5mr28007996pjr.194.1617637492081;
        Mon, 05 Apr 2021 08:44:52 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id bj15sm16132182pjb.9.2021.04.05.08.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 08:44:51 -0700 (PDT)
Date:   Mon, 5 Apr 2021 15:44:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Subject: Re: [RFC PATCH 07/12] kvm/vmx/nested: Support new
 IA32_VMX_PROCBASED_CTLS3 vmx feature control MSR
Message-ID: <YGswb1BM/58JiCZz@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
 <1611565580-47718-8-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611565580-47718-8-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Robert Hoo wrote:
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 89af692..9eb1c0b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1285,6 +1285,13 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>  		lowp = &vmx->nested.msrs.secondary_ctls_low;
>  		highp = &vmx->nested.msrs.secondary_ctls_high;
>  		break;
> +	/*
> +	 * MSR_IA32_VMX_PROCBASED_CTLS3 is 64bit, all allow-1.
> +	 * No need to check. Just return.

Uh, yes need to check.  Unsupported bits need to be '0'.

> +	 */
> +	case MSR_IA32_VMX_PROCBASED_CTLS3:
> +		vmx->nested.msrs.tertiary_ctls = data;
> +		return 0;
>  	default:
>  		BUG();
>  	}
> @@ -1421,6 +1428,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
>  	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
>  	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
>  	case MSR_IA32_VMX_PROCBASED_CTLS2:
> +	case MSR_IA32_VMX_PROCBASED_CTLS3:
>  		return vmx_restore_control_msr(vmx, msr_index, data);
>  	case MSR_IA32_VMX_MISC:
>  		return vmx_restore_vmx_misc(vmx, data);
> @@ -1516,6 +1524,9 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
>  			msrs->secondary_ctls_low,
>  			msrs->secondary_ctls_high);
>  		break;
> +	case MSR_IA32_VMX_PROCBASED_CTLS3:
> +		*pdata = msrs->tertiary_ctls;
> +		break;
>  	case MSR_IA32_VMX_EPT_VPID_CAP:
>  		*pdata = msrs->ept_caps |
>  			((u64)msrs->vpid_caps << 32);
> @@ -6375,7 +6386,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_TRAP_FLAG |
>  		CPU_BASED_MONITOR_EXITING | CPU_BASED_RDPMC_EXITING |
>  		CPU_BASED_RDTSC_EXITING | CPU_BASED_PAUSE_EXITING |
> -		CPU_BASED_TPR_SHADOW | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
> +		CPU_BASED_TPR_SHADOW | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
> +		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
>  	/*
>  	 * We can allow some features even when not supported by the
>  	 * hardware. For example, L1 can specify an MSR bitmap - and we
> @@ -6413,6 +6425,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  		SECONDARY_EXEC_RDSEED_EXITING |
>  		SECONDARY_EXEC_XSAVES;
>  
> +	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
> +		rdmsrl(MSR_IA32_VMX_PROCBASED_CTLS3,
> +		      msrs->tertiary_ctls);

No need to split that into two lines.

> +	msrs->tertiary_ctls &= ~TERTIARY_EXEC_LOADIWKEY_EXITING;

That's wrong, it should simply be "msrs->tertiary_ctls &= 0" until LOADIWKEY is
supported.

>  	/*
>  	 * We can emulate "VMCS shadowing," even if the hardware
>  	 * doesn't support it.
