Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8AE2B68A4
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgKQPYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:24:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728786AbgKQPYT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:24:19 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHF2wch158322;
        Tue, 17 Nov 2020 10:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=CI4McZlEsBe24ylvr/aTNnuaqzeOk3QxC5dyQk95YdA=;
 b=nsRUsbZKZQpAkCGbRPDTJvMmUm+pVxK90CKGhrVSuB4hiLGhMycXIPOgwUAgiqpYEFdL
 3nTlb1tHsQRPw1PLy1Uvf8pBWjFQCbAlKOlNLKBS0MnELhNPg/QYsaJBMIkmxoAg04uW
 darBlui17LOwMTMbTIjEb2oOj5/za4rq+9qkaNU7JwpkivNyTHeDtLirMTXGFpW8OerO
 xn7n3MwAcK8XRpDIz6Y5VqiAhqtLTWnxnQI2z+pUPusBt2NrSySOuu6ByKrRxU5Ngtgj
 1VEVLaaRGcLWuVtTyxEQ1gNId0qBTKlrpO2Pno4oHhRXkdHZwTwQtQSW9XkwmqUzOoKr Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ve31eyj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:24:13 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AHF4V5D172874;
        Tue, 17 Nov 2020 10:24:12 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ve31eyh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:24:12 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFNHIV008304;
        Tue, 17 Nov 2020 15:24:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 34t6v89nyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:24:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHFMqH78717008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 15:22:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1878A405C;
        Tue, 17 Nov 2020 15:22:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 448BFA4054;
        Tue, 17 Nov 2020 15:22:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.158.127])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 15:22:52 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: s390: Add memcg accounting to KVM allocations
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20201117151023.424575-1-borntraeger@de.ibm.com>
 <20201117151023.424575-2-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
Message-ID: <f7318fcc-3c7b-27a9-6d6d-7c16109ed603@linux.ibm.com>
Date:   Tue, 17 Nov 2020 16:22:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201117151023.424575-2-borntraeger@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6sMdO5WuoC7xWF7gUZKvadvAR6Op9P4pi"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=2 bulkscore=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6sMdO5WuoC7xWF7gUZKvadvAR6Op9P4pi
Content-Type: multipart/mixed; boundary="oszkB5zXk7RHUoHPiBvOhd3bHhY6K1XWn";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.vnet.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
 David Hildenbrand <david@redhat.com>, linux-s390
 <linux-s390@vger.kernel.org>, Heiko Carstens <hca@linux.ibm.com>
Message-ID: <f7318fcc-3c7b-27a9-6d6d-7c16109ed603@linux.ibm.com>
Subject: Re: [PATCH 1/2] KVM: s390: Add memcg accounting to KVM allocations
References: <20201117151023.424575-1-borntraeger@de.ibm.com>
 <20201117151023.424575-2-borntraeger@de.ibm.com>
In-Reply-To: <20201117151023.424575-2-borntraeger@de.ibm.com>

--oszkB5zXk7RHUoHPiBvOhd3bHhY6K1XWn
Content-Type: multipart/mixed;
 boundary="------------ACE1317D86CDEF8EB3357397"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------ACE1317D86CDEF8EB3357397
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/17/20 4:10 PM, Christian Borntraeger wrote:
> Almost all kvm allocations in the s390x KVM code can be attributed to
> process that triggers the allocation (in other words, no global
> allocation for other guests). This will help the memcg controller to do=

