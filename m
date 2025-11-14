Return-Path: <kvm+bounces-63154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BEECCC5ACB8
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C24C34E5CBF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7984283CBF;
	Fri, 14 Nov 2025 00:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PG1kvnGg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266EE268C42
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080607; cv=none; b=LofZuvEr7A1SpX9ZruKQ4i+iMkV4YZVH9HtVND+R3WhFXIfiYaHfkKWMDsUMR3oeD/rKymimBO+YLH7KK6njfl+gVu2LjKBkZJGBDJ9noRiwlx0/VHTr5uOU6NV8UH0CbBS+zV9P8E57bd6ErBsDymHslVv/GWLfYvNEzLdW9Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080607; c=relaxed/simple;
	bh=gsqJButb/WxCugAlU5RRzsHtU3PFmk0VKfPN29GaQrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZ6zDNJTqbJD7g7s5Y8clTqWIU4NZOdxGDR5yF9gCgCJSUJx7cC2WeDdgHrah/tMHAtNqxrMYfvDX8eHGtBLdHu/88Md4EoAgh7GxaQXZY/RI6D2SchNXkxHwZVsOqhxmcc7U6AOlEsdKlvkOUOWl0m3O9WIs5bRwRkcGc5q62c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PG1kvnGg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2pThv8sz01YiUVMpsc4DJLfGIJT4Z4GexoPb88TO8I=;
	b=PG1kvnGgLtThCb2fd8bOFtsyb/TBuwuhkDsmBwSkwismiL44dhXM/SxXskCrxynLbqIBIw
	v6fRPb3idAdeYqo0ojTHM5fT2yq/fPAAnqZdXsy1xXSYT3N7okosIHHpiO795/BswX5CMX
	RdGcmrDlykA5VpOdU5Aq4/uI968HxJ4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-nTJ9kuv5OQ-rhCI5Nv6_3g-1; Thu,
 13 Nov 2025 19:36:43 -0500
X-MC-Unique: nTJ9kuv5OQ-rhCI5Nv6_3g-1
X-Mimecast-MFC-AGG-ID: nTJ9kuv5OQ-rhCI5Nv6_3g_1763080602
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1C3118AB404;
	Fri, 14 Nov 2025 00:36:42 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 247F7300018D;
	Fri, 14 Nov 2025 00:36:42 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 10/10] KVM: emulate: enable AVX moves
Date: Thu, 13 Nov 2025 19:36:33 -0500
Message-ID: <20251114003633.60689-11-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Some users of KVM have emulated devices (typically added to private
forks of QEMU) that execute AVX instructions on PCI BARs.  Whenever
the guest OS tries to do that, an illegal instruction exception or
emulation failure is triggered.

Add the Avx flag to move instructions:
- (66) 0f 10 - MOVUPS/MOVUPD from memory
- (66) 0f 11 - MOVUPS/MOVUPD to memory
- 66 0f 6f - MOVDQA from memory
- 66 0f 7f - MOVDQA to memory
- f3 0f 6f - MOVDQU from memory
- f3 0f 7f - MOVDQU to memory
- (66) 0f 28 - MOVAPS/MOVAPD from memory
- (66) 0f 29 - MOVAPS/MOVAPD to memory
- (66) 0f 2b - MOVNTPS/MOVNTPD to memory
- 66 0f e7 - MOVNTDQ to memory
- 66 0f 38 2a - MOVNTDQA to memory

Co-developed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/kvm/BD108C42-0382-4B17-B601-434A4BD038E7@fb.com/T/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1e17043a6304..75619bdc600f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4122,7 +4122,7 @@ static const struct group_dual group15 = { {
 } };
 
 static const struct gprefix pfx_0f_6f_0f_7f = {
-	I(Mmx, em_mov), I(Sse | Aligned, em_mov), N, I(Sse | Unaligned, em_mov),
+	I(Mmx, em_mov), I(Sse | Avx | Aligned, em_mov), N, I(Sse | Avx | Unaligned, em_mov),
 };
 
 static const struct instr_dual instr_dual_0f_2b = {
@@ -4142,7 +4142,7 @@ static const struct gprefix pfx_0f_28_0f_29 = {
 };
 
 static const struct gprefix pfx_0f_e7_0f_38_2a = {
-	N, I(Sse, em_mov), N, N,
+	N, I(Sse | Avx, em_mov), N, N,
 };
 
 static const struct escape escape_d9 = { {
@@ -4355,8 +4355,8 @@ static const struct opcode twobyte_table[256] = {
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
 	/* 0x10 - 0x1F */
-	GP(ModRM | DstReg | SrcMem | Mov | Sse, &pfx_0f_10_0f_11),
-	GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_10_0f_11),
+	GP(ModRM | DstReg | SrcMem | Mov | Sse | Avx, &pfx_0f_10_0f_11),
+	GP(ModRM | DstMem | SrcReg | Mov | Sse | Avx, &pfx_0f_10_0f_11),
 	N, N, N, N, N, N,
 	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 4 * prefetch + 4 * reserved NOP */
 	D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4372,9 +4372,9 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_dr_write, dr_write,
 						check_dr_write),
 	N, N, N, N,
-	GP(ModRM | DstReg | SrcMem | Mov | Sse, &pfx_0f_28_0f_29),
-	GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_28_0f_29),
-	N, GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_2b),
+	GP(ModRM | DstReg | SrcMem | Mov | Sse | Avx, &pfx_0f_28_0f_29),
+	GP(ModRM | DstMem | SrcReg | Mov | Sse | Avx, &pfx_0f_28_0f_29),
+	N, GP(ModRM | DstMem | SrcReg | Mov | Sse | Avx, &pfx_0f_2b),
 	N, N, N, N,
 	/* 0x30 - 0x3F */
 	II(ImplicitOps | Priv, em_wrmsr, wrmsr),
-- 
2.43.5


