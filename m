Return-Path: <kvm+bounces-9891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A688678ED
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:47:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A17811C255F6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2345F135402;
	Mon, 26 Feb 2024 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqaCwwb5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5C91350F6;
	Mon, 26 Feb 2024 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958171; cv=none; b=LJzv5AYaJ3+PbAxwo3gfesIJKzgJDP01XD5bkyIYhQq3T4XhaxSizcyEm3K2HcmxYDePe4OtmOGDIMvNo6oa/iv7QLD+IWRN1uOZEUZaMU5Vodb6PiVQISCTdu2160p2Tv2M2K5tJPdEs+RQP9jP9sfFyMyqXuh4b8smtJYskn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958171; c=relaxed/simple;
	bh=S9RepT6PoqM2S+OMOYJJ6Pjp/uzBUojYH/rcTDukdCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qWYNDgFSiQiMjWAIAY3VzgkNi1hLIxX6nuduNnlerujGwjlTZMZuWg/lTizTvRNCgqEUY4tzIIXaMi3k0r9/A/9OuEs/xuZxLj7fjYrycLBErDsuaoxJWWQZEYeVCvB5VG+eBocbWpUrCRscldZhdu9QSoC/FzoJvKU3M7K24YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mqaCwwb5; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso827390b3a.2;
        Mon, 26 Feb 2024 06:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958169; x=1709562969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yal7PqZq3fB2N6wNdWSs550cQCs0YFhnt+trBoKCwic=;
        b=mqaCwwb5Zz1bN5TZhSCrivH4/roxBTSRSkWnKuPEmibM1bBYQLNLc55TbYpTktPSj2
         4EYZ63zJ/vig54AOwqmAK9uwKPw7KeEs3NnxFZfp91cfgkBuSzBUUR3WFAdWVz0RD3yj
         +PVv5N+O1aoBWYgLVM8e/5KwfO8quJ2iMhcXdwsIh8PNpkPm4/MEjNH8nlTqpvbM7Lfk
         bScgKGAOH6h1LkRNF+enS8LIfrOTCg0JMMcJnTD/HKDV7UrXEz43tPKTa5MRvtlFhPvi
         gwk6JNt+kUnHk/xlndOMNMjCkKFQifA513I3baCkKqo4VpxFNeqHQR8UZAUIPOcoGqo8
         YcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958169; x=1709562969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yal7PqZq3fB2N6wNdWSs550cQCs0YFhnt+trBoKCwic=;
        b=TQU6AOUeilZNPVH0zwq0IhM/1MFdu5ExqE7earjqHJH5ZCHpshxE9/5b3xpr238+UX
         5oVmG465D2DuP2uLzd9YO2HLMYqYgnhU9I0sHsd/yhr8679zTtiHi9CiHdNjStZSintm
         vlxfRh8OUIPsYQogxR63jAH4IJhwzR88i29RUDi08ADA2qS3kAYG0O0+GiMbxCS3iR5Q
         9do6YWPNrBsOOrCaU8Zawh0XuKj+b9CC6s8DGFsHzl9Lx+Vp8LFprv1B6ld6G0gD/hV4
         MDgkM7jhqk4vjsMnQLsQcBuzsk7sV2ors6oYXmague2O/xzxi4y/iWdRusxdnQsL4a4J
         qGBg==
X-Forwarded-Encrypted: i=1; AJvYcCU116GiRuihyfzo+QKBvt1ooeBbt40+UhLyDMq1jnz52mzzeSVnal+GPVA4bt5YXpf8ebGnhnCQkzFk6f8It8RMxVXx
X-Gm-Message-State: AOJu0YzA5LsMQGMS/7BahaV4PCmkXkKjcOIDx0S/2Wjye3gK7+wkesF8
	65rsMesRX7ExhOHCOgTJ48Wl4bwgLsO7qL1oB7hFp/LR9uEsywLrO7m2td1s
X-Google-Smtp-Source: AGHT+IHB4Cu1aKHNfPZa42dZ40xlkovy8vQGKuBOn8Bof5eHWznKUcKJ+HGxXyIylbQxXjd/SAnndQ==
X-Received: by 2002:a62:be06:0:b0:6e5:d7:e27a with SMTP id l6-20020a62be06000000b006e500d7e27amr4502659pff.5.1708958169213;
        Mon, 26 Feb 2024 06:36:09 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id y10-20020a62f24a000000b006e467935c58sm4033353pfl.89.2024.02.26.06.36.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:08 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
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
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 28/73] KVM: x86/PVM: Handle syscall from user mode
Date: Mon, 26 Feb 2024 22:35:45 +0800
Message-Id: <20240226143630.33643-29-jiangshanlai@gmail.com>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Similar to the vector event from user mode, the syscall event from user
mode follows the PVM event delivery ABI. Additionally, the 32-bit user
mode can only use "INT 0x80" for syscall.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 57d987903791..92eef226df28 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -915,6 +915,15 @@ static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
 
+static int handle_exit_syscall(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	if (!is_smod(pvm))
+		return do_pvm_user_event(vcpu, PVM_SYSCALL_VECTOR, false, 0);
+	return 1;
+}
+
 static int handle_exit_external_interrupt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.irq_exits;
@@ -939,7 +948,11 @@ static int pvm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 	u32 exit_reason = pvm->exit_vector;
 
-	if (exit_reason >= FIRST_EXTERNAL_VECTOR && exit_reason < NR_VECTORS)
+	if (exit_reason == PVM_SYSCALL_VECTOR)
+		return handle_exit_syscall(vcpu);
+	else if (exit_reason == IA32_SYSCALL_VECTOR)
+		return do_pvm_event(vcpu, IA32_SYSCALL_VECTOR, false, 0);
+	else if (exit_reason >= FIRST_EXTERNAL_VECTOR && exit_reason < NR_VECTORS)
 		return handle_exit_external_interrupt(vcpu);
 	else if (exit_reason == PVM_FAILED_VMENTRY_VECTOR)
 		return handle_exit_failed_vmentry(vcpu);
-- 
2.19.1.6.gb485710b


