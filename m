Return-Path: <kvm+bounces-27087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8236D97BE9A
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB344B20F4F
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CDA1C9879;
	Wed, 18 Sep 2024 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="eQ6up9F0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF5F1C984E
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673305; cv=none; b=RgiJi/sSXj1NYpAahdFS7d0pIoIQF2mw9fZ3hHLEqe+soWwkFITkAccwNoT4exXGJu3+8bm8UlLhj+mos2bIOHhA026ezznrM25vr5VMDLZt1snZlF8e13CQIEO4E/qw9vDAb/8R97qnqz+EEZKBhVoFmv3o0+isi9Nj0kXnv2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673305; c=relaxed/simple;
	bh=TXO4quz4Mn+UlPlrUbatQb4WzsclfIuhR8Ks5+h7PRc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uBAZF4xOC+xdgvmNqS9p092IuksJ0J90RUV7xuzfCkrCXQRXliD0+wdLDK1P343d3YshtlO03Cl13BzoKBGjoQ7BEIgg3Iy+3DLuTIcfyS72U0ZXOczPPL+JygFjaZsoiP8hrcgz4DMZacrQ2PFnQSLTImC+L3PAT2ewGYeCK7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=eQ6up9F0; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673304; x=1758209304;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=o+1ltl0tHyU5VT0TXuY0ad53zHIQ+Akmv2TZGDLX2Mo=;
  b=eQ6up9F0R/MqtbXEYkCsmNcT3sSel+JL5np9FsVzlL39tidQpJ79Xa56
   WifhFeeib63E3RxqLqKVy3hl9mfGLGJ/mKIubWal9kyv5jk4rWofKw6+s
   9+l+nDHJ+BW63sw2BIH7Q/+vpNUxDrFW1z0Kv40cTqv0dKBaoyqdmLVFY
   0=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="434305177"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:21 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:28715]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.41.159:2525] with esmtp (Farcaster)
 id 3fb400e6-91db-4d62-bc61-38f4ea3463bd; Wed, 18 Sep 2024 15:28:19 +0000 (UTC)
X-Farcaster-Flow-ID: 3fb400e6-91db-4d62-bc61-38f4ea3463bd
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:19 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:19 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:18 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id AB47D4041D;
	Wed, 18 Sep 2024 15:28:17 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 6/8] KVM: arm64: flush dirty logging data
Date: Wed, 18 Sep 2024 15:28:05 +0000
Message-ID: <20240918152807.25135-7-lilitj@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240918152807.25135-1-lilitj@amazon.com>
References: <20240918152807.25135-1-lilitj@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Make sure we do not miss last dirty pages and flush the data after
disabling dirty logging. Flush only when dirty logging is actually
disabled i.e. when page_tracking_disable returns 0.

Signed-off-by: Lilit Janpoladyan <lilitj@amazon.com>
---
 arch/arm64/kvm/arm.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 139d7e929266..5ed049accb3e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1877,17 +1877,21 @@ int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot
 
 	r = page_tracking_disable(kvm->arch.page_tracking_ctx, -1);
 
-	if (r == -EBUSY) {
-		r = 0;
-	} else {
-		page_tracking_release(kvm->arch.page_tracking_ctx);
-		kvm->arch.page_tracking_ctx = NULL;
+	if (r == -EBUSY)
+		return 0;
 
-		if (kvm->arch.page_tracking_pg) {
-			free_page((unsigned long)kvm->arch.page_tracking_pg);
-			kvm->arch.page_tracking_pg = NULL;
-		}
+	/* Flush only when dirty tracking is disabled */
+	if (!r)
+		r = page_tracking_flush(kvm->arch.page_tracking_ctx);
+
+	/* But release resources anyway */
+	page_tracking_release(kvm->arch.page_tracking_ctx);
+	kvm->arch.page_tracking_ctx = NULL;
+	if (kvm->arch.page_tracking_pg) {
+		free_page((unsigned long)kvm->arch.page_tracking_pg);
+		kvm->arch.page_tracking_pg = NULL;
 	}
+
 	return r;
 }
 
-- 
2.40.1


