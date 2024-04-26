Return-Path: <kvm+bounces-16022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E418B2FCF
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 07:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4EF81F228CC
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 05:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1286513A3EF;
	Fri, 26 Apr 2024 05:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hAu/8v2+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACD1EBE
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 05:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714110298; cv=none; b=U2kePP4p7q+f9mLY2vzTyZ0OZmnsB9OGaiVWW9FdRbnmd+F9sTpM/r4sPnsN1xhp87L/WmFIJAP3gMs4RnrcGpiggOtlCK4d9E4nFcqcr9TrNNz3L3mcjmrWQjDidOnIBDqtt71QpnvRPngJ/EeuAKk47X1IsAYxBFBlUfwj38w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714110298; c=relaxed/simple;
	bh=pu0zE3QPPT0qSBo7dBGQlCJBtyysfRS8IdgovXoZ7wE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZR5To2jyEIrEPOBw76h87mepyo6zG9k5Y54s8vQqUuU56OqDG/PbuSFONSMuRwkW9vBJTtuGnH7EM+pXd43kq5M2D1UTmPuNMw6MBQg1RXJ0isuLtYGdYdfVpzuAMjTVoRlRh5ff1mid7VPUSs1h7D/U0bcMDKJcbDEW9j8brK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hAu/8v2+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714110295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zalx7EmoT1K3AB8US4D+2ZE8xlMcgkH7h+tut8rYga4=;
	b=hAu/8v2+SxRiCWL+AvKQ3xWq4wE6MYy8Zh8B4DkNzgF9O1Ag+N3Tof+sPBOfw60eVPpefm
	e6V3k/IUuUpdO5JIDKDAm/c8dWsHLajU7tj7958Zc9q+3QD4vgzcZvVsRM4xC7cBRgnsGB
	HG9E13wz+ilmVmqigtMxOMzysof41YE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-4Ejt_4F8NpeuxX647UbwbA-1; Fri, 26 Apr 2024 01:44:53 -0400
X-MC-Unique: 4Ejt_4F8NpeuxX647UbwbA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-349cf13db2fso1086212f8f.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 22:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714110292; x=1714715092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zalx7EmoT1K3AB8US4D+2ZE8xlMcgkH7h+tut8rYga4=;
        b=LIG33tsan4tlqVoisnCmC5V20iZivRrnnb5QtkZ4QbLmFagYANPMi58IWK9yDEjeBU
         HvT/2PBxbOPX7cgWqgHgCeEurAf0Y1d7sotBFmdk8gvl4gV5SPwmVAhWKWaztZgOvyrN
         H+oaRjdA293GIq8emgreUOmy23muX5yizX4KLH8QZm4BFwp3DHxn4IQHeiXyC6LCV64Z
         5mOzBY+DpIj+dxiOBTmtWAUW3tJ+u4WmDHWjUxsFqoRI8nQ0KRwSbBCqzH3uAmeVahwI
         H/PJ80/JTRvW7M6JDqwZ1BIyWTvixei+pb7UqfUCrLt4HoBjFuk3/7WkekqqlcCXn8KE
         u4qA==
X-Forwarded-Encrypted: i=1; AJvYcCUskf/uzlTIabL6BL5RAuMRAIZL2h7c73uElSh2xG3v67/sRCgNMVRV6FekZg4cPUKo2Vcn2hABBIKI1Nedv4zxqfxA
X-Gm-Message-State: AOJu0Yw68I6TJ0PvMnkP5McwLh8QejhE4kVCF0i2AgMYZoWS2n+oaX77
	qiUvhev7RCyjLdPyuGtsr2wlTcaSGfL2YCdaMOveAcbDtfhUEBzsZ5F5dehRR+VnejNMzVHkS/Z
	oZtqcVr3WGROxSpVrA2v1OEGSCx8q2czWhkEOfsHlpSUiHTyujEhJXTi1w3Xf6lOPn1pMrvcA1w
	+hpxuZ8a/jPF3XSzUPxtQHqF49
X-Received: by 2002:adf:e253:0:b0:343:79e8:a4d6 with SMTP id bl19-20020adfe253000000b0034379e8a4d6mr1156404wrb.25.1714110292028;
        Thu, 25 Apr 2024 22:44:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqWXltO8gLCXZkrnXY5rkFkK7W0IxWNakzRZcKlEAmaam8CFb03PwsU4VGymcNZ9uSmdxI5bI5QpPBRCFyHxU=
X-Received: by 2002:adf:e253:0:b0:343:79e8:a4d6 with SMTP id
 bl19-20020adfe253000000b0034379e8a4d6mr1156391wrb.25.1714110291654; Thu, 25
 Apr 2024 22:44:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com> <ZimGulY6qyxt6ylO@google.com>
 <20240425011248.GP3596705@ls.amr.corp.intel.com> <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
 <Zip-JsAB5TIRDJVl@google.com> <20240425165144.GQ3596705@ls.amr.corp.intel.com>
In-Reply-To: <20240425165144.GQ3596705@ls.amr.corp.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Apr 2024 07:44:40 +0200
Message-ID: <CABgObfbAzj=OzhfK2zfkQmeJmRUxNqMSHeGgJd+JGjsmwC_f1g@mail.gmail.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.roth@amd.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 6:51=E2=80=AFPM Isaku Yamahata <isaku.yamahata@inte=
l.com> wrote:
> > AFAIK, unwinding on failure is completely uninteresting, and arguably u=
ndesirable,
> > because undoing LAUNCH_UPDATE or PAGE.ADD will affect the measurement, =
i.e. there
> > is no scenario where deleting pages from guest_memfd would allow a rest=
art/resume
> > of the build process to truly succeed.
>
>
> Just for record.  With the following twist to kvm_gmem_populate,
> KVM_TDX_INIT_MEM_REGION can use kvm_gmem_populate().  For those who are c=
urious,
> I also append the callback implementation at the end.

