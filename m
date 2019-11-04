Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82384EDC01
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfKDKBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:01:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26192 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727499AbfKDKBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 05:01:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572861681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IP/l08nB2fmIjqCVzyr+9DZCZfjbUn26h7d6sGQ6+u8=;
        b=UELgcbidSMXhPBXaTi++/x9+OiGh4CKdBGX84QCV3IgJJQ0TJTFBBWUjtb4bUcMVolc1c7
        HJHCJUCLg8CAiMiCn5Mu3hgP/Owho8d4tvY4iiX7agSvb4CoVvdmTCkz5looeHJA4Ym81D
        QCkeUexjIOwDW+lKB6+6NXbbGCRuAzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347--G-vB5P9PwSgOiSy1mH3oA-1; Mon, 04 Nov 2019 05:01:20 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23A7E1800D53;
        Mon,  4 Nov 2019 10:01:19 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 422F66085E;
        Mon,  4 Nov 2019 10:01:18 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] alloc: Add more memalign asserts
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, pbonzini@redhat.com
References: <20191104092055.5679-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <0d34fe5d-4d5e-5b1f-e72f-45879137b58c@redhat.com>
Date:   Mon, 4 Nov 2019 11:01:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191104092055.5679-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: -G-vB5P9PwSgOiSy1mH3oA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 10:20, Janosch Frank wrote:
> Let's test for size and alignment in memalign to catch invalid input
> data. Also we need to test for NULL after calling the memalign
> function of the registered alloc operations.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>=20
> Tested only under s390, tests under other architectures are highly
> appreciated.
>=20
> ---
>   lib/alloc.c | 3 +++
>   1 file changed, 3 insertions(+)
>=20
> diff --git a/lib/alloc.c b/lib/alloc.c
> index ecdbbc4..eba9dd6 100644
> --- a/lib/alloc.c
> +++ b/lib/alloc.c
> @@ -46,6 +46,7 @@ void *memalign(size_t alignment, size_t size)
>   =09uintptr_t blkalign;
>   =09uintptr_t mem;
>  =20
> +=09assert(size && alignment);
>   =09assert(alloc_ops && alloc_ops->memalign);
>   =09if (alignment <=3D sizeof(uintptr_t))
>   =09=09alignment =3D sizeof(uintptr_t);
> @@ -56,6 +57,8 @@ void *memalign(size_t alignment, size_t size)
>   =09size =3D ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
>   =09p =3D alloc_ops->memalign(blkalign, size);
>  =20
> +=09assert(p !=3D NULL);
> +
>   =09/* Leave room for metadata before aligning the result.  */
>   =09mem =3D (uintptr_t)p + METADATA_EXTRA;
>   =09mem =3D ALIGN(mem, alignment);
>=20

Reviewed-by: David Hildenbrand <david@redhat.com>

--=20

Thanks,

David / dhildenb

