Return-Path: <kvm+bounces-21442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9EB92F1DC
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06EED283F35
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37CE1A0732;
	Thu, 11 Jul 2024 22:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jbv6REEG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B1515CD79
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 22:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736884; cv=none; b=dOXojhZINstaW+ENPAni+IP92FvYWQU9hM04WOVyRUKHS73fkSsPHDs0cn9iUKp0fwYfNSJPhdDs2mH2/mX/brv20wZfFgtFcO8sDtLl6uSMPF7eZzzZUmo375gULNPKugS7/P0ZuKgOcxyUv5/RaXeb5I0ur4RqxWUOLYGG9RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736884; c=relaxed/simple;
	bh=BoNFTMNodlsB+PzOqqm9FaRQDDjFEoEodW/SZ/JxIgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=juSJrUw1HL5yQsVRMC0Fv/vJdIf7FPqJZ4nQfaUhYonHM0hldAXYkWsPNKLRBQQMkapFClfwz8OGDUs8O4+n8jABgBDNiazhtNZzWm7GvRPQjDN0PUzja4S5Q1kVRDE3zSdTfgn0leabThdaFVIaFh9UeDHk0YLHPRFS3YEluxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jbv6REEG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720736881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eD20AnLzqduoYD1gk5YMqXZJv49fFs5h4FT96ZIsKZg=;
	b=Jbv6REEGsh7+GGN0LLfe9/+/0zvGGuO+kJ25s/7OYrazypD/0MUBcyiMegRPZBm2CXyY56
	hX8nkO5lZJHmw8CObu4kd0NFndEKAiMmns/KX5ADWl74YlABIXet+udjlpcdRozghIbljf
	0kAPk2KEchUjvW/3jmXwwwff7pptK78=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-llKx0sUsNyaWHEDP-qGuUw-1; Thu,
 11 Jul 2024 18:27:59 -0400
X-MC-Unique: llKx0sUsNyaWHEDP-qGuUw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C219196CE01;
	Thu, 11 Jul 2024 22:27:58 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B2C9619560AE;
	Thu, 11 Jul 2024 22:27:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH 02/12] KVM: guest_memfd: delay folio_mark_uptodate() until after successful preparation
Date: Thu, 11 Jul 2024 18:27:45 -0400
Message-ID: <20240711222755.57476-3-pbonzini@redhat.com>
In-Reply-To: <20240711222755.57476-1-pbonzini@redhat.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The up-to-date flag as is now is not too useful; it tells guest_memfd not
to overwrite the contents of a folio, but it doesn't say that the page
is ready to be mapped into the guest.  For encrypted guests, mapping
a private page requires that the "preparation" phase has succeeded,
and at the same time the same page cannot be prepared twice.

So, ensure that folio_mark_uptodate() is only called on a prepared page.  If
kvm_gmem_prepare_folio() or the post_populate callback fail, the folio
will not be marked up-to-date; it's not a problem to call clear_highpage()
again on such a page prior to the next preparation attempt.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 522e1b28e7ae..1ea632dbae57 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -73,8 +73,6 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 
 		for (i = 0; i < nr_pages; i++)
 			clear_highpage(folio_page(folio, i));
-
-		folio_mark_uptodate(folio);
 	}
 
 	if (prepare) {
@@ -84,6 +82,8 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 			folio_put(folio);
 			return ERR_PTR(r);
 		}
+
+		folio_mark_uptodate(folio);
 	}
 
 	/*
@@ -646,6 +646,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
+		if (!ret)
+			folio_mark_uptodate(folio);
 
 		folio_put(folio);
 		if (ret)
-- 
2.43.0



