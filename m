Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2117FFB05D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKMMXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:23:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43285 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726449AbfKMMXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 07:23:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573647824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3+1fgWJbFLkj20PjBaWsJUFP5wYlshkbeZz7BKc4Ges=;
        b=FkI7KzoAGgrDEvIF++LXWGmXUY3uzjUSV4qwq9Q8ZWZqFF4fuYV+1gAxgo5ZjuapvsN0nX
        KZR9FOC7X5i0OCix9HcET7m0Dj2egHgKUqByEz5u0OHiSpPQg/pSpp/RvCRO+1jw0WqhPu
        ctKAIuvq6iIcYaHiAxCDy2arX/RdfHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-lzR8nFuhOU-jBLeREP5f6A-1; Wed, 13 Nov 2019 07:23:41 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11E32801E74;
        Wed, 13 Nov 2019 12:23:40 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 285AB4A;
        Wed, 13 Nov 2019 12:23:34 +0000 (UTC)
Subject: Re: [RFC v2] KVM: s390: protvirt: Secure memory is not mergeable
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-8-frankja@linux.ibm.com>
 <20191025082446.754-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <621d0191-1490-d8d3-c7be-11466243f63f@redhat.com>
Date:   Wed, 13 Nov 2019 13:23:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191025082446.754-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: lzR8nFuhOU-jBLeREP5f6A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2019 10.24, Janosch Frank wrote:
> KSM will not work on secure pages, because when the kernel reads a
> secure page, it will be encrypted and hence no two pages will look the
> same.
>=20
> Let's mark the guest pages as unmergeable when we transition to secure
> mode.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
[...]
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index edcdca97e85e..faecdf81abdb 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2548,6 +2548,23 @@ int s390_enable_sie(void)
>  }
>  EXPORT_SYMBOL_GPL(s390_enable_sie);
> =20
> +int gmap_mark_unmergeable(void)
> +{
> +=09struct mm_struct *mm =3D current->mm;
> +=09struct vm_area_struct *vma;
> +
> +

Please remove one of the two empty lines.

> +=09for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
> +=09=09if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
> +=09=09=09=09MADV_UNMERGEABLE, &vma->vm_flags))
> +=09=09=09return -ENOMEM;
> +=09}
> +=09mm->def_flags &=3D ~VM_MERGEABLE;
> +
> +=09return 0;
> +}
> +EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
> +
[...]

Apart from the cosmetic nit, the patch looks fine to me.

Reviewed-by: Thomas Huth <thuth@redhat.com>

