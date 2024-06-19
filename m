Return-Path: <kvm+bounces-20004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B44D490F551
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 19:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FECBB20D70
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1F8154C16;
	Wed, 19 Jun 2024 17:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E2wk9mJa"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F089515572F
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 17:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818853; cv=none; b=GEQ7H4AL5t81u3dvM/VXa+mR4Ml1LH67fv/xqkaU19fPn947UAq7lG04O5G2zdxngio/S42QXr9MmMHlbnbkQEHDc+b166BQaMYX5roSC0m+1yPCg0iZHLuj14vwkI9MwgUcqQx8yNH9+9BKjbRs6SDGMhj/QsFjnXiNL+D8oqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818853; c=relaxed/simple;
	bh=ah2Ud0Emqs7MiYPhZsk+yzVqKpBYMG4icdhsrogIPWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThwPrtQFFFQDD53kQyf4euODZOfOHDN+D+ehyYCKUT0CNsraq1FleZSZ0Kjc/9P+5zzb9CMKOnEuGL78RR7mg6ZsDAyFDiw5tBF7eQkAn44P0KiurnYLIJX2/NZBmKqe+UffidHV5TY8kVtSSHoHJ9ShimvUYGQv6tQgnD7UFi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E2wk9mJa; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=inCZB7yLoO8sOkHWR/qe7HFeOgCtGBU9Y06+qtJ8a1w=;
	b=E2wk9mJartlgHjQG5Lz8NOa9RvZliF3k78pJWbY8PtuX5PRQi+USeZZKE17KnDEMYF0Qw8
	2mwVO95tdQRBoPGEkThRlfrbWedWG4EnH8ofgpHQ90slJumAOHPUEf+tHZc7fefDdWhEsf
	PdQudafzoIX97SWcEXNLOY4c81mrGR0=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: sebott@redhat.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 01/10] KVM: arm64: Get sys_reg encoding from descriptor in idregs_debug_show()
Date: Wed, 19 Jun 2024 17:40:27 +0000
Message-ID: <20240619174036.483943-2-oliver.upton@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM is about to add support for more VM-scoped feature ID regs that
live outside of the id_regs[] array, which means the index of the
debugfs iterator may not actually be an index into the array.

Prepare by getting the sys_reg encoding from the descriptor itself.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..ad453c7ad6cc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3502,7 +3502,7 @@ static int idregs_debug_show(struct seq_file *s, void *v)
 		return 0;
 
 	seq_printf(s, "%20s:\t%016llx\n",
-		   desc->name, IDREG(kvm, IDX_IDREG(kvm->arch.idreg_debugfs_iter)));
+		   desc->name, IDREG(kvm, reg_to_encoding(desc)));
 
 	return 0;
 }
-- 
2.45.2.627.g7a2c4fd464-goog


