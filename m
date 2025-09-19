Return-Path: <kvm+bounces-58265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A46B1B8B89C
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EAF0B64CF2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97414306B02;
	Fri, 19 Sep 2025 22:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qyaFg7M7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF2A3054D6
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321253; cv=none; b=HrdrJ0hiIWlMtk77Cn+U6Ggo4u3lQWOh8T7x81OhcmgTRJ1QA/DWfMV3pEiiQK7q819LS+l/rxXFMJabV0UMTIo8YytEsF8RE0n+oKcyBRnN81TvGwcdDwrWoiJx84Yzq3ck5hbSC9CCMGCNlSkxVrwOFdnxj+3ByDGGsUUQrJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321253; c=relaxed/simple;
	bh=X20sEQ+xsCLTJe7gE4Qs5AwL/wm1XuF1rIgh80JVcHA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mLMfnRzW8+i0BG7b7vw6r4YJoqhtFbeNBF9snvg3zp1NcUy2h3JHMueynUugV3IZltVMQBkilPE5wpch8sDOHsYIXDlJeAwfH33jLkUY6y2+m1MJaIKq6lqTYC0adWdZcjlKbESIQLxR1X2uEbeiAEz0k3WMOenI4JRBDqA6Nrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qyaFg7M7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32e09eaf85dso3085771a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321252; x=1758926052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eHR2NLSLCCnmrfYd7kOboVWYopKWMO4BXG1y6UT4JW8=;
        b=qyaFg7M7riU2wyKee4ZsFrB7unFBf8ILe2bJbHNx8eoIuPcwVDtVGCyosGpoR0UG/a
         hnNhMuapuhIQVU+NUE3CApxOrn6ABCfmsXUZbTTWjRqSo+0TDtUm7bxxbgiEKLcoWJKY
         r79tp6HvOo7JyLn+fKiAsJPUcFl1ZGt62+CFjgPCVA5W62zLpcahdgCLP9Qbeexgk8Zy
         kw/1+Y2ZFYz+QeZI7mo4bFpZI3TDfGZSnYrobe/yK+r42wfP1TjMb5CGvhqAatU+xrDK
         MXlixHsD29s75g1tGndXJPSunL3CsKk7V2+o67odUEhm6PaJ86lR7raOMNw+ZcnXlKad
         gCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321252; x=1758926052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eHR2NLSLCCnmrfYd7kOboVWYopKWMO4BXG1y6UT4JW8=;
        b=NqH9xDH5KCx9MR0V4qUBoM1RwP2Lnr+sYBLZBORE8uhSsEzzN6zCbNn3yHi2GrRehX
         xpuXuesOJv92QrMzKjA8yr9XR/29ptATLxg/TY2/6pvSMCoswHQyELUXejKXuEge1AJp
         XTGUyQwbDHVL4Vg0rdimmDS95GhaVkKtY5/TSa9otw4PEQ1IGf80wfaYa+TuUhM+HuHO
         Lgy0/SAXS9ZGLxpukf1ZBT0o74qLDMcadgiXQ7yysqp2RO49nR45lOJAZW5TeKEabMVs
         0wkTwc135UqJXxCPPFr8QQOH4xW6M/43VEtAdENBGp0khADDx9lPnhztnuCMTem67fHz
         BLcg==
X-Gm-Message-State: AOJu0Yw9E/P96q6NmaNwGtGu4O7scKP6e6QQSdXIybeGJQrIF8jrzt+t
	sDqAiLXyVRypHzr1jddxHb5qOfbXsxbSj36aPU74Az8FtJ1TsTCRBFgQXNXgB9cLtkb6crcuu5V
	4R6j5ig==
X-Google-Smtp-Source: AGHT+IFifa+3ALaHZ5N/ALMtEqJi9pVMuOHdbpWekClGQnveANM6eyoR6/P/Qd3bbbMyzvhBHioRo62qYnU=
X-Received: from pjl13.prod.google.com ([2002:a17:90b:2f8d:b0:32d:def7:e60f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f87:b0:32e:5d87:8abc
 with SMTP id 98e67ed59e1d1-3309838e02amr4950519a91.36.1758321251699; Fri, 19
 Sep 2025 15:34:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:44 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-38-seanjc@google.com>
Subject: [PATCH v16 37/51] KVM: SVM: Update dump_vmcb with shadow stack save
 area additions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: John Allen <john.allen@amd.com>

Add shadow stack VMCB fields to dump_vmcb. PL0_SSP, PL1_SSP, PL2_SSP,
PL3_SSP, and U_CET are part of the SEV-ES save area and are encrypted,
but can be decrypted and dumped if the guest policy allows debugging.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 52d2241d8188..e50e6847fe72 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3410,6 +3410,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "rip:", save->rip, "rflags:", save->rflags);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "rsp:", save->rsp, "rax:", save->rax);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "s_cet:", save->s_cet, "ssp:", save->ssp);
+	pr_err("%-15s %016llx\n",
+	       "isst_addr:", save->isst_addr);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "star:", save01->star, "lstar:", save01->lstar);
 	pr_err("%-15s %016llx %-13s %016llx\n",
@@ -3434,6 +3438,13 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		pr_err("%-15s %016llx\n",
 		       "sev_features", vmsa->sev_features);
 
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "pl0_ssp:", vmsa->pl0_ssp, "pl1_ssp:", vmsa->pl1_ssp);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "pl2_ssp:", vmsa->pl2_ssp, "pl3_ssp:", vmsa->pl3_ssp);
+		pr_err("%-15s %016llx\n",
+		       "u_cet:", vmsa->u_cet);
+
 		pr_err("%-15s %016llx %-13s %016llx\n",
 		       "rax:", vmsa->rax, "rbx:", vmsa->rbx);
 		pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.51.0.470.ga7dc726c21-goog


