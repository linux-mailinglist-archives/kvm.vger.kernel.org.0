Return-Path: <kvm+bounces-71853-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJTqB+Itn2lXZQQAu9opvQ
	(envelope-from <kvm+bounces-71853-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:14:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B949C19B536
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 92F0B302D9E7
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549143E95AE;
	Wed, 25 Feb 2026 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="19NwrVry"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2091C3E8C73
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039644; cv=none; b=gA/7qrqdr3dbaaMO4BV73YchsarEahjz4V127PRSCAUz0diR3gMFGdkYcD8mSY4v341X3XkfUFETMiruLbv6fJYqqwb8CYFVBSoER7gHKZO1+XadPqcP9vhZnQqD8uDMbR6EcFbN0Vq8PFmTsw1fhDU+fAKWkQt1gm7kZgtALGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039644; c=relaxed/simple;
	bh=tg8jSFYCqfLFQXcaensEEHh0SKR7eXizyYpXHop7lY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoRF2WUIdPlJkUzCP/uxpDTO5Tm0keLSRcsQVSmqeEWvnKjJQDIliHsWpEVz9bRCrJh5DOZAwtSQzPabJnFhBsXCk6B7INLTGol4Hv64nM7Fm2ZRl5shyCiH04AmT+2MNLpaoIuiRms+eYZN9JnrOdUVfnqXkHrkz5l0f+ByMBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=19NwrVry; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2aaecf9c325so8071465ad.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 09:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772039641; x=1772644441; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X5lYUAYbbkVmaj2N0JUVYvP0KKje+HoMDyoPWc0/sAs=;
        b=19NwrVryExFrWq8StXHrN59w5J8tx6quoUGMcuoTI7wiNmEs9JvbIGdaf0sF5CDl2/
         KE9XAbsvmGCKg0z3Vq5qFtAXNdu7Df0bVzoK8/lqxVHxyf0W0ffVSIisvQ5vvOSyZHvt
         y8XVxOI2mOn6m6jGBqdGlTyaas3o+4sXE70GyXMa/KIqsby4Mxbcy1mjfWLSGVSKLPht
         lw5JAFf5DYsi5nOrEcTFMXeVBZThqzwLYfOdvv19+1RYcpO2kVuJFjpNBkR6FDtNFWBp
         rwJdCKWXApe9le+Mrt1+MT76neZ5/Go0txHv/mmapEcqZdB7KPHop/dLdEKw7x8Wl96V
         s6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772039641; x=1772644441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5lYUAYbbkVmaj2N0JUVYvP0KKje+HoMDyoPWc0/sAs=;
        b=p1w6sKuax3Hhq429DdJF2L8cSl1ucJYu/hG/LZ7fp2gm7IIBrZfyFDDiWvfltHM/uU
         lVjOeV8gwIH8MjmdT/2RvmNTftiephe8s76RkPcb4I6p/CyEQ1Zz/CI4kYSsZT6HwR2I
         3YXHjyBymoFdE5CQzlMDLaiQpVYA5vY9mQCsDAHNmqzG6jpj4kJxUndYrOeme5HNiSbL
         7vhOiAIrw0idlaIoRkVqXRsnDnj6of20sgTsqc6hZV5v/GJvs1s2fBl+14o5Db9oLb1v
         /YvBq4m6BpMeAlw2Giq95efpSkSlayCqtv9We+KrF67t/ocOyWmhbCt95tuC2luC2pnA
         ztYw==
X-Forwarded-Encrypted: i=1; AJvYcCVdlil5D6YKXWYyUuf2aYLj7KHweKAF+Pf/WD1NUhDpzOLwRiIw+PLdhC6dNJ0bNN6Pg7k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxBtnI9SHgZxjQmZzmjgJcpLDiB19KWOE6w46MjdqYNRhLtBIM
	oFDh0X0kRLI/EE7Ts7NFGHuZvU1SqsmU0hEO+ynhxk8zKTGNilRL7yyQyKCfBOBRhg==
X-Gm-Gg: ATEYQzxIpFQ2jUI8MYF7Vd0V+ql6JGCoBf26P5pvND2ammA2zvKK9RU+MeFkV9Mk1pX
	QqcIvmgzAqG7ZEuMqH+buf1qRuYjlSt0fM8VLTwnNL77eNsVOR2AztQzcJrlH6Od4fAyuR+e5Im
	zh9H9PrQHO1JacYsOD22aoEYAF7BgyaJWjNVWc+M4IWoLf5lOinJUEyed/wbE3+KsIBdurgwNNu
	fSBwwIM9jphVzwoff9iDuWHyW+c+VD3PnFzY5QDy7ul7xd3v9bmwqry0HKo4uimVEYiYfdctvsd
	qpQaeHihnSvqyt8X+ybiWI4n+orLQRrz9M4fHgCBXdFEH9zSz5Zv9GDgoZDvYHkVl5zJl8cjkny
	nCuXFyMbF9CTf0uvURRG72W3JcU22zKO2Jw3pCIynNAuPSmNYIuDtmqU7xBgexWVuNLoIJZMSCa
	bLt8+XE3aSVpFwZ91AL2X1x9qK+WI0wKwHk/g+O6VlWBq3hGJ6LKvoGS1ClBn8+A==
X-Received: by 2002:a17:903:19ee:b0:2aa:f43d:7c41 with SMTP id d9443c01a7336-2adbdc7017dmr41144065ad.10.1772039640984;
        Wed, 25 Feb 2026 09:14:00 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74f5dc87sm150046245ad.22.2026.02.25.09.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 09:14:00 -0800 (PST)
Date: Wed, 25 Feb 2026 17:13:56 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Vipin Sharma <vipinsh@google.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/8] vfio: selftest: Add SR-IOV UAPI test
Message-ID: <aZ8t1EEvD67_H5IR@google.com>
References: <20260224182532.3914470-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224182532.3914470-1-rananta@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71853-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B949C19B536
X-Rspamd-Action: no action

On 2026-02-24 06:25 PM, Raghavendra Rao Ananta wrote:

> Raghavendra Rao Ananta (8):
>   vfio: selftests: Add -Wall and -Werror to the Makefile
>   vfio: selftests: Introduce snprintf_assert()
>   vfio: selftests: Introduce a sysfs lib
>   vfio: selftests: Extend container/iommufd setup for passing vf_token
>   vfio: selftests: Expose more vfio_pci_device functions
>   vfio: selftests: Add helper to set/override a vf_token
>   vfio: selftests: Add helpers to alloc/free vfio_pci_device
>   vfio: selftests: Add tests to validate SR-IOV UAPI

Reviewed-by: David Matlack <dmatlack@google.com>

