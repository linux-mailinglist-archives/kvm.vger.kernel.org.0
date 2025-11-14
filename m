Return-Path: <kvm+bounces-63147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AB437C5AC94
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 009B94E1187
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DAF23BCED;
	Fri, 14 Nov 2025 00:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="POEQq+3v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B522066F7
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080601; cv=none; b=tAB2Ga6pm4cEwTrWP8hOvc+8idMmtoV3fzvyi+nn6rT1GGcYFPjXLN23GYTN074K2jGqpnoByva/9Fy+lAnxy982Xo5V2j+/VtO5ZjWsW60VUTqt2lV8fdP4VN4W6Z+j/LtMUaosUvmEaEAmhMUjA3+dRgyP0uuhjGhz0GAC6ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080601; c=relaxed/simple;
	bh=a3L6QLaldfc+rPWdOd5zLnwvXemLEtC1kQ6lujtyV6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lY4AMNkggJ+lbd7t3f4rAVLxIqrLlj41c8JpyA4wQokgW7d+LPuFe9a1d9YLq7FLIuTdx4bov5a6MVYgdrYi+oJlspBskf20qca5/hPEDHp/Dx1DPlpFhFb61MD6xlzkRt7oZd8cU5avS8FZI14YovrvtqlRxX6E0t7CM4TNwMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=POEQq+3v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccguT6wpF0pEXtqnNdiiJug6HM4TEtQF3DpQSjXibEs=;
	b=POEQq+3vY1TtZPCS+6AwQesIBEq7xgP6QQxONuASKN+X+e1GhY5IGpCcKsdZq0tSA8Wkzz
	EbK7f/wRM+TNcJpFctZQ6y6j9uB+xnqWbVUU2t7sI1bJmgU+1Stdobbq841kGQfCmyW4+w
	N7ARkXqpXJF7A5A6WNEgm3MyQIHkITg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-6z6MLITpPtCpSDu7Pf0HPQ-1; Thu,
 13 Nov 2025 19:36:37 -0500
X-MC-Unique: 6z6MLITpPtCpSDu7Pf0HPQ-1
X-Mimecast-MFC-AGG-ID: 6z6MLITpPtCpSDu7Pf0HPQ_1763080596
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 720181956096;
	Fri, 14 Nov 2025 00:36:36 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BCA6519560B9;
	Fri, 14 Nov 2025 00:36:35 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 02/10] KVM: emulate: move Src2Shift up one bit
Date: Thu, 13 Nov 2025 19:36:25 -0500
Message-ID: <20251114003633.60689-3-pbonzini@redhat.com>
In-Reply-To: <20251114003633.60689-1-pbonzini@redhat.com>
References: <20251114003633.60689-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

An irresistible microoptimization (changing accesses to Src2 to just an
AND :)) that also frees a bit for AVX in the low flags word.  This makes
it closer to SSE since both of them can access XMM registers, pointlessly
shaving another clock cycle or two (maybe).

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 43ae4fcb2137..57799b5d9da2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -147,7 +147,7 @@
 #define PageTable   (1 << 29)   /* instruction used to write page table */
 #define NotImpl     (1 << 30)   /* instruction is not implemented */
 /* Source 2 operand type */
-#define Src2Shift   (31)
+#define Src2Shift   (32)       /* bits 32-36 */
 #define Src2None    (OpNone << Src2Shift)
 #define Src2Mem     (OpMem << Src2Shift)
 #define Src2CL      (OpCL << Src2Shift)
@@ -161,6 +161,7 @@
 #define Src2FS      (OpFS << Src2Shift)
 #define Src2GS      (OpGS << Src2Shift)
 #define Src2Mask    (OpMask << Src2Shift)
+/* free: 37-39 */
 #define Mmx         ((u64)1 << 40)  /* MMX Vector instruction */
 #define AlignMask   ((u64)7 << 41)
 #define Aligned     ((u64)1 << 41)  /* Explicitly aligned (e.g. MOVDQA) */
-- 
2.43.5



