Return-Path: <kvm+bounces-16780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EFF8BD998
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 04:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F01A2826ED
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 02:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EDC3D0AF;
	Tue,  7 May 2024 02:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sfc.wide.ad.jp header.i=@sfc.wide.ad.jp header.b="ieZGML8O"
X-Original-To: kvm@vger.kernel.org
Received: from mail1.sfc.wide.ad.jp (mail1.sfc.wide.ad.jp [203.178.142.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF1B46A4
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 02:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.178.142.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715050668; cv=none; b=aOJvFbCYedgxdx0iImU5/UHP1qQ7R7ptpHPPvSfxITIb1QxrUKXtC0Yt8uYF7eh0gOdfsGED5QXHk+MUnHWI7oH1RL+dmU8TtHULh+Dpfz1WOOh0NC4tEhOLHc1yysbtQeJhUIaZ/Q0C8b2AdO6sTYAppdkdmlDucIrb+QmcmBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715050668; c=relaxed/simple;
	bh=BBFe5LEv4h/iv3i4//v6b2vpeYZ629qoaGvgPLz4eww=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nlU3M6zvfhfBmzvis6vTX6f9u5bD4qWeaFKrzcNRtLGvC//7RTiX2/AqzO60odFoVFBavvxhGc/tKT6Z0Ifyu5eZaN3kWqlsBXd8hN3lU1U0KclPHM9NaIHDHtKrAQIVrk/rpBPX+TWM2CboR8PlJ0l672TF5xHa/X9XmstAxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sfc.wide.ad.jp; spf=pass smtp.mailfrom=sfc.wide.ad.jp; dkim=pass (2048-bit key) header.d=sfc.wide.ad.jp header.i=@sfc.wide.ad.jp header.b=ieZGML8O; arc=none smtp.client-ip=203.178.142.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sfc.wide.ad.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sfc.wide.ad.jp
Received: from k8s-worker-01.tail087753.ts.net (unknown [IPv6:2400:4051:3e03:2d00:1e98:ecff:fe05:4840])
	(Authenticated sender: mii)
	by mail1.sfc.wide.ad.jp (Postfix) with ESMTPSA id C2847C5838;
	Tue,  7 May 2024 11:51:32 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sfc.wide.ad.jp;
	s=mail1; t=1715050292;
	bh=BBFe5LEv4h/iv3i4//v6b2vpeYZ629qoaGvgPLz4eww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieZGML8OOPXAerCPyfLWs92zvxAF4hab+tE8HFI7fe5CoEK4893pD/FIqJxtrtKFQ
	 +V7ARdUayTJYSsj9Zmxj3rPfOLoznTQpJbmtzpf9tUpZ3s7DNWVK3R+BbRVyXb2Ksz
	 MdnDloBhSDDvNWGtGfbm4ZUMgNhX8s38hv86mhAyVjCoSLbuQXG+Zjhjncnyyp7vrD
	 1iWQaSW5D8dGPCF1ZJdhhwvySIHKnrYtgDX2rAjpg3NAd/555Jz+0CrK8L7oP4nGG2
	 MWA/EeS8WWOuTK1o5oKcYkyyyOeWYwY/MhdXjSDHSwyvOQ6GRGgUiCS1fuCzLHqlQc
	 yA20NCv2XDnaQ==
From: Masato Imai <mii@sfc.wide.ad.jp>
To: qemu-devel@nongnu.org
Cc: Masato Imai <mii@sfc.wide.ad.jp>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH v3 1/1] accel/kvm: Fix segmentation fault
Date: Tue,  7 May 2024 02:50:11 +0000
Message-Id: <20240507025010.1968881-2-mii@sfc.wide.ad.jp>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240507025010.1968881-1-mii@sfc.wide.ad.jp>
References: <20240507025010.1968881-1-mii@sfc.wide.ad.jp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the KVM acceleration parameter is not set, executing calc_dirty_rate
with the -r or -b option results in a segmentation fault due to accessing
a null kvm_state pointer in the kvm_dirty_ring_enabled function. This
commit adds a null check for kvm_status to prevent segmentation faults.

Signed-off-by: Masato Imai <mii@sfc.wide.ad.jp>
---
 accel/kvm/kvm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c0be9f5eed..544293be8a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2329,7 +2329,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id)
 
 bool kvm_dirty_ring_enabled(void)
 {
-    return kvm_state->kvm_dirty_ring_size ? true : false;
+    return kvm_state && kvm_state->kvm_dirty_ring_size;
 }
 
 static void query_stats_cb(StatsResultList **result, StatsTarget target,
-- 
2.34.1


