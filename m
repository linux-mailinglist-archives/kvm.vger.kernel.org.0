Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 164E78D363
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfHNMnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 08:43:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52132 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfHNMnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 08:43:42 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so4487443wma.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 05:43:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+/1vKYXrSmMiEh34sDlj/esL/DhVL71JkebODZigBoQ=;
        b=bl3bfexlsTIXGIpeZl2Ota1gZdOzo5u0d1/48I38n6Njebz6o2AoOnQvKqunV7U46O
         nWWW9y5dKCl5BEdcgZUcWfQ33gYjySXWqD1bw2nDBauX0UtI5YJ/UWM+aUv97uLa+qwN
         2qXHWYcyv3pMrTOt5ESEnXHcy7ItfKsKWs9SjxHnOfO1BF8V7H8RV80tLYNzt72pq4su
         pmEW2nA5wWbcEMm5dYFWOBRmI6G2iYe9KgrwjCFiBWpps5TMKaVGEQuD+vgGc/ICiFJk
         LEBFN6IZcBl0zKn+hIoYFiX1ik8X++LuGZ2/hastnJWMBCLmCxPl0qMaoZwzhkP8AVqV
         Nr1Q==
X-Gm-Message-State: APjAAAUsckxLoDFbFvt/IlbwhQYHsYTmpEY1gVuU0jOxigYblRwNeIkM
        Xht74u8XQJIOu1F3S064CYdMLR32cKY=
X-Google-Smtp-Source: APXvYqzzDAT9Sp0tyjPx2rBW0LPqA0/D9z0qNyAJbXa5Bd2dw94Fua3CJ4aiCqDB6gsk6UPMeEPDdw==
X-Received: by 2002:a7b:c383:: with SMTP id s3mr8408422wmj.44.1565786620557;
        Wed, 14 Aug 2019 05:43:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f197sm9387049wme.22.2019.08.14.05.43.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 05:43:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for SPP
In-Reply-To: <20190814070403.6588-6-weijiang.yang@intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com> <20190814070403.6588-6-weijiang.yang@intel.com>
Date:   Wed, 14 Aug 2019 14:43:39 +0200
Message-ID: <87a7cbapdw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yang Weijiang <weijiang.yang@intel.com> writes:

> init_spp() must be called before {get, set}_subpage
> functions, it creates subpage access bitmaps for memory pages
> and issues a KVM request to setup SPPT root pages.
>
> kvm_mmu_set_subpages() is to enable SPP bit in EPT leaf page
> and setup corresponding SPPT entries. The mmu_lock
> is held before above operation. If it's called in EPT fault and
> SPPT mis-config induced handler, mmu_lock is acquired outside
> the function, otherwise, it's acquired inside it.
>
> kvm_mmu_get_subpages() is used to query access bitmap for
> protected page, it's also used in EPT fault handler to check
> whether the fault EPT page is SPP protected as well.
>
> Co-developed-by: He Chen <he.chen@linux.intel.com>
> Signed-off-by: He Chen <he.chen@linux.intel.com>
> Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  18 ++++
>  arch/x86/include/asm/vmx.h      |   2 +
>  arch/x86/kvm/mmu.c              | 160 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c          |  48 ++++++++++
>  arch/x86/kvm/x86.c              |  40 ++++++++
>  include/linux/kvm_host.h        |   4 +-
>  include/uapi/linux/kvm.h        |   9 ++
>  7 files changed, 280 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 44f6e1757861..5c4882015acc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -398,8 +398,13 @@ struct kvm_mmu {
>  	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
>  	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  			   u64 *spte, const void *pte);
> +	int (*get_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
> +	int (*set_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
> +	int (*init_spp)(struct kvm *kvm);
> +
>  	hpa_t root_hpa;
>  	gpa_t root_cr3;
> +	hpa_t sppt_root;

(I'm sorry if this was previously discussed, I didn't look into previous
submissions).

What happens when we launch a nested guest and switch vcpu->arch.mmu to
point at arch.guest_mmu? sppt_root will point to INVALID_PAGE and SPP
won't be enabled in VMCS?

(I'm sorry again, I'm likely missing something obvious)

-- 
Vitaly
