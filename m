Return-Path: <kvm+bounces-62135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07EAAC386C1
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 00:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A11E188B777
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 23:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C192F5A2D;
	Wed,  5 Nov 2025 23:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXsB25m1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBE9212568
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 23:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762386760; cv=none; b=W7k9iiqNgQp9JZm/T8ShZVNDJml2BMdmDs/Bn7KXgaeOPXqV/qnGxYRgjpqLqbDpSSZ5V34AJSAgr7u/Iv/Ll7oh0vJnyyP/g7/wyt5HmmvwD7gxc19lPzvNAWEezkGQMvbJwzCLT6PxEzM5Z1HOORHfB7MOdBHRtoKpqqQxZQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762386760; c=relaxed/simple;
	bh=ARIJZPPp+H/QGGolJymBWsGF1xfUvB9lUDs0SVqyrc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=td5Rz8LFQHUyMxb8MbF6Wqu5NjfbIWwVqGSFaeWF3NeKqnDn0875gauA1OFdCznds5+Z8bBHu+KKuyaoBP8cGDN6v8tL/RWtqSydvZb8OyD6SKgywQ2uHjHYpKf5pUO1I1L0StjoFhtbBEwoMAIzhDw4wj50w2B0ufxknT2a6II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uXsB25m1; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-29470bc80ceso4404375ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 15:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762386758; x=1762991558; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jbkBj/ZsjHNdPwuX0wKFAsON8f0sh7Iea9BGL9GBzAA=;
        b=uXsB25m1D1oO3TENsXT8tX21AOdtCKlZbB46bEugTicMd8VIERxoHb/kAmfrtUYp2V
         9zk+octk60Ap8fRKzI4aOm5mtjJQFuQE5U2SGgi2JmUQiB0PKCUCHDf6h7niMWFmNcJ4
         fUa4mwhGjz/3AYnbiS7cy9zI/HspSVL02RXaIYjXS0/x14VApv6saiQQErFcSxnliNrj
         wxLLDx8Q1obGJSnQ0N9+WuJZ4Zr7/TxkBTzo9MLvx6uUpcyc3DscAkUsqQtdLVAA0TsI
         LuBRJD63bGym5VZ9BZYGYRtjTQ1jpJxktHxs+kes5BmNIF0PBsIxJYxcvfIIHPjLkWLQ
         oufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762386758; x=1762991558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbkBj/ZsjHNdPwuX0wKFAsON8f0sh7Iea9BGL9GBzAA=;
        b=Vp2YKSeBaJe6dTuZKb9iexgfjf5cE0w3kh16AlwgsOhdyqn632yndnQTsk46Mf0Rgb
         31XzmncfoC+GsSwrPhvPKqTj/prCt0LS198kwoctJ7ihaYO1bWJRymKXzywKqQWiIbv9
         LQeq3HAhFOE7KYwD81q0b9Ei87RaFeYbr3k40gwmFea6r7AmVSPj+fzmOgi7o2QcVsYA
         /kgVqZbrZ8YrLV3SA47N0Jz3IYFYrtq3TFC/fDdDHVlP/2yz1z5FdQmD5IMPqynll3lE
         cWKJCMYUiSqtE7h4/doQTUI3CPoQuCr66eAmItWXCWTgZj98mMFO7wxTCgDcuSE7ZCo7
         gE2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW7ib3R8WWS72+IIy2HoLCLgCEHMzNX3tjG6Gx/WqyGTbuQVhlHlmr0FHzXMbMwtnOJdow=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrGuMYPfc42yX4m/ztz8JiXfDd22ulYCK8l4+B1Opl5n0FzDOY
	xy1Z6bXNyUTW1Yhw/AaDiXMNP6QngvAcQEMysddiUvZGfAnzZAFhaaDn78UMkN5xlg==
X-Gm-Gg: ASbGncsWlHXWInp6L+ewwJ4duwIT52fCUSDzPdRZM9s71YSwC2CQc3fU+M0Aj/n6YSv
	XOnNPoJg18hun0P07nSYaF8kUS+9WBWOrxv594lEHfvHR9SxIGWe73r5vbt10SfY3Owtm7DyGOi
	zKRVyPv81x7djmtQb2hsFMLJLaANXWy+QG1L8v3T3oWCaWsAngjhhRHcTbUzNyLbIrMS80hgia2
	1TjvaIQf0GCDq2xroFh9fURb11mZA7nJ3SdcWCXzbXolA7+I7S3QnbPgkQvXCxs/oaHIKNSvO1B
	n2tSqD9YERCGCpkdwCyG2XQnkDyupYl0Vd8NVbpeQRDKtBdB6CjnYnildS4URNRAT+Y2I8+U9K5
	QvUfaGe3ZNlOsC2x68tkMmz260qKh4x0Ua+F4mlgNcbvPxfxgNpVZbbsHxrOZDtv6WNYR98RP64
	UBHkcCGuclb+kCdAr2fYFjOmmG07+cal7CKRmVhdRkXk5oD5YyqCew
