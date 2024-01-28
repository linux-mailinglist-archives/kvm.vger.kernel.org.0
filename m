Return-Path: <kvm+bounces-7286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FD483F534
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 12:34:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 421991C20F02
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 11:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D01F72030D;
	Sun, 28 Jan 2024 11:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="q8lyiM9W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26751EB3F
	for <kvm@vger.kernel.org>; Sun, 28 Jan 2024 11:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706441681; cv=none; b=lLA/iR/ADmNbPDj52sEkhpAFG6QDHXXdO26hv+sNVoKm12twMqZISVhhvMKTU4uJ/saNUv2I3FpIkFC1w2IMdezK3mx09F4bMeWEXlFh9COAvzbVlr9VlAMWE1eBUBZ4o+wJp91CoCfrbSVmc4GhRLFS7BlZC1UHmiDLADT4lfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706441681; c=relaxed/simple;
	bh=KIqqe6b7++tdELzI8weZpXwb9c1lX1twgOwQ23G4KaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ca0UREqq4BYYua1JRFEnKPbBuuJpm29nIEn8lxIz8OKFFhZwUP47tza0cs3+Ajbjr1RHtLHIjiVgTHQSbhUriZuO3tpnowU/hB9uVzl7FsjH6Cs7GesAbhwKm0Kiz53CtnM35nfyKPEjopd5Hgvx156zvL19g3xb5LaDo8pOty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=q8lyiM9W; arc=none smtp.client-ip=80.12.242.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from fedora.home ([92.140.202.140])
	by smtp.orange.fr with ESMTPA
	id U3QhrO2WGJujcU3Qirni2Q; Sun, 28 Jan 2024 12:34:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1706441671;
	bh=bty2xukFdRkPEFlCnTL1HrECxC57pxJIVp0ohvU2AgA=;
	h=From:To:Cc:Subject:Date;
	b=q8lyiM9WQo/EgvGQysdvx+kePnrw+P5IQ8+wLP2buInfRszrFigPMdnwqTLcwekay
	 vxgYWtn0UQ+qlLLJH6llJzZRvaCGAwdSDbWvN6MzDu9zJPkJlMt2ntFi93UwdbbudT
	 KhHTSLQ4dxRf+1xEoK3P5vX3oQwnX1hfDina0d1b4sFDov8yKJA3eUUXk6ppcwcRf8
	 599nG14+4uqV+HixiKORto7wOAZ2vzJr3Z9XKK6lCBItSgDixxsBCp6rPYHzNRHZ8U
	 Gt+ZlR2tLvuG91dcgdYNZABgVG238N+WPdZrts6wUkezYezM+bH9s7SjtfUkAomxjO
	 jFHBjw2MxLgNw==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 28 Jan 2024 12:34:31 +0100
X-ME-IP: 92.140.202.140
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Kautuk Consul <kconsul@linux.vnet.ibm.com>,
	Amit Machhiwal <amachhiw@linux.vnet.ibm.com>,
	Jordan Niethe <jniethe5@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Gautam Menghani <gautam@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: PPC: Book3S HV nestedv2: Fix an error handling path in gs_msg_ops_kvmhv_nestedv2_config_fill_info()
Date: Sun, 28 Jan 2024 12:34:25 +0100
Message-ID: <a7ed4cc12e0a0bbd97fac44fe6c222d1c393ec95.1706441651.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return value of kvmppc_gse_put_buff_info() is not assigned to 'rc' and
'rc' is uninitialized at this point.
So the error handling can not work.

Assign the expected value to 'rc' to fix the issue.

Fixes: 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 arch/powerpc/kvm/book3s_hv_nestedv2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
index 5378eb40b162..be5f87e69637 100644
--- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
+++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
@@ -71,8 +71,8 @@ gs_msg_ops_kvmhv_nestedv2_config_fill_info(struct kvmppc_gs_buff *gsb,
 	}
 
 	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_RUN_OUTPUT)) {
-		kvmppc_gse_put_buff_info(gsb, KVMPPC_GSID_RUN_OUTPUT,
-					 cfg->vcpu_run_output_cfg);
+		rc = kvmppc_gse_put_buff_info(gsb, KVMPPC_GSID_RUN_OUTPUT,
+					      cfg->vcpu_run_output_cfg);
 		if (rc < 0)
 			return rc;
 	}
-- 
2.43.0


