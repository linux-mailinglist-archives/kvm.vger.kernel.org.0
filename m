Return-Path: <kvm+bounces-64750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D9FC8BFE8
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:17:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E822A3A1255
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 21:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C3A27F736;
	Wed, 26 Nov 2025 21:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cjfb+O2k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15432264CF
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 21:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764191828; cv=none; b=HtqL3o/58fwvjB7PRw3HZWPpIWydNg7MM3TrThBMJSJrZDLvE58lInhF/P40HrZ70neAbB3XJ85wQBuh3MJSiQSgBLiAlk0mxV2XIAVslOqCv3IdsJdhh30FuM9TLDLsNQqsLw9P0WTGkXSgZDE3IM7kzkv/wDg1iMynpF6S610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764191828; c=relaxed/simple;
	bh=Tu9UoJab2N9aOFK02uU2NH64dAR7qMBaHBTPor6ABm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VE+T+nH2qh7hK2QWSUQoDFT8y6XAtLpUomn1Ih53MnAxvYTij1v0kKPlQ1OfznNpmMH4Phxu8ox9N7fdqT/Epuui7hgIPGFKLU+MR/McxbotUtweHvrLlXRyTOKbYVpZO9QDM32VZtxx0GXizskw1/V/4ftyl+WV9Ewuh0RGstw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cjfb+O2k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764191824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bX/0i7tj4y+cgcP++a7Y4BBxU58ei/TXceewZURiUM=;
	b=cjfb+O2khbN6XVcQZjZpGLPX4PKrOcSob7iS+lea4qfOb15ruyYGqCjMn7pWKdIn9qFYVu
	ySvvprqFF5paU6/a1LjID6cZ9+Gk8iYJkoner7HXP2OW5NXEjNe8xK3SDRvntEwIpd604c
	59aLFGdfa0Jp/sn48csL9VKbj9RVN2k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-OSoQCYNGNvK3Jpe5w-JuHA-1; Wed,
 26 Nov 2025 16:17:03 -0500
X-MC-Unique: OSoQCYNGNvK3Jpe5w-JuHA-1
X-Mimecast-MFC-AGG-ID: OSoQCYNGNvK3Jpe5w-JuHA_1764191822
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C749419560B0;
	Wed, 26 Nov 2025 21:17:01 +0000 (UTC)
Received: from localhost (unknown [10.2.16.34])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AF10F1800451;
	Wed, 26 Nov 2025 21:17:00 +0000 (UTC)
Date: Wed, 26 Nov 2025 16:03:13 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: virtualization@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	netdev@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: improve RCU read sections around
 vhost_vsock_get()
