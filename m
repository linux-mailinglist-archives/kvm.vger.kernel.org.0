Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3D31021E5
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 11:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKSKS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 05:18:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38323 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727601AbfKSKS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 05:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574158738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=upMQe+GJhWgpbnACkY4g9LInZUcWuvGT1T36vHoBSqI=;
        b=KLjRPu8XQi/2L8RQn62oDNtU5XN6umeF314ncRzW0+SzEUqNnqQ7ukOFpCFGp9FNCmVpnT
        72uZQLy4emt5YUGIAoEja5EZdQABCj8Z7uHhKBn0FnCxWEfyQka/+qSljajKwFK5h/8fMb
        15eiSlxYn5BkZCsxFP8/UBnboIcMBxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-ZmOnlWgtOiCePyoiamgZRg-1; Tue, 19 Nov 2019 05:18:55 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E901801E5B;
        Tue, 19 Nov 2019 10:18:53 +0000 (UTC)
Received: from [10.36.117.126] (ovpn-117-126.ams2.redhat.com [10.36.117.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D9E162671;
        Tue, 19 Nov 2019 10:18:47 +0000 (UTC)
Subject: Re: [RFC 23/37] KVM: s390: protvirt: Make sure prefix is always
 protected
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-24-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <ded0154c-a9b4-4419-14c8-a34095494d82@redhat.com>
Date:   Tue, 19 Nov 2019 11:18:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-24-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ZmOnlWgtOiCePyoiamgZRg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index eddc9508c1b1..17a78774c617 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3646,6 +3646,15 @@ static int kvm_s390_handle_requests(struct kvm_vcp=
u *vcpu)
>   =09=09rc =3D gmap_mprotect_notify(vcpu->arch.gmap,
>   =09=09=09=09=09  kvm_s390_get_prefix(vcpu),
>   =09=09=09=09=09  PAGE_SIZE * 2, PROT_WRITE);
> +=09=09if (!rc && kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09=09rc =3D uv_convert_to_secure(vcpu->arch.gmap,
> +=09=09=09=09=09=09  kvm_s390_get_prefix(vcpu));
> +=09=09=09WARN_ON_ONCE(rc && rc !=3D -EEXIST);
> +=09=09=09rc =3D uv_convert_to_secure(vcpu->arch.gmap,
> +=09=09=09=09=09=09  kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
> +=09=09=09WARN_ON_ONCE(rc && rc !=3D -EEXIST);
> +=09=09=09rc =3D 0;
> +=09=09}

... what if userspace reads the prefix pages just after these calls?=20
validity? :/

>   =09=09if (rc) {
>   =09=09=09kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
>   =09=09=09return rc;
>=20

--=20

Thanks,

David / dhildenb

