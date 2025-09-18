Return-Path: <kvm+bounces-58018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22835B85734
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 617977C0CCC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37F12ECE8D;
	Thu, 18 Sep 2025 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gs0GFmSz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CDE20C488
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758207809; cv=none; b=gRMkyI0VlYrWd7bLwWep3uswitedYWY4DhPkFQWtcvK3EnSj6drmdJGy8QrJ91Flf1thEPPGJRpCxTDglJNGh1MZrccoorahrDDlbbJzzicKQVKtOG+pv0LUsQ7OzvmknY2Txd3SUwmph1aVBgdcsmlLkE0wyHnkTijG/2RESh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758207809; c=relaxed/simple;
	bh=EkExrjB1v+E3308pb6pdcKo1s1yc3WIbaOoY/+f5qXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wh3zErCvSFraeDqQXqGHYzTdQqWXpGYvMKS9iYR/ynqtxlHvhg4h5k3fOUFr7g3Hl2mUZJ1asTCemz1kScCUFlE4uFg60p3bUJ+zeKOvl9TGomzBQt8ItKJsYT59inKTCfMtSJyP5zlODE4SGGdNfs4bKTlG9FUUMJMM3ztfpKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gs0GFmSz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758207806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jHuroaDALPzA9ek/TZGAIvvuwoq2PBaqEYZO83mgbI0=;
	b=gs0GFmSzWvxv8xsTattEFegFjcPcs2ccWQrTBE6CCbLmHsodmxo6/FJAJxZv0NtqxmrjX8
	pLI6IKcEq25Z4znOpHRaxrELJ/AMA+vzvxFjwpMK84M4mZFhtA2qK3tc0MT7E5t9ex2SRT
	P9ARWzWJAmHKQIbw9Pw/C1jziPaZ0cc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-PumOHKBWMu-1gEU8Hwhvqw-1; Thu, 18 Sep 2025 11:03:25 -0400
X-MC-Unique: PumOHKBWMu-1gEU8Hwhvqw-1
X-Mimecast-MFC-AGG-ID: PumOHKBWMu-1gEU8Hwhvqw_1758207804
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2b0eba08so6536905e9.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 08:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758207804; x=1758812604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHuroaDALPzA9ek/TZGAIvvuwoq2PBaqEYZO83mgbI0=;
        b=ppV9GR/F7ylt+Pv9zd/akyObqymRLBtU0iMfEjJKmPwB4kf6tjNrUuvwH8dzRo8o1S
         C+tMUqdMBIjRzLLvbceSRSqsucKMSTGBt9Z9FvPNYv4cec6cEQvNZ5EHMOxFCeDN6xVA
         gZWQTsZO/GFXqCnVxFsjTEfCDcTiGfDtPgnNcNY/+wMW7nLj132tOu8QkpGFUpDHegNG
         obM2olQwD0bNcOuWYULgy/lbPgNZszuPbWDOEn5Z79wI6ZeUUG7P1J2aKPYM+6UYBGlJ
         3PC5jvnuiRDLCw1Ot7IbcpMnTLU5fnvBmU/TP5OcBEZR/YKxfvWCdrI8HjerEENMNTfB
         35UQ==
X-Gm-Message-State: AOJu0Yxrorv1frbkYcIGyKrm38oRW2WxBEO5YvQJNqF32JEdp/SbMuIs
	FHT98Ro08M9SNuCUWRY4n6YvjjeTJB7SqtWdWsiKqblLtUvd/QyRBZ1mv7wtTYOfqBu/5WR4S7I
	CQtyIFxLyo0ZOGKNnmRGf75Omzye1K/wLBvc+d4gOKEEvx7Ur1nYg9Q==