Message-ID: <20251126210313.GA499503@fedora>
References: <20251126133826.142496-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="g1JPwMl4XCtaMV09"
Content-Disposition: inline
In-Reply-To: <20251126133826.142496-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--g1JPwMl4XCtaMV09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 02:38:26PM +0100, Stefano Garzarella wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
>=20
> vhost_vsock_get() uses hash_for_each_possible_rcu() to find the
> `vhost_vsock` associated with the `guest_cid`. hash_for_each_possible_rcu=
()
> should only be called within an RCU read section, as mentioned in the
> following comment in include/linux/rculist.h:
>=20
> /**
>  * hlist_for_each_entry_rcu - iterate over rcu list of given type
>  * @pos:	the type * to use as a loop cursor.
>  * @head:	the head for your list.
>  * @member:	the name of the hlist_node within the struct.
>  * @cond:	optional lockdep expression if called from non-RCU protection.
>  *
>  * This list-traversal primitive may safely run concurrently with
>  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
>  * as long as the traversal is guarded by rcu_read_lock().
>  */
>=20
> Currently, all calls to vhost_vsock_get() are between rcu_read_lock()
> and rcu_read_unlock() except for calls in vhost_vsock_set_cid() and
> vhost_vsock_reset_orphans(). In both cases, the current code is safe,
> but we can make improvements to make it more robust.
>=20
> About vhost_vsock_set_cid(), when building the kernel with
> CONFIG_PROVE_RCU_LIST enabled, we get the following RCU warning when the
> user space issues `ioctl(dev, VHOST_VSOCK_SET_GUEST_CID, ...)` :
>=20
>   WARNING: suspicious RCU usage
>   6.18.0-rc7 #62 Not tainted
>   -----------------------------
>   drivers/vhost/vsock.c:74 RCU-list traversed in non-reader section!!
>=20
>   other info that might help us debug this:
>=20
>   rcu_scheduler_active =3D 2, debug_locks =3D 1
>   1 lock held by rpc-libvirtd/3443:
>    #0: ffffffffc05032a8 (vhost_vsock_mutex){+.+.}-{4:4}, at: vhost_vsock_=
dev_ioctl+0x2ff/0x530 [vhost_vsock]
>=20
>   stack backtrace:
>   CPU: 2 UID: 0 PID: 3443 Comm: rpc-libvirtd Not tainted 6.18.0-rc7 #62 P=
REEMPT(none)
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-7.fc=
42 06/10/2025
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x75/0xb0
>    dump_stack+0x14/0x1a
>    lockdep_rcu_suspicious.cold+0x4e/0x97
>    vhost_vsock_get+0x8f/0xa0 [vhost_vsock]
>    vhost_vsock_dev_ioctl+0x307/0x530 [vhost_vsock]
>    __x64_sys_ioctl+0x4f2/0xa00
>    x64_sys_call+0xed0/0x1da0
>    do_syscall_64+0x73/0xfa0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    ...
>    </TASK>
>=20
> This is not a real problem, because the vhost_vsock_get() caller, i.e.
> vhost_vsock_set_cid(), holds the `vhost_vsock_mutex` used by the hash
> table writers. Anyway, to prevent that warning, add lockdep_is_held()
> condition to hash_for_each_possible_rcu() to verify that either the
> caller is in an RCU read section or `vhost_vsock_mutex` is held when
> CONFIG_PROVE_RCU_LIST is enabled; and also clarify the comment for
> vhost_vsock_get() to better describe the locking requirements and the
> scope of the returned pointer validity.
>=20
> About vhost_vsock_reset_orphans(), currently this function is only
> called via vsock_for_each_connected_socket(), which holds the
> `vsock_table_lock` spinlock (which is also an RCU read-side critical
> section). However, add an explicit RCU read lock there to make the code
> more robust and explicit about the RCU requirements, and to prevent
> issues if the calling context changes in the future or if
> vhost_vsock_reset_orphans() is called from other contexts.
>=20
> Fixes: 834e772c8db0 ("vhost/vsock: fix use-after-free in network stack ca=
llers")
> Cc: stefanha@redhat.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vsock.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--g1JPwMl4XCtaMV09
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmknaxEACgkQnKSrs4Gr
c8gttwf/ZJ0Ara63zkxpEWCtgFN92fZknjdxSfwNZ2z6NsKZDwPYCnI5BYYU+7aN
RYICx39augMRLy430bN6PQJjaMJsGeAWuXegBNEKPe7U4lCjCKiNoU3sgpMbr/Rj
iyFJLkTK4umOp04jeODZBVDjd5vRp9dUvu1/zkuDriRn7HWry51Rbk/Ib1F3h9IP
qK5iVrjTRXliuSAtnokc0Kk1Ff41kyZnb6bLK1obA5h93W2RZIppBj2jLcrX8PLF
I0z2g79tY2zw03KhtvE29Faf5K6FD92KTkdZEa5K2oQkosI4b+56MmoQMyhxRkgp
M839LQbIdZnpzGHw6Liu9a3FC9i9HA==
=vy3f
-----END PGP SIGNATURE-----

--g1JPwMl4XCtaMV09--


