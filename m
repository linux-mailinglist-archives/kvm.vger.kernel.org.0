Return-Path: <kvm+bounces-38182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D20A364B6
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 18:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCDCE3AD78A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 17:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C9F268688;
	Fri, 14 Feb 2025 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="PJnSgHJ5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74700264FA7
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739554626; cv=none; b=TFVKX1iKNnbrbmGroEPD9VMdGSbPjUgA+aRcLSPyS8G3J567Vp/zUIpijGj5KeNS4qaop4zTAvHTtFGarjFtA+ig0SW/+pdoiOdLiRyvYlaMNwD4OdyQgHC9C+2SKPuj3s2rrQb1CMJC+drCk4Gd157ZomSNczvAHAdG7MBBPV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739554626; c=relaxed/simple;
	bh=/h6x2SJp7QmYGWvJDRak0FYvnnFgxwCq0e22OhxNrj8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HGBBF3uIeuRu0K5ekJeGM6fVkb5mL01Yy6txdu5kKO+PJJms5vX0t6aVBKatE3eCzN/Jay1n7L7JaZt7YQ69g2ph2jvuFuWtTV4Ys2LeucfJtc2OHzR4+6zSz7rz5MHk7exjySpwzARmS1bVo/7+kbdGMD4aM7HfNcIAWIaRi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.es; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=PJnSgHJ5; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1739554624; x=1771090624;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5Srb5ixhumHaRfzQmANe0y07xXOEsbuCXdqmXCUO90c=;
  b=PJnSgHJ5LH8NsDF/DR+oKQvq/tTTQdGJ1QqxYRjJJizTPsGeTSLdxNh/
   0mcpa2aZxMVkIPrXrmv9KNYxSBBoRnHSyEc7qWJstAq2CWmO5AzeF0e+7
   Qvuu3M71GfuUqU6helUnX+s6MqT11nqT3FS6rDf5o++6PLj/zG7ytbg66
   M=;
X-IronPort-AV: E=Sophos;i="6.13,286,1732579200"; 
   d="scan'208";a="408713750"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 17:36:59 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:48716]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.127:2525] with esmtp (Farcaster)
 id adf4c87c-216b-49df-b1a4-b0dc26522e17; Fri, 14 Feb 2025 17:36:58 +0000 (UTC)
X-Farcaster-Flow-ID: adf4c87c-216b-49df-b1a4-b0dc26522e17
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Fri, 14 Feb 2025 17:36:57 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 14 Feb 2025 17:36:56 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <nh-open-source@amazon.com>, <nsaenz@amazon.com>
Subject: [kvm-unit-tests PATCH] x86: Make set/clear_bit() atomic
Date: Fri, 14 Feb 2025 17:36:44 +0000
Message-ID: <20250214173644.22895-1-nsaenz@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

x86 is the only architecture that defines set/clear_bit() as non-atomic.
This makes it incompatible with arch-agnostic code that might implicitly
require atomicity. And it was observed to corrupt the 'online_cpus'
bitmap, as non BSP CPUs perform RmWs on the bitmap concurrently during
bring up. See:

ap_start64()
  save_id()
    set_bit(apic_id(), online_cpus)

Address this by making set/clear_bit() atomic.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 lib/x86/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index da1ed662..82507787 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -843,13 +843,13 @@ static inline bool is_canonical(u64 addr)
 
 static inline void clear_bit(int bit, u8 *addr)
 {
-	__asm__ __volatile__("btr %1, %0"
+	__asm__ __volatile__("lock; btr %1, %0"
 			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
 }
 
 static inline void set_bit(int bit, u8 *addr)
 {
-	__asm__ __volatile__("bts %1, %0"
+	__asm__ __volatile__("lock; bts %1, %0"
 			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
 }
 
-- 
2.47.1


