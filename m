Return-Path: <kvm+bounces-55667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EBE1B34ABE
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB4BB2A4A24
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8194A2777E5;
	Mon, 25 Aug 2025 19:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H1AxCg8g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092CA1C5496
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 19:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756148535; cv=none; b=BPdsFNQp2MTXjv4/9HtlzZFMrlhp9QPtSiYTremLqMqiRKgvp/CfoHvsWOU0MBNtVHNZ+nfiCdwTbtB/+bKxnSisywyxiXp2RMhN+2jxBSz0pxkWa+5+lPJCO9BdJOQN+t/KgnTqA5/U0wbA/YYDiHXWu1MYwhXuzXtls/KLPM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756148535; c=relaxed/simple;
	bh=sYYC0iVdbanWE7GDCqzygjBZmZhvkcgt/dDA7jE4oK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F1xDgyhhvMPwsUiIGMOcBaeuCUXnditzLML6z2vuhDWJQmDg9LLalhnrts/fhm2Bewz6bt81BHa50uDEl7PSWYXnzzNQBCtC1/ldhPtjBSN2cCZKT+caGzItZ8uA1cuVH6+jVy/tqzNapStElsmgWZcYIllX3L7kjx3+3Q2ozUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H1AxCg8g; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b29b714f8cso53221cf.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 12:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756148533; x=1756753333; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaQqo74RcW2JwMwPTXCT7AWCzpKJ0O5c0t8MVHlmC8g=;
        b=H1AxCg8gXWjC7rOplmxO6nnijCzO6mTT5YF90GDB/4t7W5Su4rndvA3BW4QE7p9iOV
         o/VijxGbjCMz8Hwv9dj08LANHchQL+y8KvX9YwwMaE31OH7BCey7zGgnk2mTTCxfkPk5
         bJF+Bs2m39w8DcV3ZEsIUntjzGKXJIR7TpOAXsc+bHdnp9F12e0abBM1kBl08rWxYqgo
         CwsRejgEqnE1r2HBfr94kUZjJKO1om8EeGY1APJyURKGS25FbKJPHdT82V5kSjzRXJV4
         92fHUMCDK1Km3SJTkdxX34Ow6ONqkgXjZouJQPO425MpecFBXWqwLIzIU4yqJZma0H9Z
         Vy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756148533; x=1756753333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IaQqo74RcW2JwMwPTXCT7AWCzpKJ0O5c0t8MVHlmC8g=;
        b=D3DZGiYY0YnQ1prJxPbE6Gbal2avB9h6yxK7XkG5y1y3itRg21mH75wR26eMZZjnBA
         AvXCNJYnKNif/cROgrq/k8K4u/9gCx6pZmLpu0jt1et3znWzMGKZtrrCSfYzhjJNqogF
         2l1sDYl37/CICVOV22+iyfI+zCFOMmByk5pK7wu+LY41goaOlDJN0Rn8sdDdxx55Xt2Y
         BCxsrgQJmTIzFl3nIJ7xlqFAcXSx0dZ8mtWd1o4pepKScgygu5wuUsdh8TmJNZfeIsa8
         QVN9KV5Cbp3uVmuwd92wYsstCznP+UXjWCRD4M8pKjZocBkAp6I6bUY2JnNJPQSoFPCV
         DTEA==
X-Forwarded-Encrypted: i=1; AJvYcCWQh+OzsYAW2Wsdh5kFeYjfAWW2MDa0WB9tS+H5eKaFNvaV2XLw8VoRcBdMMDNQnBvZHE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmmEa7pqElIvLegBp0ldLmKdOeSvPEhmzIanjGZS/gz7l6c177
	uKhaHYbLzBkvv+Snqp5Y6nJpeu9U0KV15rkx0CbDK5v7D9rmB7q+/adtT445JOrMyOdm8UZ5Bzm
	YcplPXbc8ZFFvnQB8Gck1lSEd1cmctSy/k0EY3VCi
