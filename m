Return-Path: <kvm+bounces-44658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9401CAA013D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BC291A84991
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942A5274FC5;
	Tue, 29 Apr 2025 04:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umnHgPjx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035C270542;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745899577; cv=none; b=AuqHuQ+hIWdz1W+EB02CECFkKXfgAW7Tru97Pb4DYgGh288bLevYkc7d5Y1jrOgEXKT9xchNUut91x2W3JrOd5WTHroTMMLOWdUMF/o5motsaDjCS+oSAEvxgKqCKQ4vqy8Bzf9zflnunyhoK7Gcgi/YAszUjJnZlsp3IdUcKUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745899577; c=relaxed/simple;
	bh=94UzipiV219n1Nsds3GgUffrYhVWmSEuqNwCotvgHTg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=okXwicw6ow8u2UYaSZrYe2r6zQjlfc2gqpKa7Tf86rp0b5mj88GP7vChJaLcmSMO5Y5ceySaRStFAtbzHsGj5r1XkoF1ftMB9QIZK0Llea2q0K9IyaVrpbXLqYw/2IRWuevD73VHziHSEOmpEp/hWfvybJMWfTULDKjK4TnFgiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umnHgPjx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF675C4CEEE;
	Tue, 29 Apr 2025 04:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745899576;
	bh=94UzipiV219n1Nsds3GgUffrYhVWmSEuqNwCotvgHTg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=umnHgPjx/uswvCkSmQAtfNXwh0J1RgCPXPtU15EJ3BJrGMr9TeAkv+02Hx8/aJrZP
	 B9pids9hDCCRiksaveqMrCaUIPjjT40xeYtCj3KLeve1mYRGk57NEeo0YsYHn7kloJ
	 Wb5lXlJ1ICFfjMDI7QXO7ihYek6tuetYOzZNrzvuaGAxSxtzS6wFaDjCD1KHmLlOpd
	 mGs+bcfHf0EcMQwc5GWPCv3Q+hydECGq09BD3DqCK5uZZKY6iXbfQpCANImiozP2H4
	 ry6PlbZas22d5KF1Q/sW5U8JGsO3qzDZZJpJ9Sos51pOgukjAw6CGW4cOv/pPGGvJh
	 2wpUI2Qi0eYHg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC846C369D1;
	Tue, 29 Apr 2025 04:06:16 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+chenlinxuan.uniontech.com@kernel.org>
Date: Tue, 29 Apr 2025 12:06:05 +0800
Subject: [PATCH RFC v3 1/8] nvme: add __always_inline for
 nvme_pci_npages_prp
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250429-noautoinline-v3-1-4c49f28ea5b5@uniontech.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2975;
 i=chenlinxuan@uniontech.com; h=from:subject:message-id;
 bh=Z0QiTYLHzEeebaywUqCSW16Ny4EMqCsjjX+KS5KBMNU=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBoEFAukhIgTV0U3xfinuIjd2L0FB1AExqdCchlv
 A3ri9QFLWiJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaBBQLgAKCRB2HuYUOZmu
 i9PbD/0bxMLZB/tZ4Ta8gMq1WIv38DYhUP3aWnHRrfHrBmcZmF3pYKgj7U3bQhz1rGgW21/5jLf
 O6iQHC8JkszMXt7z43locXuD3D2XLaMzfIjJ4SYSBJJCUhLDwTO0hXO+SgM8VdRdhmjZUc1WhnK
 MotrwNb7+YScOJV7UKO27QZ4mEX9QtP1og5KDtG4fX2A4elJ/oUz5VyPu1ZVWaZIPGpR6UfQu2W
 3V96onZcmtcYOTu7m+Q4YYn57iocabwdiYGXp9u6+muG1V36fqjgCWLFdJ87b10fBGpqSdLd78K
 Np/ZrE3r79VyFTS10nLQwcH5emDVtRsUooPidOTFB5RbtCiWZVwNXbzPXeUAOlpo1fud6r4VWu6
 qQumY8DgxrRS5yYkJuqNuYsyMje5EqNF0cT9ACHUWaiTx2mc4D4GMZxmlK0Gb/i6H6b5Nn2r2Xj
 wAaoImxclHPRalFdhXU+KjoIiAQ+6sz9E+8WePUUrBdVGKfCKQPnIoZrmz83bxpZtjB8fQ0tEQM
 iAAaovwAWgBfxfbUHIa8VeSzTs5I5aHhO+aY/5Sd1k2ttkBswHZJumET7aNiQoPsJoewmJYilGQ
 jL21aH2TLLnbAvvZ8tf8QpXJtxzRSYrmcdb8wsQqvI0rVPoHUhioggOtX3jm+SKC+ApmPIpQr8u
 b//ZkECSNX3jkKQ==
X-Developer-Key: i=chenlinxuan@uniontech.com; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for chenlinxuan@uniontech.com/default with
 auth_id=380
X-Original-From: Chen Linxuan <chenlinxuan@uniontech.com>
Reply-To: chenlinxuan@uniontech.com

From: Winston Wen <wentao@uniontech.com>

On x86_64 with gcc version 13.3.0, I build drivers/nvme/host/pci.c
with:

  make defconfig
  ./scripts/kconfig/merge_config.sh .config <(
    echo CONFIG_BLK_DEV_NVME=m
  )
  make KCFLAGS="-fno-inline-small-functions -fno-inline-functions-called-once" \
    drivers/nvme/host/pci.o

Then I get a compile error:

    CALL    scripts/checksyscalls.sh
    DESCEND objtool
    INSTALL libsubcmd_headers
    CC      drivers/nvme/host/pci.o
  In file included from <command-line>:
  drivers/nvme/host/pci.c: In function 'nvme_init':
  ././include/linux/compiler_types.h:557:45: error: call to '__compiletime_assert_878' declared with attribute error: BUILD_BUG_ON failed: nvme_pci_npages_prp() > NVME_MAX_NR_ALLOCATIONS
    557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |                                             ^
  ././include/linux/compiler_types.h:538:25: note: in definition of macro '__compiletime_assert'
    538 |                         prefix ## suffix();                             \
        |                         ^~~~~~
  ././include/linux/compiler_types.h:557:9: note: in expansion of macro '_compiletime_assert'
    557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |         ^~~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
        |                                     ^~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        |         ^~~~~~~~~~~~~~~~
  drivers/nvme/host/pci.c:3804:9: note: in expansion of macro 'BUILD_BUG_ON'
   3804 |         BUILD_BUG_ON(nvme_pci_npages_prp() > NVME_MAX_NR_ALLOCATIONS);
        |         ^~~~~~~~~~~~

Mark nvme_pci_npages_prp() with __always_inline make it can be computed
at compile time.

Co-developed-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b178d52eac1b7f7286e217226b9b3686d07b7b6c..9ab070a9f0372bc6595c29a884ee9f2ffe5ae8e9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -390,7 +390,7 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
  * as it only leads to a small amount of wasted memory for the lifetime of
  * the I/O.
  */
-static int nvme_pci_npages_prp(void)
+static __always_inline int nvme_pci_npages_prp(void)
 {
 	unsigned max_bytes = (NVME_MAX_KB_SZ * 1024) + NVME_CTRL_PAGE_SIZE;
 	unsigned nprps = DIV_ROUND_UP(max_bytes, NVME_CTRL_PAGE_SIZE);

-- 
2.43.0



