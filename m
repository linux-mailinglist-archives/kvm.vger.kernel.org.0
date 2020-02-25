Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1916BBAC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgBYISL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:18:11 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22244 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729360AbgBYISL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 03:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582618689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qLZKCPGahKgdWnmoci4Iy2YJ811YiahFIzrFsDIzji8=;
        b=bfaZBAuNnYhYjq40NJKRbWbpfYYLR3jWCB3WqPEem3CnahsIOXwUoo4EOfMc5juzlgidqp
        /JfSzgTdSb/rxFLS91VAlV7pVYeCHNaUcTqusGTpgXol03vSYcme6Syrfg3D/gEAUUbuCy
        fNjU3o60u0kIAEQ16D+66PxytMMj7Wk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-KwzumSKvPKWl6os7RVas4Q-1; Tue, 25 Feb 2020 03:18:05 -0500
X-MC-Unique: KwzumSKvPKWl6os7RVas4Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C9E413F7;
        Tue, 25 Feb 2020 08:18:04 +0000 (UTC)
Received: from [10.36.117.12] (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF41D8B755;
        Tue, 25 Feb 2020 08:18:01 +0000 (UTC)
Subject: Re: [PATCH v4 18/36] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
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
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
 <20200224114107.4646-19-borntraeger@de.ibm.com>
 <3db82b2d-ad79-8178-e027-c19889d96558@redhat.com>
 <f8d7321e-400e-ed82-471e-166a2d18ede6@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <74359acb-6694-8cae-e2ae-9eda54fa12a4@redhat.com>
Date:   Tue, 25 Feb 2020 09:18:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f8d7321e-400e-ed82-471e-166a2d18ede6@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.02.20 08:50, Christian Borntraeger wrote:
>=20
>=20
> On 24.02.20 20:13, David Hildenbrand wrote:
>> On 24.02.20 12:40, Christian Borntraeger wrote:
>>> From: Janosch Frank <frankja@linux.ibm.com>
>>>
>>> Now that we can't access guest memory anymore, we have a dedicated
>>> satellite block that's a bounce buffer for instruction data.
>>>
>>> We re-use the memop interface to copy the instruction data to / from
>>> userspace. This lets us re-use a lot of QEMU code which used that
>>> interface to make logical guest memory accesses which are not possibl=
e
>>> anymore in protected mode anyway.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>
>> [...]
>>
>>> +
>>>  long kvm_arch_vcpu_async_ioctl(struct file *filp,
>>>  			       unsigned int ioctl, unsigned long arg)
>>>  {
>>> @@ -4683,7 +4732,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>  		struct kvm_s390_mem_op mem_op;
>>> =20
>>>  		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) =3D=3D 0)
>>> -			r =3D kvm_s390_guest_mem_op(vcpu, &mem_op);
>>> +			r =3D kvm_s390_guest_memsida_op(vcpu, &mem_op);
>>>  		else
>>>  			r =3D -EFAULT;
>>>  		break;
>>> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
>>> index 014e53a41ead..cd81a58349a9 100644
>>> --- a/arch/s390/kvm/pv.c
>>> +++ b/arch/s390/kvm/pv.c
>>> @@ -33,10 +33,13 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu=
, u16 *rc, u16 *rrc)
>>>  	if (!cc)
>>>  		free_pages(vcpu->arch.pv.stor_base,
>>>  			   get_order(uv_info.guest_cpu_stor_len));
>>> +
>>> +	free_page(sida_origin(vcpu->arch.sie_block));
>>>  	vcpu->arch.sie_block->pv_handle_cpu =3D 0;
>>>  	vcpu->arch.sie_block->pv_handle_config =3D 0;
>>>  	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
>>>  	vcpu->arch.sie_block->sdf =3D 0;
>>> +	vcpu->arch.sie_block->gbea =3D 1;
>>
>> I am very confused why gbea is set to 1 when destroying the CPU. It's
>> otherwise never set (always 0). What's the meaning of this?
>=20
> This is the guest breaking event address. So a guest (and QEMU) can rea=
d it.
> It is kind of overlaid sida and gbea. Something like this:
>=20
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index cd81a58349a9..055bf0ec8fbb 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -39,6 +39,11 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u=
16 *rc, u16 *rrc)
>         vcpu->arch.sie_block->pv_handle_config =3D 0;
>         memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
>         vcpu->arch.sie_block->sdf =3D 0;
> +       /*
> +        * the sidad field (for sdf =3D=3D 2) is now the gbea field (fo=
r sdf =3D=3D 0).
> +        * Use the reset value of gbea to not leak the kernel pointer o=
f the
> +        * just free sida

"freed sida."

I guess I would have set the sidad to NULL in addition before the
"vcpu->arch.sie_block->sdf =3D 0", so access to the sidad becomes actuall=
y
grep-able.


Reviewed-by: David Hildenbrand <david@redhat.com>

--=20
Thanks,

David / dhildenb

