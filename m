Return-Path: <kvm+bounces-14960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C118A8321
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C06D0282295
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB6113D507;
	Wed, 17 Apr 2024 12:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LNUabtQ+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C5013C675
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 12:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713356789; cv=none; b=Kg+Z5eaZ/wlp+OxTMcgxvGssk3KCql25POyUP6Gw+/U6VxEHXeQ0Xj7fICJ6AR0qyMnflEXQ5yqOCUmw8lnDBzudVo6wvDoG9DHscy+y2LM5hjYqNtxbIinXd3zvIMytfYxVCTNTEaYWN4rcCMDrtWM0kXNi5Zn1GN9t1EXTi60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713356789; c=relaxed/simple;
	bh=a1x/JGeunAJ99pD0ETab0nWzZU+s+CSX3gs4v9cifxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6WWEjn9UnlzzXuwoT6Du84B6Y14McrKIxljHTr2l24pfyLAhdjHsQs//byMB++xEVk/DjvvoDEF+tBOndiReJilIXoTWd6GNC9WhH7OplbpbZOjavHLzkNX//68EPQM/pvOAajE97BAtka3X5SZ49QR3nNrku50cqhHSKzkc6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LNUabtQ+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713356787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QjCmpTxAkwRUAZXHWPGWOp6O5gOmNOMLJtx2EWIqSUo=;
	b=LNUabtQ+yzbFIo4GmgoZHtHex8dtmNy5RMseIy4HLR5D9C8fwW7uSNQ3yXxjxoTARANlLb
	oOVX7naeqB2srVf4ojObhhtLus2+rG+SUnYKmd8lVrXslkxz2SoZKY4YT150gq4snYg1LG
	yhZJnzCnwBzxJJtHep+w+TPNp2GUV4c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-3aojC09QM8aHIrZZhAq5Dg-1; Wed, 17 Apr 2024 08:26:25 -0400
X-MC-Unique: 3aojC09QM8aHIrZZhAq5Dg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343c8e87a74so3854430f8f.0
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 05:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713356784; x=1713961584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QjCmpTxAkwRUAZXHWPGWOp6O5gOmNOMLJtx2EWIqSUo=;
        b=lK5j5bi34pKJzUc3pN2qZaZIfGeGFxNZ38iFAvFf6FOPt8OManCUFjHo4Yxj/pZc14
         gRZ+uaguS6QwAdY8EcQFQ2H0MbEXlkEuWxSyGVj86VOabqJ4xu/2gLBSCw8BxxlTBM8e
         0xau5V8xXyCxep+hLEE4p+5ILVSkJE8KSntbFGsG2ki3AmGYrzDwJUcPhmWGc7CfGUHV
         2ENc86ibVxx2UG3nygUFkbIYyCbBKiqfOQc7zI6kPnI9MV2KY4wjzqHOUBvyluMOwf3n
         ag7vTICdisMCDCdM83jxePyQVHy6mB7bJdOIPYzViQhcmfUoy+yZ+f03nvz5lugeKVB9
         5QKw==
X-Gm-Message-State: AOJu0YyMw+Eg/+9NCw7avkSrpSs9ZwHveK1WVBompHycpvpQhPMwD7u4
	c7Z42LPz8iwYpDxVR/DZfH2QRF2W9e1eSulFkjoajOd4K2+olCoCT6b3ED1fNRptgXaHAJ9o/3k
	I1aWNLYo/h/rC9Ie6bEYJnKE75WBWS8+Yv7dP2fzfqCCK/qTzKwAIdn/KXxqfmi9WDlYUc1k6hu
	NJHbR2acuhbotwuDf+eBtSgpBM
X-Received: by 2002:a5d:584a:0:b0:33e:dbc0:773 with SMTP id i10-20020a5d584a000000b0033edbc00773mr16693840wrf.44.1713356784484;
        Wed, 17 Apr 2024 05:26:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSEFGD8TxnC4i4Lh/XbsnoRvMHjunnzitshgwN7+xcyscfHfDeMP7OsrRkW32dxdUewUzdvUHkqWS2saZUY7s=
X-Received: by 2002:a5d:584a:0:b0:33e:dbc0:773 with SMTP id
 i10-20020a5d584a000000b0033edbc00773mr16693824wrf.44.1713356784161; Wed, 17
 Apr 2024 05:26:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1712785629.git.isaku.yamahata@intel.com> <7194bb75ac25fa98875b7891d7929655ab245205.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <7194bb75ac25fa98875b7891d7929655ab245205.1712785629.git.isaku.yamahata@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 14:26:12 +0200
Message-ID: <CABgObfYpjYZ-UY_Dh+-u-r-Gp2nBDiu0o5yScGrraCDj6wYcxw@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] KVM: x86: Add a hook in kvm_arch_vcpu_map_memory()
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Michael Roth <michael.roth@amd.com>, David Matlack <dmatlack@google.com>, 
	Federico Parola <federico.parola@polito.it>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 12:08=E2=80=AFAM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a hook in kvm_arch_vcpu_map_memory() for KVM_MAP_MEMORY before callin=
g
> kvm_mmu_map_page() to adjust the error code for a page fault.  The hook c=
an
> hold vendor-specific logic to make those adjustments and enforce the
> restrictions.  SEV and TDX KVM will use the hook.
>
> In the case of SEV and TDX, they need to adjust the KVM page fault error
> code or refuse the operation due to their restriction.  TDX requires that
> the guest memory population must be before finalizing the VM.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v2:
> - Make pre_mmu_map_page() to take error_code.
> - Drop post_mmu_map_page().
> - Drop struct kvm_memory_map.source check.
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  3 +++
>  arch/x86/kvm/x86.c                 | 28 ++++++++++++++++++++++++++++
>  3 files changed, 32 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 5187fcf4b610..a5d4f4d5265d 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -139,6 +139,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL(get_untagged_addr)
>  KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
> +KVM_X86_OP_OPTIONAL(pre_mmu_map_page);
>
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 3ce244ad44e5..2bf7f97f889b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1812,6 +1812,9 @@ struct kvm_x86_ops {
>
>         gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsi=
gned int flags);
>         void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
> +       int (*pre_mmu_map_page)(struct kvm_vcpu *vcpu,
> +                               struct kvm_memory_mapping *mapping,
> +                               u64 *error_code);
>  };
>
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8ba9c1720ac9..b76d854701d5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5868,6 +5868,26 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vc=
pu *vcpu,
>         }
>  }
>
> +static int kvm_pre_mmu_map_page(struct kvm_vcpu *vcpu,
> +                               struct kvm_memory_mapping *mapping,
> +                               u64 *error_code)
> +{
> +       int r =3D 0;
> +
> +       if (vcpu->kvm->arch.vm_type =3D=3D KVM_X86_DEFAULT_VM) {
> +               /* nothing */
> +       } else if (vcpu->kvm->arch.vm_type =3D=3D KVM_X86_SW_PROTECTED_VM=
) {
> +               if (kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(mapping->bas=
e_address)))
> +                       *error_code |=3D PFERR_PRIVATE_ACCESS;

This can probably be done for all VM types, not just KVM_X86_SW_PROTECTED_V=
M.

For now I am going to squash

        if (kvm_arch_has_private_mem(vcpu->kvm) &&
            kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(mapping->base_address)=
))
                *error_code |=3D PFERR_GUEST_ENC_MASK;

in the previous patch. If TDX or SEV need to adjust, they can
introduce the hook where we know if/how it is used.

Paolo


