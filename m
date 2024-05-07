Return-Path: <kvm+bounces-16909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A068B8BEB29
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4188C1F21A03
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC9C16DEB8;
	Tue,  7 May 2024 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YZ5ittu2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62616D32A
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105258; cv=none; b=rT8ELPGkqjSb3/48T/Q04/Pb0+EvhsseOBYaF0pgijj1HCOLcJRuBAE1sRU9rgFGD7eG5O7UzRbGe2Dm/TWwD7+TqUPgBReBwwUUkG8BrBo15FYn1rAbmAwWp+kWQUIQDbh5KBHfMrTJVhVA05AaaaFrrdcIQ113nd9bEBxrz84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105258; c=relaxed/simple;
	bh=uVnyZYyImXug/IJ95scTctCA5brtGWGQMQzMQw1hIi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IFaaxmX9xo/uYqOi3nIuDJAszjeIxQv6aeqYcMuIVi0f0lCjQeXYjWuABpnk0BLadivuZ/MfWnMWXjPA5NUOx30VhndwwBl+5n5Bbk8MF3fJZ0YbbgkpbJsgq7anMLqXdK/4ijWCyJtCd09t+jLjqfHRP9/COPCtFlkcyGfouY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YZ5ittu2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x9rksasoN6o3C+2hIlFTffjFimcLr+rqnzsLWoL6yPo=;
	b=YZ5ittu2ktw8KESNCPcAAUF6OtkyursBH6QSyxTrjm3MNm2cOo9EkTtqx3brvDs1ztIAdf
	BOOw90gjHzPp1G6ZaITaC94yvdNjCMxUeMzeJgkzeRHumoM9ZL32FzAQaCrdaVPfFQVdzn
	4BKGVX3k7bvorOzU4ZFFiwF1whOX1Og=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-6ZNMbvA3MjuEJ08xwNW0wQ-1; Tue, 07 May 2024 14:07:32 -0400
X-MC-Unique: 6ZNMbvA3MjuEJ08xwNW0wQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B7401839B6C;
	Tue,  7 May 2024 18:07:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1ABD040C6EB7;
	Tue,  7 May 2024 18:07:31 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: vbabka@suse.cz,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	michael.roth@amd.com,
	yilun.xu@intel.com
Subject: [PATCH 4/9] KVM: guest_memfd: limit overzealous WARN
Date: Tue,  7 May 2024 14:07:24 -0400
Message-ID: <20240507180729.3975856-5-pbonzini@redhat.com>
In-Reply-To: <20240507180729.3975856-1-pbonzini@redhat.com>
References: <20240507180729.3975856-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Because kvm_gmem_get_pfn() is called from the page fault path without
any of the slots_lock, filemap lock or mmu_lock taken, it is
possible for it to race with kvm_gmem_unbind().  This is not a
problem, as any PTE that is installed temporarily will be zapped
before the guest has the occasion to run.

However, it is not possible to have a complete unbind+bind
racing with the page fault, because deleting the memslot
will call synchronize_srcu_expedited() and wait for the
page fault to be resolved.  Thus, we can still warn if
the file is there and is not the one we expect.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c27828b0d42d..fd32288d0fbc 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -499,7 +499,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	gmem = file->private_data;
 
-	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot)) {
+	if (xa_load(&gmem->bindings, index) != slot) {
+		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
 		r = -EIO;
 		goto out_fput;
 	}
-- 
2.43.0



