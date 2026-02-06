Return-Path: <kvm+bounces-70511-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDN+BrVThmlzMAQAu9opvQ
	(envelope-from <kvm+bounces-70511-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 21:48:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D761033B2
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 21:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AEF35304030A
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 20:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30514301001;
	Fri,  6 Feb 2026 20:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="gqQ/rNW6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PtrfSzYR"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00989286D5C;
	Fri,  6 Feb 2026 20:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770410928; cv=none; b=BJv1KW13REZXg/0oUAO8qHDs/zG8Vd2GUF5dEab0XfDX/7bv7B2JCkJrFhiV+XpFPi+jjf4EiNdSQ+AQXqJFigI51xNJZ4UK4j/XbU5V8zxZmeEqMEh17enlqGGdj91+lDxcWVwMKl4/gc29DnCjVmfhP48wev0BJZySTOfuZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770410928; c=relaxed/simple;
	bh=sewls7mFlNxIVyLdmPeLP+fjx/8nqmWgNZT5L7hNZD0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iKvsPkfFGcnagJV2nnpbtkPCyOhHtoFlBxdVWvDmkSqL21+2XhgWd8AT2LC4WkMijXArybhX1k7yDqMPqleJ3kku61tdB6FBWezpu6wIduJh9v8ZHRgzeEqR1boV53yOmWE8TOvH93VJBNzGo762U7ZhfO0Ikqyv5YKHsT+KbXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=gqQ/rNW6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PtrfSzYR; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E03997A006D;
	Fri,  6 Feb 2026 15:48:45 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 06 Feb 2026 15:48:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770410925;
	 x=1770497325; bh=0PWlIAQoyUVJP6ckfGtooQ0hzJjpmashNbmqxfQHqeA=; b=
	gqQ/rNW6Au9rxXl/WadhAbwdLaHQmOE+b+ORS6D3HNpFhneHD2Z3oaWVOV2d55Ms
	rEBIWEiUi76WdOI3PlbdH7o5DMKKIr6w8DHyOaxA7L4mX+pljMDHiJ8mJ3/llQki
	ABbHDMcl/r8V2SlDQyGtmVckntjEY7ZHIu+1zJtS++Bu2xZd/orgQ9+BBUUwUMNY
	O+lTfUSYifYEv6M1PcuQByPWugStlia8AjeooV0V8uCEMxjy8vjGjNd4/4bsC7LI
	WhJm2CYx8gfjNz5uPwKeAFPcRdKHYfuLe+h2bHNHDFISjTujnZBZ9Q3qXJ3jLaf3
	xnN5K3JxxUms9ZNuYMLokQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770410925; x=
	1770497325; bh=0PWlIAQoyUVJP6ckfGtooQ0hzJjpmashNbmqxfQHqeA=; b=P
	trfSzYRP6Bid4ocaSNUjm8B6jpc86HxwT9CiUIXkXznXygUCIW7+IwXEBZwMoPS+
	IgceFNMbvNlnP2F+NfIGiql3zirJAFCIU7C5+dkWHbtG42De+cDE/XCcOjuvv+4t
	uqmJNKFqlf+Q0V3jhqdcTcZ2r/7WGmUr0IOuP2G2eyKfFPxjLSnEFBRAZ+Ru5afo
	zI1vqpJkfldCPmQr5p4Z8r5vnHv+7hkY0YLZAhlYQBneLaEsDJAQvok/auiojAlN
	WuPu4Hdac40jtL5XLT26flRDehHRnX5E3w4k+RTQ8lbO3LrEQXcl43xSLMpdELNj
	FBv5D3w/Nc0Khlwg+NBkw==
X-ME-Sender: <xms:rVOGad8sCa5p9XGfYVB1lIY5p_BtlDI2lx-_-fyoITfgxzJQpVGuOA>
    <xme:rVOGaVhJgV_9Cl8--RtG6JQTqIiMKGgyUgGkNkr2rX1k1UmE8lId7UzwFB4gn5Elg
    0wdvJk7yMy7Od29YQA2Gs1rIij8KD1Otf48wIjUWNsehzOzXIZRbig>
X-ME-Received: <xmr:rVOGaUGqXhGM9q0QkylGzf8YVc_k5acKFvjY8KyYAcbUeq2Y51zC7Wde9dg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeeludejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepjedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprhgrnhgrnhhtrgesghhoohhglhgvrdgtohhmpdhrtg
    hpthhtohepughmrghtlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthhopegrlhgv
    gidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehvihhpih
    hnshhhsehgohhoghhlvgdrtghomhdprhgtphhtthhopehjrhhhihhlkhgvsehgohhoghhl
    vgdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:rVOGaU8_Czjn_-gMgz2IsUlU0lgGMrrV2dAuRUBRUfesXvCkQjv63Q>
    <xmx:rVOGabzp52Qa8BVYzMKRPhuW_R63T8hY0O6cuHC3-U4nuSxUvIDEVA>
    <xmx:rVOGaQMrmmcK9XOqrGaxwC67SDQLdYAnld-FpE0X4_BKg5z1gqnDgA>
    <xmx:rVOGaQ8g9lSpLNzmhXbgHfgJZ1FBbVBrJqVFQ7JDoklYnQKAB-eHPQ>
    <xmx:rVOGaTVp1JxuPgNUc1aDsEZNaj0uAwLtrcFVBBQr8O1EVpheKciRkye1>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Feb 2026 15:48:44 -0500 (EST)
Date: Fri, 6 Feb 2026 13:48:43 -0700
From: Alex Williamson <alex@shazbot.org>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson
 <alex.williamson@redhat.com>, Vipin Sharma <vipinsh@google.com>, Josh Hilke
 <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] vfio: selftests: Introduce a sysfs lib
