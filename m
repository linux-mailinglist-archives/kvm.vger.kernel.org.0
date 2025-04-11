Return-Path: <kvm+bounces-43145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A11EDA856D8
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A178175070
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 08:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3178528F936;
	Fri, 11 Apr 2025 08:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QcoNEaIC"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173C2290BCF
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744360959; cv=none; b=KcXADyVZzE4x6yu7ghpzrFMf+R40cZRrTj+nwlOxR3fzfW8Q+Zd1+3PCCldIi9ZUONKjDdTheHjB+qQXwdBYyStmh7nEERCWVWAyaiGJR6F+8AtldKVpJdQ+ZDc+kKUIgn07B4iiQ+83Cey0tKKzIokvbFxrClae/eKI6LIUsJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744360959; c=relaxed/simple;
	bh=xczJTV805XwY69aZprlClTihI5ZLithnddgBF8DmLCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qPwUaHRV6ISR03iO5uQAxyscT0LXyboENihZU7R7CYJEZrkOG8+4NLdEj0KMtqoT0YiEu9eWyVHUs9xNBm8PcJzsnKQuxFMuDGuhPJd2qvJ4nwc9U+Ry/Fn3nwQgNGRaHNuRxQFD3t5LiY/0MO1ZzrjewjsqlSu+eD4/SgPYkqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QcoNEaIC; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744360953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MdTcTTn9V7geK5rQuA+yDIzL/vSURyQGllXaAX2HpQA=;
	b=QcoNEaICIR7s08TAtqE8OHsqC62eyCEeqIvkymDTx3s0HSiFqrlyKIq1Cx5BQ2Wdm5uf9X
	GZPohmMqYc36Wc1340M1ZJMOIhq6BVnn+Wa7VHeDsknIPSKvyLm5GHrRaKmSfcLvBJfkoR
	cWLY6m6MounWXUj/gsAPIQEieZIRiFU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] KVM: powerpc: Enable commented out BUILD_BUG_ON() assertion
Date: Fri, 11 Apr 2025 10:42:21 +0200
Message-ID: <20250411084222.6916-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The BUILD_BUG_ON() assertion was commented out in commit 38634e676992
("powerpc/kvm: Remove problematic BUILD_BUG_ON statement") and fixed in
commit c0a187e12d48 ("KVM: powerpc: Fix BUILD_BUG_ON condition"), but
not enabled. Enable it now that this no longer breaks and remove the
comment.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/powerpc/kvm/timing.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index 45817ab82bb4..14b0e23f601f 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -38,11 +38,7 @@ static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type) {}
 static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
 {
 	/* type has to be known at build time for optimization */
-
-	/* The BUILD_BUG_ON below breaks in funny ways, commented out
-	 * for now ... -BenH
 	BUILD_BUG_ON(!__builtin_constant_p(type));
-	*/
 	switch (type) {
 	case EXT_INTR_EXITS:
 		vcpu->stat.ext_intr_exits++;
-- 
2.49.0


