Return-Path: <kvm+bounces-44661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 712EEAA013E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45FF482BAA
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0685827586D;
	Tue, 29 Apr 2025 04:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRQ75lu0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C01270ED0;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745899577; cv=none; b=pfrHwvliT7+J39elDBuEkcQuuQ31fY9Dcy5SL9A2aRtfOCkl0ymWGJw06SGd8XCE7vm9Tm/pg+uz/HBHkjEtW43cVKFV7FGbTfjc6YmaT9/X/GqjCr78ZxNzAHgSeZMbSkhgt25w/8WgoyuWs49xPXaJZy9yECXLr8jBoRDUecc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745899577; c=relaxed/simple;
	bh=xaBPg6MMzZtyI5BynxGLu2CWzfYAh0y0igpwIukNl4w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RvMsLXax76/pjn56J0aRi+zcCeUSfNOoBzjkWQBjX9zxIPNpSYICxdJ0hDWhlxdqe8e0wTrOZLNrSxRSWntGa5iEe9jsQSlUx+tFkfJ6yBSc8i5uLF218phTcuh+KwlPhTPJSxbLasmBXplmxAqa0VOFRKsVRPldM9xFXjhmwIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRQ75lu0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D9C1C4CEF4;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745899577;
	bh=xaBPg6MMzZtyI5BynxGLu2CWzfYAh0y0igpwIukNl4w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rRQ75lu00znvBITjVyrAMVKtCn2AtPLSrSuYcoZf125A63zHSdMhkAi/HFUGNCNeK
	 J7X1yl7r0rN29gdmq5SsHcGn/T7CmDF/ID2Uvi7mvr0PFwvdGJmCpdOIysf5LfRnjC
	 1w21Gx6IhBsNzjDnYjd6ko75qTravedUuRFoDbjzIS1z9I6hCFuD3mi0z2GXS1i4t6
	 27AUHJ9cCIxoiAkllQIMQpLiz/s3c9V6KCvxFG9I9FzO5D6fpDGPZSi6DGeJKkmgmX
	 LtIjdVeuyd+wIT4KgskYvFdzQ7diMBplESrWTHBJv/Ah47o30uQF/CA+9DkHa7pT6h
	 70djD7BzAwDPA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BE0C3ABA8;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+chenlinxuan.uniontech.com@kernel.org>
Date: Tue, 29 Apr 2025 12:06:09 +0800
Subject: [PATCH RFC v3 5/8] rseq: add __always_inline for
 rseq_kernel_fields
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250429-noautoinline-v3-5-4c49f28ea5b5@uniontech.com>
References: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
In-Reply-To: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
To: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Juergen Gross <jgross@suse.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 linux-integrity@vger.kernel.org, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, Winston Wen <wentao@uniontech.com>, 
 kasan-dev@googlegroups.com, xen-devel@lists.xenproject.org, 
 Chen Linxuan <chenlinxuan@uniontech.com>, 
 Changbin Du <changbin.du@intel.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1064;
 i=chenlinxuan@uniontech.com; h=from:subject:message-id;
 bh=yuauFI3DVy8k9g1XQ1OrB7eESWm7f+B3/2pt9syGKzM=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBoEFAyanc3Cwc7HAg/63YHY6NNSEBN2RhZfPBtP
 dtxoPOqXNeJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaBBQMgAKCRB2HuYUOZmu
 i7aID/44sv/mzy4WT2GTGw2LDhzFHfM+7rL13wS9xt+G7CMG4l6A0rduPv9Kj1+aTi8eOVMJft5
 5TiNxVdcrGKSr3zwVOY/PNRlc66oIZlthPkrupbFv0SD5r0m5xlYv9Q9WAMMOLU1a+CKw7KXlIK
 zUkQ0dGZaFEhfFS3giTzwyMqJS6nvmjb5iRc4Zz/XOtdtIIBsD6qlLRwQDdV4KuiKgfabOvMbeX
 C/d2ZrlzN8bw8uBY9bJS4LF4cptR+kay58eEnIn86mc9en18eq/l2Y01BEqmDWaad6N+FJDodwI
 pMr/+GVr6bsXlGZJ+sULeKleGffl4G1zIhAoz7H8I0oNmr/nSGd3Wn6BKIxuLhtVppnLY1KsvGa
 yf2RsSmPzJHLCXkfpLhDD/oicoxFl43gpHqaND1YU47v6537LXhTaUC1wslQX7j/d1+ujI4YwtF
 vOr8GQoQM+gOCkSVJLMdhN73NjDBDQByqvsYdot/uoc2GscYToCLN6G8w6S/yE1iwgbv9J0upsK
 hCjXyMYy0yLyfeIMCV/s3OTjYIs2fkUTwhR/5ByE/gU+4GGrFSrBbZP1FArrKKo834SUQ98QfUi
 V+gTyYTxvmL/HMhC3LP7oMkp9BWNsUvbCEi3F0KTEm/YPo52etQ+1LPa6z6VqhkHXnGwZSJcPtW
 crGc2BctRQzKvsw==
X-Developer-Key: i=chenlinxuan@uniontech.com; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for chenlinxuan@uniontech.com/default with
 auth_id=380
X-Original-From: Chen Linxuan <chenlinxuan@uniontech.com>
Reply-To: chenlinxuan@uniontech.com

From: Chen Linxuan <chenlinxuan@uniontech.com>

Presume that kernel is compiled for x86_64 with gcc version 13.3.0:

  make allmodconfig
  make KCFLAGS="-fno-inline-small-functions -fno-inline-functions-called-once"

This results some objtool warnings:

  vmlinux.o: warning: objtool: rseq_update_cpu_node_id+0x14c: call to rseq_kernel_fields() with UACCESS enabled
  vmlinux.o: warning: objtool: rseq_reset_rseq_cpu_node_id+0xef: call to rseq_kernel_fields() with UACCESS enabled

Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
---
 kernel/rseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index b7a1ec327e8117b47e353cab92d62111dd261520..7a4b6c211359714087a753047581bc8ff0c6c76b 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -27,7 +27,7 @@
 				  RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE)
 
 #ifdef CONFIG_DEBUG_RSEQ
-static struct rseq *rseq_kernel_fields(struct task_struct *t)
+static __always_inline struct rseq *rseq_kernel_fields(struct task_struct *t)
 {
 	return (struct rseq *) t->rseq_fields;
 }

-- 
2.43.0



