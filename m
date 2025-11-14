Return-Path: <kvm+bounces-63150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 009A0C5ACBB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 36CC335281A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE7D264602;
	Fri, 14 Nov 2025 00:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WpYAa79o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FC72472B0
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080604; cv=none; b=K+dh4dge3MZ2a5RpPMf3Yk/zApoxqdzUKehNl/SJ+nLMNlrOCDROJSwr1bwLNP3Mht7StutTbMuu9iy1U4gtoVnDXbpuucgodVK6x6ATzy/MTJbee+m+pezrYYvUWJy/e37ui6S8xBRazRYmh7+UGmxc5MBr37nWLcCHDAKCU/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080604; c=relaxed/simple;
	bh=vxHkaROEL/BY525YUhGo0nMaP1cMhptMXQ8pDEJVP+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+St0GXVH+A2D4PvniH9twNWbQ9HEV65ec2UjT3Hj9fOoaJQ50kp3+YpjxhVdEe3/LVwwbm8TDF6KETVVGmU2rW4zE/BXMo9wuf1+SQv1VVffh36PHUdHBwxFFzMDaFVAXyM7DJW6P3iO4ZLhffQzM2mW8tGhNBaif6akwkTMcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WpYAa79o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2+QYxSsLujLsfOK9VJedC1w46EE3jwzSpZW4DcZzgUc=;
	b=WpYAa79ophJp/1uZe4HK7pvh2lW3ZexWUSN8xKNfxqzxUV2va6W5WmGOdAqR25caWa3TEo
	qPHXilnhMrstBxdTOjeB6VS9Htm2XHxaBkPlu2rZIr4x3DfwsWpHETMzqE606svnlEuScL
	94ZDgTfw8RwAxV4r3Z/1CjLr/ueUrOs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-X9VRm1CVOE6eVvXqnFd-yg-1; Thu,
 13 Nov 2025 19:36:39 -0500
X-MC-Unique: X9VRm1CVOE6eVvXqnFd-yg-1
X-Mimecast-MFC-AGG-ID: X9VRm1CVOE6eVvXqnFd-yg_1763080597
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC99C195608F;
	Fri, 14 Nov 2025 00:36:37 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 400E519560B9;
	Fri, 14 Nov 2025 00:36:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 04/10] KVM: emulate: move op_prefix to struct x86_emulate_ctxt
Date: Thu, 13 Nov 2025 19:36:27 -0500
Message-ID: <20251114003633.60689-5-pbonzini@redhat.com>
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

VEX decode will need to set it based on the "pp" bits, so make it
a field in the struct rather than a local variable.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c     | 8 ++++----
 arch/x86/kvm/kvm_emulate.h | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 28f81346878e..7ef791407dbc 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4761,7 +4761,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	int rc = X86EMUL_CONTINUE;
 	int mode = ctxt->mode;
 	int def_op_bytes, def_ad_bytes, goffset, simd_prefix;
-	bool op_prefix = false;
 	bool has_seg_override = false;
 	struct opcode opcode;
 	u16 dummy;
@@ -4813,7 +4812,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	for (;;) {
 		switch (ctxt->b = insn_fetch(u8, ctxt)) {
 		case 0x66:	/* operand-size override */
-			op_prefix = true;
+			ctxt->op_prefix = true;
 			/* switch between 2/4 bytes */
 			ctxt->op_bytes = def_op_bytes ^ 6;
 			break;
@@ -4920,9 +4919,9 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 			opcode = opcode.u.group[goffset];
 			break;
 		case Prefix:
-			if (ctxt->rep_prefix && op_prefix)
+			if (ctxt->rep_prefix && ctxt->op_prefix)
 				return EMULATION_FAILED;
-			simd_prefix = op_prefix ? 0x66 : ctxt->rep_prefix;
+			simd_prefix = ctxt->op_prefix ? 0x66 : ctxt->rep_prefix;
 			switch (simd_prefix) {
 			case 0x00: opcode = opcode.u.gprefix->pfx_no; break;
 			case 0x66: opcode = opcode.u.gprefix->pfx_66; break;
@@ -5140,6 +5139,7 @@ void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 	ctxt->rip_relative = false;
 	ctxt->rex_prefix = 0;
 	ctxt->lock_prefix = 0;
+	ctxt->op_prefix = false;
 	ctxt->rep_prefix = 0;
 	ctxt->regs_valid = 0;
 	ctxt->regs_dirty = 0;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 7b5ddb787a25..83af019620e3 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -348,6 +348,7 @@ struct x86_emulate_ctxt {
 	u8 opcode_len;
 	u8 b;
 	u8 intercept;
+	bool op_prefix;
 	u8 op_bytes;
 	u8 ad_bytes;
 	union {
-- 
2.43.5



