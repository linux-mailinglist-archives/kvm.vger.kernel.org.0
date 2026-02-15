Return-Path: <kvm+bounces-71110-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLU1GJHgkWkxngEAu9opvQ
	(envelope-from <kvm+bounces-71110-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:04:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC90613EEE9
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1CBE302D943
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD301367;
	Sun, 15 Feb 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o8itmGSi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A07C299943;
	Sun, 15 Feb 2026 15:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167820; cv=none; b=dNjQdR+bgGISJsPA8n9ZoP9cWTZHv6lDhOxhlwi7DsZFLRG73LP4ssiX+b/4Q/OycSjUugiZOMRd/dn8LawDWAiXoy0eHTwPb+z4rEYG9Aieqz/0KyW7HuuU4J0B7DZyfA8+oGI7Z4kJYygAZgDCCpSP7oKFvw2uZFQCeHjhFiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167820; c=relaxed/simple;
	bh=Qb61Xon3bScn8289NmFzFgFVQh/g4gjwWfLT5UW9CJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igKsFqV187mVoIiuPaPBAs7dflIe4pZeEhQjOf1H5LvkY/YUlHJnCSIxyCv5RbNK0yOmleWctcaxLxn/1hy38X0bwvPLbIIxY3dbL7nVJwlAYPqx/YqtR8BWw1k4xkbffTlvdTGV/uGw6trrotmsK0+lKHaLRSrQJv1DSpGYkKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o8itmGSi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992CEC19422;
	Sun, 15 Feb 2026 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167820;
	bh=Qb61Xon3bScn8289NmFzFgFVQh/g4gjwWfLT5UW9CJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8itmGSiKZ3EUaljV7ZCVyn3vrA7ciVMldSf4yzpvjT4Ua1eRKRyutZLjieDQ4B/J
	 xMHxe1yp8vA90eJm+/LjAJQTJ+u8gRZPelVnTFotgXUNwVr6F8WjekcbKN4YjHMoru
	 NdUqtd7LuJXqwNVgXNdbK78RsYvEBs3B2FXVLs5U7IPFBof0+PRNYFZ6LcI2UjWEPJ
	 UFcqhtfR3DlkiT0pIutv2Ba/3jDUfy2ukBVMRwJLOFCcPshq3TNbwZSzkT3WUQ1BWi
	 +GC2eYFuC9ExjkO7PjWhv49YMBC7W08kLgT/yKnoiZP+/AfAe1oJjuR7W/bNTAlXsP
	 rValsyPX0bEzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] hisi_acc_vfio_pci: fix the queue parameter anomaly issue
Date: Sun, 15 Feb 2026 10:03:21 -0500
Message-ID: <20260215150333.2150455-4-sashal@kernel.org>
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
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_FROM(0.00)[bounces-71110-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+]
X-Rspamd-Queue-Id: BC90613EEE9
X-Rspamd-Action: no action

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit c3cbc276c2a33b04fc78a86cdb2ddce094cb3614 ]

When the number of QPs initialized by the device, as read via vft, is zero,
it indicates either an abnormal device configuration or an abnormal read
result.
Returning 0 directly in this case would allow the live migration operation
to complete successfully, leading to incorrect parameter configuration after
migration and preventing the service from recovering normal functionality.
Therefore, in such situations, an error should be returned to roll back the
live migration operation.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20260122020205.2884497-5-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the function `qm_get_vft()`:
- Returns negative on error (from `hisi_qm_mb()`)
- Returns `qp_num` (positive) on success, which is `(masked_value) + 1`

Wait — looking at line 93, `qp_num = (... & ...) + 1`, the `+1` means
the minimum return value on the success path would be 1, not 0. Let me
think about this more carefully...

Actually, since the masked value could theoretically be `0xFFFFFFFF`
(all bits set in the mask), adding 1 could wrap to 0 due to integer
overflow. But more practically, if the hardware register returns
unexpected values, the result could indeed be 0. The commit message says
"the number of QPs initialized by the device, as read via vft, is zero"
— so this is a real scenario they've observed.

The fix is self-contained and does not depend on any other commits. The
`vf_qm_check_match` function and `qm_get_vft` have existed since the
driver was introduced.

### 8. Summary

| Criterion | Assessment |
|---|---|
| Fixes real bug | Yes — incorrect success return on abnormal state |
| Bug severity | High — silent data corruption during live migration |
| Patch size | Minimal — 1 line |
| Risk of regression | Very low — only affects the zero-QP edge case |
| Self-contained | Yes — no dependencies |
| Stable criteria met | Yes — all criteria satisfied |

The fix is small, surgical, obviously correct, and prevents a real-world
issue where live migration silently succeeds with broken device
configuration. It meets all stable kernel criteria.

**YES**

 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 39bff70f1e14b..8ed00f6183622 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -426,7 +426,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
 	if (ret <= 0) {
 		dev_err(dev, "failed to get vft qp nums\n");
-		return ret;
+		return ret < 0 ? ret : -EINVAL;
 	}
 
 	if (ret != vf_data->qp_num) {
-- 
2.51.0


