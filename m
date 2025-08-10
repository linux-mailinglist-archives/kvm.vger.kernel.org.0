Return-Path: <kvm+bounces-54350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2208B1F768
	for <lists+kvm@lfdr.de>; Sun, 10 Aug 2025 02:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A18FD17BFB2
	for <lists+kvm@lfdr.de>; Sun, 10 Aug 2025 00:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8056F12E5B;
	Sun, 10 Aug 2025 00:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rH1O4I6O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4276101DE;
	Sun, 10 Aug 2025 00:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785286; cv=none; b=tcc3Dvpj7VCl0RjkxHN2cmYuQRWcJcqkCkHMjasFg8nVy1Tj1Udo6JOK/xSUImo2GeFy5vGUjDWf/DqiKC4PUD/tFtmoT/ZmGwwS+NlsBKjp4VZ9kdHc/qCeyo/bfuUVgiRWZAkedXtvs5F0+izd+nHEOECRp7QvjannXHxVNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785286; c=relaxed/simple;
	bh=SP3/KX0uSNQDWiSQiUfwjPe2lFiJ1PaPCjw4UaLPynw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SS+b6DH7W7xRXm5vBj+z73b4X4xqRMnMeQyqBU7EuYCkBxnQJdnmosKV5C5QBjMIrN5ytTJqKbuCikMe3KjM7y+mms2aWM6Cb2ju2DEouR2K8hOf9TOhi/oFXc1SBxoDUlzZLh1W6V5QckYayAXPYg2noapW1tZ/eU6PrlkhNEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rH1O4I6O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534D5C4CEF1;
	Sun, 10 Aug 2025 00:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785286;
	bh=SP3/KX0uSNQDWiSQiUfwjPe2lFiJ1PaPCjw4UaLPynw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rH1O4I6OSex9DxV6baafmCSHdoUCf5hhSfrVB7+eDpNE1zPYQc8g5Q4a/NwTWGBMB
	 Mx4x4CytvjN8X7Syq7A8pn7WHL0eECnfi7DPEuJfwvISND0s+BmXncBXdzkz9/POJH
	 Zxsofug46bncrslj5aOLSZuN+51cZvsl6+dodLo6bR28LXu2JtdHNj/VQRaVmOS2V9
	 W1FLRzLfH7ajF+P+kBlGeZvM7IJKeCew77Fe8mF09nCusfIL2dySTNQyvN3eG58VOF
	 HfA8G4ddRCNtQ+3hmRSZpS9GEEdKNj67CdFMOVuKQAP8VoMVcvCPTSp+dSrXnHOD5d
	 Nq3iXgtSUq9qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.1] vfio/mlx5: fix possible overflow in tracking max message size
Date: Sat,  9 Aug 2025 20:20:58 -0400
Message-Id: <20250810002104.1545396-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810002104.1545396-1-sashal@kernel.org>
References: <20250810002104.1545396-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Artem Sadovnikov <a.sadovnikov@ispras.ru>

[ Upstream commit b3060198483bac43ec113c62ae3837076f61f5de ]

MLX cap pg_track_log_max_msg_size consists of 5 bits, value of which is
used as power of 2 for max_msg_size. This can lead to multiplication
overflow between max_msg_size (u32) and integer constant, and afterwards
incorrect value is being written to rq_size.

Fix this issue by extending integer constant to u64 type.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/20250701144017.2410-2-a.sadovnikov@ispras.ru
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Critical Integer Overflow Bug Fix

1. **Clear Bug with Security Implications**: The commit fixes a critical
   integer overflow bug in the VFIO MLX5 driver. When `log_max_msg_size`
   reaches its maximum value (31, as it's a 5-bit field), the
   calculation `4 * max_msg_size` causes an integer overflow:
   - `max_msg_size = (1ULL << 31) = 2147483648 (0x80000000)`
   - `4 * max_msg_size` overflows to 0 when calculated as u32 * int
   - This results in `rq_size` being incorrectly set, potentially to 0
     or a very small value

2. **Introduced by Recent Code**: The vulnerable code was introduced in
   commit 9c7c5430bca36 ("vfio/mlx5: Align the page tracking max message
   size with the device capability") from December 2024, which itself
   has a Fixes tag for commit 79c3cf279926 from 2022. This indicates the
   affected code exists in stable kernels.

3. **Simple and Contained Fix**: The fix is minimal - just changing `4`
   to `4ULL` in two places to ensure 64-bit arithmetic:
  ```c
   - if (rq_size < 4 * max_msg_size)
   - rq_size = 4 * max_msg_size;
   + if (rq_size < 4ULL * max_msg_size)
   +     rq_size = 4ULL * max_msg_size;
   ```

4. **Affects User-Visible Functionality**: This bug affects VFIO device
   passthrough for MLX5 devices, specifically the page tracking
   functionality used for live migration. An incorrect `rq_size` could
   lead to:
   - Failed QP (Queue Pair) creation
   - Memory corruption
   - System instability during VM migration

5. **Low Risk of Regression**: The change only affects the calculation
   precision by ensuring 64-bit arithmetic. It doesn't change any logic,
   APIs, or data structures.

6. **Found by Verification Tools**: The bug was discovered by the Linux
   Verification Center using SVACE static analysis, indicating it's a
   real issue that could be triggered in practice.

7. **Reviewed by Maintainers**: The fix was suggested by the VFIO
   maintainer (Alex Williamson) and reviewed by the MLX5 driver
   maintainer (Yishai Hadas), showing consensus on the solution.

The commit meets all criteria for stable backporting: it fixes a real
bug that affects users, the fix is small and contained, there's minimal
risk of regression, and it addresses a potential security/stability
issue in virtualization infrastructure.

 drivers/vfio/pci/mlx5/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5b919a0b2524..a92b095b90f6 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1523,8 +1523,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
 	max_msg_size = (1ULL << log_max_msg_size);
 	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
-	if (rq_size < 4 * max_msg_size)
-		rq_size = 4 * max_msg_size;
+	if (rq_size < 4ULL * max_msg_size)
+		rq_size = 4ULL * max_msg_size;
 
 	memset(tracker, 0, sizeof(*tracker));
 	tracker->uar = mlx5_get_uars_page(mdev);
-- 
2.39.5