Message-ID: <20260206134843.4ab04ee2@shazbot.org>
In-Reply-To: <20260204010057.1079647-4-rananta@google.com>
References: <20260204010057.1079647-1-rananta@google.com>
	<20260204010057.1079647-4-rananta@google.com>
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
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70511-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 95D761033B2
X-Rspamd-Action: no action

On Wed,  4 Feb 2026 01:00:52 +0000
Raghavendra Rao Ananta <rananta@google.com> wrote:

> Introduce a sysfs library to handle the common reads/writes to the
> PCI sysfs files, for example, getting the total number of VFs supported
> by the device via /sys/bus/pci/devices/$BDF/sriov_totalvfs. The library
> will be used in the upcoming test patch to configure the VFs for a given
> PF device.
> 
> Opportunistically, move vfio_pci_get_group_from_dev() to this library as
> it falls under the same bucket. Rename it to sysfs_iommu_group_get() to
> align with other function names.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/vfio/lib/include/libvfio.h      |   1 +
>  .../vfio/lib/include/libvfio/sysfs.h          |  12 ++
>  tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
>  tools/testing/selftests/vfio/lib/sysfs.c      | 136 ++++++++++++++++++
>  .../selftests/vfio/lib/vfio_pci_device.c      |  22 +--
>  5 files changed, 151 insertions(+), 21 deletions(-)
>  create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
>  create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
> 
> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools/testing/selftests/vfio/lib/include/libvfio.h
> index 279ddcd70194..bbe1d7616a64 100644
> --- a/tools/testing/selftests/vfio/lib/include/libvfio.h
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio.h
> @@ -5,6 +5,7 @@
>  #include <libvfio/assert.h>
>  #include <libvfio/iommu.h>
>  #include <libvfio/iova_allocator.h>
> +#include <libvfio/sysfs.h>
>  #include <libvfio/vfio_pci_device.h>
>  #include <libvfio/vfio_pci_driver.h>
>  
> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
> new file mode 100644
> index 000000000000..c48d5ef00ba6
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
> +#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
> +
> +int sysfs_sriov_totalvfs_get(const char *bdf);
> +int sysfs_sriov_numvfs_get(const char *bdf);
> +void sysfs_sriov_numvfs_set(const char *bdfs, int numvfs);
> +char *sysfs_sriov_vf_bdf_get(const char *pf_bdf, int i);
> +unsigned int sysfs_iommu_group_get(const char *bdf);
> +char *sysfs_driver_get(const char *bdf);
> +
> +#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H */
> diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
> index 9f47bceed16f..b7857319c3f1 100644
> --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> @@ -6,6 +6,7 @@ LIBVFIO_SRCDIR := $(selfdir)/vfio/lib
>  LIBVFIO_C := iommu.c
>  LIBVFIO_C += iova_allocator.c
>  LIBVFIO_C += libvfio.c
> +LIBVFIO_C += sysfs.c
>  LIBVFIO_C += vfio_pci_device.c
>  LIBVFIO_C += vfio_pci_driver.c
>  
> diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/selftests/vfio/lib/sysfs.c
> new file mode 100644
> index 000000000000..f01598ff15d7
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/lib/sysfs.c
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <linux/limits.h>
> +
> +#include <libvfio.h>
> +
> +static int sysfs_val_get(const char *component, const char *name,
> +			 const char *file)
> +{
> +	char path[PATH_MAX];
> +	char buf[32];
> +	int fd;
> +
> +	snprintf_assert(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name, file);
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		return fd;
> +
> +	VFIO_ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
> +	VFIO_ASSERT_EQ(close(fd), 0);
> +
> +	return strtol(buf, NULL, 0);

I'm surprised we're not sanitizing the strtol() here, ie.

	errno = 0;
	ret = strtol(buf, NULL, 0);
	VFIO_ASSERT_EQ(errno, 0, "sysfs path \"%s\" is not an integer: \"%s\"\n", path, buf);

	return ret;

We also need that sign-off on 7/8.  Thanks,

Alex

