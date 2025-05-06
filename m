Return-Path: <kvm+bounces-45548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC3CAAAB907
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D99C13BA6BA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CAF433D9;
	Tue,  6 May 2025 03:59:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FD224B28;
	Tue,  6 May 2025 01:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746494602; cv=none; b=MBShooi3bRhLEBrMZkPUq79o2sY1stmN0mY0xETlkY4Ei20XfDPFMssKeK6IZfwFaZDIcmqJjaybF/RnxMNavy2DJRglOfBkqXJwsqGWDOtKGhPTiDAQJdogEGpAqUSPncZE+efv9jF1DRHLHRsRX1A3xzNzZ1DbWmCapasSiGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746494602; c=relaxed/simple;
	bh=Rz5mAkcAfO2eGMS9ePIIhXXsMu0PG+vS7H048NPddfY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JeFrgEqPc2Ql8IIUd3BI2WWuZWp/A0nSQYyG5ZDLsxdQL+1RhD7jfsePRmmjQ9X8GP1BjCVIFVUuNb7u2H0xi2XBrIGHK/XdnVq9Pc076FudDIeIyhkRZBB09tObGOh6QNZtgYJEFwTg8qiyCxMdLi8vWwlNmUvNJU+l0PrrQEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <seanjc@google.com>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][v2] KVM: Remove obsolete comment about locking for kvm_io_bus_read/write
Date: Tue, 6 May 2025 09:22:51 +0800
Message-ID: <20250506012251.2613-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: BC-Mail-Ex14.internal.baidu.com (172.31.51.54) To
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-05-06 09:22:59:713
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

Nobody is actually calling these functions with slots_lock held, The
srcu_dereference() in kvm_io_bus_read/write() precisely communicates
both what is being protected, and what provides the protection. so the
comments are no longer needed

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Diff with v1: Remove comments, instead of fixing

 virt/kvm/kvm_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a..d9fe087 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5774,7 +5774,6 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 	return -EOPNOTSUPP;
 }
 
-/* kvm_io_bus_write - called under kvm->slots_lock */
 int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		     int len, const void *val)
 {
@@ -5795,7 +5794,6 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_write);
 
-/* kvm_io_bus_write_cookie - called under kvm->slots_lock */
 int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
 			    gpa_t addr, int len, const void *val, long cookie)
 {
@@ -5845,7 +5843,6 @@ static int __kvm_io_bus_read(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 	return -EOPNOTSUPP;
 }
 
-/* kvm_io_bus_read - called under kvm->slots_lock */
 int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		    int len, void *val)
 {
-- 
2.9.4


