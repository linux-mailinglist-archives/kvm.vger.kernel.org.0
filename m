Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96A6FC8CD
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 15:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfKNOWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 09:22:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbfKNOWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 09:22:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573741361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sCc5nA4aVTzlO3ItUygoMzfKpsiyxafzMqcM3+wFzd0=;
        b=U7hyOu9d2jnaMouc/cWCAaUo5heKfGwGn4nOEsceHWu6rthg/NiMu13LRhWBPS8PCmP1Cb
        CYWmL7GQCkNxgxhtz1JyaLlbv+5kgAqWvMI2a8frOm0C7cOx/CngVZnariIAlUL2Vvwa7I
        lc2/anlmUCTikhLQiLgXevY32WvEH84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-eULjYjAPOB-8qdMcXShXIw-1; Thu, 14 Nov 2019 09:22:38 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90214DB64;
        Thu, 14 Nov 2019 14:22:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-89.ams2.redhat.com [10.36.116.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C921760475;
        Thu, 14 Nov 2019 14:22:27 +0000 (UTC)
Subject: Re: [RFC 18/37] KVM: s390: protvirt: Handle spec exception loops
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-19-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6d1d7c2f-0191-b41f-dbed-146a98c9ec4c@redhat.com>
Date:   Thu, 14 Nov 2019 15:22:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-19-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: eULjYjAPOB-8qdMcXShXIw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> SIE intercept code 8 is used only on exception loops for protected
> guests. That means we need stop the guest when we see it.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/intercept.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index acc1710fc472..b013a9c88d43 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -231,6 +231,13 @@ static int handle_prog(struct kvm_vcpu *vcpu)
> =20
>  =09vcpu->stat.exit_program_interruption++;
> =20
> +=09/*
> +=09 * Intercept 8 indicates a loop of specification exceptions
> +=09 * for protected guests
> +=09 */
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm))
> +=09=09return -EOPNOTSUPP;
> +
>  =09if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
>  =09=09rc =3D kvm_s390_handle_per_event(vcpu);
>  =09=09if (rc)

Reviewed-by: Thomas Huth <thuth@redhat.com>

