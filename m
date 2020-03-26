Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7619431F
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgCZPZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:15 -0400
Received: from foss.arm.com ([217.140.110.172]:33830 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbgCZPZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE24F7FA;
        Thu, 26 Mar 2020 08:25:14 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 01BC53F71E;
        Thu, 26 Mar 2020 08:25:13 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 18/32] ioport: Fail when registering overlapping ports
Date:   Thu, 26 Mar 2020 15:24:24 +0000
Message-Id: <20200326152438.6218-19-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we try to register a range of ports which overlaps with another, already
registered, I/O ports region then device emulation for that region will not
work anymore. There's nothing sane that the ioport emulation layer can do
in this case so refuse to allocate the port. This matches the behavior of
kvm__register_mmio.

There's no need to protect allocating a new ioport struct with a lock, so
move the lock to protect the actual ioport insertion in the tree.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 ioport.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/ioport.c b/ioport.c
index cb778ed8d757..d9f2e8ea3c3b 100644
--- a/ioport.c
+++ b/ioport.c
@@ -68,14 +68,6 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	struct ioport *entry;
 	int r;
 
-	br_write_lock(kvm);
-
-	entry = ioport_search(&ioport_tree, port);
-	if (entry) {
-		pr_warning("ioport re-registered: %x", port);
-		ioport_remove(&ioport_tree, entry);
-	}
-
 	entry = malloc(sizeof(*entry));
 	if (entry == NULL)
 		return -ENOMEM;
@@ -90,6 +82,7 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 		},
 	};
 
+	br_write_lock(kvm);
 	r = ioport_insert(&ioport_tree, entry);
 	if (r < 0)
 		goto out_free;
-- 
2.20.1

