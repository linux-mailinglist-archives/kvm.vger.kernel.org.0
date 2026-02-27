Return-Path: <kvm+bounces-72227-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KDHALIsComnPyAQAu9opvQ
	(envelope-from <kvm+bounces-72227-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:46:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5245E1BDE80
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03D6430FF4A2
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A044744D02F;
	Fri, 27 Feb 2026 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="PfivyYGE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HSc/BJ8Y"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E67844DB64
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 20:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772224962; cv=none; b=djLHj3tcXe1Tiysj5AFsko2eAfSWA4MTwW/crnQ0IDD0ZP3kFsUbe4P3aTP0yJiROKdqvih3ieAf+Wh0/Nrkkl5FFWMCW+Y9m0UB6J4Lg8CX4zHCxkbT/w3NvGwuj5RDHJSQOfsej4vgRRY6WOwqLAr2T8SUHCPtR545N7n1LB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772224962; c=relaxed/simple;
	bh=YuaHD9/+da9dblL+sxe3C84j02lyK4ns39nCLV7DAa4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8aeUsHvkrpsX0aAI0PwZDR+HRHRFgwL2HMoGMot2ArBOz3uYo8Jh9EYzWneDVUXA//wyBzjWGyKXXlAE5ZU8W3KhB2Dt4iVcaYZeAyVDiQHhnYLxo2m8Go9606KJUGdF8s2Uk5DpU8PYgvH4MC/8oHmF1JKg4qofEdZrUC+i6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=PfivyYGE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HSc/BJ8Y; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 3F93B1D00162;
	Fri, 27 Feb 2026 15:42:38 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 27 Feb 2026 15:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772224958;
	 x=1772311358; bh=5r8g0VD90mt08uR3M1jsWCvBzXDncfTKEMIWpry1UR0=; b=
	PfivyYGE2GcLAT8PLNlbVjQhkcxG1DVOvAYXjToOmIMFkHSPj70OD6WIQz9+C1BD
	fQDLoMFLsOa6ca1v+KSY3vMSQ8Q6pcNVKBeI25EsaBqNZO3pNViKwkYVXxEQ7ZDV
	0aMjIhHLNJS10ehnkGRITlkRQPfm3e4lZlclEKXV4XBt+uOBfqi9AmGJfOwXjNBk
	0eZBo/60n+sdJUmD+73lzo+/UwgaLImi482gRZOwjDjagIFD7X+AnpmdTyjKz+oo
	fgB/U725TFW5+1TXV4MnwZ9PTjs3PvJvt6dTxEB+E86byDOtCGOokd5WLb8BEGB+
	oslVHi0o+7MuNKKjUKMfFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772224958; x=
	1772311358; bh=5r8g0VD90mt08uR3M1jsWCvBzXDncfTKEMIWpry1UR0=; b=H
	Sc/BJ8YG/SGh5nxG1ztfty+mGkOpowcgVvlfMaQGwIXFgobLI9xrgTnV7EZu+73u
	7SkFnyHfiZsGFKAoWNkJcolheKn+VaZhAQU9KbHJuc8SRukLMUGn+cRc2rQMqulf
	QAs4Et0ZvWuNmLZ9aRMMSpepYc7ZbtyVz4aSIFmDK6xEZd2MzDQsgAqS1UyDv5JJ
	eg7RJdzBqwrMBRoX74UQqWa+pRe/eMtFR4MR4mBurRsPhtqvRPKZQAca4adTWqQS
	MyUMWliM9tvM7RGH+5h24ZJgFiBe73YD85q5SF44m75aolH24KFQxCTzkQqrZeGI
	rkibYY4ja/YPQTVHCKdKQ==
X-ME-Sender: <xms:vQGiacyn0_alp7vmSdd16_RAJwx7qAjEG2dMYr_zYaF8qx9L53FOYQ>
    <xme:vQGiaWo4WivWlAhcAz8waXcb687_qvMZ7sI7aID7o9PpysdHDTm6nkWq7gu5lXux6
    atOJMMJ7gHTk4GjYMuHrbLrrDy_YdAOA8IYpn5gEVa2LlvTVqz9yq0>
X-ME-Received: <xmr:vQGiaaliwe5KGkSRzIbxXotolP7aY1JtEm8iuJ2Ra7hFiiTy2J2zQjwhnmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelleelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepudefpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopeihihhshhgrihhhsehnvhhiughirgdrtghomhdprh
    gtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdprhgt
    phhtthhopehjghhgsehnvhhiughirgdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrh
    drkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghl
    rdgtohhmpdhrtghpthhtohepjhhorghordhmrdhmrghrthhinhhssehorhgrtghlvgdrtg
    homhdprhgtphhtthhopehlvghonhhrohesnhhvihguihgrrdgtohhmpdhrtghpthhtohep
    mhgrohhrghesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprghvihhhrghihhesnhhvih
    guihgrrdgtohhm
X-ME-Proxy: <xmx:vQGiaYV3NE6v-WflkXiLzZBurqKdOAqd-jnRt1Z31txTWw7XJvnVfw>
    <xmx:vQGiaWpsPo2OxT-oJLIb1sRz6Z-eO87iH4YMfLt0O7b8FNprLAr4sA>
    <xmx:vQGiaRWxXSRline533BFFTgYaYKPzoSQoMP7AzNdAYz_mVReo-_jtA>
    <xmx:vQGiafEmR5jm-P-PQJEMQatG_i3VFEqejt3MXuwYoeORQzefNPlBig>
    <xmx:vgGiaY6woS6_pgOUVlPeW18fwicNCVnhLqMy-IJmsKS3jvoscdNTfvK3>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 15:42:36 -0500 (EST)
Date: Fri, 27 Feb 2026 13:42:35 -0700
From: Alex Williamson <alex@shazbot.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
 <kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
 <maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
 <giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>, alex@shazbot.org
Subject: Re: [PATCH vfio 2/6] vfio: Add support for
 VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2
Message-ID: <20260227134235.0affe244@shazbot.org>
In-Reply-To: <20260224082019.25772-3-yishaih@nvidia.com>
References: <20260224082019.25772-1-yishaih@nvidia.com>
	<20260224082019.25772-3-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-72227-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim,nvidia.com:email]
