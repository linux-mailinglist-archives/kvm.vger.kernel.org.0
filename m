Return-Path: <kvm+bounces-54351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5602CB1F767
	for <lists+kvm@lfdr.de>; Sun, 10 Aug 2025 02:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12C7D3BFA3F
	for <lists+kvm@lfdr.de>; Sun, 10 Aug 2025 00:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E00F4FA;
	Sun, 10 Aug 2025 00:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBcDRdcW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6E28F40;
	Sun, 10 Aug 2025 00:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785294; cv=none; b=bAsbxHQl986YKFA9TL3o9EaM0DkTC5VhG4iePO+KtLivISrmCMDb5btgozfdngW8b9a91BZ60nIZOhCVv2Ht0bEg1yHgcIbhws3DODTt1ONpYAhLYnw0ICRXxL2qO+H4tiwa/0FzWfUB9xFgSYB2CvSaHscS6UZgQgTFD6s0lsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785294; c=relaxed/simple;
	bh=78QzPlzaBG01dmRGq5FOYkDlmNnMxuwrIq23STEu7HU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dg2scFc+2racU2i6GzSf2QiE+H56J4cX4fAHCqEY424dqecoHrzL+z8edMQqVhCWzu2zzv9eB5uoJCcAOVe1lDjlql7A+0+dI/iiu42q4tVYoewNN2TugMDmLsmJyejLXbs7HJqp8PZdU5whr673mIYdJVmclsAX99dmTmFjVPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBcDRdcW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416F0C4CEF1;
	Sun, 10 Aug 2025 00:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785294;
	bh=78QzPlzaBG01dmRGq5FOYkDlmNnMxuwrIq23STEu7HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBcDRdcW9dy3yWlnaWyij968W7RddLtzfsga+7NCWOhO2buKSScFUz91eafoJYm29
	 gPpZJ/U5QoiNtX2RCWPawywrJ1/frXrcNNO7712AigCmOydjT2Zcw5BbQpu918yIbU
	 EKTGrdnENdvR1bRXijDxNEyR4rnhwsRVuZUYJi5feNmd57WwYYh0ZtaH69cY0WJ9Dg
	 VxxXSn+oAOqUlS/1AFB6GMdGevAxHF0MK2P9WjtD9Nbk9RVMD5Fn/2eYEHufAwFP7h
	 fImYcizfqZyAetFuAhLMoTMEMnTtLL/10qKf8l5izeqc6H6GbX/Eopx+GTp6nWqSmf
	 nrU46aKg+w9Ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.15] vfio/type1: conditional rescheduling while pinning
Date: Sat,  9 Aug 2025 20:21:01 -0400
Message-Id: <20250810002104.1545396-12-sashal@kernel.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b1779e4f209c7ff7e32f3c79d69bca4e3a3a68b6 ]

A large DMA mapping request can loop through dma address pinning for
many pages. In cases where THP can not be used, the repeated vmf_insert_pfn can
be costly, so let the task reschedule as need to prevent CPU stalls. Failure to
do so has potential harmful side effects, like increased memory pressure
as unrelated rcu tasks are unable to make their reclaim callbacks and
result in OOM conditions.

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu:   36-....: (20999 ticks this GP) idle=b01c/1/0x4000000000000000 softirq=35839/35839 fqs=3538
 rcu:            hardirqs   softirqs   csw/system
 rcu:    number:        0        107            0
 rcu:   cputime:       50          0        10446   ==> 10556(ms)
 rcu:   (t=21075 jiffies g=377761 q=204059 ncpus=384)