> the right decisions.
>=20
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Acked-by: Heiko Carstens <hca@linux.ibm.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  arch/s390/kvm/guestdbg.c  |  8 ++++----
>  arch/s390/kvm/intercept.c |  2 +-
>  arch/s390/kvm/interrupt.c | 10 +++++-----
>  arch/s390/kvm/kvm-s390.c  | 20 ++++++++++----------
>  arch/s390/kvm/priv.c      |  4 ++--
>  arch/s390/kvm/pv.c        |  6 +++---
>  arch/s390/kvm/vsie.c      |  4 ++--
>  7 files changed, 27 insertions(+), 27 deletions(-)
>=20
> diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
> index 394a5f53805b..3765c4223bf9 100644
> --- a/arch/s390/kvm/guestdbg.c
> +++ b/arch/s390/kvm/guestdbg.c
> @@ -184,7 +184,7 @@ static int __import_wp_info(struct kvm_vcpu *vcpu,
>  	if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
>  		return -EINVAL;
>=20
> -	wp_info->old_data =3D kmalloc(bp_data->len, GFP_KERNEL);
> +	wp_info->old_data =3D kmalloc(bp_data->len, GFP_KERNEL_ACCOUNT);
>  	if (!wp_info->old_data)
>  		return -ENOMEM;
>  	/* try to backup the original value */
> @@ -234,7 +234,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>  	if (nr_wp > 0) {
>  		wp_info =3D kmalloc_array(nr_wp,
>  					sizeof(*wp_info),
> -					GFP_KERNEL);
> +					GFP_KERNEL_ACCOUNT);
>  		if (!wp_info) {
>  			ret =3D -ENOMEM;
>  			goto error;
> @@ -243,7 +243,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>  	if (nr_bp > 0) {
>  		bp_info =3D kmalloc_array(nr_bp,
>  					sizeof(*bp_info),
> -					GFP_KERNEL);
> +					GFP_KERNEL_ACCOUNT);
>  		if (!bp_info) {
>  			ret =3D -ENOMEM;
>  			goto error;
> @@ -349,7 +349,7 @@ static struct kvm_hw_wp_info_arch *any_wp_changed(s=
truct kvm_vcpu *vcpu)
>  		if (!wp_info || !wp_info->old_data || wp_info->len <=3D 0)
>  			continue;
>=20
> -		temp =3D kmalloc(wp_info->len, GFP_KERNEL);
> +		temp =3D kmalloc(wp_info->len, GFP_KERNEL_ACCOUNT);
>  		if (!temp)
>  			continue;
>=20
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index e7a7c499a73f..72b25b7cc6ae 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -398,7 +398,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
>  	if (!kvm_s390_pv_cpu_is_protected(vcpu) && (addr & ~PAGE_MASK))
>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>=20
> -	sctns =3D (void *)get_zeroed_page(GFP_KERNEL);
> +	sctns =3D (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  	if (!sctns)
>  		return -ENOMEM;
>=20
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 2f177298c663..e3183bd05910 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1792,7 +1792,7 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_i=
nt(struct kvm *kvm,
>  		goto out;
>  	}
>  gisa_out:
> -	tmp_inti =3D kzalloc(sizeof(*inti), GFP_KERNEL);
> +	tmp_inti =3D kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>  	if (tmp_inti) {
>  		tmp_inti->type =3D KVM_S390_INT_IO(1, 0, 0, 0);
>  		tmp_inti->io.io_int_word =3D isc_to_int_word(isc);
> @@ -2015,7 +2015,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
>  	struct kvm_s390_interrupt_info *inti;
>  	int rc;
>=20
> -	inti =3D kzalloc(sizeof(*inti), GFP_KERNEL);
> +	inti =3D kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>  	if (!inti)
>  		return -ENOMEM;
>=20
> @@ -2414,7 +2414,7 @@ static int enqueue_floating_irq(struct kvm_device=
 *dev,
>  		return -EINVAL;
>=20
>  	while (len >=3D sizeof(struct kvm_s390_irq)) {
> -		inti =3D kzalloc(sizeof(*inti), GFP_KERNEL);
> +		inti =3D kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
>  		if (!inti)
>  			return -ENOMEM;
>=20
> @@ -2462,7 +2462,7 @@ static int register_io_adapter(struct kvm_device =
*dev,
>  	if (dev->kvm->arch.adapters[adapter_info.id] !=3D NULL)
>  		return -EINVAL;
>=20
> -	adapter =3D kzalloc(sizeof(*adapter), GFP_KERNEL);
> +	adapter =3D kzalloc(sizeof(*adapter), GFP_KERNEL_ACCOUNT);
>  	if (!adapter)
>  		return -ENOMEM;
>=20
> @@ -3290,7 +3290,7 @@ int kvm_s390_gib_init(u8 nisc)
>  		goto out;
>  	}
>=20
> -	gib =3D (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL | GFP_DMA);=

> +	gib =3D (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL_ACCOUNT | G=
FP_DMA);
>  	if (!gib) {
>  		rc =3D -ENOMEM;
>  		goto out;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 425d3d75320b..282a13ece554 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1254,7 +1254,7 @@ static int kvm_s390_set_processor(struct kvm *kvm=
, struct kvm_device_attr *attr)
>  		ret =3D -EBUSY;
>  		goto out;
>  	}
> -	proc =3D kzalloc(sizeof(*proc), GFP_KERNEL);
> +	proc =3D kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
>  	if (!proc) {
>  		ret =3D -ENOMEM;
>  		goto out;
> @@ -1416,7 +1416,7 @@ static int kvm_s390_get_processor(struct kvm *kvm=
, struct kvm_device_attr *attr)
>  	struct kvm_s390_vm_cpu_processor *proc;
>  	int ret =3D 0;
>=20
> -	proc =3D kzalloc(sizeof(*proc), GFP_KERNEL);
> +	proc =3D kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
>  	if (!proc) {
>  		ret =3D -ENOMEM;
>  		goto out;
> @@ -1444,7 +1444,7 @@ static int kvm_s390_get_machine(struct kvm *kvm, =
struct kvm_device_attr *attr)
>  	struct kvm_s390_vm_cpu_machine *mach;
>  	int ret =3D 0;
>=20
> -	mach =3D kzalloc(sizeof(*mach), GFP_KERNEL);
> +	mach =3D kzalloc(sizeof(*mach), GFP_KERNEL_ACCOUNT);
>  	if (!mach) {
>  		ret =3D -ENOMEM;
>  		goto out;
> @@ -1812,7 +1812,7 @@ static long kvm_s390_get_skeys(struct kvm *kvm, s=
truct kvm_s390_skeys *args)
>  	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
>  		return -EINVAL;
>=20
> -	keys =3D kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
> +	keys =3D kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCO=
UNT);
>  	if (!keys)
>  		return -ENOMEM;
>=20
> @@ -1857,7 +1857,7 @@ static long kvm_s390_set_skeys(struct kvm *kvm, s=
truct kvm_s390_skeys *args)
>  	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
>  		return -EINVAL;
>=20
> -	keys =3D kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
> +	keys =3D kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCO=
UNT);
>  	if (!keys)
>  		return -ENOMEM;
>=20
> @@ -2625,7 +2625,7 @@ static void sca_dispose(struct kvm *kvm)
>=20
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
> -	gfp_t alloc_flags =3D GFP_KERNEL;
> +	gfp_t alloc_flags =3D GFP_KERNEL_ACCOUNT;
>  	int i, rc;
>  	char debug_name[16];
>  	static unsigned long sca_offset;
> @@ -2670,7 +2670,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
>=20
>  	BUILD_BUG_ON(sizeof(struct sie_page2) !=3D 4096);
>  	kvm->arch.sie_page2 =3D
> -	     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
> +	     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DM=
A);
>  	if (!kvm->arch.sie_page2)
>  		goto out_err;
>=20
> @@ -2900,7 +2900,7 @@ static int sca_switch_to_extended(struct kvm *kvm=
)
>  	if (kvm->arch.use_esca)
>  		return 0;
>=20
> -	new_sca =3D alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO=
);
> +	new_sca =3D alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL_ACCOUNT | =
__GFP_ZERO);
>  	if (!new_sca)
>  		return -ENOMEM;
>=20
> @@ -3133,7 +3133,7 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *=
vcpu)
>=20
>  int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
>  {
> -	vcpu->arch.sie_block->cbrlo =3D get_zeroed_page(GFP_KERNEL);
> +	vcpu->arch.sie_block->cbrlo =3D get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  	if (!vcpu->arch.sie_block->cbrlo)
>  		return -ENOMEM;
>  	return 0;
> @@ -3243,7 +3243,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	int rc;
>=20
>  	BUILD_BUG_ON(sizeof(struct sie_page) !=3D 4096);
> -	sie_page =3D (struct sie_page *) get_zeroed_page(GFP_KERNEL);
> +	sie_page =3D (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);=

>  	if (!sie_page)
>  		return -ENOMEM;
>=20
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index cd74989ce0b0..9928f785c677 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -879,7 +879,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>  	switch (fc) {
>  	case 1: /* same handling for 1 and 2 */
>  	case 2:
> -		mem =3D get_zeroed_page(GFP_KERNEL);
> +		mem =3D get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  		if (!mem)
>  			goto out_no_data;
>  		if (stsi((void *) mem, fc, sel1, sel2))
> @@ -888,7 +888,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>  	case 3:
>  		if (sel1 !=3D 2 || sel2 !=3D 2)
>  			goto out_no_data;
> -		mem =3D get_zeroed_page(GFP_KERNEL);
> +		mem =3D get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  		if (!mem)
>  			goto out_no_data;
>  		handle_stsi_3_2_2(vcpu, (void *) mem);
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index f5847f9dec7c..813b6e93dc83 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -60,7 +60,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16=
 *rc, u16 *rrc)
>  	if (kvm_s390_pv_cpu_get_handle(vcpu))
>  		return -EINVAL;
>=20
> -	vcpu->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL,
> +	vcpu->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL_ACCOUNT,
>  						   get_order(uv_info.guest_cpu_stor_len));
>  	if (!vcpu->arch.pv.stor_base)
>  		return -ENOMEM;
> @@ -72,7 +72,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16=
 *rc, u16 *rrc)
>  	uvcb.stor_origin =3D (u64)vcpu->arch.pv.stor_base;
>=20
>  	/* Alloc Secure Instruction Data Area Designation */
> -	vcpu->arch.sie_block->sidad =3D __get_free_page(GFP_KERNEL | __GFP_ZE=
RO);
> +	vcpu->arch.sie_block->sidad =3D __get_free_page(GFP_KERNEL_ACCOUNT | =
__GFP_ZERO);
>  	if (!vcpu->arch.sie_block->sidad) {
>  		free_pages(vcpu->arch.pv.stor_base,
>  			   get_order(uv_info.guest_cpu_stor_len));
> @@ -120,7 +120,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>  	struct kvm_memory_slot *memslot;
>=20
>  	kvm->arch.pv.stor_var =3D NULL;
> -	kvm->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL, get_order(bas=
e));
> +	kvm->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL_ACCOUNT, get_o=
rder(base));
>  	if (!kvm->arch.pv.stor_base)
>  		return -ENOMEM;
>=20
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 4f3cbf6003a9..c5d0a58b2c29 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1234,7 +1234,7 @@ static struct vsie_page *get_vsie_page(struct kvm=
 *kvm, unsigned long addr)
>=20
>  	mutex_lock(&kvm->arch.vsie.mutex);
>  	if (kvm->arch.vsie.page_count < nr_vcpus) {
> -		page =3D alloc_page(GFP_KERNEL | __GFP_ZERO | GFP_DMA);
> +		page =3D alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
>  		if (!page) {
>  			mutex_unlock(&kvm->arch.vsie.mutex);
>  			return ERR_PTR(-ENOMEM);
> @@ -1336,7 +1336,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
>  void kvm_s390_vsie_init(struct kvm *kvm)
>  {
>  	mutex_init(&kvm->arch.vsie.mutex);
> -	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL);
> +	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
>  }
>=20
>  /* Destroy the vsie data structures. To be called when a vm is destroy=
ed. */
>=20


--------------ACE1317D86CDEF8EB3357397
Content-Type: application/pgp-keys;
 name="OpenPGP_0xE354E6B8E238B9F8.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0xE354E6B8E238B9F8.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6q=
LqY
r+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv15mH4=
9iK
SmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZezuMRBivJQ=
QI1
esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzblDbbTlEeyBACe=
ED7
DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoLEsb8Y4avOYIgYDhgk=
Ch0
nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk0m3WJwvwd1s878HrQNK0o=
rWd
8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0ScITWU9Rxb04XyigY4XmZ8dywa=
xwi
2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsUZ+/ldjToHnq21MNa1wx0lCEipCCyE=
/8K
9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNjHTOLb2g2UT65AjZEQE95U2AY9iYm5usMq=
aWD
39pAHfhC09/7NQARAQABzSVKYW5vc2NoIEZyYW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+w=
sF3
BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQA=
Ljk
dj5euJVI2nNT3/IAxAhQSmRhPEt0AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxT=
dSN
SAN/5Z7qmOR9JySvDOf4d3mSbMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmj=
Ghe
2YUhJLR1v1LguME+YseTeXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwh=
fPC
CUK0850o1fUAYq5pCNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEj=
Oxu
3dqgIKbHbjzaEXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprA=
Y94
hY3F4trTrQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJ=
Vrw
eMubUscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK1=
5k/
RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNqd=
q2v
0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPLjJbaw=
sFc
BBABCAAGBQJbm7i8AAoJELvpdr8mrl3SNBQQANp57g9R15FxBxvKpu2TvP9eZJl/CeVCb6ED8=
NZL
TUweQmm3mMfzmtkbuBU9BWJwR/dfqWnjvNA/8awXDA1dxLUEUC76y1P2ya5F1DGeB9PzmK3hq=
iez
jeN0irBJwMx2ZHT190NML8InRHry1pOvkFXQBrtgwzlyvgXsuU5Und/YesGPzYwVvb0rFIbjM=
ncm
FjuIIlrVnIH3iOcr9yG+4hLHcmKcPcOBStJi5KJT/5d13i4HRKj8j3Q2wyK/XPvqBl7CBTpUv=
grr
gZA856rkOVRCwy9v9q3+F7soRwGoaKoUxhWLJt/cCXoQbRCIc9UmNxq5a2pQLrCU3MOqZEPJB=
GT/
sYfsRlNsK4Shop/pubhvRKgYVFLH/Bc8gSvBKalIOkwQxUHyH6t0YXTOFcaIymRlt+XlyH8+r=
3rq
TLIVDzjxUur0OKU/1yjG7IIBzwoFAGxXzdkeSIJ3V2oXqH4WdM+BdawllDaq3t3qMu5ykjCBR=
yxU
M4S3SoSiYyz5u5mSlSFApJXGqz0HudIUCwoO3gLruHNnj8kT0ScwyPTqS4U3zA8qYYr9+2n5n=
gN4
ZuYxWCX7/GDhYAIysdj5N+MuXElIOZeO5EUp3nIjcuoTivWTj8i4lcS56tWcEdJyporJRbHRt=
VyV
5HNGWjZIlRi8z5YBkKD11bDYdFZAPskHFFN7wsFcBBMBAgAGBQJbm7WQAAoJEIZFfh8x4fgdb=
4YP
/3v5dXvrJTUFs+8WFrY6zCmbCPDgMOu+Yw96XMqJOfdUSFgJsr9KzREGjmV43Z5p90c9dR7hP=
9j9
gv6R2N/Gn6GHljrW9F381iF1vZ7zmPTRMhXOmc6rbpisp3EicImmV+aWO5pn9C9RT2hrC4E2a=
cbv
at8LlHGbxEsRQhRtlUnfAKNxGbxkaBx8nIyjmkiFCvYUdIfdQZ5Pz6ePmUWeXVzDZKK7UO+Ca=
M+U
IMhnm44m7ud6aSS7xQFLDJr+8i5BnST1GBaAR9gr0+wQfeO077heB62Wtxgg0jr9wWIOPiD2X=
XHD
v3g3K1362+PR+nxTmcBelVjFqQpRXnw4Kcs6fmhCslHV+ixXN59q9GjOZ/OueU0JZHqZ6AFZQ=
zYl
TQD9X2cUwVbtfyOd4U1VAOVJ1F4YjD0iOkzfT8iGiEHNwtqPyWPcBvEK4/ZTDNVMUKnJPkqMa=
RKY
Q2JCv3aROtFYOCfyVoVAB/hXXGfpPWhhy1wo6gYdYe6ywt28zxXDdA9j5CBaUiQX4u24xOHbF=
aE3
+9kWLfv1MgPH5Kq7DZM6WJ3SvcqclQdaUlgPQlFTg03b2akkOXwmyQQfjA5u9G7Rz0q+8WJ+d=
zRj
2z0xgd1kAU4zckGs61M6GGGCQYcLlo1JLqUPcfBGUyRDVA8T+Tv3SmwvEuO5H+FpSVqAIykAn=
YI1
wsFcBBABAgAGBQJbm8vmAAoJEBF7vIC1phx84ccQAJCm6ibzB4lubSlWZ1fCK0vmJdBu1nxjV=
LEj
lMXw+L0xmqB2aEi5QuzoYlctnvmsL6PG7em9XO89NgPKBMVeJPSIHJ2ASOJgPk0gUknz+luOG=
MmF
1JKjfC8nwaB2GDEbj0vd3bfgLb6vOavg7XzvFavuGO4U4mzlvs8Ts+uSPBXEHDJH97AMhm+Lw=
TsR
92/a9lM95zX3jUJQvm/d8kwx1zbwXy21noOH8XmS4a8y9OKOjK6d2cxbWQJ3uio9sMyIfvp9T=
jE8
mw4U5W8bOcGDGQJhLXOiosJNl/QWCLjWdBfyXNdVIY6NXBQfvax2j9IZmugnd3u4/mFZsM16I=
CnO
fl3ULbs+PFJq9WHvmlUvbMTuGFL88TIlnKWfogRWtlaSvGBNFMAg+QxI1MHWq8PH4BNe8TqQd=
Zps
kWiRc8mvbziH59zX5EsIN90eRSmcbP6n4kBFutwtNDV9j19ee52c0GljELlJ1Q2F55LqTr0sy=
4j2
sEfObfLjIjkGs4DvLjeWbSllVKXPJ4JTUJCFO680EHE0jZ9p/VLkYNp3GDmrOSe3b7NjAUag/=
uom
x5X324p1vNzpP6Thd25q87ZljkuWayXcPp5r/9nLd33ZlGWSx5/eaUBpDSqOfXNAJTuYoFMfD=
a3U
kkC5H38e8TvJbnikKEstdT/50GZq5u2hLKiWNGVEwsFcBBIBAgAGBQJbm7/VAAoJEA0vhuyXG=
x0A
Y3sP/2Be0rwSRICIji9aNduvMknMBUfSG4IVF5+3icvWDJUJbuu0diNYmIRCpn7uJuwBrnDeV=
aYB
CTU45q95swUiSBaWliK9G1NQtLVZjSQ6kFBN/c3/Gn1/eVasJz3/5dIn+wAHFbdWWHc2m2Cr1=
r+Z
r3z3D5g6CDiFlFTvDPo6ZHbaqu7o+2QEcwg3fA5/HRcw5KG8B+boVAFqhNHxTHYFe+WEj5f6m=
qu8
LovDjhotTPq+inybSj8FbDhIwA4xpj4TrSoO+K1z0Kuc0+p9xLmlRB3QEB1FZt4iFxTSeh6oD=
TwW
X8STUaH0FlZSQQvDi1EWWkVhMu6wH9fzDDKwyaE8nn95tLv4WtceCyiRBv76RGx/Q+ejmvrvy=
6R7
0hwjWfM0Sdly2KaErnSgtEbB01qx9NCs6OBm/GNhn2WwskXnQD2oS6hAMJNI38y/XkRw8Y9SQ=
4K1
uFVBqoB+KGm2YoLfTKbGCf5U3wStWBn8a2k1j2h1hjlmlx2mA8uPkqfZQqti+HByT65rQUzFK=
OwZ
hLGhKoV8xYl8n8uVdC/NVNQI6wNoi8tEBJt0ctYnb8YdVHfRDOV5gQUsd+lCIA2dZCHWqjnLA=
D6m
kt+Q8iaVsp5eFKBlGsBSGYBpD20QLw9lixwaDzag3AhV71438ia7rjuK+bfcT8hvdFcOhcmjk=
Ors
jSvqwsFcBBIBAgAGBQJbm8iIAAoJECIOw3kbKW7CFN8P/RQk+RC0NnpL/yFAP3sF07D8ttzZN=
V3F
08ofvstZjZ4Cvc5HBUwVGehrVQO/hIjzEw8VmMFh0jnquuyvD3/OekcEAQ7aSSeJtU5+4WCPK=
0Aw
sV6S08J2EFKaNArBFUOwRCRENUgSdkDYidwtxZ6nsf8kGh80Bjr23yWcDz7lgGSzbj8JmwmVp=
kRn
OE+gpwx/QK/LZPbuJzhrDtwK5TKRTg57ZTcoD5NZ6OmKg3lSCn9eh4q8m6V0l48Y79lrZ2+ZC=
384
PsQwByoKacl1CS50UzHsd4i+wsWIjs4cl0vyRkn0Qk69yEWgG0WZHoP7WfVjCrWfgw5gBxHoW=
/QA
2aZOdSGcCLsJ1ubHh+KP43CSTNLm/+8oA49guZmBI+YsTyt4vr6/vYDvrSIz73n22edbgUr8Q=
OXN
h+sHJ7LH1sWG3kdZ8GptPqZOr7lAoGsz3QlvlEPJwqwYodShQb7sZmfT2d63YL0whBkeHOj7y=
FQp
PQYa5YDrBGQv+FLrCquysFS0cw3NzeJzhzAnDy/uSn/v6tpzvw/Qc16gMrJU0OdzfgKjzjF0N=
4Yq
IFiTPdq+bTXrvV5009ElR0uCTFjK/JF4ZVB2tn+QUwy5Jq972X3TsCQfUJKNS/O6sVM+XvcR5=
zw7
ZyqWBOMI9OEzUhqolfH+Vq36shpPjNR821NhMxh4yvWhwsBcBBABCAAGBQJc7pIqAAoJEL4Y/=
M44
5LLlLoEH/19s1qwYjKU5FushYDRtQGMXBHHqbuWHXuFgQqw9Ro9aIQTg1J3JiP04hfTIipKkU=
k8W
T7bp8oPxhoGTGhunkLGeel4VGzqew6KNgUjR4aOHly1rqWARgY6Vn1Zs2pOQwhvMHFZKzNyTX=
X0l
R67kGYDRiOY4DOYoEiSpWa0LpaIjAXzvpXgzsp9cQ73yS9wBs1CaFlgi2IleI/HM64j4gQHYm=
Hva
JngficYZBislT+6TasOJYcbjMgXtIBi8dfvox6qA7weXaTLwIixJijpUofb1IiQVAJDNCYzdA=
7aI
IZ2wCoNpIeqw7a+567ecdbcTe+8XQOMzCpqYVYO6HEV0XtnCwXMEEgEIAB0WIQTzlzFsIQqcA=
xIF
ZpFGfI7ScWqT1wUCXO7vlwAKCRBGfI7ScWqT13aVD/9s3dQVKgqwEvTyZztMtwiWtTqb2AMjf=
5/g
1MW8XbN+pim6tP+63suWYitIUG8jL8gPXvLMhE28Tndk2RkalG7RjhDrT+aiJDKFL1KegwZTh=
QBQ
9xQvLP2wk+5i0p+F5ABMn2NivCD7XVw1pk1MUM1xDyVXLvqPT8sc35RORbuny7OeM50ZgaTS+=
5wv
8cQ4Nl8SmdyOX7teGVPUTNpJz3/QXL56dcF3p/CLtF9kcJw0biPSh+7WpDWFLe45yobY7N6Hs=
2ur
ptA9K0B+1f5WNdYdbvH0r4coPJ9FSVlSt9K4hUFR31eA/NLlWaq2NJfixTyC5QP8uykLh+ZgR=
U9K
NaGbXoSZ4EoYc3EQ56i4YAA0jJGhIdfbIY++GNs42xJuyqhYuJEKl/y7sCRxHqYGx4l+E+1gs=
V8E
43XKDIizjkgUOu1+Zcrqeo64gSqllCaT99/3v8uJFrZmWDDH1sYLnoxMgPfb+ZdVwu8t8YDlU=
zmc
F0vcbAIKFDLI9/sSFuaYW8zrfSZturGAX6geZAH5S/SLn4OnMC8oZrqZmJHu7Ty3zpey5Vajs=
l9K
gEcQ06D+YH/qF5IZA4E8SwQ1j7fD7LQu7ud4VuAaF1lKU5UeE+ZBv3TYdJ+5HevRbM26LbKox=
LpL
GR+y5qwPaMwgvYLb3wQsgBy88HFgF8J9cpicJBokrs7BTQRbm6Q+ARAAwHFE0alxf2mOdzkh+=
yMC
CvZRSsSJtCKBZDhIeyzH6exRs2j+wDa2XXCM4WYt/McjpHGhWPp6RhFr5KO65SAJ9CaQTuMd4=
X4Z
oQQ/1kmPC0CBUDTYxJt786zKO2/SWyQKkMX21EWNw6pdxlM3lkxvbmidNLvhBD5WPM3FUoQ5b=
SJe
Ty4odtHvMYE5zc8eXNddJUErtImb9pQBOgzPtmyUE7DEmIsCpcE7r/SyPQoZ6KOvrbDeeTasj=
MWK
iYBJZN1c5U10q9/q7UgsH7atnIpxE288XNV7oSF+qbv2ghpzX7hJDN+G+xtQ+gj8wzKqJDRW8=
qDu
g0Nfn1unOYHLV4P5WetNohJeAuK4HK9/hKX6D1FsynjPCV7+SqauGA8Yb24ra/A5vIK9/PlCh=
WSp
Vi5cIUOeq/8wFL+iyLJtdRphbNv3JoA9W6gUzRx3E1sFrUUy4Jp6iW1YrDCbmCbeCjT6qYU1r=
D2P
EhLW7nyJWB1zidpalMzkXk64ntrtKnErxgG0n3nPWqUxZdl5KP3Xaj3GTKSoQYl5mPLSc0j5N=
/hu
Larq+Ok2AJuaLorSbIAEetQru7Pjzbqv6Uyw4SvuvzY5nPeDRgXEQOKk7srBBhO/b2Fj9qCAF=
OBb
+oKmlh2eDBCNl06h/MIsMz3QkD2LEhNH11omLuzm3hK0+oi0k2RseK0AEQEAAcLBXwQYAQgAC=
QUC
W5ukPgIbDAAKCRDjVOa44ji5+AwxD/0bsnJFuuUmXDxuHDHzYFsWRfK1Y3lZf/TwX8tNSvEdI=
Wo1
ONG1rV0jIm8u49P3TI8/fYzei/gCRyb6y8+KmEc59mLPON1vkX14+tmXXuGDQROUi4ycHkQmz=
Fim
iS4+uPfX3LcU8nm/fgDC0EuMkUsB7gGS5gG+QMgltYAXE1mW/DjeQZlp0anhpiIAtRLwpx8vv=
mgZ
x059Jvs1fPQYUy01Gpd+bXI1BcJbgWN/UdrsfxzZQTtRmN2flmF4Qb6u6pGrU4S42kEppzqzI=
c6m
JnUoT9ZXhU1W811FCGL/xm8pzv2Ky9oGkKWj9WxFBIvJVAH1yWxFhnZxxZHIq8otPdhPP/Y/P=
QyY
OJpmajmru07VMY0TJQXCJYl5M0i1JPkLw+CytZFonrybHuJrXhQXZFh3z+AR//vA8WqUXBtVA=
IXk
p0kUOS4judGp5zge6Fxfr4CiGontkwX2cUDRgLN0UPm4Gg3IQqhZuWnYkj+fjk+DY5ClHhqQX=
v2k
ckEpXv0a6KU4AovOaY3v47mBJ9j/VAIJHwSazh70PWftkr2vBUXetTSS5AieCxbpkZ/cEJV9o=
nBW
4vFA1d3aNIVyUUWE1gsax7HDIZKxVi4WIjxeIqYV+1DXTlgUPdKqR8gMR5g2s3aNu4BI377IG=
DHb
3ipJxDkxG+aYcMVoIOwXCA6CX/VDAg=3D=3D
=3DR9cN
-----END PGP PUBLIC KEY BLOCK-----

--------------ACE1317D86CDEF8EB3357397--

--oszkB5zXk7RHUoHPiBvOhd3bHhY6K1XWn--

--6sMdO5WuoC7xWF7gUZKvadvAR6Op9P4pi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl+z6ssFAwAAAAAACgkQ41TmuOI4ufg1
ehAAjS2bmCrbnqFEhSep9MXEaRoeF2bmaZVn3LbxFw8qv4MQsx7w19wPob0ClbQnagS9gl4V9LEX
XUTosg+35RIKCyLvlOrHVPzy5y2Fd+mO8ne5kvCnF744/x4QVFoQkLPwsbkqMMy3AQiGosVgi9vO
gmUAmhjn2usJYFzUfkyxPzhsPTaMKFDgpmrF4h3Sv5Yrtu+AGWSo9Bj8GNo/h7R8XQgi4GXKmtAq
eCuNwzJjCYilgDlmHoNoXhOq23Ex6Xf/6n/Wgt7KOAY4HHLHqC/ys0uDUd6iV3hcH9U593WqcOSJ
nu1+PZFZ0Q8ScJGptED9MZB9q7oWdb7RVNaQlF82hsftGuhCa1C696qOOSbfS4tWRcD0g7SdQl8z
3xZU+itmiWbiH59fqZQrb3oWSK906QvRPnAqEDaexskPgutXKpyWWVm1NJua/VQGG+Y2ZReQxJnJ
8L/sx4b8HHAd0I4K2ngg2eQeB+f5eRNKyCyTkKzAL0Iwk8M59eb7ZHlp+wD8r5z/MGY2UFPCDmyh
B/G6dcK7HQziVt0HWcMWGARswr1htYsdKh8x1VuQcO5mhuu8KDOgaUmmMy9quU2sVhxFliInoo3k
qGfdoxlWyqQQNebmKs7IpsbHMJsWoH4cEnOutBn1B8C75L+jAPhwQ9NuHUh6lh4b5o3zVoJcTZjt
o8Q=
=IJjy
-----END PGP SIGNATURE-----

--6sMdO5WuoC7xWF7gUZKvadvAR6Op9P4pi--

