Return-Path: <kvm+bounces-53782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF2E2B16D45
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3AFB16CF7D
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E497D1FBEBD;
	Thu, 31 Jul 2025 08:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qQj7U4JD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CBC2D613
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949750; cv=none; b=hpfeIPU9jUeiyOb9+JSkgHMcAULXLeRi2V1NdPrw+5RVGdTeUlGRUkbn1rqUR5wVv7GVbF5EH0V0UN+gEhLfcadbooHhdWMAMtS/3hTz2AHz3hakYDFOB4Y8GrRZHLKEbrCK+NXvgZUPs2hDeoXCBy7hZTGNKI4ysYJu6ug7o9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949750; c=relaxed/simple;
	bh=G3TwnVv2ws+ArFsJ6yylpavyeu3llx2RDNcE+HMxtyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eElgNFxaiUpuK6vdlo9RIfSyxswkKm3/jk3Arkrz/79vPzHYVZRhz324ERuED0xLuUJRPxxys7xmzznF1HkRznrmQdPW9m0QWvzgHSX0KJA4oP6yScjxrIZgcE020R0qn6/F5oLkGk2Pf6cfiXNrUXajnW4cQzTsyp8wFeQKLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qQj7U4JD; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ab86a29c98so206081cf.0
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949747; x=1754554547; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtgeTLUnQXMXWU42NDS+n+b9sSh//OO5LLzxtMDq45g=;
        b=qQj7U4JD/Q2wr6UMuVKl1w4yIE6VC4upg/w72cK2pSGAGCLDRVlvUnFksQx1m5PPMy
         PveRfOTCDvSSJaFPlGZN5T8qIazGHWHXpY43Tp04DIOHM19y1I8n3Qj157EDsJwmzBCb
         +p+2IDx+rvzI11KF6ex5vzN6XJpY3eVugAtqR2PE24LQy2yJ3kIF/HGqqvyxFxHau2Jy
         /3T+JRbvFssANn8NcFq8ci1PoW1Qcoz2fBMs4Z5ElfcZ8U/pKfQOWq2rs02aXtxconxj
         rCRljJhRz1avVuT/CCrfZ7Xm76LgTnuGal3gvl8PxZKxrjmzRL0sSPKUxCG1a495EikA
         mg3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949747; x=1754554547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZtgeTLUnQXMXWU42NDS+n+b9sSh//OO5LLzxtMDq45g=;
        b=hAPtw64dSszrbLCvr0fupnNydEmjhoZhDseQSDBNG/nuYl1oM1HU1bQLerbeLnt4tr
         kNyufWvWHEc1ple0QvCgQ53EkDSIHARllHu+zQv/r6OkXRk4j/7L5daVgI5CMMZ7nqLU
         5UGsnC5qSk/Z9TBD3D+BaqGNNWPIPj1v3vhJmnJpJD7TebGrfbSwMiZCNjdy3oi/rakG
         yLQTmeAGRuWXZZCrn3MGVecBM67XmlWByoWSXv5Crlw3bNxYnp3kQmepnH3vhNhJXggZ
         5OKumFLqgkW0M6OiJHxPg2wT7vUAZKJpNXFpLvca7AEGxUlvCxGhsnsPpx3NpW/3enSQ
         8V1A==
X-Forwarded-Encrypted: i=1; AJvYcCX8ealoAFz4lNNM4EZLP01Uo2Q+PDSgBvT54EvjtOlHT5yYFBfTxNrprHDH5VpgKpPLgak=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtQw4Sx8Z6vUOsmPLifw9gqWNXY+yWO3+oGnDJhf4NiQ3w1lO7
	OEapTwdebE/AdhRPfRL/HUnGmbIrr3ApfpcNy8iwCq+AWvNby5ieerp+sjnZfGbWBk7AWRMLdP+
	IVHRQRe74GxFE4VQrMuh83qlPEHFKzs0VPtmWpGMP
X-Gm-Gg: ASbGncsoHAxQ7x5CjnGlCMoQoAUbp8WxDqHj5j2M0gbPzrIofxb7s1sJCOpGA+ookWp
	eIvTteMJwj95Q/bFHjbBAiBFg5KFkM7Ae1PwSfPksU9xVKhJGF4KmXicM3DfdatG3TStSGrzIwy
	vSPprcewYLRu7MTUNrJKt6dg+w7FXijR15isZaWmmWLcMmd0YutqAn/b2vClg1NxkMhsNP+j/dY
	ija8cwcxq8R1bUiJg==
