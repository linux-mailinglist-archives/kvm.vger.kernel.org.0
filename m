Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B6416A9F1
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgBXPVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:21:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21956 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727815AbgBXPVr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 10:21:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582557706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IopEsTUE5lI0cUR+880LPC7mmamlm8psrnpSr2ASOkM=;
        b=MBS5nb6POXBN9IqKB08AosvUlJtzHPPk1Aq2Bz9CKHjn34k4ElFXObOsV7Z+ClJljCNUQh
        MncDoR5EZOhEzv4F/cQyujBZfJJ4Lh6wsXNyvsbXTg0S+7c9WGMWlW+dcrkZB5lJcHlC/w
        z7T4AhteWEBY0B3f3X6gMg4bF6wb4lk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-kNx8jqzZM4m_jbF5inKDNQ-1; Mon, 24 Feb 2020 10:21:44 -0500
X-MC-Unique: kNx8jqzZM4m_jbF5inKDNQ-1
Received: by mail-wr1-f69.google.com with SMTP id l1so5772671wrt.4
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 07:21:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IopEsTUE5lI0cUR+880LPC7mmamlm8psrnpSr2ASOkM=;
        b=GRZmC2yIKPLP1tpdzBmV9cDqZhkZBUAYKweGJMiRWg2LRwL8XNF+a2MoGlT6Wmx1ry
         JSpP7cEFS2AvvkVwGsKiZrwo+5BFjLMqeT//38rCrrYW28oX0061dg82N156/iL9/hT4
         +l6rgnXIkcgORPB/n5aKpUhd1IWCaCDlwaZWzylyF6DM8B6KYZXQTPL8/W48GXjFzYM9
         BiTYGdbiKn6KaOnhzlJ4EQXy0ighnNYfd733YrMvEfa+aiSr4gPoiQFXEGFpO5HtiyND
         KKtqimUpK2CWtlm2pC9xe98zLVf6j/h8QRe942sUri/sQFgpd2lJbPpX2w2/N8F/D6PQ
         9GiQ==
X-Gm-Message-State: APjAAAVQogQTX6HpAdDsjz592PdwtVqMxp+ZhozRQqb+lhYWMOq+HKyt
        m9RGOSk2FpEccXcAkL+Ysnqc5AkiKtIRwiDn1M+PSExO8ei0zSurg+RoPPKkQzPqfI2sc4koW51
        99/GCgAtIQ4S1
X-Received: by 2002:a1c:6389:: with SMTP id x131mr23481538wmb.155.1582557703187;
        Mon, 24 Feb 2020 07:21:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYPhCx7IoeJSa2iQ/qLZj3RL6CoZ096gV1mztg+UbOH9RxjotR5udiQDnoBWE9fIOZLSaQqQ==
X-Received: by 2002:a1c:6389:: with SMTP id x131mr23481524wmb.155.1582557702990;
        Mon, 24 Feb 2020 07:21:42 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h13sm18581924wrw.54.2020.02.24.07.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 07:21:42 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 32/61] KVM: x86: Handle UMIP emulation CPUID adjustment in VMX code
In-Reply-To: <20200201185218.24473-33-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-33-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 16:21:41 +0100
Message-ID: <87y2ssnh8a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the CPUID adjustment for UMIP emulation into VMX code to eliminate
> an instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
> pattern in the common CPUID handling code.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c   | 2 --
>  arch/x86/kvm/vmx/vmx.c | 2 ++
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a5f150204d73..202a6c0f1db8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -339,7 +339,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  
>  static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  {
> -	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
>  	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  	unsigned f_la57;
>  	unsigned f_pku = kvm_x86_ops->pku_supported() ? F(PKU) : 0;
> @@ -382,7 +381,6 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  		cpuid_entry_mask(entry, CPUID_7_ECX);
>  		/* Set LA57 based on hardware capability. */
>  		entry->ecx |= f_la57;
> -		entry->ecx |= f_umip;
>  		entry->ecx |= f_pku;
>  		/* PKU is not yet implemented for shadow paging. */
>  		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 49ee4c600934..9d2e36a5ecb9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7111,6 +7111,8 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  			cpuid_entry_set(entry, X86_FEATURE_MPX);
>  		if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
>  			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
> +		if (vmx_umip_emulated())
> +			cpuid_entry_set(entry, X86_FEATURE_UMIP);
>  		break;
>  	default:
>  		break;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

