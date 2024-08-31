Return-Path: <kvm+bounces-25585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F25D6966D38
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4983284C1D
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31A5BA4B;
	Sat, 31 Aug 2024 00:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wVS4K4EC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729AF4C81
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063346; cv=none; b=BnVhMP+tfUXitwHSzuVSmIy652ME5HjPsdyIavEE9Z/egdZVd5H6pSYNRdv/1NkwQmGgwuc68JDlkU+Mj/FFTbsgOQQYeOyA6Dl7NDD1vS5ZdBWlhPFBlkPc0HW90Su11pYwMIwjxCinISqiag/XSp6oqq43HfINtHmjyte8+q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063346; c=relaxed/simple;
	bh=YXptvY2Uza2H6tZmzonyv74pSte76Tmo4IfX2fwO+lI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mdK/bJdAqDnkfCiTHs1wvLqlBLUHnaQpQfVwVSfT05gR5zL/e8SrFD6fpaIQID5VPOKHXAtzJNAYVgLnIw8V78PZY8/uzwyorOEvROIVNV+vr9OVWQ0zDdkmH6YiMNIreFmyO22/1971zaLj+wD+ukfGhk1HqLC3tmCA0OTXu0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wVS4K4EC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71431f47164so2530044b3a.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063343; x=1725668143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TE7D/Acr9LdQYMIXlBbpo74VePMtTsMcOWGqO6E6aPU=;
        b=wVS4K4ECSWnN4B2tXS5Xi+dfWOwdFk322Z3lzJgGYbNbPuUk1GVvTgQl1EF2ZORY38
         ygjMeFPBXe6cWuHk/yvVr3aryruQGspP8HdJKGDqhdzE2KkA6mC7hnRFaTOKg9UwQywR
         SZRU1ya92RrqYrA2esJCvU9eMKpCMUyWhGONaTCBMWr6VF12KyVzLvTo7duQzHG9uynM
         zmtgYcP2hn40AYEZn1AmkgebR71OKQmZAzDhQh/Hf5we0VFvUK/UU7MOzG59mJ27jIku
         PDHgP49RazXClrJ2AzxVYkmKC09zntgMVqGjLnZIClTAsE6vFG6h5oMR5gOGB5aj+/iJ
         JkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063343; x=1725668143;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TE7D/Acr9LdQYMIXlBbpo74VePMtTsMcOWGqO6E6aPU=;
        b=P4VWbJhO7yvIWzHzE/5lsYLBYrPfMFWUMVshKyZA/lynlLMu+lB+6p9z3jgcUUNCKE
         guVF7VFKQm6TwgH4P+Ezr2I3NbUHhNTqwji1Hr4W4abPyjLEADpM41/xUwTLCw6PgCuW
         WZsRGRL0WEjy8jVWYsUjIEkNbKUg7Ta+YTGgx4lobmR4qfq6rjWhp2OrAS8s2DUY9fyI
         9wHuro8gV9x1Z/Jyl2s3P87dO1FVxfJYKsB5uXnb53dCUm9k9NCyS/zv9vYPjmDOLIyh
         3HZwIVlUydEdyWNE/34cZY4LwVkxHKNtet9appWtpiCjmwVZ4MgP5G8rjdw2FZqCMSQx
         M7Vg==
X-Gm-Message-State: AOJu0Yz8Af7IAGwuRFU1uILHMKmB7VKQ/J2+WfcldEXJnRdvH50f0gXa
	oh8vv8MNwnRv/sg4JjBa8yzaa/W0kJ8/AJgCfG6A9nPaXvt2Pp1kF9laFdq/G+L49BiPVBEYNfI
	Geg==
X-Google-Smtp-Source: AGHT+IHgRgu3nlEMwZydwng1Zdptt9mq0HfSF6rdSzaH8wMvVyFEIrgTbt4SBvsLsaty6rpdkiRrHOmEX/c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:739d:b0:714:200c:39b0 with SMTP id
 d2e1a72fcca58-717308ae005mr11477b3a.6.1725063342706; Fri, 30 Aug 2024
 17:15:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:16 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-2-seanjc@google.com>
Subject: [PATCH v2 01/22] KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and
 only if the GVA is valid
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Set PFERR_GUEST_{FINAL,PAGE}_MASK based on EPT_VIOLATION_GVA_TRANSLATED if
and only if EPT_VIOLATION_GVA_IS_VALID is also set in exit qualification.
Per the SDM, bit 8 (EPT_VIOLATION_GVA_TRANSLATED) is valid if and only if
bit 7 (EPT_VIOLATION_GVA_IS_VALID) is set, and is '0' if bit 7 is '0'.

  Bit 7 (a.k.a. EPT_VIOLATION_GVA_IS_VALID)

  Set if the guest linear-address field is valid.  The guest linear-address
  field is valid for all EPT violations except those resulting from an
  attempt to load the guest PDPTEs as part of the execution of the MOV CR
  instruction and those due to trace-address pre-translation

  Bit 8 (a.k.a. EPT_VIOLATION_GVA_TRANSLATED)

  If bit 7 is 1:
    =E2=80=A2 Set if the access causing the EPT violation is to a guest-phy=
sical
      address that is the translation of a linear address.
    =E2=80=A2 Clear if the access causing the EPT violation is to a paging-=
structure
      entry as part of a page walk or the update of an accessed or dirty bi=
t.
      Reserved if bit 7 is 0 (cleared to 0).

Failure to guard the logic on GVA_IS_VALID results in KVM marking the page
fault as PFERR_GUEST_PAGE_MASK when there is no known GVA, which can put
the vCPU into an infinite loop due to kvm_mmu_page_fault() getting false
positive on its PFERR_NESTED_GUEST_PAGE logic (though only because that
logic is also buggy/flawed).

In practice, this is largely a non-issue because so GVA_IS_VALID is almost
always set.  However, when TDX comes along, GVA_IS_VALID will *never* be
set, as the TDX Module deliberately clears bits 12:7 in exit qualification,
e.g. so that the faulting virtual address and other metadata that aren't
practically useful for the hypervisor aren't leaked to the untrusted host.

  When exit is due to EPT violation, bits 12-7 of the exit qualification
  are cleared to 0.

Fixes: eebed2438923 ("kvm: nVMX: Add support for fast unprotection of neste=
d guest page tables")
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f9fbc299126c..ad5c3f149fd3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5800,8 +5800,9 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu=
)
 	error_code |=3D (exit_qualification & EPT_VIOLATION_RWX_MASK)
 		      ? PFERR_PRESENT_MASK : 0;
=20
-	error_code |=3D (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) !=3D =
0 ?
-	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
+	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
+		error_code |=3D (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
+			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
=20
 	/*
 	 * Check that the GPA doesn't exceed physical memory limits, as that is
--=20
2.46.0.469.g59c65b2a67-goog


