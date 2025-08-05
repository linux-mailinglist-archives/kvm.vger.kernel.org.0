Return-Path: <kvm+bounces-53991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D0B2B1B45D
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:12:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEE727A63B1
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60848275AE7;
	Tue,  5 Aug 2025 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sU9gAOCW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CEE2749DC;
	Tue,  5 Aug 2025 13:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399432; cv=none; b=AdbUjUgM/JPdLcE0NTdSdvrw/kLVEBJMnfNf1L88oEwg8f1VGjByMNFKc7dZ/KdCxRbk99934g5Y+oZK8R5Q2yoOr5VFF5TcVTsRuEcUp0iGBuuCsXGzV2RIXi3ydXkd2eI4wjxd9G+i4JCqFS7QsdkxEsncwyuHEJ1IXACidO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399432; c=relaxed/simple;
	bh=NQcQvL4WNTHVf5ntRe0Vi/Q6bkjiOxBpxI9KSmmyEc8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hr4AR9K0sbAB6WX11xIYyGCsknnZMiUTZ1XUbhzdT47yckHiPKTq4Q9bVMBpa3IzuVwjp+gT72afzRy1esNWvDl9qsFtxvob3G6VPSHPZLTsbMGAiezmJqD0rGChkOPWXKY2dRns/Im7oHYCt9b2Of0duZvqqJZRWJSv9x855ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sU9gAOCW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A39C4CEF7;
	Tue,  5 Aug 2025 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399432;
	bh=NQcQvL4WNTHVf5ntRe0Vi/Q6bkjiOxBpxI9KSmmyEc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sU9gAOCWpmMKS06phbsFSzf5qfiudijHofnbyxXMSzgGJo0+cZlFaKWPkegiMFG/U
	 uEuk/cBSTtYH4v7e6D0Q7AfGM1kqxHXEPymgQvV71d+84vZeVvR1u7tv4tQtOkYNAk
	 kbYGVN9VDYyN+bwBJ6QhjvCCl0dM5OBo/IhvK95KUcla5lGt48QR/+QtQmypxl0Lue
	 ECXenflVfJHrgIMi/6RbdzaFlbg+kAwH7P2ii1V0yKf0yLGiWSt8FyZa0JJzdI5W4A
	 K+1sqRvCrDeJPUzWYxgp+CFAvU79f3xIo/DvrQu2VvQJL4nip+ydkvjKk9vxz2LVJV
	 PAVVSZotIPzxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] vhost: fail early when __vhost_add_used() fails
Date: Tue,  5 Aug 2025 09:08:55 -0400
Message-Id: <20250805130945.471732-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit b4ba1207d45adaafa2982c035898b36af2d3e518 ]

This patch fails vhost_add_used_n() early when __vhost_add_used()
fails to make sure used idx is not updated with stale used ring
information.

Reported-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20250714084755.11921-2-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Analysis

The commit fixes a critical error handling bug in `vhost_add_used_n()`
where the function continues execution even after `__vhost_add_used_n()`
fails on line 2776. Looking at the code:

1. **The Bug**: In the original code at drivers/vhost/vhost.c:2776, when
   the second call to `__vhost_add_used_n()` fails and returns an error,
   the function doesn't immediately return. Instead, it continues to:
   - Execute memory barrier (`smp_wmb()`) at line 2779
   - Update the used index via `vhost_put_used_idx()` at line 2780
   - Potentially log the used index update at lines 2784-2791

2. **Impact**: This means the vhost driver updates the used ring index
   even when the actual used ring entries weren't successfully written.
   This creates a **data corruption scenario** where:
   - The guest sees an updated used index
   - But the corresponding used ring entries contain stale/invalid data
   - This can lead to guest crashes, data corruption, or unpredictable
     behavior

3. **The Fix**: The patch adds a simple but crucial check at lines
   2778-2779 (after applying):
  ```c
  if (r < 0)
  return r;
  ```
  This ensures the function returns immediately upon failure, preventing
  the index from being updated with invalid ring state.

## Stable Backport Criteria Assessment

1. **Bug Fix**: ✓ This fixes a real bug that can cause data corruption
   in vhost operations
2. **Small and Contained**: ✓ The fix is only 3 lines of code -
   extremely minimal
3. **No Side Effects**: ✓ The change only adds proper error handling, no
   behavioral changes for success cases
4. **No Architectural Changes**: ✓ Simple error check addition, no
   design changes
5. **Critical Subsystem**: ✓ vhost is used for virtualization (virtio
   devices), affecting VMs and containers
6. **Clear Bug Impact**: ✓ Data corruption in guest-host communication
   is a serious issue
7. **Follows Stable Rules**: ✓ Important bugfix with minimal regression
   risk

## Additional Evidence

- The bug was reported by Eugenio Pérez from Red Hat, indicating it was
  found in production/testing environments
- The fix has been tested (as indicated by "Tested-by: Lei Yang")
- The function `__vhost_add_used_n()` can fail with -EFAULT when
  `vhost_put_used()` fails (line 2738-2740)
- The first call to `__vhost_add_used_n()` already has proper error
  handling (lines 2770-2772), making this an inconsistency bug

This is a textbook example of a stable backport candidate: a small,
obvious fix for a real bug that can cause data corruption in a critical
kernel subsystem.

 drivers/vhost/vhost.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3a5ebb973dba..d1d3912f4804 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2775,6 +2775,9 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	r = __vhost_add_used_n(vq, heads, count);
 
+	if (r < 0)
+		return r;
+
 	/* Make sure buffer is written before we update index. */
 	smp_wmb();
 	if (vhost_put_used_idx(vq)) {
-- 
2.39.5


