Return-Path: <kvm+bounces-18020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58EC88CCD35
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 09:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84AFD1C2101D
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 07:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F84C13CFA8;
	Thu, 23 May 2024 07:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="KmvMA0Rl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ky1FyPr0"
X-Original-To: kvm@vger.kernel.org
Received: from fout4-smtp.messagingengine.com (fout4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630273B29D;
	Thu, 23 May 2024 07:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716450214; cv=none; b=DqeQyZS8rxrlD5PAryXZF0HVajHkmOY/Y+GAqslz3SGwfIEmbYeWnR1zQV8zg8woQi1wlsLBZDXSpURcJc/eIFgergLDVM3/0oU3ADlPcUSm5LyhVTjLSCyU4Ldye+ilzfXCqsI08poXyJjnWjMZOCEQWzLe5dsL6VJrebNPAXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716450214; c=relaxed/simple;
	bh=RF/T6VmbZncLkH+mPH467ZY+cLh6LpgxZjP0H/p17T4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUR7y3KY8UZHxKwR3JWV7ukWE3oT/MxLt/uCc6n/jAb6mcitpsx4/ehRHwoH4kqN0cZsNJ3b/VpSmtIibp7CwVN7fROb5wAVf9GFiw7FEkOJ7pKh/lEKYgn5e2tpE5KTax3Ni+Znyt0HahMsQjqYnW8+sNDOiDZrd2kTUqyROPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=KmvMA0Rl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ky1FyPr0; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfout.nyi.internal (Postfix) with ESMTP id 4BDF21380093;
	Thu, 23 May 2024 03:43:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 23 May 2024 03:43:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1716450210; x=1716536610; bh=Z54riPT5w/
	GXWKm3n3NRJES1/8ZfLErFEZnD1X1HhbQ=; b=KmvMA0RlQBO6id/CK5a9vFvUvR
	5C5ltyCkThCqWn71NsagNjedTWcuKDeEYnv1j9Y8SkYecGHxuJUd56zkpVBBzu08
	1xL1BiUErrUZugZUnARtLOqK94YpHZRKFoAELNy15h8WmWdqO7J8Y98DC3cg5bph
	0eQrsQea64ecYxDcREORxP9+gl2/lkl6YoVK2PWqs1NupIZBozv0dB8EY71bbhXL
	UZEi9JN5sxDgHfZB7aG90AdHMvKKBJJX4V/roR4S0+fL6J4f6iiKInzSKREi2oRl
	g3creWIGcsDdzSfNEGyqiVVDgrLIEei4w2NfCo7YvlVPw6a++EK9zVxohg0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1716450210; x=1716536610; bh=Z54riPT5w/GXWKm3n3NRJES1/8Zf
	LErFEZnD1X1HhbQ=; b=ky1FyPr0AtptsanbZ9Zekp0M244Y8s0mQ00QcCarYrn+
	eD0PhiIOWMMTg4xFaaWUk+c12RkXfpF63BnJephrceyb1a6TthWopg8FCp3i95bi
	YWUYHYtOzf2x5hfukSR8Kg9yi3gHm8c5brfXNxHBQW/npILV1lFoElSxRgyuD6M9
	R1ZHECtWKgreEvfG+zJXbauCFEfn5Wn70Q6QUygk6QpDzqJZy2cK+k4LqCHIlLY3
	wEs0f3ZH6jP/wPEjo6dd+lNxBrCCFd/R1rXNqyIpud6p/05Wn1fM/qCfN8JYG1ZD
	s+qJaKGbKWyuZBr2jI69cLaam6aehHFue9T332Tv1w==
X-ME-Sender: <xms:ofNOZl1j_FziXDjSHf76AJHKJIz0tesuZEZpkFOBfp-VSzVdWDb6bA>
    <xme:ofNOZsH4beBGtIkt56x418n9qckwNv1v9k0nGiiMMsJGLACdQTkzJFeEg_83X_UBV
    R5z-q1qICpM1uZ0Ww>
X-ME-Received: <xmr:ofNOZl6onAOMt8r4gcJBkkGBHdjiL0L7ZqFkxKjI2pMyu2yNgP9AuPt4WPicDGD6KSU6oTj5fDtq4yUmvDRqVsF-B0lS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdeihedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtdfsredttdejnecuhfhrohhmpeetlhih
    shhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtffrrghtthgvrhhnpe
    egiedutdegvdffuefgkedtgedtvdetfedvffejveefhfefffeugfeiffeiffegveenucff
    ohhmrghinhepohgrshhishdqohhpvghnrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhihshhsrgdrihhs
X-ME-Proxy: <xmx:ofNOZi2Qg0gLRtEISMFBv4LBxL6pap9WcDOUuJB5pT7yv27lxRwo0w>
    <xmx:ofNOZoGVTD9hpKcgPmu7CxJvnevTESb1hf-gscRyo9UyR811PveD4w>
    <xmx:ofNOZj8qwPPeRTDZcmfHslbCdHQ0MsOa-tsqcUX8idEpWObRc-kQpA>
    <xmx:ofNOZlkoeHUIDuIjgP8TARrySxpfZwmXxXZibytZ6H45EsCreYF2lA>
    <xmx:ovNOZr9KQWdmmOyos6VDiamTU3CIzp7VOXDV6wI4FCOcP7Iul1xeqd7n>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 May 2024 03:43:29 -0400 (EDT)
Received: by mbp.qyliss.net (Postfix, from userid 1000)
	id 477F54F4620; Thu, 23 May 2024 09:43:27 +0200 (CEST)
Date: Thu, 23 May 2024 09:43:27 +0200
From: Alyssa Ross <hi@alyssa.is>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com, 
	davem@davemloft.net, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xuewei Niu <niuxuewei.nxw@antgroup.com>, virtio-comment@lists.linux.dev
Subject: Re: [RFC PATCH 1/5] vsock/virtio: Extend virtio-vsock spec with an
 "order" field
Message-ID: <4hmduhgue6g7rnuaqtakvgigaiu2dwgm2cm7wwusm7wa2xfdtr@eav5ltj4lqsd>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
 <20240517144607.2595798-2-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ymwyv3un5agbox3r"
Content-Disposition: inline
In-Reply-To: <20240517144607.2595798-2-niuxuewei.nxw@antgroup.com>


--ymwyv3un5agbox3r
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(CCing virtio-comment, since this proposes adding a field to a struct
that is standardized[1] in the VIRTIO spec, so changes to the Linux
implementation should presumably be coordinated with changes to the
spec.)

[1]: https://docs.oasis-open.org/virtio/virtio/v1.3/csd01/virtio-v1.3-csd01=
=2Ehtml#x1-4780004

On Fri, May 17, 2024 at 10:46:03PM +0800, Xuewei Niu wrote:
> The "order" field determines the location of the device in the linked lis=
t,
> the device with CID 4, having a smallest order, is in the first place, and
> so forth.
>
> Rules:
>
> * It doesn=E2=80=99t have to be continuous;
> * It cannot exist conflicts;
> * It is optional for the mode of a single device, but is required for the
>   mode of multiple devices.
>
> Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> ---
>  include/uapi/linux/virtio_vsock.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virti=
o_vsock.h
> index 64738838bee5..b62ec7d2ab1e 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -43,6 +43,7 @@
>
>  struct virtio_vsock_config {
>  	__le64 guest_cid;
> +	__le64 order;
>  } __attribute__((packed));
>
>  enum virtio_vsock_event_id {
> --
> 2.34.1
>

--ymwyv3un5agbox3r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmZO85wACgkQ+dvtSFmy
ccDRVg/+J2b4Yt4KmcQzq0DfhbUZU5xta4K5cBOzSruvTYlBmO0SFOoBRnLERz7g
J5/1nYCE6vxMPymbTLkvaP+npnZfnr9Vdtf9f+jJ2NtBEcxVYV2ITZ2wb3a9+ffT
VPE78h3xVPFA6cGRTQomS4xaThvLtngicfBWwoZT1LrC2Jt5U14fYxO8u0FOCd1w
X7eEfmnz1rieoUKOf6g1ELIpNTSI6OcWxZafKXFtqX2IZo9e22Ln4yft8F4CS0fc
3Pczp2OVHIZEkUz6hfaGQlwpavm0Asrf4M+StL4nyQJ5rTJF3/pVBDEsK+v4IlDP
TQCZyd436QhXZG5NV9Fb6cry9Rh3vmhPkuE/NljpWn3SI0WyOsbITmxoGmgpJkYq
RIjIcGM8EIqUwik8KtdUqkkA0opseaZOp90MpieUBFzDAPJr8b7Afa7oaDmUdkak
6Q+29Bpvy5exSzuCNjQjksaBUgwAyd5SvZTyaxQCKxKEjM+FROvARo/cLQUYpDuf
r3EPH9gMwx99mewVLhnxE5AxmfcGgElextGjBBc0OZ+KglvFziVx/l0EBmvwxoLP
FDiJ8+wfSc0a68wqKmGsrphRu8fxIkOnHy80VGKm+sdeljH+qRETwqBo1S7rtYWs
tZlgDBEtc7DjSlo8G0GxBeIW9yWsfsg1nLMbd8UCQ8rR/pjn0bE=
=n1+2
-----END PGP SIGNATURE-----

--ymwyv3un5agbox3r--

