Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CA0E376B
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 18:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407544AbfJXQH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 12:07:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407703AbfJXQH6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 12:07:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571933276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CyKqa+jdl9i0d0+DEUyNgwBNtXJRTjesYYjnpO4IDlA=;
        b=PMA8XhU1K/9jiMxkr6EWBMkz3/dCBVe6r5q4MQLa2h+Zh9qShJM2sja2nFYnrpDdq75mT7
        lt9+Q8vwq5eBXRqoOIIwVVyX0Zy8lEi0gZzzk4FVUdKTFzZpp4AKsYxxDwS1Mb93MBpXxM
        0w+6K66wHkYPJiTunTp/4oMfc7CoXjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-PgunsR4JNuGNyojyJucKcQ-1; Thu, 24 Oct 2019 12:07:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 457E51800E05;
        Thu, 24 Oct 2019 16:07:17 +0000 (UTC)
Received: from [10.36.116.202] (ovpn-116-202.ams2.redhat.com [10.36.116.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64F9A196B2;
        Thu, 24 Oct 2019 16:07:15 +0000 (UTC)
Subject: Re: [RFC 07/37] KVM: s390: protvirt: Secure memory is not mergeable
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-8-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <f80519a0-a8da-1a98-c450-b81dfcf2e897@redhat.com>
Date:   Thu, 24 Oct 2019 18:07:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-8-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: PgunsR4JNuGNyojyJucKcQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> KSM will not work on secure pages, because when the kernel reads a
> secure page, it will be encrypted and hence no two pages will look the
> same.
>=20
> Let's mark the guest pages as unmergeable when we transition to secure
> mode.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/include/asm/gmap.h |  1 +
>   arch/s390/kvm/kvm-s390.c     |  6 ++++++
>   arch/s390/mm/gmap.c          | 28 ++++++++++++++++++----------
>   3 files changed, 25 insertions(+), 10 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 6efc0b501227..eab6a2ec3599 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -145,4 +145,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned long=
 start,
>  =20
>   void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bit=
map[4],
>   =09=09=09     unsigned long gaddr, unsigned long vmaddr);
> +int gmap_mark_unmergeable(void);
>   #endif /* _ASM_S390_GMAP_H */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 924132d92782..d1ba12f857e7 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2176,6 +2176,12 @@ static int kvm_s390_handle_pv(struct kvm *kvm, str=
uct kvm_pv_cmd *cmd)
>   =09=09if (r)
>   =09=09=09break;
>  =20
> +=09=09down_write(&current->mm->mmap_sem);
> +=09=09r =3D gmap_mark_unmergeable();
> +=09=09up_write(&current->mm->mmap_sem);
> +=09=09if (r)
> +=09=09=09break;
> +
>   =09=09mutex_lock(&kvm->lock);
>   =09=09kvm_s390_vcpu_block_all(kvm);
>   =09=09/* FMT 4 SIE needs esca */
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index edcdca97e85e..bf365a09f900 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2548,6 +2548,23 @@ int s390_enable_sie(void)
>   }
>   EXPORT_SYMBOL_GPL(s390_enable_sie);
>  =20
> +int gmap_mark_unmergeable(void)
> +{
> +=09struct mm_struct *mm =3D current->mm;
> +=09struct vm_area_struct *vma;
> +
> +=09for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
> +=09=09if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
> +=09=09=09=09MADV_UNMERGEABLE, &vma->vm_flags)) {
> +=09=09=09mm->context.uses_skeys =3D 0;

That skey setting does not make too much sense when coming via=20
kvm_s390_handle_pv(). handle that in the caller?

> +=09=09=09return -ENOMEM;
> +=09=09}
> +=09}
> +=09mm->def_flags &=3D ~VM_MERGEABLE;
> +=09return 0;
> +}
> +EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
> +
>   /*
>    * Enable storage key handling from now on and initialize the storage
>    * keys with the default key.
> @@ -2593,7 +2610,6 @@ static const struct mm_walk_ops enable_skey_walk_op=
s =3D {
>   int s390_enable_skey(void)
>   {
>   =09struct mm_struct *mm =3D current->mm;
> -=09struct vm_area_struct *vma;
>   =09int rc =3D 0;
>  =20
>   =09down_write(&mm->mmap_sem);
> @@ -2601,15 +2617,7 @@ int s390_enable_skey(void)
>   =09=09goto out_up;
>  =20
>   =09mm->context.uses_skeys =3D 1;
> -=09for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
> -=09=09if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
> -=09=09=09=09MADV_UNMERGEABLE, &vma->vm_flags)) {
> -=09=09=09mm->context.uses_skeys =3D 0;
> -=09=09=09rc =3D -ENOMEM;
> -=09=09=09goto out_up;
> -=09=09}
> -=09}
> -=09mm->def_flags &=3D ~VM_MERGEABLE;
> +=09gmap_mark_unmergeable();
>  =20
>   =09walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
>  =20
>=20


--=20

Thanks,

David / dhildenb

