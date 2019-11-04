Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A080EE203
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 15:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfKDOR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 09:17:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53385 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727788AbfKDOR0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 09:17:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572877044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COp03Y7FO60fqWsQcf0UnFkYR+fwrFHAeGStSiiVXyY=;
        b=iNgYQgGTAExe8IH8WME77auWBGpbTSfSr4N+kAmj+x/m4hGVd+Otm38Kly0T+AugzB1+rS
        8CFzzs0QHa6S0w4WxlHynRI3hPf6rZ++VlI2S/gUikPBG7zrzaYz652d7yew3G7J7oCvuK
        dwehwDkh/i1Jsf2xoMEYYlFawE++o0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-yoB0gkdROUmk8HAnOYvvDA-1; Mon, 04 Nov 2019 09:17:21 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB8D1800C73;
        Mon,  4 Nov 2019 14:17:19 +0000 (UTC)
Received: from [10.36.117.96] (ovpn-117-96.ams2.redhat.com [10.36.117.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E4D8600F0;
        Mon,  4 Nov 2019 14:17:16 +0000 (UTC)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <09115b82-40a7-2f06-c629-94cce65fd567@redhat.com>
Date:   Mon, 4 Nov 2019 15:17:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-10-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: yoB0gkdROUmk8HAnOYvvDA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>=20
> Pin the guest pages when they are first accessed, instead of all at
> the same time when starting the guest.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/gmap.h |  1 +
>   arch/s390/include/asm/uv.h   |  6 +++++
>   arch/s390/kernel/uv.c        | 20 ++++++++++++++
>   arch/s390/kvm/kvm-s390.c     |  2 ++
>   arch/s390/kvm/pv.c           | 51 ++++++++++++++++++++++++++++++------
>   5 files changed, 72 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 99b3eedda26e..483f64427c0e 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -63,6 +63,7 @@ struct gmap {
>   =09struct gmap *parent;
>   =09unsigned long orig_asce;
>   =09unsigned long se_handle;
> +=09struct page **pinned_pages;
>   =09int edat_level;
>   =09bool removed;
>   =09bool initialized;
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 99cdd2034503..9ce9363aee1c 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -298,6 +298,7 @@ static inline int uv_convert_from_secure(unsigned lon=
g paddr)
>   =09return -EINVAL;
>   }
>  =20
> +int kvm_s390_pv_pin_page(struct gmap *gmap, unsigned long gpa);
>   /*
>    * Requests the Ultravisor to make a page accessible to a guest
>    * (import). If it's brought in the first time, it will be cleared. If
> @@ -317,6 +318,11 @@ static inline int uv_convert_to_secure(struct gmap *=
gmap, unsigned long gaddr)
>   =09=09.gaddr =3D gaddr
>   =09};
>  =20
> +=09down_read(&gmap->mm->mmap_sem);
> +=09cc =3D kvm_s390_pv_pin_page(gmap, gaddr);
> +=09up_read(&gmap->mm->mmap_sem);
> +=09if (cc)
> +=09=09return cc;
>   =09cc =3D uv_call(0, (u64)&uvcb);

So, a theoretical question: Is any in-flight I/O from paging stopped=20
when we try to pin the pages? I am no export on paging, but the comment=20
from Christian ("you can actually fault in a page that is currently=20
under paging I/O.") made me wonder.

Let's assume you could have parallel I/O on that page. You would do a=20
uv_call() and convert the page to secure/unencrypted. The I/O can easily=20
stumble over that (now inaccessible) page and report an error.

Or is any such race not possible because we are using=20
get_user_pages_fast() vs. get_user_pages()? (then, I'd love to see a=20
comment regarding that in the patch description)

--=20

Thanks,

David / dhildenb

