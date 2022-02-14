Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CB04B5E8C
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiBOAAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:00:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiBOAAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:00:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59B0419AF;
        Mon, 14 Feb 2022 16:00:29 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EMeUE2020024;
        Tue, 15 Feb 2022 00:00:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kqlcqmF5w2MGv7JpCS8yHLa0y1a97OHn8G/774OLrzY=;
 b=GjtFNz1W3GWfwVqC5fIB3730gWcM0vrD3p/DOUIlXzxaDugIbjfyIRLxyXAiL7IVxI8P
 tQkZgym6UV596pWHjZmhMy0d7s3ZC+3LTvK4oV3f7hBGBWKcBMUL6jTh7WmaVToyuA/H
 i49cT8ZHuFFpR/k+XW2QpFK6jqQfMYXtLlJhvdSDNowJWqBGgIExapPTuw//kEao8ezu
 vNvE3z7a0pWDnYtKyzX3HAf3IYlqwcTfcpVG0MVvn39oNi19NVfry22lCeXTTREK4n6x
 z4m9x2h6J364GLnE4v+iEWT5dDXvEfK+Uf6lDoLJSGOtOttdAhA1052EGVj3X/QKuNMu hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e79fw72jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:00:28 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21ENwrDm022756;
        Tue, 15 Feb 2022 00:00:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e79fw72hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:00:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21ENw1uu006757;
        Tue, 15 Feb 2022 00:00:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64h9su98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:00:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F00K8345875638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:00:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF18DA405D;
        Tue, 15 Feb 2022 00:00:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AC32A405B;
        Tue, 15 Feb 2022 00:00:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:00:19 +0000 (GMT)
Date:   Mon, 14 Feb 2022 16:52:59 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v4 02/10] KVM: s390: Honor storage keys when accessing
 guest memory
Message-ID: <20220214165259.4bd4fd12@p-imbrenda>
In-Reply-To: <20220211182215.2730017-3-scgl@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
        <20220211182215.2730017-3-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gfTjf90qZ4AvqYeAcnLexv9Iiib7MAD2
