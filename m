Return-Path: <kvm+bounces-10162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B76186A3CC
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:36:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0388EB2E6CC
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468DA5B5AC;
	Tue, 27 Feb 2024 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFjgvgk6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B070057889
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076072; cv=none; b=Mdo9zggY11YmgYCtpoos9P5QRemfA4Mvvxu1Ut/+AH/gD6mTXM7QVpNnMTvqYwZoS/4v2WEBEYwq7rdNJYUwAxggMhLULI4Kx/a4oNX3rXBZvl11Hvlp48hSl1RABsRC/2JZFZDLdfFeUKgOcatToQ5qlwb6grJXUnuUCMYKW54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076072; c=relaxed/simple;
	bh=S+uYhRirj57d50L93671lbfFFpK+UcWKuIe6fA+sLME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lvp5pGIKbtaXeV9UnUrExblyFaWqJwsyUXBS4vUKfHRHJQsbrmA1p5jyKA6piNYoc91eMpnWzkLy8YM8p6Q5wc+zazdzHsYt49lpCp/Gf0AbFN0NPTIlvRcO2JSunifOdWThaemVbRLEMG+Jqf2dVQcYYPpcRtB3u2xwhlsn240=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFjgvgk6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2AC1kWCQIdviuYJSL43BWVEXzcmh8/McQsHaI1LaBw=;
	b=ZFjgvgk6YnxGz+suaEYbiWl8TZj0bml9iNQbXZGrprzmB5TYPtAD5VI716EUKdRzKQNwC0
	7Q76tU4ButKMTmP6+BZc5n6MHXj9aOvxy2skkKlqL6cEM1Vg9ij+dF5uk5veU/ezaet/jf
	HkW9/ZvgbQpdKSOiF8nKOD6yvSNJ1pg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-179-bY7PtkpjPjONcKbOO7aBxQ-1; Tue,
 27 Feb 2024 18:21:05 -0500
X-MC-Unique: bY7PtkpjPjONcKbOO7aBxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 999A83C13A87;
	Tue, 27 Feb 2024 23:21:04 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D272C0348F;
	Tue, 27 Feb 2024 23:21:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: [PATCH 16/21] KVM: guest_memfd: pass error up from filemap_grab_folio
Date: Tue, 27 Feb 2024 18:20:55 -0500
Message-Id: <20240227232100.478238-17-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Some SNP ioctls will require the page not to be in the pagecache, and as such they
will want to return EEXIST to userspace.  Start by passing the error up from
filemap_grab_folio.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0f4e0cf4f158..de0d5a5c210c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -20,7 +20,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	/* TODO: Support huge pages. */
 	folio = filemap_grab_folio(inode->i_mapping, index);
 	if (IS_ERR_OR_NULL(folio))
-		return NULL;
+		return folio;
 
 	/*
 	 * Use the up-to-date flag to track whether or not the memory has been
@@ -146,8 +146,8 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 		}
 
 		folio = kvm_gmem_get_folio(inode, index);
-		if (!folio) {
-			r = -ENOMEM;
+		if (IS_ERR_OR_NULL(folio)) {
+			r = folio ? PTR_ERR(folio) : -ENOMEM;
 			break;
 		}
 
-- 
2.39.0



