Return-Path: <kvm+bounces-72228-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IUwANwBomnPyAQAu9opvQ
	(envelope-from <kvm+bounces-72228-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:43:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AF31BDE23
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A3FDE3094161
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FDD477E47;
	Fri, 27 Feb 2026 20:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="pmWFXljH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TaB8JKzl"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B19450905
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 20:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772224970; cv=none; b=a7QCh0MNalWKaFNyIA0Wtm8PZbfCxzTgy8XhVV9uh0B10+P+1bttAnRnIwaVGfVczCZoPolU+h4YyKDCnnPqysagl6WFB+PsC+gJrZBHKG0GktDdJND687F/r6BGje3XnerxM04KT9pv1BH2YG/H59wKrFk48vurQvnUa59ZmEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772224970; c=relaxed/simple;
	bh=T51q69NyqAoRrC8eWdQUrI5axS0BbXBTns6KZD1J81A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7xcc7OgUCoESCJWdE0wcNWTLIyLUZi4/GWoFjOEiVgKNEkIN0hupzF13GSW2UGQP+qtVu0NcvHg9+C3qHW+NBlVt3/7Yp/mXQiTCROg5X/DQ5k4N1ekvJwZyVdgQ5OHZBSaJuDKV8yS+6jnZJDiLl/b9YCeV0DfXnVJXRIfb+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=pmWFXljH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TaB8JKzl; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7759D7A00D9;
	Fri, 27 Feb 2026 15:42:48 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 15:42:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772224968;
	 x=1772311368; bh=nQBej5dUcbhU4T2Aw/e+1hvksmqfGGJ3QHaWWw1MKq0=; b=
	pmWFXljHZh3f/3DgqODg8+mX3W2fQ8hzm0VvrdtF3XBlu3ASS/JRZSLNwCr8V1Gv
	eo/FUuxKp6O5qs2msKTQMcH5o/TESfwmbDS7eVbwDBHAPrns94D//TVv3G9CsktJ
	p+YqtDptpqHKllhEksJyZZa1y1aB3llpeN8wJpE2WU/2j8I9RpYc/dXiW+wS8+bT
	TvooUdkvMnIBlHuZbyP2Bcr4tBcxL7v0AkvySl4IxejVGWZdI6gGV+TWkgnwRKov
	q0Adfn/HFbiYwEDYwn4lBIUwItr/G1hIdt5eH1LW/2f0jRWXtjMDaVdTZeeGm4XH
	iV5uDyGQJy/soCOsF8aWjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772224968; x=
	1772311368; bh=nQBej5dUcbhU4T2Aw/e+1hvksmqfGGJ3QHaWWw1MKq0=; b=T
	aB8JKzlQ3hmj8CaWNZZuGQ0HYuZvjx9uUTfim//v6xEf48vN/cJfhJ8Bp3upgMSG
	LbS5tQwUGj7KKPf/dRgVHz6kSNTQAV6w8JhiYTMt58VVlsM49xXI0zBAwLa7S/Bu
	RC48/SjRJLiIm5cuV+5yodPmW/MPJgsWu418AaiFRMMyRW3Xd26uZsrs/+ZGiIs7
	JafY8kSL2dFDfaMIMbhnnRl0OZhjsYle9KcsB9S1H/LXS0w7pTcjWU33tCTRu6rd
	+XNMP1RSmrHZhKKe/NG1APy1EvY7t5jvpoc1leAMxbFJ7GlyXh211BjK+seSaV5t
	EOnPdlfgMY/jEU/YyC4Rw==
X-ME-Sender: <xms:yAGiac2tVj5DzopJ2J8tYttLvx-vPTetcY8KzOyPvtzlEYegVboZgA>
    <xme:yAGiadesdLxkBKzl_4PultTsC0IPoua0RxqGpLCGPlo61aM_Ik7kHdxVxQAVse52T
    c3iFNimpN2TlskhKUpVK4_7emVnz6fl4KMmAY-AHjy7_NcVAXgIcA>
X-ME-Received: <xmr:yAGiaRLjGlY2XkYfxY9Z5-xMc7_QevrgXtdnA-OdOpSg8Y2TaRTUjNTIM3c>
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
X-ME-Proxy: <xmx:yAGiaTp6eifrwlIHRBvrE_Icj5UieV2xT9D2Sx824JtJdOeIVL0rqw>
    <xmx:yAGiaXsxWGs8mmsgKVubbqzJvcAYl6LTCzHHghXk9fYMM69LHBy0Ow>
    <xmx:yAGiaVLfD0YI-1CvdW2xNazKreQlGK5K0fy1oL1kzFHznFt_q2VGLw>
    <xmx:yAGiaeqk64xt8oY2xrn4zu-ShGGOG_UcCYaSeWgj86Wv_GCXPcPhVg>
    <xmx:yAGiaUcQlnIwjRcdiJHSA8FWdDeMvNKDhQfOPR1za3GmJjj0pgPkHX7u>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 15:42:47 -0500 (EST)
Date: Fri, 27 Feb 2026 13:42:46 -0700
From: Alex Williamson <alex@shazbot.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
 <kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
 <maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
 <giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>, alex@shazbot.org
Subject: Re: [PATCH vfio 1/6] vfio: Define uAPI for re-init initial bytes
 during the PRE_COPY phase
Message-ID: <20260227134246.27ca482a@shazbot.org>
In-Reply-To: <20260224082019.25772-2-yishaih@nvidia.com>
References: <20260224082019.25772-1-yishaih@nvidia.com>
	<20260224082019.25772-2-yishaih@nvidia.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-72228-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim]
