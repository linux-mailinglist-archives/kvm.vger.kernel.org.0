Return-Path: <kvm+bounces-12052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E3B87F411
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B7A283C54
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F72A604AC;
	Mon, 18 Mar 2024 23:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JzPnz6xO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D9A5FB95
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804843; cv=none; b=e4Aqpevz3XeYWl4wjJBdqPzTmZTe8+j+kHPUHNj8O3dkgV7iHtgmEGSbEessC12okNewa3elkEfZXa9/JPDEbMcztXALpiUTDwhnAwnmBOqN3Sx2naH0u6q/3bJmWHkHyX1s2KSXzJ7k7WHbip/LvNGsBVcL/faPMJ8Pgd1rGVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804843; c=relaxed/simple;
	bh=EcmswukeZI313nMpV8tNY2A/YJT9P17ql1iH81L5DCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BPx5Mnepc/vUWJ6jjcrXcVXOQ4fL18UEYglh8c+dRzuPiMmCBUWCkPVNeickLb8YQmyy9Ul0zZ70ZX1TSE3/OyjYRTaHVkr0xWhThp7qIUSHrkzpRheh+BzEqkInHxA6m1b+KF1YN2n0G8umPPK/saubq8+OSFPn0IkeXaukoig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JzPnz6xO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CU08kKmFr2y+l/PfA7wEzPvqxMRumVnT+OH5USVjR9A=;
	b=JzPnz6xOxtoW04kaJnGENYAoCJzdZhf9V54HbeKhEnx3D7QcvtpZ2hRuwDtlgFIws/kvoY
	iuWzpT0VROJUMrKStOaSkcqinJPp8MW48El4zk048pPV3NFyOVNLIIt6du7Z80HZt3Co6O
	7kAv4A5EvD4S8w9ofgdMdZ7Zd5qaMQQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-ueGFrfW5NUGeIrIZwqWvTA-1; Mon, 18 Mar 2024 19:33:56 -0400
X-MC-Unique: ueGFrfW5NUGeIrIZwqWvTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CA9B101A552;
	Mon, 18 Mar 2024 23:33:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56A611C060A4;
	Mon, 18 Mar 2024 23:33:56 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 13/15] KVM: SEV: allow SEV-ES DebugSwap again
Date: Mon, 18 Mar 2024 19:33:50 -0400
Message-ID: <20240318233352.2728327-14-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

The DebugSwap feature of SEV-ES provides a way for confidential guests
to use data breakpoints.  Its status is record in VMSA, and therefore
attestation signatures depend on whether it is enabled or not.  In order
to avoid invalidating the signatures depending on the host machine, it
was disabled by default (see commit 5abf6dceb066, "SEV: disable SEV-ES
DebugSwap by default", 2024-03-09).

However, we now have a new API to create SEV VMs that allows enabling
DebugSwap based on what the user tells KVM to do, and we also changed the
legacy KVM_SEV_ES_INIT API to never enable DebugSwap.  It is therefore
possible to re-enable the feature without breaking compatibility with
kernels that pre-date the introduction of DebugSwap, so go ahead.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dc22b31faebd..1a11840facfb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -42,7 +42,7 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
-static bool sev_es_debug_swap_enabled = false;
+static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 


