Return-Path: <kvm+bounces-33329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 562909E9DB3
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 18:59:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80A131887617
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 17:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5BF1F0E28;
	Mon,  9 Dec 2024 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iX5sLhwq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2621E9B19
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767091; cv=none; b=Jtri81luDpY8r2i2UKuTxqaEpDs5i2VEdnVfpYmd3IKeLTeunbFPTNT7O24PXuoWDEhKfezqO7y6YmwL8B1nNmMdIGw33W+X/d4bAxmi3QmVCJc1ZgDkd8AXRl+rnweMv8JqwjfLU19u4DDZ70G7tHLRRbtQf73b6aWiCLBHVRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767091; c=relaxed/simple;
	bh=VaTHl5CWYXaEUg5GJy076IuF06Ppro6TIwGO5pxBuO0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KvXsfqu9kX3gk6Pr49A20I+90kkSM51FxLSi65aQlB3vHA2y5kgqyQ8/j+INwHofPIurIWhAOkF4hyIYmDo1bgSuRMKK9KHIqvbk+GV7lgNVKxH3r06sWuP2NEiH1OosJW2cE/XO4CH8Ce3OVc8nZNQFoiALP7cefALeadDREdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iX5sLhwq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733767089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PGHdr5xe6OO2VfVdzoKzmBYzOtEMeKKpC50tlN0vOu0=;
	b=iX5sLhwqQogOQG2IhwdZoMwhpr0YMklX3ZPJw0u+0rW9WYdNheh63HbpfZ2NIkWrd2lp7e
	/519EZEeGydBQSqQnFeeMGGdTSrv6bx1amzepN1jpQnmRV2NHnFqapZao0Z5i4l7AKuN3x
	nKQ0mRMCnshaN635h2+OJmRAPwBQgEA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-446-hIhlvnUsMiWopcay2Ie4Qw-1; Mon,
 09 Dec 2024 12:58:05 -0500
X-MC-Unique: hIhlvnUsMiWopcay2Ie4Qw-1
X-Mimecast-MFC-AGG-ID: hIhlvnUsMiWopcay2Ie4Qw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FAFE1956088;
	Mon,  9 Dec 2024 17:58:00 +0000 (UTC)
Received: from starship.lan (unknown [10.22.82.46])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 37B70195606C;
	Mon,  9 Dec 2024 17:57:56 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Long Li <longli@microsoft.com>,
	Yury Norov <yury.norov@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/2] net: mana: Fix memory leak in mana_gd_setup_irqs
Date: Mon,  9 Dec 2024 12:57:50 -0500
Message-Id: <20241209175751.287738-2-mlevitsk@redhat.com>
In-Reply-To: <20241209175751.287738-1-mlevitsk@redhat.com>
References: <20241209175751.287738-1-mlevitsk@redhat.com>
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


