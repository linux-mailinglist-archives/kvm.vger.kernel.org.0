Return-Path: <kvm+bounces-63148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F116C5AC97
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 837404E01B8
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D93B24A076;
	Fri, 14 Nov 2025 00:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gd0AlaGy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F6C21254B
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080602; cv=none; b=E8aMr7n8tnSu1M11bek/wsNFXVNZg/dBQATCKKO7UYGq32K+gjQNG+eqmmFZBrRsNmosP2Q8CfW00CNDBacPGLxHhVSe50yGjKIEt4Pr+PcXvRvaNnMf0XwmB3Fi1FBU+71vkNlCiUG1o2qL0g6rPO//AiPHwQ3KhnmhHPem0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080602; c=relaxed/simple;
	bh=9xtrLqirKICH3+v4PSPZR/caXGl7ApwY7DfyxgB1iz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cv75t8BQEuim7YOHIdpiEpRaresH9JGCY5SPqjoEHTPAUdi+6OHXUnRtgeQMcFmeuUcl0JbsM/F/UVyBiUL9bIyJ3/r8hQquAp8pQbPE8ll9ZjV5mkVr169m5kHgfeU+GZ0XV6u+8K0vX+FO+urKSHAlGslxzLdr5x7UGHs+Qq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gd0AlaGy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMzO+M2E3B8XBgrzfunENWfEm+Ikh/b2200X6CIHXBc=;
	b=Gd0AlaGy1Q9cWFh31arnixrTQngtNcJ08N2y8BYQL3KE3SX5UiTBPfmcrZ60MIbrvJBtgZ
	sb5CWcHtOrHe9VKOCcPkL0uIfhyBDmgpjWZtUofMsvoZbdNdygPbQonZftGxMn2+ofOvsW
	gO0WRcXU0JWW8y3bLRCclqXeFW1AaqU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-sOEPT50fPD-k9dX9liDM6g-1; Thu,
 13 Nov 2025 19:36:36 -0500
X-MC-Unique: sOEPT50fPD-k9dX9liDM6g-1
X-Mimecast-MFC-AGG-ID: sOEPT50fPD-k9dX9liDM6g_1763080595
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD7E4180045C;
	Fri, 14 Nov 2025 00:36:35 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B2D719560B9;
	Fri, 14 Nov 2025 00:36:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 01/10] KVM: emulate: add MOVNTDQA
Date: Thu, 13 Nov 2025 19:36:24 -0500
Message-ID: <20251114003633.60689-2-pbonzini@redhat.com>
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

MOVNTDQA is a simple MOV instruction, in fact it has the same
characteristics as 0F E7 (MOVNTDQ) other than the aligned-address
requirement.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4e3da5b497b8..43ae4fcb2137 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4133,7 +4133,7 @@ static const struct gprefix pfx_0f_28_0f_29 = {
 	I(Aligned, em_mov), I(Aligned, em_mov), N, N,
 };
 
-static const struct gprefix pfx_0f_e7 = {
+static const struct gprefix pfx_0f_e7_0f_38_2a = {
 	N, I(Sse, em_mov), N, N,
 };
 
@@ -4431,7 +4431,7 @@ static const struct opcode twobyte_table[256] = {
 	/* 0xD0 - 0xDF */
 	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N,
 	/* 0xE0 - 0xEF */
-	N, N, N, N, N, N, N, GP(SrcReg | DstMem | ModRM | Mov, &pfx_0f_e7),
+	N, N, N, N, N, N, N, GP(SrcReg | DstMem | ModRM | Mov, &pfx_0f_e7_0f_38_2a),
 	N, N, N, N, N, N, N, N,
 	/* 0xF0 - 0xFF */
 	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N
@@ -4458,8 +4458,13 @@ static const struct gprefix three_byte_0f_38_f1 = {
  * byte.
  */
 static const struct opcode opcode_map_0f_38[256] = {
-	/* 0x00 - 0x7f */
-	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
+	/* 0x00 - 0x1f */
+	X16(N), X16(N),
+	/* 0x20 - 0x2f */
+	X8(N),
+	X2(N), GP(SrcReg | DstMem | ModRM | Mov | Aligned, &pfx_0f_e7_0f_38_2a), N, N, N, N, N,
+	/* 0x30 - 0x7f */
+	X16(N), X16(N), X16(N), X16(N), X16(N),
 	/* 0x80 - 0xef */
 	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
 	/* 0xf0 - 0xf1 */
-- 
2.43.5



