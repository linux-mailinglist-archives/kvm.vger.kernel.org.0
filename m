Return-Path: <kvm+bounces-36931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6280EA231F1
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 17:34:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 788DA7A44A1
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 16:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98B2D1EEA35;
	Thu, 30 Jan 2025 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Je+24Mx2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E671EE7AD
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254699; cv=none; b=cPcMnz0sBh6KoUeCL71m0CZWBe2Jn2B9Kt2pa2G3TCdj+e34WWvNxMasFdU1HyN707x/sPr4awQ6pAeCpbd+uYUtpJ8YXZX3xIRyd9nI2lWQLZujln5QLX0ZnmepZ2t6+w5o2Tb5HWTkE4mG4xhH5hSRJq8L91pDy79hGspUijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254699; c=relaxed/simple;
	bh=jLO94T/rfsKNszrDBAXBuU7MElfZOIVS3fTfu8k5I70=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DTwJdm0zRORpQyD3yiklisQRx3JExCD2G2wJhRmwVlnHjzNbbdyWw1ejWGIQborO2ACmnKk1lIe6/1lnXqhuDjVzykz28oNPXVa/nDxDt7pFeZGDvAzfQ4XOgy2BonWRpIb3Sls34HwSSbFmPviZhP/WRvtxHQuHhHxXSnbbHHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Je+24Mx2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21638389f63so16532275ad.1
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 08:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738254697; x=1738859497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HgChTB+h/v0V1ILcaues3kTeRfwzF+xBPcgEstOaJbY=;
        b=Je+24Mx2NJSMtT5xVeC4/bgqefeykaH2cxZZJWq19OdqqwaZ60paymPv+ta1E52VyZ
         re1RNVWrKdohlEKbyS6H9gvFy3gm5MRncexGDQX7RJLP5vmvsmLzEwJ8r3k+TlXvmk69
         Qs4KuEQFcvXPOytGrGE5FAUL+k1IVM3Fp024fjvy8nQVHc1f1FrWh7HjC9YLu/1hjBVi
         IUgmPs9MvUh0GngJC70tDCWQXrxeQOHmDZWLFyv1uoOHkm+u6R6YVkMChajWy3tV0b16
         0bybk62L54nv00u5MRS7KDWx9ZOWAijZjsof/2oXpm9uRfbievyRLYxxyPKnzYMax6wX
         r81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738254697; x=1738859497;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HgChTB+h/v0V1ILcaues3kTeRfwzF+xBPcgEstOaJbY=;
        b=TqZvsa206LDkOSKgA0J3YKDrTchguLW75g+sMS20fsJd8Kz/6vIRRi79SiuNG0J61f
         Kgr6C0bWePZRWsvOiVA9WuQ8cuf6XsBVeFv/pt/iGcF5D/MADb/TQIA94qTop6d3kY1t
         uofaWJvD5X0eQMDpH/XMrg4Cqkg1WysdZ/Xkt+5Y8UPPhzDXTSiwkiA7hexH6pD05SN+
         i8TF8tGtJ++HHSlmaajcHd4RxijuWw9yZJixWrUIPqpM6IH+3Hn4uD5Bna60ciFBFI99
         hSUTX1/rTUGzRC3Koyie9C7yBYYzeGVjBGoRbnpwb2F4HJQu7EXIhmWi+sFewseQMnaY
         5FUA==
X-Gm-Message-State: AOJu0YwZPNOGupQpAj8S53WGvbzHmRrNCBBwZjItkEvKTOND1rV0eZqm
	sB6tZyJXSoYaSyuaQyBkD0dlNOSS+qm/nPbRJ1u5R9gTnj3sOR4gIo8j+a8+pG52uZCuZot+LyL
	GkQ==
X-Google-Smtp-Source: AGHT+IFdxwqEpVPHkNTx8enKIzhdfrGcuN/btBrdsQSLMQOzmDaP/yF2U8z7MObmKxVtbnzvzQFlRPqDFI8=
X-Received: from pfbbe14.prod.google.com ([2002:a05:6a00:1f0e:b0:725:c7de:e052])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d07:b0:1e1:a07f:9679
 with SMTP id adf61e73a8af0-1ed7a5b67a5mr12830134637.4.1738254697505; Thu, 30
 Jan 2025 08:31:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Jan 2025 08:31:35 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250130163135.270770-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Actually emit forced emulation prefix for kvm_asm_safe_fep()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use KVM_ASM_SAFE_FEP, not simply KVM_ASM_SAFE, for kvm_asm_safe_fep(), as
the non-FEP version doesn't force emulation (stating the obvious).  Note,
there are currently no users of kvm_asm_safe_fep().

Fixes: ab3b6a7de8df ("KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index e28c3e462fa7..61578f038aff 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1251,7 +1251,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	uint64_t ign_error_code;					\
 	uint8_t vector;							\
 									\
-	asm volatile(KVM_ASM_SAFE(insn)					\
+	asm volatile(KVM_ASM_SAFE_FEP(insn)				\
 		     : KVM_ASM_SAFE_OUTPUTS(vector, ign_error_code)	\
 		     : inputs						\
 		     : KVM_ASM_SAFE_CLOBBERS);				\

base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.1.262.g85cc9f2d1e-goog


