Return-Path: <kvm+bounces-2459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA7D7F894A
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 09:34:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FD32B215C4
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 08:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEDD7C15D;
	Sat, 25 Nov 2023 08:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEKqf8J9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6048E10F6
	for <kvm@vger.kernel.org>; Sat, 25 Nov 2023 00:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700901245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=37TsTYXqNHIurQZSI6nP6/rFe+8uy0S4I2sdRSNsCA0=;
	b=dEKqf8J98lozGLkrP/CnBfMi83/qtD9qGrBwVEB9NP4kogEkKROXkSRUJ31T9r89T2P/4/
	uzmwv7OtyWoQb5+yZgR2Frhmgl/MnCP72wiYKJr1nG06OAt+6FF0Jm6sMNtkVVTR8IsqLr
	ZbIlh50dTka1vBN9P/MVAad8WAIvz9o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-ekSR8i3BPkK372lj5BasCw-1; Sat, 25 Nov 2023 03:34:02 -0500
X-MC-Unique: ekSR8i3BPkK372lj5BasCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAD6A82BA81;
	Sat, 25 Nov 2023 08:34:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8B081121306;
	Sat, 25 Nov 2023 08:34:01 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	mlevitsk@redhat.com
Subject: [PATCH v2 4/4] KVM: x86/mmu: fix comment about mmu_unsync_pages_lock
Date: Sat, 25 Nov 2023 03:34:00 -0500
Message-Id: <20231125083400.1399197-5-pbonzini@redhat.com>
In-Reply-To: <20231125083400.1399197-1-pbonzini@redhat.com>
References: <20231125083400.1399197-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Fix the comment about what can and cannot happen when mmu_unsync_pages_lock
is not help.  The comment correctly mentions "clearing sp->unsync", but then
it talks about unsync going from 0 to 1.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1cb81573a60b..a71b8813febe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2840,9 +2840,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 			/*
 			 * Recheck after taking the spinlock, a different vCPU
 			 * may have since marked the page unsync.  A false
-			 * positive on the unprotected check above is not
+			 * negative on the unprotected check above is not
 			 * possible as clearing sp->unsync _must_ hold mmu_lock
-			 * for write, i.e. unsync cannot transition from 0->1
+			 * for write, i.e. unsync cannot transition from 1->0
 			 * while this CPU holds mmu_lock for read (or write).
 			 */
 			if (READ_ONCE(sp->unsync))
-- 
2.39.1


