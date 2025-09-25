Return-Path: <kvm+bounces-58748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54093B9F702
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 15:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1E733B2887
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 13:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114F321ADA4;
	Thu, 25 Sep 2025 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DECKPo1S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A79D212548
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758805822; cv=none; b=kMOQR/dxN9GtluLTCQRbw0nsV876sjN8T0ZE3EO5UNKXx8gRHeQtzJDnhkF4o5TkmYebYBruNna3z8RydYHYWzfBKnN7jkEbe38noNSSGmJOXR/IvS3nN1yjaS+irhxDQRUWcvZc85skypcYWq2+ObnB+fbi0/+7y7A3Of5Bs60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758805822; c=relaxed/simple;
	bh=0B43x3hO60s/q7zuJq3RHOjXfJvIsP5KZNO4MN7Tppc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qJp1NkghCkqDVk8CP5CNDdnFqDtHM9vxJovRI/iDiUprfWeG1d1A0r0HqncODIc4Za3X35nj4KFyUIy9VXJcAyfY44DiYoKW5gMNkZ05jtKLvjwUDquFWfGjJh+O9igBR8fVBhOvxCe64TKwZetLyDEGUNvEPrDzFd/qdd4eXnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DECKPo1S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758805819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=KW0ZC7vXwF1U7peaSsttqsWo+PHv2YRJfJzgYOs3pfE=;
	b=DECKPo1SUylXy39P44wVpzMhUT+EypRxLpfO4IcaL/fBeyI+Wu13YdAbJ98dYjb/+o31O6
	/0ZNnafaqFkkWgqVn51c5pBwphpaEDiRvAeY5ZedEHxY3FXWxJ5p53xWiP/6rWYuqBRSxS
	oTiaJa7kcFOxICzJvnV7OjhxoNzjBCs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-9SV3UfcTNdK_ISU1eV15ag-1; Thu, 25 Sep 2025 09:10:17 -0400
X-MC-Unique: 9SV3UfcTNdK_ISU1eV15ag-1
X-Mimecast-MFC-AGG-ID: 9SV3UfcTNdK_ISU1eV15ag_1758805817
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdc9dbc5fso706293f8f.1
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 06:10:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758805816; x=1759410616;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KW0ZC7vXwF1U7peaSsttqsWo+PHv2YRJfJzgYOs3pfE=;
        b=K6b4diDhFGK7GMqi3yv7ewrqfjH24FWN9uGebApx2+O6YimlavRHRRRry8qEELNKGi
         6SRMSsKV7uN2BJkebpAfBuA3WdqpXcKSbF6LzNN+ksO4mBtLdY+jUfj7C/DCF1htc9TS
         C2k++nrNJEwYFx20IzYnblN+lCz1iUyoeP2QOi3/z0F08Xxk+cxr5iV6oBZ/WfNxkMnV
         j0f47BzfxrkLYQ3OXEnVfT9R/AZzjFBdxJmglElmXURMzvCRJ1RGaEuJ4fJhaet23vJf
         JSn0XTEqUXk6yOoi8a8kFkQMhhzIgwPyOjkdK6pt5zf9k4rUBf4V3DqG/K6yT2ug94F8
         we0A==
X-Gm-Message-State: AOJu0Yxy3sYmk05vqVHLTTXDm4ZaXc4W8rUAWyRX/kPnZ9Ocfo0gKIM9
	GfjqUv+eM8btchh/Loz1uMel5wc++sijEmHpBlbE2/gqQZjobTxzq0LWlFyxzJIdYSuVoy0aNCl
	Rhi7oDDWsvLvqJML/By8HMbq8sI1/KE2WY+1DjdJWDtXPWY4d8tGvFg==
X-Gm-Gg: ASbGncsv3hz/WHDUcuz6JXuMbe5xAskSWQCN3hZCZlG8cXo+o8sFVV6FKIi8qtKxI06
	e0CbW2ykWaRQnxkAku6mXPXR8PET3jQVEG/Z6Sgcck2qd/mk/fmPMo2udW1bTBR39h3wyh0cFPA
	ATCUTw2F/6kKOMyWEaqIaZkybrM2WiJHmlpPdU+I6Gb7LBFDXgZFNKahzKAg9OpkRyXJKaX/tuC
	koRAx5B9GRDH0joND8muFXl1VJ48eNax7KQppV3GANGPZRxVbaCgjry4b/FcTKNpxOH5+jQPltg
	d1rDSzK+rxppEagsSZ6N7FbQuw7Hr7yMuw==
X-Received: by 2002:a5d:588c:0:b0:3fb:37fd:c983 with SMTP id ffacd0b85a97d-40e48a57465mr3216282f8f.49.1758805816381;
        Thu, 25 Sep 2025 06:10:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzU/fT07/taXxNhpSlgViOVy92VqAS1NyA0bx0hGfqPg/L3VBSKrQfSmeVvB7FScm07URuig==
X-Received: by 2002:a5d:588c:0:b0:3fb:37fd:c983 with SMTP id ffacd0b85a97d-40e48a57465mr3216242f8f.49.1758805815830;
        Thu, 25 Sep 2025 06:10:15 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1538:2200:56d4:5975:4ce3:246f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72facf9sm3112468f8f.13.2025.09.25.06.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 06:10:15 -0700 (PDT)
Date: Thu, 25 Sep 2025 09:10:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alok.a.tiwari@oracle.com, ashwini@wisig.com, bigeasy@linutronix.de,
	hi@alyssa.is, jasowang@redhat.com, jon@nutanix.com, mst@redhat.com,
	peter.hilber@oss.qualcomm.com, seanjc@google.com,
	stable@vger.kernel.org
Subject: [GIT PULL] virtio,vhost: last minute fixes
Message-ID: <20250925091012-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

I have a couple more fixes I'm testing but the issues have
been with us for a long time, and they come from
code review not from the field IIUC so no rush I think.

The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:

  Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to cde7e7c3f8745a61458cea61aa28f37c3f5ae2b4:

  MAINTAINERS, mailmap: Update address for Peter Hilber (2025-09-21 17:44:20 -0400)

----------------------------------------------------------------
virtio,vhost: last minute fixes

More small fixes. Most notably this fixes crashes and hangs in
vhost-net.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alok Tiwari (1):
      vhost-scsi: fix argument order in tport allocation error message

Alyssa Ross (1):
      virtio_config: clarify output parameters

Ashwini Sahu (1):
      uapi: vduse: fix typo in comment

Jason Wang (2):
      vhost-net: unbreak busy polling
      vhost-net: flush batched before enabling notifications

Michael S. Tsirkin (1):
      Revert "vhost/net: Defer TX queue re-enable until after sendmsg"

Peter Hilber (1):
      MAINTAINERS, mailmap: Update address for Peter Hilber

Sebastian Andrzej Siewior (1):
      vhost: Take a reference on the task in struct vhost_task.

 .mailmap                      |  1 +
 MAINTAINERS                   |  2 +-
 drivers/vhost/net.c           | 40 +++++++++++++++++-----------------------
 drivers/vhost/scsi.c          |  2 +-
 include/linux/virtio_config.h | 11 ++++++-----
 include/uapi/linux/vduse.h    |  2 +-
 kernel/vhost_task.c           |  3 ++-
 7 files changed, 29 insertions(+), 32 deletions(-)


