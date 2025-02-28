Return-Path: <kvm+bounces-39739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B91CA49EE0
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 17:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1E0C7A4601
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 16:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A514E280A51;
	Fri, 28 Feb 2025 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NfSu3/TJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E7E27FE95
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740760345; cv=none; b=j05f3qmiGS1k5TOuyIy33Lmzhha9g9ln71fL1R73tFbAPMzEPu2ST7z2whrUaKp2zthvLiotwb0vP+pfjfQk9oERxzRjWo4RDqwphfDJFVNi6ttY/QPifdt0cspeIVxhwVkjyn7Oat5St+lQf0nYQc8M0MRbWw2au3fSkEL/A0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740760345; c=relaxed/simple;
	bh=xHfETFRXXqxzlXTdtZnDhJeu4Hb5RXkwxN6WWVEL74c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MTJdmppIoM4NUTCqYjnwiufV/9S1CSM0/BS0t+CKvCEApTpsdJEF5qh2LC7LzdPbhYuyz0Hi+jhATtRtzcLJUJmHo4QdJwucFeIKv5WTWhsu6HUwwaVxhOJUTczEizgqLMtfsFFTBsAAw3Sk+YnGL7N7b8YyXPbNWrmBpoZ3IN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NfSu3/TJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740760342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrqrOSYWZtD40E+osmzSBLGghD04Qb3lStl4xZJ4Yw4=;
	b=NfSu3/TJ7KWSoJINB0NRfqjle0xRnSjT5X+W22wnDBJqy9CUrNmvfN0cdzrQ0Hz4c420+X
	v0OXsUDJyHjhhyK0QAj0QM/m2FprZA3fFiIJM/AbM+jGA1VcDmn3pPevjCjDeX2+Kry42n
	Hlc0Mp/9y/JUpCSIG+x+aRBzyrqCy0s=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-VfxWDId2NmusQGjhr9V9Tw-1; Fri, 28 Feb 2025 11:32:21 -0500
X-MC-Unique: VfxWDId2NmusQGjhr9V9Tw-1
X-Mimecast-MFC-AGG-ID: VfxWDId2NmusQGjhr9V9Tw_1740760340
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d2ebfabc12so94655ab.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 08:32:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740760340; x=1741365140;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XrqrOSYWZtD40E+osmzSBLGghD04Qb3lStl4xZJ4Yw4=;
        b=rTWhIE4Lnp0hXNOdB3vdZcg3jGCOuyuglW3ENsO0WO9b0QINY7cLL+QcZi1tRr/yJl
         E1qJPDZF3sD6TeTe4kDEGlb/FQnrFbw7hEq2s01q9cA79VBC5dUHozgni6rJ84y+0bp3
         Pi56/LCVlT9B6Fyk/w8nqlE391LzUsd831I5WD8FZ5WIv6o1RC9KvNv4ZwMFpDfwLYjR
         EQKXk7bCUB7WafWQUZYxSoSlaTUfi0FfCjhN0FZSmxZ5IWy4+9qX6d/jWJ4X4t+i8/ZC
         Mz1mMthWSfHf/TasDqgbWAXAS9fA2K2k9FQGW+BqBCATbBcPYfUMOIebxFzIY6Xw6Btl
         dYZw==
X-Gm-Message-State: AOJu0Yyp4EaqSKdmd8CMXzcSHxu1lTQwCDoLbVheE4ekGt33WyKt7yxZ
	83DvXSo7d5qkK5B7jRYFinkWd/2auVZI4lBrWo/7InBTJBiqCvil5pelC7eOT+QjLiyKol8W4CW
	ALZxrXWULpjxn56GtiRMLMdMEKe1dQFXg9n31tg6F+W7JZnA2NZtJPulYUw==
X-Gm-Gg: ASbGncsOmQ61AyAjM7cC2t5eaVTvG2eWnhxpxTkML7sJFW1pdkqCVB7dQW+SYunixvG
	elksIII5Y2esKZoNOO6KQ4nnNIVjW/KM4mGu8mh7b01fEEuAuH6rMvwlGyMnKQlXMtlfj9LLNDl
	XOeZcbGzXlTqthq62Q+jsnKE/BZ/KYgpaXgdckhV33PZZM/IATj5wmtFBVF8592eGOQfy6KCYEm
	n0B32DuIkgpI7EGZ+Jw7e2xWI7OVEKTSxpmOrJZjYMvcz7e6phfXiWera2FnDgq1/1Wlx/FLun7
	bJEb1ZHOkqcf48fLZKY=
X-Received: by 2002:a05:6e02:8e:b0:3d3:dcd5:cde5 with SMTP id e9e14a558f8ab-3d3e6f65b5dmr11898965ab.4.1740760339806;
        Fri, 28 Feb 2025 08:32:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFEQVWdAAouesIuSGFJu/QRRb8A3ncG+n0kWFoE0EBXjfN1U0L9ZvyqALnG5kZJ/4ZmPBGsmw==
X-Received: by 2002:a05:6e02:8e:b0:3d3:dcd5:cde5 with SMTP id e9e14a558f8ab-3d3e6f65b5dmr11898885ab.4.1740760339544;
        Fri, 28 Feb 2025 08:32:19 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061c701dfsm964449173.60.2025.02.28.08.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 08:32:18 -0800 (PST)
Date: Fri, 28 Feb 2025 09:32:15 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Tomita Moeko <tomitamoeko@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfio/pci: match IGD devices in display controller
 class
Message-ID: <20250228093215.2901dd7f.alex.williamson@redhat.com>
In-Reply-To: <20250123163416.7653-1-tomitamoeko@gmail.com>
References: <20250123163416.7653-1-tomitamoeko@gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jan 2025 00:34:15 +0800
Tomita Moeko <tomitamoeko@gmail.com> wrote:

> IGD device can either expose as a VGA controller or display controller
> depending on whether it is configured as the primary display device in
> BIOS. In both cases, the OpRegion may be present. A new helper function
> vfio_pci_is_intel_display() is introduced to check if the device might
> be an IGD device.
> 
> Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
> ---

Applied to vfio next branch for v6.15.  Thanks,

Alex


