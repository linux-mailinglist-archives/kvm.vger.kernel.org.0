Return-Path: <kvm+bounces-59342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E96BB1643
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E00BF1C2FBC
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AE2258EDF;
	Wed,  1 Oct 2025 17:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=josie.lol header.i=@josie.lol header.b="EH7EU1tJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-108-mta153.mxroute.com (mail-108-mta153.mxroute.com [136.175.108.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A175648CFC
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759340763; cv=none; b=HUo89JDY1UYGXZKhTRnaJFvG4MJOERnRCx8fFXovp41BItQc2NrRPCCUYExaFQJgxkVJ1lNoLLJF3N3dfDp/jkNtg20cl+4LrmPKS8Ih1etR1zr+I7yew0QeW2Im1dcVE/SgSUoa4NZ2ym9txSBwACDYusdrBId00glBUJn+ZK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759340763; c=relaxed/simple;
	bh=iiVkYuz/2XXwRBeJ5iI3BuDDQXdoqvoAcA4HlOwwwJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CY+IGlnMkLsVpBwDSec947vpBp9uXUUZQe3skk7jeaMeq1+kmOaB4TtB2s5FsTdNgJ//ZnU3HOSUCgKIlbTPd64hHYLNpSOZULVavqaTkZGKdTI6n+rXwkXpeR6OyswSYGLpbSNpt0gUgPZHev8gNx+GRy6GH3SFqlNntp06Ev8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=josie.lol; spf=pass smtp.mailfrom=josie.lol; dkim=pass (2048-bit key) header.d=josie.lol header.i=@josie.lol header.b=EH7EU1tJ; arc=none smtp.client-ip=136.175.108.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=josie.lol
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=josie.lol
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta153.mxroute.com (ZoneMTA) with ESMTPSA id 199a0dcd350000c244.009
 for <kvm@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Wed, 01 Oct 2025 17:40:50 +0000
X-Zone-Loop: c80395170e901d9e09722bc2e7d0f48e16fd82f8ec08
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=josie.lol;
	s=x; h=Content-Transfer-Encoding:MIME-Version:Date:Subject:Cc:To:From:Sender:
	Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=IibJPiL24xaDFWeZlLX0HfLUN4QwapSI53d0jSp1xlw=; b=EH7EU1tJE1AK
	I1tkycOlhPLTdFSxHQ8hcPJMRxU55WWQBjoIozUj7EquMztld30vP22GJWrfLsNHgr2UAjhUibXq/
	4yCQjHraVM6RnRRWo79oayHkV/yZHLWAm9Q3Bsvw0/qGXP6jdD80NrQ6JIvtnEG6bX1HmB++F3q1h
	6PvkfUnbllXEKzSpT2W+AcZt171j1qGkbwfnDZ/CEMMBfQ0HOKRWuyId1+PwY1/iIIpkbUVDjWLEw
	6MOO+dK9QmQTOB3FEtu7bgdtTFih2O0gO+4OzAHZE78hdilqKsta0gBBylB5uVtN056VuWOmCqRK1
	4VzKLEH0YAqK9kWvULkHMw==;
From: Josephine Pfeiffer <hi@josie.lol>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] s390/kvm: Replace sprintf with snprintf for buffer safety
Date: Wed,  1 Oct 2025 19:40:46 +0200
Message-ID: <20251001174046.192295-1-hi@josie.lol>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Id: hi@josie.lol

Replace sprintf() with snprintf() when formatting debug names to prevent
potential buffer overflow. The debug_name buffer is 16 bytes, and while
unlikely to overflow with current PIDs, using snprintf() provides proper
bounds checking.

Signed-off-by: Josephine Pfeiffer <hi@josie.lol>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6d51aa5f66be..005c117be086 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3371,7 +3371,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 			((char *) kvm->arch.sca + sca_offset);
 	mutex_unlock(&kvm_lock);
 
-	sprintf(debug_name, "kvm-%u", current->pid);
+	snprintf(debug_name, sizeof(debug_name), "kvm-%u", current->pid);
 
 	kvm->arch.dbf = debug_register(debug_name, 32, 1, 7 * sizeof(long));
 	if (!kvm->arch.dbf)
-- 
2.51.0