X-Rspamd-Queue-Id: 5245E1BDE80
X-Rspamd-Action: no action

On Tue, 24 Feb 2026 10:20:15 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations don't
> assign info.flags before copy_to_user().
> 
> Because they copy the struct in from userspace first, this effectively
> echoes userspace-provided flags back as output, preventing the field
> from being used to report new reliable data from the drivers.
> 
> Add support for a new device feature named
> VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.
> 
> On SET, enables the v2 pre_copy_info behaviour, where the
> vfio_precopy_info.flags is a valid output field.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c |  1 +
>  drivers/vfio/vfio_main.c         | 20 ++++++++++++++++++++
>  include/linux/vfio.h             |  1 +
>  3 files changed, 22 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index d43745fe4c84..e22280f53ebf 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -736,6 +736,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  #endif
>  	vfio_pci_core_disable(vdev);
>  
> +	core_vdev->precopy_info_flags_fix = 0;
>  	vfio_pci_dma_buf_cleanup(vdev);
>  
>  	mutex_lock(&vdev->igate);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 742477546b15..2243a6eb5547 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -964,6 +964,23 @@ vfio_ioctl_device_feature_migration_data_size(struct vfio_device *device,
>  	return 0;
>  }
>  
> +static int
> +vfio_ioctl_device_feature_migration_precopy_info_v2(struct vfio_device *device,
> +						    u32 flags, size_t argsz)
> +{
> +	int ret;
> +
> +	if (!(device->migration_flags & VFIO_MIGRATION_PRE_COPY))
> +		return -EINVAL;
> +
> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);

This should be VFIO_DEVICE_FEATURE_SET | VFIO_DEVICE_FEATURE_PROBE.
Probe support is essentially free, but we've not been good about
including it.  Thanks,

Alex

> +	if (ret != 1)
> +		return ret;
> +
> +	device->precopy_info_flags_fix = 1;
> +	return 0;
> +}
> +
>  static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  					       u32 flags, void __user *arg,
>  					       size_t argsz)
> @@ -1251,6 +1268,9 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  		return vfio_ioctl_device_feature_migration_data_size(
>  			device, feature.flags, arg->data,
>  			feature.argsz - minsz);
> +	case VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2:
> +		return vfio_ioctl_device_feature_migration_precopy_info_v2(
> +			device, feature.flags, feature.argsz - minsz);
>  	default:
>  		if (unlikely(!device->ops->device_feature))
>  			return -ENOTTY;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e90859956514..3ff21374aeee 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -52,6 +52,7 @@ struct vfio_device {
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> +	u8 precopy_info_flags_fix;
>  	struct kvm *kvm;
>  
>  	/* Members below here are private, not for driver use */


