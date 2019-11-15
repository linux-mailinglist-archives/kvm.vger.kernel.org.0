Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C524FDA66
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfKOKEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:04:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32731 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727132AbfKOKEe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 05:04:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573812272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twfC3eJ9fenWbj+1iTb4uCfRWF8ThzLNgGYWE5XfCXc=;
        b=W6TBseGHhK5AlXXkk7Dcx+dEQUTXRrHrV+g2lceKG6dDzlix6/Qp7yDip7PbANAcpBkWug
        Xs3fvO2PS2iGGYrD5E2hM2tC9wTXxwZjI6S8xl9/DHSLjUJ8gof0jb+B5NMHsgNIPXInKZ
        VArv8qrwT1YM+7ui79W0GK9/UI9ju+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-5QICuIuvOa-MvAoyXONlxA-1; Fri, 15 Nov 2019 05:04:31 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93F1E107ACC5;
        Fri, 15 Nov 2019 10:04:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC4A55C1B0;
        Fri, 15 Nov 2019 10:04:24 +0000 (UTC)
Subject: Re: [RFC 31/37] KVM: s390: protvirt: Add diag 308 subcode 8 - 10
 handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-32-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a1c263ff-954e-a7c3-28b4-e9bd866eb35f@redhat.com>
Date:   Fri, 15 Nov 2019 11:04:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-32-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 5QICuIuvOa-MvAoyXONlxA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> If the host initialized the Ultravisor, we can set stfle bit 161
> (protected virtual IPL enhancements facility), which indicates, that
> the IPL subcodes 8, 9 and are valid. These subcodes are used by a
> normal guest to set/retrieve a IPIB of type 5 and transition into
> protected mode.
>=20
> Once in protected mode, the VM will loose the facility bit, as each

So should the bit be cleared in the host code again? ... I don't see
this happening in this patch?

 Thomas


> boot into protected mode has to go through non-protected. There is no
> secure re-ipl with subcode 10 without a previous subcode 3.
>=20
> In protected mode, there is no subcode 4 available, as the VM has no
> more access to its memory from non-protected mode. I.e. each IPL
> clears.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/diag.c     | 6 ++++++
>  arch/s390/kvm/kvm-s390.c | 5 +++++
>  2 files changed, 11 insertions(+)
>=20
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 3fb54ec2cf3e..b951dbdcb6a0 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -197,6 +197,12 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcp=
u)
>  =09case 4:
>  =09=09vcpu->run->s390_reset_flags =3D 0;
>  =09=09break;
> +=09case 8:
> +=09case 9:
> +=09case 10:
> +=09=09if (!test_kvm_facility(vcpu->kvm, 161))
> +=09=09=09return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +=09=09/* fall through */
>  =09default:
>  =09=09return -EOPNOTSUPP;
>  =09}
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 500972a1f742..8947f1812b12 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2590,6 +2590,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lon=
g type)
>  =09if (css_general_characteristics.aiv && test_facility(65))
>  =09=09set_kvm_facility(kvm->arch.model.fac_mask, 65);
> =20
> +=09if (is_prot_virt_host()) {
> +=09=09set_kvm_facility(kvm->arch.model.fac_mask, 161);
> +=09=09set_kvm_facility(kvm->arch.model.fac_list, 161);
> +=09}
> +
>  =09kvm->arch.model.cpuid =3D kvm_s390_get_initial_cpuid();
>  =09kvm->arch.model.ibc =3D sclp.ibc & 0x0fff;
> =20
>=20

