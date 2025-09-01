Return-Path: <kvm+bounces-56525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15BBFB3F0D2
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 00:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A932066F6
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 22:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217E127E1C5;
	Mon,  1 Sep 2025 22:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r9dbKAXi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF0B32F747
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 22:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756764359; cv=none; b=muTdQRp0JYp8mSmcoXLsqiJbQrBWd/phWKJX0Ijoi++THy7lXtXoI1gfHXo3Shn3Ot3ANbOtvv20a2fdJBZEtlSod0BqZVRh6AxDyqXeJeuq25cRTCBnKV2SBaIx6+dzg879OHx6gGZ/6kxqD05oq8QkTkp/m0WWFJUKR057yeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756764359; c=relaxed/simple;
	bh=IRucAxRkdYj3+XFl/z4CHJNMo/npxJqZtRe84oNwZdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1FxkXVjG+gmpG4XRpysdWF5B8xW0QfTKL+3+eaFpAOD0pi3jShX2EvcgE5eF3JZ0t5WTjVGuboK5eaPO1MVfZRTHEBIdWgUqdKOycbwQaYI8zEehvqNhOhTf0eHS54PeFydtW3TePrCwJbLvOGfRX4skp1z94qI3e5nGSiAqLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r9dbKAXi; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24936b6f29bso334265ad.1
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 15:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756764357; x=1757369157; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iNGclCR4OfhQm1LG6IdweoAsF6Re2IBZ+iy2oOfb3/Y=;
        b=r9dbKAXiJwiD8ZPUrsbz567F3YSmViOL/dTZobUi1bEqxatHbJ3atYWkuh5oA8L9uA
         XoZhu+IXb3JWL5dU5iH5FN/ZcqJI4IFIV3rIXrNRCqtZpS4G2HIOSj4gxNayqX/Il3rZ
         zdok228uSCN1TwhzEAfcyLWFa9uWleh26W9uzKk+goOU+8HY2Dm8224Ag2idqHi8DlgR
         CWZIulap2BT/8c0yDZ1NdffYONjs5Y3rcKqN+3mHnv+95ZqkFd2NGGeq/9b3Rev0riOP
         6oe2fzH+uc1Y7OkLqXEDZDl75Fx3So1pMhlK1xRw92miLIpJDtxrPI2O6R/g7hLGbfNG
         HSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756764357; x=1757369157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNGclCR4OfhQm1LG6IdweoAsF6Re2IBZ+iy2oOfb3/Y=;
        b=XsE6FQ8ov8CdOnrXccp5G4oL9BGZVxFQu078raoP2C/aUXjxCjgbQDtC+rUmwTmgPT
         NgJq+z2XeVh5Ueu3WHB6YB5l2Fo/2fSW2knh5TgfbqIgFGbsD/jRXpjyOyrXZY38XKq0
         zLTa/CUtRgeddw2giaaaUMDf6TSARBdIlWyFvxuJO8bWgvHKZ337ukdu/9KITx5b4SY7
         EcLJUkCupyO84P7ZCC2PGpOfkvqkYS2p0jKPmhZeKXEscgJR4nVnLcOQJEAfUByMSubJ
         8sdSa4TFS2B5/XF61KTRuUiKVV6m4wRXbFy1XWbzEZNXi2YigvZvxu0Z7Yd+lIB9l7Tt
         AOmQ==
X-Gm-Message-State: AOJu0Ywlc4xInfPDQdr3M2+xrDZykCXbO7CFH3e8Pw53Vt7iPT3ARF9h
	Me9LR4VxcMaFP5lmpTW1SRNmY/EA4gEKa9ZQ4ELInBWUcBDX4T9mhYIEFx06KsSJOA==
X-Gm-Gg: ASbGnctXZczbMw/0d1kBLIuDOTBPFNSSoLwOv+gH9gCGdY6UWrKvbRgm3/iYIQKIojC
	j5dR7Ml2Lft+er8Jz0FBUiwxAgFae2F/rgVGspTLEx2D8/Lz+2BwCvY0BpsT3aGG2ld+GBwmKi1
	z3HI/fBXFUmXpHqhfhgY4CfFZHrHoo6B5nCCrE6rkf0C0//FrJYDn4KKo5bunHKhW9G0s9ymNqS
	zXqIzjI8R0Ij4Np4QKzzLraeBsUinqy3IsNKSUiJZtR/ROKYdd4dD2LoUlLNRRA+PFBI0VwZxty
	a8Og2Hme/Pv3wTzOcqJyF3lsfJ4c8+wiBVKrke676Tl9ObwXD7pNJw4+IKth52e29BL05J9I74p
	vRAUUc8N6sl6NrhRJBLpPC86SWH4y1rzAs6wKbPE5ttL9LbBSIRwdtEH0s3zq3ss=
X-Google-Smtp-Source: AGHT+IGTjJJ+lUPIOI6BFtIHzkUqQ53h8k+cOaGDC+1aTzya9kiOTmJe43O4r98yS5cHzoKAUIUnwA==
X-Received: by 2002:a17:903:32c7:b0:248:bac6:4fd8 with SMTP id d9443c01a7336-2493e9db864mr7485925ad.15.1756764356920;
        Mon, 01 Sep 2025 15:05:56 -0700 (PDT)
Received: from google.com (23.178.142.34.bc.googleusercontent.com. [34.142.178.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a5f7a9csm11592840b3a.91.2025.09.01.15.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 15:05:56 -0700 (PDT)
Date: Mon, 1 Sep 2025 22:05:49 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	eric.auger@redhat.com, smostafa@google.com
Subject: Re: [PATCH 0/2] vfio/platform: Deprecate vfio-amba and reset drivers
Message-ID: <aLYYvURhjGmJ__Fx@google.com>
References: <20250825175807.3264083-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825175807.3264083-1-alex.williamson@redhat.com>

On Mon, Aug 25, 2025 at 11:57:59AM -0600, Alex Williamson wrote:
> Based on discussion[1] there's still interest in keeping vfio-platform
> itself, but the use case doesn't involve any of the current reset
> drivers and doesn't include vfio-amba.  To give any users a chance to
> speak up, let's mark these as deprecated and generate logs if they're
> used.
> 
> I intend to pull the vfio/fsl-mc removal from the previous series given
> there were no objections.  Thanks,
> 
> Alex
> 
> [1] https://lore.kernel.org/all/20250806170314.3768750-1-alex.williamson@redhat.com/
> 
> Alex Williamson (2):
>   vfio/amba: Mark for removal
>   vfio/platform: Mark reset drivers for removal
> 
>  drivers/vfio/platform/Kconfig                            | 5 ++++-
>  drivers/vfio/platform/reset/Kconfig                      | 6 +++---
>  drivers/vfio/platform/reset/vfio_platform_amdxgbe.c      | 2 ++
>  drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c    | 2 ++
>  drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 ++
>  drivers/vfio/platform/vfio_amba.c                        | 2 ++
>  6 files changed, 15 insertions(+), 4 deletions(-)
> 

The series feels like a sensible compromise. The rationale for
deprecating vfio-amba and the obsolete reset drivers is sound, as it
cleans up code that can no longer be tested by the maintainers [1].

The changes to Kconfig and the addition of dev_err_once() handle this
deprecation cleanly.

For the series:
Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

[1] https://kvm-forum.qemu.org/2024/vfio-platform-kvm-forum24-landscape_TtZ3SnC.pdf

> -- 
> 2.50.1
> 

