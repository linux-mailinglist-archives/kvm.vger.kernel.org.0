Return-Path: <kvm+bounces-19112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 184AE900EBC
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A50B4B220BB
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBA251FDA;
	Sat,  8 Jun 2024 00:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zGMjgRM0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9737F
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805408; cv=none; b=qvdElCNR5yM9gIM32Z3cbT4+6IrdX7Qd8AlMFjfxZI6Almn7oNLiNucEyLSbBglTVqDEhmp8tXOxyg1nY/kkZMKvlqicnay/7psyx572wAZHNZAupsk4IY+s9rmfJM86Bq1AoroAZ26OzPCiwnTBizWkwqsYcCgF0zk5+2+muQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805408; c=relaxed/simple;
	bh=W4obiWieTwX8XIqKNFsDLPnp7HqRk5M9sGKeUadzy3I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=JkQT9pv466aUkeXecuEhTQRc82AHqKot3XyruFJPzqOZasd1iKV+88gSEZu55iupmvyly9N3TMWdvaxqZxtjNGTHiBVbpK62ILsHTe6d+4XhpF9y7wzYt//NcKRw7HK6aUsDbC8I+1Pun6bJYaLJe0JSL3cqmM/RNYeOgsWNVYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zGMjgRM0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a27e501d4so45149557b3.3
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805405; x=1718410205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ovNDgtVbmisuBeW7HmpFAvacvLNy1ePjizPveBsLPr4=;
        b=zGMjgRM0JVdzKI3YauzLyVFHID61kfaD4ZAmvVlRbwmc4uP+n+mt+U5v+r6dgU0x2T
         /MuQxz/hFgGRF/ANZbC3J3+BaRoxnxgZv9QZNAflTn6M4C3fGVYo2GDt6UnhEoEDJiAc
         UtZ30tXXyE6hFzIpkqcfyAg6UVKV8QvWMTinCfFT0LwL0PZirTdDlu8hP8zPUa5RpXp9
         wVlbcaSCCwqi87E3CiuCcYKoNie/PJ4sowXFfEnsWqlt9z2SlCBE/2m60w06FRqx0rSb
         VUyDLjZytxeUYOkzd1LIOvqzb9Qv1i2Isl/jbM3FRL6oA6/v4a/u9o6dx3B9KRYZ6224
         mMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805405; x=1718410205;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovNDgtVbmisuBeW7HmpFAvacvLNy1ePjizPveBsLPr4=;
        b=TP+++prGsvPhziAcsXBFNX4QluUox59WTXLZu+fPhjiFgSkPn9NRdjbP94A/UfEQ55
         fG199fEXXuEQHxsb0XG6wjbTCsfO8l8qKbyCLZzZUfNVNo1/lK3hPqhwfPwaIXvz03WJ
         oyDq+Y3dt7kWNlNXvaYQbDkFPXxwwEj16FIu3uJHa/MH/tKzCjPGAutgaXq7OPVumV0Q
         2f+6kvkDIfcxlgHZm4U3YbnIrzI8XJNR3O0SogYwSUuAqFzbdNRrIe5TeKK/vTu9NtPv
         eIQiWgqiHlhtN/2vUz6bFiu2sFD0LRwuTi8oIVAxw69IFEwbphkJneq3dRWWw9J04SwT
         qMvQ==
X-Gm-Message-State: AOJu0YzKBb378+3hsgLUWtqG5D42Y/yWM+iIl4oP0+YQfpPpugKy5bbG
	cY+RsY/5tjpC5wsoRavH0rfyTgT9bECt5TkZM324ThBQr7ANj7Pj0J8/UkVCKSfGxiozkFOOxm4
	ogw==
X-Google-Smtp-Source: AGHT+IGCFQlXppceAobvWJ0ws2hb75J4/DwIiNLGsm2o8FxFFflMMK+TT9IocPOq0aInmGSc//ZDlrCDb2o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:64c9:b0:627:a6f7:899e with SMTP id
 00721157ae682-62cd566d549mr8431987b3.9.1717805405666; Fri, 07 Jun 2024
 17:10:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:10:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608001003.3296640-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Remove unnecessary INVEPT[GLOBAL] from hardware
 enable path
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Remove the completely pointess global INVEPT, i.e. EPT TLB flush, from
KVM's VMX enablement path.  KVM always does a targeted TLB flush when
using a "new" EPT root, in quotes because "new" simply means a root that
isn't currently being used by the vCPU.

KVM also _deliberately_ runs with stale TLB entries for defunct roots,
i.e. doesn't do a TLB flush when vCPUs stop using roots, precisely because
KVM does the flush on first use.  As called out by the comment in
kvm_mmu_load(), the reason KVM flushes on first use is because KVM can't
guarantee the correctness of past hypervisors.

Jumping back to the global INVEPT, when the painfully terse commit
1439442c7b25 ("KVM: VMX: Enable EPT feature for KVM") was added, the
effective TLB flush being performed was:

  static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
  {
          vpid_sync_vcpu_all(to_vmx(vcpu));
  }

I.e. KVM was not flushing EPT TLB entries when allocating a "new" root,
which very strongly suggests that the global INVEPT during hardware
enabling was a misguided hack that addressed the most obvious symptom,
but failed to fix the underlying bug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0e3aaf520db2..21dbe20f50ba 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2832,9 +2832,6 @@ int vmx_hardware_enable(void)
 		return r;
 	}
 
-	if (enable_ept)
-		ept_sync_global();
-
 	return 0;
 }
 

base-commit: af0903ab52ee6d6f0f63af67fa73d5eb00f79b9a
-- 
2.45.2.505.gda0bf45e8d-goog


