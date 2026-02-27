Return-Path: <kvm+bounces-72226-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0ElmAkv9oWl4yAQAu9opvQ
	(envelope-from <kvm+bounces-72226-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:23:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4721BD941
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:23:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DC64B3056C35
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2F82C0F6C;
	Fri, 27 Feb 2026 20:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="B/soX7pI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="czzjBXvN"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8423290C1
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 20:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772223815; cv=none; b=Mi1mNGX6sVVvalFK+GZXK1HkJTgdV189ufh6WVBsj6KGKmQgRel0VayCQDjzsppdZrKxkI7rK008tgqeEKDx3ka+BKuRGX8Tlowdpixs6ST1eRJbnZeWpVzODuo7DuzJK7m6V8hSgaketd65wZQhAiR/oUzPhvbJRLtPA8qoXR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772223815; c=relaxed/simple;
	bh=jHPHcf51Wo0TYJoMvFi349novSWA3YTgCv1LJV15DFk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=if3W0woom7YPtRmdbDFiyBI/xJq88Hjyzn1b2yC9DxjFOdv9VDA/auB82vHckn2NzAqk49MuE7tH6xWvPaVzoLy81nHxBl6Wh3YfyVDJoiLGRf8C0EZ0AZXI6VPdCMziOMecwh86y5XY+E6bzNNdPMHfdl3OuyR5cbhokZ7SNEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=B/soX7pI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=czzjBXvN; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3FDF87A024A;
	Fri, 27 Feb 2026 15:23:31 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 27 Feb 2026 15:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772223811;
	 x=1772310211; bh=Y5IxKQZV+J39sceMcf1cl3Rd9NtZYHyjsu5xaa9lyiw=; b=
	B/soX7pIW3yB8RcOo5x63EFFx/KKbLMRMUrFd7av+6++sWllnbRbodsbAS3wxrWn
	HMO3tHHCun51gB4QjBJf4duWMHQUt26U9cuABRpscCoeGrVkJFg/YzD8OArjDVRj
	Y5n0ge2+o4yssfe2vLkPqE510k4R+nVnHOP1UfCE67BH05ww1ZnlCxsJxuFQucip
	+bPYDLlUZ1fZ2UdwN7cbVliOzgr/RMuP5qFE02N73maKaulA2LFWjrRvV1YqAZZK
	KKcWGNjr6XmkAKWbYFzYKmpyHIIL/SLNdwMZhEMEa+Gnd7S/n4UL1db/7C3xrK0R
	kpTgTfNKHSI3TzjFWVi3Eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772223811; x=
	1772310211; bh=Y5IxKQZV+J39sceMcf1cl3Rd9NtZYHyjsu5xaa9lyiw=; b=c
	zzjBXvNmxCr5ZK+JpQHa2CBS5VsTtSvT98cZ7y5u5FwUnHL8bMzvczzliczmmlj3
	uuIQueITut5floa+0byCm2rGdrGNfO4rqwgagtDK8AizK7/nWun6vscwE3kBeab1
	8P8hxyxWIgsDkLgUdpt4JwLF5ZyIlZXgEErymHBtNaUEtME1nQdlEF81wrVF7hzE
	gkypb3F1bAws9dD3y8M8wesUXAqflvN+xnhL79coCQbAZ07VAGi+3RA/yXGeBP//
	WTfp4vm33QO0Hk8z0TrBGuoff4ACP5MxyhnSttzA1lrp4NjGl/H79TXRBLV7dqtl
	CBMd0T04y5ZJ3MvY4ANqg==
X-ME-Sender: <xms:Qv2haQlyR1__-oYAj7IY-6UBEZsSCgcrV-V_6-LWpMSmlvSkunbg4A>
    <xme:Qv2hacMjDPFrGN-YiOaBgLrYqoyUkW8rRk4_N_7ghNn73kq4SWn18EHAxaVgoc24W
    tWuSaL4_UQK8MylFjtoieqj5BiPf4yZRWpvDuFDz6yNk18UdnAGrQ>
X-ME-Received: <xmr:Qv2haTH9y97rEiHIkA-TAtKcVrLoKf17AYR3h2hp42LNx2A_uDE3_DujeOM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelleeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegudevhfejueefveduieeuueeifeettdekveekhffgvdetfeelueehgfdt
    heffhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepudehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopeihihhshhgrihhhsehnvhhiughirgdrtghomhdprh
    gtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdprhgt
    phhtthhopehjghhgsehnvhhiughirgdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrh
    drkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghl
    rdgtohhmpdhrtghpthhtohepjhhorghordhmrdhmrghrthhinhhssehorhgrtghlvgdrtg
    homhdprhgtphhtthhopehlvghonhhrohesnhhvihguihgrrdgtohhmpdhrtghpthhtohep
    mhgrohhrghesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprghvihhhrghihhesnhhvih
    guihgrrdgtohhm
X-ME-Proxy: <xmx:Qv2haavotZAqaU-E6InsEMnjUsSLjnV0ZdowCJfCXep9KcFtMCxarQ>
    <xmx:Qv2habRS6IBcrapZMiyFr2pt0DD_wls-057nvQNdE30m1U16fSwkaA>
    <xmx:Qv2hacMSkA5UlBQO97bJNz5OreJauCBtXl64GwRyNkVFrt4YX1vtFA>
    <xmx:Qv2haR40Ip7c0mgIbnY8J1wg8wqM0Cx_UQSbVedoCb-wzbak4l50ZQ>
    <xmx:Q_2hacQ4m3JGGKbvt4oXhRDSeS9Q1fEk39wnDk8ZhmPvEFUAz220zQPn>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 15:23:28 -0500 (EST)
Date: Fri, 27 Feb 2026 13:23:27 -0700
From: Alex Williamson <alex@shazbot.org>
To: =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>, Peter Xu
 <peterx@redhat.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
 <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>,
 <avihaih@nvidia.com>, <liulongfang@huawei.com>,
 <giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>, alex@shazbot.org
Subject: Re: [PATCH vfio 0/6] Add support for PRE_COPY initial bytes
 re-initialization
Message-ID: <20260227132327.3e627601@shazbot.org>
In-Reply-To: <20260224082019.25772-1-yishaih@nvidia.com>
References: <20260224082019.25772-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_FROM(0.00)[bounces-72226-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim]
X-Rspamd-Queue-Id: 7A4721BD941
X-Rspamd-Action: no action


+C=C3=A9dric, +Peter, please see what you think of this approach relative to
QEMU.  The broken uAPI for flags on the PRECOPY_INFO ioctl is
unfortunate, but we need an opt-in for the driver to enable REINIT
reporting anyway.  Thanks,

Alex

On Tue, 24 Feb 2026 10:20:13 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series introduces support for re-initializing the initial_bytes
> value during the VFIO PRE_COPY migration phase.
>=20
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> As currently defined, initial_bytes is monotonically decreasing and
> precedes dirty_bytes when reading from the saving file descriptor.
> The transition from initial_bytes to dirty_bytes is unidirectional and
> irreversible.
>=20
> The initial_bytes are considered critical data that is highly
> recommended to be transferred to the target as part of PRE_COPY.
> Without this data, the PRE_COPY phase would be ineffective.
>=20
> Problem Statement
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> In some cases, a new chunk of critical data may appear during the
> PRE_COPY phase. The current API does not provide a mechanism for the
> driver to report an updated initial_bytes value when this occurs.
>=20
> Solution
> =3D=3D=3D=3D=3D=3D=3D=3D
> For that, we extend the VFIO_MIG_GET_PRECOPY_INFO ioctl with an output
> flag named VFIO_PRECOPY_INFO_REINIT to allow drivers reporting a new
> initial_bytes value during the PRE_COPY phase.
>=20
> However, Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations
> don't assign info.flags before copy_to_user(), this effectively echoes
> userspace-provided flags back as output, preventing the field from being
> used to report new reliable data from the drivers.
>=20
> Reliable use of the new VFIO_PRECOPY_INFO_REINIT flag requires userspace
> to explicitly opt in. For that we introduce a new feature named
> VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.
>=20
> User should opt-in to the above feature with a SET operation, no data is
> required and any supplied data is ignored.
>=20
> When the caller opts in:
> - We set info.flags to zero, otherwise we keep v1 behaviour as is for
>   compatibility reasons.
> - The new output flag VFIO_PRECOPY_INFO_REINIT can be used reliably.
> - The VFIO_PRECOPY_INFO_REINIT output flag indicates that new initial
>   data is present on the stream. The initial_bytes value should be
>   re-evaluated relative to the readiness state for transition to
>   STOP_COPY.
>=20
> The mlx5 VFIO driver is extended to support this case when the
> underlying firmware also supports the REINIT migration state.
>=20
> As part of this series, a core helper function is introduced to provide
> shared functionality for implementing the VFIO_MIG_GET_PRECOPY_INFO
> ioctl, and all drivers have been updated to use it.
>=20
> Note:
> We may need to send the net/mlx5 patch to VFIO as a pull request to
> avoid conflicts prior to acceptance.
>=20
> Yishai
>=20
> Yishai Hadas (6):
>   vfio: Define uAPI for re-init initial bytes during the PRE_COPY phase
>   vfio: Add support for VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2
>   vfio: Adapt drivers to use the core helper vfio_check_precopy_ioctl
>   net/mlx5: Add IFC bits for migration state
>   vfio/mlx5: consider inflight SAVE during PRE_COPY
>   vfio/mlx5: Add REINIT support to VFIO_MIG_GET_PRECOPY_INFO
>=20
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  17 +--
>  drivers/vfio/pci/mlx5/cmd.c                   |  25 +++-
>  drivers/vfio/pci/mlx5/cmd.h                   |   6 +-
>  drivers/vfio/pci/mlx5/main.c                  | 118 +++++++++++-------
>  drivers/vfio/pci/qat/main.c                   |  17 +--
>  drivers/vfio/pci/vfio_pci_core.c              |   1 +
>  drivers/vfio/pci/virtio/migrate.c             |  17 +--
>  drivers/vfio/vfio_main.c                      |  20 +++
>  include/linux/mlx5/mlx5_ifc.h                 |  16 ++-
>  include/linux/vfio.h                          |  40 ++++++
>  include/uapi/linux/vfio.h                     |  22 ++++
>  samples/vfio-mdev/mtty.c                      |  16 +--
>  12 files changed, 217 insertions(+), 98 deletions(-)
>=20


