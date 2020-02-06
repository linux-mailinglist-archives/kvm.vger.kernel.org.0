Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAEBF154106
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 10:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgBFJSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 04:18:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21825 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728088AbgBFJSb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 04:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580980710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=EVyxFfqAwwY7FOhviNWI9kBPJm2qlrclbAWOXivGxjI=;
        b=fNHUbBLZnBnZReYd1+GJJPxUKcWOHwNWFtQb/evkDrRQItixxljErjfhbpXAqeKLJVRrgx
        iNWXoirzBN3sOeqVvR/DVkgsUDJ52ghfqUBiS5ew2LKSl2H7oKpN36xRbfqOI6DD7UBbm/
        u/y4RNT4Pr196/i1aJ+V8U80LiuSHkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-fmV2iQJgMWaDhm0htRvCog-1; Thu, 06 Feb 2020 04:18:26 -0500
X-MC-Unique: fmV2iQJgMWaDhm0htRvCog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B3EF14E2;
        Thu,  6 Feb 2020 09:18:25 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-151.ams2.redhat.com [10.36.116.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B441E5DA75;
        Thu,  6 Feb 2020 09:18:20 +0000 (UTC)
Subject: Re: [RFCv2 21/37] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-22-borntraeger@de.ibm.com>
 <55220810-3e2f-6312-4199-2afb583d9ff2@redhat.com>
 <47593ba3-43c0-c7d3-2f4f-e649e21cb29a@linux.ibm.com>
 <7539e1d3-79c6-3581-b3fb-afa545bb81d2@redhat.com>
 <456828bf-fb85-66ca-6887-9e505690ee6a@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3899a905-d5bc-40ca-321a-7e629d056996@redhat.com>
Date:   Thu, 6 Feb 2020 10:18:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <456828bf-fb85-66ca-6887-9e505690ee6a@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/2020 10.07, Christian Borntraeger wrote:
> On 05.02.20 18:00, Thomas Huth wrote:
>=20
>>>>
>>>> Uh, why the mix of a new ioctl with the existing mem_op stuff? Could=
 you
>>>> please either properly integrate this into the MEM_OP ioctl (and e.g=
.
>>>> use gaddr as offset for the new SIDA_READ and SIDA_WRITE subcodes), =
or
>>>> completely separate it for a new ioctl, i.e. introduce a new struct =
for
>>>> the new ioctl instead of recycling the struct kvm_s390_mem_op here?
>>>> (and in case you ask me, I'd slightly prefer to integrate everything
>>>> into MEM_OP instead of introducing a new ioctl here).
>>>
>>> *cough* David and Christian didn't like the memop solution and it too=
k
>>> me a long time to get this to work properly in QEMU...
>>
>> I also don't like to re-use MEMOP_LOGICAL_READ and MEMOP_LOGICAL_WRITE
>> for the SIDA like you've had it in RFC v1 ... but what's wrong with
>> using KVM_S390_MEMOP_SIDA_READ and KVM_S390_MEMOP_SIDA_WRITE with the
>> MEM_OP ioctl directly?
>>
>>  Thomas
>>
>=20
> In essence something like the following?
>=20
> @@ -4583,6 +4618,9 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu=
 *vcpu,
>                 }
>                 r =3D write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mo=
p->size);
>                 break;
> +       case KVM_S390_MEMOP_SIDA_READ:
> +       case KVM_S390_MEMOP_SIDA_WRITE:
> +               kvm_s390_guest_sida_op(vcpu, mop);
>         default:
>                 r =3D -EINVAL;
>         }
>=20
>=20
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ea2b4d66e0c3..6e029753c955 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1519,7 +1519,6 @@ struct kvm_pv_cmd {
>  /* Available with KVM_CAP_S390_PROTECTED */
>  #define KVM_S390_PV_COMMAND            _IOW(KVMIO, 0xc5, struct kvm_pv=
_cmd)
>  #define KVM_S390_PV_COMMAND_VCPU       _IOW(KVMIO, 0xc6, struct kvm_pv=
_cmd)
> -#define KVM_S390_SIDA_OP               _IOW(KVMIO, 0xc7, struct kvm_s3=
90_mem_op)
> =20
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {

Right!

But maybe you should also fence the other subcodes in case of PV:

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d9e6bf3d54f0..f99e7d7af6ea 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4274,6 +4274,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu
*vcpu,

        switch (mop->op) {
        case KVM_S390_MEMOP_LOGICAL_READ:
+               if (kvm_s390_pv_is_protected(vcpu->kvm))
+                       r =3D -EINVAL;
+                       break;
+               }
                if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
                        r =3D check_gva_range(vcpu, mop->gaddr, mop->ar,
                                            mop->size, GACC_FETCH);
@@ -4286,6 +4290,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu
*vcpu,
                }
                break;
        case KVM_S390_MEMOP_LOGICAL_WRITE:
+               if (kvm_s390_pv_is_protected(vcpu->kvm))
+                       r =3D -EINVAL;
+                       break;
+               }
                if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
                        r =3D check_gva_range(vcpu, mop->gaddr, mop->ar,
                                            mop->size, GACC_STORE);

... not sure whether it's maybe easier in the end to move everything to
a new ioctl with a new struct instead ... whatever you prefer.

But I guess there should be a check like the above in
kvm_s390_guest_mem_op() anyway to avoid that userspace can write to
protected pages with this MEM_OP ioctl.

 Thomas

