Return-Path: <kvm+bounces-73262-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YK7ANdt9rmlfFQIAu9opvQ
	(envelope-from <kvm+bounces-73262-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 08:59:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D4AE23524B
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 08:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 720F4304C622
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 07:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F1A36AB7C;
	Mon,  9 Mar 2026 07:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zt5QHL9P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB735CBC4
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 07:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773043060; cv=none; b=jzvoh2n3+BjN4j7TNPu8hReDbhcXESTwLYzDw542PNx5Tv9OxjU82dqA6YzO5MWnLxk9vQl2wMFTOq4XtZj0KpJWtf4vt0H7GoKKNZN+tFKM8IYGeN9trg2HzeDFWDXiZDgM0BjygotGguuCMidE31ca2DGff47yKwufN/C8CIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773043060; c=relaxed/simple;
	bh=frZ/Gjh5qCWQ8LcCQqDuW5jr4lafMvpstNc8bo2TYgo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P8RFBGXb0fxmsU+wWWUViKPRHR7g2Z+RbrU2SMhgOmay4X8xFFnoOWpJ+9JnOxKlNBBhbe+vH5jHWEUh9/uAKwqKVGCEjtlV1/CEYCsdefSmTCXsf8B0dstL3YNy0QxksfOCAPUXbGd+gZCcaj8i27Id1MB2IV06VzosfMyKtag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zt5QHL9P; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-354a18c48b5so10186787a91.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 00:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773043059; x=1773647859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vYxvvKDM1kpJclPuX2KpjyyYIPBTNr1A0MC60wYdYOM=;
        b=Zt5QHL9PMEZ0jiSwu8EbhxR1BPjVkRMjtfi8An2+LNjpAt1RN6U4kyB8bZABAX73ZB
         NT4hxkL38y0ob8rVcVU0P6ap5HqVD+XVzIfxFAyUojcxsqrA4A10+domFINdmaFvfkBA
         Es63hub0usnuMknYcH1teFNqyFmyBMDXdKEH6gJj6z7vFowyOp4T6cEKEHpmCc7b18CL
         Pd3Cg6G4tmFVEXx2jQpe7I/LNpmIwCw4QTsQ/5KU7X5/s7SHlnwG+RGD1T5ZKCOsqggk
         1hLBa4CU0JGpeC4qq++Le/n8N7FqAkPnW8Sp9WzYD+KiKxbiDeekn+GPfvPv3KSCKM5+
         kdDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773043059; x=1773647859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYxvvKDM1kpJclPuX2KpjyyYIPBTNr1A0MC60wYdYOM=;
        b=J36CGs7yhi2zpm6sklnz8iH5lN7UTFnt0UP2cXaUZPWnl26PuST9r/uEl2NBuiK3nz
         rBwI2tBis1Fqa8SADKVNvv9nfFOujKB+zL5Jy+KKKSXOpiZ6W6vBUbTwFZqDK+vNJt/Q
         qxWCOW9hiF17fak7Mdu77GRY7A2QsB1W/HzUqU2syVy3F2DQyBhRxFLR4FtL1SBKtFb9
         UTBPCTqwDuRg5awF2Ox9MBTn/C38bDEh0Tx+bKWRPd5gr9kyJnB8iZ58KbiaqdxaZPHA
         HfRGziWl6Fx1wFSfPPj/0gmJexRJm+dwkCeGBLF1bOh45UmqZa8RJwBSmJua32H6J4Xh
         /9Eg==
X-Forwarded-Encrypted: i=1; AJvYcCXNacmx2nRlg5glZw2ABJWvQt81RVE5DGzDCT8eoxcoRMh0ZFlxukYBNy9ftsb7YrNUeLc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3d+Q0NoRBAVADBf8xnmpSxQGDfliR+TLMCnOPZQNR+rqeITcD
	JVDTatQkrUAaBzdcU17GtDHhC+rxpJ+L2w0Gx8CZZREvNSL4aldKK1+b
X-Gm-Gg: ATEYQzw2KSoVs7vh1EuN/WKxS8QYA8YraBoo7CUXRiXNWJE5z4dvzvV04+ZKvTxlKN+
	XvNAErRho4PCboArsISoEChAuVx6FeUWNHPgWJ8mSGU2sEkMjkszCXEqhhwGLmvatlp4gRTQllQ
	pOmOzspaIfbgAXf1MNFRb/7r4qBNhpB1Sfgt0SaEgUtVOqldUmFOfPghuCuWAChwF4160lsv6Se
	rHsdxwJy8kRVQJy6er4fnALduA9w0mGkfs4jqKjCSse56jTFTDcX22NIlpTR71ijDGS9DznbWiz
	KG45WnG3kDfvG+sPMrRHxAvjpensvZppBek2gYH+KT3SiNl0W9lQVFPY632F1krUxtDB94LrSh5
	ajlFvEOmlvAOfzzobYR4yCiQf80ENnPOL2D6FdCiWeWTzBTpWzZqqheOajHHPhnZ6Xtnf85uK8U
	GtN5Nqnqx0t4bsoDlVfPYXXJLZnZ0v1nO3Jxh22n1ykkcOUA==
X-Received: by 2002:a17:90b:4cc6:b0:340:ff7d:c26 with SMTP id 98e67ed59e1d1-359be3082b7mr9445937a91.16.1773043058893;
        Mon, 09 Mar 2026 00:57:38 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.3])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359c0154a09sm10039968a91.12.2026.03.09.00.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 00:57:38 -0700 (PDT)
From: phind.uet@gmail.com
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nguyen Dinh Phi <phind.uet@gmail.com>,
	syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: pfncache: Fix uhva validity check in kvm_gpc_is_valid_len()
Date: Mon,  9 Mar 2026 15:56:29 +0800
Message-ID: <20260309075629.24569-2-phind.uet@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D4AE23524B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73262-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,syzkaller.appspotmail.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[phinduet@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.987];
	TAGGED_RCPT(0.00)[kvm,cde12433b6c56f55d9ed];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,appspotmail.com:email]
X-Rspamd-Action: no action

From: Nguyen Dinh Phi <phind.uet@gmail.com>

In kvm_gpc_is_valid_len(), if the GPA is an error GPA, the function uses
uhva to calculate the page offset. However, if uhva is invalid, its value
can still be page-aligned (for example, PAGE_OFFSET) and this function will
still return true.

An invalid uhva could lead to incorrect offset calculations and potentially
trigger a WARN_ON_ONCE in __kvm_gpc_refresh().

Fixing it by adding an additional check for uhva.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed

---
 virt/kvm/pfncache.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 728d2c1b488a..707ead0a096c 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -60,8 +60,16 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 static bool kvm_gpc_is_valid_len(gpa_t gpa, unsigned long uhva,
 				 unsigned long len)
 {
-	unsigned long offset = kvm_is_error_gpa(gpa) ? offset_in_page(uhva) :
-						       offset_in_page(gpa);
+	unsigned long offset;
+
+	if (kvm_is_error_gpa(gpa)) {
+		if (kvm_is_error_hva(uhva))
+			return false;
+
+		offset = offset_in_page(uhva);
+	} else {
+		offset = offset_in_page(gpa);
+	}
 
 	/*
 	 * The cached access must fit within a single page. The 'len' argument
-- 
2.43.0


