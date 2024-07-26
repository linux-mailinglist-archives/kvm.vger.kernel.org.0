Return-Path: <kvm+bounces-22338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE6193D8A2
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:53:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 949BC1F24F58
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAAF6149C45;
	Fri, 26 Jul 2024 18:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E2yKnBHv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BEC77110
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 18:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722019929; cv=none; b=TbQY8k+NhnYea2FXULW1DR8GhxUaPRgz4SV2EF/vVZo7Y3oTHRZ5df1HF8uyXPCJzwpIA4SxKoMxag7Deqq8qQknDOuvJLcS+WAy/sqBe6hIXkF9h0BAvST2kK05f2yJtcCsAqKQo5vJOk7OKDSdk77WvipV4RUG7rYvZr08muM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722019929; c=relaxed/simple;
	bh=HnUElBeQKRL1MutPm5oCZ7vX+DXUmz4ApaPIT5WcH7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vai1gmb4YC9Cvv7oV7u1Csr6qgJjTMLnLlVttPylyi3e8uJjbZrGszrJjq+F3Ol9gD8QdjgktZd0jJpYXF49zJGFMM4LbySySr4urK5wczbYBP8Fk1dBq+F78xHWWiaBPcfzpDpLksXcNNmORPYGvmzl4oPvIhBMshJe86zsiAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E2yKnBHv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722019927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rlInCC/uW0M23bzyOsgzc7VI9SzS/mJVpYI8FhQeX5c=;
	b=E2yKnBHv+cRj46/o+zpvFiKUJFi7bAaZmFlEQlVEp/+FL6iqxP2yDX0dXOvqdxSvSJCDTr
	L7yHd9rcreC1tFZSNJeJEnxKlZLtOgQjIaTj+dCQacLXKh6GfyPE09Uyv2cl5y6qCAOH3u
	AMgsOW4ZbXM2280aWWeKm8f0v9b6fQM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-zIj4yEPJO9242zJO79y3cw-1; Fri,
 26 Jul 2024 14:52:02 -0400
X-MC-Unique: zIj4yEPJO9242zJO79y3cw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 613D41956095;
	Fri, 26 Jul 2024 18:52:01 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB4B93000194;
	Fri, 26 Jul 2024 18:52:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH v2 03/14] KVM: guest_memfd: delay folio_mark_uptodate() until after successful preparation
Date: Fri, 26 Jul 2024 14:51:46 -0400
Message-ID: <20240726185157.72821-4-pbonzini@redhat.com>
In-Reply-To: <20240726185157.72821-1-pbonzini@redhat.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The up-to-date flag as is now is not too useful; it tells guest_memfd not
to overwrite the contents of a folio, but it doesn't say that the page
is ready to be mapped into the guest.  For encrypted guests, mapping
a private page requires that the "preparation" phase has succeeded,
and at the same time the same page cannot be prepared twice.

So, ensure that folio_mark_uptodate() is only called on a prepared page.  If
kvm_gmem_prepare_folio() or the post_populate callback fail, the folio
will not be marked up-to-date; it's not a problem to call clear_highpage()
again on such a page prior to the next preparation attempt.

Reviewed-by: Michael Roth <michael.roth@amd.com>
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



