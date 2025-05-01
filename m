Return-Path: <kvm+bounces-45097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6FEAA5FDD
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EE674C4CE8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 14:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AABD1F151E;
	Thu,  1 May 2025 14:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0hBlpnr4"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1FF1F1313;
	Thu,  1 May 2025 14:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746109369; cv=none; b=hQkI3UFKJkJ22gEqp5bm7Sw63wVVKO7qHcjpSOML/O5gGROWAfnb9VyyHZdSX1bHqOcjHzh6t08lODAk4VGUrPSOpN5s8pmuAomK4LlsT0auiXmgajq/lUndfPib0xPI7gWjAsREautLnPmPjiBbGqf89wJdskvGs7ZaVwp6OP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746109369; c=relaxed/simple;
	bh=4uduP/E1+iiWW5QwTqKsiTlY+NnSHbK8s0ipJNrwbCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o1o6PHzbBv28segKLS92/sNST5HZs3OMpzDFVdKQmbupLw046rYwd+CqRsrVzM6iGqXeLYZpmdbp185Z/Y9o13uKTofEWJ1NjkX/acJ67PT4muvFANa1wFyjc2xr56OZ/G53xs0iiBWQn2CsJ1kBw1dRrdDrpybyUWAnNjgUsAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0hBlpnr4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Y0IQBEy5A72SAbKcBMN9KFzK0p4E//3l79XMemTBafw=; b=0hBlpnr4hU8vi3PFOkslX08aAH
	xd3HfFz7pis+wBju+KL/ABPoI4eBWseb+TTLYm8Z0rwvhyT3RQIczD4sUgOebGMp7IaKayWsYlOdm
	CXAyqE+RcN1cdA3yH+6Lg1xNVBXw7A30aV56zY30qxw0JWQgSxRaamKRELx7vsCzzXTO12JwiTDPb
	Ie0xcCJXk2j7aiaWYh9ki2V/zRDFf87zNs1C61OJxDbxcb5RUeOsxcnVStTm/UhYyidx9Xl76hnUF
	B43QBocnkbTN0hDVEjWbXMszZfTkJICHGbImWk0UiwvxHVv2BaOcSsLm6FTjv6WoaYjpMPCXc9SBi
	bXnS5tdA==;
Received: from [206.0.71.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUoJ-0000000FxIF-0c9G;
	Thu, 01 May 2025 14:22:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: mst@redhat.com,
	jasowang@redhat.com
Cc: eperezma@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH v2] vringh: use bvec_kmap_local
Date: Thu,  1 May 2025 09:22:30 -0500
Message-ID: <20250501142244.2888227-1-hch@lst.de>
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

Changes since v1:
 - actually finish the conversion

 drivers/vhost/vringh.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 73e153f9b449..f3ec2483b014 100644
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
+		__virtio16 *to = bvec_kmap_local(&ivec.iov.bvec[0]);
 
-		WRITE_ONCE(*(__virtio16 *)to, tmp);
-		kunmap_local(kaddr);
+		WRITE_ONCE(*to, tmp);
+		kunmap_local(to);
 	}
 
 	return 0;
-- 
2.47.2


