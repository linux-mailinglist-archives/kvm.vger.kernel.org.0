Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797D5EDC9F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfKDKdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:33:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21069 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbfKDKdg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 05:33:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572863615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uMheZaAUIoNHHNgujHaIe7uhtD6HeQXhcpKRkC2DPbA=;
        b=P7FM9OKJy8E98pmeV6T7qIBp8TCcuHyx/kZKHF7naN+0FUeaTRS6e5Lghfm757mETgxyoR
        azNVvlPMSwf3vvih0vUatePLPDGtH8aXiZDlIHCzc5CsXJTCGw9BTQY6EpE9gckdSsaVD5
        STFF5O0JZQKTBD+6r6hkERd6K3amYUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-z-6KeafeMTy1QL3jJenHmw-1; Mon, 04 Nov 2019 05:33:31 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 323CA2EDC;
        Mon,  4 Nov 2019 10:33:30 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4662F1001B23;
        Mon,  4 Nov 2019 10:33:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, pbonzini@redhat.com
References: <20191104102916.10554-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
Date:   Mon, 4 Nov 2019 11:33:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191104102916.10554-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: z-6KeafeMTy1QL3jJenHmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 11:29, Janosch Frank wrote:
> Let's test for size and alignment in memalign to catch invalid input
> data. Also we need to test for NULL after calling the memalign
> function of the registered alloc operations.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/alloc.c | 3 +++
>   1 file changed, 3 insertions(+)
>=20
> diff --git a/lib/alloc.c b/lib/alloc.c
> index ecdbbc4..b763c70 100644
> --- a/lib/alloc.c
> +++ b/lib/alloc.c
> @@ -47,6 +47,8 @@ void *memalign(size_t alignment, size_t size)
>   =09uintptr_t mem;
>  =20
>   =09assert(alloc_ops && alloc_ops->memalign);
> +=09if (!size || !alignment)
> +=09=09return NULL;
>   =09if (alignment <=3D sizeof(uintptr_t))
>   =09=09alignment =3D sizeof(uintptr_t);

BTW, memalign MAN page

"EINVAL The alignment argument was not a power of two, or was not a=20
multiple of sizeof(void *)."

So we could also return NULL here (not sure if anybody relies on that)

>   =09else
> @@ -55,6 +57,7 @@ void *memalign(size_t alignment, size_t size)
>   =09blkalign =3D MAX(alignment, alloc_ops->align_min);
>   =09size =3D ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
>   =09p =3D alloc_ops->memalign(blkalign, size);
> +=09assert(p);
>  =20
>   =09/* Leave room for metadata before aligning the result.  */
>   =09mem =3D (uintptr_t)p + METADATA_EXTRA;
>=20

Reviewed-by: David Hildenbrand <david@redhat.com>

--=20

Thanks,

David / dhildenb

