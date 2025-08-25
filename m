Return-Path: <kvm+bounces-55663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C206B34974
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FDCE1898D2B
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5923090D5;
	Mon, 25 Aug 2025 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i52yWpy3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435C1305E3E
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756144701; cv=none; b=Re9otuXskJEuT5hCIHiH7lt2nd/qYsZ8ScsVMdpe2vE58T0vtaomLbdWOYMDIk/Rsmu0lpkv7PRNEGn/EX9HTzlKl8Y5GxKO8vPcYq2jwbTSB+rtGesXbAhnIZkRuvZoq1tw6jugC5zdkAdjiN9pCgjDOj5VyMsLX6ZvaX/7J6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756144701; c=relaxed/simple;
	bh=WDhRlqwcifzJM8V3Ig1t/ZtG/CN3yZ1PfYwAUT5ReuE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YxMtA3XLydIUV1a/wuCz1J2Bk7fhK/zCl+AmSVDCM9Oc4PPIZwDCBGHKUq6zH7TGuw4NwuHLNEEU1SK2TXees7em7FTgC36TVpfRCtcaWfGd23cwZZgZLX01d0wVQxiEyy8+4vTnDWZARsTVv1xQ9FQsslksh7i5V7gwEI6F3XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i52yWpy3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756144699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YIPIxypSfqE+fy4Eh+zfZM3VN+E68nsIha/aFUFw9n0=;
	b=i52yWpy35AYDA04eDb7a95LFO2BGbf/4zghQo/BIvZJFh69eRzb9myeZOf4+iw9QJlOCeI
	ed0ZWSjJFx2IXT+yXEK2dOrxVmqURYGqZ0YEfv+bmNqHwT8lUNm+7PYEvogJcLr6WP3/6H
	rii2/lJjo7VVqI4cHwfR4NocIRqMLEw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-ltVhhlOsPaq5_PVmR_bM8w-1; Mon,
 25 Aug 2025 13:58:15 -0400
X-MC-Unique: ltVhhlOsPaq5_PVmR_bM8w-1
X-Mimecast-MFC-AGG-ID: ltVhhlOsPaq5_PVmR_bM8w_1756144694
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 951FA18004D4;
	Mon, 25 Aug 2025 17:58:14 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.64.176])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E39FD180028A;
	Mon, 25 Aug 2025 17:58:12 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	eric.auger@redhat.com,
	smostafa@google.com,
	praan@google.com
Subject: [PATCH 0/2] vfio/platform: Deprecate vfio-amba and reset drivers
Date: Mon, 25 Aug 2025 11:57:59 -0600
Message-ID: <20250825175807.3264083-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Based on discussion[1] there's still interest in keeping vfio-platform
itself, but the use case doesn't involve any of the current reset
drivers and doesn't include vfio-amba.  To give any users a chance to
speak up, let's mark these as deprecated and generate logs if they're
used.

I intend to pull the vfio/fsl-mc removal from the previous series given
there were no objections.  Thanks,

Alex

[1] https://lore.kernel.org/all/20250806170314.3768750-1-alex.williamson@redhat.com/

Alex Williamson (2):
  vfio/amba: Mark for removal
  vfio/platform: Mark reset drivers for removal

 drivers/vfio/platform/Kconfig                            | 5 ++++-
 drivers/vfio/platform/reset/Kconfig                      | 6 +++---
 drivers/vfio/platform/reset/vfio_platform_amdxgbe.c      | 2 ++
 drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c    | 2 ++
 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 ++
 drivers/vfio/platform/vfio_amba.c                        | 2 ++
 6 files changed, 15 insertions(+), 4 deletions(-)

-- 
2.50.1


