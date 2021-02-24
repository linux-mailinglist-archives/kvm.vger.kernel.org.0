Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF3323B06
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 12:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbhBXLGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 06:06:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234980AbhBXLET (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 06:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614164570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/xWki6YKPwpSXb+1Z2/M1jfoM3KeHUEQjKvWUh92Oo4=;
        b=Cx1vNNh5zR1JY4TnKSEogXDyeZ5R+Psu61YRULVigt3lm+0rAZFjnibs6YuWoC9H7MPfWx
        LI/LuWgS4Kaay1lfyPNEkR9N+kyGwUcnBcGRw6tCS6Hz/amrncW4vB4SAbnqEKCEIaRNty
        PPW7UP/Xf7FvVwD5BLQvs01AWp1qJQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-aPjiGJMTMTO7Xjjfmi3C_g-1; Wed, 24 Feb 2021 06:02:19 -0500
X-MC-Unique: aPjiGJMTMTO7Xjjfmi3C_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96E632FD00;
        Wed, 24 Feb 2021 11:02:18 +0000 (UTC)
Received: from localhost (ovpn-115-137.ams2.redhat.com [10.36.115.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4088F60C5F;
        Wed, 24 Feb 2021 11:02:15 +0000 (UTC)
Date:   Wed, 24 Feb 2021 11:02:14 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Subject: Re: [RFC v3 3/5] KVM: implement wire protocol
Message-ID: <YDYyNr5LanXq0T+H@stefanha-x1.localdomain>
References: <cover.1613828726.git.eafanasova@gmail.com>
 <dad3d025bcf15ece11d9df0ff685e8ab0a4f2edd.1613828727.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jn5JHJiO97RvjVFm"
Content-Disposition: inline
In-Reply-To: <dad3d025bcf15ece11d9df0ff685e8ab0a4f2edd.1613828727.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--jn5JHJiO97RvjVFm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 21, 2021 at 03:04:39PM +0300, Elena Afanasova wrote:
> +static bool
> +pack_cmd(struct ioregionfd_cmd *cmd, u64 offset, u64 len, u8 opt, u8 resp,
> +	 u64 user_data, const void *val)
> +{
> +	switch (len) {
> +	case 0:
> +		break;

The 0 case might be non-obvious. A comment would be nice:

/* FAST_MMIO does not specify a length */

> +	case 1:
> +		cmd->size_exponent = IOREGIONFD_SIZE_8BIT;
> +		break;
> +	case 2:
> +		cmd->size_exponent = IOREGIONFD_SIZE_16BIT;
> +		break;
> +	case 4:
> +		cmd->size_exponent = IOREGIONFD_SIZE_32BIT;
> +		break;
> +	case 8:
> +		cmd->size_exponent = IOREGIONFD_SIZE_64BIT;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	if (val)
> +		memcpy(&cmd->data, val, len);
> +	cmd->user_data = user_data;
> +	cmd->offset = offset;
> +	cmd->cmd = opt;
> +	cmd->resp = resp;
> +
> +	return true;
> +}
> +
> +enum {

A comment would help explain why the enum is needed:

/* A way to remember our state when interrupted by a signal */

> +	SEND_CMD,
> +	GET_REPLY,
> +	COMPLETE
> +};

--jn5JHJiO97RvjVFm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA2MjYACgkQnKSrs4Gr
c8h+PAf+JkMlmnmsa7rX+AZXInPs+NXHzNKac0lasCrBcYTaB85WgXL1/Tb5cdQD
A8uEF53g3gP/38HXPXCn30RFMWsjkCrlBxQSiMLYvSr/G7dDJsSn3E7E3d6mXba7
nwshaOAE3JVGgIWXiQkm8Nqc8tmjSt+zftFVUXrGUFA/CMijsQMlo9onfIIiAQM7
tJZ2RDJgN0Ne0aU9uKsadTOHM2OP8Xm6OL6x5vNfddaZDzhpGvL4pyWILrg4GwCN
YiCOvYX4yT0ptz+AuRsW2vxi7qqfNiXCqBuYJTizTUZExgRRlEivkqbe32AcbcEo
a8gmnFTJmTiFPCNkyLex7LIkYgQxoQ==
=ZFbx
-----END PGP SIGNATURE-----

--jn5JHJiO97RvjVFm--

