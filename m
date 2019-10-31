Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D02BEB3D4
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 16:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfJaPWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 11:22:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58917 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726642AbfJaPWp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 31 Oct 2019 11:22:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572535363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y8s+Vgvc+v9XMpGE6FEjvbl/8jrNYXPh3ji5We4DHis=;
        b=e5p9lAjSmAx27SMOkUgeLHVa2K39eg+ok42C9N+UrmyC0hMkguSZaLqcngkygZOyYIgSPA
        vbtIiL0j8w2DVX7f0MYRlLU6gx0pkyNtQosLuawZazsMeXXTRUdnS6CfLQ1r0R1A5diM+M
        U6mHyDy67fPiz64z5yJUmN2kDbxohsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-ZnknGqUVNhqd44J7PwFE2A-1; Thu, 31 Oct 2019 11:22:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFECE5EA;
        Thu, 31 Oct 2019 15:22:38 +0000 (UTC)
Received: from [10.36.118.44] (unknown [10.36.118.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72AE360870;
        Thu, 31 Oct 2019 15:22:37 +0000 (UTC)
Subject: Re: [PATCH 1/1] KVM: s390: Add memcg accounting to KVM allocations
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
References: <20191031151921.31871-1-borntraeger@de.ibm.com>
 <20191031151921.31871-2-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <5b5dcd65-34e2-663d-a462-f381a62a0428@redhat.com>
Date:   Thu, 31 Oct 2019 16:22:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191031151921.31871-2-borntraeger@de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: ZnknGqUVNhqd44J7PwFE2A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.10.19 16:19, Christian Borntraeger wrote:
> While I propared my KVM Forum talk about whats new in KVM including
> memcg, I realized that the s390 code does not take care of memcg.
>=20
> As far as I can tell, almost all kvm allocations in the s390x KVM code
> can be attributed to process that triggers the allocation (in other
> words, no global allocation for other guests). This will help the memcg
> controller to do the right decisions.
>=20
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   arch/s390/kvm/guestdbg.c  |  8 ++++----
>   arch/s390/kvm/intercept.c |  2 +-
>   arch/s390/kvm/interrupt.c | 12 ++++++------
>   arch/s390/kvm/kvm-s390.c  | 22 +++++++++++-----------
>   arch/s390/kvm/priv.c      |  4 ++--
>   arch/s390/kvm/vsie.c      |  4 ++--
>   6 files changed, 26 insertions(+), 26 deletions(-)
>=20
> diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
> index 394a5f53805b..3765c4223bf9 100644
> --- a/arch/s390/kvm/guestdbg.c
> +++ b/arch/s390/kvm/guestdbg.c
> @@ -184,7 +184,7 @@ static int __import_wp_info(struct kvm_vcpu *vcpu,
>   =09if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
>   =09=09return -EINVAL;
>  =20
> -=09wp_info->old_data =3D kmalloc(bp_data->len, GFP_KERNEL);
> +=09wp_info->old_data =3D kmalloc(bp_data->len, GFP_KERNEL_ACCOUNT);
>   =09if (!wp_info->old_data)
>   =09=09return -ENOMEM;
>   =09/* try to backup the original value */
> @@ -234,7 +234,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>   =09if (nr_wp > 0) {
>   =09=09wp_info =3D kmalloc_array(nr_wp,
>   =09=09=09=09=09sizeof(*wp_info),
> -=09=09=09=09=09GFP_KERNEL);
> +=09=09=09=09=09GFP_KERNEL_ACCOUNT);
>   =09=09if (!wp_info) {
>   =09=09=09ret =3D -ENOMEM;
>   =09=09=09goto error;
> @@ -243,7 +243,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>   =09if (nr_bp > 0) {
>   =09=09bp_info =3D kmalloc_array(nr_bp,
>   =09=09=09=09=09sizeof(*bp_info),
> -=09=09=09=09=09GFP_KERNEL);
> +=09=09=09=09=09GFP_KERNEL_ACCOUNT);
>   =09=09if (!bp_info) {
>   =09=09=09ret =3D -ENOMEM;
>   =09=09=09goto error;
> @@ -349,7 +349,7 @@ static struct kvm_hw_wp_info_arch *any_wp_changed(str=
uct kvm_vcpu *vcpu)
>   =09=09if (!wp_info || !wp_info->old_data || wp_info->len <=3D 0)
>   =09=09=09continue;
>  =20
> -=09=09temp =3D kmalloc(wp_info->len, GFP_KERNEL);
> +=09=09temp =3D kmalloc(wp_info->len, GFP_KERNEL_ACCOUNT);
>   =09=09if (!temp)
>   =09=09=09continue;
>  =20
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index a389fa85cca2..fb2daae88105 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -387,7 +387,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
>   =09if (addr & ~PAGE_MASK)
>   =09=09return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>  =20
> -=09sctns =3D (void *)get_zeroed_page(GFP_KERNEL);
> +=09sctns =3D (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>   =09if (!sctns)
>   =09=09return -ENOMEM;
>  =20
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 165dea4c7f19..7fe8896a82dd 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1668,7 +1668,7 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_int=
(struct kvm *kvm,
>   =09=09goto out;
>   =09}
>   gisa_out:
> -=09tmp_inti =3D kzalloc(sizeof(*inti), GFP_KERNEL);
> +=09tmp_inti =3D kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>   =09if (tmp_inti) {
>   =09=09tmp_inti->type =3D KVM_S390_INT_IO(1, 0, 0, 0);
>   =09=09tmp_inti->io.io_int_word =3D isc_to_int_word(isc);
> @@ -1881,7 +1881,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
>   =09struct kvm_s390_interrupt_info *inti;
>   =09int rc;
>  =20
> -=09inti =3D kzalloc(sizeof(*inti), GFP_KERNEL);
> +=09inti =3D kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>   =09if (!inti)
>   =09=09return -ENOMEM;
>  =20
> @@ -2275,7 +2275,7 @@ static int enqueue_floating_irq(struct kvm_device *=
dev,
>   =09=09return -EINVAL;
>  =20
>   =09while (len >=3D sizeof(struct kvm_s390_irq)) {
> -=09=09inti =3D kzalloc(sizeof(*inti), GFP_KERNEL);
> +=09=09inti =3D kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>   =09=09if (!inti)
>   =09=09=09return -ENOMEM;
>  =20
> @@ -2323,7 +2323,7 @@ static int register_io_adapter(struct kvm_device *d=
ev,
>   =09if (dev->kvm->arch.adapters[adapter_info.id] !=3D NULL)
>   =09=09return -EINVAL;
>  =20
> -=09adapter =3D kzalloc(sizeof(*adapter), GFP_KERNEL);
> +=09adapter =3D kzalloc(sizeof(*adapter), GFP_KERNEL_ACCOUNT);
>   =09if (!adapter)
>   =09=09return -ENOMEM;
>  =20
> @@ -2363,7 +2363,7 @@ static int kvm_s390_adapter_map(struct kvm *kvm, un=
signed int id, __u64 addr)
>   =09if (!adapter || !addr)
>   =09=09return -EINVAL;
>  =20
> -=09map =3D kzalloc(sizeof(*map), GFP_KERNEL);
> +=09map =3D kzalloc(sizeof(*map), GFP_KERNEL_ACCOUNT);
>   =09if (!map) {
>   =09=09ret =3D -ENOMEM;
>   =09=09goto out;
> @@ -3223,7 +3223,7 @@ int kvm_s390_gib_init(u8 nisc)
>   =09=09goto out;
>   =09}
>  =20
> -=09gib =3D (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
> +=09gib =3D (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL_ACCOUNT | G=
FP_DMA);
>   =09if (!gib) {
>   =09=09rc =3D -ENOMEM;
>   =09=09goto out;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d9e6bf3d54f0..373e182fd8e8 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1243,7 +1243,7 @@ static int kvm_s390_set_processor(struct kvm *kvm, =
struct kvm_device_attr *attr)
>   =09=09ret =3D -EBUSY;
>   =09=09goto out;
>   =09}
> -=09proc =3D kzalloc(sizeof(*proc), GFP_KERNEL);
> +=09proc =3D kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
>   =09if (!proc) {
>   =09=09ret =3D -ENOMEM;
>   =09=09goto out;
> @@ -1405,7 +1405,7 @@ static int kvm_s390_get_processor(struct kvm *kvm, =
struct kvm_device_attr *attr)
>   =09struct kvm_s390_vm_cpu_processor *proc;
>   =09int ret =3D 0;
>  =20
> -=09proc =3D kzalloc(sizeof(*proc), GFP_KERNEL);
> +=09proc =3D kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
>   =09if (!proc) {
>   =09=09ret =3D -ENOMEM;
>   =09=09goto out;
> @@ -1433,7 +1433,7 @@ static int kvm_s390_get_machine(struct kvm *kvm, st=
ruct kvm_device_attr *attr)
>   =09struct kvm_s390_vm_cpu_machine *mach;
>   =09int ret =3D 0;
>  =20
> -=09mach =3D kzalloc(sizeof(*mach), GFP_KERNEL);
> +=09mach =3D kzalloc(sizeof(*mach), GFP_KERNEL_ACCOUNT);
>   =09if (!mach) {
>   =09=09ret =3D -ENOMEM;
>   =09=09goto out;
> @@ -1801,7 +1801,7 @@ static long kvm_s390_get_skeys(struct kvm *kvm, str=
uct kvm_s390_skeys *args)
>   =09if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
>   =09=09return -EINVAL;
>  =20
> -=09keys =3D kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
> +=09keys =3D kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCO=
UNT);
>   =09if (!keys)
>   =09=09return -ENOMEM;
>  =20
> @@ -1846,7 +1846,7 @@ static long kvm_s390_set_skeys(struct kvm *kvm, str=
uct kvm_s390_skeys *args)
>   =09if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
>   =09=09return -EINVAL;
>  =20
> -=09keys =3D kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
> +=09keys =3D kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCO=
UNT);
>   =09if (!keys)
>   =09=09return -ENOMEM;
>  =20
> @@ -2393,7 +2393,7 @@ static void sca_dispose(struct kvm *kvm)
>  =20
>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
> -=09gfp_t alloc_flags =3D GFP_KERNEL;
> +=09gfp_t alloc_flags =3D GFP_KERNEL_ACCOUNT;
>   =09int i, rc;
>   =09char debug_name[16];
>   =09static unsigned long sca_offset;
> @@ -2438,7 +2438,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
>  =20
>   =09BUILD_BUG_ON(sizeof(struct sie_page2) !=3D 4096);
>   =09kvm->arch.sie_page2 =3D
> -=09     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
> +=09     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DM=
A);
>   =09if (!kvm->arch.sie_page2)
>   =09=09goto out_err;
>  =20
> @@ -2652,7 +2652,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
>   =09unsigned int vcpu_idx;
>   =09u32 scaol, scaoh;
>  =20
> -=09new_sca =3D alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO=
);
> +=09new_sca =3D alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL_ACCOUNT | =
__GFP_ZERO);
>   =09if (!new_sca)
>   =09=09return -ENOMEM;
>  =20
> @@ -2947,7 +2947,7 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vc=
pu)
>  =20
>   int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
>   {
> -=09vcpu->arch.sie_block->cbrlo =3D get_zeroed_page(GFP_KERNEL);
> +=09vcpu->arch.sie_block->cbrlo =3D get_zeroed_page(GFP_KERNEL_ACCOUNT);
>   =09if (!vcpu->arch.sie_block->cbrlo)
>   =09=09return -ENOMEM;
>   =09return 0;
> @@ -3047,12 +3047,12 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm =
*kvm,
>  =20
>   =09rc =3D -ENOMEM;
>  =20
> -=09vcpu =3D kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> +=09vcpu =3D kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
>   =09if (!vcpu)
>   =09=09goto out;
>  =20
>   =09BUILD_BUG_ON(sizeof(struct sie_page) !=3D 4096);
> -=09sie_page =3D (struct sie_page *) get_zeroed_page(GFP_KERNEL);
> +=09sie_page =3D (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);
>   =09if (!sie_page)
>   =09=09goto out_free_cpu;
>  =20
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index ed52ffa8d5d4..536fcd599665 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -878,7 +878,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>   =09switch (fc) {
>   =09case 1: /* same handling for 1 and 2 */
>   =09case 2:
> -=09=09mem =3D get_zeroed_page(GFP_KERNEL);
> +=09=09mem =3D get_zeroed_page(GFP_KERNEL_ACCOUNT);
>   =09=09if (!mem)
>   =09=09=09goto out_no_data;
>   =09=09if (stsi((void *) mem, fc, sel1, sel2))
> @@ -887,7 +887,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>   =09case 3:
>   =09=09if (sel1 !=3D 2 || sel2 !=3D 2)
>   =09=09=09goto out_no_data;
> -=09=09mem =3D get_zeroed_page(GFP_KERNEL);
> +=09=09mem =3D get_zeroed_page(GFP_KERNEL_ACCOUNT);
>   =09=09if (!mem)
>   =09=09=09goto out_no_data;
>   =09=09handle_stsi_3_2_2(vcpu, (void *) mem);
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 076090f9e666..f55fca8f94f8 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1236,7 +1236,7 @@ static struct vsie_page *get_vsie_page(struct kvm *=
kvm, unsigned long addr)
>  =20
>   =09mutex_lock(&kvm->arch.vsie.mutex);
>   =09if (kvm->arch.vsie.page_count < nr_vcpus) {
> -=09=09page =3D alloc_page(GFP_KERNEL | __GFP_ZERO | GFP_DMA);
> +=09=09page =3D alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
>   =09=09if (!page) {
>   =09=09=09mutex_unlock(&kvm->arch.vsie.mutex);
>   =09=09=09return ERR_PTR(-ENOMEM);
> @@ -1338,7 +1338,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
>   void kvm_s390_vsie_init(struct kvm *kvm)
>   {
>   =09mutex_init(&kvm->arch.vsie.mutex);
> -=09INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL);
> +=09INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
>   }
>  =20
>   /* Destroy the vsie data structures. To be called when a vm is destroye=
d. */
>=20

I was wondering about the gmap, especially also page tables for nested=20
guests. Did you consider that already?

--=20

Thanks,

David / dhildenb

