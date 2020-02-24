Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E587F16AA12
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgBXP2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:28:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727730AbgBXP2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 10:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582558111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wHAZ9y2pihKYw7c3k4iQPIjf+uieiRyVBchHD/9GTS4=;
        b=cBPKqPu4bGAwlYoArpKyqfbwRluWP3RR0nGdsQcTu/nkxsGpxKqTLi5HJRWHJ5D6U2+0yR
        3Kv/0aK1CwvSs1MvsGbMpkWPsZ/d+1VuPVtk+cDTKScDZ5grLxEQIaWTlONxMJufDLVJMN
        ic4HFjnRDzPviXcc4NiWCXVrTXk2Sts=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-UaWgEAEuOIycCGNWlVl3og-1; Mon, 24 Feb 2020 10:28:29 -0500
X-MC-Unique: UaWgEAEuOIycCGNWlVl3og-1
Received: by mail-wr1-f69.google.com with SMTP id y28so2153387wrd.23
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 07:28:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wHAZ9y2pihKYw7c3k4iQPIjf+uieiRyVBchHD/9GTS4=;
        b=O3duyWAn+kE4Icim2r1vZeSlVgDWH9sV0hchSmZJnf82jCN07/uaq+IhVcJodYLSW5
         cLVZMZmh35XeTiprVhsIvkkMOp24CVYTZBHj/JRY4NT/e9iXpmf52TYbQvGpSyLG3SoS
         wKbJkR15hk/yi8Hl7bYvkI1bQ5PBXk9t3IiAjjCZNeAKva5YyC7tdiTyIjIar6wSU23X
         luXQyk4I3JzstqxU1zGwvGfNCheEVHolFXOdjjjDO4BA25ncz2yJU0Q++rslv5oADwZC
         UZHlvrxHk5Dwjx97qnRQVt3q2fkK1h+sodugi0S5aIAryAcGa3B6mcCDilOcwfW/dofm
         0E8g==
X-Gm-Message-State: APjAAAXF04uSH+6ckqr7O9AWBnTMcLL2nbGEsbLibo5htQ1mSB3/32cN
        MXj34x5T78/nEp3vA8sNGXP+/DpRfyMD6QE+DxnQ2R+bOi5ZIn9Hx0NSc3EdnzPVgxSHhYRVgq4
        sKJ/nQ6yKJjx+
X-Received: by 2002:a5d:6390:: with SMTP id p16mr70107151wru.170.1582558108751;
        Mon, 24 Feb 2020 07:28:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqznNullXZQLscLdq0n1IkBlvgG6ZPyWj5WqLqKUAuN46cIaUur5xnd6Jzyz2xgqMhCUyDpmXw==
X-Received: by 2002:a5d:6390:: with SMTP id p16mr70107133wru.170.1582558108551;
        Mon, 24 Feb 2020 07:28:28 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b10sm19832764wrw.61.2020.02.24.07.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 07:28:28 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/61] KVM: x86: Handle RDTSCP CPUID adjustment in VMX code
In-Reply-To: <20200201185218.24473-35-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-35-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 16:28:27 +0100
Message-ID: <87sgj0ngx0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the clearing of the RDTSCP CPUID bit into VMX, which has a separate
> VMCS control to enable RDTSCP in non-root, to eliminate an instance of
> the undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
> common CPUID handling code.  Drop ->rdtscp_supported() since CPUID
> adjustment was the last remaining user.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c   | 3 +--
>  arch/x86/kvm/vmx/vmx.c | 4 ++++
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a1f46b3ca16e..fc507270f3f3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -424,7 +424,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	unsigned f_gbpages = 0;
>  	unsigned f_lm = 0;
>  #endif
> -	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
>  	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
>  	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  
> @@ -446,7 +445,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
>  		F(PAT) | F(PSE36) | 0 /* Reserved */ |
>  		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> -		F(FXSR) | F(FXSR_OPT) | f_gbpages | f_rdtscp |
> +		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
>  		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
>  	/* cpuid 1.ecx */
>  	const u32 kvm_cpuid_1_ecx_x86_features =
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a9728cc0c343..3990ba691d07 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7119,6 +7119,10 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  		    boot_cpu_has(X86_FEATURE_OSPKE))
>  			cpuid_entry_set(entry, X86_FEATURE_PKU);
>  		break;
> +	case 0x80000001:
> +		if (!cpu_has_vmx_rdtscp())
> +			cpuid_entry_clear(entry, X86_FEATURE_RDTSCP);
> +		break;
>  	default:
>  		break;
>  	}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