X-Proofpoint-ORIG-GUID: foHyACBzmzgQStrT5ICHysPy7DXc8Fg7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140134
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Feb 2022 19:22:07 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Storage key checking had not been implemented for instructions emulated
> by KVM. Implement it by enhancing the functions used for guest access,
> in particular those making use of access_guest which has been renamed
> to access_guest_with_key.
> Accesses via access_guest_real should not be key checked.
> 
> For actual accesses, key checking is done by
> copy_from/to_user_key (which internally uses MVCOS/MVCP/MVCS).
> In cases where accessibility is checked without an actual access,
> this is performed by getting the storage key and checking if the access
> key matches. In both cases, if applicable, storage and fetch protection
> override are honored.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/ctl_reg.h |   2 +
>  arch/s390/include/asm/page.h    |   2 +
>  arch/s390/kvm/gaccess.c         | 187 ++++++++++++++++++++++++++++++--
>  arch/s390/kvm/gaccess.h         |  77 +++++++++++--
>  arch/s390/kvm/intercept.c       |  12 +-
>  arch/s390/kvm/kvm-s390.c        |   4 +-
>  6 files changed, 253 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/s390/include/asm/ctl_reg.h b/arch/s390/include/asm/ctl_reg.h
> index 04dc65f8901d..c800199a376b 100644
> --- a/arch/s390/include/asm/ctl_reg.h
> +++ b/arch/s390/include/asm/ctl_reg.h
> @@ -12,6 +12,8 @@
>  
>  #define CR0_CLOCK_COMPARATOR_SIGN	BIT(63 - 10)
>  #define CR0_LOW_ADDRESS_PROTECTION	BIT(63 - 35)
> +#define CR0_FETCH_PROTECTION_OVERRIDE	BIT(63 - 38)
> +#define CR0_STORAGE_PROTECTION_OVERRIDE	BIT(63 - 39)
>  #define CR0_EMERGENCY_SIGNAL_SUBMASK	BIT(63 - 49)
>  #define CR0_EXTERNAL_CALL_SUBMASK	BIT(63 - 50)
>  #define CR0_CLOCK_COMPARATOR_SUBMASK	BIT(63 - 52)
> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> index d98d17a36c7b..cfc4d6fb2385 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -20,6 +20,8 @@
>  #define PAGE_SIZE	_PAGE_SIZE
>  #define PAGE_MASK	_PAGE_MASK
>  #define PAGE_DEFAULT_ACC	0
> +/* storage-protection override */
> +#define PAGE_SPO_ACC		9
>  #define PAGE_DEFAULT_KEY	(PAGE_DEFAULT_ACC << 4)
>  
>  #define HPAGE_SHIFT	20
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 4460808c3b9a..7fca0cff4c12 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -10,6 +10,7 @@
>  #include <linux/mm_types.h>
>  #include <linux/err.h>
>  #include <linux/pgtable.h>
> +#include <linux/bitfield.h>
>  
>  #include <asm/gmap.h>
>  #include "kvm-s390.h"
> @@ -794,6 +795,79 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>  	return 1;
>  }
>  
> +static bool fetch_prot_override_applicable(struct kvm_vcpu *vcpu, enum gacc_mode mode,
> +					   union asce asce)
> +{
> +	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> +	unsigned long override;
> +
> +	if (mode == GACC_FETCH || mode == GACC_IFETCH) {
> +		/* check if fetch protection override enabled */
> +		override = vcpu->arch.sie_block->gcr[0];
> +		override &= CR0_FETCH_PROTECTION_OVERRIDE;
> +		/* not applicable if subject to DAT && private space */
> +		override = override && !(psw_bits(*psw).dat && asce.p);
> +		return override;
> +	}
> +	return false;
> +}
> +
> +static bool fetch_prot_override_applies(unsigned long ga, unsigned int len)
> +{
> +	return ga < 2048 && ga + len <= 2048;
> +}
> +
> +static bool storage_prot_override_applicable(struct kvm_vcpu *vcpu)
> +{
> +	/* check if storage protection override enabled */
> +	return vcpu->arch.sie_block->gcr[0] & CR0_STORAGE_PROTECTION_OVERRIDE;
> +}
> +
> +static bool storage_prot_override_applies(u8 access_control)
> +{
> +	/* matches special storage protection override key (9) -> allow */
> +	return access_control == PAGE_SPO_ACC;
> +}
> +
> +static int vcpu_check_access_key(struct kvm_vcpu *vcpu, u8 access_key,
> +				 enum gacc_mode mode, union asce asce, gpa_t gpa,
> +				 unsigned long ga, unsigned int len)
> +{
> +	u8 storage_key, access_control;
> +	unsigned long hva;
> +	int r;
> +
> +	/* access key 0 matches any storage key -> allow */
> +	if (access_key == 0)
> +		return 0;
> +	/*
> +	 * caller needs to ensure that gfn is accessible, so we can
> +	 * assume that this cannot fail
> +	 */
> +	hva = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gpa));
> +	mmap_read_lock(current->mm);
> +	r = get_guest_storage_key(current->mm, hva, &storage_key);
> +	mmap_read_unlock(current->mm);
> +	if (r)
> +		return r;
> +	access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
> +	/* access key matches storage key -> allow */
> +	if (access_control == access_key)
> +		return 0;
> +	if (mode == GACC_FETCH || mode == GACC_IFETCH) {
> +		/* it is a fetch and fetch protection is off -> allow */
> +		if (!(storage_key & _PAGE_FP_BIT))
> +			return 0;
> +		if (fetch_prot_override_applicable(vcpu, mode, asce) &&
> +		    fetch_prot_override_applies(ga, len))
> +			return 0;
> +	}
> +	if (storage_prot_override_applicable(vcpu) &&
> +	    storage_prot_override_applies(access_control))
> +		return 0;
> +	return PGM_PROTECTION;
> +}
> +
>  /**
>   * guest_range_to_gpas() - Calculate guest physical addresses of page fragments
>   * covering a logical range
> @@ -804,6 +878,7 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>   * @len: length of range in bytes
>   * @asce: address-space-control element to use for translation
>   * @mode: access mode
> + * @access_key: access key to mach the range's storage keys against
>   *
>   * Translate a logical range to a series of guest absolute addresses,
>   * such that the concatenation of page fragments starting at each gpa make up
> @@ -830,7 +905,8 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>   */
>  static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  			       unsigned long *gpas, unsigned long len,
> -			       const union asce asce, enum gacc_mode mode)
> +			       const union asce asce, enum gacc_mode mode,
> +			       u8 access_key)
>  {
>  	psw_t *psw = &vcpu->arch.sie_block->gpsw;
>  	unsigned int offset = offset_in_page(ga);
> @@ -857,6 +933,10 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  		}
>  		if (rc)
>  			return trans_exc(vcpu, rc, ga, ar, mode, prot);
> +		rc = vcpu_check_access_key(vcpu, access_key, mode, asce, gpa, ga,
> +					   fragment_len);
> +		if (rc)
> +			return trans_exc(vcpu, rc, ga, ar, mode, PROT_TYPE_KEYC);
>  		if (gpas)
>  			*gpas++ = gpa;
>  		offset = 0;
> @@ -880,16 +960,54 @@ static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
>  	return rc;
>  }
>  
> -int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
> -		 unsigned long len, enum gacc_mode mode)
> +static int
> +access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
> +			   void *data, unsigned int len, u8 access_key)
> +{
> +	struct kvm_memory_slot *slot;
> +	bool writable;
> +	gfn_t gfn;
> +	hva_t hva;
> +	int rc;
> +
> +	gfn = gpa >> PAGE_SHIFT;
> +	slot = gfn_to_memslot(kvm, gfn);
> +	hva = gfn_to_hva_memslot_prot(slot, gfn, &writable);
> +
> +	if (kvm_is_error_hva(hva))
> +		return PGM_ADDRESSING;
> +	/*
> +	 * Check if it's a ro memslot, even tho that can't occur (they're unsupported).
> +	 * Don't try to actually handle that case.
> +	 */
> +	if (!writable && mode == GACC_STORE)
> +		return -EOPNOTSUPP;
> +	hva += offset_in_page(gpa);
> +	if (mode == GACC_STORE)
> +		rc = copy_to_user_key((void __user *)hva, data, len, access_key);
> +	else
> +		rc = copy_from_user_key(data, (void __user *)hva, len, access_key);
> +	if (rc)
> +		return PGM_PROTECTION;
> +	if (mode == GACC_STORE)
> +		mark_page_dirty_in_slot(kvm, slot, gfn);
> +	return 0;
> +}
> +
> +int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> +			  void *data, unsigned long len, enum gacc_mode mode,
> +			  u8 access_key)
>  {
>  	psw_t *psw = &vcpu->arch.sie_block->gpsw;
>  	unsigned long nr_pages, idx;
>  	unsigned long gpa_array[2];
>  	unsigned int fragment_len;
>  	unsigned long *gpas;
> +	enum prot_type prot;
>  	int need_ipte_lock;
>  	union asce asce;
> +	bool try_storage_prot_override;
> +	bool try_fetch_prot_override;
>  	int rc;
>  
>  	if (!len)
> @@ -904,16 +1022,47 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		gpas = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
>  	if (!gpas)
>  		return -ENOMEM;
> +	try_fetch_prot_override = fetch_prot_override_applicable(vcpu, mode, asce);
> +	try_storage_prot_override = storage_prot_override_applicable(vcpu);
>  	need_ipte_lock = psw_bits(*psw).dat && !asce.r;
>  	if (need_ipte_lock)
>  		ipte_lock(vcpu);
> -	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
> -	for (idx = 0; idx < nr_pages && !rc; idx++) {
> +	/*
> +	 * Since we do the access further down ultimately via a move instruction
> +	 * that does key checking and returns an error in case of a protection
> +	 * violation, we don't need to do the check during address translation.
> +	 * Skip it by passing access key 0, which matches any storage key,
> +	 * obviating the need for any further checks. As a result the check is
> +	 * handled entirely in hardware on access, we only need to take care to
> +	 * forego key protection checking if fetch protection override applies or
> +	 * retry with the special key 9 in case of storage protection override.
> +	 */
> +	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode, 0);
> +	if (rc)
> +		goto out_unlock;
> +	for (idx = 0; idx < nr_pages; idx++) {
>  		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
> -		rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
> +		if (try_fetch_prot_override && fetch_prot_override_applies(ga, fragment_len)) {
> +			rc = access_guest_page(vcpu->kvm, mode, gpas[idx],
> +					       data, fragment_len);
> +		} else {
> +			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
> +							data, fragment_len, access_key);
> +		}
> +		if (rc == PGM_PROTECTION && try_storage_prot_override)
> +			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
> +							data, fragment_len, PAGE_SPO_ACC);
> +		if (rc == PGM_PROTECTION)
> +			prot = PROT_TYPE_KEYC;
> +		if (rc)
> +			break;
>  		len -= fragment_len;
>  		data += fragment_len;
> +		ga = kvm_s390_logical_to_effective(vcpu, ga + fragment_len);
>  	}
> +	if (rc > 0)
> +		rc = trans_exc(vcpu, rc, ga, ar, mode, prot);
> +out_unlock:
>  	if (need_ipte_lock)
>  		ipte_unlock(vcpu);
>  	if (nr_pages > ARRAY_SIZE(gpa_array))
> @@ -940,12 +1089,13 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>  }
>  
>  /**
> - * guest_translate_address - translate guest logical into guest absolute address
> + * guest_translate_address_with_key - translate guest logical into guest absolute address
>   * @vcpu: virtual cpu
>   * @gva: Guest virtual address
>   * @ar: Access register
>   * @gpa: Guest physical address
>   * @mode: Translation access mode
> + * @access_key: access key to mach the storage key with
>   *
>   * Parameter semantics are the same as the ones from guest_translate.
>   * The memory contents at the guest address are not changed.
> @@ -953,8 +1103,9 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>   * Note: The IPTE lock is not taken during this function, so the caller
>   * has to take care of this.
>   */
> -int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
> -			    unsigned long *gpa, enum gacc_mode mode)
> +int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
> +				     unsigned long *gpa, enum gacc_mode mode,
> +				     u8 access_key)
>  {
>  	union asce asce;
>  	int rc;
> @@ -963,7 +1114,17 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
>  	if (rc)
>  		return rc;
> -	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode);
> +	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode,
> +				   access_key);
> +}
> +
> +int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
> +			    unsigned long *gpa, enum gacc_mode mode)
> +{
> +	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
> +
> +	return guest_translate_address_with_key(vcpu, gva, ar, gpa, mode,
> +						access_key);
>  }
>  
>  /**
> @@ -973,9 +1134,10 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>   * @ar: Access register
>   * @length: Length of test range
>   * @mode: Translation access mode
> + * @access_key: access key to mach the storage keys with
>   */
>  int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
> -		    unsigned long length, enum gacc_mode mode)
> +		    unsigned long length, enum gacc_mode mode, u8 access_key)
>  {
>  	union asce asce;
>  	int rc = 0;
> @@ -984,7 +1146,8 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  	if (rc)
>  		return rc;
>  	ipte_lock(vcpu);
> -	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode);
> +	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode,
> +				 access_key);
>  	ipte_unlock(vcpu);
>  
>  	return rc;
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index 7c72a5e3449f..e5b2f56e7962 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -186,24 +186,31 @@ enum gacc_mode {
>  	GACC_IFETCH,
>  };
>  
> +int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
> +				     unsigned long *gpa, enum gacc_mode mode,
> +				     u8 access_key);
> +
>  int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva,
>  			    u8 ar, unsigned long *gpa, enum gacc_mode mode);
> +
>  int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
> -		    unsigned long length, enum gacc_mode mode);
> +		    unsigned long length, enum gacc_mode mode, u8 access_key);
>  
> -int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
> -		 unsigned long len, enum gacc_mode mode);
> +int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> +			  void *data, unsigned long len, enum gacc_mode mode,
> +			  u8 access_key);
>  
>  int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>  		      void *data, unsigned long len, enum gacc_mode mode);
>  
>  /**
> - * write_guest - copy data from kernel space to guest space
> + * write_guest_with_key - copy data from kernel space to guest space
>   * @vcpu: virtual cpu
>   * @ga: guest address
>   * @ar: access register
>   * @data: source address in kernel space
>   * @len: number of bytes to copy
> + * @access_key: access key the storage key needs to match
>   *
>   * Copy @len bytes from @data (kernel space) to @ga (guest address).
>   * In order to copy data to guest space the PSW of the vcpu is inspected:
> @@ -214,8 +221,8 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>   * The addressing mode of the PSW is also inspected, so that address wrap
>   * around is taken into account for 24-, 31- and 64-bit addressing mode,
>   * if the to be copied data crosses page boundaries in guest address space.
> - * In addition also low address and DAT protection are inspected before
> - * copying any data (key protection is currently not implemented).
> + * In addition low address, DAT and key protection checks are performed before
> + * copying any data.
>   *
>   * This function modifies the 'struct kvm_s390_pgm_info pgm' member of @vcpu.
>   * In case of an access exception (e.g. protection exception) pgm will contain
> @@ -243,10 +250,53 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>   *	 if data has been changed in guest space in case of an exception.
>   */
>  static inline __must_check
> +int write_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> +			 void *data, unsigned long len, u8 access_key)
> +{
> +	return access_guest_with_key(vcpu, ga, ar, data, len, GACC_STORE,
> +				     access_key);
> +}
> +
> +/**
> + * write_guest - copy data from kernel space to guest space
> + * @vcpu: virtual cpu
> + * @ga: guest address
> + * @ar: access register
> + * @data: source address in kernel space
> + * @len: number of bytes to copy
> + *
> + * The behaviour of write_guest is identical to write_guest_with_key, except
> + * that the PSW access key is used instead of an explicit argument.
> + */
> +static inline __must_check
>  int write_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		unsigned long len)
>  {
> -	return access_guest(vcpu, ga, ar, data, len, GACC_STORE);
> +	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
> +
> +	return write_guest_with_key(vcpu, ga, ar, data, len, access_key);
> +}
> +
> +/**
> + * read_guest_with_key - copy data from guest space to kernel space
> + * @vcpu: virtual cpu
> + * @ga: guest address
> + * @ar: access register
> + * @data: destination address in kernel space
> + * @len: number of bytes to copy
> + * @access_key: access key the storage key needs to match
> + *
> + * Copy @len bytes from @ga (guest address) to @data (kernel space).
> + *
> + * The behaviour of read_guest_with_key is identical to write_guest_with_key,
> + * except that data will be copied from guest space to kernel space.
> + */
> +static inline __must_check
> +int read_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> +			void *data, unsigned long len, u8 access_key)
> +{
> +	return access_guest_with_key(vcpu, ga, ar, data, len, GACC_FETCH,
> +				     access_key);
>  }
>  
>  /**
> @@ -259,14 +309,16 @@ int write_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>   *
>   * Copy @len bytes from @ga (guest address) to @data (kernel space).
>   *
> - * The behaviour of read_guest is identical to write_guest, except that
> - * data will be copied from guest space to kernel space.
> + * The behaviour of read_guest is identical to read_guest_with_key, except
> + * that the PSW access key is used instead of an explicit argument.
>   */
>  static inline __must_check
>  int read_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  	       unsigned long len)
>  {
> -	return access_guest(vcpu, ga, ar, data, len, GACC_FETCH);
> +	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
> +
> +	return read_guest_with_key(vcpu, ga, ar, data, len, access_key);
>  }
>  
>  /**
> @@ -287,7 +339,10 @@ static inline __must_check
>  int read_guest_instr(struct kvm_vcpu *vcpu, unsigned long ga, void *data,
>  		     unsigned long len)
>  {
> -	return access_guest(vcpu, ga, 0, data, len, GACC_IFETCH);
> +	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
> +
> +	return access_guest_with_key(vcpu, ga, 0, data, len, GACC_IFETCH,
> +				     access_key);
>  }
>  
>  /**
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index d07ff646d844..8bd42a20d924 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -331,18 +331,18 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
>  
>  	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>  
> -	/* Make sure that the source is paged-in */
> -	rc = guest_translate_address(vcpu, vcpu->run->s.regs.gprs[reg2],
> -				     reg2, &srcaddr, GACC_FETCH);
> +	/* Ensure that the source is paged-in, no actual access -> no key checking */
> +	rc = guest_translate_address_with_key(vcpu, vcpu->run->s.regs.gprs[reg2],
> +					      reg2, &srcaddr, GACC_FETCH, 0);
>  	if (rc)
>  		return kvm_s390_inject_prog_cond(vcpu, rc);
>  	rc = kvm_arch_fault_in_page(vcpu, srcaddr, 0);
>  	if (rc != 0)
>  		return rc;
>  
> -	/* Make sure that the destination is paged-in */
> -	rc = guest_translate_address(vcpu, vcpu->run->s.regs.gprs[reg1],
> -				     reg1, &dstaddr, GACC_STORE);
> +	/* Ensure that the source is paged-in, no actual access -> no key checking */
> +	rc = guest_translate_address_with_key(vcpu, vcpu->run->s.regs.gprs[reg1],
> +					      reg1, &dstaddr, GACC_STORE, 0);
>  	if (rc)
>  		return kvm_s390_inject_prog_cond(vcpu, rc);
>  	rc = kvm_arch_fault_in_page(vcpu, dstaddr, 1);
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 2296b1ff1e02..fdbd6c1dc709 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4713,7 +4713,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>  	case KVM_S390_MEMOP_LOGICAL_READ:
>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>  			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
> -					    mop->size, GACC_FETCH);
> +					    mop->size, GACC_FETCH, 0);
>  			break;
>  		}
>  		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
> @@ -4725,7 +4725,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>  	case KVM_S390_MEMOP_LOGICAL_WRITE:
>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>  			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
> -					    mop->size, GACC_STORE);
> +					    mop->size, GACC_STORE, 0);
>  			break;
>  		}
>  		if (copy_from_user(tmpbuf, uaddr, mop->size)) {

