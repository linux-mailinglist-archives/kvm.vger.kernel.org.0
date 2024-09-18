Return-Path: <kvm+bounces-27086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60AB597BE99
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B296283937
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19A7A1C9877;
	Wed, 18 Sep 2024 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="V6N/T07X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852291BAEF4
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673305; cv=none; b=U5YEK8xGchT1AAqZyGfLn2WqildbD5dNN43qTUelsy1yCsc6OWaQSG48KhW80p+PKZfyStYInxk2wSlr9iv5T06sXKo+tENhsySJMopN9Gt/8LhueA10B3A9RfIpz2eVLAcObqfF9Z77waVuoVECUe6bu1ACAdZuIl6gpJcNN4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673305; c=relaxed/simple;
	bh=HvbYUAUuqxfvZVUyVuSjHY5g7ZmMcbW5eX1OPbSI7ak=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFpeWzdq20M7mkTgHwFwe41A3hliAparvidHB7SBJ2Qrz2qg9mVuCoyKjZ5eLfiP6JmJXsSrBuIijfwKOigCcqOlhupexJVczMbnB/yiM1TuzCrCnPaLOE3bC0tTAk3sxYnE6i7sEWDly1Qc1/tWdxJVqd0cvQLlhXwbEdHoKqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=V6N/T07X; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673303; x=1758209303;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Mrvf5QEc5i3VRcPPRer2E9I3RCr3GLlTIVg8suSOwps=;
  b=V6N/T07XY/pYp1J6oHHuVvTmKUTrk3BhzbjOBuTdBwxIvPzrPEtJ6I4l
   80U0W0y9v/7i/1akI90CMHNyRJapqymRAmhc8r3xIicNIhOZcnbi6BNjk
   psEhfPW/EcKRjKylI/8JjoAX0Hr/Eqa4OX8B5mNohgC8diWYjTjFOc5kH
   I=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="127584803"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:22 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:54141]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.8.19:2525] with esmtp (Farcaster)
 id 4c766550-61e7-4d25-8d36-b3acac605531; Wed, 18 Sep 2024 15:28:20 +0000 (UTC)
X-Farcaster-Flow-ID: 4c766550-61e7-4d25-8d36-b3acac605531
Received: from EX19D018EUA003.ant.amazon.com (10.252.50.163) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:20 +0000
Received: from EX19MTAUWB002.ant.amazon.com (10.250.64.231) by
 EX19D018EUA003.ant.amazon.com (10.252.50.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:20 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.228) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:19 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id 869FC4043E;
	Wed, 18 Sep 2024 15:28:18 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 7/8] KVM: arm64: enable hardware dirty state management for stage-2
Date: Wed, 18 Sep 2024 15:28:06 +0000
Message-ID: <20240918152807.25135-8-lilitj@amazon.com>
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

Enable hardware management of dirty state for stage-2 (VTCR_EL2.HD)
translations. Set VTCR_EL2.HD unconditionally. This won't allow hardware
dirty state management yet as page descriptors are considered as
candidates for hardware dirty state updates when DBM (51) bit is set
and by default page descriptors are created with DBM = 0.

Signed-off-by: Lilit Janpoladyan <lilitj@amazon.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9e2bbee77491..d507931ab10c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -658,7 +658,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 
 #ifdef CONFIG_ARM64_HW_AFDBM
 	/*
-	 * Enable the Hardware Access Flag management, unconditionally
+	 * Enable the Hardware Access Flag and Dirty State management, unconditionally
 	 * on all CPUs. In systems that have asymmetric support for the feature
 	 * this allows KVM to leverage hardware support on the subset of cores
 	 * that implement the feature.
@@ -669,8 +669,10 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	 * happen to be running on a design that has unadvertised support for
 	 * HAFDBS. Here be dragons.
 	 */
-	if (!cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
+	if (!cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38)) {
 		vtcr |= VTCR_EL2_HA;
+		vtcr |= VTCR_EL2_HD;
+	}
 #endif /* CONFIG_ARM64_HW_AFDBM */
 
 	if (kvm_lpa2_is_enabled())
-- 
2.40.1


