Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D202FDBAB
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfKOKsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:48:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57155 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727170AbfKOKsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573814889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HzFbww9FVWdD39hKBOtyqsfxSOu8yp0+zrzbT4HP8KU=;
        b=L+Wri0Y6qZJGbgtil3riJ1LfCgZaG76Fm/SQYGHKDnaW5c0ACESi0iLWneKD8VKAZ/uhAW
        xYRpa81xU52JuHWbdwjvyTPZr25rEWUW3bmRUrrQqIdenyitksjRl56AXynoXb1sR4xM9Q
        o2O7aYSdzZ5zGg6GOJqA2brmajcpGos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-ad1wF_yMNMC33XubVJvPPQ-1; Fri, 15 Nov 2019 05:48:06 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F34878048ED;
        Fri, 15 Nov 2019 10:48:04 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E10A65E99;
        Fri, 15 Nov 2019 10:47:57 +0000 (UTC)
Subject: Re: [RFC 33/37] KVM: s390: Introduce VCPU reset IOCTL
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-34-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e7a62927-7e0e-1309-d5ad-b4a59149bb6a@redhat.com>
Date:   Fri, 15 Nov 2019 11:47:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-34-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: ad1wF_yMNMC33XubVJvPPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> With PV we need to do things for all reset types, not only initial...
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 53 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h |  6 +++++
>  2 files changed, 59 insertions(+)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d3fd3ad1d09b..d8ee3a98e961 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3472,6 +3472,53 @@ static int kvm_arch_vcpu_ioctl_initial_reset(struc=
t kvm_vcpu *vcpu)
>  =09return 0;
>  }
> =20
> +static int kvm_arch_vcpu_ioctl_reset(struct kvm_vcpu *vcpu,
> +=09=09=09=09     unsigned long type)
> +{
> +=09int rc;
> +=09u32 ret;
> +
> +=09switch (type) {
> +=09case KVM_S390_VCPU_RESET_NORMAL:
> +=09=09/*
> +=09=09 * Only very little is reset, userspace handles the
> +=09=09 * non-protected case.
> +=09=09 */
> +=09=09rc =3D 0;
> +=09=09if (kvm_s390_pv_handle_cpu(vcpu)) {
> +=09=09=09rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
> +=09=09=09=09=09   UVC_CMD_CPU_RESET, &ret);
> +=09=09=09VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: cpu %d rc %x r=
rc %x",
> +=09=09=09=09   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
> +=09=09}
> +=09=09break;
> +=09case KVM_S390_VCPU_RESET_INITIAL:
> +=09=09rc =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> +=09=09if (kvm_s390_pv_handle_cpu(vcpu)) {
> +=09=09=09uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
> +=09=09=09=09      UVC_CMD_CPU_RESET_INITIAL,
> +=09=09=09=09      &ret);
> +=09=09=09VCPU_EVENT(vcpu, 3, "PROTVIRT RESET INITIAL VCPU: cpu %d rc %x =
rrc %x",
> +=09=09=09=09   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
> +=09=09}
> +=09=09break;
> +=09case KVM_S390_VCPU_RESET_CLEAR:
> +=09=09rc =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> +=09=09if (kvm_s390_pv_handle_cpu(vcpu)) {
> +=09=09=09rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
> +=09=09=09=09=09   UVC_CMD_CPU_RESET_CLEAR, &ret);
> +=09=09=09VCPU_EVENT(vcpu, 3, "PROTVIRT RESET CLEAR VCPU: cpu %d rc %x rr=
c %x",
> +=09=09=09=09   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
> +=09=09}
> +=09=09break;
> +=09default:
> +=09=09rc =3D -EINVAL;
> +=09=09break;

(nit: you could drop the "break;" here)

> +=09}
> +=09return rc;
> +}
> +
> +
>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs =
*regs)
>  {
>  =09vcpu_load(vcpu);
> @@ -4633,8 +4680,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  =09=09break;
>  =09}
>  =09case KVM_S390_INITIAL_RESET:
> +=09=09r =3D -EINVAL;
> +=09=09if (kvm_s390_pv_is_protected(vcpu->kvm))
> +=09=09=09break;

Wouldn't it be nicer to call

  kvm_arch_vcpu_ioctl_reset(vcpu, KVM_S390_VCPU_RESET_INITIAL)

in this case instead?

>  =09=09r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>  =09=09break;
> +=09case KVM_S390_VCPU_RESET:
> +=09=09r =3D kvm_arch_vcpu_ioctl_reset(vcpu, arg);
> +=09=09break;
>  =09case KVM_SET_ONE_REG:
>  =09case KVM_GET_ONE_REG: {
>  =09=09struct kvm_one_reg reg;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f75a051a7705..2846ed5e5dd9 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1496,6 +1496,12 @@ struct kvm_pv_cmd {
>  #define KVM_S390_PV_COMMAND=09=09_IOW(KVMIO, 0xc3, struct kvm_pv_cmd)
>  #define KVM_S390_PV_COMMAND_VCPU=09_IOW(KVMIO, 0xc4, struct kvm_pv_cmd)
> =20
> +#define KVM_S390_VCPU_RESET_NORMAL=090
> +#define KVM_S390_VCPU_RESET_INITIAL=091
> +#define KVM_S390_VCPU_RESET_CLEAR=092
> +
> +#define KVM_S390_VCPU_RESET    _IO(KVMIO,   0xd0)

Why not 0xc5 ?

 Thomas

