Return-Path: <kvm+bounces-63151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id F094BC5ACCD
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B13F53571DF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31E526FD9B;
	Fri, 14 Nov 2025 00:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WXB5F9+5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADF425785D
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080606; cv=none; b=X/PNE43/npA9MdNiPdRn5V5COqa0VGv359m7akNgYAmWBFqAvwIr0AsVFmaBGjoE8fe8dUSFbc0lfqp/b+/+kmOnANWMEDb/591hXHoERCXwoMXrLswyJiwxLXsrDUBoaZFwdh8ghKngCKuV11bWMBiJXyblu1SsGxSG5T0o+cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080606; c=relaxed/simple;
	bh=o/pGAoGbIVp+fh4K/ZWEnQNrfi8awnyaiB1MiJypuD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAi8FJjwvJuTuEzzz+0mC3+BwJQjIbkfkJIRzmF5XuW+4MdSzC95SjA+UEXMZ1b/G3sL9sIucEpfmGmi9jPkFYjxjg/xLiCzQg+kQJ1tnw9fPuYBe6pXLYcdvHwE9JCzgprqE55Vvh1qzxuUk8/zqWdW0SODNCPlVyq2QPtxLLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WXB5F9+5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zm/zWVFRQtJEXVqjp0si12SzgJsoQe9GWB6V5sFDnSU=;
	b=WXB5F9+5KBAbV6kXHtt3nt0SvaRXiugo6nDCahfqCItdOsgqzRE02p/kYVzHmqDTFyMaKQ
	2JlXvwzGWi4xCCSPbRaF78LUXaomUYZ1M9jFcUqsISUdBiAJkxuOMyOCite8TpyEP8WaXK
	yZ6NEfqsZQzpkUye2Fyit9XxewuYf/o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-ETaiBloaPA6mz-JP1GSweA-1; Thu,
 13 Nov 2025 19:36:40 -0500
X-MC-Unique: ETaiBloaPA6mz-JP1GSweA-1
X-Mimecast-MFC-AGG-ID: ETaiBloaPA6mz-JP1GSweA_1763080599
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53EEC180045C;
	Fri, 14 Nov 2025 00:36:39 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE65C19560B9;
	Fri, 14 Nov 2025 00:36:38 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 06/10] KVM: emulate: add get_xcr callback
Date: Thu, 13 Nov 2025 19:36:29 -0500
Message-ID: <20251114003633.60689-7-pbonzini@redhat.com>
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

This will be necessary in order to check whether AVX is enabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/kvm_emulate.h | 1 +
 arch/x86/kvm/x86.c         | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 83af019620e3..5f9d69c64cd5 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -237,6 +237,7 @@ struct x86_emulate_ops {
 	bool (*is_smm)(struct x86_emulate_ctxt *ctxt);
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
+	int (*get_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 *xcr);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 
 	gva_t (*get_untagged_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9c2aa6f4705..cfce7c120215 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8842,6 +8842,14 @@ static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
 	kvm_make_request(KVM_REQ_TRIPLE_FAULT, emul_to_vcpu(ctxt));
 }
 
+static int emulator_get_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 *xcr)
+{
+	if (index != XCR_XFEATURE_ENABLED_MASK)
+		return 1;
+	*xcr = emul_to_vcpu(ctxt)->arch.xcr0;
+	return 0;
+}
+
 static int emulator_set_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr)
 {
 	return __kvm_set_xcr(emul_to_vcpu(ctxt), index, xcr);
@@ -8914,6 +8922,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.is_smm              = emulator_is_smm,
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
+	.get_xcr             = emulator_get_xcr,
 	.set_xcr             = emulator_set_xcr,
 	.get_untagged_addr   = emulator_get_untagged_addr,
 	.is_canonical_addr   = emulator_is_canonical_addr,
-- 
2.43.5



