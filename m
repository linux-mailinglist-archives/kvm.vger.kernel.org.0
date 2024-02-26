Return-Path: <kvm+bounces-9933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E6A86795A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBDFB28DB49
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1C714F9EA;
	Mon, 26 Feb 2024 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AW4B7y+r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5414F99A;
	Mon, 26 Feb 2024 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958388; cv=none; b=Xtt9UbHpH6P/p4wOwKgkeCFWkrmr1ejVFlabPwgL4Y9Is6R1f0X2Rbdxmf8Zly9c1c45mmXKsTTMD26yEwMsVvJMP/VkBpx0Xw7c+34GooGpy9x/DlmyljwnR6Vnrl6t63s7b8LpQDDinC/7wAdWANts93BxslQcNbTnc5LHGh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958388; c=relaxed/simple;
	bh=pVj+O/nc8ZTcYQP0Pc8FIf1e7FsTCb44SoV4NEs/Y14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C1pjGSqrARbMeo95uO18j1GSKPOkwJZ8uECl1Dw/BSrsvzm9TMlRYCfLH13oJP2Yv5LRaRBeraznBOtir3LcoZpBFSTKVOnVcKVW/PRSkgHpTbuO+AGC5g4PsmIBBAM7kA5aZLTqWuhgp4Bk+40p+vsNsxLEls1F14Vqhtxp0xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AW4B7y+r; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dc139ed11fso20145375ad.0;
        Mon, 26 Feb 2024 06:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958386; x=1709563186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QI/Y1kNMrQvMG7JUt6H0OqHjkXiCz72P215jqTcUcU=;
        b=AW4B7y+rghpeQAyzXcXbndgLtRl7Xk0kB94Rrs2BoPDJssOJFonAJtAF2sGkbkrI8B
         Y7LMbnnGWOdUMtDOQQXnV3lNGHf9EJtTJIBWXaGMWr3Ao+gVAsPlk0xqKkKCmn2S71gX
         dJlPKwaPXre+Ac9lBn+Zk3p6D4jWzSqoS8CtUolqR+1zRKqQ+p7okihu4PbbsMR4sGXT
         qDifUEWK53SwSwxIhPbt5iSrC2pw7ymVPWJjlik+Ef89MzW5v9I5vyl6MNqEromADrV4
         Y7mcYyjqdiOkm9LxvugUidtd/lCUXE1J+bgl6vOzzpjmW6fyWJknJELc9BTkET3IjItD
         xvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958386; x=1709563186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9QI/Y1kNMrQvMG7JUt6H0OqHjkXiCz72P215jqTcUcU=;
        b=JzRpcs8o90som9KMzub/eUKa+APJsLvrbq2WYjBHYuYnAz4XWoZ8yxk6hVaGu7WjCt
         L/3E00LlgqFDpaG1OcNTbAJIikMtuQ2vj8JkGFEdyHYOfqNv1PH7qL3/gVXbvB55SzK6
         UZB3BDhE90dgRU5A4zZ9kas8pBfqoyUQQfpGgOmhEnS3Na8F0LW55rIf5PIrq7J/X3tL
         FbnHEkkzcQ+DTIYHFMJjEOx31mZAv90AzrFDe8DOq6L71vOhyQEiqdt0Ny9dJpzjbQlo
         xmbpIFuo6VHfD6utL3EMkE00l6TIpZNK+rdQYiDTUpp3BSiyesZaycLkrFY01B8hLQAL
         ontQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4VZCyjBJkJJZJmxn6potz7Y4rvMe/78tgwhtJNCTHnjD1vty7UcKSlem25E7Drl6YunslDCxFQo+lejv990+wR5qy
X-Gm-Message-State: AOJu0YxnTF1cfeTA1KEuOSAMTjmLxCt/oVBxX2PsM7A8UQcc5KH5h6V9
	ikKFXVdDZLsDX8u1+EoMHm3tp2T15ZszClW8HV95qVvjDeBZQfhAasBPbnSf
X-Google-Smtp-Source: AGHT+IHy8ONH+IR/CrprMSlLNr66EQ8UbtExowfbbOUGEyBdvChuDg4mhNFNKU725s1aIh6O+0Jq+w==
X-Received: by 2002:a17:902:e806:b0:1dc:6e06:7685 with SMTP id u6-20020a170902e80600b001dc6e067685mr9416736plg.29.1708958386631;
        Mon, 26 Feb 2024 06:39:46 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902fe0c00b001dc91b4081dsm2841692plj.271.2024.02.26.06.39.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:46 -0800 (PST)
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
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 70/73] x86/pvm: Don't use SWAPGS for gsbase read/write
Date: Mon, 26 Feb 2024 22:36:27 +0800
Message-Id: <20240226143630.33643-71-jiangshanlai@gmail.com>
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

On PVM guest, SWAPGS doesn't work. So let __rdgsbase_inactive() and
__wrgsbase_inactive() to use rdmsrl()/wrmsrl() on PVM guest.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kernel/process_64.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 33b268747bb7..9a56bcef515e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -157,7 +157,7 @@ enum which_selector {
  * traced or probed than any access to a per CPU variable happens with
  * the wrong GS.
  *
- * It is not used on Xen paravirt. When paravirt support is needed, it
+ * It is not used on Xen/PVM paravirt. When paravirt support is needed, it
  * needs to be renamed with native_ prefix.
  */
 static noinstr unsigned long __rdgsbase_inactive(void)
@@ -166,7 +166,8 @@ static noinstr unsigned long __rdgsbase_inactive(void)
 
 	lockdep_assert_irqs_disabled();
 
-	if (!cpu_feature_enabled(X86_FEATURE_XENPV)) {
+	if (!cpu_feature_enabled(X86_FEATURE_XENPV) &&
+	    !cpu_feature_enabled(X86_FEATURE_KVM_PVM_GUEST)) {
 		native_swapgs();
 		gsbase = rdgsbase();
 		native_swapgs();
@@ -184,14 +185,15 @@ static noinstr unsigned long __rdgsbase_inactive(void)
  * traced or probed than any access to a per CPU variable happens with
  * the wrong GS.
  *
- * It is not used on Xen paravirt. When paravirt support is needed, it
+ * It is not used on Xen/PVM paravirt. When paravirt support is needed, it
  * needs to be renamed with native_ prefix.
  */
 static noinstr void __wrgsbase_inactive(unsigned long gsbase)
 {
 	lockdep_assert_irqs_disabled();
 
-	if (!cpu_feature_enabled(X86_FEATURE_XENPV)) {
+	if (!cpu_feature_enabled(X86_FEATURE_XENPV) &&
+	    !cpu_feature_enabled(X86_FEATURE_KVM_PVM_GUEST)) {
 		native_swapgs();
 		wrgsbase(gsbase);
 		native_swapgs();
-- 
2.19.1.6.gb485710b


