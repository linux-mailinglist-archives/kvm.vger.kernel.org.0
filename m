Return-Path: <kvm+bounces-61091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD0AC09A37
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 18:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ED13A4FEF6F
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 16:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C085A3176E3;
	Sat, 25 Oct 2025 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHpOB6dK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15F230B518;
	Sat, 25 Oct 2025 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409582; cv=none; b=DqD2eEFJv1Z3Ol2w2CKd9IAMBTU0qWZJ8pXmdU80JZoam31lmycXy9mHEPJQ10nAGPqHNmoPfam255rPB7iLNXZvJ9PfoOypb0epQau0JYGHXmgiGWIzermGBJAd1rKPsxco7A/5gOn1eRtuTOTfppPJl11ro8JEfbcD7y/0+v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409582; c=relaxed/simple;
	bh=s7f5NGcsHUJSWmLfVeWCNvN+yvCvlV4mJTiULqN/vqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rvalThpqB5Qxpt0tIsC53NvxmL3St7wyl57V4Vu1s7BbZgcuzUYSJH0ssOZ+GSDaaimqf+WYDYm+n0n0glhapH7GLdushka6A8iarg2x9X7j3TXZSljl17ro7G3Zax9+g/0DCIq2pVyM+iiEJuWlj/5egFurCPmfe9O2rLe/Ajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHpOB6dK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D31C4CEF5;
	Sat, 25 Oct 2025 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409581;
	bh=s7f5NGcsHUJSWmLfVeWCNvN+yvCvlV4mJTiULqN/vqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHpOB6dKNH4KNe8qysX/bsOk6E7BsQpqaet5s3Urcg8/mWEOC7aw4UY+oZdbZ7kYi
	 iWH+zuRg/e/whwWk1XmfkYOoPcY+ddgWafSzltYuKCP+XSesJb9ZrrORdIehbyGnAu
	 uo2HsPegGGQkdCWz/RGZHl0iG2/ySv+eNFeAeS0m2HqIwjCSYOHOPIIprVMVhI29eL
	 f5XN339qwb5uOXSaETwcIUjdMmQRafsGQVnK60IqR/sHqHaYw4AaB923wYweX2zQA2
	 K7Jglq8QJtDQfwt8bKxrB/w3zSIlI52u8qDN7SwNo2Hj1i7b0DEqJmvB65dZGRGcV2
	 X6Usy+eyLtgdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	alex@shazbot.org,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] vfio: return -ENOTTY for unsupported device feature
Date: Sat, 25 Oct 2025 12:00:07 -0400
Message-ID: <20251025160905.3857885-376-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Mastro <amastro@fb.com>

[ Upstream commit 16df67f2189a71a8310bcebddb87ed569e8352be ]

The two implementers of vfio_device_ops.device_feature,
vfio_cdx_ioctl_feature and vfio_pci_core_ioctl_feature, return
-ENOTTY in the fallthrough case when the feature is unsupported. For
consistency, the base case, vfio_ioctl_device_feature, should do the
same when device_feature == NULL, indicating an implementation has no
feature extensions.

Signed-off-by: Alex Mastro <amastro@fb.com>
Link: https://lore.kernel.org/r/20250908-vfio-enotty-v1-1-4428e1539e2e@fb.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `drivers/vfio/vfio_main.c:1255` now returns `-ENOTTY` when
  `device->ops->device_feature` is NULL, matching the documented
  optional nature of that callback (`include/linux/vfio.h:137`), so
  users probing for vendor/device extensions on drivers without feature
  support get the expected “unsupported ioctl” error instead of the
  misleading `-EINVAL`.
- Existing feature implementations already signal “unsupported” with
  `-ENOTTY` (for example `drivers/vfio/pci/vfio_pci_core.c:1518` and
  `drivers/vfio/cdx/main.c:79`), so the change restores API consistency
  and lets user space rely on a single return code when checking for
  absent features.
- The bug has been present since the core feature decoder was introduced
  (commit 445ad495f0ff), leading to real user-visible confusion where
  `VFIO_DEVICE_FEATURE_PROBE` can’t distinguish between bad arguments
  and an unsupported feature on simpler devices.
- The fix is trivially small, has no dependencies, and only adjusts an
  errno in one fallback path, so regression risk for stable kernels is
  negligible while improving correctness for existing VFIO users.

 drivers/vfio/vfio_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5046cae052224..715368076a1fe 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1251,7 +1251,7 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 			feature.argsz - minsz);
 	default:
 		if (unlikely(!device->ops->device_feature))
-			return -EINVAL;
+			return -ENOTTY;
 		return device->ops->device_feature(device, feature.flags,
 						   arg->data,
 						   feature.argsz - minsz);
-- 
2.51.0


