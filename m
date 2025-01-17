Return-Path: <kvm+bounces-35770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3165CA14EA0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 12:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47366169243
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 11:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949DA1FE478;
	Fri, 17 Jan 2025 11:44:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D2B19992C;
	Fri, 17 Jan 2025 11:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.237.72.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737114285; cv=none; b=qEyXHoZ9VL7lsZ4tUWaTDjoHXxbZStIeLiB1PkHkEyhU5AmvPx8x/cz/E7uIzC0bE/qjD0xXzX54IZBnvNygzypWznyjXGbqqU4ZBoQfDDNkF/UnJ5nTS7vSCBJzeRRz/R+6Pt7mueuzP6A5tTz4Ouil3gBn4rYFQEXloRAK9EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737114285; c=relaxed/simple;
	bh=PhK0DeHGXnoZKBKI5r3PGBPr8XqY/40VBWxLuspWuag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7BJFYnAACdhailsIPAqrQZpKDEmmPiz4Ey4qIY1LMwYxkbc3nDUCCvBELnheMo+us0if+vN1ptme2c8BSYFbNuMTM3q2PRvLjmrX+Rv/JklBuFxapEw2klugOdnM0E2EaJZuzhZhKZxDyIyQLZbzFE95WSBAsCJqRoC2n8Ea1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.237.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.214.100.11])
	by mtasvr (Coremail) with SMTP id _____wBXxX2GQopnEJ0YAA--.20523S3;
	Fri, 17 Jan 2025 19:44:07 +0800 (CST)
Received: from NUC10i7FNH.. (unknown [10.214.100.11])
	by mail-app2 (Coremail) with SMTP id zC_KCgCXdV6CQopnA40LAA--.9592S2;
	Fri, 17 Jan 2025 19:44:05 +0800 (CST)
From: Haoran Zhang <wh1sper@zju.edu.cn>
To: michael.christie@oracle.com
Cc: mst@redhat.com,
	jasowang@redhat.com,
	pbonzini@redhat.com,
	stefanha@redhat.com,
	eperezma@redhat.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoran Zhang <wh1sper@zju.edu.cn>
Subject: Re: Re: [PATCH] vhost/scsi: Fix improper cleanup in vhost_scsi_set_endpoint()
Date: Fri, 17 Jan 2025 19:42:02 +0800
Message-ID: <20250117114400.79792-1-wh1sper@zju.edu.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e418a5ee-45ca-4d18-9b5d-6f8b6b1add8e@oracle.com>
References: <e418a5ee-45ca-4d18-9b5d-6f8b6b1add8e@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgCXdV6CQopnA40LAA--.9592S2
X-CM-SenderInfo: asssliaqzvq6lmxovvfxof0/1tbiAg8JB2eJiygpSQAAsu
X-CM-DELIVERINFO: =?B?wOZpVwXKKxbFmtjJiESix3B1w3u7BCRQAee6E0rsv8LVXQpn+jaR4luXxag8yWi2LJ
	86hmNl1N/KjW2+Pzmhc0HcODClqWXbN+DaVcrUonWrmkaBtWb0Y17wNRe4l1CQeTIzSqoV
	jvhx3BsZ8YrkQ3MQ8C49b7CoVDZy+9r3JI6jQOmiJ3qtq8cranNWbrrSC45yiw==
X-Coremail-Antispam: 1Uk129KBj93XoWxuw1rKFyrGFWkCr43XFyDCFX_yoW7Gw4DpF
	Z8G34jyr48G34UZrs7W3W5Xr18Crs3ur9xKFn2kry2vr98Cry8JrZrK3Z09F4DuFWrJF47
	J3Wqq3W5Wrn8A3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJV
	Cq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84AC
	jcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0ow
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1l
	Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnV
	AKz4kxM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCF04k2
	0xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
	8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
	IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
	AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
	jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUjtfHUUUUUU==

> I see now and can replicate it. I think there is a 2nd bug in
> vhost_scsi_set_endpoint related to all this where we need to
> prevent switching targets like this or else we'll leak some
> other refcounts. If 500140501e23be28's tpg number was 3 then
> we would overwrite the existing vs->vs_vhost_wwpn and never
> be able to release the refounts on the tpgs from 500140562c8936fa.
>
> I'll send a patchset to fix everything and cc you.
>
> Thanks for all the work you did testing and debugging this
> issue.

You are welcome. There is another bug I was about to report, but I'm not
sure whether I should create a new thread. I feel that the original design
of dynamically allocating new vs_tpgs in vhost_scsi_set_endpoint is not
intuitive, and copying TPGs before setting the target doesn't seem
logical. Since you are already refactoring the code, maybe I should post
it here so we can address these issues in one go.

[PATCH] vhost/scsi: Fix dangling pointer in vhost_scsi_set_endpoint()

