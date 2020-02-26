Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958E516F995
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 09:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBZI2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 03:28:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52181 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727252AbgBZI2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 03:28:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582705689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=CoihTrugfLbsUdeaWgYvqiGrGviETHhR7vlMDMkeTuc=;
        b=CO81jjFXrj9evuL4JwROlIXmWM7wl+ER3FWA9rlg5IcWcoj7HzWhJb4+c53VMEXVQLBv36
        UaR18Ju568ClWy7SaSkhdLYImVcXO4toFwRQdK7GxH6Dahj640llXwt5uZc6jm52rOMJZN
        qQFRJt0MAimN9Fu0hArqx5Pk0gkrMiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-tfVezRmBOkuqGt3LHT5tAw-1; Wed, 26 Feb 2020 03:28:05 -0500
X-MC-Unique: tfVezRmBOkuqGt3LHT5tAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA9AE802560;
        Wed, 26 Feb 2020 08:28:03 +0000 (UTC)
Received: from [10.36.117.196] (ovpn-117-196.ams2.redhat.com [10.36.117.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EF0B1001DD8;
        Wed, 26 Feb 2020 08:28:01 +0000 (UTC)
Subject: Re: [PATCH v4.5 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ulrich.Weigand@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, frankja@linux.vnet.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
References: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
 <20200225214822.3611-1-borntraeger@de.ibm.com>
 <a8bf1afc-8afe-a704-32f6-b20ed2f3a54c@redhat.com>
 <8ac08255-f830-934d-1e91-d26b2cbe99f5@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <d77bba47-3292-4def-59d6-5d1c19fc5171@redhat.com>
Date:   Wed, 26 Feb 2020 09:28:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <8ac08255-f830-934d-1e91-d26b2cbe99f5@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.02.20 09:12, Christian Borntraeger wrote:
>=20
>=20
> On 25.02.20 23:37, David Hildenbrand wrote:
>>
>>> +static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>>> +{
>>> +	unsigned long base =3D uv_info.guest_base_stor_len;
>>> +	unsigned long virt =3D uv_info.guest_virt_var_stor_len;
>>> +	unsigned long npages =3D 0, vlen =3D 0;
>>> +	struct kvm_memory_slot *memslot;
>>> +
>>> +	kvm->arch.pv.stor_var =3D NULL;
>>> +	kvm->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL, get_order(b=
ase));
>>> +	if (!kvm->arch.pv.stor_base)
>>> +		return -ENOMEM;
>>> +
>>> +	/*
>>> +	 * Calculate current guest storage for allocation of the
>>> +	 * variable storage, which is based on the length in MB.
>>> +	 *
>>> +	 * Slots are sorted by GFN
>>> +	 */
>>> +	mutex_lock(&kvm->slots_lock);
>>> +	memslot =3D kvm_memslots(kvm)->memslots;
>>> +	npages =3D memslot->base_gfn + memslot->npages;
>>> +	mutex_unlock(&kvm->slots_lock);
>>
>> As discussed, I think we should just use mem_limit and check against
>> some hardcoded upper limit. But yeah, we can do that as an addon (in
>> which case memory hotplug will require special tweaks to detect this
>> from user space ... e.g., a new capability)
>>
>>
>> [...]
>>
>>> +int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>>> +{
>>> +		struct uv_cb_cgc uvcb =3D {
>>> +		.header.cmd =3D UVC_CMD_CREATE_SEC_CONF,
>>> +		.header.len =3D sizeof(uvcb)
>>> +	};
>>> +	int cc, ret;
>>> +	u16 dummy;
>>> +
>>> +	ret =3D kvm_s390_pv_alloc_vm(kvm);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	/* Inputs */
>>> +	uvcb.guest_stor_origin =3D 0; /* MSO is 0 for KVM */
>>> +	uvcb.guest_stor_len =3D kvm->arch.pv.guest_len;
>>> +	uvcb.guest_asce =3D kvm->arch.gmap->asce;
>>> +	uvcb.guest_sca =3D (unsigned long)kvm->arch.sca;
>>> +	uvcb.conf_base_stor_origin =3D (u64)kvm->arch.pv.stor_base;
>>> +	uvcb.conf_virt_stor_origin =3D (u64)kvm->arch.pv.stor_var;
>>> +
>>> +	cc =3D uv_call(0, (u64)&uvcb);
>>> +	*rc =3D uvcb.header.rc;
>>> +	*rrc =3D uvcb.header.rrc;
>>> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %=
x rrc %x",
>>> +		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
>>> +
>>> +	/* Outputs */
>>> +	kvm->arch.pv.handle =3D uvcb.guest_handle;
>>> +
>>> +	if (cc) {
>>> +		if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
>>> +			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
>>> +		else
>>> +			kvm_s390_pv_dealloc_vm(kvm);
>>> +		return -EIO;
>>
>> A lot easier to read :)
>>
>>
>> Fell free add my rb with or without the mem_limit change.
>=20
> I think I will keep the memslot logic. For hotplug we actually need
> to notify the ultravisor that the guest size has changed as only the
> ultravisor will be able to inject an addressing exception.

So holes in between memory slots won't be properly considered? What will
happen if a guest accesses such memory right now?

>=20
> Lets keep it simple for now=20
>=20

I double checked (virt/kvm/kvm_main.c:update_memslots()), and the slots
are definitely sorted "based on their GFN". I think, it's lowest GFN
first, so the code in here would be wrong with more than one slot.

Can you double check, because I might misinterpret the code.


--=20
Thanks,

David / dhildenb

