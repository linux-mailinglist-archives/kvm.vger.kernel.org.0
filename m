Return-Path: <kvm+bounces-50808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B67DBAE9702
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:42:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8F5B17CC51
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E6923D29D;
	Thu, 26 Jun 2025 07:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TEGjrFPc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BFA1B043C
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923765; cv=none; b=WksHeYgov+sdA0iYgpbpbPoauPC2JmLTFoJWCwW7JilWMwEoepJh+sEcfXxeGlTpp9Z8FRNNhaYix0KLByTBMCehF5qjaedGDK7tUXbCQNBlmk2sZHiiNT6XpklyndA/4xSF8ByjmNhah+mjNTIPyBHqq0ncZEBbr9d2Kifk6IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923765; c=relaxed/simple;
	bh=s7YdkI4QlK26d5mLHH6uzqlBsCrWmulEcF2j7Q7vWfA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rK6hjV4fbZkX+QFaTnIkw647qk1rCsggIJxUJ65wtlsefcdZGETGfYkLwzurvkYvkqRlW1tLv5p10UXsyam5bjLrdMgjBx8pglM5UJHPc3Ymi0NJwiBvB3Lx+XjyXEh+Zc+EoMuSzXBljyWBHTzoHNMR7erIR9dM8/ebUj/ebqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TEGjrFPc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750923762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0pmCyCPqlBNto5bm/feF4YES01zWBFEQcdwqWlcvcao=;
	b=TEGjrFPcIIQExLandijwB6XXfJvkz0OQSerKGBrFHARz7EhgZNq92gCRyRceiXA+V7ztAo
	yWWNNa0VUeciyuNR7+cEoUfXS60sw0TFcU4VI3Et8el13wMZCs+Yg5Cy8h/0Os9vPaJHiO
	ft5If9AlX0ZcQkrb5rePfukEh4VJmDQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-30-jfYVBSZWOK-tr1v2h7rMzQ-1; Thu,
 26 Jun 2025 03:42:40 -0400
X-MC-Unique: jfYVBSZWOK-tr1v2h7rMzQ-1
X-Mimecast-MFC-AGG-ID: jfYVBSZWOK-tr1v2h7rMzQ_1750923759
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7325A180028B;
	Thu, 26 Jun 2025 07:42:39 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.32.244])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA8DE196BADB;
	Thu, 26 Jun 2025 07:42:38 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 1BB2518000B2; Thu, 26 Jun 2025 09:42:36 +0200 (CEST)
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-coco@lists.linux.dev,
	kvm@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 0/2] x86/sev: improve efi runtime code support.
Date: Thu, 26 Jun 2025 09:42:33 +0200
Message-ID: <20250626074236.307848-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

v3:
 - pick up updates from Borislav
 - add vmpl check to sev_es_efi_map_ghcbs_caas
v2 changes:
 - rebase to latest master.
 - update error message (Dionna).
 - more details in the commit message (Borislav).

Gerd Hoffmann (2):
  x86/sev/vc: fix efi runtime instruction emulation
  x86/sev: Let sev_es_efi_map_ghcbs() map the caa pages too

 arch/x86/include/asm/sev.h     |  4 ++--
 arch/x86/coco/sev/core.c       | 20 ++++++++++++++++++--
 arch/x86/coco/sev/vc-handle.c  |  8 +++++++-
 arch/x86/platform/efi/efi_64.c |  4 ++--
 4 files changed, 29 insertions(+), 7 deletions(-)

-- 
2.50.0


