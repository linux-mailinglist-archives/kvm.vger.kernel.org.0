Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0E3E1EE4
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 00:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbhHEWgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 18:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241198AbhHEWf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 18:35:58 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF8AC0617B1
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 15:35:35 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so18489858pjb.2
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 15:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rhBbxf1keApeH0HZr94f6ha2IwXSaTleZr4Kiwj/80I=;
        b=EivLKAHlfNh5KZVAVEWVk6jIbCxTHLY2FgBazDi5lsAIxuSkUlJhIk2wt4798LDj+A
         p97JIOuPQyPl4mGn27jmN+mvK5HS/UdqrjyiQSnoPdAp7yvv9udPYqU9mb/39rZYSRmE
         7sK7tAxHWAypgvRxbwvsI0kaXMcZo+jJ9JFKKZ97UzZ/VMDynFZX6wzHlDtQb3Oh1DCm
         2eKah1AN6mmSpgWX3f1hbaydV0io/5ZBNUgckAk5GXTHa1/smG/VbMy22lc/tYu2RRKe
         3+pZcA31woyNn47DMWhgxiMIrDN9+fu54Z16nV1fyrLNJmhqX0IaCxQRqzcEY1J5DkeT
         mq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rhBbxf1keApeH0HZr94f6ha2IwXSaTleZr4Kiwj/80I=;
        b=pBzcy39oZFbpt26+MpXvs0fZcNMO9HiwCVteVc1h4Z3B4k3lQNx9RYRUQ0w+P07WJy
         fj6gxJY1hGprAd8Iyc+PVQEMHC4LFo34R9WUMCOkzR32Dmt8zeEtIX+lOEZ/fAOm+RXB
         n/bVgmVzgg7zbDZB9mUXska7rSjdircvmc797Uo4kjygryqkm8XTNGTknFshY/d370Rg
         6xbieRRrieZoF6e0vftkGpvXQVi8mn0IdXyqgQxgzZRQspc4WjpN8kl0V3CKXC6SYa+2
         pe7LRHV3byxCgjrEk/uKAScADCEdULm7aqvWCqXHUcy/Ek8B5PiDRWv7EPn21ziwpj9t
         u83Q==
X-Gm-Message-State: AOAM5301TOPyZmP7cdq5pN8uBtsoDRGUkiH5F/k3E2nPLkPMwL9bLnoI
        IrTYR9q/vGdXwiU3qhobXMvNMg==
X-Google-Smtp-Source: ABdhPJyOX8WyQFhtDFpV+MJoQfvcX4TDdK9nyvPy+iZO6MD4eVrgviSw/BBYz7FSfUSforNeQWtE+w==
X-Received: by 2002:a17:90a:70c5:: with SMTP id a5mr1274437pjm.23.1628202935199;
        Thu, 05 Aug 2021 15:35:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y2sm7309681pjl.6.2021.08.05.15.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 15:35:34 -0700 (PDT)
Date:   Thu, 5 Aug 2021 22:35:31 +0000
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
Subject: Re: [PATCH v3 3/6] KVM: VMX: Detect Tertiary VM-Execution control
 when setup VMCS config
Message-ID: <YQxns0wQ74d4X5VD@google.com>
References: <20210805151317.19054-1-guang.zeng@intel.com>
 <20210805151317.19054-4-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805151317.19054-4-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021, Zeng Guang wrote:
> +u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)

Make this static and drop the declaration from vmx.h, there's no nested user (yet),
and I'm also working on a patch to rework how prepare_vmcs02_early() gets KVMs
desires without having to call these heleprs, i.e. I want to bury all of these in
vmx.c.

> +{
> +	return vmcs_config.cpu_based_3rd_exec_ctrl;
> +}
> +
>  /*
>   * Adjust a single secondary execution control bit to intercept/allow an
>   * instruction in the guest.  This is usually done based on whether or not a
> @@ -4319,6 +4354,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
>  	}
>  
> +	if (cpu_has_tertiary_exec_ctrls())
> +		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
> +
>  	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
>  		vmcs_write64(EOI_EXIT_BITMAP0, 0);
>  		vmcs_write64(EOI_EXIT_BITMAP1, 0);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 945c6639ce24..448006bd8fa7 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -478,6 +478,7 @@ static inline u32 vmx_vmexit_ctrl(void)
>  
>  u32 vmx_exec_control(struct vcpu_vmx *vmx);
>  u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx);
> +u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx);
>  
>  static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
>  {
> -- 
> 2.25.1
> 
