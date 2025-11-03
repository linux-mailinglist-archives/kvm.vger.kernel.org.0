Return-Path: <kvm+bounces-61799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03DF8C2AB2A
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 10:18:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAD0E188E1F1
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 09:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B75E2E88A2;
	Mon,  3 Nov 2025 09:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P361Trol"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA4D38D
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 09:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762161476; cv=none; b=dqNmW/Sao+kDATORLcp+YvW6GjBjd9bK2vBZHiqVd+Wy2uI5RZlZMr5tR4I36xquLc4A3+PmUaSjGQXxj/6rr6vIfzlAb2JoeKSg+FwSGjS/+y1Ylwcy0eA20HfMgdfKHnSqY/qU6zjQ57ByMch+6+AxXQ4zZ3oEHRFx+mXaRtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762161476; c=relaxed/simple;
	bh=LY1xRyw/sotSmc1ZWJGJzk33jk3SQzhqq5wkvs4AlEA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VqhI63vnV7EOD6NBMPr1wxEeU1T61Cup5bvHHmnmfcX/f27j110pJdQ84uN+zDzxaocIlPE4OGlVsF2X7l1wdRa32zv7LGtHuBuM4U2LFuzkQIn9aH1KfOZDBKwhtZE5yGBx9tCyCLGh4me3S4rd+SqZIJzCZVxIEhjKrLnJjZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P361Trol; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 077A5C4CEFD
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 09:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762161476;
	bh=LY1xRyw/sotSmc1ZWJGJzk33jk3SQzhqq5wkvs4AlEA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=P361Trolla5WlyCdCW7GyQa4tfpi6k7q3AT6QGAp0BGcevAWe7gjkgaLH6hwygdhA
	 STSbFB5ObnESud9KmyVeyvE2DwTPJUqwRDpeT1vJD3OkQ3XFODZS3qKLCl91Yw09GJ
	 yyVzmuJcuq192+Op+yUyGH9bboGIyzFlcRRdxpc3rGNjtpFLGuYlOqsvZytCNW9GCa
	 +mCiYSKcT4lmAcq6dA6Ed7Btu0kw8l2taiTiPeLYmiEKhrtlX1WinNQH4YVNTIj4Wk
	 x/cWMSSkHUW5bnwSUKwCSnX7t4l/wUPLD5xOUyLBZHC971B2YgRtkKyJpNo3XIPE+C
	 EBxHE6IzEwdNA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F06C2C53BC5; Mon,  3 Nov 2025 09:17:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Mon, 03 Nov 2025 09:17:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit cc cf_regression
Message-ID: <bug-220740-28872-Lz15Sg6qBz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220740-28872@https.bugzilla.kernel.org/>
References: <bug-220740-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220740

Chen, Fan (farrah.chen@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |2b938e3db335e3670475e31a722
                   |                            |c2bee34748c5a
                 CC|                            |farrah.chen@intel.com
         Regression|No                          |Yes

--- Comment #1 from Chen, Fan (farrah.chen@intel.com) ---
I reproduced this issue on SPR, GNR, SRF, CWF.
If we disable "PCIE Error Enabling" in BIOS, host will not crash.

After bisecting, the first bad commit is:
commit 2b938e3db335e3670475e31a722c2bee34748c5a (HEAD)
Author: Ramesh Thomas <ramesh.thomas@intel.com>
Date:   Tue Dec 10 05:19:37 2024 -0800

    vfio/pci: Enable iowrite64 and ioread64 for vfio pci

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
    Link:
https://lore.kernel.org/r/20241210131938.303500-2-ramesh.thomas@intel.com
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
b/drivers/vfio/pci/vfio_pci_rdwr.c
index 66b72c289284..a0595c745732 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>

 #include "vfio_pci_priv.h"

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

