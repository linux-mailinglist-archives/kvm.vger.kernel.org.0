Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FE165F373
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 19:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjAESJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 13:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbjAESIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 13:08:45 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C54DE94
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 10:08:19 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id b12so25028944pgj.6
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 10:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kHwNxW7tKzPeg+Rryqslw3Wesgthp6smnEvYGf9SYLk=;
        b=oA5BuhPf0EoT1DYeXnUSdVycWkj08PoWvaHPJaaRZ4exdvDnW9oEJ/DKu0hSGIAxTd
         RgC5AAR4GnpYUV2Nw8TV6XUnKFUs/aEfudyqYMPAARkegrb4XEpLjnTXA4xm9t5RMiu+
         bB15daqALL2UFw55poYn15D5F/2BTeDdBWEbTfac470r0/gqlT2KbCvJIXtfwHrp5N3f
         Lp1Es6drCmKGqq61jGUBxQDykfG1F7AFlltfuNl90BMLVxALQCV0b3wSvh8s0Tff33cf
         lbpuEZPm6SEuZctMyBn4gELGvW4upQTmrXdnbM/JzmCB8pDR0Jt1Hm8Xr9cNSHKL+sOO
         /8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHwNxW7tKzPeg+Rryqslw3Wesgthp6smnEvYGf9SYLk=;
        b=ceB9mvc1EUGhvcia3QBUptTnxK7+lwpSIqs0eSiEcFe/AYDL3vNxICMZpDX5R643uR
         nwJR//T0v/ZQXU8cAFAoeGjeadjLxwtWhNHYQE6JDy7Kbdj04uAP7SVl/vUv8ZWasjfs
         jE+njHByvplaLgEBia1+84gtx7y3x7Pqub4AYZVinZml7kqgAMoBeHdGUInE1J/hh0lZ
         h8xaYbo/EnTNRuVC903HMI5TsUjT5W4J7dgi/qf64i3nxpqVoD084pKfmL8UmCbix2cG
         cqFwh6pC6WEIFTZ0UZzXzlecKBOLUXFNhSJqiBQ56qgWuR1Ht1/zYNdH3TPE4OqbGknW
         oCDw==
X-Gm-Message-State: AFqh2krrv6gO4NDDZ6HhrNHJEZxDghVthjkpKV+Ihpt8HteNbKfXFmpP
        M63XuaS9DvFo5Ot0CHEZ9TjnIQ==
X-Google-Smtp-Source: AMrXdXuW3OyFaU+fjUBBEmFpO5eoCoyt9hENnAdiZiJUViWqCSoNXK4rgJtOw/M58Y0o7InTCv61rw==
X-Received: by 2002:a62:54c1:0:b0:574:8995:c0d0 with SMTP id i184-20020a6254c1000000b005748995c0d0mr235528pfb.1.1672942098472;
        Thu, 05 Jan 2023 10:08:18 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g23-20020aa796b7000000b005811082f134sm20313318pfk.158.2023.01.05.10.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 10:08:17 -0800 (PST)
Date:   Thu, 5 Jan 2023 18:08:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Replace cpu_dirty_logging_count with
 nr_memslots_dirty_logging
Message-ID: <Y7cSDjcqwv6XQvZh@google.com>
References: <20230105165431.2770276-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105165431.2770276-1-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023, David Matlack wrote:
> Drop cpu_dirty_logging_count in favor of nr_memslots_dirty_logging.
> Both fields count the number of memslots that have dirty-logging enabled,
> with the only difference being that cpu_dirty_logging_count is only
> incremented when using PML. So while nr_memslots_dirty_logging is not a
> direct replacement for cpu_dirty_logging_count, it can be combined with
> enable_pml to get the same information.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/vmx/vmx.c          | 8 +++++---
>  arch/x86/kvm/x86.c              | 8 ++------
>  3 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2f5bf581d00a..f328007ea05a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1329,7 +1329,6 @@ struct kvm_arch {
>  	u32 bsp_vcpu_id;
>  
>  	u64 disabled_quirks;
> -	int cpu_dirty_logging_count;
>  
>  	enum kvm_irqchip_mode irqchip_mode;
>  	u8 nr_reserved_ioapic_pins;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c788aa382611..9c1bf4dfafcc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4606,7 +4606,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  	 * it needs to be set here when dirty logging is already active, e.g.
>  	 * if this vCPU was created after dirty logging was enabled.
>  	 */
> -	if (!vcpu->kvm->arch.cpu_dirty_logging_count)
> +	if (!enable_pml || !atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
>  		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
>  
>  	if (cpu_has_vmx_xsaves()) {
> @@ -7993,12 +7993,14 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>  		return;
>  	}
>  
> +	WARN_ON_ONCE(!enable_pml);

If you're going to add a WARN, might as well bail and do nothing if !enable_pml.
Setting the VMCS bit could lead to a VMWRITE error and/or corrupt memory due to
enabling PML with a garbage buffer.

> +
>  	/*
> -	 * Note, cpu_dirty_logging_count can be changed concurrent with this
> +	 * Note, nr_memslots_dirty_logging can be changed concurrent with this
>  	 * code, but in that case another update request will be made and so
>  	 * the guest will never run with a stale PML value.
>  	 */
> -	if (vcpu->kvm->arch.cpu_dirty_logging_count)
> +	if (atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
>  		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_ENABLE_PML);
>  	else
>  		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c936f8d28a53..ee89a85bbd4e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12482,16 +12482,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  
>  static void kvm_mmu_update_cpu_dirty_logging(struct kvm *kvm, bool enable)
>  {
> -	struct kvm_arch *ka = &kvm->arch;
> -
>  	if (!kvm_x86_ops.cpu_dirty_log_size)
>  		return;
>  
> -	if ((enable && ++ka->cpu_dirty_logging_count == 1) ||
> -	    (!enable && --ka->cpu_dirty_logging_count == 0))
> +	if ((enable && atomic_read(&kvm->nr_memslots_dirty_logging) == 1) ||
> +	    (!enable && atomic_read(&kvm->nr_memslots_dirty_logging) == 0))

There's no need to force multiple reads of nr_memslots_dirty_logging.  And the
!enable check is unnecessary since this helper is called iff there's a change
(and we have bigger problems if the count wraps).

E.g. this could be

	int nr_slots;

	if (!kvm_x86_ops.cpu_dirty_log_size)
		return;

	nr_slots = atomic_read(&kvm->nr_memslots_dirty_logging);
	if ((enable && nr_slots == 1) || !nr_slots)
		kvm_make_all_cpus_request(kvm, KVM_REQ_UPDATE_CPU_DIRTY_LOGGING);

Or if we want to be unnecessarily clever :-)

	if (((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES) &&
	    kvm_x86_ops.cpu_dirty_log_size &&
	    !(atomic_read(&kvm->nr_memslots_dirty_logging) - log_dirty_pages))
		kvm_make_all_cpus_request(kvm, KVM_REQ_UPDATE_CPU_DIRTY_LOGGING);
