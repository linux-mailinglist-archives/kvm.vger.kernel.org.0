Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9CF1C4A1C
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgEDXUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:20:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47389 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726911AbgEDXUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 19:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588634437;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNTGPHGCvQkKfNViHDiLQZ+jRyRLgBajxxr2dmg/aIY=;
        b=RySloh3I959QaOSc/4vgipeYlzG50hvWXIaNpRtrzLqvPiisreXdMig5X6d6gmE1Jl245u
        MWVnfuwUe0BrbeiHLFhtykBGzceUDXF5UXSXYyv6AO5TbGmHQv52Lv0KQ5YkZDS0d4t+PJ
        opikGpELcF9XmLY2vJ0hzrqOnYIk0t4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-RbA5ZVjJNnSVNM93qwQIGw-1; Mon, 04 May 2020 19:20:35 -0400
X-MC-Unique: RbA5ZVjJNnSVNM93qwQIGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E8981800D4A;
        Mon,  4 May 2020 23:20:34 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-132.bne.redhat.com [10.64.54.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDEB75D9C9;
        Mon,  4 May 2020 23:20:29 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: Fix a warning in __kvm_gfn_to_hva_cache_init()
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <20200504190526.84456-1-peterx@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <871e801d-10dc-f1d5-a4a5-efc6824ebd21@redhat.com>
Date:   Tue, 5 May 2020 09:20:27 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200504190526.84456-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/20 5:05 AM, Peter Xu wrote:
> GCC 10.0.1 gives me this warning when building KVM:
>=20
>    warning: =E2=80=98nr_pages_avail=E2=80=99 may be used uninitialized =
in this function [-Wmaybe-uninitialized]
>    2442 |  for ( ; start_gfn <=3D end_gfn; start_gfn +=3D nr_pages_avai=
l) {
>=20
> It should not happen, but silent it.
>=20
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 74bdb7bf3295..2da293885a67 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2425,7 +2425,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm=
_memslots *slots,
>   	gfn_t start_gfn =3D gpa >> PAGE_SHIFT;
>   	gfn_t end_gfn =3D (gpa + len - 1) >> PAGE_SHIFT;
>   	gfn_t nr_pages_needed =3D end_gfn - start_gfn + 1;
> -	gfn_t nr_pages_avail;
> +	gfn_t nr_pages_avail =3D 0;
>  =20
>   	/* Update ghc->generation before performing any error checks. */
>   	ghc->generation =3D slots->generation;
>=20