Nice, thank you very much. Since TDX does not need
HAVE_KVM_GMEM_PREPARE, if I get rid of FGP_CREAT_ONLY it will work for
you, right?

Paolo

>
> --
>
>  include/linux/kvm_host.h | 2 ++
>  virt/kvm/guest_memfd.c   | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index df957c9f9115..7c86b77f8895 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2460,6 +2460,7 @@ bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
>   *       (passed to @post_populate, and incremented on each iteration
>   *       if not NULL)
>   * @npages: number of pages to copy from userspace-buffer
> + * @prepare: Allow page allocation to invoke gmem_prepare hook
>   * @post_populate: callback to issue for each gmem page that backs the G=
PA
>   *                 range
>   * @opaque: opaque data to pass to @post_populate callback
> @@ -2473,6 +2474,7 @@ bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
>   * Returns the number of pages that were populated.
>   */
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, lon=
g npages,
> +                      bool prepare,
>                        int (*post_populate)(struct kvm *kvm, gfn_t gfn, k=
vm_pfn_t pfn,
>                                             void __user *src, int order, =
void *opaque),
>                        void *opaque);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3195ceefe915..18809e6dea8a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -638,6 +638,7 @@ static int kvm_gmem_undo_get_pfn(struct file *file, s=
truct kvm_memory_slot *slot
>  }
>
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, lon=
g npages,
> +                      bool prepare,
>                        int (*post_populate)(struct kvm *kvm, gfn_t gfn, k=
vm_pfn_t pfn,
>                                             void __user *src, int order, =
void *opaque),
>                        void *opaque)
> @@ -667,7 +668,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, vo=
id __user *src, long npages
>                 gfn_t this_gfn =3D gfn + i;
>                 kvm_pfn_t pfn;
>
> -               ret =3D __kvm_gmem_get_pfn(file, slot, this_gfn, &pfn, &m=
ax_order, false);
> +               ret =3D __kvm_gmem_get_pfn(file, slot, this_gfn, &pfn, &m=
ax_order, prepare);
>                 if (ret)
>                         break;
>
> --
> 2.43.2
>
>
> Here is the callback for KVM_TDX_INIT_MEM_REGION.
> Note: the caller of kvm_gmem_populate() acquires mutex_lock(&kvm->slots_l=
ock)
> and idx =3D srcu_read_lock(&kvm->srcu).
>
>
> struct tdx_gmem_post_populate_arg {
>         struct kvm_vcpu *vcpu;
>         __u32 flags;
> };
>
> static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t p=
fn,
>                                   void __user *src, int order, void *_arg=
)
> {
>         struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
>         struct tdx_gmem_post_populate_arg *arg =3D _arg;
>         struct kvm_vcpu *vcpu =3D arg->vcpu;
>         struct kvm_memory_slot *slot;
>         gpa_t gpa =3D gfn_to_gpa(gfn);
>         struct page *page;
>         kvm_pfn_t mmu_pfn;
>         int ret, i;
>         u64 err;
>
>         /* Pin the source page. */
>         ret =3D get_user_pages_fast((unsigned long)src, 1, 0, &page);
>         if (ret < 0)
>                 return ret;
>         if (ret !=3D 1)
>                 return -ENOMEM;
>
>         slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>         if (!kvm_slot_can_be_private(slot) || !kvm_mem_is_private(kvm, gf=
n)) {
>                 ret =3D -EFAULT;
>                 goto out_put_page;
>         }
>
>         read_lock(&kvm->mmu_lock);
>
>         ret =3D kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &mmu_pfn);
>         if (ret < 0)
>                 goto out;
>         if (ret > PG_LEVEL_4K) {
>                 ret =3D -EINVAL;
>                 goto out;
>         }
>         if (mmu_pfn !=3D pfn) {
>                 ret =3D -EAGAIN;
>                 goto out;
>         }
>
>         ret =3D 0;
>         do {
>                 err =3D tdh_mem_page_add(kvm_tdx, gpa, pfn_to_hpa(pfn),
>                                        pfn_to_hpa(page_to_pfn(page)), NUL=
L);
>         } while (err =3D=3D TDX_ERROR_SEPT_BUSY);
>         if (err) {
>                 ret =3D -EIO;
>                 goto out;
>         }
>
>         WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
>         atomic64_dec(&kvm_tdx->nr_premapped);
>         tdx_account_td_pages(vcpu->kvm, PG_LEVEL_4K);
>
>         if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
>                 for (i =3D 0; i < PAGE_SIZE; i +=3D TDX_EXTENDMR_CHUNKSIZ=
E) {
>                         err =3D tdh_mr_extend(kvm_tdx, gpa + i, NULL);
>                         if (err) {
>                                 ret =3D -EIO;
>                                 break;
>                         }
>                 }
>         }
>
> out:
>         read_unlock(&kvm->mmu_lock);
> out_put_page:
>         put_page(page);
>         return ret;
> }
>
> --
> Isaku Yamahata <isaku.yamahata@intel.com>
>


