Return-Path: <kvm+bounces-2781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 297137FDB83
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 16:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A7C01C20C94
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E07E38F8A;
	Wed, 29 Nov 2023 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jombYPbi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A6E38DF9
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 15:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD688C433C8;
	Wed, 29 Nov 2023 15:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701271975;
	bh=IMG9YxIDr+Fl0aVREHwJe3Kp/N91o8sNpnhBkBL/3ec=;
	h=From:To:Cc:Subject:Date:From;
	b=jombYPbint8xcSYE63U6Vb+r6J/OhHwSHDwRI4LUYDP6Zo3RBxoekRSiAD2Vr9pPL
	 snrYkeva4AjB/vBkxVGudlG12nPSCb4QX8uUa4Mv6ALz/svtS2Gt487tt0PSwOZB2F
	 g8WmEh24o2EjEzx0/uaJkYK9r/XXOfRz9jNTNmbcfN/s5R5v8UyUu+j3oNIXj0eBF5
	 yI4VSAZ099/hS5Y3rHH/DIZgDTyIUB+QcO6XW6sTEMTr+/voOzaFgPHqc6Qyw/hJL+
	 /vWi5E5hFlvKgpAPQO/07ou8SaoTDJ860pl+ANdneOZP7i78EHjggJ/vps5dJra2xG
	 2k8koekovXphA==
From: Arnd Bergmann <arnd@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: guest-memfd: fix unused-function warning
Date: Wed, 29 Nov 2023 16:32:40 +0100
Message-Id: <20231129153250.3105359-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

With migration disabled, one function becomes unused:

virt/kvm/guest_memfd.c:262:12: error: 'kvm_gmem_migrate_folio' defined but not used [-Werror=unused-function]
  262 | static int kvm_gmem_migrate_folio(struct address_space *mapping,
      |            ^~~~~~~~~~~~~~~~~~~~~~

Replace the #ifdef around the reference with a corresponding PTR_IF() check
that lets the compiler know how it is otherwise used.

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 virt/kvm/guest_memfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 16d58806e913..1a0355b95379 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -301,9 +301,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping,
 
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
-#ifdef CONFIG_MIGRATION
-	.migrate_folio	= kvm_gmem_migrate_folio,
-#endif
+	.migrate_folio = PTR_IF(IS_ENABLED(CONFIG_MIGRATION),
+				kvm_gmem_migrate_folio),
 	.error_remove_folio = kvm_gmem_error_folio,
 };
 
-- 
2.39.2


