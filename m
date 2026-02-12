Return-Path: <kvm+bounces-71014-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wqGtHz9FjmmfBQEAu9opvQ
	(envelope-from <kvm+bounces-71014-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:25:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5D01313D3
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:25:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E378C3010218
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 21:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AC3347FD1;
	Thu, 12 Feb 2026 21:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OtiPNqyQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E166A2D8DD6
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 21:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770931514; cv=none; b=Hvl1DB/7rQoV849JmAGui17V4NXcZ4wU9SyCYNc9O7VNvNJIZrMt/GSC63HLnTwvC74/p4brOgMrVXUFK0V8gMMp+jR2ek0jkNMpv7CDuMBgHJaJhQpaDEdfhZZEWEXoUqlKH81EKgk54Q+yKQmXqimLJUMVywKnAFXjaSxvwG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770931514; c=relaxed/simple;
	bh=KRhe4rELu/sz9QsZje5A7ZyRCiBmJhzJPEwVLEqS/1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xd9NuOL+D1OzJH3EjmuR1RQTd3+J18d7lQ6Mh458q6LU+k0gpRTKj5hf6UenE3Fe20gynJP6myhaWG4xErCJJ9Lvi2vLX4TLVwLnu8LD4NeEbozh4dvogW2oAwIjBI3wynNRTB7bnh9xBrh68kTMDX3hsFzeqshcv3iBEd5Nluw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OtiPNqyQ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-480706554beso2944175e9.1
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 13:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770931511; x=1771536311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q07s9ZcFobUHauXrgdwNud5gwoKYfOpZ6mEK9JsUxm8=;
        b=OtiPNqyQ0IfIxGzMPUzrFoAqCRGZKKyHZxFay7OJSShdMl1dMgtN3sm59XJQ0Sgo0A
         17EoT9cGbi08usadXqJhrakZlPciNGbkG9454paeN6BzRU1LxOlbEp7HJog2YZcgMwcW
         p+bDnCmE8W19pfYfZflyUib1mB6Zt/de24bUCdCW1qL/G09ktV6K8Ui41HlynHhQBibu
         5+ds9Ca4iShjXD+5mvQGUA6/xlz4QkkBOuytFMgwJUrlM2SMz2LJjukax/bhByGY2cM2
         g8hMM2PHq+kjvhSHWn6l9So3yi5uWtYEg5cRTSWhkoiDtsKGfeVkpGkcMPvrreTHf9xt
         IcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931511; x=1771536311;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q07s9ZcFobUHauXrgdwNud5gwoKYfOpZ6mEK9JsUxm8=;
        b=N/NFKNJauJiaof12pfEa22KJ0aMo3O3r/Po4yWxYgk2Hox05zWLTyH4jtWxkiytkLb
         zf6uo+3yUJ2M83ZMfaQZZicN1jyQUcfOImmQYe37N7kxkM5+N9j3QH+NYbPIO8lKZWqh
         w470iOpsf+xKRu4yNEYivua21IUK/9/I17HFfdyXEJcjQdDGU24OdrBBhry0yXqUjrOV
         CZOJyQr+H8vKRQZMfLYIyOBL/MUUYfyjyslQE0dGzCPMeiFgDvPAutRLn92uYzqUpufM
         izqqHWq2cGntGyz/dsfZ7HcfmSwFbBDONt6cqZYiObMv4wxPvVBuijbb8iht/gwPhvel
         fkyg==
X-Gm-Message-State: AOJu0YzKQocpagireD9UFXp6Ko311eWqYwjcUH4QhIOk70go82qi9bZ8
	FDFdDlW/0lIeF/fakODSn5IzrH54Gv2MVBQMY8ds/GAFS5rHSc0STbOcnfsT3Oku
X-Gm-Gg: AZuq6aLHbiWsIUxfYXhH5igfh3i1Hr+4TVswyhEOIBNH0WFV9wJq3Iq7ofmIISyOcI9
	DkG0beoCum0s11mK0ItgFrefjnEkhyXJqawqS0TOQbdNZT+eZudh5oXbVxjD5Gsxz3y+6HlHSxL
	OrD2sfKznYGVfxPykTxunzgv0/IUHUU/bnfsPBTAVhu3YQBaxBPq7dYPiaTeRpU2c6sLmYtkNSe
	A57E6MNSb1uQFWgXZR5uD5GOcamHyxC7Ufr1iLHjoC3pikzmXy+y+vPe6fXDhKr+zFnnYz3Vkny
	GUTUbUa8FRBAdmtJz5VJ00MEaOOuFMp62saRLBfA2rbTynmi6wdjaGxeCu1mfhR7dn6p36Bex61
	lQ5YtGNt2qeKr4iT4SxP4l59FrB91blLfw89pCpPkzjGkZDApy7V2SOKWDHjydlqswzWvCSvxmS
	uyC3fAf0QOJESWCT1zWi2klEN+039YBHU/ql6Sb08pDfCqW9yzDRcPhfE=
X-Received: by 2002:a05:600c:699a:b0:482:f564:d613 with SMTP id 5b1f17b1804b1-48370e23c36mr7565265e9.15.1770931510844;
        Thu, 12 Feb 2026 13:25:10 -0800 (PST)
Received: from fedora ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835dcfaae1sm113802635e9.10.2026.02.12.13.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 13:25:10 -0800 (PST)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM: x86: Zero-initialize temporary fxregs_state buffers in FXSAVE emulation
Date: Thu, 12 Feb 2026 22:24:04 +0100
Message-ID: <20260212212457.24483-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,google.com,redhat.com,kernel.org,alien8.de,linux.intel.com,zytor.com];
	TAGGED_FROM(0.00)[bounces-71014-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ubizjak@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,alien8.de:email,zytor.com:email]
X-Rspamd-Queue-Id: 9A5D01313D3
X-Rspamd-Action: no action

Explicitly zero-initialize stack-allocated struct fxregs_state
variables in em_fxsave() and fxregs_fixup() to ensure all padding and
unused fields are cleared before use.

Both functions declare temporary fxregs_state buffers that may be
partially written by fxsave. Although the emulator copies only the
architecturally defined portion of the state to userspace, any padding
or otherwise untouched bytes in the structure can remain uninitialized.
This can lead to the use of uninitialized stack data and may trigger
KMSAN reports. In the worst case, it could result in leaking stack
contents if such bytes are ever exposed.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c8e292e9a24d..20ed588015f1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3708,7 +3708,7 @@ static inline size_t fxstate_size(struct x86_emulate_ctxt *ctxt)
  */
 static int em_fxsave(struct x86_emulate_ctxt *ctxt)
 {
-	struct fxregs_state fx_state;
+	struct fxregs_state fx_state = {};
 	int rc;
 
 	rc = check_fxsr(ctxt);
@@ -3738,7 +3738,7 @@ static int em_fxsave(struct x86_emulate_ctxt *ctxt)
 static noinline int fxregs_fixup(struct fxregs_state *fx_state,
 				 const size_t used_size)
 {
-	struct fxregs_state fx_tmp;
+	struct fxregs_state fx_tmp = {};
 	int rc;
 
 	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_tmp));
-- 
2.53.0


