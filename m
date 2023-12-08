Return-Path: <kvm+bounces-3948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B69380AC71
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D396CB20A48
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1507047A6A;
	Fri,  8 Dec 2023 18:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7m8XMyh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF71CFB
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 10:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702061353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1U4FyBTNgaTu3ym4pmdpXt8ICQFx8oOPzOCvbI3KWnc=;
	b=Q7m8XMyhnN3VM7cpNK8sb1gGYFNN1K+ClDKO1FnDL9WqSMNwb6vuTOm0aGvlxFMdH1UNND
	Of/RvjPnHL3hgRzRQ5bl+AjAiPmiGQozJH6+bYBZ4Errf/2jkq0tBcsGrQnIA8t6lf1vQx
	GCgTrOdfKmGvcdrKjpQBvyApybi3olw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-eVXvRh78Mjm_x0I8g51vlQ-1; Fri, 08 Dec 2023 13:49:09 -0500
X-MC-Unique: eVXvRh78Mjm_x0I8g51vlQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51FB3832D1B;
	Fri,  8 Dec 2023 18:49:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD93E40C6EB9;
	Fri,  8 Dec 2023 18:49:08 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2] KVM: guest-memfd: fix unused-function warning
Date: Fri,  8 Dec 2023 13:49:08 -0500
Message-Id: <20231208184908.2298225-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

With migration disabled, one function becomes unused:

virt/kvm/guest_memfd.c:262:12: error: 'kvm_gmem_migrate_folio' defined but not used [-Werror=unused-function]
  262 | static int kvm_gmem_migrate_folio(struct address_space *mapping,
      |            ^~~~~~~~~~~~~~~~~~~~~~

Remove the #ifdef around the reference so that fallback_migrate_folio()
is never used.  The gmem implementation of the hook is trivial; since
the gmem mapping is unmovable, the pages should not be migrated anyway.

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b99272396119..c2e2371720a9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -300,9 +300,7 @@ static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
 
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
-#ifdef CONFIG_MIGRATION
 	.migrate_folio	= kvm_gmem_migrate_folio,
-#endif
 	.error_remove_page = kvm_gmem_error_page,
 };
 
-- 
2.39.1


