Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89E1E9FA6
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 16:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfJ3Put (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 11:50:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52172 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727624AbfJ3Pus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 11:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572450648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9S6/4tSu/lCAjI7kwvb6uvrrsEY/A8TSedOLT0uS31M=;
        b=K2g8ujlaGC7YjqLd46U1kNjQHK2/LoViPF35OnD8Ir7r5CZiPxvbH47CJ5ChyuFn6gcA4F
        FIcUcYBewFFwEB5R4yqB0PErZmvov4iz3k80r9rbpIP36PUbQ5ycarVe2xZIaU+RXQ5WpJ
        rvqHcNIqEl+fK8EKX5TdJAt/G8gAAv0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-tPq6ZYrHPee7w3P6rtA6zw-1; Wed, 30 Oct 2019 11:50:44 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 777B61800D55;
        Wed, 30 Oct 2019 15:50:43 +0000 (UTC)
Received: from [10.36.116.178] (ovpn-116-178.ams2.redhat.com [10.36.116.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D9165C1C3;
        Wed, 30 Oct 2019 15:50:41 +0000 (UTC)
Subject: Re: [RFC 12/37] KVM: s390: protvirt: Handle SE notification
 interceptions
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-13-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <a3d3923a-4047-9d6e-8caf-a07c294e8c7a@redhat.com>
Date:   Wed, 30 Oct 2019 16:50:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-13-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: tPq6ZYrHPee7w3P6rtA6zw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> Since KVM doesn't emulate any form of load control and load psw
> instructions anymore, we wouldn't get an interception if PSWs or CRs
> are changed in the guest. That means we can't inject IRQs right after
> the guest is enabled for them.
>=20
> The new interception codes solve that problem by being a notification
> for changes to IRQ enablement relevant bits in CRs 0, 6 and 14, as
> well a the machine check mask bit in the PSW.
>=20
> No special handling is needed for these interception codes, the KVM
> pre-run code will consult all necessary CRs and PSW bits and inject
> IRQs the guest is enabled for.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  2 ++
>   arch/s390/kvm/intercept.c        | 18 ++++++++++++++++++
>   2 files changed, 20 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index d4fd0f3af676..6cc3b73ca904 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -210,6 +210,8 @@ struct kvm_s390_sie_block {
>   #define ICPT_PARTEXEC=090x38
>   #define ICPT_IOINST=090x40
>   #define ICPT_KSS=090x5c
> +#define ICPT_PV_MCHKR=090x60
> +#define ICPT_PV_INT_EN=090x64
>   =09__u8=09icptcode;=09=09/* 0x0050 */
>   =09__u8=09icptstatus;=09=09/* 0x0051 */
>   =09__u16=09ihcpu;=09=09=09/* 0x0052 */
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index a389fa85cca2..acc1710fc472 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -480,6 +480,24 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>   =09case ICPT_KSS:
>   =09=09rc =3D kvm_s390_skey_check_enable(vcpu);
>   =09=09break;
> +=09case ICPT_PV_MCHKR:
> +=09=09/*
> +=09=09 * A protected guest changed PSW bit 13 to one and is now
> +=09=09 * enabled for interrupts. The pre-run code will check
> +=09=09 * the registers and inject pending MCHKs based on the
> +=09=09 * PSW and CRs. No additional work to do.
> +=09=09 */
> +=09=09rc =3D 0;
> +=09=09break;
> +=09case  ICPT_PV_INT_EN:
> +=09=09/*
> +=09=09 * A protected guest changed CR 0,6,14 and may now be
> +=09=09 * enabled for interrupts. The pre-run code will check
> +=09=09 * the registers and inject pending IRQs based on the
> +=09=09 * CRs. No additional work to do.
> +=09=09 */
> +=09=09rc =3D 0;
> +=09break;

Wrong indentation.

Maybe simply

case ICPT_PV_MCHKR:
ICPT_PV_INT_EN:
=09/*
=09 * PSW bit 13 or a CR (0, 6, 14) changed and we might now be
          * able to deliver interrupts. pre-run code will take care of
          * this.
=09 */
=09rc =3D 0;
=09break;

--=20

Thanks,

David / dhildenb

