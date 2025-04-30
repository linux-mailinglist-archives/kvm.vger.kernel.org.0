Return-Path: <kvm+bounces-44917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8398EAA4DFE
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCEF49C3302
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 13:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A1825E459;
	Wed, 30 Apr 2025 14:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FbBbUVmN"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6F82512D9;
	Wed, 30 Apr 2025 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746021610; cv=none; b=P80hAPf5b3ktteNiIJvd4KYgCIwQjNO8rLsfeRcaZKMJ0yI4fgyKWa+mC90+G157VXdVMkrdQFrwix2Ap6qOpYQxLH+/fwsjW4grHEEhCxI8HJCPEuAsSiuvEzZS0jcum8b3X6zQg+2ne99aGil5Mg7Js/ye/e/5djDUVIJqB0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746021610; c=relaxed/simple;
	bh=jzKXco1InVJpT8YnddnfCznsHQ/xhGBSVeadGGk6FjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E7ymVcRKUszMqa4Oa0qhosoOHv8PyQL47JUX9mDLAgs8Jix/F3/hHrFO+0bO9BP5Jzr2V9z9t4AvG/Yl/5p4doUA21Rbxufp863jijsAfnhnx99/3H6IsMUaq1ZHgJvj1fm7zSeIfRdZvqaMX3R0qrIOrYBFysIjkBANDCcPEXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FbBbUVmN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hp1dhRMiEEl3xs/2lDO5cInsDNc9pOFtlVo1nTqdIlw=; b=FbBbUVmNAG5SNipgjSq5IkJKVH
	vvgl50G4wFhNJsVw1GMKgTZSpOtLq5Xs7C7+MxgvAJtjJFQR4d3ZZhDnFgn/XtW4XKlnKlL7EUWQH
	0pKXg2MgJnGHcGTxr0vveMZcPK+3kcEZmUY+hbr97icxgYZPPsnsUS+hCimIhIhs9+gsh4AxfZk/c
	Dtcop5nQLPyx+M6BZ9CBanmRo3sreSDnN4Dfu5ryrFRKlACSPxOwa4i7D/cWYpbrpRpC41G5uu1/v
	w1dR2z5pz7Sv0V9mjMpP7HEG/U8en/Pom0XGayT6leUn+/E8NLzF3YmXS7eStzPi2004Z+nBS922M
	Nvi5Zo/g==;
Received: from [206.0.71.33] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uA7yp-0000000D40G-1cAx;
	Wed, 30 Apr 2025 14:00:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: mst@redhat.com,
	jasowang@redhat.com
Cc: eperezma@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH] vringh: use bvec_kmap_local
Date: Wed, 30 Apr 2025 09:00:04 -0500
Message-ID: <20250430140004.2724391-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the bvec_kmap_local helper rather than digging into the bvec
internals.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vhost/vringh.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 73e153f9b449..f8caa322bafa 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1291,11 +1291,10 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 		if (ret)
 			return ret;
 	} else {
-		void *kaddr = kmap_local_page(ivec.iov.bvec[0].bv_page);
-		void *from = kaddr + ivec.iov.bvec[0].bv_offset;
+		__virtio16 *from = bvec_kmap_local(&ivec.iov.bvec[0]);
 
-		tmp = READ_ONCE(*(__virtio16 *)from);
-		kunmap_local(kaddr);
+		tmp = READ_ONCE(*from);
+		kunmap_local(from);
 	}
 
 	*val = vringh16_to_cpu(vrh, tmp);
@@ -1330,11 +1329,10 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 		if (ret)
 			return ret;
 	} else {
-		void *kaddr = kmap_local_page(ivec.iov.bvec[0].bv_page);
-		void *to = kaddr + ivec.iov.bvec[0].bv_offset;
+		__virtio16 *to = kmap_local_page(&ivec.iov.bvec[0]);
 
-		WRITE_ONCE(*(__virtio16 *)to, tmp);
-		kunmap_local(kaddr);
+		WRITE_ONCE(*to, tmp);
+		kunmap_local(to);
 	}
 
 	return 0;
-- 
2.47.2


