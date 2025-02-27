Return-Path: <kvm+bounces-39419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF75A46FD7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F2C116E15F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E2A182CD;
	Thu, 27 Feb 2025 00:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y/k4+hi7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60619196
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740614835; cv=none; b=PrixxyTWgCeg6x4lyOpi48TH6HG5L6sgrmnH+ZdRE5hE2J3f/xBGmCnJlhqEJz4jb4s+vGzLeSZkZ5zut2j97XlKv0Korkvgk/WLbSgDq/dUEcDyXalyVvf2FHmVAk+MFaa8POpsD2Dsfw6QgkCgi6xX4PGOx14KhXMO0AKHvCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740614835; c=relaxed/simple;
	bh=ARt9Rjho6v38X6nxSVSobQN7HwGd2l4pHj0ITorrVg8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=evaoJn/YjMU6jjunoNPqMH+8MpWmjKHMCWh1gZp4yewMciezrTCUcYv08umq7MUuMjeIwNe7TUNnNezrltKnjjRkO+RNNDygNakTH2T3tafnj3mMgJq+xnweTWCAMfhXfNJgdecFMZTrOh71w9kY7NTw8kLZ1Wp5FXVUhaTSSfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y/k4+hi7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22349ce68a9so9261845ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 16:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740614833; x=1741219633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FadFsZPSnl5y0it2sxf4RFwxg+b4udHNraHDwIbef04=;
        b=y/k4+hi7AEd6W+jbNll4lo2Dk2uZP+8W55NmzY+u3D3YtqOyiSJLbvfFsFg+qVLqD3
         a6Pa3K3BDMs+3yWUT/pwFoioxGaJWmlNRw1hGouIZQjaWohbmHrS4hbjl7qj5flsRjhu
         qWXClgSgQIPl0kTk3FqRskjGWV8DGMDNlXbloZTEY/hfpbmItPlnDxUVXrrtPXHSrSd7
         t2bIWJ9NF7lWqnkE1lTCOPJXqRxWuXCorypecr+ul0cN/PdS13FXJpcovDql9DnLvJTR
         TXHrSPY0Exn667V4TzI0G5G+YLJQ7zMUCn0isDc/L9Z6CcnJT5xaZY745jbIygLjhsO4
         HX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740614833; x=1741219633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FadFsZPSnl5y0it2sxf4RFwxg+b4udHNraHDwIbef04=;
        b=HBN4WM/+NilxJgYnaPvjx0mNMXmxcMYBJGerIMRyG8Pfn24QCRpjjy3JgN4PcAPudA
         dDSG+HTx3MfXaLNHokH/98xvez1jkZtlJ+e638nJgC5pNAdHFJ/ChHc8kCCG7vBJD6xT
         PvvwbPPqbFapYIHh/wx4jmCWz9AnjPD2xvwLKIpbq64mgXY3gp72XAgwmTb0elmSQAGJ
         k56oG5WjlgSbiMkwDzhx91yglR2+8nzA6i4yD6br+Ze+/vtEqS+QGjIYhIzl0pZRLGqa
         oz2yOXmFdqzbbGO/K7DcxsircAi/QPQUITiAxVMm7TKnIPoMVr0xa5g6YMNNwFSUb9iT
         bnNw==
X-Gm-Message-State: AOJu0YytlZxSng3GKtMhZBc+19zD7MQ5R7tY0b7CtTxcWDVQCcc7D7Ou
	TxAhFGNRySpEpw52Wmz6KFeSuqQzbXC4vK+2X76nmrYJbM/apPm2ufbOyIie14HcP3GbHxRG2vU
	SHQ==
X-Google-Smtp-Source: AGHT+IHA9FknTJvD3YTTz9hcMKM2W0XGo/hnQM6/5TXTpAmds//ZeSqngmimoO5DKp/EFvix7m84a3sTWQ0=
X-Received: from pfx22.prod.google.com ([2002:a05:6a00:a456:b0:730:b665:d832])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d07:b0:730:8a0a:9ef9
 with SMTP id d2e1a72fcca58-73426da560fmr31384138b3a.22.1740614833635; Wed, 26
 Feb 2025 16:07:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 16:07:04 -0800
In-Reply-To: <20250227000705.3199706-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227000705.3199706-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227000705.3199706-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nikolay Borisov <nik.borisov@suse.com>, Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="UTF-8"

From: Nikolay Borisov <nik.borisov@suse.com>

Those defines are only used in the definition of the various
EPT_VIOLATIONS_ACC_* macros which are then used to extract respective
bits from vmexit error qualifications. Remove the _BIT defines and
redefine the _ACC ones via BIT() macro. No functional changes.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f7fd4369b821..aabc223c6498 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -580,18 +580,13 @@ enum vm_entry_failure_code {
 /*
  * Exit Qualifications for EPT Violations
  */
-#define EPT_VIOLATION_ACC_READ_BIT	0
-#define EPT_VIOLATION_ACC_WRITE_BIT	1
-#define EPT_VIOLATION_ACC_INSTR_BIT	2
 #define EPT_VIOLATION_RWX_SHIFT		3
-#define EPT_VIOLATION_GVA_IS_VALID_BIT	7
-#define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
-#define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
-#define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
-#define EPT_VIOLATION_ACC_INSTR		(1 << EPT_VIOLATION_ACC_INSTR_BIT)
+#define EPT_VIOLATION_ACC_READ		BIT(0)
+#define EPT_VIOLATION_ACC_WRITE		BIT(1)
+#define EPT_VIOLATION_ACC_INSTR		BIT(2)
 #define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
-#define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
-#define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
+#define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
+#define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
 
 /*
  * Exit Qualifications for NOTIFY VM EXIT
-- 
2.48.1.711.g2feabab25a-goog