X-Gm-Gg: ASbGncuRCOZvqgsv4l4lHQ+OPoMF/fDjFWIjYBpjH2XufafWD9TNkVdvLy/ahIR+UJV
	2gw0YrjY0P0ZCw6O7mT2QJfQxenKoZLkpS+mJi29fBI+DteMaVO+jpSYnq4lOSacWhD+qO7+hHk
	4cUxiodveWXVg+Gk9ivj2aePCL6zFYypBeHtnnxvUuBWi95mXT4nUAYUor3i/Qpv6riO27lLgGv
	lBl8e4EmUvTrFd4F2Hpe0ADU1hMQez13Uw6qNznER64HNHRxCLLs9VaP1EORdXPNBXaABSiz7Pc
	Ulg5y5kfhsDtco7P7uiahSAGLLHDQLZ4Xrg=
X-Received: by 2002:a05:600c:3111:b0:45d:d287:d339 with SMTP id 5b1f17b1804b1-4620683f1e4mr63892365e9.25.1758207802093;
        Thu, 18 Sep 2025 08:03:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzXMO/8xWkfvQqlitTmfPRvJ7wLVF0bHaOOs2wJAFpxqVjxaTdhQB7sp9EBt86tb48mNkwbQ==
X-Received: by 2002:a05:600c:3111:b0:45d:d287:d339 with SMTP id 5b1f17b1804b1-4620683f1e4mr63891665e9.25.1758207801215;
        Thu, 18 Sep 2025 08:03:21 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f6695a9dsm45758515e9.24.2025.09.18.08.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 08:03:20 -0700 (PDT)
Date: Thu, 18 Sep 2025 11:03:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alok.a.tiwari@oracle.com, ashwini@wisig.com, filip.hejsek@gmail.com,
	hi@alyssa.is, leiyang@redhat.com, maxbr@linux.ibm.com,
	seanjc@google.com, stable@vger.kernel.org,
	zhangjiao2@cmss.chinamobile.com
Subject: Re: [GIT PULL] virtio,vhost: last minute fixes
Message-ID: <20250918110237-mutt-send-email-mst@kernel.org>
References: <20250918104144-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918104144-mutt-send-email-mst@kernel.org>

On Thu, Sep 18, 2025 at 10:41:44AM -0400, Michael S. Tsirkin wrote:
> The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:
> 
>   Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to 549db78d951726646ae9468e86c92cbd1fe73595:
> 
>   virtio_config: clarify output parameters (2025-09-16 05:37:03 -0400)


Sorry, pls ignore, Sean Christopherson requested I drop his patches.
Will send v2 without.

> ----------------------------------------------------------------
> virtio,vhost: last minute fixes
> 
> More small fixes. Most notably this reverts a virtio console
> change since we made it without considering compatibility
> sufficiently.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ----------------------------------------------------------------
> Alok Tiwari (1):
>       vhost-scsi: fix argument order in tport allocation error message
> 
> Alyssa Ross (1):
>       virtio_config: clarify output parameters
> 
> Ashwini Sahu (1):
>       uapi: vduse: fix typo in comment
> 
> Michael S. Tsirkin (1):
>       Revert "virtio_console: fix order of fields cols and rows"
> 
> Sean Christopherson (3):
>       vhost_task: Don't wake KVM x86's recovery thread if vhost task was killed
>       vhost_task: Allow caller to omit handle_sigkill() callback
>       KVM: x86/mmu: Don't register a sigkill callback for NX hugepage recovery tasks
> 
> zhang jiao (1):
>       vhost: vringh: Modify the return value check
> 
>  arch/x86/kvm/mmu/mmu.c           |  7 +-----
>  drivers/char/virtio_console.c    |  2 +-
>  drivers/vhost/scsi.c             |  2 +-
>  drivers/vhost/vhost.c            |  2 +-
>  drivers/vhost/vringh.c           |  7 +++---
>  include/linux/sched/vhost_task.h |  1 +
>  include/linux/virtio_config.h    | 11 ++++----
>  include/uapi/linux/vduse.h       |  2 +-
>  kernel/vhost_task.c              | 54 ++++++++++++++++++++++++++++++++++++----
>  9 files changed, 65 insertions(+), 23 deletions(-)


