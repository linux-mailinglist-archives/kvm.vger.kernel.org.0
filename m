Return-Path: <kvm+bounces-39228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB5EA456D7
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 08:42:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B376188F8A3
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 07:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F52826BD8C;
	Wed, 26 Feb 2025 07:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CB45Bxm1";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CB45Bxm1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3070268FE0
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 07:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740555732; cv=none; b=d1eA5oETe84Zz7bivB/6wNLGpWSyoRRNwGbMI1sOAPgEfuYrgh+QjXPl0PK9saRAZIza3eoSE8HN8uIOshGkXuLbAsI+FvXQgEc00QoqVor0nAwRIdAh89awztvjrsH3QF0udQUGuDaLDsWmNZUmIz6Gu6jST/Aplpo/sZbI7Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740555732; c=relaxed/simple;
	bh=+MQf+S9kFQnlMCCJLtaaAS/cjIg2FayZa+gZhZQ+Eec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XOfbEohPMJD09MXy8thl7MfeNMUVDkSmvkKuc7w4HLFs2O5FKgKaZxNuS0isLxDJQ2V/UvNRjjqa2B81PhUeQTkvoPOMGfZPJchSGmz1xDHRP2wfpryEW/8RIp6yLlnTDZTUT6QwZn87FXxBlmRKiyAXgwNxQmZO8MVB2iclGPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CB45Bxm1; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CB45Bxm1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95BC421195;
	Wed, 26 Feb 2025 07:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740555721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UKa2Q017dfnP0J7Tq5MMMM65VUVHlhiGjjKd3E3FmNo=;
	b=CB45Bxm1lVSFflNe6WoaU1k/X9H2gDvlVtb7Rczm6/BT2YgVewck0LbTHrbMMu0IfTroy/
	LWrbmW0tDH/Ik+0AJshWq36MVF2d6Zkru5Lio3F7lMDmfeZuHbJMLMOdCApS86Kfnsyx/v
	TgcWrjJpa+CFuVwr6HnZ1MRrdTbJqdI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=CB45Bxm1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740555721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UKa2Q017dfnP0J7Tq5MMMM65VUVHlhiGjjKd3E3FmNo=;
	b=CB45Bxm1lVSFflNe6WoaU1k/X9H2gDvlVtb7Rczm6/BT2YgVewck0LbTHrbMMu0IfTroy/
	LWrbmW0tDH/Ik+0AJshWq36MVF2d6Zkru5Lio3F7lMDmfeZuHbJMLMOdCApS86Kfnsyx/v
	TgcWrjJpa+CFuVwr6HnZ1MRrdTbJqdI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4AE0013A53;
	Wed, 26 Feb 2025 07:42:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bzngD8nFvmc4NwAAD6G6ig
	(envelope-from <nik.borisov@suse.com>); Wed, 26 Feb 2025 07:42:01 +0000
From: Nikolay Borisov <nik.borisov@suse.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH] KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines
Date: Wed, 26 Feb 2025 09:41:51 +0200
Message-ID: <20250226074151.312588-1-nik.borisov@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95BC421195
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

Those defines are only used in the definition of the various
EPT_VIOLATIONS_ACC_* macros which are then used to extract respective
bits from vmexit error qualifications. Remove the _BIT defines and
redefine the _ACC ones via BIT() macro. No functional changes.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
---
 arch/x86/include/asm/vmx.h | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f7fd4369b821..aabc223c6498 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -580,18 +580,13 @@ enum vm_entry_failure_code {
 /*
  * Exit Qualifications for EPT Violations
  */
-#define EPT_VIOLATION_ACC_READ_BIT	0
-#define EPT_VIOLATION_ACC_WRITE_BIT	1
-#define EPT_VIOLATION_ACC_INSTR_BIT	2
 #define EPT_VIOLATION_RWX_SHIFT		3
-#define EPT_VIOLATION_GVA_IS_VALID_BIT	7
-#define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
-#define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
-#define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
-#define EPT_VIOLATION_ACC_INSTR		(1 << EPT_VIOLATION_ACC_INSTR_BIT)
+#define EPT_VIOLATION_ACC_READ		BIT(0)
+#define EPT_VIOLATION_ACC_WRITE		BIT(1)
+#define EPT_VIOLATION_ACC_INSTR		BIT(2)
 #define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
-#define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
-#define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
+#define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
+#define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
 
 /*
  * Exit Qualifications for NOTIFY VM EXIT
-- 
2.43.0


