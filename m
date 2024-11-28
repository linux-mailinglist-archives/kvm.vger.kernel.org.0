Return-Path: <kvm+bounces-32762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEDF9DBCAD
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 20:43:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C935E281596
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 19:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F6C1C2DA2;
	Thu, 28 Nov 2024 19:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixxv/WY3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CE0AD4B
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 19:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732822995; cv=none; b=oqAR2WlgBK8shnrJwI/v5mZgHHZ9IfnmD3Zs3YkdZ8BzoEt71gB4GH2OVgaS7CHrLEKg6jLfTj1IhwI/zlMVipE/JZQFKmUbcW5vuiM3o4SiPMQDccDduoHRunfy4kxrdLGA8iQ6/a03+JT4rUDbjXRxNtQVb2t0B4pnLYj0uxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732822995; c=relaxed/simple;
	bh=VaTHl5CWYXaEUg5GJy076IuF06Ppro6TIwGO5pxBuO0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eHoE+7voaXXVDT6wulaSZsrv7EWEmmF4EteI219tFeQ/S2C4NTICtAlr/INOmcV2B9oEAxQcdZtSwfrpA6DTwDhGLPE6u6dzKJPzke3cUlVzhh4orsC2wumFo302P2+YaJzBirmva8uYMst6BgEenh5L/X+2TNmZpQgqSQxV/e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ixxv/WY3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732822992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PGHdr5xe6OO2VfVdzoKzmBYzOtEMeKKpC50tlN0vOu0=;
	b=ixxv/WY3uPas+H+R2Y1+fecCPVltlJTVbYC2ZVcabq05QQPWZscUJS966ucQydCHgdtCVV
	gC2CrazTgKboE4uTKE+fWOpfZuRt7kKfVfQQahl0KHToFdyYhR6Hzo+kfo9w//riwbq+Bg
	g+Q3jmqoqPMw15hcS/em7y5Xqr/3FLs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-pQL-K4C2OSu2dQbquJMVrw-1; Thu,
 28 Nov 2024 14:43:10 -0500
X-MC-Unique: pQL-K4C2OSu2dQbquJMVrw-1
X-Mimecast-MFC-AGG-ID: pQL-K4C2OSu2dQbquJMVrw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF1651954197;
	Thu, 28 Nov 2024 19:43:04 +0000 (UTC)
Received: from starship.lan (unknown [10.22.88.88])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7ECDB195605A;
	Thu, 28 Nov 2024 19:43:01 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Yury Norov <yury.norov@gmail.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Eric Dumazet <edumazet@google.com>,
	linux-hyperv@vger.kernel.org,
	Long Li <longli@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Leon Romanovsky <leon@kernel.org>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: mana: Fix memory leak in mana_gd_setup_irqs
Date: Thu, 28 Nov 2024 14:43:00 -0500
Message-Id: <20241128194300.87605-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Commit 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
added memory allocation in mana_gd_setup_irqs of 'irqs' but the code
doesn't free this temporary array in the success path.

This was caught by kmemleak.

Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index e97af7ac2bb2..aba188f9f10f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1375,6 +1375,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	gc->max_num_msix = nvec;
 	gc->num_msix_usable = nvec;
 	cpus_read_unlock();
+	kfree(irqs);
 	return 0;
 
 free_irq:
-- 
2.26.3


