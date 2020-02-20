Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D40165E15
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgBTNDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:03:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727943AbgBTNDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:03:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=q/2nOjjwcwBj1iqlZWZW67bop9S+zJlmH/W/Rvn+lvM=;
        b=WNJK2JM68K5IYyizMIOtXdsIGS3XPvRxX5niZ6TS13S+bgLUbjBQZeU+tHwr15pheiZW9o
        sVuKCtVThyTxNc6UJPs5WyJs5xh54d9Oyi+CvYDFd8c+/ZSFlqczjKqWlfoVMAAzzZQLI1
        NZvcPisvc5D/PgBTGSIgpeV4X2EkEnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-z_rAXw6SNw20JWercynXCw-1; Thu, 20 Feb 2020 08:02:58 -0500
X-MC-Unique: z_rAXw6SNw20JWercynXCw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17687108442A;
        Thu, 20 Feb 2020 13:02:57 +0000 (UTC)
Received: from [10.36.118.29] (unknown [10.36.118.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 368821001B2D;
        Thu, 20 Feb 2020 13:02:25 +0000 (UTC)
Subject: Re: [PATCH v3 09/37] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
 <20200220104020.5343-10-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABtCREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT6JAlgEEwEIAEICGwMFCQlmAYAGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheAFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl3pImkCGQEACgkQTd4Q
 9wD/g1o+VA//SFvIHUAvul05u6wKv/pIR6aICPdpF9EIgEU448g+7FfDgQwcEny1pbEzAmiw
 zAXIQ9H0NZh96lcq+yDLtONnXk/bEYWHHUA014A1wqcYNRY8RvY1+eVHb0uu0KYQoXkzvu+s
 Dncuguk470XPnscL27hs8PgOP6QjG4jt75K2LfZ0eAqTOUCZTJxA8A7E9+XTYuU0hs7QVrWJ
 jQdFxQbRMrYz7uP8KmTK9/Cnvqehgl4EzyRaZppshruKMeyheBgvgJd5On1wWq4ZUV5PFM4x
 II3QbD3EJfWbaJMR55jI9dMFa+vK7MFz3rhWOkEx/QR959lfdRSTXdxs8V3zDvChcmRVGN8U
 Vo93d1YNtWnA9w6oCW1dnDZ4kgQZZSBIjp6iHcA08apzh7DPi08jL7M9UQByeYGr8KuR4i6e
 RZI6xhlZerUScVzn35ONwOC91VdYiQgjemiVLq1WDDZ3B7DIzUZ4RQTOaIWdtXBWb8zWakt/
 ztGhsx0e39Gvt3391O1PgcA7ilhvqrBPemJrlb9xSPPRbaNAW39P8ws/UJnzSJqnHMVxbRZC
 Am4add/SM+OCP0w3xYss1jy9T+XdZa0lhUvJfLy7tNcjVG/sxkBXOaSC24MFPuwnoC9WvCVQ
 ZBxouph3kqc4Dt5X1EeXVLeba+466P1fe1rC8MbcwDkoUo65Ag0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAGJAiUEGAECAA8FAlXLn5ECGwwFCQlmAYAACgkQTd4Q
 9wD/g1qA6w/+M+ggFv+JdVsz5+ZIc6MSyGUozASX+bmIuPeIecc9UsFRatc91LuJCKMkD9Uv
 GOcWSeFpLrSGRQ1Z7EMzFVU//qVs6uzhsNk0RYMyS0B6oloW3FpyQ+zOVylFWQCzoyyf227y
 GW8HnXunJSC+4PtlL2AY4yZjAVAPLK2l6mhgClVXTQ/S7cBoTQKP+jvVJOoYkpnFxWE9pn4t
 H5QIFk7Ip8TKr5k3fXVWk4lnUi9MTF/5L/mWqdyIO1s7cjharQCstfWCzWrVeVctpVoDfJWp
 4LwTuQ5yEM2KcPeElLg5fR7WB2zH97oI6/Ko2DlovmfQqXh9xWozQt0iGy5tWzh6I0JrlcxJ
 ileZWLccC4XKD1037Hy2FLAjzfoWgwBLA6ULu0exOOdIa58H4PsXtkFPrUF980EEibUp0zFz
 GotRVekFAceUaRvAj7dh76cToeZkfsjAvBVb4COXuhgX6N4pofgNkW2AtgYu1nUsPAo+NftU
 CxrhjHtLn4QEBpkbErnXQyMjHpIatlYGutVMS91XTQXYydCh5crMPs7hYVsvnmGHIaB9ZMfB
 njnuI31KBiLUks+paRkHQlFcgS2N3gkRBzH7xSZ+t7Re3jvXdXEzKBbQ+dC3lpJB0wPnyMcX
 FOTT3aZT7IgePkt5iC/BKBk3hqKteTnJFeVIT7EC+a6YUFg=
Organization: Red Hat GmbH
Message-ID: <1f0c2c5a-5964-dc34-73af-7b1776391276@redhat.com>
Date:   Thu, 20 Feb 2020 14:02:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200220104020.5343-10-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> +{
> +	int r =3D 0;
> +	u16 dummy;
> +	void __user *argp =3D (void __user *)cmd->data;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_ENABLE: {
> +		r =3D -EINVAL;
> +		if (kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r =3D kvm_s390_pv_alloc_vm(kvm);
> +		if (r)
> +			break;
> +
> +		/* FMT 4 SIE needs esca */
> +		r =3D sca_switch_to_extended(kvm);
> +		if (r) {
> +			kvm_s390_pv_dealloc_vm(kvm);
> +			kvm_s390_vcpu_unblock_all(kvm);

You forgot to remove that.

> +			mutex_unlock(&kvm->lock);

That's certainly wrong as well.

> +			break;
> +		}
> +		r =3D kvm_s390_pv_create_vm(kvm, &cmd->rc, &cmd->rrc);
> +		if (!r)
> +			r =3D kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
> +		if (r)
> +			kvm_s390_pv_destroy_vm(kvm, &dummy, &dummy);

Should there be a kvm_s390_pv_dealloc_vm() as well?

> +
> +		break;
> +	}
> +	case KVM_PV_DISABLE: {
> +		r =3D -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
> +		r =3D kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
> +		if (!r)
> +			kvm_s390_pv_dealloc_vm(kvm);

Hm, if destroy fails, the CPUs would already have been removed.

Is there a way to make kvm_s390_pv_destroy_vm() never fail? The return
value is always ignored except here ... which looks wrong.

> +		break;
> +	}

[...]

> @@ -2558,10 +2724,21 @@ static void kvm_free_vcpus(struct kvm *kvm)
> =20
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
> +	u16 rc, rrc;
>  	kvm_free_vcpus(kvm);
>  	sca_dispose(kvm);
> -	debug_unregister(kvm->arch.dbf);
>  	kvm_s390_gisa_destroy(kvm);
> +	/*
> +	 * We are already at the end of life and kvm->lock is not taken.
> +	 * This is ok as the file descriptor is closed by now and nobody
> +	 * can mess with the pv state. To avoid lockdep_assert_held from
> +	 * complaining we do not use kvm_s390_pv_is_protected.
> +	 */
> +	if (kvm_s390_pv_get_handle(kvm)) {

I'd prefer something like kvm_s390_pv_is_protected_unlocked(), but I
guess for these few use cases, this is fine.


> +		kvm_s390_pv_destroy_vm(kvm, &rc, &rrc);
> +		kvm_s390_pv_dealloc_vm(kvm);
> +	}
> +	debug_unregister(kvm->arch.dbf);
>  	free_page((unsigned long)kvm->arch.sie_page2);
>  	if (!kvm_is_ucontrol(kvm))
>  		gmap_remove(kvm->arch.gmap);
> @@ -2657,6 +2834,9 @@ static int sca_switch_to_extended(struct kvm *kvm=
)
>  	unsigned int vcpu_idx;
>  	u32 scaol, scaoh;
> =20
> +	if (kvm->arch.use_esca)
> +		return 0;
> +
>  	new_sca =3D alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO=
);
>  	if (!new_sca)
>  		return -ENOMEM;
> @@ -2908,6 +3088,7 @@ static void kvm_s390_vcpu_setup_model(struct kvm_=
vcpu *vcpu)
>  static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>  {
>  	int rc =3D 0;
> +	u16 uvrc, uvrrc;
> =20
>  	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH |
>  						    CPUSTAT_SM |
> @@ -2975,6 +3156,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *=
vcpu)
> =20
>  	kvm_s390_vcpu_crypto_setup(vcpu);
> =20
> +	mutex_lock(&vcpu->kvm->lock);
> +	if (kvm_s390_pv_is_protected(vcpu->kvm))
> +		rc =3D kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
> +	mutex_unlock(&vcpu->kvm->lock);

Do we have to cleanup anything? (e.g., cmma page) I *think*
kvm_arch_vcpu_destroy() is not called when kvm_arch_vcpu_create() fails .=
..

> +
>  	return rc;
>  }
> =20
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 83dabb18e4d9..d62de29b2d6c 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -15,6 +15,7 @@
>  #include <linux/hrtimer.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
> +#include <linux/lockdep.h>
>  #include <asm/facility.h>
>  #include <asm/processor.h>
>  #include <asm/sclp.h>
> @@ -207,6 +208,40 @@ static inline int kvm_s390_user_cpu_state_ctrl(str=
uct kvm *kvm)
>  	return kvm->arch.user_cpu_state_ctrl !=3D 0;
>  }
> =20
> +/* implemented in pv.c */
> +void kvm_s390_pv_dealloc_vm(struct kvm *kvm);
> +int kvm_s390_pv_alloc_vm(struct kvm *kvm);
> +int kvm_s390_pv_create_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
> +int kvm_s390_pv_destroy_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
> +void kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)=
;
> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, =
u16 *rc,
> +			      u16 *rrc);
> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned l=
ong size,
> +		       unsigned long tweak, u16 *rc, u16 *rrc);
> +
> +static inline u64 kvm_s390_pv_get_handle(struct kvm *kvm)
> +{
> +	return kvm->arch.pv.handle;
> +}
> +
> +static inline u64 kvm_s390_pv_cpu_get_handle(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.pv.handle;
> +}
> +
> +static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)

