Return-Path: <kvm+bounces-65551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3E6CB076F
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 16:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C085E30A0F9E
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 15:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2CC2FF156;
	Tue,  9 Dec 2025 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z4G9aKgr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4253182B7
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765295347; cv=none; b=j3tXkoSPYvj+93ilShtsc+rrmQ6ugSXZ+cR4KEEEEtUdTU+RkKlBX8agDcTcz5qxcaSnazcG4k27o1M0N2+RXBm8DGQqrJSw/M19JlBwi/fRyq28M7qSlH2qHi7sb28LyJHoEtfvr0RJzahPwqvOuM4KfB1sYretO7wsnpQFqHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765295347; c=relaxed/simple;
	bh=sM81+F9tbUyUYaayIVkpNYHexGA4M47J0rZR5oJjscI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYMLfMzQsvMzfmBq9w8RHRktGoycymvUAEH07W6UX5hEbc8Ew16M4Avui3bQcl/xekE+tOJGcrWqQ73V+Iju1yIdRKiYgrUXvIf46mgcY+SgHNO8TEwtPB9eTj8XgveEhQ17ZG5NEFlnezR828rSAiVyaSzOXyUJ1OjjzEJz4LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z4G9aKgr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765295344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/uNDxO/YckqKTHtoTj0Ga8z2Ov6f3Kk6XygAXetz1+8=;
	b=Z4G9aKgr/T61+AhrQ4CbrKrC1eN9ZC8fMihVhpRQrNKCBjz9ZeWYob5kSGHbFEdAElRkfj
	yjgAl6BtqpLsWvYQiXnkNOKNPHvI37mPo81uClMtvlhVhoopBGOvE73743YKc1ysGgYNP+
	Qb0vtm+hevUfsKtaYB0mOkitQ1kxNg8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-4NB1rnVoNrGTuMfmGmvr6A-1; Tue,
 09 Dec 2025 10:49:01 -0500
X-MC-Unique: 4NB1rnVoNrGTuMfmGmvr6A-1
X-Mimecast-MFC-AGG-ID: 4NB1rnVoNrGTuMfmGmvr6A_1765295340
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 330721800378;
	Tue,  9 Dec 2025 15:49:00 +0000 (UTC)
