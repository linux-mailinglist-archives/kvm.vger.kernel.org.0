Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD66FDC16
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 12:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfKOLQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 06:16:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45801 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbfKOLQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 06:16:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573816566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvSSd9thjzlhDZ/ZO8+fXfZcB5eZVlva+mfs075TrAI=;
        b=ZHPOPDSidmYJuvAWMBwNWtcqlV8zzsJsfdKgiK8RqnPYK2Q56W4J7Vlc9OKBACYgkH6LHd
        potdkXxe1b0bBE8Xg5c8c1t0KlIUzKP992DDZXxXx6uLoUe1TfujudOCOd2cLGhWwwx+uR
        GFYU+WwpkdbUA95x3q7Fz3FErDVuk9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-CnjwVW7fP9KfZmkjf6cxYA-1; Fri, 15 Nov 2019 06:16:02 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C39D718B5FA3;
        Fri, 15 Nov 2019 11:16:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF66460C18;
        Fri, 15 Nov 2019 11:15:58 +0000 (UTC)
Subject: Re: [RFC 27/37] KVM: s390: protvirt: SIGP handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-28-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <64374089-8c38-e7b3-7ebf-b9da0aa0dfa2@redhat.com>
Date:   Fri, 15 Nov 2019 12:15:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-28-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: CnjwVW7fP9KfZmkjf6cxYA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/intercept.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 37cb62bc261b..a89738e4f761 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -72,7 +72,8 @@ static int handle_stop(struct kvm_vcpu *vcpu)
>  =09if (!stop_pending)
>  =09=09return 0;
> =20
> -=09if (flags & KVM_S390_STOP_FLAG_STORE_STATUS) {
> +=09if (flags & KVM_S390_STOP_FLAG_STORE_STATUS &&
> +=09    !kvm_s390_pv_is_protected(vcpu->kvm)) {
>  =09=09rc =3D kvm_s390_vcpu_store_status(vcpu,
>  =09=09=09=09=09=09KVM_S390_STORE_STATUS_NOADDR);
>  =09=09if (rc)

Can this still happen at all that we get here with
KVM_S390_STOP_FLAG_STORE_STATUS in the protected case? I'd rather expect
that SIGP is completely handled by the UV already, so userspace should
have no need to inject a SIGP_STOP anymore? Or did I get that wrong?

Anyway, I guess it can not hurt to add this check anyway, so:

Reviewed-by: Thomas Huth <thuth@redhat.com>

