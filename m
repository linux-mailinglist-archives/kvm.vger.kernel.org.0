Return-Path: <kvm+bounces-4013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E9B580BF96
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 04:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DA9B1F20FF2
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 03:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D5BC15AFF;
	Mon, 11 Dec 2023 03:05:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BDF9D;
	Sun, 10 Dec 2023 19:05:21 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=guanjun@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0Vy9Z.J._1702263918;
Received: from localhost(mailfrom:guanjun@linux.alibaba.com fp:SMTPD_---0Vy9Z.J._1702263918)
          by smtp.aliyun-inc.com;
          Mon, 11 Dec 2023 11:05:19 +0800
From: 'Guanjun' <guanjun@linux.alibaba.com>
To: dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	kirill.shutemov@linux.intel.com,
	yu.c.zhang@linux.intel.com,
	tabba@google.com,
	xiaoyao.li@intel.com
Cc: pbonzini@redhat.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] KVM: Move kvm_gmem_migrate_folio inside CONFIG_MIGRATION
Date: Mon, 11 Dec 2023 11:05:18 +0800
Message-Id: <20231211030518.2722714-1-guanjun@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guanjun <guanjun@linux.alibaba.com>

'kvm_gmem_migrate_folio' is only used when CONFIG_MIGRATION
is defined, And it will triggers the compiler warning about
'kvm_gmem_migrate_folio' defined but not used when CONFIG_MIGRATION
isn't defined.

The compiler complained like that:
arch/x86/kvm/../../../virt/kvm/guest_memfd.c:262:12: error: ‘kvm_gmem_migrate_folio’ defined but not used [-Werror=unused-function]
  262 | static int kvm_gmem_migrate_folio(struct address_space *mapping,
      |            ^~~~~~~~~~~~~~~~~~~~~~

Fixes: a7800aa80ea4 (KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory)
Signed-off-by: Guanjun <guanjun@linux.alibaba.com>
---
 virt/kvm/guest_memfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 16d58806e913..62bb8a1a47d1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -259,6 +259,7 @@ void kvm_gmem_init(struct module *module)
 	kvm_gmem_fops.owner = module;
 }
 
+#ifdef CONFIG_MIGRATION
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
 				  struct folio *dst, struct folio *src,
 				  enum migrate_mode mode)
@@ -266,6 +267,7 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 	WARN_ON_ONCE(1);
 	return -EINVAL;
 }
+#endif
 
 static int kvm_gmem_error_folio(struct address_space *mapping,
 		struct folio *folio)
-- 
2.39.3


