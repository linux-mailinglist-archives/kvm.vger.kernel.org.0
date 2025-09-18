Return-Path: <kvm+bounces-58012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5BFB854E7
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAEC017797D
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E827C308F08;
	Thu, 18 Sep 2025 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jBZy6d8W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D83E2309B9
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206513; cv=none; b=Bv/q3dnbeBsm7ul4q2ILn2h/8YbApMuwGsgBUWIybWKeCZ2DQOqlnlBuhZPOk7gOP7oXk7NcGIucn5Ciy4VyvNC9nA+A6tcARZnUbusXw8z2gaoOKkiGz/TrYyzEdq9ishSH8Sv6QnHx60mq8colFuR4CpRZVs6Ek1OSkxC4nWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206513; c=relaxed/simple;
	bh=52mzwF50ZysPik2mfGb84bky8NEzJW1dDbmZc78Gl3o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mWIwKpxX2JaQuJCXbwK5XL2VvVT2uXF9OEBmbgsm5+dgrCGMORoROcsDlDLrrDq/U+HMudRndLEgrOoKcwXe71sgkRbYa8YbpUXCgi65xhpltFLggxYfB+J/gjsuliSk7pyQa8wZEyua8+bUi2Lox5dl3DjLjyF4ZQo4At5WU04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jBZy6d8W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758206510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=XGS8iYxGjjgCtPNfLtzzgPnXWY2Ig3ulBcoQ+vUpdX4=;
	b=jBZy6d8W3ydjMg2N5kOOKhaF+EDpSX3+9jH4nYUa0Ew/q1lKn5MrskSWICmWfWAu9Ik+M9
	XBC41ZfgxU0S8igzBJzLm3ME72j8wiCngt2wsQCkZxhzHDy6UExkskhPprBGupDmXf+urh
	zDD2FppRgnVeAROkiXIH2dS2GTgqaVA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-0WBM6mwuMKusKHS7yvEBmQ-1; Thu, 18 Sep 2025 10:41:48 -0400
X-MC-Unique: 0WBM6mwuMKusKHS7yvEBmQ-1
X-Mimecast-MFC-AGG-ID: 0WBM6mwuMKusKHS7yvEBmQ_1758206507
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2b0eba08so6321305e9.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 07:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758206507; x=1758811307;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XGS8iYxGjjgCtPNfLtzzgPnXWY2Ig3ulBcoQ+vUpdX4=;
        b=UolCeUGuHXUO22reAdeEOdZhuo2vAz4XNbGSzw2vjUXENTW9TqnQ8PC216rBHeuFjH
         Y/qVzBfTJCR+1MlgbFQRY6Chn+RvjjoeSENEJoT/KjhEanBSBMHfuovVZWpUmnHrtVrb
         wgK7OSRbbHKuzpOQAdwNV2VU2NsI5EnxtDRTBjx9DWUJW3xa7I6XgH8f1uYrW9Jj9c1l
         mmAZxThkmzKbiCFJ0kPW9uvFZXIlTBgdTxN4Hk2TYli6nWuJ3Xtv/RDTvVssdRbaGwr+
         LMi80ZqMmc9b9CVUMa7ryelWbom+i6bBfHaI1kaCQbWliqGOh+/kpfVLNHotjz1Ttw9C
         Wkmw==
X-Gm-Message-State: AOJu0YxcrbDA4PLVU89/bM318UfUzxoG6Ceksb7MUuMmqK66spFHbWEM
	qpfVoXZ7VfoMUk9gqjiL0KR35mtcPYL2igufXP1taAu6+MMNDNzhGgRJibK70ildK1OLKSwgf2i
	2wpvb1Mi8KwLzH+gIc83/IEdrM0ixAA4llN82M19gQ8G3M8UE2d7r9w==
X-Gm-Gg: ASbGncuHEKw9rCY6JU1A8vlvioRIEuF55TUsGMdTOqvsS16zE3uSeJ0nFt9CWrLkCmZ
	PSWVLtUnqIpoAGv5x5vXgF5qmEuC68vsoWRy7h2Qy/rckR6dTKLa/v0KHw+gou5o6FbT+qozY0Z
	06sKiE2xuQL/8SZ1wvlojTHiLOCedfXEt9WlOjIPspgGWAu+GuKy9LlG/BYgO6kVk2em5QnSMk/
	9OSGbp+wmTRL/AIixKKFbxwliONw4PSRSoFGgsns1j5UT+wonKije4ZYDd+MFfTyxr3tXq/AClN
	poecMN9hpE8L6kOC9xCSApoEK41QjwvjO1w=
X-Received: by 2002:a05:600c:3b05:b0:461:8b9d:db1d with SMTP id 5b1f17b1804b1-46201f8aa61mr51947635e9.7.1758206507306;
        Thu, 18 Sep 2025 07:41:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6KtyNG51lUBBb+796Ksha+xJ3k91Ah4nN79uv8tPH32cwmgf4CIFGIqg2jBve/wowaCq5Rg==
X-Received: by 2002:a05:600c:3b05:b0:461:8b9d:db1d with SMTP id 5b1f17b1804b1-46201f8aa61mr51947335e9.7.1758206506772;
        Thu, 18 Sep 2025 07:41:46 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f0aac3fdsm42562565e9.1.2025.09.18.07.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 07:41:46 -0700 (PDT)
Date: Thu, 18 Sep 2025 10:41:44 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alok.a.tiwari@oracle.com, ashwini@wisig.com, filip.hejsek@gmail.com,
	hi@alyssa.is, leiyang@redhat.com, maxbr@linux.ibm.com,
	mst@redhat.com, seanjc@google.com, stable@vger.kernel.org,
	zhangjiao2@cmss.chinamobile.com
Subject: [GIT PULL] virtio,vhost: last minute fixes
Message-ID: <20250918104144-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:

  Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 549db78d951726646ae9468e86c92cbd1fe73595:

  virtio_config: clarify output parameters (2025-09-16 05:37:03 -0400)

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

Sean Christopherson (3):
      vhost_task: Don't wake KVM x86's recovery thread if vhost task was killed
      vhost_task: Allow caller to omit handle_sigkill() callback
      KVM: x86/mmu: Don't register a sigkill callback for NX hugepage recovery tasks

zhang jiao (1):
      vhost: vringh: Modify the return value check

 arch/x86/kvm/mmu/mmu.c           |  7 +-----
 drivers/char/virtio_console.c    |  2 +-
 drivers/vhost/scsi.c             |  2 +-
 drivers/vhost/vhost.c            |  2 +-
 drivers/vhost/vringh.c           |  7 +++---
 include/linux/sched/vhost_task.h |  1 +
 include/linux/virtio_config.h    | 11 ++++----
 include/uapi/linux/vduse.h       |  2 +-
 kernel/vhost_task.c              | 54 ++++++++++++++++++++++++++++++++++++----
 9 files changed, 65 insertions(+), 23 deletions(-)