X-Google-Smtp-Source: AGHT+IFl+4bLAl16hSQ6h6hY8D49g4G1vydk6YJxERppDa81I9jESXgOuYdC3pTfYES+sKLBwIZOyA==
X-Received: by 2002:a17:902:d512:b0:295:55fc:67a0 with SMTP id d9443c01a7336-296508402a1mr14835225ad.2.1762386757885;
        Wed, 05 Nov 2025 15:52:37 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8f8d7eee7sm518223a12.4.2025.11.05.15.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:52:36 -0800 (PST)
Date: Wed, 5 Nov 2025 23:52:32 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
Message-ID: <aQvjQDwU3f0crccT@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-2-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104003536.3601931-2-rananta@google.com>

On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:

> -struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode);
> +struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> +					      const char *iommu_mode,
> +					      const char *vf_token);

Vipin is also looking at adding an optional parameter to
vfio_pci_device_init():
https://lore.kernel.org/kvm/20251018000713.677779-20-vipinsh@google.com/

I am wondering if we should support an options struct for such
parameters. e.g. something like this

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index b01068d98fda..cee837fe561c 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -160,6 +160,10 @@ struct vfio_pci_driver {
        int msi;
 };

+struct vfio_pci_device_options {
+       const char *vf_token;
+};
+
 struct vfio_pci_device {
        int fd;

@@ -202,9 +206,18 @@ const char *vfio_pci_get_cdev_path(const char *bdf);

 extern const char *default_iommu_mode;

-struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
-                                             const char *iommu_mode,
-                                             const char *vf_token);
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+                                              const char *iommu_mode,
+                                              const struct vfio_pci_device_options *options);
+
+static inline struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
+                                                          const char *iommu_mode)
+{
+       static const struct vfio_pci_device_options default_options = {};
+
+       return __vfio_pci_device_init(bdf, iommu_mode, &default_options);
+}
+

This will avoid you having to update every test.

You can create a helper function in vfio_pci_sriov_uapi_test.c to call
__vfio_pci_device_init() and abstract away the options stuff from your
test.

> -static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
> +static void vfio_pci_container_get_device_fd(struct vfio_pci_device *device,

Let's name this vfio_pci_group_get_device_fd() since it's getting the
device FD from the group using ioctl(VFIO_GROUP_GET_DEVICE_FD).

> +					      const char *bdf,
> +					      const char *vf_token)

There's an extra space before these arguments. Align them all vertically
with the first argument.

I noticed this throughout this patch, so please fix throughout the whole
series in v2.

Also please run checkpatch.pl. It will catch things like this for you.

  CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis
  #78: FILE: tools/testing/selftests/vfio/lib/vfio_pci_device.c:335:
  +static void vfio_pci_container_get_device_fd(struct vfio_pci_device *device,
  +                                             const char *bdf,

> +{
> +	char *arg = (char *) bdf;

No space necessary after a cast. This is another one checkpatch.pl will
catch for you.

  CHECK:SPACING: No space is necessary after a cast
  #81: FILE: tools/testing/selftests/vfio/lib/vfio_pci_device.c:338:
  +       char *arg = (char *) bdf;

> +
> +	/*
> +	 * If a vf_token exists, argument to VFIO_GROUP_GET_DEVICE_FD
> +	 * will be in the form of the following example:
> +	 * "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> +	 */
> +	if (vf_token) {
> +		size_t sz = strlen(bdf) + strlen(" "VF_TOKEN_ARG) +
> +			    strlen(vf_token) + 1;
> +
> +		arg = calloc(1, sz);
> +		VFIO_ASSERT_NOT_NULL(arg);
> +
> +		snprintf(arg, sz, "%s %s%s", bdf, VF_TOKEN_ARG, vf_token);
> +	}

UUIDs are 16 bytes so I think we could create a pretty reasonably fixed
size array to hold the argument and simplify this code, make it more
self-documenting, and eliminate VF_TOKEN_ARG. This is test code, so we
can make the array bigger in the future if we need to.  Keeping the code
simple is more important IMO.

static void vfio_pci_container_get_device_fd(struct vfio_pci_device *device,
                                             const char *bdf,
                                             const char *vf_token)
{
        char arg[64];

        if (vf_token)
                snprintf(arg, ARRAY_SIZE(arg), "%s vf_token=%s", bdf, vf_token);
        else
                snprintf(arg, ARRAY_SIZE(arg), "%s", bdf);

        device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, arg);
        VFIO_ASSERT_GE(device->fd, 0);
}

And to protect against writing off the end of arg, we can introduce a
snprintf_assert() in a separate commit. There are actually a few
snprintf() calls in vfio_pci_device.c that would be nice to convert to
snprintf_assert().

#define snprintf_assert(_s, _size, _fmt, ...) do {                      \
        int __ret = snprintf(_s, _size, _fmt, ##__VA_ARGS__);           \
        VFIO_ASSERT_LT(__ret, _size);                                   \
} while (0)

snprintf_assert() could be added in a precursor commit to this one.

> +static void vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token)
>  {
>  	struct vfio_device_bind_iommufd args = {
>  		.argsz = sizeof(args),
>  		.iommufd = iommufd,
>  	};
> +	uuid_t token_uuid = {0};
> +
> +	if (vf_token) {
> +		VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
> +		args.flags = VFIO_DEVICE_BIND_FLAG_TOKEN;

Maybe make this |= instead of = ? I had to double-check that this wasn't
overwriting any flags set above this. Obviously it's not since this is a
small function, but |= would make that super obvious.

