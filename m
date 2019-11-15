Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95278FD7E5
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 09:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKOI1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 03:27:41 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47641 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726890AbfKOI1l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 03:27:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573806460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vdu6eMBJD2SgB0lzVDKbnJJ+cTOlwYyQGiOP5FLcOsc=;
        b=VEr9LPVbXzl+m6nezwpHjlqc8feM1cygOc6BNp/sCAaei7M8orHocJEWxxZU57lT65Y5Jt
        yA0nQu8lFXNJL6hLy+Xgwo9ZktK9f/fWy8+VuW6dvm+dv8IX6YF2eVw5QKe1Xvz1dYzlC8
        0HVRHrCzUvLJvnPjQY0AZwqHcrWoKuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-YZJ4-4IsMiWiuujpCcP-Ag-1; Fri, 15 Nov 2019 03:27:36 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27D2D802682;
        Fri, 15 Nov 2019 08:27:35 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC6376293B;
        Fri, 15 Nov 2019 08:27:30 +0000 (UTC)
Subject: Re: [RFC 25/37] KVM: s390: protvirt: STSI handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-26-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <4891580a-422a-3d85-f20e-c4c194487d34@redhat.com>
Date:   Fri, 15 Nov 2019 09:27:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-26-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: YZJ4-4IsMiWiuujpCcP-Ag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> Save response to sidad and disable address checking for protected
> guests.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/priv.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index ed52ffa8d5d4..06c7e7a10825 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -872,7 +872,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
> =20
>  =09operand2 =3D kvm_s390_get_base_disp_s(vcpu, &ar);
> =20
> -=09if (operand2 & 0xfff)
> +=09if (!kvm_s390_pv_is_protected(vcpu->kvm) && (operand2 & 0xfff))
>  =09=09return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);

I'd prefer if you could put the calculation of operand2 also under the
!pv if-statement:

=09if (!kvm_s390_pv_is_protected(vcpu->kvm)) {
=09=09operand2 =3D kvm_s390_get_base_disp_s(vcpu, &ar);
=09=09if (operand2 & 0xfff)
=09=09=09return kvm_s390_inject_program_int(vcpu,
=09=09=09=09=09=09    PGM_SPECIFICATION);
=09}

... that makes it more obvious that operand2 is only valid in the !pv
case and you should get automatic compiler warnings if you use it otherwise=
.

>  =09switch (fc) {
> @@ -893,8 +893,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>  =09=09handle_stsi_3_2_2(vcpu, (void *) mem);
>  =09=09break;
>  =09}
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09memcpy((void *)vcpu->arch.sie_block->sidad, (void *)mem,
> +=09=09       PAGE_SIZE);
> +=09=09rc =3D 0;
> +=09} else
> +=09=09rc =3D write_guest(vcpu, operand2, ar, (void *)mem, PAGE_SIZE);

Please also use braces for the else-branch (according to
Documentation/process/coding-style.rst).

 Thomas

