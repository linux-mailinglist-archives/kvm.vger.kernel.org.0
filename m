Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D2CEDDAA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfKDLZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 06:25:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24665 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726526AbfKDLZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 06:25:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572866751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u8ORXVaygiG7yZ+UA4fbgu2ZwJRWaM7SoO6rj/g5bUM=;
        b=MYgA8Wx9PxXvr1BF9HmL8Ux3AmVbBJatUvpkv4e+Zst3hGdHy3rkK486c6Kfsqxf3FIiR/
        pNQQjkIqJHYmISu+Vpgmc3vWlqnfSl+bA1aI+b8HVJIFnPqITfx7d3Jut54VX3CSe6Iozv
        M7x5i3cn0lcSCh3lrYfWv8Wumex/pTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-kKmctXOMPS6zSrtGx6V8jQ-1; Mon, 04 Nov 2019 06:25:48 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F0221005500;
        Mon,  4 Nov 2019 11:25:46 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFDBA600C4;
        Mon,  4 Nov 2019 11:25:44 +0000 (UTC)
Subject: Re: [RFC 19/37] KVM: s390: protvirt: Add new gprs location handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-20-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <2eba24a5-063d-1e93-acf0-1153963facfe@redhat.com>
Date:   Mon, 4 Nov 2019 12:25:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-20-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: kKmctXOMPS6zSrtGx6V8jQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> Guest registers for protected guests are stored at offset 0x380.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  4 +++-
>   arch/s390/kvm/kvm-s390.c         | 11 +++++++++++
>   2 files changed, 14 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 0ab309b7bf4c..5deabf9734d9 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -336,7 +336,9 @@ struct kvm_s390_itdb {
>   struct sie_page {
>   =09struct kvm_s390_sie_block sie_block;
>   =09struct mcck_volatile_info mcck_info;=09/* 0x0200 */
> -=09__u8 reserved218[1000];=09=09/* 0x0218 */
> +=09__u8 reserved218[360];=09=09/* 0x0218 */
> +=09__u64 pv_grregs[16];=09=09/* 0x380 */
> +=09__u8 reserved400[512];
>   =09struct kvm_s390_itdb itdb;=09/* 0x0600 */
>   =09__u8 reserved700[2304];=09=09/* 0x0700 */
>   };
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 490fde080107..97d3a81e5074 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3965,6 +3965,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int=
 exit_reason)
>   static int __vcpu_run(struct kvm_vcpu *vcpu)
>   {
>   =09int rc, exit_reason;
> +=09struct sie_page *sie_page =3D (struct sie_page *)vcpu->arch.sie_block=
;
>  =20
>   =09/*
>   =09 * We try to hold kvm->srcu during most of vcpu_run (except when run=
-
> @@ -3986,8 +3987,18 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>   =09=09guest_enter_irqoff();
>   =09=09__disable_cpu_timer_accounting(vcpu);
>   =09=09local_irq_enable();
> +=09=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09=09memcpy(sie_page->pv_grregs,
> +=09=09=09       vcpu->run->s.regs.gprs,
> +=09=09=09       sizeof(sie_page->pv_grregs));
> +=09=09}
>   =09=09exit_reason =3D sie64a(vcpu->arch.sie_block,
>   =09=09=09=09     vcpu->run->s.regs.gprs);
> +=09=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09=09memcpy(vcpu->run->s.regs.gprs,
> +=09=09=09       sie_page->pv_grregs,
> +=09=09=09       sizeof(sie_page->pv_grregs));
> +=09=09}

sie64a will load/save gprs 0-13 from to vcpu->run->s.regs.gprs.

I would have assume that this is not required for prot virt, because the=20
HW has direct access via the sie block?


1. Would it make sense to have a specialized sie64a() (or a parameter,=20
e.g., if you pass in NULL in r3), that optimizes this loading/saving?=20
Eventually we can also optimize which host registers to save/restore then.

2. Avoid this copying here. We have to store the state to=20
vcpu->run->s.regs.gprs when returning to user space and restore the=20
state when coming from user space.

Also, we access the GPRS from interception handlers, there we might use=20
wrappers like

kvm_s390_set_gprs()
kvm_s390_get_gprs()

to route to the right location. There are multiple options to optimize this=
.

--=20

Thanks,

David / dhildenb

