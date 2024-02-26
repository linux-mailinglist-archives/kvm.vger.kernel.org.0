Return-Path: <kvm+bounces-9935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E55B86795F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C71D52938A9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100571534F7;
	Mon, 26 Feb 2024 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HOfXGjYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420B12FF65;
	Mon, 26 Feb 2024 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958399; cv=none; b=KZxBri8jwVB/w9hmAobU+3kD2jkM6s+ycl0R3QZC4FJgkzZ9I2qDv3wH3eMmcfey+guXdYY9dE7MDcAxjtO8wKbxeFk84bIzt5FpcRYb+KSNe/m2iKbnO8Iybi4K5I41xJ7sgS1EFC1yh++T+PrxuglmR9wBmMSgbRNKAi1OEJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958399; c=relaxed/simple;
	bh=iXEXISMa0LFDWwH0oSNq32/ssO3bNLLFAadmTz0LNz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bvD6JkBNQiJYrNtEAUqE1OhILjasB96j+e08Qyk4pjlQr1ouDG98pHbk65wKgcPN4KmTQjLiJgIKXzbjysMmNoWzu5PkKGC76qKGGUzqqujQTFWOYByb4JsiJ83jxUfgyLYbH2mta4COuuiAuh4e0xBKsU2fBv1zs48cNSx52II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HOfXGjYW; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dbd32cff0bso22045055ad.0;
        Mon, 26 Feb 2024 06:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958397; x=1709563197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozpAnnPH2LU7+faQB5EOaaa/mJ5DT/kXmcQ3UpGuV/k=;
        b=HOfXGjYWTP6tnBFHUQ73Ws43EeJxrZM8JckujZksQcaGxSPCpGbD4+qbmIFYy60IRI
         KmHoGfosvlLlVB0FPXastSR2S6V+ufyaJ9AKUKD4H4Y61Q5Fnyez/FEhSOsfAjW0xzsa
         VmBdwtwVdj2P3gKTVliH3wC8g9MTn3xANfDA2WJ8YTre5EOteItxX1ZUQyVn6c61PyXP
         9/60w6bHUrWmhTceE2pb2oV1G0DdQ0pQFhS8Wm/lMdBwFljermGdWB6DepFpc4VndcSN
         739AFGHwcshPFIWkceqf9lpoqDg0sLZZ/ZYzRxkpcS67vp29cjIVugfhgeOGpm+stHSQ
         RxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958397; x=1709563197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ozpAnnPH2LU7+faQB5EOaaa/mJ5DT/kXmcQ3UpGuV/k=;
        b=NcmIwCMSU2BQ5S6t6tzH9/yxkp86AcoEzQ2F4yw87XHX/Z+Jtdg2MHIDdUbncMGBRt
         H/xQ4QQ6JsNxzcKZm4YXTRdPP7ur5DCwXbnAMJwfatZFraMLfoezjQ6tv+VSnHZJTc3v
         bH99jfPNhKvuBplJ3y6PsIyBKzbTkw93KyPxmUxxOp3xyE7A7FGwoyXGOAgUaBgtQr1b
         ol94Sffx8/ip3X3+0EMzgYsTyikb+D/JBpJoVTs8nYHugPn+JdHcgqleU+1v3vtUZgNt
         VpwXC2J0KlznPBBXcTm1Yl+AOF1xs2erRaLi1kb6qJVzrvfZ5Lqjlh+nU9PaHZKiAEv/
         clTA==
X-Forwarded-Encrypted: i=1; AJvYcCVQCK2hXqxYk4PXrvrafKlPa62AUBnmFPMaqlhBk+8m7ASPOnNDdJg0zfLC56mIC4TFMk2pIjdUq4XPrGPAQQ7PqQFq
X-Gm-Message-State: AOJu0YxLlaSBrXAs7mMlXZLMLZhTg9e6lV6njNdIKVp8w2wxiC3j9Gdo
	mewRL5icQGokoMqd79rsqlSt9ZScaN+Ahpq88ZtLc0YJYPiKu25hz4FOFUSQ
