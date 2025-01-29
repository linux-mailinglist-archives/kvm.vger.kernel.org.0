Return-Path: <kvm+bounces-36857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35C66A21EBB
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D735416AF20
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DBB81F03CB;
	Wed, 29 Jan 2025 14:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InlmoVu2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE4212E1CD;
	Wed, 29 Jan 2025 14:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159446; cv=none; b=ia9GEKaVcWNGqi11LWm5JqgdUis8ZR3qxkXsNZjDosPfUZaInuNHLhvK/wXmKqEDM2NsVRwSkZPXBjvl8WqANkAdaJxtznqCrD6DO0sJLPOoY9g0mRSOACJp/ST1ljc3hIiYZq+FomNr6nH71CB9n9KYaTAqLfAsy8cV/qLp7rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159446; c=relaxed/simple;
	bh=lSYTTN3hLoJkIAgPTbOeIJipjaPZmjsbDaNomJGGk6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oqTY24tlF4LvAU9vO3Lkr+ritSj/LDzTFPcTtbDGa35529C9db+jbaOkf6sDnJiyN+eHwu8pFvbZ9kH1OQDseMjICKYNbmwDk5hdCCnxz3Y4X27ZETQQGHsXriUEugIkbAWHkEdBYX6lgj7YhP59+pRVfnoQC+AOtIt9aUarWpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InlmoVu2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0801CC4CED1;
	Wed, 29 Jan 2025 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159446;
	bh=lSYTTN3hLoJkIAgPTbOeIJipjaPZmjsbDaNomJGGk6Y=;
	h=From:To:Cc:Subject:Date:From;
	b=InlmoVu2EcKULhE5ak463nq8CikMhKuT65xu5FFk/TFDGh1zFfRZWWiH8bYwsjr5s
	 k7sNWmu9w38/NclCROrwCJCZKCWI/dwb02o4kSfU3vzYsLrSb/mdt5Cy3kC+vXkTzo
	 OtEiKBgD31Ed8FBCcr2L6r734DbTJk5Dj/AtKgivueJyW4UAY1b9NcA47mxWqjJI9K
	 5fUVx/clmrLG/rDn0T78YyFuVMPY1Euo2OR+0uCKxPLdtIE3ThA7CvSmyDnHnEDQ73
	 wJin4cKGE+LpDo76QJxLlXlPKtrb5ygJdN4/vTV7WQgVaTX7B8Ppj89rgsCWD6Vruw
	 scw7tR6FRrQpw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ramesh Thomas <ramesh.thomas@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Yunxiang.Li@amd.com,
	jgg@ziepe.ca,
	gbayer@linux.ibm.com,
	bpsegal@us.ibm.com,
	ankita@nvidia.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Wed, 29 Jan 2025 08:00:20 -0500
Message-Id: <20250129130024.1273272-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.233
Content-Transfer-Encoding: 8bit

From: Ramesh Thomas <ramesh.thomas@intel.com>

[ Upstream commit 2b938e3db335e3670475e31a722c2bee34748c5a ]

Definitions of ioread64 and iowrite64 macros in asm/io.h called by vfio
pci implementations are enclosed inside check for CONFIG_GENERIC_IOMAP.
They don't get defined if CONFIG_GENERIC_IOMAP is defined. Include
linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64 macros
when they are not defined. io-64-nonatomic-lo-hi.h maps the macros to
generic implementation in lib/iomap.c. The generic implementation does
64 bit rw if readq/writeq is defined for the architecture, otherwise it
would do 32 bit back to back rw.

Note that there are two versions of the generic implementation that
differs in the order the 32 bit words are written if 64 bit support is
not present. This is not the little/big endian ordering, which is
handled separately. This patch uses the lo followed by hi word ordering
which is consistent with current back to back implementation in the
vfio/pci code.

Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241210131938.303500-2-ramesh.thomas@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a0b5fc8e46f4d..fdcc9dca14ca9 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 #include "vfio_pci_private.h"
 
-- 
2.39.5