...
  <TASK>
  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
  ? walk_system_ram_range+0x63/0x120
  ? walk_system_ram_range+0x46/0x120
  ? pgprot_writethrough+0x20/0x20
  lookup_memtype+0x67/0xf0
  track_pfn_insert+0x20/0x40
  vmf_insert_pfn_prot+0x88/0x140
  vfio_pci_mmap_huge_fault+0xf9/0x1b0 [vfio_pci_core]
  __do_fault+0x28/0x1b0
  handle_mm_fault+0xef1/0x2560
  fixup_user_fault+0xf5/0x270
  vaddr_get_pfns+0x169/0x2f0 [vfio_iommu_type1]
  vfio_pin_pages_remote+0x162/0x8e0 [vfio_iommu_type1]
  vfio_iommu_type1_ioctl+0x1121/0x1810 [vfio_iommu_type1]
  ? futex_wake+0x1c1/0x260
  x64_sys_call+0x234/0x17a0
  do_syscall_64+0x63/0x130
  ? exc_page_fault+0x63/0x130
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20250715184622.3561598-1-kbusch@meta.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Fix Nature

The commit fixes a critical CPU stall issue that can lead to system
instability. The RCU stall trace in the commit message shows:
- A 21-second RCU stall (`t=21075 jiffies`)
- Over 10 seconds of CPU time consumed (`cputime: 10556ms`)
- The stall originates from `vfio_pin_pages_remote()` during large DMA
  mapping operations

This is a serious bug that affects system reliability and can cascade
into OOM conditions as mentioned: "increased memory pressure as
unrelated rcu tasks are unable to make their reclaim callbacks and
result in OOM conditions."

## Code Change Analysis

The fix is minimal and well-contained:
1. **Single line addition**: The patch adds only `cond_resched()` call
   at line 654 (after the comment block)
2. **Strategic placement**: Positioned at the beginning of the batch
   refill loop, before `vaddr_get_pfns()` is called
3. **Clear comment**: The 5-line comment explains exactly why the
   reschedule is needed

```c
+                       /*
+                        * Large mappings may take a while to repeatedly
refill
+                        * the batch, so conditionally relinquish the
CPU when
+                        * needed to avoid stalls.
+                        */
+                       cond_resched();
```

## Stability and Safety

1. **Low risk**: `cond_resched()` is a standard kernel primitive that
   only yields CPU if needed
2. **Already used pattern**: My search shows vfio_iommu_type1.c already
   uses `cond_resched()` in other places, confirming this is an
   established pattern
3. **No functional changes**: The fix doesn't alter the logic of DMA
   pinning, it just prevents monopolizing the CPU
4. **Reviewed by RCU maintainer**: Paul E. McKenney's review adds
   credibility to the fix

## Stable Tree Criteria Compliance

Per stable-kernel-rules.rst, this meets the criteria:
- **Fixes a real bug**: CPU stalls and potential OOM are serious issues
- **Small change**: Single line addition with comment
- **Obviously correct**: Standard solution for long-running loops
- **Already tested**: Has been in mainline and reviewed by experts
- **No new features**: Pure bug fix, no functionality addition

## Impact Assessment

The bug affects systems performing large DMA mappings through VFIO,
particularly when Transparent Huge Pages (THP) cannot be used. This is
common in:
- Virtual machine device passthrough
- GPU/accelerator passthrough scenarios
- Large memory pinning operations

Without this fix, affected systems can experience:
- RCU stalls leading to system unresponsiveness
- Memory pressure and OOM kills
- Performance degradation for unrelated tasks

The fix prevents these issues with negligible overhead (conditional
reschedule only when needed).

 drivers/vfio/vfio_iommu_type1.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1136d7ac6b59..f8d68fe77b41 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -647,6 +647,13 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 
 	while (npage) {
 		if (!batch->size) {
+			/*
+			 * Large mappings may take a while to repeatedly refill
+			 * the batch, so conditionally relinquish the CPU when
+			 * needed to avoid stalls.
+			 */
+			cond_resched();
+
 			/* Empty batch, so refill it. */
 			ret = vaddr_get_pfns(mm, vaddr, npage, dma->prot,
 					     &pfn, batch);
-- 
2.39.5


