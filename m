Return-Path: <kvm+bounces-16907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7C18BEB26
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E6701C20B1C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7443716D9BE;
	Tue,  7 May 2024 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WcXysAcJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926F616D319
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105257; cv=none; b=MEdfhwITXMFXp1QKbputFy8Mq0BwWNXdQYQ4xdoBrOVYVtyLnJ+BigYw+VdiW6wdmWJt2CQ2Ph4ZWERd19eQwv8HXecPMdhN0Y5TzG7imwlQBbAlQIGMr6GmBIS5J0WR4wavh1EU4R0NcXvtJizR1G7wktAWEw48IzFThJJVpjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105257; c=relaxed/simple;
	bh=hVFNZWdC9DOlDIg8Up+tLBUHcZP6ppMY7wF+VHGHOKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSCWd0VGUN2z/7liM3sx2RyxBLKrX9pB8AKGsvvYvM+W38sFikbZoRW2ROgB98eOFYG72d7YSrAUlfPcl9fkNdqfjwz1SshUw6oAsknMvLtR/tu5BKm6+EBoS9GkE0fzsvWgtgKcjIgk912nH0xD1aDbDlpO39yG47Ujh2nAm9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WcXysAcJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gHuV5lFHC0UB6R5XPoecvLq/6suqEUmHMMZiSdK/AsE=;
	b=WcXysAcJ/oYrXV42onvZ/n8Am01Bom+jCUebho7reWIemIE6ofU4zeyDH1Y9/GmofBF8xU
	T3X0JTbuUv9A9/GIoApdoSDzoNCMjEVTa9kcEShhuaCusHTTuHKIhDqz9HfOC3FDO3E8eW
	Eb12p7Jr2XBQWEz57G3JQiPQlMOqQ0s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-kJxJYozMOuOAWSI42hlSTw-1; Tue, 07 May 2024 14:07:31 -0400
X-MC-Unique: kJxJYozMOuOAWSI42hlSTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD98C85A58C;
	Tue,  7 May 2024 18:07:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 76BC040C6EB7;
	Tue,  7 May 2024 18:07:30 +0000 (UTC)
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
	yilun.xu@intel.com,
	linux-mm@kvack.org
Subject: [PATCH 2/9] KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode
Date: Tue,  7 May 2024 14:07:22 -0400
Message-ID: <20240507180729.3975856-3-pbonzini@redhat.com>
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

From: Michael Roth <michael.roth@amd.com>

truncate_inode_pages_range() may attempt to zero pages before truncating
them, and this will occur before arch-specific invalidations can be
triggered via .invalidate_folio/.free_folio hooks via kvm_gmem_aops. For
AMD SEV-SNP this would result in an RMP #PF being generated by the
hardware, which is currently treated as fatal (and even if specifically
allowed for, would not result in anything other than garbage being
written to guest pages due to encryption). On Intel TDX this would also
result in undesirable behavior.

Set the AS_INACCESSIBLE flag to prevent the MM from attempting
unexpected accesses of this sort during operations like truncation.

This may also in some cases yield a decent performance improvement for
guest_memfd userspace implementations that hole-punch ranges immediately
after private->shared conversions via KVM_SET_MEMORY_ATTRIBUTES, since
the current implementation of truncate_inode_pages_range() always ends
up zero'ing an entire 4K range if it is backing by a 2M folio.

Link: https://lore.kernel.org/lkml/ZR9LYhpxTaTk6PJX@google.com/
Cc: linux-mm@kvack.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240329212444.395559-6-michael.roth@amd.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0f4e0cf4f158..5a929536ecf2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -357,6 +357,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
+	inode->i_mapping->flags |= AS_INACCESSIBLE;
 	inode->i_mode |= S_IFREG;
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-- 
2.43.0



