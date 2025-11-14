Return-Path: <kvm+bounces-63138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1C5C5ABA9
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 716B34E5F7E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F7621CC71;
	Fri, 14 Nov 2025 00:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vu2IkFp8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0900823370F
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079203; cv=none; b=rj+z95aRv3kQdPrAYqZkYsZvW6u7UXhxUkFNFghvPdcAkYbvaUrqVOkZUIB5U5mLBCx230Gh9Yq/UsO7yN9rESuHNEAkFzw9ofhddYAQ28XhcppWtvbqz7Bsh3Bl0eK5RCAkG3wwTmCyncvxSY6RG2eMnwh1phP/w4z25JOm9n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079203; c=relaxed/simple;
	bh=WysjQid0dpRvPUHrUw6lwlufaXmPUfAbB8W5ZohMxeI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mpfZWrlMpvLQhtlASVGuskE75jhAuzbahgUAIS00RLXRCi2ozR6CtjP9QBhSHqNt2gUOlBJOoOfMheK/VRQ33YASa8KGOwXAB54v0W18hmaOPu9WK6K2UbaqSbRMQOE5B64/fZezEWGwneknS7qdzqMglHmCR9+hWiHzjjmTd9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vu2IkFp8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso1770839a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079201; x=1763684001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YF9eC/iY/nwKua27LhErZzKqqd0ed5ejtLtiGfXzPUk=;
        b=vu2IkFp86PopFRtbFQTuM0CwkDYLly4OGR86qURI24xnjE2yvYoTd/qDVdLoSfX4cd
         aAbjybazVg4mYIxwu+oK9JdHc/ZklFlS7SrS0GcHiM5EPJdU/cZoLzRHyKdY7ZxZGs4o
         SnBNZ8bgNPpgHgxwoa2EZRj9LHXPfkJ11a0rv1D17VanfZgio44LCp0R9xHwzFcdl+Sw
         t7VFmJD2Pr4u5pfJ7YSOU4GeMazb2eAV1KYuuzkoP2yF9DCY8u2fC2bDZfTQz5AQ/qoY
         SWK6x4j7pj/UsPfpFiuevdTPtN7xIqtsnAxYPF9cuHF+FTNOIgjncQSGTQ+O/jItYCBH
         +q2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079201; x=1763684001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YF9eC/iY/nwKua27LhErZzKqqd0ed5ejtLtiGfXzPUk=;
        b=nfK6VUFSw5HTssJJbfS3oVVEznvOr1NXkXc5wxN1LWcf0KFSVibriD4lXV8jjSjeIc
         b4NMeStldk1hf8eeQBUgXThXl2027YYKAUjGuX7UH+sAGFJSXeWbHQMJL3i8WhFh4d2p
         sb+OOqi0Fo7jYoSam4IpXbUBDLVlPDduUzCXwmM+Z7Lo8Hn5wEzBQw4Y/GU4/CPTQriR
         9xt9WAj/+knkAqdN5h4Tjqcq7weOwW269A6xuwDxNWuDR4BVD/7A7j7rPb1HVmDEIT5+
         Ms9pMe0Tuk1vrnne8qR317damTSrkR/CwIMWij4Pm65vYJxwSIgnrrMGUfDWrUCXHz+i
         CYYw==
X-Gm-Message-State: AOJu0YzV4qfy2X94AMs+2U6lfZD85J9UnMYWvzZP4cJNLmwl8Q2344Zs
	mqKyK7V3184CYzCLm+mZpV/nlZpVEcd6/+3cXzgkdcgiQxAMoPdseCYxQsr4GvxnNrLtAw/gNaB
	kcF2+Lg==
X-Google-Smtp-Source: AGHT+IFCj3xTbKFlaClBDEUc+PWHnBYL4aZW4UjFZnf3pHCLdZikUdzN4Ck0Arw0/ICpnwLMnKTNREcyUPQ=
X-Received: from pjbnk9.prod.google.com ([2002:a17:90b:1949:b0:343:7133:ea30])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28cc:b0:33f:ebc2:643
 with SMTP id 98e67ed59e1d1-343fa527f01mr1060169a91.23.1763079201334; Thu, 13
 Nov 2025 16:13:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:53 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-13-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 12/17] x86: cet: Use symbolic values for the
 #CP error codes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
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


