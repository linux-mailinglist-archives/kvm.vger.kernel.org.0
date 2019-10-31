Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E2EEB3F7
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 16:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfJaPbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 11:31:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48221 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727605AbfJaPbi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 31 Oct 2019 11:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572535896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ifJDtK4cLTh9VAr7vgvBg6Wz3A4m4CctUdyzfx0xhpE=;
        b=Gyb/M4xcZS9NRTTD0XI/w7vgLc9cyaWCdbe0SqUKO0wbJZFbEJle+5SMfo86Q7p9aH0CQ0
        CeCy6bLQO/9wFjyCH2d+N9j6GaGKZj6xkg6bfvv6xoWOBKPNSoXBtXNoqnAujebU0dwXlb
        8L3zzWKsUThQzADLvCZvWdKCFakzk48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-W39DKvS5Py2yjnGiyYUzvw-1; Thu, 31 Oct 2019 11:31:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4CC8107ACC0;
        Thu, 31 Oct 2019 15:31:29 +0000 (UTC)
Received: from [10.36.118.44] (unknown [10.36.118.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E87C5DA32;
        Thu, 31 Oct 2019 15:31:28 +0000 (UTC)
Subject: Re: [PATCH 1/1] KVM: s390: Add memcg accounting to KVM allocations
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
References: <20191031151921.31871-1-borntraeger@de.ibm.com>
 <20191031151921.31871-2-borntraeger@de.ibm.com>
 <5b5dcd65-34e2-663d-a462-f381a62a0428@redhat.com>
 <90ff4d78-fdc5-6002-9f2b-44331d8e70fe@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <aa179151-3721-4ca4-a6fe-2b81155ad67d@redhat.com>
Date:   Thu, 31 Oct 2019 16:31:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <90ff4d78-fdc5-6002-9f2b-44331d8e70fe@de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: W39DKvS5Py2yjnGiyYUzvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.10.19 16:27, Christian Borntraeger wrote:
>=20
>=20
> On 31.10.19 16:22, David Hildenbrand wrote:
>> On 31.10.19 16:19, Christian Borntraeger wrote:
>>> While I propared my KVM Forum talk about whats new in KVM including
>>> memcg, I realized that the s390 code does not take care of memcg.
>>>
>>> As far as I can tell, almost all kvm allocations in the s390x KVM code
>>> can be attributed to process that triggers the allocation (in other
>>> words, no global allocation for other guests). This will help the memcg
>>> controller to do the right decisions.
>>>
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> ---
>>>  =C2=A0 arch/s390/kvm/guestdbg.c=C2=A0 |=C2=A0 8 ++++----
>>>  =C2=A0 arch/s390/kvm/intercept.c |=C2=A0 2 +-
>>>  =C2=A0 arch/s390/kvm/interrupt.c | 12 ++++++------
>>>  =C2=A0 arch/s390/kvm/kvm-s390.c=C2=A0 | 22 +++++++++++-----------
>>>  =C2=A0 arch/s390/kvm/priv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++=
--
>>>  =C2=A0 arch/s390/kvm/vsie.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++=
--
>>>  =C2=A0 6 files changed, 26 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
>>> index 394a5f53805b..3765c4223bf9 100644
>>> --- a/arch/s390/kvm/guestdbg.c
>>> +++ b/arch/s390/kvm/guestdbg.c
>>> @@ -184,7 +184,7 @@ static int __import_wp_info(struct kvm_vcpu *vcpu,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (wp_info->len < 0 || wp_info->len > =
MAX_WP_SIZE)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 wp_info->old_data =3D kmalloc(bp_data->len,=
 GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 wp_info->old_data =3D kmalloc(bp_data->len, GFP_KER=
NEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!wp_info->old_data)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* try to backup the original value */
>>> @@ -234,7 +234,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (nr_wp > 0) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wp_info =3D kma=
lloc_array(nr_wp,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(*wp_info),
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!wp_info) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ret =3D -ENOMEM;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 goto error;
>>> @@ -243,7 +243,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (nr_bp > 0) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bp_info =3D kma=
lloc_array(nr_bp,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(*bp_info),
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!bp_info) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ret =3D -ENOMEM;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 goto error;
>>> @@ -349,7 +349,7 @@ static struct kvm_hw_wp_info_arch *any_wp_changed(s=
truct kvm_vcpu *vcpu)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!wp_info ||=
 !wp_info->old_data || wp_info->len <=3D 0)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 continue;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 temp =3D kmalloc(wp=
_info->len, GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 temp =3D kmalloc(wp_info->l=
en, GFP_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!temp)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 continue;
>>>  =C2=A0 diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercep=
t.c
>>> index a389fa85cca2..fb2daae88105 100644
>>> --- a/arch/s390/kvm/intercept.c
>>> +++ b/arch/s390/kvm/intercept.c
>>> @@ -387,7 +387,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (addr & ~PAGE_MASK)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return kvm_s390=
_inject_program_int(vcpu, PGM_SPECIFICATION);
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 sctns =3D (void *)get_zeroed_page(GFP_KERNE=
L);
>>> +=C2=A0=C2=A0=C2=A0 sctns =3D (void *)get_zeroed_page(GFP_KERNEL_ACCOUN=
T);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!sctns)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0 diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrup=
t.c
>>> index 165dea4c7f19..7fe8896a82dd 100644
>>> --- a/arch/s390/kvm/interrupt.c
>>> +++ b/arch/s390/kvm/interrupt.c
>>> @@ -1668,7 +1668,7 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_i=
nt(struct kvm *kvm,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>  =C2=A0 gisa_out:
>>> -=C2=A0=C2=A0=C2=A0 tmp_inti =3D kzalloc(sizeof(*inti), GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 tmp_inti =3D kzalloc(sizeof(*inti), GFP_KERNEL_ACCO=
UNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (tmp_inti) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tmp_inti->type =
=3D KVM_S390_INT_IO(1, 0, 0, 0);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tmp_inti->io.io=
_int_word =3D isc_to_int_word(isc);
>>> @@ -1881,7 +1881,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_s390_interrupt_info *inti;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 inti =3D kzalloc(sizeof(*inti), GFP_KERNEL)=
;
>>> +=C2=A0=C2=A0=C2=A0 inti =3D kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT)=
;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!inti)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0 @@ -2275,7 +2275,7 @@ static int enqueue_floating_irq(struct kv=
m_device *dev,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (len >=3D sizeof(struct kv=
m_s390_irq)) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inti =3D kzalloc(sizeof(*in=
ti), GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inti =3D kzalloc(sizeof(*in=
ti), GFP_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!inti)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0 @@ -2323,7 +2323,7 @@ static int register_io_adapter(struct kvm=
_device *dev,
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dev->kvm->arch.adapters[adapter_inf=
o.id] !=3D NULL)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 adapter =3D kzalloc(sizeof(*adapter), GFP_K=
ERNEL);
>>> +=C2=A0=C2=A0=C2=A0 adapter =3D kzalloc(sizeof(*adapter), GFP_KERNEL_AC=
COUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!adapter)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0 @@ -2363,7 +2363,7 @@ static int kvm_s390_adapter_map(struct kv=
m *kvm, unsigned int id, __u64 addr)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!adapter || !addr)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 map =3D kzalloc(sizeof(*map), GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 map =3D kzalloc(sizeof(*map), GFP_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!map) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM=
;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> @@ -3223,7 +3223,7 @@ int kvm_s390_gib_init(u8 nisc)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 gib =3D (struct kvm_s390_gib *)get_zeroed_p=
age(GFP_KERNEL | GFP_DMA);
>>> +=C2=A0=C2=A0=C2=A0 gib =3D (struct kvm_s390_gib *)get_zeroed_page(GFP_=
KERNEL_ACCOUNT | GFP_DMA);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!gib) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D -ENOMEM;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index d9e6bf3d54f0..373e182fd8e8 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -1243,7 +1243,7 @@ static int kvm_s390_set_processor(struct kvm *kvm=
, struct kvm_device_attr *attr)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EBUSY;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 proc =3D kzalloc(sizeof(*proc), GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 proc =3D kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT)=
;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!proc) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM=
;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> @@ -1405,7 +1405,7 @@ static int kvm_s390_get_processor(struct kvm *kvm=
, struct kvm_device_attr *attr)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_s390_vm_cpu_processor *proc;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 proc =3D kzalloc(sizeof(*proc), GFP_KERNEL)=
;
>>> +=C2=A0=C2=A0=C2=A0 proc =3D kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT)=
;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!proc) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM=
;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> @@ -1433,7 +1433,7 @@ static int kvm_s390_get_machine(struct kvm *kvm, =
struct kvm_device_attr *attr)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_s390_vm_cpu_machine *mach;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 mach =3D kzalloc(sizeof(*mach), GFP_KERNEL)=
;
>>> +=C2=A0=C2=A0=C2=A0 mach =3D kzalloc(sizeof(*mach), GFP_KERNEL_ACCOUNT)=
;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!mach) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM=
;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> @@ -1801,7 +1801,7 @@ static long kvm_s390_get_skeys(struct kvm *kvm, s=
truct kvm_s390_skeys *args)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (args->count < 1 || args->count > KV=
M_S390_SKEYS_MAX)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 keys =3D kvmalloc_array(args->count, sizeof=
(uint8_t), GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 keys =3D kvmalloc_array(args->count, sizeof(uint8_t=
), GFP_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!keys)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0 @@ -1846,7 +1846,7 @@ static long kvm_s390_set_skeys(struct kvm=
 *kvm, struct kvm_s390_skeys *args)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (args->count < 1 || args->count > KV=
M_S390_SKEYS_MAX)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 keys =3D kvmalloc_array(args->count, sizeof=
(uint8_t), GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 keys =3D kvmalloc_array(args->count, sizeof(uint8_t=
), GFP_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!keys)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0 @@ -2393,7 +2393,7 @@ static void sca_dispose(struct kvm *kvm)
>>>  =C2=A0 =C2=A0 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type=
)
>>>  =C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 gfp_t alloc_flags =3D GFP_KERNEL;
>>> +=C2=A0=C2=A0=C2=A0 gfp_t alloc_flags =3D GFP_KERNEL_ACCOUNT;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i, rc;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char debug_name[16];
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 static unsigned long sca_offset;
>>> @@ -2438,7 +2438,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUILD_BUG_ON(sizeof(struct sie_p=
age2) !=3D 4096);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm->arch.sie_page2 =3D
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (struct sie_page2 *) =
get_zeroed_page(GFP_KERNEL | GFP_DMA);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (struct sie_page2 *) =
get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!kvm->arch.sie_page2)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_err;
>>>  =C2=A0 @@ -2652,7 +2652,7 @@ static int sca_switch_to_extended(struct =
kvm *kvm)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int vcpu_idx;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 scaol, scaoh;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 new_sca =3D alloc_pages_exact(sizeof(*new_s=
ca), GFP_KERNEL|__GFP_ZERO);
>>> +=C2=A0=C2=A0=C2=A0 new_sca =3D alloc_pages_exact(sizeof(*new_sca), GFP=
_KERNEL_ACCOUNT | __GFP_ZERO);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!new_sca)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0 @@ -2947,7 +2947,7 @@ void kvm_s390_vcpu_unsetup_cmma(struct kv=
m_vcpu *vcpu)
>>>  =C2=A0 =C2=A0 int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
>>>  =C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 vcpu->arch.sie_block->cbrlo =3D get_zeroed_page(GFP=
_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 vcpu->arch.sie_block->cbrlo =3D get_zeroed_page(GFP=
_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!vcpu->arch.sie_block->cbrlo)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> @@ -3047,12 +3047,12 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kv=
m *kvm,
>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D -ENOMEM;
>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 vcpu =3D kmem_cache_zalloc(kvm_vcpu_cache, =
GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 vcpu =3D kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERN=
EL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!vcpu)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUILD_BUG_ON(sizeof(struct sie_p=
age) !=3D 4096);
>>> -=C2=A0=C2=A0=C2=A0 sie_page =3D (struct sie_page *) get_zeroed_page(GF=
P_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 sie_page =3D (struct sie_page *) get_zeroed_page(GF=
P_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!sie_page)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_free_c=
pu;
>>>  =C2=A0 diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index ed52ffa8d5d4..536fcd599665 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -878,7 +878,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (fc) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 1: /* same handling for 1 and 2 */
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 2:
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mem =3D get_zeroed_page(GFP=
_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mem =3D get_zeroed_page(GFP=
_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!mem)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 goto out_no_data;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (stsi((void =
*) mem, fc, sel1, sel2))
>>> @@ -887,7 +887,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 3:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sel1 !=3D 2=
 || sel2 !=3D 2)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 goto out_no_data;
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mem =3D get_zeroed_page(GFP=
_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mem =3D get_zeroed_page(GFP=
_KERNEL_ACCOUNT);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!mem)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 goto out_no_data;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 handle_stsi_3_2=
_2(vcpu, (void *) mem);
>>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>>> index 076090f9e666..f55fca8f94f8 100644
>>> --- a/arch/s390/kvm/vsie.c
>>> +++ b/arch/s390/kvm/vsie.c
>>> @@ -1236,7 +1236,7 @@ static struct vsie_page *get_vsie_page(struct kvm=
 *kvm, unsigned long addr)
>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&kvm->arch.vsie.mutex=
);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm->arch.vsie.page_count < nr_vcpu=
s) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page =3D alloc_page(GFP_KER=
NEL | __GFP_ZERO | GFP_DMA);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page =3D alloc_page(GFP_KER=
NEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!page) {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 mutex_unlock(&kvm->arch.vsie.mutex);
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 return ERR_PTR(-ENOMEM);
>>> @@ -1338,7 +1338,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
>>>  =C2=A0 void kvm_s390_vsie_init(struct kvm *kvm)
>>>  =C2=A0 {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_init(&kvm->arch.vsie.mutex);
>>> -=C2=A0=C2=A0=C2=A0 INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_K=
ERNEL);
>>> +=C2=A0=C2=A0=C2=A0 INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_K=
ERNEL_ACCOUNT);
>>>  =C2=A0 }
>>>  =C2=A0 =C2=A0 /* Destroy the vsie data structures. To be called when a=
 vm is destroyed. */
>>>
>>
>> I was wondering about the gmap, especially also page tables for nested g=
uests. Did you consider that already?
>=20
> No not yet. gmap would be an extra patch. I then also have to be careful =
if there  are
> some data structures that are shared between different guests. I think no=
t, but I have
> not yet looked completely through that code.

Everything that is shared should apply to the user page tables only. But=20
all datastructures we allocate in the gmap (especially tables, radix=20
tress ...) should be for this very process only. At least that's what I=20
hope :D

Agreed that this should go to a separate patch.

--=20

Thanks,

David / dhildenb