X-Google-Smtp-Source: AGHT+IHum+mxS4FQWGohuWSxE1bsdYayCIrR4AxVpGaAxnRumWchRbzfaDoIjobdQIcpfnlAdJSBZA==
X-Received: by 2002:a17:902:d2c2:b0:1db:e7a4:90a8 with SMTP id n2-20020a170902d2c200b001dbe7a490a8mr7447890plc.10.1708958397036;
        Mon, 26 Feb 2024 06:39:57 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id v17-20020a170902d09100b001dc11f90512sm3424456plv.126.2024.02.26.06.39.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:56 -0800 (PST)
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
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Fangrui Song <maskray@google.com>,
	Willy Tarreau <w@1wt.eu>,
	Thomas Garnier <thgarnie@chromium.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Xin Li <xin3.li@intel.com>
Subject: [RFC PATCH 72/73] x86/pvm: Use RDTSCP as default in vdso_read_cpunode()
Date: Mon, 26 Feb 2024 22:36:29 +0800
Message-Id: <20240226143630.33643-73-jiangshanlai@gmail.com>
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

The CPUNODE description of the guest cannot be installed into the host's
GDT, as this index is also used for the host to retrieve the current CPU
in paranoid entry. As a result, LSL in vdso_read_cpunode() does not work
correctly for the PVM guest. To address this issue, use RDTSCP as the
default in vdso_read_cpunode(), as it is supported by the hypervisor.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/alternative.h | 14 ++++++++++++++
 arch/x86/include/asm/segment.h     | 14 ++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index cf4b236b47a3..caebb49c5d61 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -299,6 +299,20 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm_inline volatile (ALTERNATIVE(oldinstr, newinstr, ft_flags)	\
 		: output : "i" (0), ## input)
 
+/*
+ * This is similar to alternative_io. But it has two features and
+ * respective instructions.
+ *
+ * If CPU has feature2, newinstr2 is used.
+ * Otherwise, if CPU has feature1, newinstr1 is used.
+ * Otherwise, oldinstr is used.
+ */
+#define alternative_io_2(oldinstr, newinstr1, ft_flags1, newinstr2,	     \
+			 ft_flags2, output, input...)			     \
+	asm_inline volatile (ALTERNATIVE_2(oldinstr, newinstr1, ft_flags1,   \
+		newinstr2, ft_flags2)					     \
+		: output : "i" (0), ## input)
+
 /* Like alternative_io, but for replacing a direct call with another one. */
 #define alternative_call(oldfunc, newfunc, ft_flags, output, input...)	\
 	asm_inline volatile (ALTERNATIVE("call %P[old]", "call %P[new]", ft_flags) \
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 9d6411c65920..555966922e8f 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -253,11 +253,17 @@ static inline void vdso_read_cpunode(unsigned *cpu, unsigned *node)
 	 * hoisting it out of the calling function.
 	 *
 	 * If RDPID is available, use it.
+	 *
+	 * If it is PVM guest and RDPID is not available, use RDTSCP.
 	 */
-	alternative_io ("lsl %[seg],%[p]",
-			".byte 0xf3,0x0f,0xc7,0xf8", /* RDPID %eax/rax */
-			X86_FEATURE_RDPID,
-			[p] "=a" (p), [seg] "r" (__CPUNODE_SEG));
+	alternative_io_2("lsl %[seg],%[p]",
+			 ".byte 0x0f,0x01,0xf9\n\t" /* RDTSCP %eax:%edx, %ecx */
+			 "mov %%ecx,%%eax\n\t",
+			 X86_FEATURE_KVM_PVM_GUEST,
+			 ".byte 0xf3,0x0f,0xc7,0xf8", /* RDPID %eax/rax */
+			 X86_FEATURE_RDPID,
+			 [p] "=a" (p), [seg] "r" (__CPUNODE_SEG)
+			 : "cx", "dx");
 
 	if (cpu)
 		*cpu = (p & VDSO_CPUNODE_MASK);
-- 
2.19.1.6.gb485710b


