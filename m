Return-Path: <kvm+bounces-7782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1751184661F
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 03:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C795B28F505
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 02:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE32101D0;
	Fri,  2 Feb 2024 02:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UnMEjc9I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DD6EAF8
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 02:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706842635; cv=none; b=Qqc15zHTHKWj+UfM1ui0Ls4h4SOkAdtNzsuS+lgGOBooSNrywHpCfoj1tLCGH3pB+in/VFIk977svdxwfzL7MLWYFH5fil7NNXhAUA93pM+JPw05Trb8aF59zKc0gafW11qIKoP485/0TzsE3WgGJjwxy0eFzJqsgU2ep3VfxJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706842635; c=relaxed/simple;
	bh=CFCmJjwKp5av5hjkAYWAQpnhq7Fv7wpmWOVD0ITvnNA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TuajL2XT02mot8xqZ3/XtIa16n4u57uTnyx9g9Vj6JS1UrSSkmdyfI7yGsndGpX2dsKw1CNSDlOQJVdj5h8z0ciSKNmjT3UfeaI7Wx0HAukere8hJfWE5gAkpYeiNJq4AkaD1Pq+rnCVEpOazd5IhYfcuo/SDpdMmGif5iVXKSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UnMEjc9I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706842633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hi+EdE9BcVWpF5frSoCALRQVB52U4QNkUOAopYUQrrE=;
	b=UnMEjc9IXao31DPvQBmqeJjBxxPNZ7CTYpJA5zXxFgJxWs5RnaS2eIeQtpdNy5zKku4kde
	iFxx2Z+5ksOYt6LDv4khiIpnGbz5jzL5QdCLs3U9O8TWJNxlk8PpFCvPzNK5Iba9i4R9cu
	mPdK+slrv7/d/df2+UzRVttb7arCI28=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-DpsQMxLPPnu5XY_HqBOn1Q-1; Thu,
 01 Feb 2024 21:57:08 -0500
X-MC-Unique: DpsQMxLPPnu5XY_HqBOn1Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F24672825BA8;
	Fri,  2 Feb 2024 02:57:07 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8E30C1D36C;
	Fri,  2 Feb 2024 02:57:07 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Eric Auger <eauger@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/5] KVM: selftests: aarch64: Fix the buggy [enable|disable]_counter
Date: Thu,  1 Feb 2024 21:56:52 -0500
Message-Id: <20240202025659.5065-4-shahuang@redhat.com>
In-Reply-To: <20240202025659.5065-1-shahuang@redhat.com>
References: <20240202025659.5065-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

In general, the set/clr registers should always be used in their
write form, never in a RMW form (imagine an interrupt disabling
a counter between the read and the write...).

The current implementation of [enable|disable]_counter both use the RMW
form, fix them by directly write to the set/clr registers.

At the same time, it also fix the buggy disable_counter() which would
end up disabling all the counters.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 tools/testing/selftests/kvm/include/aarch64/vpmu.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/vpmu.h b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
index f78c93a08bff..92715021f892 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vpmu.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
@@ -77,17 +77,13 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
 
 static inline void enable_counter(int idx)
 {
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenset_el0);
+	write_sysreg(BIT(idx), pmcntenset_el0);
 	isb();
 }
 
 static inline void disable_counter(int idx)
 {
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
+	write_sysreg(BIT(idx), pmcntenclr_el0);
 	isb();
 }
 
-- 
2.40.1


