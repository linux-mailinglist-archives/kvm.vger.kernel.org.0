Return-Path: <kvm+bounces-58020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 665AEB857BB
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 332F24663DF
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB4330CB27;
	Thu, 18 Sep 2025 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vbbf7tu7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A781C3314
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208196; cv=none; b=TO4eC39jgw0mrGThlT/yduB1euiKuu1Mi1KVBe921H8DFM2KhvPBnthxi0l+jsCKO/0LvVAddHvZJvTYDnqY4uSqizNwLuk1uDbz968yNCckk49mP1pM9Sf3WIITKnPFbQPfcEq3EtY5lgwxcIRJjXvd5EnZCIsd6nu0M/I+HX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208196; c=relaxed/simple;
	bh=Pw/MjLea6UioSwSASZnpZ8AAsRX5LWCOIOgzJejjR58=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dJCROx70fBX3SLClT3eSoMi/TwfxUeRszDXyqXl1rZ/asXYNUlLRKZl/kUQ9uKUg//2QogZ/8AFfSsPsCuCe5U0rr7YDU5uiMVpMVRxu1lguDsI6EtNQsIUsIlEh0OULLMqEYAWjkw+8Ip3BUvxNGIHYOzyuazWzp2Bfu/MOKR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vbbf7tu7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758208193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=OTSr1wJjkB666s7wnjnpL8189wpCEBf5U1utvv7uWvc=;
	b=Vbbf7tu7NI3o2CJxn4apDsbZGv/Vy4ANDeEI7yZ8bzYHPUg1p244hgcwgMnRmL/jQtwR/5
	m7dnDyeXebJ+/5jVGGwftC8SJa+neJpKb8nszIPUrlkpTx5pNAg9Ja5DZQI/Lu0kMSo4JG
	c7H67jSeOKfpcMCyF01zhZqNPRvKD8w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-FIBXe20SNjGiPaxNkujeQA-1; Thu, 18 Sep 2025 11:09:51 -0400
X-MC-Unique: FIBXe20SNjGiPaxNkujeQA-1
X-Mimecast-MFC-AGG-ID: FIBXe20SNjGiPaxNkujeQA_1758208190
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so13860505e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 08:09:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758208190; x=1758812990;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OTSr1wJjkB666s7wnjnpL8189wpCEBf5U1utvv7uWvc=;
        b=CtV59HyWrJp0Q69eS/XLWBaracllibqr7XZxO3rZYQTV8VsCa3LJS+5++O0vbLmiCs
         eq/OhoEaqqBuwfNnMmT/BI3G3gx7HV0VFLPb8ZVNlGgkx5uMP3W4r4RE/u7AD8Dq6OHk
         Dofqkp8839I164ckcuB1YxaoAhC2z+yqCts//cwEMgVTrrzhjnZ8Be29Y7qeI3VHThxY
         U/RTmOAQwwE7qOyXuoKW4IeSinE+4wzkmQ6NF23cVse6Ocp2QMISpE4dVJJ26QYTnACI
         1PwfOcgtsyiyxgKYOyTCoi0kvAL+Rqnbmk8BirOlbM//XXDtG+ovDj7LztyIaiYwe/Oe
         CJUw==
X-Gm-Message-State: AOJu0Yx8UsXA5PCMUM9lw2LiWPw3Q/ycNStBMlngxH35ls72Lp8gmnT0
	Ur1glTWr3FzMMD/uK+O7YJ+O0wiLuJ2vi4bDgoTgjjlgaKXqXik4ST9LFXKCipZZqzwrUx0KrQK
	k2K1mS07lFa1/Hvm9y6wiMZcIPBdeFF7b9UVGetjXhgkhtWjS8oFwEg==
X-Gm-Gg: ASbGncucI+D9YxTwuqgI2DiNqEKly6fEqBMzyTR9DsRcGy+61VGaLd8KL2b7QeKG7Qo
	M5WXwE9BbAwigJcz/de8IT2+0ZiFngX96qBfAkXdcue1WlCenyOL1WwSmq9ErewH7ArGMQWz4fN
	rOFiw3IxkIeOE90PnTweTayi8i9wmsskPE+4MRDd2Ypl4FLVSJ2fAFMOTmSow8oaJhaKhH+rDw+
	GF4M0+VU5pGYvCbJv4nA3VQLG5MHD5+VI23NIJUET3Qj4KmbcanGwsA1fCL/j1xs3ar0/lda/d5
	iKHvoG/laH7l/rXWb6GIs56v/6/ZncfzvdQ=
X-Received: by 2002:a05:600c:1d1d:b0:45d:d259:9a48 with SMTP id 5b1f17b1804b1-467aad147bcmr382865e9.9.1758208189540;
        Thu, 18 Sep 2025 08:09:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaJ2Mef73Q+HoINKzwUEsC1cVU7zVeFESpyDHECaEl4JHKCNZY7hJUwLmFSP/kpoOzvVa5TQ==
X-Received: by 2002:a05:600c:1d1d:b0:45d:d259:9a48 with SMTP id 5b1f17b1804b1-467aad147bcmr382485e9.9.1758208188954;
        Thu, 18 Sep 2025 08:09:48 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7478sm4120284f8f.38.2025.09.18.08.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 08:09:48 -0700 (PDT)
Date: Thu, 18 Sep 2025 11:09:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alok.a.tiwari@oracle.com, ashwini@wisig.com, filip.hejsek@gmail.com,
	hi@alyssa.is, maxbr@linux.ibm.com, mst@redhat.com,
	zhangjiao2@cmss.chinamobile.com
Subject: [GIT PULL v2] virtio,vhost: last minute fixes
Message-ID: <20250918110946-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

changes from v1:
drop Sean's patches as an issue was found there.

The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:

  Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 1cedefff4a75baba48b9e4cfba8a6832005f89fe:

  virtio_config: clarify output parameters (2025-09-18 11:05:32 -0400)

----------------------------------------------------------------
virtio,vhost: last minute fixes

More small fixes. Most notably this reverts a virtio console
change since we made it without considering compatibility
sufficiently.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alok Tiwari (1):
      vhost-scsi: fix argument order in tport allocation error message

Alyssa Ross (1):
      virtio_config: clarify output parameters

Ashwini Sahu (1):
      uapi: vduse: fix typo in comment

Michael S. Tsirkin (1):
      Revert "virtio_console: fix order of fields cols and rows"

zhang jiao (1):
      vhost: vringh: Modify the return value check

 drivers/char/virtio_console.c |  2 +-
 drivers/vhost/scsi.c          |  2 +-
 drivers/vhost/vringh.c        |  7 ++++---
 include/linux/virtio_config.h | 11 ++++++-----
 include/uapi/linux/vduse.h    |  2 +-
 5 files changed, 13 insertions(+), 11 deletions(-)


