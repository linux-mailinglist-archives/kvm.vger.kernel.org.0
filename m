Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579C0455288
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 03:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbhKRCQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 21:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241485AbhKRCQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 21:16:50 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAF5C061764
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 18:13:51 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x18-20020a17090a789200b001a7317f995cso4118025pjk.4
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 18:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2Js2iHBO2bZVfNMqUVey3hZaIS7yAI9P1HePKZNMPjA=;
        b=StB2FGyNfxc2zpcYOPcBGNktxSHAjN23Ec7WAeY4so4yqYSmScPquLDjh/m9LV6HoD
         fdeYbBmfy+fBMvCLrQIkwr8RtHFOeN66RsiUBCKDCuLcXaIUOctrG8WTCjEwgJngXVGn
         Mml8YfwIFTYHOJbx6McEHlVqRUwkcpoNbjf0G1FcfxeKoMU43aHKxgx3IYNasIznozau
         eWsfRSHcaPAtEeVhpJTfs7WqRiu7tzIzY2bhel28rQG0KKQ039eutWnGlNI5Ir8fg+64
         zRuzue/dg6kjgVDJZJBAhtL6vltRf02h4jcympZOGzVIrxcAiGrW0IHStrnbaltYIxJY
         h0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2Js2iHBO2bZVfNMqUVey3hZaIS7yAI9P1HePKZNMPjA=;
        b=sO3UYQEPTq6b33lWTmpTLFS9X8y+bKwKtagIxsVJlB2SHho0arqVAclcYxtl9ymTfn
         hnSRmaSNRFBTImWNdjMTuOEWZXEA3MBRvWHoPubCwwGJj3SLSAos+lI+2M8nbSweoyoJ
         oIM3sDrRTItr71rUW4XAi6Z9/PXJA8C4Ug31uvY9nd0B4MC9d9NdFgbwqm7WkciG/WzQ
         VQFNxdC+mkyn2VHYx29lA/qdJvaG5SB3bE7HFiUPA25ZlUkEdhxHEsZUZ0ClXr32dqCU
         ShGGUKP75g0kdfaQr70FDNUG7xl/6TlOFZhyjklNJJF1xB+gID+xF5flO70zEWx4l9uG
         5c1g==
X-Gm-Message-State: AOAM533mAg/x8wMH3yupTMNr9h+F9ou1Esyogo6axzLiFJZvvZ9Q0QlS
        68IfNoQIfP0hfggOIrnj7vOeh4cM+C/dHg==
X-Google-Smtp-Source: ABdhPJzVZ+TP2/CXOW9X27brrp2kSoZ7P1RxWqUT/XC+pIhpI+apST8WXWlgTXn/BrCtbSo7L3BMTH6FBf2RYg==
X-Received: from tlingit.sea.corp.google.com ([2620:15c:17:3:48cc:d46b:ea6d:e005])
 (user=sterritt job=sendgmr) by 2002:a17:90b:4b04:: with SMTP id
 lx4mr5844564pjb.11.1637201630693; Wed, 17 Nov 2021 18:13:50 -0800 (PST)
Date:   Wed, 17 Nov 2021 18:13:26 -0800
Message-Id: <20211118021326.4134850-1-sterritt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH] Fix SEV-ES INS/OUTS instructions for word, dword, and qword.
From:   Michael Sterritt <sterritt@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-coco@lists.linux.dev
Cc:     marcorr@google.com, pgonda@google.com,
        Michael Sterritt <sterritt@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Properly type the operands being passed to __put_user()/__get_user().
Otherwise, these routines truncate data for dependent instructions
(e.g., INSW) and only read/write one byte.

Tested: Tested by sending a string with `REP OUTSW` to a port and then
reading it back in with `REP INSW` on the same port. Previous behavior
was to only send and receive the first char of the size. For example,
word operations for "abcd" would only read/write "ac". With change, the
full string is now written and read back.

Signed-off-by: Michael Sterritt <sterritt@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/sev.c | 57 +++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 74f0ec955384..a9fc2ac7a8bd 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -294,11 +294,6 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
 				   char *dst, char *buf, size_t size)
 {
 	unsigned long error_code = X86_PF_PROT | X86_PF_WRITE;
-	char __user *target = (char __user *)dst;
-	u64 d8;
-	u32 d4;
-	u16 d2;
-	u8  d1;
 
 	/*
 	 * This function uses __put_user() independent of whether kernel or user
@@ -320,26 +315,42 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
 	 * instructions here would cause infinite nesting.
 	 */
 	switch (size) {
-	case 1:
+	case 1: {
+		u8 d1;
+		u8 __user *target = (u8 __user *)dst;
+
 		memcpy(&d1, buf, 1);
 		if (__put_user(d1, target))
 			goto fault;
 		break;
-	case 2:
+	}
+	case 2: {
+		u16 d2;
+		u16 __user *target = (u16 __user *)dst;
+
 		memcpy(&d2, buf, 2);
 		if (__put_user(d2, target))
 			goto fault;
 		break;
-	case 4:
+	}
+	case 4: {
+		u32 d4;
+		u32 __user *target = (u32 __user *)dst;
+
 		memcpy(&d4, buf, 4);
 		if (__put_user(d4, target))
 			goto fault;
 		break;
-	case 8:
+	}
+	case 8: {
+		u64 d8;
+		u64 __user *target = (u64 __user *)dst;
+
 		memcpy(&d8, buf, 8);
 		if (__put_user(d8, target))
 			goto fault;
 		break;
+	}
 	default:
 		WARN_ONCE(1, "%s: Invalid size: %zu\n", __func__, size);
 		return ES_UNSUPPORTED;
@@ -362,11 +373,6 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 				  char *src, char *buf, size_t size)
 {
 	unsigned long error_code = X86_PF_PROT;
-	char __user *s = (char __user *)src;
-	u64 d8;
-	u32 d4;
-	u16 d2;
-	u8  d1;
 
 	/*
 	 * This function uses __get_user() independent of whether kernel or user
@@ -388,26 +394,41 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 	 * instructions here would cause infinite nesting.
 	 */
 	switch (size) {
-	case 1:
+	case 1: {
+		u8 d1;
+		u8 __user *s = (u8 __user *)src;
+
 		if (__get_user(d1, s))
 			goto fault;
 		memcpy(buf, &d1, 1);
 		break;
-	case 2:
+	}
+	case 2: {
+		u16 d2;
+		u16 __user *s = (u16 __user *)src;
+
 		if (__get_user(d2, s))
 			goto fault;
 		memcpy(buf, &d2, 2);
 		break;
-	case 4:
+	}
+	case 4: {
+		u32 d4;
+		u32 __user *s = (u32 __user *)src;
+
 		if (__get_user(d4, s))
 			goto fault;
 		memcpy(buf, &d4, 4);
 		break;
-	case 8:
+	}
+	case 8: {
+		u64 d8;
+		u64 __user *s = (u64 __user *)src;
 		if (__get_user(d8, s))
 			goto fault;
 		memcpy(buf, &d8, 8);
 		break;
+	}
 	default:
 		WARN_ONCE(1, "%s: Invalid size: %zu\n", __func__, size);
 		return ES_UNSUPPORTED;
-- 
2.34.0.rc2.393.gf8c9666880-goog

