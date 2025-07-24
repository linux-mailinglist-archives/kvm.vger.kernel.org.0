Return-Path: <kvm+bounces-53412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89748B11404
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 00:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB5E67BCD8A
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 22:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C23423F295;
	Thu, 24 Jul 2025 22:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tkjiDh74"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EA23BD04
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 22:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753396420; cv=none; b=d2nshlDIQuvz1dGD5YeMmmCtvLYULtKGUKdqEBnAdD5xweP1rQBqQcQIiXoyduJH/b0Po0OD4DGfdeCH08iGsZD3sLd8ZfWXLm/+m2oqMHG7VE9fz9o9gScoQDkXF7zNy6qUCTBH+ECyWIOX38k5dxD6zapJFCOVy49VIG+Jtgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753396420; c=relaxed/simple;
	bh=fR04mv39CqWH9hOwlExnLKnmwlLVKhJNGIGbrPJHvtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qf/oD73ZgSXaaQoh3CB2H3E07+UewY6jcLvJLulnqYFwlhtZuc/xHxaBa1fqqyQrJZ/VTh8WeoyWRT8r53vLlKCT/T/bhWYWo2ouBvmaBu6Qgd5eWXtxLAAu4Sa+GhN0J2Mc8k4XWxGRHjVNVXHUqX26EIzMaIklOhRG4ESZeRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tkjiDh74; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311e98ee3fcso2931068a91.0
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 15:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396418; x=1754001218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=inLy5vcBNILr3/MOBz76JuwhCqWg6KJsocdJKuHsHow=;
        b=tkjiDh74RUnF0/IRfnpT70/TXT91ya+rk2ck+drbYaFsfyzRpCdynFm96YM/q7gORK
         +z/KAuF2z3vV1eZaJFW2Y0D6Phvg2MNQDEVpfO9apKmQLEMTCC/pNgw0E1re3n7SBePQ
         dPADMe6euklqPlPQD5+WTjH2Dr5IBSGDpFYAyD/alEj3XWXY4Wgb92NuM6HzkVMH5BdC
         8IQ3aGV3iAamrLx3qsC6NCbpv3VVAhjmVXhSRuffcagx9zYxtmIvMGQEb4e2kdiGEWBg
         7Teqy4j4qbLmwJSLG2HrVNuAxHjw3pNaPRTw7ongDssGEinyvVGWCDP/Bwf/3+yBXOGv
         Rwmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396418; x=1754001218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inLy5vcBNILr3/MOBz76JuwhCqWg6KJsocdJKuHsHow=;
        b=v4zWBXNh1mU1Gr9pRbTJOWh79RJPxICDOl6Vv31zUlj05/PCBcI5wDYgLkshe9omia
         0/TnpdH/y4QccEN/Bvx2fslW/HDEkomUIMa85can4ld1rwkdpjyk7qlMICwup2J3b946
         DBpVAgR1ksBdGen5oihbrtPoJwrVbxMYqnElov0NocurIKbmhFdwOla+JJ1wE5QclkVl
         vTYk7ygZ2gM6xjZ50ulHb8UOcxD6qUvmWX1neNxW65rMnoH5JGsdi5ICf4ZIzNQ1APt6
         zO7N0+BPm1oKWSBwlahujA5G3KF1dpaiCCep3xD/v57biiSTLjbII+uKYoN+HNanZErc
         O8zA==
X-Forwarded-Encrypted: i=1; AJvYcCU22yUj3KHPktqbsBTF5fdP8DTGC9P++KDBuVhz5aqW/vT8cS6tqkWIUoc+8lszqMjjeRI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRC8GIOojC6hnBumLqI3gAk/ro5zGeAIYw63CujG71+t1NzJBh
	27rMJN+P1NHzA6mOpFrl5C60O/wUevBzOF6L4DPSdnB7lrCRL/Kh5WHVAaZcEuU9OVQpo4djxP9
	HmnMAlQ==
X-Google-Smtp-Source: AGHT+IE9v+AMqISEN6fUyAdtK8mFeHQvOl0cmpRw928j7ZGnBCeUKwILml7veHgu+g+g3U0uNgaRQdu3bsM=
X-Received: from pjbsy11.prod.google.com ([2002:a17:90b:2d0b:b0:31a:aa02:8c50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0b:b0:30a:3e8e:ea30
 with SMTP id 98e67ed59e1d1-31e662e841emr4851203a91.11.1753396418146; Thu, 24
 Jul 2025 15:33:38 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:33:36 -0700
In-Reply-To: <c301ec11-9d24-4cc6-9dc7-46800df4d5a8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-11-tabba@google.com>
 <c301ec11-9d24-4cc6-9dc7-46800df4d5a8@intel.com>
Message-ID: <aIK0wHgP91XhNEMC@google.com>
Subject: Re: [PATCH v16 10/22] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 23, 2025, Xiaoyao Li wrote:
> On 7/23/2025 6:47 PM, Fuad Tabba wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a1c49bc681c4..e5cd54ba1eaa 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13518,6 +13518,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
> > +#ifdef CONFIG_KVM_GUEST_MEMFD
> > +/*
> > + * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
> > + * (the private vs. shared tracking needs to be moved into guest_memfd).
> > + */
> > +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> > +{
> > +	return !kvm_arch_has_private_mem(kvm);
> > +}
> > +
> 
> I think it's better to move the kvm_arch_supports_gmem_mmap() stuff to patch
> 20. Because we don't know how kvm_arch_supports_gmem_mmap() is going to be
> used unitll that patch.

No strong preference on my end.

