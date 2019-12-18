Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37734123F46
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 06:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLRFxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 00:53:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23509 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725797AbfLRFxf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 00:53:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576648414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GWocaOhvv7iz+Y/q3X9mGWyFBvKPi09TUVpc/LIJHfQ=;
        b=ViFTtpDOQf/rnL9WvGjSorRVuBd/42DUouVAcEIb3vdqgyGwm3hsuFLASgO7/qxJI04+Uj
        tIwi6fTJSg3UfuBYJzP3R9t+ny3BDdgd+d8rNmK4BEK4/IewsgofZl6J0GSjrhOk90HC5s
        YMLIeK9wcLwffIWLkypR7OL9la3m/vw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-c8U9DMXXOUOp4b8hEnHBtg-1; Wed, 18 Dec 2019 00:53:32 -0500
X-MC-Unique: c8U9DMXXOUOp4b8hEnHBtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D09510054E3;
        Wed, 18 Dec 2019 05:53:31 +0000 (UTC)
Received: from [10.72.12.155] (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26C1C1001902;
        Wed, 18 Dec 2019 05:53:20 +0000 (UTC)
Subject: Re: [PATCH 1/1] drivers/vhost : Removes unnecessary 'else' in
 vhost_copy_from_user
To:     Leonardo Bras <leonardo@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191212211539.34578-1-leonardo@linux.ibm.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <86408a73-1acf-562b-75c0-08ca2728ed36@redhat.com>
Date:   Wed, 18 Dec 2019 13:53:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191212211539.34578-1-leonardo@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/12/13 =E4=B8=8A=E5=8D=885:15, Leonardo Bras wrote:
> There is no need for this else statement, given that if block will retu=
rn.
> This change is not supposed to change the output binary.
>
> It reduces identation level on most lines in this function, and also
> fixes an split string on vq_err().
>
> Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> ---
>   drivers/vhost/vhost.c | 50 +++++++++++++++++++++---------------------=
-
>   1 file changed, 24 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index f44340b41494..b23d1b74c32f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -824,34 +824,32 @@ static int vhost_copy_from_user(struct vhost_virt=
queue *vq, void *to,
>  =20
>   	if (!vq->iotlb)
>   		return __copy_from_user(to, from, size);
> -	else {
> -		/* This function should be called after iotlb
> -		 * prefetch, which means we're sure that vq
> -		 * could be access through iotlb. So -EAGAIN should
> -		 * not happen in this case.
> -		 */
> -		void __user *uaddr =3D vhost_vq_meta_fetch(vq,
> -				     (u64)(uintptr_t)from, size,
> -				     VHOST_ADDR_DESC);
> -		struct iov_iter f;
>  =20
> -		if (uaddr)
> -			return __copy_from_user(to, uaddr, size);
> +	/* This function should be called after iotlb
> +	 * prefetch, which means we're sure that vq
> +	 * could be access through iotlb. So -EAGAIN should
> +	 * not happen in this case.
> +	 */
> +	void __user *uaddr =3D vhost_vq_meta_fetch(vq,
> +			     (u64)(uintptr_t)from, size,
> +			     VHOST_ADDR_DESC);
> +	struct iov_iter f;


I think this will lead at least warnings from compiler.

Generally, I would not bother to make changes like this especially=20
consider it will bring troubles when trying to backporting fixes to=20
downstream in the future.

There're some more interesting things: e.g current metadata IOTLB=20
performance is bad for dynamic mapping since it will be reset each time=20
a new updating is coming.

We can optimize this by only reset the metadata IOTLB when the updating=20
is for metdata.

Want to try this?

Thanks


>  =20
> -		ret =3D translate_desc(vq, (u64)(uintptr_t)from, size, vq->iotlb_iov=
,
> -				     ARRAY_SIZE(vq->iotlb_iov),
> -				     VHOST_ACCESS_RO);
> -		if (ret < 0) {
> -			vq_err(vq, "IOTLB translation failure: uaddr "
> -			       "%p size 0x%llx\n", from,
> -			       (unsigned long long) size);
> -			goto out;
> -		}
> -		iov_iter_init(&f, READ, vq->iotlb_iov, ret, size);
> -		ret =3D copy_from_iter(to, size, &f);
> -		if (ret =3D=3D size)
> -			ret =3D 0;
> -	}
> +	if (uaddr)
> +		return __copy_from_user(to, uaddr, size);
> +
> +	ret =3D translate_desc(vq, (u64)(uintptr_t)from, size, vq->iotlb_iov,
> +			     ARRAY_SIZE(vq->iotlb_iov),
> +			     VHOST_ACCESS_RO);
> +	if (ret < 0) {
> +		vq_err(vq, "IOTLB translation failure: uaddr %p size 0x%llx\n",
> +		       from, (unsigned long long)size);
> +		goto out;
> +	}
> +	iov_iter_init(&f, READ, vq->iotlb_iov, ret, size);
> +	ret =3D copy_from_iter(to, size, &f);
> +	if (ret =3D=3D size)
> +		ret =3D 0;
>  =20
>   out:
>   	return ret;