Could have been "kvm_s390_is_protected" or "kvm_s390_is_pv", but also
fine with me. (maybe I even suggested that one without caring about that
detail :) )

[...]

> +
>  /* implemented in interrupt.c */
>  int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
>  void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> new file mode 100644
> index 000000000000..67ea9a18ed8f
> --- /dev/null
> +++ b/arch/s390/kvm/pv.c
> @@ -0,0 +1,256 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hosting Secure Execution virtual machines
> + *
> + * Copyright IBM Corp. 2019
> + *    Author(s): Janosch Frank <frankja@linux.ibm.com>

I'd assume you're an author as well at this point ;)

[...]

> +
> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, =
u16 *rc,
> +			      u16 *rrc)
> +{
> +	struct uv_cb_ssc uvcb =3D {
> +		.header.cmd =3D UVC_CMD_SET_SEC_CONF_PARAMS,
> +		.header.len =3D sizeof(uvcb),
> +		.sec_header_origin =3D (u64)hdr,
> +		.sec_header_len =3D length,
> +		.guest_handle =3D kvm_s390_pv_get_handle(kvm),
> +	};
> +	int cc;
> +
> +	cc =3D uv_call(0, (u64)&uvcb);

int cc =3D ... could be done.


> +	*rc =3D uvcb.header.rc;
> +	*rrc =3D uvcb.header.rrc;
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
> +		     *rc, *rrc);
> +	if (cc)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2=
],
> +		      u16 *rc, u16 *rrc)
> +{
> +	struct uv_cb_unp uvcb =3D {
> +		.header.cmd =3D UVC_CMD_UNPACK_IMG,
> +		.header.len =3D sizeof(uvcb),
> +		.guest_handle =3D kvm_s390_pv_get_handle(kvm),
> +		.gaddr =3D addr,
> +		.tweak[0] =3D tweak[0],
> +		.tweak[1] =3D tweak[1],
> +	};
> +	int ret;
> +
> +	ret =3D gmap_make_secure(kvm->arch.gmap, addr, &uvcb);

... similarly, with ret.

> +	*rc =3D uvcb.header.rc;
> +	*rrc =3D uvcb.header.rrc;
> +
> +	if (ret && ret !=3D -EAGAIN)
> +		KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx with rc %=
x rrc %x",
> +			     uvcb.gaddr, *rc, *rrc);
> +	return ret;
> +}
> +
> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned l=
ong size,
> +		       unsigned long tweak, u16 *rc, u16 *rrc)
> +{
> +	u64 tw[2] =3D {tweak, 0};

I have no idea what tweaks are in this context. So I have to trust you
guys on the implementation, because I don't understand it.

Especially, why can't we simply have

s/tweak/tweak/

offset =3D 0;

while (offset < size) {
	...
	ret =3D unpack_one(kvm, addr, tweak, offset, rc, rrc);
				    ^ no idea what tweak is
	...
	... offset +=3D  PAGE_SIZE;
}

But maybe I am missing what the whole array is about.

> +	int ret =3D 0;
> +
> +	if (addr & ~PAGE_MASK || !size || size & ~PAGE_MASK)
> +		return -EINVAL;
> +
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
> +		     addr, size);
> +
> +	while (tw[1] < size) {> +		ret =3D unpack_one(kvm, addr, tw, rc, rrc)=
;
> +		if (ret =3D=3D -EAGAIN) {
> +			cond_resched();
> +			if (fatal_signal_pending(current))
> +				break;
> +			continue;
> +		}
> +		if (ret)
> +			break;
> +		addr +=3D PAGE_SIZE;
> +		tw[1] +=3D PAGE_SIZE;
> +	}
> +	if (!ret)
> +		KVM_UV_EVENT(kvm, 3, "%s", "PROTVIRT VM UNPACK: successful");
> +	return ret;
> +}

[...]
> +enum pv_cmd_id {
> +	KVM_PV_ENABLE,
> +	KVM_PV_DISABLE,
> +	KVM_PV_VM_SET_SEC_PARMS,
> +	KVM_PV_VM_UNPACK,
> +	KVM_PV_VM_VERIFY,

I wonder if we should just drop "_VM" from all of these ...

[...]


--=20
Thanks,

David / dhildenb

