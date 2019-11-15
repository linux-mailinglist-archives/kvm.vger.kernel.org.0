Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8579BFD7CF
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 09:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKOITW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 03:19:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55424 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725829AbfKOITW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 03:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573805961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HM25g7Y+c6Nk3R4SIg2yp3WYvXOoTvCW1OyFB7VAXf8=;
        b=GBAmFn3apBaJEPfUegtHuzGThSQ2sW+Sl/ldSTYCMp1T/fAVXFyWe7iR3268UDs9Rk14L6
        cayp9zKBgrjQ7xPDR8GGwwFoX9oIZCdVyypqDo3eOcBr1GEEKVHKCL8j+QFjXAu/jKsdUN
        lpLbly4B4wSWsY65HZrnaKEh1EPfYiY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-hwMwx4_wNYWDLqL_otnQ4Q-1; Fri, 15 Nov 2019 03:19:18 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC57B1005511;
        Fri, 15 Nov 2019 08:19:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 819EB65E99;
        Fri, 15 Nov 2019 08:19:10 +0000 (UTC)
Subject: Re: [PATCH] Fixup sida bouncing
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com
References: <ad0f9b90-3ce4-c2d2-b661-635fe439f7e2@redhat.com>
 <20191114162153.25349-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <016cea87-9097-ca8b-2d19-9f69cdff3af6@redhat.com>
Date:   Fri, 15 Nov 2019 09:19:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191114162153.25349-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: hwMwx4_wNYWDLqL_otnQ4Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/2019 17.21, Janosch Frank wrote:
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 0fa7c6d9ed0e..9820fde04887 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4432,13 +4432,21 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu=
 *vcpu,
>  =09if (mop->size > MEM_OP_MAX_SIZE)
>  =09=09return -E2BIG;
> =20
> -=09/* Protected guests move instruction data over the satellite
> +=09/*
> +=09 * Protected guests move instruction data over the satellite
>  =09 * block which has its own size limit
>  =09 */
>  =09if (kvm_s390_pv_is_protected(vcpu->kvm) &&
> -=09    mop->size > ((vcpu->arch.sie_block->sidad & 0x0f) + 1) * PAGE_SIZ=
E)
> +=09    mop->size > ((vcpu->arch.sie_block->sidad & 0xff) + 1) * PAGE_SIZ=
E)
>  =09=09return -E2BIG;
> =20
> +=09/* We can currently only offset into the one SIDA page. */
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09mop->gaddr &=3D ~PAGE_MASK;
> +=09=09if (mop->gaddr + mop->size > PAGE_SIZE)
> +=09=09=09return -EINVAL;
> +=09}
> +
>  =09if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
>  =09=09tmpbuf =3D vmalloc(mop->size);
>  =09=09if (!tmpbuf)
> @@ -4451,6 +4459,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *=
vcpu,
>  =09case KVM_S390_MEMOP_LOGICAL_READ:
>  =09=09if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>  =09=09=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09=09=09/* We can always copy into the SIDA */
>  =09=09=09=09r =3D 0;
>  =09=09=09=09break;
>  =09=09=09}
> @@ -4461,8 +4470,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *=
vcpu,
>  =09=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>  =09=09=09r =3D 0;
>  =09=09=09if (copy_to_user(uaddr, (void *)vcpu->arch.sie_block->sidad +
> -=09=09=09=09=09 (mop->gaddr & ~PAGE_MASK),
> -=09=09=09=09=09 mop->size))
> +=09=09=09=09=09 mop->gaddr, mop->size))
>  =09=09=09=09r =3D -EFAULT;
>  =09=09=09break;
>  =09=09}
> @@ -4485,8 +4493,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *=
vcpu,
>  =09=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>  =09=09=09r =3D 0;
>  =09=09=09if (copy_from_user((void *)vcpu->arch.sie_block->sidad +
> -=09=09=09=09=09   (mop->gaddr & ~PAGE_MASK), uaddr,
> -=09=09=09=09=09   mop->size))
> +=09=09=09=09=09   mop->gaddr, uaddr, mop->size))
>  =09=09=09=09r =3D -EFAULT;
>  =09=09=09break;
>  =09=09}
>=20

That looks better, indeed.

Still, is there a way you could also verify that gaddr references the
right page that is mirrored in the sidad?

 Thomas