X-Gm-Gg: ASbGncvFo4JnmMK/cC1jPmUdnUULTcOQxFbIHrf1779/1okeYO8gtyjIDOXkg4tuh1r
	CPutN5+OYcEgWfGl2LDzVFdcOmTgE8PTD7MXjrYcm5WFa2pMdEX5L52aKTDzf6Gb1f2RKxpkbiK
	mEMWvf8KQDx/h3Z+X82LQ0zQ7IJLbE73PuootHcgeN07xDJVqN25Eq6dYfPS0sv2i6uD21v5yie
	Tz5qVmAOZp0RwhhKJBMfqOgSKPNJRAveuQNdbme38+aUUXrGzjoPsYmOAncpxcf4cnV
X-Google-Smtp-Source: AGHT+IG37Fpm8pmS0cYjnY1zdEIsH2AvZlMaGDSJAsScgM0WNtuFkJEb/GM+J22/j3DUH8fA/on5QCRXgh9ENMNDfEc=
X-Received: by 2002:a05:622a:2a08:b0:4ae:d2cc:ad51 with SMTP id
 d75a77b69052e-4b2e1d7275dmr521981cf.1.1756148532292; Mon, 25 Aug 2025
 12:02:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-15-sagis@google.com>
 <aKwhchKBV1ts+Jhm@yzhao56-desk.sh.intel.com>
In-Reply-To: <aKwhchKBV1ts+Jhm@yzhao56-desk.sh.intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Mon, 25 Aug 2025 14:02:00 -0500
X-Gm-Features: Ac12FXzQbW3pU8ZuEpWVL71xnL6eIme2KZ_bnlMVjeOEZcTPvuL4Zc2kOAnffUI
Message-ID: <CAAhR5DGZnrpW8u9Y0O+EFLJJsbTVO6mdrh4jbG4CrFgR13Y60g@mail.gmail.com>
Subject: Re: [PATCH v9 14/19] KVM: selftests: Add helpers to init TDX memory
 and finalize VM
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2025 at 3:41=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Wed, Aug 20, 2025 at 09:29:07PM -0700, Sagi Shahar wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > TDX protected memory needs to be measured and encrypted before it can b=
e
> > used by the guest. Traverse the VM's memory regions and initialize all
> > the protected ranges by calling KVM_TDX_INIT_MEM_REGION.
> >
> > Once all the memory is initialized, the VM can be finalized by calling
> > KVM_TDX_FINALIZE_VM.
> >
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Co-developed-by: Erdem Aktas <erdemaktas@google.com>
> > Signed-off-by: Erdem Aktas <erdemaktas@google.com>
> > Co-developed-by: Sagi Shahar <sagis@google.com>
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  .../selftests/kvm/include/x86/tdx/tdx_util.h  |  2 +
> >  .../selftests/kvm/lib/x86/tdx/tdx_util.c      | 97 +++++++++++++++++++
> >  2 files changed, 99 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/t=
ools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
> > index a2509959c7ce..2467b6c35557 100644
> > --- a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
> > +++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
> > @@ -71,4 +71,6 @@ void vm_tdx_load_common_boot_parameters(struct kvm_vm=
 *vm);