Since commit 4f7f46d32c98 ("tcm_vhost: Use vq->private_data to indicate
if the endpoint is setup"), a dangling pointer issue has been introduced
in vhost_scsi_set_endpoint() when the host fails to reconfigure the
vhost-scsi endpoint. Specifically, this causes a UAF fault in
vhost_scsi_get_req() when the guest attempts to send an SCSI request.

In vhost_scsi_set_endpoint(), vhost_scsi->vs_tpg holds the same pointer
as vq->private_data. The code allocates a new vs_tpg array to hold the
TPGs and updates vq->private_data if a match is found between
vhost_scsi_list's tport_name and the target WWPN. However, the code
ignored the case where `match == 0` (i.e. the target endpoint does not
match any TPGs in vhost_scsi_list). In this scenario, it directly frees
the old vs_tpg and updates vhost_scsi->vs_tpg without modifying
vq->private_data, leaving all vq's backend pointer dangling. As a result,
subsequent requests from the guest will trigger a UAF fault on vs_tpg in
vhost_scsi_get_req(). Below is the KASAN report:

[   68.606821] BUG: KASAN: slab-use-after-free in vhost_scsi_get_req+0xef/0x1f0
[   68.607671] Read of size 8 at addr ffff8880087a1008 by task vhost-1440/1460
[   68.608570]
[   68.612070] Call Trace:
[   68.612429]  <TASK>
[   68.612739]  dump_stack_lvl+0x9e/0xd0
[   68.613206]  print_report+0xd1/0x670
[   68.613711]  ? __virt_addr_valid+0x54/0x250
[   68.614232]  ? kasan_complete_mode_report_info+0x6a/0x200
[   68.614879]  kasan_report+0xd6/0x120
[   68.615329]  ? vhost_scsi_get_req+0xef/0x1f0
[   68.615869]  ? vhost_scsi_get_req+0xef/0x1f0
[   68.616406]  __asan_load8+0x8b/0xe0
[   68.616854]  vhost_scsi_get_req+0xef/0x1f0
[   68.617362]  vhost_scsi_handle_vq+0x30f/0x15e0
[   68.622248]  ...
[   68.622868]  vhost_scsi_handle_kick+0x39/0x50
[   68.623409]  vhost_run_work_list+0xd9/0x120
[   68.623939]  ? __pfx_vhost_run_work_list+0x10/0x10
[   68.624521]  vhost_task_fn+0xf8/0x240
[   68.629164]  ...
[   68.629705]  ret_from_fork+0x5d/0x80
[   68.630155]  ? __pfx_vhost_task_fn+0x10/0x10
[   68.630693]  ret_from_fork_asm+0x1a/0x30
[   68.631179] RIP: 0033:0x0
[   68.631516] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[   68.637405]  </TASK>
[   68.637670]
[   68.637798] Allocated by task 1440:
[   68.638124]  kasan_save_stack+0x39/0x70
[   68.638607]  kasan_save_track+0x14/0x40
[   68.638919]  kasan_save_alloc_info+0x37/0x60
[   68.639331]  __kasan_kmalloc+0xc3/0xd0
[   68.639625]  __kmalloc_cache_noprof+0x186/0x3a0
[   68.639971]  vhost_scsi_ioctl+0x630/0xec0
[   68.640392]  __x64_sys_ioctl+0x126/0x160
[   68.640755]  x64_sys_call+0x11ad/0x25f0
[   68.641076]  do_syscall_64+0x7e/0x170
[   68.641437]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   68.641887]
[   68.642016] Freed by task 1461:
[   68.642301]  kasan_save_stack+0x39/0x70
[   68.642622]  kasan_save_track+0x14/0x40
[   68.642958]  kasan_save_free_info+0x3b/0x60
[   68.643352]  __kasan_slab_free+0x52/0x80
[   68.643675]  kfree+0x129/0x440
[   68.643973]  vhost_scsi_ioctl+0xd74/0xec0
[   68.644290]  __x64_sys_ioctl+0x126/0x160
[   68.644589]  x64_sys_call+0x11ad/0x25f0
[   68.644939]  do_syscall_64+0x7e/0x170
[   68.645377]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

To address this issue, we need to prevent the `free(vs_tpg)` operation
from being triggered by the `match == 0` branch , either by moving the
free operation inside the if-clause or by adding a goto statement in the
else-clause. Here is an alternative patch commit.

Fixes: 4f7f46d32c98 ("tcm_vhost: Use vq->private_data to indicate if the endpoint is setup")
Signed-off-by: Haoran Zhang <wh1sper@zju.edu.cn>
---
 drivers/vhost/scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 718fa4e0b31e..1e15eab530d7 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1775,6 +1775,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		ret = 0;
 	} else {
 		ret = -EEXIST;
+		goto undepend;
 	}
 
 	/*
-- 
2.43.0


