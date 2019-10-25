Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C92E462C
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393107AbfJYIto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:49:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731524AbfJYIto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 04:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571993382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSGri+f/M7/xWpKJG9j+HerX9L+eGDjKax0gbGzHiOQ=;
        b=HbiCRRoFbSOww2XqJ+6CU83kuDKeo4nC5PVgZ9zytK0GB2Ex07UBtG45oRRtBJ4zy/SEFH
        1mhtR9kM7p1DOpAYfnpR1W0ivMv58FMXLxY8QYQXB7hwb8JrXIKxKmQaoCbYqHcRvynhKB
        uqV9aiOToNwKvz4EP+pWCiQI/oVmySU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-JyPZvvG4OpWlV9J-HV6dBg-1; Fri, 25 Oct 2019 04:49:38 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AB6F1800E00;
        Fri, 25 Oct 2019 08:49:37 +0000 (UTC)
Received: from [10.36.116.205] (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FF2860BE0;
        Fri, 25 Oct 2019 08:49:35 +0000 (UTC)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
Date:   Fri, 25 Oct 2019 10:49:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-10-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: JyPZvvG4OpWlV9J-HV6dBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>=20
> Pin the guest pages when they are first accessed, instead of all at
> the same time when starting the guest.

Please explain why you do stuff. Why do we have to pin the hole guest=20
memory? Why can't we mlock() the hole memory to avoid swapping in user=20
space?

This really screams for a proper explanation.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/gmap.h |  1 +
>   arch/s390/include/asm/uv.h   |  6 +++++
>   arch/s390/kernel/uv.c        | 20 ++++++++++++++
>   arch/s390/kvm/kvm-s390.c     |  2 ++
>   arch/s390/kvm/pv.c           | 51 ++++++++++++++++++++++++++++++------
>   5 files changed, 72 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 99b3eedda26e..483f64427c0e 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -63,6 +63,7 @@ struct gmap {
>   =09struct gmap *parent;
>   =09unsigned long orig_asce;
>   =09unsigned long se_handle;
> +=09struct page **pinned_pages;
>   =09int edat_level;
>   =09bool removed;
>   =09bool initialized;
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 99cdd2034503..9ce9363aee1c 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -298,6 +298,7 @@ static inline int uv_convert_from_secure(unsigned lon=
g paddr)
>   =09return -EINVAL;
>   }
>  =20
> +int kvm_s390_pv_pin_page(struct gmap *gmap, unsigned long gpa);
>   /*
>    * Requests the Ultravisor to make a page accessible to a guest
>    * (import). If it's brought in the first time, it will be cleared. If
> @@ -317,6 +318,11 @@ static inline int uv_convert_to_secure(struct gmap *=
gmap, unsigned long gaddr)
>   =09=09.gaddr =3D gaddr
>   =09};
>  =20
> +=09down_read(&gmap->mm->mmap_sem);
> +=09cc =3D kvm_s390_pv_pin_page(gmap, gaddr);
> +=09up_read(&gmap->mm->mmap_sem);
> +=09if (cc)
> +=09=09return cc;
>   =09cc =3D uv_call(0, (u64)&uvcb);
>  =20
>   =09if (!cc)
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index f7778493e829..36554402b5c6 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -98,4 +98,24 @@ void adjust_to_uv_max(unsigned long *vmax)
>   =09if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
>   =09=09*vmax =3D uv_info.max_sec_stor_addr;
>   }
> +
> +int kvm_s390_pv_pin_page(struct gmap *gmap, unsigned long gpa)
> +{
> +=09unsigned long hva, gfn =3D gpa / PAGE_SIZE;
> +=09int rc;
> +
> +=09if (!gmap->pinned_pages)
> +=09=09return -EINVAL;
> +=09hva =3D __gmap_translate(gmap, gpa);
> +=09if (IS_ERR_VALUE(hva))
> +=09=09return -EFAULT;
> +=09if (gmap->pinned_pages[gfn])
> +=09=09return -EEXIST;
> +=09rc =3D get_user_pages_fast(hva, 1, FOLL_WRITE, gmap->pinned_pages + g=
fn);
> +=09if (rc < 0)
> +=09=09return rc;
> +=09return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pv_pin_page);
> +
>   #endif
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d1ba12f857e7..490fde080107 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2196,6 +2196,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, stru=
ct kvm_pv_cmd *cmd)
>   =09=09/* All VCPUs have to be destroyed before this call. */
>   =09=09mutex_lock(&kvm->lock);
>   =09=09kvm_s390_vcpu_block_all(kvm);
> +=09=09kvm_s390_pv_unpin(kvm);
>   =09=09r =3D kvm_s390_pv_destroy_vm(kvm);
>   =09=09if (!r)
>   =09=09=09kvm_s390_pv_dealloc_vm(kvm);
> @@ -2680,6 +2681,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   =09kvm_s390_gisa_destroy(kvm);
>   =09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
>   =09    kvm_s390_pv_is_protected(kvm)) {
> +=09=09kvm_s390_pv_unpin(kvm);
>   =09=09kvm_s390_pv_destroy_vm(kvm);
>   =09=09kvm_s390_pv_dealloc_vm(kvm);
>   =09}
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 80aecd5bea9e..383e660e2221 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -15,8 +15,35 @@
>   #include <asm/mman.h>
>   #include "kvm-s390.h"
>  =20
> +static void unpin_destroy(struct page **pages, int nr)
> +{
> +=09int i;
> +=09struct page *page;
> +=09u8 *val;
> +
> +=09for (i =3D 0; i < nr; i++) {
> +=09=09page =3D pages[i];
> +=09=09if (!page)=09/* page was never used */
> +=09=09=09continue;
> +=09=09val =3D (void *)page_to_phys(page);
> +=09=09READ_ONCE(*val);
> +=09=09put_page(page);
> +=09}
> +}
> +
> +void kvm_s390_pv_unpin(struct kvm *kvm)
> +{
> +=09unsigned long npages =3D kvm->arch.pv.guest_len / PAGE_SIZE;
> +
> +=09mutex_lock(&kvm->slots_lock);
> +=09unpin_destroy(kvm->arch.gmap->pinned_pages, npages);
> +=09mutex_unlock(&kvm->slots_lock);
> +}
> +
>   void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
>   {
> +=09vfree(kvm->arch.gmap->pinned_pages);
> +=09kvm->arch.gmap->pinned_pages =3D NULL;
>   =09vfree(kvm->arch.pv.stor_var);
>   =09free_pages(kvm->arch.pv.stor_base,
>   =09=09   get_order(uv_info.guest_base_stor_len));
> @@ -28,7 +55,6 @@ int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>   =09unsigned long base =3D uv_info.guest_base_stor_len;
>   =09unsigned long virt =3D uv_info.guest_virt_var_stor_len;
>   =09unsigned long npages =3D 0, vlen =3D 0;
> -=09struct kvm_memslots *slots;
>   =09struct kvm_memory_slot *memslot;
>  =20
>   =09kvm->arch.pv.stor_var =3D NULL;
> @@ -43,22 +69,26 @@ int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>   =09 * Slots are sorted by GFN
>   =09 */
>   =09mutex_lock(&kvm->slots_lock);
> -=09slots =3D kvm_memslots(kvm);
> -=09memslot =3D slots->memslots;
> +=09memslot =3D kvm_memslots(kvm)->memslots;
>   =09npages =3D memslot->base_gfn + memslot->npages;
> -
>   =09mutex_unlock(&kvm->slots_lock);
> +
> +=09kvm->arch.gmap->pinned_pages =3D vzalloc(npages * sizeof(struct page =
*));
> +=09if (!kvm->arch.gmap->pinned_pages)
> +=09=09goto out_err;
>   =09kvm->arch.pv.guest_len =3D npages * PAGE_SIZE;
>  =20
>   =09/* Allocate variable storage */
>   =09vlen =3D ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE=
);
>   =09vlen +=3D uv_info.guest_virt_base_stor_len;
>   =09kvm->arch.pv.stor_var =3D vzalloc(vlen);
> -=09if (!kvm->arch.pv.stor_var) {
> -=09=09kvm_s390_pv_dealloc_vm(kvm);
> -=09=09return -ENOMEM;
> -=09}
> +=09if (!kvm->arch.pv.stor_var)
> +=09=09goto out_err;
>   =09return 0;
> +
> +out_err:
> +=09kvm_s390_pv_dealloc_vm(kvm);
> +=09return -ENOMEM;
>   }
>  =20
>   int kvm_s390_pv_destroy_vm(struct kvm *kvm)
> @@ -216,6 +246,11 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned lon=
g addr, unsigned long size,
>   =09for (i =3D 0; i < size / PAGE_SIZE; i++) {
>   =09=09uvcb.gaddr =3D addr + i * PAGE_SIZE;
>   =09=09uvcb.tweak[1] =3D i * PAGE_SIZE;
> +=09=09down_read(&kvm->mm->mmap_sem);
> +=09=09rc =3D kvm_s390_pv_pin_page(kvm->arch.gmap, uvcb.gaddr);
> +=09=09up_read(&kvm->mm->mmap_sem);
> +=09=09if (rc && (rc !=3D -EEXIST))
> +=09=09=09break;
>   retry:
>   =09=09rc =3D uv_call(0, (u64)&uvcb);
>   =09=09if (!rc)
>=20


--=20

Thanks,

David / dhildenb

