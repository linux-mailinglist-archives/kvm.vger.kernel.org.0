Return-Path: <kvm+bounces-72284-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAM7MXZMo2nW/AQAu9opvQ
	(envelope-from <kvm+bounces-72284-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 21:13:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0781C80C6
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 21:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 105DF3506E86
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 20:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE882E424F;
	Sat, 28 Feb 2026 19:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="hFMEmxJN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wTwSIaYD"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8C22C21F8
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 19:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308287; cv=none; b=UYvnai8pSJScitkJCu2hfh75Yw5tONgMbw3FOo2dAcwWj9f0rRK9rTG5Zvr6lJC+g9HLZzvjkqQ726KrJigI4Ru77Bd7rCX6bnBw1uxVes+REmu5e5MRYioCnKjGO/maAjkfVXTK+x0hJ1uUMv3qQ1/R1au5n5kG0T0T3V0CmLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308287; c=relaxed/simple;
	bh=Yo9H9uE3LfidqW1Bifx0VGO7JWn331iwNM5MhleuCY0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tw9p/46xg6HPEl129S24/CMKsBsUCkLWu4ErRkmeecClejCoawDH5QbKml4ecf58BfsM2cFW9CZeFMI4qw2SaFQp9GutdZ8blMSpy5W/AQPEbaSwfYJ2BpVM6PP6WBVjkriG4vpUk7r8DUTzplGv42RUqXqHIW12k+zO/uxXIX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=hFMEmxJN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wTwSIaYD; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 484AF140002C;
	Sat, 28 Feb 2026 14:51:23 -0500 (EST)
Received: from phl-imap-18 ([10.202.2.89])
  by phl-compute-02.internal (MEProxy); Sat, 28 Feb 2026 14:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772308283;
	 x=1772394683; bh=Xy2WUE6BOrT9WCbqR3HmTt56Y/DQe/Nep1hJay8YzHU=; b=
	hFMEmxJNUie47YthPIXjRHIuF9NwlSx+4WAE4c+qUPItWuLW8X6Dc1b1aG65nmu+
	DvV2Q3jvhZ9NL5gVRK9V8c4e4KOapVN07KS955JH6NCVGabdr7BwKsoCFwv3vh/5
	OxmJSQ+/R4Mim6d+ovk8knRzCP3z3rg6FS7nEQmwCK3Jh95SMgecY88iZ1KvhCEI
	UUgfGKQcBrtJhNNTvTwWMFvcvOwic5ns+dj+sBDHUoW3QxMbrT381qLScFGlDEEQ
	Qo7mn0CUhTRMo6NfrkpgPwlR+kiJKg9fyFeYJ6wp9K/0dTMPiwIeRoSl0J17YCJa
	RjIJ/OCrTRVHxOp6rpZrWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772308283; x=
	1772394683; bh=Xy2WUE6BOrT9WCbqR3HmTt56Y/DQe/Nep1hJay8YzHU=; b=w
	TwSIaYDm4+nl9sQRgZ6WA0ibKg4nsjk8WcuEZtAXAeBP5EY9uwrBbIFtUBw36XWn
	8QNxzXO01WDKIJ3bhYC/itVqR4bMpDSQA6zdINsvjEjA7Re/DERnTR/pUuNRj6CJ
	5Lrv44hmC+1yOHUYPUZUnKMpMzeLH5/zvnSUP0/tgTnAvu4s3RaQtGTCP/4z1arL
	BGL4L62eLsjc+TaTPV0WNigH/GKCwVWrTiKRX7y8qcsArQpDP8LaHr8Vn1WZlqKC
	LmteUediS1YSd9Nu1mtxpdTT7Xm6lrD2R2sKzzEyAceNFzsNFs+DV3p3sNWccGsg
	BTN8DnZiADt4kEbRqr7qA==
X-ME-Sender: <xms:OkejaRd0bZaSvbT1AyW-aV2pTI_CwfT1bAXRYGDTcx9DPoYeuo4UGA>
    <xme:OkejaaDrqTXe7huZZddCJ0BC2DK72As_QYp3pR4ns_F5cJccvmFVHdAF4qaeIPEWJ
    216GStWjnCANafKNWGulhDyqVl-3deKUlud6NomSVgc8Mx_y0wlhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvhedvjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehlvgig
    ucghihhllhhirghmshhonhdfuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtf
    frrghtthgvrhhnpefgfeeflefggfffveffteetiedvtedtgfdvieevfeejfeefffevteej
    tedufffgveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepuddvpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehlihhulhhonhhgfhgrnhhgsehhuhgrfigvih
    drtghomhdprhgtphhtthhopehgihhovhgrnhhnihdrtggrsghiugguuhesihhnthgvlhdr
    tghomhdprhgtphhtthhopehkvghvihhnrdhtihgrnhesihhnthgvlhdrtghomhdprhgtph
    htthhopegrvhhihhgrihhhsehnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgsehn
    vhhiughirgdrtghomhdprhgtphhtthhopehkfigrnhhkhhgvuggvsehnvhhiughirgdrtg
    homhdprhgtphhtthhopehlvghonhhrohesnhhvihguihgrrdgtohhmpdhrtghpthhtohep
    mhgrohhrghesnhhvihguihgrrdgtohhmpdhrtghpthhtohephihishhhrghihhesnhhvih
    guihgrrdgtohhm
X-ME-Proxy: <xmx:OkejaXAUYD6QiwIl_X5e108KnHyFWW3VpF_S-n5AOWHRjpicZIUJmQ>
    <xmx:OkejafGQMwv95iHXJ9THO6uq-H66PMvRIpDpwMFXEfZLPVggn_8ylQ>
    <xmx:OkejaR3T4_t_Z2N4vlJkycfdtDEgiM8IZ_gOGUWJ_VJx-lxZqR45rg>
    <xmx:OkejaQPDZ99te3ZTcMZ7_5vbet-Bl1jj0QgwwYOcAr1wxD1djg6LiA>
    <xmx:O0ejaZYorQbyIjAkNbb57sxS0XO15V2rAje2Bj8Vk6A8V170bZpVyjFn>
Feedback-ID: i03f14258:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7E69915C008E; Sat, 28 Feb 2026 14:51:22 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AuobAVvnblXw
Date: Sat, 28 Feb 2026 12:51:02 -0700
From: "Alex Williamson" <alex@shazbot.org>
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: "Alex Williamson" <alex.williamson@redhat.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>, kvm@vger.kernel.org,
 "Kevin Tian" <kevin.tian@intel.com>, joao.m.martins@oracle.com,
 leonro@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
 liulongfang@huawei.com, giovanni.cabiddu@intel.com,
 kwankhede <kwankhede@nvidia.com>
Message-Id: <f58493e4-941b-4e62-b0a2-9fe9ba5bae4c@app.fastmail.com>
In-Reply-To: <20260227134235.0affe244@shazbot.org>
References: <20260224082019.25772-1-yishaih@nvidia.com>
 <20260224082019.25772-3-yishaih@nvidia.com>
 <20260227134235.0affe244@shazbot.org>
Subject: Re: [PATCH vfio 2/6] vfio: Add support for
 VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.15 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72284-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email,app.fastmail.com:mid]
