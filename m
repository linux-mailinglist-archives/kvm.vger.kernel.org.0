Return-Path: <kvm+bounces-8547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C579851222
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 12:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21F63B238D8
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 11:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB3E939846;
	Mon, 12 Feb 2024 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5noxPAz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0FE38DE4;
	Mon, 12 Feb 2024 11:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707737065; cv=none; b=HNpLU9qyo2YAiDRbejg8oOwsXRXTXSeF+ktrzXRFVmly1JW66V8D5tsnW6OeyldPPnP24w/MYWG2tnWhvnPl1EseWHeFqsCP3T2Qk3v1LWccbRBQoVfY64QMNNcTJ62MaQsVqUt2tVv5ph54y7hlsy6DTCpZwYez1zzMiMF58EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707737065; c=relaxed/simple;
	bh=ctB3UNnuko1So6jdWUHT6OoiQS0dR1uMODQ5VcPcPKc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ecGaLcdzWBadbq20algPSnvsPyRD3IzY744myK7tSxh4rjdZ5sbeIXhwqpfrfoUIdeaupybRe4UCkLOpWamxNSvQy6V6Mn1V87srACqtvSVHT5FNxv7U8m1ytAa9xzwnGNUxJj/lsyrfqmuIKX/WZ3I+jyOlr6194mVzZRUI9Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5noxPAz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB6CC433F1;
	Mon, 12 Feb 2024 11:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707737064;
	bh=ctB3UNnuko1So6jdWUHT6OoiQS0dR1uMODQ5VcPcPKc=;
	h=From:To:Cc:Subject:Date:From;
	b=B5noxPAzXIEuAGofnSaGSwq1xWlEazm6k239d4/xurIUbuH5MgkBZfs/R7TmGqlW5
	 T9lEmQcQLc010Rnb2Q8h/yB0kiY4BWU5AkdAXvVzwz0iaoBHRL8jy+nr3q62v4aRdc
	 NIFNQ/KJZpWOQV2SBjEIHLMlvrgFh49TQOEnuMDuDpy5iOc7Cg6LZ9WKBdb2K0JZMM
	 rsnWzKlx/pOIl/03GuxYcjmTILp7teizsQGVIfmV3yRrJiKqFE3ZDKZwZYF67tJbK0
	 KDHzzvHo/bwKCULiTcyXI+b5s3dD7nkaEAa/k533pVgeWBBGDG84tkj2nmuCmH8Wya
	 wnHZDzTRf02eQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	David Matlack <dmatlack@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Sean Christopherson <seanjc@google.com>,
	Fuad Tabba <tabba@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: fix kvm_mmu_memory_cache allocation warning
Date: Mon, 12 Feb 2024 12:24:10 +0100
Message-Id: <20240212112419.1186065-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

gcc-14 notices that the arguments to kvmalloc_array() are mixed up:

arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_mmu_topup_memory_cache':
arch/x86/kvm/../../../virt/kvm/kvm_main.c:424:53: error: 'kvmalloc_array' sizes specified with 'sizeof' in the earlier argument and not in the later argument [-Werror=calloc-transposed-args]
  424 |                 mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
      |                                                     ^~~~
arch/x86/kvm/../../../virt/kvm/kvm_main.c:424:53: note: earlier argument should specify number of elements, later size of each element

The code still works correctly, but the incorrect order prevents the compiler
from properly tracking the object sizes.

Fixes: 837f66c71207 ("KVM: Allow for different capacities in kvm_mmu_memory_cache structs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f03b56dafbd..4c48f61cae35 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -421,7 +421,7 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
 		if (WARN_ON_ONCE(!capacity))
 			return -EIO;
 
-		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
+		mc->objects = kvmalloc_array(capacity, sizeof(void *), gfp);
 		if (!mc->objects)
 			return -ENOMEM;
 
-- 
2.39.2


