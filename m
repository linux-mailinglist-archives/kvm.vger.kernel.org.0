Return-Path: <kvm+bounces-62136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85ECBC386E7
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 01:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0C4C188AD5A
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 00:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411591891AB;
	Thu,  6 Nov 2025 00:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xlx6srgX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2151F4A21
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 00:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762387295; cv=none; b=ZPB6KpJZoCkYwyrJcbi3yuoN200Cm7HE5sBIPOVpDsAsbXk+678SlqbgdyVCMhSfpRGcY4JbGBqzBZP0nTa4/FWz0fzhQWYQS/PBuhiRyda0dM0bU9FVUYjRkPnmSpyZxnJPrXi5DfBOIvc7spiQbogYIdeSOvKXDBUJNhYxp0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762387295; c=relaxed/simple;
	bh=IJpNmGCqomd5vPrThOxk8bXJzEiTqgNJywW3jA2ng9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lbmN3Ams5oa9OtlDfNpqvnRAIpP78b1z88BQyceo58IGdKlz3IAbpwkBH6swc/9P9aHU7kspNSOB1E6W8XC0/MQXBaHZw+gIhBUtN3jccWsolgA4Rmt0smSLnKSAiKdp2oB7iP+tko3mpqzidMvbdZoS93drVTeFTadAiQ17iYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xlx6srgX; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a9cdf62d31so569448b3a.3
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 16:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762387293; x=1762992093; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M+j9mh4om2Lo/eeZHz47ynRZd+sYb7QQJYZHiwixfAI=;
        b=Xlx6srgXuyXl3zaJXO294ebhFDLkatxa6OzCbBskjFiCig1oW3QcpIYOUkKy3vpHZP
         tnmdKNizkzKwPya+Gum1/HeijDy1A5PYLQOdQl07PVW2NAhSeLqZXekbhtmPMb1t/lH+
         JU/gDdHw0vnSycFtC1o1U8obwcbEPH0s9s+YcMc+uleL4j1jvwOfB3PA1JU4QR1KtwoR
         3Mc3ejP9wWzTDbeEBxvfbXi9COhylPXJIhv6b5xM69rnqRUKZx5zfxQp83jOTvo7Br3a
         9a6sUICmu5DlzZymeGu8bvgmz85a1rVdaTuhAyDi5OEm/9EkmcfgzO/LfkhwnyykMNHk
         OqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762387293; x=1762992093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M+j9mh4om2Lo/eeZHz47ynRZd+sYb7QQJYZHiwixfAI=;
        b=s9vjcDKdulxLQwtnAtywG/eu3XeXTmSGxGx57XX88xRCmkHActFzNbz5E4a8CNH0FW
         5xnola30ihtQZhMj7hdx7SUG6o3SF+JcQe6RsvxC8/ACDEIKcSQE+pk4TTFUNVXVy8z/
         wG1YpJjDbhj6MdMG2J8tukPl4nuKDaeuknO/Hqr5oWfU9duhLypsFP9l0NgRxpxd6I5B
         nQuyQ7ldX+fNvmMKkFfMFflBXwdVMnnmU5K0sm2e31og+ci3Gxr+7xA8YYqUP2zvVw1e
         ApsyFAPDPg/3meFqqGFXBEgTH/s4TyKm3yQEk4Hra8014CjirfJnOtpfEOMnLQzXWJ3E
         0pRA==
X-Forwarded-Encrypted: i=1; AJvYcCWpfXh7ZqAJZr0tYAPbREwt2XV6kTVK/A+D8jgaEFN4RmA+Rnc1vQFg2txIzvk8rJ1gQ9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHYKbqC/fOnoTAvMFEN39hrSieeY2VpjjcVTHM0d4uNMHVhrSi
	YtPjUZaOXpqAgKnDZRbR4x6uT74456bCasZmp3ZOLJKJPM9QeWwPJ89PiElw2DuWmCVcnGCtNRQ
	cYiezjw==
X-Gm-Gg: ASbGnct06pQAiK5U/DRnPIxDW9xhgaMEQ61d67MQEyNWMwxpjrAnfSvl1iB21iHHkxW
	mEylus2V4vV4LtboOtskGSgcyEqDjm3AVSocJy1p6GNbekhnt1U8x6uB7Zsj+IPc5r4m0SSky5Q
	HYvtz7iToy8RBI0sXMXGcU9MCA2Tl65o/79rvyL73RagASdhLCE5BFANM6CyDXacfzEksTlrUL6
	y7/8zeVNM4+BeKuhwBxVAdcM1Hi60IwwMyt+A9qa7Kut2Y6WIoRMzvbcCBCoaw9gOq+9+TCgWdn
	NCezWpNhCtnKJMOvl+oBySNmOQPSuSy5DTm7exg3OXc9WWw1twjIe6gqGKZDj95CFN3hPNuE3Ao
	pag1ZlAZF9HQTRt2nyZ3ET5MfAnXSspk+dMl9c+fXVVwRw5aj3A8q+Hvhk/WtnC2eD1Ix9q6P5w
	sQi/AlrsC5RdfjiLNasJPQ8dO0vgq5jzDYTWTbV0k8mBydqKbCkYfR
X-Google-Smtp-Source: AGHT+IFZn0wKXKfe4nQzbawEz5PMGpfdeosAv1u2jDFwGrH5HD8pmPBonB38N8KxSgxtY7ZfrXxzxg==
X-Received: by 2002:a05:6a00:98f:b0:7ad:1e4:bef0 with SMTP id d2e1a72fcca58-7ae1cd59fe0mr6150438b3a.4.1762387293044;
        Wed, 05 Nov 2025 16:01:33 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af82603dd3sm595170b3a.53.2025.11.05.16.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 16:01:31 -0800 (PST)
Date: Thu, 6 Nov 2025 00:01:27 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] vfio: selftests: Add helper to set/override a
 vf_token
Message-ID: <aQvlVzljJhKQQ2ji@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-4-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104003536.3601931-4-rananta@google.com>

On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> Not only at init, but a vf_token can also be set via the
> VFIO_DEVICE_FEATURE ioctl, by setting the
> VFIO_DEVICE_FEATURE_PCI_VF_TOKEN flag. Add an API to utilize this
> functionality from the test code.

Say what the commit does first. Then add context (e.g.  compare/contrast
to other ways of setting the VF token).

Also please add a sentence about how this will be used in a subsequent
commit, since there are no callers in this commit.

> +void vfio_device_set_vf_token(int fd, const char *vf_token)
> +{
> +	uuid_t token_uuid = {0};
> +
> +	VFIO_ASSERT_NOT_NULL(vf_token, "vf_token is NULL");

nit: The help message here is not needed. It will be very obvious that
vf_token is NULL if this assert fires :)

