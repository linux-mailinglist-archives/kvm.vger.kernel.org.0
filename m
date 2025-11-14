Return-Path: <kvm+bounces-63267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F5F9C5F494
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9B60C4E80C7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947AB342536;
	Fri, 14 Nov 2025 20:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mbkuwmh0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550162FFF90
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153486; cv=none; b=pUXNhbQKpwtykAQYTabgG5azGqXe9Ndrr4FyEw0AebGbcSf2gaQusU0cfL6cL/XmqhijOIWZhPwIJcvLgHlyaInDiIHLhOVgfqMk7jSyom4elvYxz2t+I74aQw4rI8TuiAN0C5XDsPIYPzZr/JSxNryac++/5xBAqY/upUo01aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153486; c=relaxed/simple;
	bh=WysjQid0dpRvPUHrUw6lwlufaXmPUfAbB8W5ZohMxeI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OP+zMGn8IFEN7axJBp9AzgR8qYrtoXeQe3tc8ISQRjAOwwGGlTpI+9Jl8bxuZadCCvvxx37FdOI/gSWN6y24UaiK8F1G/5WWufCpONCBlYU0gITwVbK/0eDzin4QXw7ZOoAcpCA4aVyR/mdAPXABv0el9IqLUcKcpzzGHXNmeOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mbkuwmh0; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958a134514so31588125ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153485; x=1763758285; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YF9eC/iY/nwKua27LhErZzKqqd0ed5ejtLtiGfXzPUk=;
        b=Mbkuwmh0VKfWiZqrerPCoTnP1xOi5/GHFzGlcqtuIABGGyfGveuMpEpTKL86hmMNkc
         gDCSkAtT7C2v3ulXq9hhtymoxZD7dhk4+Nf/89NOWqNfZlU8MN3763Fkjx32BPiLsEah
         9IeyrpGHAY6s1nWiO0MblfteQhmUj/kq3BvjaNwTC7sz+nQ8O/MXge5yLu/W0XTPK+5F
         5YJIFSvW59c0jjU2Zf0ZsN3OrH+hsTTconkgiuVh8BAhpSgGo2Q0gq3VFYJ/QXKzADwn
         tdxts0/EFPheseJjTcZCFIEzAaauTXrGI6kWnfHlBgJxO97yMa2zNQjHYHBSO9WxOrvB
         tTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153485; x=1763758285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YF9eC/iY/nwKua27LhErZzKqqd0ed5ejtLtiGfXzPUk=;
        b=ewHSOVmiUHu7cnBwnrMh1cxpNDKYO7LEy7gvws9cLeCzgL8ady5TtgfHhMwqwlghxZ
         r8Z4hlCN7BAOvON8hU1Tpvo97hqriCx3kX1LNFVmtkfhPJQTOajZeDSBBbrg2I956DeJ
         H44T7SuM20MY+1F72QFaX8mB+z0yY/B6m2/GJzDsfz4vppdF7HB0qxtEvO+pIWYPgAgB
         ejKQyfNE2EYvqDkIK2z+VVACxBWHmpjVJtPwbxtJko2D8QpOR97oRpXYYM2WSXPmhHk6
         6F/bcKPmHjxaat/FQdJfSQLu7h3f/3ZLbT9rnazgr6q4eA23yHzU4UBstlM1c5F9fwQn
         Jyow==
X-Gm-Message-State: AOJu0Yyx9sVDvNNxbDYhL/M7+L2YPl6mpa+Wke+Qr2N6VUW5qXDfd/XR
	cAiFH2LluAW1xjSqAvfp1E60GEYhHM00ggtKFK8j4eYIvjzCdrgMnZZHzqeU3E9j2vkQsiQuuIk
	SttsvXg==
X-Google-Smtp-Source: AGHT+IHxswTiHH6uIlkaiKjFLU/0Kkm4yqHsx0oW7loto62QVVwaWkmBknb9JfYXKZAyhkKbR+7huOdlx8g=
X-Received: from plap9.prod.google.com ([2002:a17:902:f089:b0:25f:48ba:97e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2406:b0:295:24ab:fb06
 with SMTP id d9443c01a7336-2986a6ceb22mr49669095ad.22.1763153484718; Fri, 14
 Nov 2025 12:51:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:53 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-12-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 11/18] x86: cet: Use symbolic values for the
 #CP error codes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

Use symbolic names for the #CP exception error codes.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index a1643c83..f19ceb22 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -47,6 +47,13 @@ static uint64_t cet_ibt_func(void)
 	return 0;
 }
 
+#define CP_ERR_NEAR_RET	0x0001
+#define CP_ERR_FAR_RET	0x0002
+#define CP_ERR_ENDBR	0x0003
+#define CP_ERR_RSTORSSP	0x0004
+#define CP_ERR_SETSSBSY	0x0005
+#define CP_ERR_ENCL		BIT(15)
+
 #define ENABLE_SHSTK_BIT 0x1
 #define ENABLE_IBT_BIT   0x4
 
@@ -92,15 +99,17 @@ int main(int ac, char **av)
 	/* Enable CET master control bit in CR4. */
 	write_cr4(read_cr4() | X86_CR4_CET);
 
-	printf("Unit test for CET user mode...\n");
+	printf("Unit tests for CET user mode...\n");
 	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
+	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
+	       "NEAR RET shadow-stack protection test");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
 	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
+	report(rvc && exception_error_code() == CP_ERR_ENDBR,
+	       "Indirect-branch tracking test");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.52.0.rc1.455.g30608eb744-goog


