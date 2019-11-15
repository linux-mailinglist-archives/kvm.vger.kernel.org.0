Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120AFFD789
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 09:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfKOIEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 03:04:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57746 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725829AbfKOIEO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 03:04:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573805053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSBrMOQOzdg5jINY82a8yb8Bu4IoFOyhsGte6lCAa3c=;
        b=F1k9N9WsBgggI9rDRbeW+QmoBeVHDWwoZvYxmH83y8wY1rM6Z+ureFXo6UsqJhB5AqcMMa
        D/kjVAurqSbGki3VXIQzv329m/hgV6EUVG7vyV3BvWUC+KfnYAGQPriKbBAP41xfjB+I7h
        7esUXoTEbqIqYby0RRyRh4q0O9kNQ8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-j32RKQV8NLWYhrg_CV-Zjw-1; Fri, 15 Nov 2019 03:04:10 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EDAD477;
        Fri, 15 Nov 2019 08:04:08 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F7D45D6AE;
        Fri, 15 Nov 2019 08:04:03 +0000 (UTC)
Subject: Re: [RFC 24/37] KVM: s390: protvirt: Write sthyi data to instruction
 data area
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-25-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <cf52261e-9281-b11c-fee4-b97013a77ff2@redhat.com>
Date:   Fri, 15 Nov 2019 09:04:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-25-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: j32RKQV8NLWYhrg_CV-Zjw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> STHYI data has to go through the bounce buffer.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/intercept.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 510b1dee3320..37cb62bc261b 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -391,7 +391,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
>  =09=09goto out;
>  =09}
> =20
> -=09if (addr & ~PAGE_MASK)
> +=09if (!kvm_s390_pv_is_protected(vcpu->kvm) && (addr & ~PAGE_MASK))
>  =09=09return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> =20
>  =09sctns =3D (void *)get_zeroed_page(GFP_KERNEL);
> @@ -402,10 +402,15 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
> =20
>  out:
>  =09if (!cc) {
> -=09=09r =3D write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
> -=09=09if (r) {
> -=09=09=09free_page((unsigned long)sctns);
> -=09=09=09return kvm_s390_inject_prog_cond(vcpu, r);
> +=09=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09=09memcpy((void *)vcpu->arch.sie_block->sidad, sctns,

sidad & PAGE_MASK, just to be sure?

> +=09=09=09       PAGE_SIZE);
> +=09=09} else {
> +=09=09=09r =3D write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
> +=09=09=09if (r) {
> +=09=09=09=09free_page((unsigned long)sctns);
> +=09=09=09=09return kvm_s390_inject_prog_cond(vcpu, r);
> +=09=09=09}
>  =09=09}
>  =09}
> =20
>=20

With "& PAGE_MASK":

Reviewed-by: Thomas Huth <thuth@redhat.com>