X-Google-Smtp-Source: AGHT+IF3jlBckt17asL1OJitjRV0KoT4GNPiTrULyMmi9374k00fq9EfEoagert0ixcsHtiWtn0sZ/lfGp2Bbtfgh5k=
X-Received: by 2002:a05:622a:1989:b0:479:1958:d81a with SMTP id
 d75a77b69052e-4aeefd25399mr2200101cf.6.1753949746748; Thu, 31 Jul 2025
 01:15:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-13-seanjc@google.com>
In-Reply-To: <20250729225455.670324-13-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:15:10 +0100
X-Gm-Features: Ac12FXy9BehYhXYWaAAmIrERtbmas51wza3GSdkE_3UpVeAlSRu_uO9i-1FddA8
Message-ID: <CA+EHjTwuXT_wcDAOwwKP+yBetE9N46QMb+hUKAOsxBVkkOgCTw@mail.gmail.com>
Subject: Re: [PATCH v17 12/24] KVM: x86/mmu: Rename .private_max_mapping_level()
 to .gmem_max_mapping_level()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
> in anticipation of extending guest_memfd support to non-private memory.
>
> No functional change intended.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

nit: remove my "Signed-off-by", since I'm not a co-developer, and instead:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/include/asm/kvm-x86-ops.h | 2 +-
>  arch/x86/include/asm/kvm_host.h    | 2 +-
>  arch/x86/kvm/mmu/mmu.c             | 2 +-
>  arch/x86/kvm/svm/sev.c             | 2 +-
>  arch/x86/kvm/svm/svm.c             | 2 +-
>  arch/x86/kvm/svm/svm.h             | 4 ++--
>  arch/x86/kvm/vmx/main.c            | 6 +++---
>  arch/x86/kvm/vmx/tdx.c             | 2 +-
>  arch/x86/kvm/vmx/x86_ops.h         | 2 +-
>  9 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 18a5c3119e1a..62c3e4de3303 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -145,7 +145,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL(get_untagged_addr)
>  KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>  KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
> -KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
> +KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
>  KVM_X86_OP_OPTIONAL(gmem_invalidate)
>
>  #undef KVM_X86_OP
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 50366a1ca192..c0a739bf3829 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
>         void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>         int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>         void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> -       int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
> +       int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
>  };
>
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index fdc2824755ee..b735611e8fcd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4532,7 +4532,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>         if (max_level == PG_LEVEL_4K)
>                 return PG_LEVEL_4K;
>
> -       req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
> +       req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>         if (req_max_level)
>                 max_level = min(max_level, req_max_level);
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7744c210f947..be1c80d79331 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>         }
>  }
>
> -int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         int level, rc;
>         bool assigned;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d9931c6c4bc6..8a66e2e985a4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5180,7 +5180,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>
>         .gmem_prepare = sev_gmem_prepare,
>         .gmem_invalidate = sev_gmem_invalidate,
> -       .private_max_mapping_level = sev_private_max_mapping_level,
> +       .gmem_max_mapping_level = sev_gmem_max_mapping_level,
>  };
>
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 58b9d168e0c8..d84a83ae18a1 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>  void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> -int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
>  struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
>  void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
>  #else
> @@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
>         return 0;
>  }
>  static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
> -static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index dbab1c15b0cd..dd7687ef7e2d 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -831,10 +831,10 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>         return tdx_vcpu_ioctl(vcpu, argp);
>  }
>
> -static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         if (is_td(kvm))
> -               return tdx_gmem_private_max_mapping_level(kvm, pfn);
> +               return tdx_gmem_max_mapping_level(kvm, pfn);
>
>         return 0;
>  }
> @@ -1005,7 +1005,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>         .mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
>         .vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
>
> -       .private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
> +       .gmem_max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level)
>  };
>
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 66744f5768c8..b444714e8e8a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3318,7 +3318,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>         return ret;
>  }
>
> -int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         return PG_LEVEL_4K;
>  }
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 2b3424f638db..6037d1708485 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
>  void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
> -int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> --
> 2.50.1.552.g942d659e1b-goog
>

