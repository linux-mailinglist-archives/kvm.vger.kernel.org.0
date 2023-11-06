Return-Path: <kvm+bounces-650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE9D7E1E98
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC652B2124E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239AC18E05;
	Mon,  6 Nov 2023 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v9GGJRYS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F93A18041
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:40:25 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6F4A1
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UEnjaXF9IbVpfGR6pVwSlj7B+44LHx3n6ww2MVgkTpA=; b=v9GGJRYSotjmH5aMKb615be3Wh
	A1SIx3pqMqmeGy+3oNTCGKnqFJdb5KIGg/zpCYxMEK7EBG7CvNqv+7uzJTgzNZhqT0p2zeACSmuQA
	AE9Kr3tGyv2X7LVTKZOoFBHE46N3ry/HY7XkMw5A+oxo7NStJih00MnU/DfEkCStM2lAuuFIbtAo8
	Spa3GytWn1hjEQUXwjU6P8Y23QDIdFc+5uHZFRkSkz0ARD998Lnm06p8S8FoaQUDm1amp/qKAkVpx
	9pHknZWs5urn5hg6GhsU81PlAY/6Iu3JLqi8s6vVBCnHktWnbr8Ks22660tRwpyHG5cuC/T6JHDQ5
	N2C6zWEA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qzx1P-005R1h-Og; Mon, 06 Nov 2023 10:39:56 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1qzx1Q-000qG9-09;
	Mon, 06 Nov 2023 10:39:56 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org,
	qemu-stable@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 4/7] hw/xen: don't clear map_track[] in xen_gnttab_reset()
Date: Mon,  6 Nov 2023 10:39:52 +0000
Message-ID: <20231106103955.200867-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106103955.200867-1-dwmw2@infradead.org>
References: <20231106103955.200867-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The refcounts actually correspond to 'active_ref' structures stored in a
GHashTable per "user" on the backend side (mostly, per XenDevice).

If we zero map_track[] on reset, then when the backend drivers get torn
down and release their mapping we hit the assert(s->map_track[ref] != 0)
in gnt_unref().

So leave them in place. Each backend driver will disconnect and reconnect
as the guest comes back up again and reconnects, and it all works out OK
in the end as the old refs get dropped.

Cc: qemu-stable@nongnu.org
Fixes: de26b2619789 ("hw/xen: Implement soft reset for emulated gnttab")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/i386/kvm/xen_gnttab.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/i386/kvm/xen_gnttab.c b/hw/i386/kvm/xen_gnttab.c
index 21c30e3659..839ec920a1 100644
--- a/hw/i386/kvm/xen_gnttab.c
+++ b/hw/i386/kvm/xen_gnttab.c
@@ -541,7 +541,5 @@ int xen_gnttab_reset(void)
     s->entries.v1[GNTTAB_RESERVED_XENSTORE].flags = GTF_permit_access;
     s->entries.v1[GNTTAB_RESERVED_XENSTORE].frame = XEN_SPECIAL_PFN(XENSTORE);
 
-    memset(s->map_track, 0, s->max_frames * ENTRIES_PER_FRAME_V1);
-
     return 0;
 }
-- 
2.41.0