Received: from localhost (unknown [10.2.17.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 911CE19560A7;
	Tue,  9 Dec 2025 15:48:59 +0000 (UTC)
Date: Tue, 9 Dec 2025 10:48:58 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: mst@redhat.com, sgarzare@redhat.com,
	virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
	oren@nvidia.com, aevdaev@nvidia.com, aaptel@nvidia.com
Subject: Re: [PATCH v2 1/1] virtio: add driver_override support
Message-ID: <20251209154858.GA1386932@fedora>
References: <20251208220908.9250-1-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r5W3FOUm/YTozNI8"
Content-Disposition: inline
In-Reply-To: <20251208220908.9250-1-mgurtovoy@nvidia.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--r5W3FOUm/YTozNI8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2025 at 12:09:08AM +0200, Max Gurtovoy wrote:
> Add support for the 'driver_override' attribute to Virtio devices. This
> allows users to control which Virtio bus driver binds to a given Virtio
> device.
>=20
> If 'driver_override' is not set, the existing behavior is preserved and
> devices will continue to auto-bind to the first matching Virtio bus
> driver.
>=20
> Tested with virtio blk device (virtio core and pci drivers are loaded):
>=20
>   $ modprobe my_virtio_blk
>=20
>   # automatically unbind from virtio_blk driver and override + bind to
>   # my_virtio_blk driver.
>   $ driverctl -v -b virtio set-override virtio0 my_virtio_blk

Why a second virtio-blk driver implementation? Please explain the use
case.

Thanks,
Stefan

> In addition, driverctl saves the configuration persistently under
> /etc/driverctl.d/.
>=20
> Signed-off-by: Avraham Evdaev <aevdaev@nvidia.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>=20
> changes from v1:
>  - use !strcmp() to compare strings (MST)
>  - extend commit msg with example (MST)
>=20
> ---
>  drivers/virtio/virtio.c | 34 ++++++++++++++++++++++++++++++++++
>  include/linux/virtio.h  |  4 ++++
>  2 files changed, 38 insertions(+)
>=20
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index a09eb4d62f82..993dc928be49 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -61,12 +61,41 @@ static ssize_t features_show(struct device *_d,
>  }
>  static DEVICE_ATTR_RO(features);
> =20
> +static ssize_t driver_override_store(struct device *_d,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct virtio_device *dev =3D dev_to_virtio(_d);
> +	int ret;
> +
> +	ret =3D driver_set_override(_d, &dev->driver_override, buf, count);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +
> +static ssize_t driver_override_show(struct device *_d,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct virtio_device *dev =3D dev_to_virtio(_d);
> +	ssize_t len;
> +
> +	device_lock(_d);
> +	len =3D sysfs_emit(buf, "%s\n", dev->driver_override);
> +	device_unlock(_d);
> +
> +	return len;
> +}
> +static DEVICE_ATTR_RW(driver_override);
> +
>  static struct attribute *virtio_dev_attrs[] =3D {
>  	&dev_attr_device.attr,
>  	&dev_attr_vendor.attr,
>  	&dev_attr_status.attr,
>  	&dev_attr_modalias.attr,
>  	&dev_attr_features.attr,
> +	&dev_attr_driver_override.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(virtio_dev);
> @@ -88,6 +117,10 @@ static int virtio_dev_match(struct device *_dv, const=
 struct device_driver *_dr)
>  	struct virtio_device *dev =3D dev_to_virtio(_dv);
>  	const struct virtio_device_id *ids;
> =20
> +	/* Check override first, and if set, only use the named driver */
> +	if (dev->driver_override)
> +		return !strcmp(dev->driver_override, _dr->name);
> +
>  	ids =3D drv_to_virtio(_dr)->id_table;
>  	for (i =3D 0; ids[i].device; i++)
>  		if (virtio_id_match(dev, &ids[i]))
> @@ -582,6 +615,7 @@ void unregister_virtio_device(struct virtio_device *d=
ev)
>  {
>  	int index =3D dev->index; /* save for after device release */
> =20
> +	kfree(dev->driver_override);
>  	device_unregister(&dev->dev);
>  	virtio_debug_device_exit(dev);
>  	ida_free(&virtio_index_ida, index);
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index db31fc6f4f1f..418bb490bdc6 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -138,6 +138,9 @@ struct virtio_admin_cmd {
>   * @config_lock: protects configuration change reporting
>   * @vqs_list_lock: protects @vqs.
>   * @dev: underlying device.
> + * @driver_override: driver name to force a match; do not set directly,
> + *                   because core frees it; use driver_set_override() to
> + *                   set or clear it.
>   * @id: the device type identification (used to match it with a driver).
>   * @config: the configuration ops for this device.
>   * @vringh_config: configuration ops for host vrings.
> @@ -158,6 +161,7 @@ struct virtio_device {
>  	spinlock_t config_lock;
>  	spinlock_t vqs_list_lock;
>  	struct device dev;
> +	const char *driver_override;
>  	struct virtio_device_id id;
>  	const struct virtio_config_ops *config;
>  	const struct vringh_config_ops *vringh_config;
> --=20
> 2.18.1
>=20

--r5W3FOUm/YTozNI8
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmk4ROoACgkQnKSrs4Gr
c8h5ugf+JodsqSFNoUTRWXfNSu/KBJtkgSFLEe7HYWQp5IvoL+5yMYJdjkaPJ/Gt
d+okVWOIU5+Qtkcjn6E4Xp8eQSYQlmGr6zm4d+4Tb0hkv30wdZg74VyxY/Z40He0
NLqVB350r1yu+R7Hv64d45bwqlFiwZbrlb8tRVjMIdUXg8FbGS6pux+M35JPVlzJ
DvgOfO8aj2Qk/JeHXQb+FNJdOxlExpuCLjalqLuzuD06/96KEjwX5DvySy60O61f
506FwttYBDNZcI+slZL7eEr/6YRVeF7eH5M5mnJCPXByiUJOOB21mvgtfMMvF6H8
paNn3o7AWUrwze8mrTlqJ2/HGElviA==
=6wr4
-----END PGP SIGNATURE-----

--r5W3FOUm/YTozNI8--


