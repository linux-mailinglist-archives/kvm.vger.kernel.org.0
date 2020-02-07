Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40ED8155BB6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 17:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBGQZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 11:25:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35147 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726874AbgBGQZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 11:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581092757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1A4AnPYG4QKudcgCccIbKk1UqeHiL89Ca/26LbtLNW0=;
        b=TTsJWg/z6Bufg8NOGA7/vSgYWPlt/n7mvcrdpjSrmfaKo+tqYUupjxpcLPVSfTe/buTKjO
        BtLlFIQNP9mEHmhFooSvMbQNpHzaGEqxUTLDtJEIIwI+0Ub8cIUFeQNjrXYyrfVOxAzDxo
        s7pWeKHFp2yAterED1Hc2g/5zuZU6HY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-MH39CF0jOQqPIdou9QFOUQ-1; Fri, 07 Feb 2020 11:25:52 -0500
X-MC-Unique: MH39CF0jOQqPIdou9QFOUQ-1
Received: by mail-wm1-f69.google.com with SMTP id z7so961358wmi.0
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 08:25:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1A4AnPYG4QKudcgCccIbKk1UqeHiL89Ca/26LbtLNW0=;
        b=c67+qFSPsLbKgPri8Crk4uuCsAZwVRCcjNEaoRqnXRyhNomO90lSgft0cBMxS5u47J
         UoIKAdQi+JSbKjcrU7+6UIIw8DElkiK9C2EIXO1e+J003M2aHQm8/eYHq3Li44Oqe0Zv
         /RMUikrvjTsIRW9fRPHoh0HGF/Fpj5MtM0nBaPpu89O5ky4dLMkEoLye2Pn+4epryCcI
         hbhlQNbKxKqQsW4ilf4PCZT5c/kJv99EUS5CxIMxKz4v9GNnpqFAuuKGI4ugSv7fIfsL
         0cVz+VakUfpe0D/Gnwx9hChjF1wunBRkXMWignmz8+B9fJGU1lGIFmgU2BaEUmRmtN9o
         tfAA==
X-Gm-Message-State: APjAAAVtOV8zYP8dNCI/wuBo3gvQZsqwPG1YwsCAZaXyPoL7DURvOmoi
        9+CkO5jnDdlTFoc4Ml+9aMU180uqWwcdP30SomlU+iCxw/E4tAtiYTBgL2EyqwucAey8pb/Sggb
        eIQCK4hZoMvs9
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr5161410wmi.35.1581092751588;
        Fri, 07 Feb 2020 08:25:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqw301M5FoKZ0/Wzsw2hrBkoIM94RmCmiNqrRJGjHwwSRYaykvhuKE/qTOXZAcTjqdr1tHov0w==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr5161389wmi.35.1581092751345;
        Fri, 07 Feb 2020 08:25:51 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e22sm4044678wme.45.2020.02.07.08.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 08:25:50 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH v2] KVM: nVMX: Fix some comment typos and coding style
In-Reply-To: <1581088965-3334-1-git-send-email-linmiaohe@huawei.com>
References: <1581088965-3334-1-git-send-email-linmiaohe@huawei.com>
Date:   Fri, 07 Feb 2020 17:25:50 +0100
Message-ID: <87zhdupdo1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Fix some typos in the comments. Also fix coding style.
> [Sean Christopherson rewrites the comment of write_fault_to_shadow_pgtable
> field in struct kvm_vcpu_arch.]
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> v1->v2:
> Use Sean Christopherson' comment for write_fault_to_shadow_pgtable
> ---
>  arch/x86/include/asm/kvm_host.h | 16 +++++++++++++---
>  arch/x86/kvm/vmx/nested.c       |  5 +++--
>  2 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4dffbc10d3f8..40a0c0fd95ca 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -781,9 +781,19 @@ struct kvm_vcpu_arch {
>  	u64 msr_kvm_poll_control;
>  
>  	/*
> -	 * Indicate whether the access faults on its page table in guest
> -	 * which is set when fix page fault and used to detect unhandeable
> -	 * instruction.
> +	 * Indicates the guest is trying to write a gfn that contains one or
> +	 * more of the PTEs used to translate the write itself, i.e. the access
> +	 * is changing its own translation in the guest page tables.  KVM exits
> +	 * to userspace if emulation of the faulting instruction fails and this
> +	 * flag is set, as KVM cannot make forward progress.
> +	 *
> +	 * If emulation fails for a write to guest page tables, KVM unprotects
> +	 * (zaps) the shadow page for the target gfn and resumes the guest to
> +	 * retry the non-emulatable instruction (on hardware).  Unprotecting the
> +	 * gfn doesn't allow forward progress for a self-changing access because
> +	 * doing so also zaps the translation for the gfn, i.e. retrying the
> +	 * instruction will hit a !PRESENT fault, which results in a new shadow
> +	 * page and sends KVM back to square one.
>  	 */
>  	bool write_fault_to_shadow_pgtable;
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 657c2eda357c..e7faebccd733 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -544,7 +544,8 @@ static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
>  	}
>  }
>  
> -static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap) {
> +static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
> +{
>  	int msr;
>  
>  	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
> @@ -1981,7 +1982,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
>  	}
>  
>  	/*
> -	 * Clean fields data can't de used on VMLAUNCH and when we switch
> +	 * Clean fields data can't be used on VMLAUNCH and when we switch
>  	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
>  	 */
>  	if (from_launch || evmcs_gpa_changed)

With Sean's comment added the subject of the patch is a bit unexpected
:-) But the change itself looks good (and thanks Sean for the great
explanation!).

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

