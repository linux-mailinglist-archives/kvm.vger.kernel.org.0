Return-Path: <kvm+bounces-48165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BB8ACACC7
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 12:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E402A175B11
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 10:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95DA720C477;
	Mon,  2 Jun 2025 10:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOa+gu63"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B702040BF
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 10:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748861460; cv=none; b=n4HfwqVThrE65EuBTg5C2Gy+00v8aVa7BDeEoYATQmdbWe+6JAZgRdeoa3b1VSCRN+sSh0GldBz8LAZ8VjHCS3nK+ux8/Jnf3oKbdojqaB1wsJAf5mJlUu1tceBVNqudqZDNvzOeUL+RB7fqukaAKKKhkfPGkPLD7M6cT2cfMpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748861460; c=relaxed/simple;
	bh=cgi0kTnOpIerwwIIUuaZ3WBgd6q8UJBnqjhc3bcbl8o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NB8lZJR/hRWqU39ARfnKdZPAc/0o9BS2LK4zJb03ro53a9aU2WZfWWEyLzaQtNEtx3WOyLr2+06veJlB/x9+3KuKwQR0Jj0ik1JEkyOC2acZqKvu1QHEWruvzia0pieJYvZLgEQrsdvPNTjpbNuKkD4A6+cUsongHzVv6oJKYLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DOa+gu63; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748861457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b5auH/MkILKaGx66deEPmfZPE+HxLBD8pbuM+zpVxxU=;
	b=DOa+gu63lh+idZIVWH03LLlzIutfB7zGmzQ9b/W1Em2ecQd/dVDrL+OLbeIBe+Kg7HeiTz
	nDHjr8bRtSl+nqDJI04+0bIYwM0KPGGmIxCrgs1lYsvWaW+DA/rwya9yXeG8StgNXFjut+
	NmFFWOc9GvyicsjwzEpS0mlH9znSlzI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-413-8vNb6eRoPbKGu8s2W5b5rA-1; Mon,
 02 Jun 2025 06:50:54 -0400
X-MC-Unique: 8vNb6eRoPbKGu8s2W5b5rA-1
X-Mimecast-MFC-AGG-ID: 8vNb6eRoPbKGu8s2W5b5rA_1748861453
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99E45180036D;
	Mon,  2 Jun 2025 10:50:53 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.45.224.29])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AF831800368;
	Mon,  2 Jun 2025 10:50:53 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 93D6B1800609; Mon, 02 Jun 2025 12:50:50 +0200 (CEST)
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-coco@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v2 0/2] x86/sev: improve efi runtime code support.
Date: Mon,  2 Jun 2025 12:50:47 +0200
Message-ID: <20250602105050.1535272-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

v2 changes:
 - rebase to latest master.
 - update error message (Dionna).
 - more details in the commit message (Borislav).

Gerd Hoffmann (2):
  x86/sev/vc: fix efi runtime instruction emulation
  x86/sev: let sev_es_efi_map_ghcbs map the caa pages too

 arch/x86/include/asm/sev.h     |  4 ++--
 arch/x86/coco/sev/core.c       | 14 ++++++++++++--
 arch/x86/coco/sev/vc-handle.c  |  3 ++-
 arch/x86/platform/efi/efi_64.c |  4 ++--
 4 files changed, 18 insertions(+), 7 deletions(-)

-- 
2.49.0


