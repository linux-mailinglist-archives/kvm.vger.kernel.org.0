Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1BDFD853
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 10:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKOJDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 04:03:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41082 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727059AbfKOJDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 04:03:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573808586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Ylzuw0MFzogSbNwyDr1XDn1X0CmhhzBiYdtRVmGClw=;
        b=M0Aac7RWuAAdtcaBSU47WcOmtpiP//TtXQa7YMTADpIk70cS085XjR6vlnykEoLhTMBtur
        tuLh2a0d8QM4znQ5lmTYeOpaJ7mJYAFI0pWbAn1MU1IY7S9hcVkO0LVy7aDHf/a/biC6gJ
        /aW+RTul3aPsNT5GW4qG2YBfVM2GMNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-eff2Ar84M_-bnxma5jABhg-1; Fri, 15 Nov 2019 04:03:03 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1D1A8048E5;
        Fri, 15 Nov 2019 09:03:01 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D7D55E264;
        Fri, 15 Nov 2019 09:02:57 +0000 (UTC)
Subject: Re: [RFC 26/37] KVM: s390: protvirt: Only sync fmt4 registers
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-27-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <197c1218-3171-3e22-caf8-47cdab58caf8@redhat.com>
Date:   Fri, 15 Nov 2019 10:02:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-27-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: eff2Ar84M_-bnxma5jABhg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> A lot of the registers are controlled by the Ultravisor and never
> visible to KVM. Also some registers are overlayed, like gbea is with
> sidad, which might leak data to userspace.
>=20
> Hence we sync a minimal set of registers for both SIE formats and then
> check and sync format 2 registers if necessary.
>=20
> Also we disable set/get one reg for the same reason. It's an old
> interface anyway.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 138 +++++++++++++++++++++++----------------
>  1 file changed, 82 insertions(+), 56 deletions(-)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 17a78774c617..f623c64aeade 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2997,7 +2997,8 @@ static void kvm_s390_vcpu_initial_reset(struct kvm_=
vcpu *vcpu)
>  =09/* make sure the new fpc will be lazily loaded */
>  =09save_fpu_regs();
>  =09current->thread.fpu.fpc =3D 0;
> -=09vcpu->arch.sie_block->gbea =3D 1;
> +=09if (!kvm_s390_pv_is_protected(vcpu->kvm))
> +=09=09vcpu->arch.sie_block->gbea =3D 1;
>  =09vcpu->arch.sie_block->pp =3D 0;
>  =09vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
>  =09vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
> @@ -3367,6 +3368,10 @@ static int kvm_arch_vcpu_ioctl_get_one_reg(struct =
kvm_vcpu *vcpu,
>  =09=09=09     (u64 __user *)reg->addr);
>  =09=09break;
>  =09case KVM_REG_S390_GBEA:
> +=09=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09=09r =3D 0;
> +=09=09=09break;
> +=09=09}
>  =09=09r =3D put_user(vcpu->arch.sie_block->gbea,
>  =09=09=09     (u64 __user *)reg->addr);
>  =09=09break;
> @@ -3420,6 +3425,10 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct =
kvm_vcpu *vcpu,
>  =09=09=09     (u64 __user *)reg->addr);
>  =09=09break;
>  =09case KVM_REG_S390_GBEA:
> +=09=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09=09r =3D 0;
> +=09=09=09break;
> +=09=09}

Wouldn't it be better to return EINVAL in this case? ... the callers
definitely do not get what they expected here...

 Thomas

