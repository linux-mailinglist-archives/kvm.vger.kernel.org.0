Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DCA18469B
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 13:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgCMMOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 08:14:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23637 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgCMMOp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 08:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584101683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hqgOELx5Eh0w6B52bJXObYBgYmHtgSglsBGhlheS4bg=;
        b=h6Gip6vl+NytuHq9TexbiMoLjqvzsw3ZNBr6UKJ2ZeWdmiZLJkXgaY9k81RTSj7cc8KoOr
        ok3c94yzm1DWEVXjaHJRz5hmJQP4dP3wm/gWSvlHKCfOaQJ8o2DnLjZLIYDahcDS8AbpHJ
        MguJSqojReJ7/8zDHZXc0hU3tzlvt8k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-8CvhTfPCOuKVblcgnep06g-1; Fri, 13 Mar 2020 08:14:42 -0400
X-MC-Unique: 8CvhTfPCOuKVblcgnep06g-1
Received: by mail-wm1-f69.google.com with SMTP id x7so2858748wmi.4
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 05:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hqgOELx5Eh0w6B52bJXObYBgYmHtgSglsBGhlheS4bg=;
        b=nasijz3Z7WbIeXT4Ee4KdFItrqNPyJ+6MzOc18NtrTmQV9Zj+oL70sD7h5g5uIOd2D
         hlJUI0jX8fgjFLeFuKwle/BSxNqqG/bhTeNU5wa865gSii9iBHhJG2CyNASWyDss8Eyr
         mjWxE6zewbz8+8bWreMQxyCVqMb+ea9r61sOSsVQ5zJau3eqz8uT12f8DM1RrJq/xtta
         RB6w1ZkE7tsCCZT089dKvqewa0b08QIFqVr0ev8KzL+fXFpu5xivPDnClAbVhW1kc0e2
         HW+mrLNb/skYQvUPwL2qu/BXaz3dVfrA2Eba2ARA2vURekRAmjDBZCkKwGJfce5KXEjj
         hyYQ==
X-Gm-Message-State: ANhLgQ3ksNPyhwHXp6v62G/N0C72U1qMg5GemQ2ZIGtT6L+ZuTgdX4t6
        FUUUDCn0M137ZJyoicA4kUETmTD/vVDWw8nUw+QsQZM3vNUVc+p379A4MLuK9ZFT1gYzOomxIe3
        Lx+d/n8yIbvjV
X-Received: by 2002:a05:600c:20c9:: with SMTP id y9mr11209441wmm.83.1584101681173;
        Fri, 13 Mar 2020 05:14:41 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvjCNKxnvFmlZOYRIS69ZrrfDY8J2ZBKXrNdmq2sDPmSgUuGhwVfudb9nPw33+JXSmrftWkLQ==
X-Received: by 2002:a05:600c:20c9:: with SMTP id y9mr11209402wmm.83.1584101680892;
        Fri, 13 Mar 2020 05:14:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l5sm16033461wml.3.2020.03.13.05.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 05:14:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 02/10] KVM: nVMX: Drop a superfluous WARN on reflecting EXTERNAL_INTERRUPT
In-Reply-To: <20200312184521.24579-3-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com> <20200312184521.24579-3-sean.j.christopherson@intel.com>
Date:   Fri, 13 Mar 2020 13:14:39 +0100
Message-ID: <87h7yspi34.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Drop the WARN in nested_vmx_reflect_vmexit() that fires if KVM attempts
> to reflect an external interrupt.  nested_vmx_exit_reflected() is now
> called from nested_vmx_reflect_vmexit() and unconditionally returns
> false for EXTERNAL_INTERRUPT, i.e. barring a compiler or major CPU bug,
> the WARN will never fire.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.h | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 6bc379cf4755..8f5ff3e259c9 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -84,12 +84,11 @@ static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
>  		return false;
>  
>  	/*
> -	 * At this point, the exit interruption info in exit_intr_info
> -	 * is only valid for EXCEPTION_NMI exits.  For EXTERNAL_INTERRUPT
> -	 * we need to query the in-kernel LAPIC.
> +	 * vmcs.VM_EXIT_INTR_INFO is only valid for EXCEPTION_NMI exits.  For
> +	 * EXTERNAL_INTERRUPT, the value for vmcs12->vm_exit_intr_info would
> +	 * need to be synthesized by querying the in-kernel LAPIC, but external
> +	 * interrupts are never reflected to L1 so it's a non-issue.
>  	 */
> -	WARN_ON(exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT);
> -
>  	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>  	if ((exit_intr_info &
>  	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

