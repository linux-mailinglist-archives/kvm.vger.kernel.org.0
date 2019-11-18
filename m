Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E3D100951
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfKRQjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 11:39:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24136 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726322AbfKRQjz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 11:39:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574095194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ocyby15EQxy2iZNO+GuEyjy4i4PoYAeDtvXT65y9yA=;
        b=hagHL0v9N0KT+TUC2EDYmfCPwf/sTlge30O9yBCwMfYXgHVthW3um2GErf3VBQYK+QOpbm
        z/Od2ZG7JcJBZjLfJveLydXSgNDC1NSlLPsFOkuPXSxTt8ikNvY75RgxtRWVJ0+5Hc/Y3s
        EqpTbUrZQqd4KeUVzbVTLNQXf82k20E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-ryTzPaCqMgirnMBFFQ_pmQ-1; Mon, 18 Nov 2019 11:39:51 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90C8D95C5E;
        Mon, 18 Nov 2019 16:39:49 +0000 (UTC)
Received: from gondolin (ovpn-117-194.ams2.redhat.com [10.36.117.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E74360603;
        Mon, 18 Nov 2019 16:39:44 +0000 (UTC)
Date:   Mon, 18 Nov 2019 17:39:42 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 23/37] KVM: s390: protvirt: Make sure prefix is always
 protected
Message-ID: <20191118173942.0252b731.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-24-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-24-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: ryTzPaCqMgirnMBFFQ_pmQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:45 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

Add at least a short sentence here?

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index eddc9508c1b1..17a78774c617 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3646,6 +3646,15 @@ static int kvm_s390_handle_requests(struct kvm_vcp=
u *vcpu)
>  =09=09rc =3D gmap_mprotect_notify(vcpu->arch.gmap,
>  =09=09=09=09=09  kvm_s390_get_prefix(vcpu),
>  =09=09=09=09=09  PAGE_SIZE * 2, PROT_WRITE);
> +=09=09if (!rc && kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09=09rc =3D uv_convert_to_secure(vcpu->arch.gmap,
> +=09=09=09=09=09=09  kvm_s390_get_prefix(vcpu));
> +=09=09=09WARN_ON_ONCE(rc && rc !=3D -EEXIST);
> +=09=09=09rc =3D uv_convert_to_secure(vcpu->arch.gmap,
> +=09=09=09=09=09=09  kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
> +=09=09=09WARN_ON_ONCE(rc && rc !=3D -EEXIST);
> +=09=09=09rc =3D 0;

So, what happens if we have an error other than -EEXIST (which
presumably means that we already protected it) here? The page is not
protected, and further accesses will get an error? (Another question:
what can actually go wrong here?)

> +=09=09}
>  =09=09if (rc) {
>  =09=09=09kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
>  =09=09=09return rc;