X-Rspamd-Queue-Id: 4A0781C80C6
X-Rspamd-Action: no action

On Fri, Feb 27, 2026, at 1:42 PM, Alex Williamson wrote:
> On Tue, 24 Feb 2026 10:20:15 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations don't
>> assign info.flags before copy_to_user().
>> 
>> Because they copy the struct in from userspace first, this effectively
>> echoes userspace-provided flags back as output, preventing the field
>> from being used to report new reliable data from the drivers.
>> 
>> Add support for a new device feature named
>> VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.
>> 
>> On SET, enables the v2 pre_copy_info behaviour, where the
>> vfio_precopy_info.flags is a valid output field.
>> 
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c |  1 +
>>  drivers/vfio/vfio_main.c         | 20 ++++++++++++++++++++
>>  include/linux/vfio.h             |  1 +
>>  3 files changed, 22 insertions(+)
>> 
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index d43745fe4c84..e22280f53ebf 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -736,6 +736,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>>  #endif
>>  	vfio_pci_core_disable(vdev);
>>  
>> +	core_vdev->precopy_info_flags_fix = 0;
>>  	vfio_pci_dma_buf_cleanup(vdev);
>>  
>>  	mutex_lock(&vdev->igate);
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index 742477546b15..2243a6eb5547 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -964,6 +964,23 @@ vfio_ioctl_device_feature_migration_data_size(struct vfio_device *device,
>>  	return 0;
>>  }
>>  
>> +static int
>> +vfio_ioctl_device_feature_migration_precopy_info_v2(struct vfio_device *device,
>> +						    u32 flags, size_t argsz)
>> +{
>> +	int ret;
>> +
>> +	if (!(device->migration_flags & VFIO_MIGRATION_PRE_COPY))
>> +		return -EINVAL;
>> +
>> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
>
> This should be VFIO_DEVICE_FEATURE_SET | VFIO_DEVICE_FEATURE_PROBE.
> Probe support is essentially free, but we've not been good about
> including it.  Thanks,

Sorry, ignore this, only GET and SET are checked for supported ops, PROBE is implicitly supported.  Thanks,

Alex


>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	device->precopy_info_flags_fix = 1;
>> +	return 0;
>> +}
>> +
>>  static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>>  					       u32 flags, void __user *arg,
>>  					       size_t argsz)
>> @@ -1251,6 +1268,9 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>>  		return vfio_ioctl_device_feature_migration_data_size(
>>  			device, feature.flags, arg->data,
>>  			feature.argsz - minsz);
>> +	case VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2:
>> +		return vfio_ioctl_device_feature_migration_precopy_info_v2(
>> +			device, feature.flags, feature.argsz - minsz);
>>  	default:
>>  		if (unlikely(!device->ops->device_feature))
>>  			return -ENOTTY;
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index e90859956514..3ff21374aeee 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -52,6 +52,7 @@ struct vfio_device {
>>  	struct vfio_device_set *dev_set;
>>  	struct list_head dev_set_list;
>>  	unsigned int migration_flags;
>> +	u8 precopy_info_flags_fix;
>>  	struct kvm *kvm;
>>  
>>  	/* Members below here are private, not for driver use */

