Return-Path: <kvm+bounces-71111-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IOjwLtDgkWkxngEAu9opvQ
	(envelope-from <kvm+bounces-71111-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:05:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B50113EF16
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67C933043016
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFBD2C235E;
	Sun, 15 Feb 2026 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NpBcA46R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7241367;
	Sun, 15 Feb 2026 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167824; cv=none; b=iYBeXPoWlTXC5XcDYZh57Zjv9rNTBBIqHNwspGIM/vHsPkezJU/M+xJXMp+cbsePBErUbCXI1oTFHTzJlJRzIRfqif5eF9AhC36ep3C1/xPXKqUPP2qUhldbuQyA1mIV/SXM2YtR0UqvpEGCguVWKThtQR+HVa46hs9cTjqFBIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167824; c=relaxed/simple;
	bh=6/fOJZ/cgkSRg2NZ2eWT52wyEMPTPVKBORw2726c6CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YE1hzwjbMPZ1A5BPSydhs9+9c5cwcOyVH0jl04d5djyglWNhEWWGQween1uprqBmD2BmMBABeQ/P6mf1ikcDSZGUE8WTtERBUQppPanhSF7Ezq6w8xy0VYk1y9NrhVH/HnIYnVTkeJDG4t9M3w7zLsT1/7Bw8X5MN1AJxTcDVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NpBcA46R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44325C2BC86;
	Sun, 15 Feb 2026 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167824;
	bh=6/fOJZ/cgkSRg2NZ2eWT52wyEMPTPVKBORw2726c6CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpBcA46R4yaO3SQkkiivOLR7fuU/jO/8H4VR3VzkuOgUtJ4MJ3AcwfG6Dukr6M+5M
	 aGtrQaGZn/Dlby4FmeGX2O7fH0g5oFcX9TPK4Nhfh2BbYIhJ9MjTNbiMexJBoEyD1p
	 lvl6jJfQq6R//xZnYnKnPSTdJNrggPKGZdY5HIi5fgYYAvz4VbkaPK5kgMK8C4s2H3
	 LG/nuWU/xUPXd5glnAFO/yaJstFKnfcksCK0OHwuJ5X6GnThXcLL7BGvucgEeoxlrD
	 HUksz3cBXENOlFFHzbKAlJuiuaE/J0+rTdgzoc+lhi3klMh/AwvX3i4fYsGbEye5sC
	 gFybXtHDwSY+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kommula Shiva Shankar <kshankar@marvell.com>,
	Jason Wang <jasowang@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] vhost: fix caching attributes of MMIO regions by setting them explicitly
Date: Sun, 15 Feb 2026 10:03:24 -0500
Message-ID: <20260215150333.2150455-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215150333.2150455-1-sashal@kernel.org>
References: <20260215150333.2150455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71111-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[10];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+]
X-Rspamd-Queue-Id: 3B50113EF16
X-Rspamd-Action: no action

From: Kommula Shiva Shankar <kshankar@marvell.com>

[ Upstream commit 5145b277309f3818e2db507f525d19ac3b910922 ]

Explicitly set non-cached caching attributes for MMIO regions.
Default write-back mode can cause CPU to cache device memory,
causing invalid reads and unpredictable behavior.

Invalid read and write issues were observed on ARM64 when mapping the
notification area to userspace via mmap.

Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260102065703.656255-1-kshankar@marvell.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The mmap functionality has been there since `ddd89d0a059d8` which
introduced doorbell mapping. This fix would apply to all stable trees
that have this function.

### Summary

This is a textbook stable kernel fix:

1. **Obviously correct**: MMIO must be mapped non-cacheable; this is a
   fundamental hardware requirement. Every other MMIO mmap in the kernel
   uses `pgprot_noncached()` or similar.
2. **Fixes a real bug**: Invalid reads/writes on ARM64 — this causes
   device malfunction and potential data corruption.
3. **Small and contained**: Single line addition, no side effects.
4. **No new features**: Just corrects existing mmap behavior to follow
   hardware requirements.
5. **Low risk**: `pgprot_noncached()` is the standard, well-understood
   kernel API for this exact purpose.
6. **High-quality review**: Three expert maintainers
   reviewed/acked/committed.
7. **Self-contained**: No dependencies on other commits.

**YES**

 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05a481e4c385a..b0179e8567aba 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1527,6 +1527,7 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_end - vma->vm_start != notify.size)
 		return -ENOTSUPP;
 
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vhost_vdpa_vm_ops;
 	return 0;
-- 
2.51.0


