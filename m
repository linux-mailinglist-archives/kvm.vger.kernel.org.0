Return-Path: <kvm+bounces-21978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA63937E17
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C64B81F21CC4
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5747614A4E7;
	Fri, 19 Jul 2024 23:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Vq3fpFf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3096514A092
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432640; cv=none; b=CbxOY2t1/ebAVge/aimSkDxB05NqhtW8XmLvL23rJKseHp54ydRFVlY4oQA+7B5RgWfoD7BldU86LOm02SSohPhObarvYG14edF7WrwYHEBu8+n2D8345Sh4x7W5WDQUjd8YojHIOUiuC+BrZM7gcLge6ns/PIgQYxjbs/B3BJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432640; c=relaxed/simple;
	bh=PPn7G+f4jddXFxEDGFar00uqs+OIt5lJ4PTBlh2FQQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TB139tiwqSKbNXG1McyzxmWrPngLI+K7e49zDpcjSQyVFP7V0Elob/qE+EGfV8SXCbQqeG94e5QaixmIUB6LYRWBoqAGjCe9uhS3iQHhdZyj12SqwmFZTsoH11CTyLFeFv5LcWeVpHQUMvZvbGmfsRTLFZReJmdX/VcACWCAyG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Vq3fpFf; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70af7dc9780so1325201b3a.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432638; x=1722037438; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nPt/EFV+Nq2FbP/DjJ0bFlMBOKC3xPMXdgZnshJlA9c=;
        b=3Vq3fpFfznOlU1PmOXKDg2z39TyQyHZf9wYfhsx1zuLWJcaUMGN33VlX40g+DSYnnc
         wul05y62UHZoao/I1r6FAIBNtEDOQAABOrq1+djwvsWpE8kSU55ZL+NaDZxV3k+HZh0U
         MabqoUJLcTZ0WskElfDW5SlrJ07bkVVSJxMiOxPHmMRTqizMjQs4Y7T/Ej++VKOp7aVB
         IkJyGJNY1PCtKTHkRKkC+jAa+3/JY3EBVSBVFdIQDzgoqKh2x2g1wl2iSa4+qJIOdKkK
         Kgqb7Fd2YZM1XX/ePz6Wcbl8bokbGLJd18u7c40jcDyei6Uk6NwAyTZL7oPouTBREXRN
         +1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432638; x=1722037438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nPt/EFV+Nq2FbP/DjJ0bFlMBOKC3xPMXdgZnshJlA9c=;
        b=HsJoDrJlDMGnF5ulSq77qJTKdmmzVpczwYzPUMmYvFshTcv66Zy30wNgD85piXDfXq
         uzm+si2TAPDFcQxzNxUv22/MF7QjK4L5hiyb4oI23z4rBooWLp4uu15fIIOib/qaYb/B
         rVmYGC0meMUcgWg6qeiHUfYpTeGgNcuXKHVvexcJ4oFeuOoBVzsWRnbJLYeJleVg3A0l
         tqcX+K5sNYKXHNNZmb7dEf2CAQ9YgC5ikOJsUqJfuL/w5F11gAbf9S/voXUzlMooP/wL
         S6g3rt9wQE10nX46VSP0KHYBLJYj+/6SkXQC2x0HmNqdS+CUXtbsc4VybF/lrUBW9ejv
         RaoA==
X-Gm-Message-State: AOJu0YwT/55c+xk5f4kB3w5yQBqFDbN2IRibi8Jda0cnX6otHxZpCi2K
	3wI/bk3NXbfycpsLh7pmqCHgB8mAV6Gsq+n7h/zUlqwIIXUVIk+jEngBg85Zg1FkEBdmtZ4qxuQ
	Eqw==
X-Google-Smtp-Source: AGHT+IH0kpH/UFJ9YnQJ29R7jW5YI6r3QaHGi0uazNzGckCKBUeuNmJ/e1teSmk32abSP1lzY/T/0UsK7vk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1314:b0:706:3433:bf21 with SMTP id
 d2e1a72fcca58-70cfd58f8f9mr47559b3a.3.1721432638145; Fri, 19 Jul 2024
 16:43:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:42 -0700
In-Reply-To: <20240719234346.3020464-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719234346.3020464-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-6-seanjc@google.com>
Subject: [PATCH 5/8] KVM: selftests: Report unhandled exceptions on x86 as
 regular guest asserts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Now that selftests support printf() in the guest, report unexpected
exceptions via the regular assertion framework.  Exceptions were special
cased purely to provide a better error message.  Convert only x86 for now,
as it's low-hanging fruit (already formats the assertion in the guest),
and converting x86 will allow adding asserts in x86 library code without
needing to update multiple tests.

Once all other architectures are converted, this will allow moving the
reporting to common code, which will in turn allow adding asserts in
common library code, and will also allow removing UCALL_UNHANDLED.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 153739f2e201..814a604c0891 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -566,10 +566,8 @@ void route_exception(struct ex_regs *regs)
 	if (kvm_fixup_exception(regs))
 		return;
 
-	ucall_assert(UCALL_UNHANDLED,
-		     "Unhandled exception in guest", __FILE__, __LINE__,
-		     "Unhandled exception '0x%lx' at guest RIP '0x%lx'",
-		     regs->vector, regs->rip);
+	GUEST_FAIL("Unhandled exception '0x%lx' at guest RIP '0x%lx'",
+		   regs->vector, regs->rip);
 }
 
 static void vm_init_descriptor_tables(struct kvm_vm *vm)
@@ -611,7 +609,7 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
-	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED)
+	if (get_ucall(vcpu, &uc) == UCALL_ABORT)
 		REPORT_GUEST_ASSERT(uc);
 }
 
-- 
2.45.2.1089.g2a221341d9-goog


