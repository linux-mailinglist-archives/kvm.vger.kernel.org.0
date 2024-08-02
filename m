Return-Path: <kvm+bounces-23096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 744BE9462FD
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E62E1F23AA3
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0431AE053;
	Fri,  2 Aug 2024 18:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lsOSvbMo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833591A83D4
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722622797; cv=none; b=i0rpniY1wLWCHQopjsAt6gMCE7VlRBUMVVAs1SYvkAM3NOrniPOahd4QB1b/qkM89T5D4wiV55NtrUui6znK22sN8HZGECfg5QmybQeuIUSvrCJA8ZnJAmOFYZg3JznXs43gZ2e1b98S7Ese11h5rHqP/jliF0c10+JTTEwHcBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722622797; c=relaxed/simple;
	bh=KPLJgEJ/YLE4ImH6B/0BvTHADqCesy6cg2Mgr42CQOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YumDgRSo7vrjRIageCY2BEewpvpD9Ts0p2nWZfwSl4lElaUHJjOOmlZbx9tlVK8WvJnYuMNmydTeDiCZKuAPnR4SHa+vrMPBAWTw0AyrLiYsJfk2mYVjg2+nBlAFbToiun9ckbMfEge+HBmcb3DHkDQE0R1cSylipB39c9UqM10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lsOSvbMo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb51290896so8789202a91.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722622795; x=1723227595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VW65TnSe3VDX+Z2p8XcPpkoNA7LEX/iy6oraj4XmO9c=;
        b=lsOSvbMouzEaHvN2FswNed2RB8U0Oavh+AFQ4XGE7QVmibpUELRvusuH4qbeK0fcB1
         twexQGL6WZlx0t64vxE26YA0+A6kL5TsHEsiJ61S2CiTHc4bXSYOZqL62et/c23Rwf3L
         QV3bjq2GOUlfVGBH6XhTSkbbdp5Lf9Zk8St6yHZR5t5bqYPpUzeOE0J9jM9yrR4wQUQZ
         xQDgE+6/wHJQiLi6cOj8fgHHb/bNTZ6csjb6+I+JBq2Mi9lnFwhzg0vOyhVTy0zQZ4va
         guRq4eBy+WcM7cX88xd0rwbfSZW27N48eulNYe287bseCba3BDnz7k6Z+hgQQloQxfUu
         bWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722622795; x=1723227595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VW65TnSe3VDX+Z2p8XcPpkoNA7LEX/iy6oraj4XmO9c=;
        b=rhbOw1SG005AtZrokSVcyTouETjS1NrFBwARfgy+de0cAy2QWhr8YQb9zQ9rr5lGuU
         IIs2fey1t2Km9kXFFUeS8YaFn2aEE3FtKjij15Skzs53hGIcesvfU/m4uxqeP1NCfLLm
         h4pM5tsPfif+xgJcY6Fv46z4P5RXptt5FQ1UqcAIcucR5kxRYe1Zz1167PSfiO/QQN3h
         IrGpKO85l3NtMRfG56P5qatx6KIXN9yGengeULryrkSfRXI4vaIEVEQ3xCHhBfgRv9YE
         nwVoOJNSMuKMjSKRXJVlDgdRdofuXEY5rNY49san2hKnVjEkfg5C26wGDbZvJXnexRKo
         Mh8Q==
X-Gm-Message-State: AOJu0YwpoPmbDVSfZQlmkeg9Gg4UlEf2ICQCawh4TxPx6qBqR+gMnGVv
	5sCepQdp4P2EtpWHqt/dgkB/kb35CEcrm91teZSQN0ViyrAyMTbrtiZ3Rqbkf00z76+lx8CKHJ6
	nWg==
X-Google-Smtp-Source: AGHT+IHC2KYxnPAs2UD3E/vc510cwpqXgXyw7rAYKuvHYwr4mXpoWWx2tKTMlZBvYrh1ocwK8+X9gwZAAUI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:dc0c:b0:2c9:8b25:d72d with SMTP id
 98e67ed59e1d1-2cff93c1210mr58862a91.2.1722622794752; Fri, 02 Aug 2024
 11:19:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:19:34 -0700
In-Reply-To: <20240802181935.292540-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802181935.292540-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802181935.292540-10-seanjc@google.com>
Subject: [PATCH v2 09/10] KVM: x86: Suppress failures on userspace access to
 advertised, unsupported MSRs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Extend KVM's suppression of failures due to a userspace access to an
unsupported, but advertised as a "to save" MSR to all MSRs, not just those
that happen to reach the default case statements in kvm_get_msr_common()
and kvm_set_msr_common().  KVM's soon-to-be-established ABI is that if an
MSR is advertised to userspace, then userspace is allowed to read the MSR,
and write back the value that was read, i.e. why an MSR is unsupported
doesn't change KVM's ABI.

Practically speaking, this is very nearly a nop, as the only other paths
that return KVM_MSR_RET_UNSUPPORTED are {svm,vmx}_get_feature_msr(), and
it's unlikely, though not impossible, that userspace is using KVM_GET_MSRS
on unsupported MSRs.

The primary goal of moving the suppression to common code is to allow
returning KVM_MSR_RET_UNSUPPORTED as appropriate throughout KVM, without
having to manually handle the "is userspace accessing an advertised"
waiver.  I.e. this will allow formalizing KVM's ABI without incurring a
high maintenance cost.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d0ea6340fba1..ad28f0acc4fa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -512,6 +512,15 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
 	if (ret != KVM_MSR_RET_UNSUPPORTED)
 		return ret;
 
+	/*
+	 * Userspace is allowed to read MSRs, and write '0' to MSRs, that KVM
+	 * reports as to-be-saved, even if an MSR isn't fully supported.
+	 * Simply check that @data is '0', which covers both the write '0' case
+	 * and all reads (in which case @data is zeroed on failure; see above).
+	 */
+	if (host_initiated && !*data && kvm_is_msr_to_save(msr))
+		return 0;
+
 	if (!ignore_msrs) {
 		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
 				      op, msr, *data);
@@ -4140,14 +4149,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 
-		/*
-		 * Userspace is allowed to write '0' to MSRs that KVM reports
-		 * as to-be-saved, even if an MSRs isn't fully supported.
-		 */
-		if (msr_info->host_initiated && !data &&
-		    kvm_is_msr_to_save(msr))
-			break;
-
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
@@ -4499,16 +4500,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 
-		/*
-		 * Userspace is allowed to read MSRs that KVM reports as
-		 * to-be-saved, even if an MSR isn't fully supported.
-		 */
-		if (msr_info->host_initiated &&
-		    kvm_is_msr_to_save(msr_info->index)) {
-			msr_info->data = 0;
-			break;
-		}
-
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


