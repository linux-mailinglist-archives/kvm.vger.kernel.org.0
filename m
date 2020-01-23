Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3415F146998
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAWNsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:42 -0500
Received: from foss.arm.com ([217.140.110.172]:39784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbgAWNsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D78B11B3;
        Thu, 23 Jan 2020 05:48:41 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2D7713F68E;
        Thu, 23 Jan 2020 05:48:40 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 17/30] hw/vesa: Don't ignore fatal errors
Date:   Thu, 23 Jan 2020 13:47:52 +0000
Message-Id: <20200123134805.1993-18-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Failling an mmap call or creating a memslot means that device emulation
will not work, don't ignore it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/vesa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/hw/vesa.c b/hw/vesa.c
index b92cc990b730..a665736a76d7 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -76,9 +76,11 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 
 	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
 	if (mem == MAP_FAILED)
-		ERR_PTR(-errno);
+		return ERR_PTR(-errno);
 
-	kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
+	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
+	if (r < 0)
+		return ERR_PTR(r);
 
 	vesafb = (struct framebuffer) {
 		.width			= VESA_WIDTH,
-- 
2.20.1

