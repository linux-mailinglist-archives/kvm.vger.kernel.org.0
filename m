Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2707FDC35
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 12:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfKOLZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 06:25:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24912 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726521AbfKOLZZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 06:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573817124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/JpN/oMJR/zr1X7jwXbaW9VEUcQwKCQO+0WLQlJgXE=;
        b=gsHiIMG3XTuabNZtrPvN2cL1jsbR+3DjgLT7HNpy3F+11+tZzkz6sw2Xy8NBFgA5VteQRo
        MCBZWQVYI377qDZFFqdpI89OPxSoD6Y8dP7B6baQTGDKfi46RsQTEzMJscT83bCoqc8Avc
        qSd2faMoBOGrHTfuuYBnxmnDSAYC/9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-CigA_vKNPwa37lgDhhUM_Q-1; Fri, 15 Nov 2019 06:25:22 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57BAD805EB7;
        Fri, 15 Nov 2019 11:25:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5FC169193;
        Fri, 15 Nov 2019 11:25:15 +0000 (UTC)
Subject: Re: [RFC 36/37] KVM: s390: protvirt: Support cmd 5 operation state
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-37-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b7880d6a-0d94-800a-654c-7d44c21b7154@redhat.com>
Date:   Fri, 15 Nov 2019 12:25:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-37-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: CigA_vKNPwa37lgDhhUM_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> Code 5 for the set cpu state UV call tells the UV to load a PSW from
> the SE header (first IPL) or from guest location 0x0 (diag 308 subcode
> 0/1). Also it sets the cpu into operating state afterwards, so we can
> start it.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 1 +
>  arch/s390/kvm/kvm-s390.c   | 4 ++++
>  include/uapi/linux/kvm.h   | 1 +
>  3 files changed, 6 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 33b52ba306af..8d10ae731458 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -163,6 +163,7 @@ struct uv_cb_unp {
>  #define PV_CPU_STATE_OPR=091
>  #define PV_CPU_STATE_STP=092
>  #define PV_CPU_STATE_CHKSTP=093
> +#define PV_CPU_STATE_OPR_LOAD=095
> =20
>  struct uv_cb_cpu_set_state {
>  =09struct uv_cb_header header;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index cc5feb67f145..5cc9108c94e4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4652,6 +4652,10 @@ static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu=
 *vcpu,
>  =09=09r =3D kvm_s390_pv_destroy_cpu(vcpu);
>  =09=09break;
>  =09}
> +=09case KVM_PV_VCPU_SET_IPL_PSW: {
> +=09=09r =3D kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR_LOAD);
> +=09=09break;
> +=09}

Nit: No need for the curly braces here.

 Thomas