X-Rspamd-Queue-Id: 68AF31BDE23
X-Rspamd-Action: no action

On Tue, 24 Feb 2026 10:20:14 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> As currently defined, initial_bytes is monotonically decreasing and
> precedes dirty_bytes when reading from the saving file descriptor.
> The transition from initial_bytes to dirty_bytes is unidirectional and
> irreversible.
> 
> The initial_bytes are considered as critical data that is highly
> recommended to be transferred to the target as part of PRE_COPY, without
> this data, the PRE_COPY phase would be ineffective.
> 
> We come to solve the case when a new chunk of critical data is
> introduced during the PRE_COPY phase and the driver would like to report
> an entirely new value for the initial_bytes.
> 
> For that, we extend the VFIO_MIG_GET_PRECOPY_INFO ioctl with an output
> flag named VFIO_PRECOPY_INFO_REINIT to allow drivers reporting a new
> initial_bytes value during the PRE_COPY phase.
> 
> Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations don't
> assign info.flags before copy_to_user(), this effectively echoes
> userspace-provided flags back as output, preventing the field from being
> used to report new reliable data from the drivers.
> 
> Reliable use of the new VFIO_PRECOPY_INFO_REINIT flag requires userspace
> to explicitly opt in by enabling the
> VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2 device feature.
> 
> When the caller opts in, the driver may report an entirely new
> value for initial_bytes. It may be larger, it may be smaller, it may
> include the previous unread initial_bytes, it may discard the previous
> unread initial_bytes, up to the driver logic and state.
> The presence of the VFIO_PRECOPY_INFO_REINIT output flag set by the
> driver indicates that new initial data is present on the stream.
> 
> Once the caller sees this flag, the initial_bytes value should be
> re-evaluated relative to the readiness state for transition to
> STOP_COPY.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index bb7b89330d35..b6efda07000f 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1266,6 +1266,17 @@ enum vfio_device_mig_state {
>   * The initial_bytes field indicates the amount of initial precopy
>   * data available from the device. This field should have a non-zero initial
>   * value and decrease as migration data is read from the device.
> + * The presence of the VFIO_PRECOPY_INFO_REINIT output flag indicates
> + * that new initial data is present on the stream.
> + * In that case initial_bytes may report a non-zero value irrespective of
> + * any previously reported values, which progresses towards zero as precopy
> + * data is read from the data stream. dirty_bytes is also reset
> + * to zero and represents the state change of the device relative to the new
> + * initial_bytes.
> + * VFIO_PRECOPY_INFO_REINIT can be reported only after userspace opts in to
> + * VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2. Without this opt-in, the flags field
> + * of struct vfio_precopy_info is reserved for bug-compatibility reasons.
> + *
>   * It is recommended to leave PRE_COPY for STOP_COPY only after this field
>   * reaches zero. Leaving PRE_COPY earlier might make things slower.
>   *
> @@ -1301,6 +1312,7 @@ enum vfio_device_mig_state {
>  struct vfio_precopy_info {
>  	__u32 argsz;
>  	__u32 flags;
> +#define VFIO_PRECOPY_INFO_REINIT (1 << 0) /* output - new initial data is present */
>  	__aligned_u64 initial_bytes;
>  	__aligned_u64 dirty_bytes;
>  };
> @@ -1510,6 +1522,16 @@ struct vfio_device_feature_dma_buf {
>  	struct vfio_region_dma_range dma_ranges[] __counted_by(nr_ranges);
>  };
>  
> +/*
> + * Enables the migration prepcopy_info_v2 behaviour.

s/prepcopy/precopy/

Thanks,
Alex


> + *
> + * VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.
> + *
> + * On SET, enables the v2 pre_copy_info behaviour, where the
> + * vfio_precopy_info.flags is a valid output field.
> + */
> +#define VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2  12
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**


