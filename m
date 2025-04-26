Return-Path: <kvm+bounces-44393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16021A9D856
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 08:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 157751B60DD3
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 06:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EAC1D5CD1;
	Sat, 26 Apr 2025 06:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4XHQ5Fo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3C41C3BE2;
	Sat, 26 Apr 2025 06:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745648540; cv=none; b=d4LRkG+K+R2NFNglr1Dl8qYc8XAmWAj6NW2MnLXv+KJS04ACxqP1LrSPWfPkxByz838TxKT6U3w5KAGL7yKZ+dix3AUxRV7X/i6RTqh+sFMm6UMBmFf82xxZayVBIcCiGyvcQkk4m3FJ9jspgkbqZwsdIEBKLR7G5ORnfdxOZSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745648540; c=relaxed/simple;
	bh=Lo+Lep6sLWcNZQlhzW2ZLVGNj1PKx63G6pOoiymrW44=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=nww7MIkgRcnM4x1V7mD3x4o+u8ia6ViyfXOCUE4YmBrQWnQq9l4tfAZxBFr5esj4uxGngK3lDKp8MBjJ/8vyk4hPq8H6TwG7Lus9NkP4rvS95zqzZyl2kYSmRbdO8rvKWcm7OGrezZRiHq+IcqE0wgAERAUAI9SQ248p6l+03fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4XHQ5Fo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC3AC4CEE2;
	Sat, 26 Apr 2025 06:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745648538;
	bh=Lo+Lep6sLWcNZQlhzW2ZLVGNj1PKx63G6pOoiymrW44=;
	h=From:To:Cc:Subject:Date:From;
	b=j4XHQ5Fo43R4aDcWfCMlvLBN0zM3OPp+ZDW5gF6L/lHqgam/+2zxOnFwUwkIjQ+Mv
	 24D1Q+rklx6t4vcYYl8Pwfk84naXxJH/DclSvgS+11VTiV0+eecuB6AMse2zBfnJcF
	 Vtof75JQu/6GPTN51hVrBFX+9DFMbw+xrDBO4b2vs+U5fVLXWLa1l/JNBUVD0c0Agy
	 fXtFyjfQs6y8nTcHVBYt0EcZ3XxBm55S5euefCl+ia63sfW7NLPJe9EzSQMUDxpkBT
	 fwJE99AqDNczAOqXJFOMlhq40GXkQuZH1sKrMJVnnlO/uiXsPtD72XsvpjAbxaYctT
	 SjpfwjEfGarQA==
From: Kees Cook <kees@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kees Cook <kees@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] vhost: vringh: Use matching allocation type in resize_iovec()
Date: Fri, 25 Apr 2025 23:22:15 -0700
Message-Id: <20250426062214.work.334-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1839; i=kees@kernel.org; h=from:subject:message-id; bh=Lo+Lep6sLWcNZQlhzW2ZLVGNj1PKx63G6pOoiymrW44=; b=owGbwMvMwCVmps19z/KJym7G02pJDBk81dNuFBpufLHrwPyoyU7n1c8+i6/ib9l5IPb66gbFq yrO3g+rOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACaS1cLI8GJtRHayxrrOtztP 8mndKm66prJO09jxsHfNjLUaE+bLGzH8T/4qsE/k1HYhhtA91o3Hjup8PHny8Yy48jN1m3boChY fZwcA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct kvec *", but the returned type will be
"struct iovec *". These have the same allocation size, so there is no
bug:

struct kvec {
        void *iov_base; /* and that should *never* hold a userland pointer */
        size_t iov_len;
};

struct iovec
{
        void __user *iov_base;  /* BSD uses caddr_t (1003.1g requires void *) */
        __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
};

Adjust the allocation type to match the assignment.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: <kvm@vger.kernel.org>
Cc: <virtualization@lists.linux.dev>
Cc: <netdev@vger.kernel.org>
---
 drivers/vhost/vringh.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 73e153f9b449..93735fc5c5b4 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -225,10 +225,9 @@ static int resize_iovec(struct vringh_kiov *iov, gfp_t gfp)
 
 	flag = (iov->max_num & VRINGH_IOV_ALLOCATED);
 	if (flag)
-		new = krealloc_array(iov->iov, new_num,
-				     sizeof(struct iovec), gfp);
+		new = krealloc_array(iov->iov, new_num, sizeof(*new), gfp);
 	else {
-		new = kmalloc_array(new_num, sizeof(struct iovec), gfp);
+		new = kmalloc_array(new_num, sizeof(*new), gfp);
 		if (new) {
 			memcpy(new, iov->iov,
 			       iov->max_num * sizeof(struct iovec));
-- 
2.34.1