> >  void vm_tdx_load_vcpu_boot_parameters(struct kvm_vm *vm, struct kvm_vc=
pu *vcpu);
> >  void vm_tdx_set_vcpu_entry_point(struct kvm_vcpu *vcpu, void *guest_co=
de);
> >
> > +void vm_tdx_finalize(struct kvm_vm *vm);
> > +
> >  #endif // SELFTESTS_TDX_TDX_UTIL_H
> > diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools=
/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > index d8eab99d9333..4024587ed3c2 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > @@ -274,3 +274,100 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t a=
ttributes)
> >
> >       free(init_vm);
> >  }
> > +
> > +static void tdx_init_mem_region(struct kvm_vm *vm, void *source_pages,
> > +                             uint64_t gpa, uint64_t size)
> > +{
> > +     uint32_t metadata =3D KVM_TDX_MEASURE_MEMORY_REGION;
> > +     struct kvm_tdx_init_mem_region mem_region =3D {
> > +             .source_addr =3D (uint64_t)source_pages,
> > +             .gpa =3D gpa,
> > +             .nr_pages =3D size / PAGE_SIZE,
> > +     };
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     vcpu =3D list_first_entry_or_null(&vm->vcpus, struct kvm_vcpu, li=
st);
> > +
> > +     TEST_ASSERT((mem_region.nr_pages > 0) &&
> > +                 ((mem_region.nr_pages * PAGE_SIZE) =3D=3D size),
> > +                 "Cannot add partial pages to the guest memory.\n");
> > +     TEST_ASSERT(((uint64_t)source_pages & (PAGE_SIZE - 1)) =3D=3D 0,
> > +                 "Source memory buffer is not page aligned\n");
> > +     vm_tdx_vcpu_ioctl(vcpu, KVM_TDX_INIT_MEM_REGION, metadata, &mem_r=
egion);
> > +}
> > +
> > +static void tdx_init_pages(struct kvm_vm *vm, void *hva, uint64_t gpa,
> > +                        uint64_t size)
> > +{
> > +     void *scratch_page =3D calloc(1, PAGE_SIZE);
> > +     uint64_t nr_pages =3D size / PAGE_SIZE;
> > +     int i;
> > +
> > +     TEST_ASSERT(scratch_page,
> > +                 "Could not allocate memory for loading memory region"=
);
> > +
> > +     for (i =3D 0; i < nr_pages; i++) {
> > +             memcpy(scratch_page, hva, PAGE_SIZE);
> > +
> > +             tdx_init_mem_region(vm, scratch_page, gpa, PAGE_SIZE);
> > +
> > +             hva +=3D PAGE_SIZE;
> > +             gpa +=3D PAGE_SIZE;
> > +     }
> > +
> > +     free(scratch_page);
> > +}
> > +
> > +static void load_td_private_memory(struct kvm_vm *vm)
> > +{
> > +     struct userspace_mem_region *region;
> > +     int ctr;
> > +
> > +     hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {
> > +             const struct sparsebit *protected_pages =3D region->prote=
cted_phy_pages;
> > +             const vm_paddr_t gpa_base =3D region->region.guest_phys_a=
ddr;
> > +             const uint64_t hva_base =3D region->region.userspace_addr=
;
> > +             const sparsebit_idx_t lowest_page_in_region =3D gpa_base =
>> vm->page_shift;
> > +
> > +             sparsebit_idx_t i;
> > +             sparsebit_idx_t j;
> > +
> > +             if (!sparsebit_any_set(protected_pages))
> > +                     continue;
> > +
> > +             sparsebit_for_each_set_range(protected_pages, i, j) {
> > +                     const uint64_t size_to_load =3D (j - i + 1) * vm-=
>page_size;
> > +                     const uint64_t offset =3D
> > +                             (i - lowest_page_in_region) * vm->page_si=
ze;
> > +                     const uint64_t hva =3D hva_base + offset;
> > +                     const uint64_t gpa =3D gpa_base + offset;
> > +
> > +                     vm_set_memory_attributes(vm, gpa, size_to_load,
> > +                                              KVM_MEMORY_ATTRIBUTE_PRI=
VATE);
> > +
> > +                     /*
> > +                      * Here, memory is being loaded from hva to gpa. =
If the memory
> > +                      * mapped to hva is also used to back gpa, then a=
 copy has to be
> > +                      * made just for loading, since KVM_TDX_INIT_MEM_=
REGION ioctl
> > +                      * cannot encrypt memory in place.
> > +                      *
> > +                      * To determine if memory mapped to hva is also u=
sed to back
> > +                      * gpa, use a heuristic:
> > +                      *
> > +                      * If this memslot has guest_memfd, then this mem=
slot should
> > +                      * have memory backed from two sources: hva for s=
hared memory
> > +                      * and gpa will be backed by guest_memfd.
> > +                      */
> > +                     if (region->region.guest_memfd =3D=3D -1)
> Why to pass !guest_memfd region to tdx_init_mem_region()?
>

Not sure I understand your comment.

>
> > +                             tdx_init_pages(vm, (void *)hva, gpa, size=
_to_load);
> > +                     else
> > +                             tdx_init_mem_region(vm, (void *)hva, gpa,=
 size_to_load);
> > +             }
> > +     }
> > +}
> > +
> > +void vm_tdx_finalize(struct kvm_vm *vm)
> > +{
> > +     load_td_private_memory(vm);
> > +     vm_tdx_vm_ioctl(vm, KVM_TDX_FINALIZE_VM, 0, NULL);
> > +}
> > --
> > 2.51.0.rc1.193.gad69d77794-goog
> >
> >

