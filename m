Return-Path: <kvm+bounces-9882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F4088678E1
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:45:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7141BB2B697
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317C8132475;
	Mon, 26 Feb 2024 14:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="frsiMweg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1042112BF0D;
	Mon, 26 Feb 2024 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958142; cv=none; b=MYu2Tq/wVe7njJ2s+l+92QTypwi+BlckuAsiWoOt+DdiMJm/H5UYJsqUQzS+0qR45iidpwyB6Ff+bDeCHF+97qYBCDUgRk/Wj0T6292KBH6F4nMzoMnilTNIdtCxoSsBpXlIxmm6DNBnbn9yVJTW6JZ+m316ZYM2QeQsFczZFZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958142; c=relaxed/simple;
	bh=lkPWWNX4CqvxkABoFnNNUXtgtU86hs8RqI86OHed6gI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sqx+QlnwCliJHknl4xR9xEQYOQdsoFZ2lmH4/EJ39JDyBDD37wVCQJfL3r38gtMPqfzdlt8cDqE1Dw8qp/I7LO9Hm15AQp2oPu64rFqkWRTZ9lsoRbhiZHn5z/sDGu+3Be+XKvrRE40FwfTCAuvj/7kHtmeqexzMAqOdvZJmV6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=frsiMweg; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e08dd0fa0bso2686770b3a.1;
        Mon, 26 Feb 2024 06:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958140; x=1709562940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTFwRy/j+hGc3A0+vUN+d8c3IFpFYgzuXEpZOKFIa18=;
        b=frsiMwegqR48pYel71xccNr85n9qEBuLXgiIKvX3g4Qe1slOER1yHJqjC9SckgQaWT
         vhzCB8i6CsSNNy+crzUY4uZPRyENqpj1rpmWR0zPAin1UjnPn8qOY6rRMyw0ztXtyI/j
         lCXYVrf/A512sv5D4SIH6hNs/664YoFGBdQylFiAeVtc5wH441hCE5GpB2mdfvVkU9Un
         I8wgYinQXtCba4K0EU8vH3AG5WLqj7BDTZ1bhHNh5PU6+HzZW1YsTw7NsaSOIv9cuimH
         ddNp+e31ZepvBe/7EpPU/GyEr218qjtWFjlD3Ak2scQ6hW2lt7je2aA7KvGxezsnFB4z
         Yccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958140; x=1709562940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BTFwRy/j+hGc3A0+vUN+d8c3IFpFYgzuXEpZOKFIa18=;
        b=WjmZVmyb9NGyPQfE7/VOXmcCf78j+xqOIK7LBxh2oF45xeAeXN4UCyYjHIjtNNvwSc
         9rbsexLRCP0/8yE4yranYfezkDEBXJjivDwRkPGBQPvO2tn8ePhP36b6pGixGAaFv7Ig
         IF85vhnXG23rfr4t57oSGQBlfqZISH0ykAL+/5pN6sJJf5si0R/lSa8JOV+Pw+sZqjke
         mrcRCchy+iJBHUNcRsLOTbed6NIV2jxpXG7+asunrnjyIkCCCvJFhfxGklWjiQ5smETF
         3BQJGXtLcT9Pyh9babVEeN/DNg6FTlPXyVMkl4f9LFSzmYggz/CgIW5xIkiApUJ2h8/8
         2NIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPOIWkmpUNIIo2ysfq9HJRy50EMEfv6ZAORRBZGcgtiCJH2uft+DRvolvDWzxbkQnHyLFoUORHdKLWAGXN+K8gBIae
X-Gm-Message-State: AOJu0YzDQayBtbZihwVKz+ZWF1aN5lRgmXEB6aUGl2H6VuxYBEqi23NB
	Hv2cQIOTJiDHjTEPjKdlWCiGe7ro0/SMqA5reYFIpQlO4jrTQMKgKR8ke57M
X-Google-Smtp-Source: AGHT+IFkQAeotaJC6rOlB/07QXBxTvhlQ1Y2T2xm7Tl42zr/8ZXRkxT+6oQYkxerVjcTQcp6MLzzeQ==
X-Received: by 2002:a05:6a21:1014:b0:1a0:e6c6:fa with SMTP id nk20-20020a056a21101400b001a0e6c600famr9611214pzb.7.1708958140321;
        Mon, 26 Feb 2024 06:35:40 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id x64-20020a626343000000b006e501303f1fsm3433320pfb.40.2024.02.26.06.35.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:40 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 19/73] x86/entry: Export 32-bit ignore syscall entry and __ia32_enabled variable
Date: Mon, 26 Feb 2024 22:35:36 +0800
Message-Id: <20240226143630.33643-20-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

For PVM hypervisor, it ignores 32-bit syscall for guest currenlty.
Therefore, export 32-bit ignore syscall entry and __ia32_enabled
variable for PVM module.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/entry/common.c   | 1 +
 arch/x86/entry/entry_64.S | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 6356060caaf3..00ff701aa1be 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -141,6 +141,7 @@ static __always_inline int syscall_32_enter(struct pt_regs *regs)
 
 #ifdef CONFIG_IA32_EMULATION
 bool __ia32_enabled __ro_after_init = !IS_ENABLED(CONFIG_IA32_EMULATION_DEFAULT_DISABLED);
+EXPORT_SYMBOL_GPL(__ia32_enabled);
 
 static int ia32_emulation_override_cmdline(char *arg)
 {
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 65bfebebeab6..5b25ea4a16ae 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1527,6 +1527,7 @@ SYM_CODE_START(entry_SYSCALL32_ignore)
 	mov	$-ENOSYS, %eax
 	sysretl
 SYM_CODE_END(entry_SYSCALL32_ignore)
+EXPORT_SYMBOL_GPL(entry_SYSCALL32_ignore)
 
 .pushsection .text, "ax"
 	__FUNC_ALIGN
-- 
2.19.1.6.gb485710b


