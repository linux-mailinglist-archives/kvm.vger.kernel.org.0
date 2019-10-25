Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CAAE469A
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 11:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438224AbfJYJE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 05:04:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2437447AbfJYJE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 05:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571994296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6EtAtoX5oupHpGZ0bBxA2I7EmQRkVr1qP+CrHfc+uw=;
        b=SwELlRDmLaCjVJrCuP9FyrbmKjpjrj9RI3vDkH20vLgG/cJqh6oOGSWs9DLqgCMy5EE6GY
        qEDsF4/N8ZTTZtYY4GkwaoAYHwYLuna+/w7NuLzV0FIVVYKtoaeYBeXbcn8H/kOUDYTZG8
        M0g4G0WsgAeHX2LKc+aaRcq0BwZ/vbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-UpfcuMk4NvaZqMoApZ9rEw-1; Fri, 25 Oct 2019 05:04:53 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8C58800D41;
        Fri, 25 Oct 2019 09:04:51 +0000 (UTC)
Received: from [10.36.116.205] (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4E4910013D9;
        Fri, 25 Oct 2019 09:04:49 +0000 (UTC)
Subject: Re: [RFC 05/37] s390: KVM: Export PV handle to gmap
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-6-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <ff7418ed-ce4b-2343-8f08-01eeac6f816e@redhat.com>
Date:   Fri, 25 Oct 2019 11:04:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-6-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: UpfcuMk4NvaZqMoApZ9rEw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> We need it in the next patch, when doing memory management for the
> guest in the kernel's fault handler, where otherwise we wouldn't have
> access to the handle.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/include/asm/gmap.h | 1 +
>   arch/s390/kvm/pv.c           | 1 +
>   2 files changed, 2 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 37f96b6f0e61..6efc0b501227 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -61,6 +61,7 @@ struct gmap {
>   =09spinlock_t shadow_lock;
>   =09struct gmap *parent;
>   =09unsigned long orig_asce;
> +=09unsigned long se_handle;
>   =09int edat_level;
>   =09bool removed;
>   =09bool initialized;
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 94cf16f40f25..80aecd5bea9e 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -169,6 +169,7 @@ int kvm_s390_pv_create_vm(struct kvm *kvm)
>   =09=09kvm_s390_pv_dealloc_vm(kvm);
>   =09=09return -EINVAL;
>   =09}
> +=09kvm->arch.gmap->se_handle =3D uvcb.guest_handle;
>   =09return rc;
>   }
>  =20
>=20

I'd suggest squashing that into the patch that needs it.

--=20

Thanks,

David / dhildenb

