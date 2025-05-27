Return-Path: <kvm+bounces-47793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED30AC5138
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 16:47:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D2F33BAEE6
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 14:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F3E279918;
	Tue, 27 May 2025 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aQvWONh1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C20F2CCC0
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748357175; cv=none; b=kqbilMM6vdxJckg5mii8yyRLCXIcwOTke2kPTlTObNcpN7ZeP0aoue+zmYWx0u0azqyNR+OUFJLuYry3TC0KMTsLXoulIIM2rOt6bFlYri9YXpMoMrpD5XETW4YG0iOFMfgSMd1VS4r0jEh4rFNMXjw2rFrWrB60VbWNFeLWhbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748357175; c=relaxed/simple;
	bh=j+1FYl1eH47hvev1VnD13nxIOLXyM7N6wIPD+7tAisw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VDgBFGpK9G8GVQyl+YAjT0kkzngFOSNLh5E8ym3fP+taaCs0rg3yTHacuHUbl/sn3ouPOIUduBHoSmaKXfvqJaK6Vz9JLRxmeitG8Z60nvSAZRNmdPeVQOnkfpxvC/C7tKJvS1L6j9aijhya5du6v4Br3BfgadJq1pPbxaggcQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aQvWONh1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748357172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TYvH6opew6c0SfiVsSSap4M4b37BCRrFIqizknsdu/Q=;
	b=aQvWONh1TCxVoTiNGuJQaQPIYacdBQ1tbxa8GV1eFaJ29wTujVRmcu8SwehbcDvTT2k4nT
	1HeHVBO8SsTIIuy+vCpRDa8muC5PvFKa2mmYdLS04fvfzZbqEp98BzbKW2ACXSZsJWHkpO
	4mMJEBnXzbR6qgmWjEE2r6HmAJXjeaI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-Senl8kZHMmmjF5SAdGBHUw-1; Tue,
 27 May 2025 10:46:09 -0400
X-MC-Unique: Senl8kZHMmmjF5SAdGBHUw-1
X-Mimecast-MFC-AGG-ID: Senl8kZHMmmjF5SAdGBHUw_1748357168
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6B0919560BB;
	Tue, 27 May 2025 14:46:07 +0000 (UTC)
Received: from dobby.home.kraxel.org (unknown [10.45.226.108])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 247183000717;
	Tue, 27 May 2025 14:46:03 +0000 (UTC)
Received: by dobby.home.kraxel.org (Postfix, from userid 1000)
	id D2E7044FBC2; Tue, 27 May 2025 16:46:00 +0200 (CEST)
From: Gerd Hoffmann <kraxel@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86/sev/vc: fix efi runtime instruction emulation
Date: Tue, 27 May 2025 16:45:44 +0200
Message-ID: <20250527144546.42981-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In case efi_mm is active go use the userspace instruction decoder which
supports fetching instructions from active_mm.  This is needed to make
instruction emulation work for EFI runtime code, so it can use cpuid
and rdmsr.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 36beaac713c1..145f594d7e6b 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -346,7 +346,7 @@ static enum es_result __vc_decode_kern_insn(struct es_em_ctxt *ctxt)
 
 static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
 {
-	if (user_mode(ctxt->regs))
+	if (user_mode(ctxt->regs) || current->active_mm == &efi_mm)
 		return __vc_decode_user_insn(ctxt);
 	else
 		return __vc_decode_kern_insn(ctxt);
-- 
2.49.0


