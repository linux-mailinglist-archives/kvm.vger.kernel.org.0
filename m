Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64ACFCA0E
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfKNPic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:38:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58552 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726482AbfKNPic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 10:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573745910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPne8oN6R6+zyM+0+k+w+pzmHGieIUd+RzaOkmdYprA=;
        b=b0yMn44iKzcgtDfghVzkFwf8056atDzcR2LmoXL4kQFky66LTR71Ozd4GRxlvrAg3M0Dbd
        SRqTzXM4x1YnvSNo5jfV6bnhaC/D+hNYJAXGUTlY6UeOAGvdefUZ9NsHBTLjFOsv4R7ReM
        cqTo77DrjxFSV8IBdqSQBRONygx1A+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-fcCmXEoWOVGxuipc4x9XdQ-1; Thu, 14 Nov 2019 10:38:27 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EA8ADBA5;
        Thu, 14 Nov 2019 15:38:26 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64CE060BFB;
        Thu, 14 Nov 2019 15:38:21 +0000 (UTC)
Date:   Thu, 14 Nov 2019 16:38:19 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 21/37] KVM: S390: protvirt: Instruction emulation
Message-ID: <20191114163819.4fb4bed1.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-22-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-22-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: fcCmXEoWOVGxuipc4x9XdQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:43 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> We have two new SIE exit codes 104 for a secure instruction
> interception, on which the SIE needs hypervisor action to complete the
> instruction.
>=20
> And 108 which is merely a notification and provides data for tracking
> and management, like for the lowcore we set notification bits for the
> lowcore pages.

What about the following:

"With protected virtualization, we have two new SIE exit codes:

- 104 indicates a secure instruction interception; the hypervisor needs
  to complete emulation of the instruction.
- 108 is merely a notification providing data for tracking and
  management in the hypervisor; for example, we set notification bits
  for the lowcore pages."

?

>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  2 ++
>  arch/s390/kvm/intercept.c        | 23 +++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 2a8a1e21e1c3..a42dfe98128b 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -212,6 +212,8 @@ struct kvm_s390_sie_block {
>  #define ICPT_KSS=090x5c
>  #define ICPT_PV_MCHKR=090x60
>  #define ICPT_PV_INT_EN=090x64
> +#define ICPT_PV_INSTR=090x68
> +#define ICPT_PV_NOT=090x6c

Maybe ICPT_PV_NOTIF?

>  =09__u8=09icptcode;=09=09/* 0x0050 */
>  =09__u8=09icptstatus;=09=09/* 0x0051 */
>  =09__u16=09ihcpu;=09=09=09/* 0x0052 */
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index b013a9c88d43..a1df8a43c88b 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -451,6 +451,23 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>  =09return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>  }
> =20
> +static int handle_pv_spx(struct kvm_vcpu *vcpu)
> +{
> +=09u32 pref =3D *(u32 *)vcpu->arch.sie_block->sidad;
> +
> +=09kvm_s390_set_prefix(vcpu, pref);
> +=09trace_kvm_s390_handle_prefix(vcpu, 1, pref);
> +=09return 0;
> +}
> +
> +static int handle_pv_not(struct kvm_vcpu *vcpu)
> +{
> +=09if (vcpu->arch.sie_block->ipa =3D=3D 0xb210)
> +=09=09return handle_pv_spx(vcpu);
> +
> +=09return handle_instruction(vcpu);

Hm... if I understood it correctly, we are getting this one because the
SIE informs us about things that it handled itself (but which we
should be aware of). What can handle_instruction() do in this case?

> +}
> +
>  int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  {
>  =09int rc, per_rc =3D 0;
> @@ -505,6 +522,12 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>  =09=09 */
>  =09=09rc =3D 0;
>  =09break;
> +=09case ICPT_PV_INSTR:
> +=09=09rc =3D handle_instruction(vcpu);
> +=09=09break;
> +=09case ICPT_PV_NOT:
> +=09=09rc =3D handle_pv_not(vcpu);
> +=09=09break;
>  =09default:
>  =09=09return -EOPNOTSUPP;
>  =09}

