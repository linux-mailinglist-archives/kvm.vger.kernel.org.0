Return-Path: <kvm+bounces-58387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB899B923A2
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9950188C89C
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C493126A6;
	Mon, 22 Sep 2025 16:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W4Ol7vBy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC26311975
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758558587; cv=none; b=NeP+VBy9axbOXdzkXcoBuASEJilleOx0OIpmEEg2BWGGq6An2paAzh7rMsW+Lprj77UDh+RGbiUGe+mfvliabYlOxqN2Z3wVyCwooq/iblqtmtjFiWFp4ujptUH0Pj6/GOtnL1OinUYBtXhFaK7R3MPlWCbkCEomRCcR+5bjNpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758558587; c=relaxed/simple;
	bh=t52RI7t5Qv+jWIhNWUYoVvPH+4WLTE0aurBZ0jd9Z2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E9/kb6ruEY+u96rRBwL4HgWYJh1VbIRmrPjVfuvwMF+xNr+lHZdJT4NiEvNvoYJWm3HTXgvJZ7pCyoaxHBMqOq/jlWhYDvTKDp5A8Z3cnCCC2tU2iXqdYULbuIahp0aax2KZ6KlRhRoQKI1mMBFp8YvRd3haJggXn14sLvDqOtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W4Ol7vBy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b554fdd710bso737877a12.3
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758558586; x=1759163386; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bkgY9ceXPdaZB5q5v1VS3P+DK7qjSWQRkaXpesHzhwg=;
        b=W4Ol7vBy3M8JqtUALETuX8xwiq0dEKJbXI+b9bUk3FN40UO+/JhtC8apyZ99Nzl2gR
         rJkBWSIFDaiverLfVUjCCGKRkNaH9+ut2flta2HtVcigpy+LmUFiNY4SvdCshEMIiqNY
         5ixA/RKptooZoIM7zzPVSczVoL4VOhO+lNKkpJREXHzMTBigwzAp9b7pockMwqLKzpO5
         ewpb/cRPshcpN4gRkouv5lXwimJl1kfnTECUJr3/wvqXNjw3lS90FtmFw//vgZeMtvKY
         p0JELSW4f4k2oIG1lQ5a5tRcOe17BzlUZYcu2d6QvVn8BwHNRUU+CiBcMQBoMAjjaalM
         79+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758558586; x=1759163386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bkgY9ceXPdaZB5q5v1VS3P+DK7qjSWQRkaXpesHzhwg=;
        b=EyLEilU++5M/mq7BJl1DD9XPUrCFdPDJfcNQtvVyJ5ZxF3pUOunOXoP//vUf5jcxdo
         KXmlq1nEOta5rwwrSC2c10PcDdT5lY01Rt0klBpkBNRFJ0D3l95HN5ZOweMI+1stQHOi
         9yVqotzPbLuivydc4vwPZS4GZ2XykMrKnZrLG3K/BIpClStZ+XAdXSWPltAsxnXyxD1x
         YuEEqJbZrU5l1m4QlyFctpN5id8jxdDta70TsZ70surLErEyq9Zhn9GIJlBlzthOLrt/
         X5zCKUBWdcPI2n1Xi1iNZq8IJSCzm6InWSJTZfbpeQ9LO+WIdWmJNZA5HLizn3/pl0M5
         0aow==
X-Forwarded-Encrypted: i=1; AJvYcCX34h0P6sXTrmIKtNnWM09Kok10oCFPnqqA+WINpUIhJqFtT3lIIZc1fw1W3IQlIQd+C5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNTm0roLfWACSvRMBe317Yyoy9KBXtxml7N6oRvFHnVxngayn6
	MWyeQpL+kxDPqui8+3URJ70Hx4nSRwWDlO4gUazxqu/cH7VNzn4/uGeS2liDfiz9tEEpCJuHjzv
	Fj2jhS/teOwr9VQ==
X-Google-Smtp-Source: AGHT+IEGcw3tckWJnWAt+KDw3v1zpwJKOzPT7MsJPUPXmlWdpknfr9XxZgn+Y/Rd7ABuKyWODb8wqHIlO+Ea0Q==
X-Received: from pjbhl4.prod.google.com ([2002:a17:90b:1344:b0:330:7dd8:2dc2])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:57ce:b0:327:83e1:5bf with SMTP id 98e67ed59e1d1-3309836301bmr14749855a91.28.1758558585645;
 Mon, 22 Sep 2025 09:29:45 -0700 (PDT)
Date: Mon, 22 Sep 2025 09:29:22 -0700
In-Reply-To: <20250922162935.621409-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250922162935.621409-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250922162935.621409-2-jmattson@google.com>
Subject: [PATCH 1/2] KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>, Matteo Rizzo <matteorizzo@google.com>
Content-Type: text/plain; charset="UTF-8"

Mark the VMCB_PERM_MAP bit as dirty in nested_vmcb02_prepare_control()
on every nested VMRUN.

If L1 changes MSR interception (INTERCEPT_MSR_PROT) between two VMRUN
instructions on the same L1 vCPU, the msrpm_base_pa in the associated
vmcb02 will change, and the VMCB_PERM_MAP clean bit should be cleared.

Fixes: 4bb170a5430b ("KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit")
Reported-by: Matteo Rizzo <matteorizzo@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b7fd2e869998..177a9764fb64 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -744,6 +744,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
+	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
 
 	/*
 	 * Stash vmcb02's counter if the guest hasn't moved past the guilty
-- 
2.51.0.470.ga7dc726c21-goog


