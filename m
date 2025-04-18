Return-Path: <kvm+bounces-43651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 593B8A936C9
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:03:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D275467796
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE9A274665;
	Fri, 18 Apr 2025 12:03:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx315.baidu.com [180.101.52.204])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F385F16D4E6;
	Fri, 18 Apr 2025 12:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744977813; cv=none; b=kHrrwyt4j9Viy9Te+W0beKJ56WG6D07wmxZUTeueclBuzcWUjfQlQ/BmdWxRbwWph5RYf7uN+KN4dwz0ipncjLgS9nT04mT3x300YV/XCo3tK+zaaKukhzeQGJY6LeKpZIhKTkpDhv65bOZDhvvKpbaxaJMRRjEW/quQpt1X9sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744977813; c=relaxed/simple;
	bh=aXMtoxRXpb9mtODLaMZUt/U7XWp+XRb3PN7cS5Iy5go=;
	h=From:To:Cc:Subject:Date:Message-Id; b=loeHMWaHAVAMyzUtUtl6NWbEtbAvJ7FWYemuZcZy76ktAd4h/sy+vu5AMS9NkrwRLskwvvINcbrBAsIphsYv9he/PavBERJxGOHRaRyVSrGVyHnWm153fnwgWYrXTzdt9J/7zn/QzP+2aCOEqkMlAgH/hch6dUVkWz0ECtsYdfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 9A9B07F00045;
	Fri, 18 Apr 2025 19:55:08 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] KVM: Fix obsolete comment about locking for kvm_io_bus_read/write
Date: Fri, 18 Apr 2025 19:55:04 +0800
Message-Id: <20250418115504.17155-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Nobody is actually calling these functions with slots_lock held.
The srcu read lock is required.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a..2e591cc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5774,7 +5774,7 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 	return -EOPNOTSUPP;
 }
 
-/* kvm_io_bus_write - called under kvm->slots_lock */
+/* kvm_io_bus_write - called under kvm->srcu read lock */
 int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		     int len, const void *val)
 {
@@ -5795,7 +5795,7 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_write);
 
-/* kvm_io_bus_write_cookie - called under kvm->slots_lock */
+/* kvm_io_bus_write_cookie - called under kvm->srcu read lock */
 int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
 			    gpa_t addr, int len, const void *val, long cookie)
 {
@@ -5845,7 +5845,7 @@ static int __kvm_io_bus_read(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 	return -EOPNOTSUPP;
 }
 
-/* kvm_io_bus_read - called under kvm->slots_lock */
+/* kvm_io_bus_read - called under kvm->srcu read lock */
 int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		    int len, void *val)
 {
-- 
2.9.4


