Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BD3EA357
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 19:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfJ3S3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 14:29:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55517 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727500AbfJ3S3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 14:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572460192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sD9ilt7E0eF8ebEenHyF+oLBsdtqCiop9f34SpTYO9U=;
        b=OGYSnVU8OCSc3LQTXPe/e6mOV4/qKMPdjDZ10nTjm3FvDnFjMbTvuVyW9MS2voV6K+NY0+
        oG/lLVplVpz3abLsl5SsvwJhpL8zb2jk90kjUjtBuVjmD7TH1Pcd/H8KFiV+zSQ9IH+/vG
        gWx8x0ahmTeFzgR049QkBpGBA5vtoXU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-fsqSqvcaMyCho3W8c_yCWA-1; Wed, 30 Oct 2019 14:29:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EECC9800D49;
        Wed, 30 Oct 2019 18:29:47 +0000 (UTC)
Received: from [10.36.116.178] (ovpn-116-178.ams2.redhat.com [10.36.116.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BAAE5C1C3;
        Wed, 30 Oct 2019 18:29:45 +0000 (UTC)
Subject: Re: [RFC 27/37] KVM: s390: protvirt: SIGP handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-28-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <37df8c9a-091b-4da6-e1dc-294f432cb743@redhat.com>
Date:   Wed, 30 Oct 2019 19:29:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-28-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: fsqSqvcaMyCho3W8c_yCWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Can you add why this is necessary and how handle_stop() is intended to=20
work in prot mode?

How is SIGP handled in general in prot mode? (which intercepts are=20
handled by QEMU)
Would it be valid for user space to inject a STOP interrupt with "flags=20
& KVM_S390_STOP_FLAG_STORE_STATUS" - I think not (legacy QEMU only)

I think we should rather disallow injecting such stop interrupts=20
(KVM_S390_STOP_FLAG_STORE_STATUS) in prot mode in the first place. Also,=20
we should disallow prot virt without user_sigp.

> ---
>   arch/s390/kvm/intercept.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 37cb62bc261b..a89738e4f761 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -72,7 +72,8 @@ static int handle_stop(struct kvm_vcpu *vcpu)
>   =09if (!stop_pending)
>   =09=09return 0;
>  =20
> -=09if (flags & KVM_S390_STOP_FLAG_STORE_STATUS) {
> +=09if (flags & KVM_S390_STOP_FLAG_STORE_STATUS &&
> +=09    !kvm_s390_pv_is_protected(vcpu->kvm)) {
>   =09=09rc =3D kvm_s390_vcpu_store_status(vcpu,
>   =09=09=09=09=09=09KVM_S390_STORE_STATUS_NOADDR);
>   =09=09if (rc)
>=20

--=20

Thanks,

David / dhildenb

