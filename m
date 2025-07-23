Return-Path: <kvm+bounces-53247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E4FB0F410
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE41F7B9BC0
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C906A2E8DF0;
	Wed, 23 Jul 2025 13:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D0Pb6NzP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829382E7BA3
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753277588; cv=none; b=JKw0qJF6W5DdS9xMf7LIiDdFSRFwyOTHo8/bHtuemZipQyXXwxTlG81Eku7iFvwueUIG59mQy48p0mSCpIFhpn+rJDElepq2hCXCb7iIwnWxsW0GlGIUUDPbC3UAZpvzPR0IAOb1PbjyVZUcpEWLx4UEEZ5VRtZh2FjSFkihTNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753277588; c=relaxed/simple;
	bh=X9zCDN0Jw1pFsgcIO98Rf+SGmIXT2ODPt0EmGeDVdXo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QHYuaHclpeMLNKYO8+GGXd0zoIpUNiz5xIfulmTMAOBGSf8c/qr5fh56LqsZLg0gs6iLM5EvJgh/ua8I1/Sx8XYRN+Rr7kjz0v4eyMAmvZFFMqPSYu6zaUnHvVjaccRUaTXLY90gdNW7RX2wp4/K72LxoMnDy5arZZNlvXKc+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D0Pb6NzP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753277585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JyJdFmhjA6tFSmnZMfOHLMsD08VHaKsgXBvphvLX+lg=;
	b=D0Pb6NzPnS2Zb1IWUzLGiHR1vAKTnD+qWBUuyZim7KgfR4lXQaCnh0i0QjYtzzrSl+Xxpv
	uELaoNu7WY+v5evTw29tVoMWLlX73Qr5h8Y4TZrPJFuMJX2WLxykO/bd3lED+5Ga/LGjQR
	tig8lR0A9q/E5o/22LuA46NOef5kkBs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-yS1NGVQMMFSuIcsZ34JIUw-1; Wed,
 23 Jul 2025 09:33:02 -0400
X-MC-Unique: yS1NGVQMMFSuIcsZ34JIUw-1
X-Mimecast-MFC-AGG-ID: yS1NGVQMMFSuIcsZ34JIUw_1753277581
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39AA719560BE;
	Wed, 23 Jul 2025 13:33:01 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.2])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C613119560A3;
	Wed, 23 Jul 2025 13:33:00 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 0169C21E6A27; Wed, 23 Jul 2025 15:32:57 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,
	mtosatti@redhat.com,
	kvm@vger.kernel.org,
	aharivel@redhat.com
Subject: [PATCH 0/2] A fix and cleanup around qio_channel_socket_connect_sync()
Date: Wed, 23 Jul 2025 15:32:55 +0200
Message-ID: <20250723133257.1497640-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Markus Armbruster (2):
  i386/kvm/vmsr_energy: Plug memory leak on failure to connect socket
  vfio scsi ui: Error-check qio_channel_socket_connect_sync() the same
    way

 hw/vfio-user/proxy.c          | 2 +-
 scsi/pr-manager-helper.c      | 9 ++-------
 target/i386/kvm/vmsr_energy.c | 6 +-----
 ui/input-barrier.c            | 5 +----
 4 files changed, 5 insertions(+), 17 deletions(-)

-- 
2.49.0


