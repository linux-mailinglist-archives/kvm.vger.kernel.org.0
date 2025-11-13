Return-Path: <kvm+bounces-63079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C2CC5A816
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:19:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 298DD4E4759
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAC932549D;
	Thu, 13 Nov 2025 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1qM5XqUG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A672025F797
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075665; cv=none; b=ql9RG3PvPTBEj9laLq+AOUdca8iHpUWzjQIRnx8JJfVvhA55h7bLRYNLoTp1olXF5ZEVpWiIjs9aXHR/PKyTEOaJqi+9/sCBtTFtDfXpaqeiyqxtjpCCyzgUSzxQsYGmQOj5oKrsjl0WzVAHx8OLvq4m+oOSwwaFU3BylBWRTrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075665; c=relaxed/simple;
	bh=mn8GVQsW19Ick+Xm2YxzYB2fwo0JYhu91nF/XucEWIw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=n4pFAuqFaKmh9sKPXePqLvZGCD111SaE2uZYs2XYwWSXsXHk8pLRKkEGcsZPb8bZ2QeYnRkRZ9ZXrVdvgPkATuceRbBbdFwo34WYXBzi7flz4TR7d9srS/evaSBOgVe3XIT+cMCP4YXyV9hcnSnxn6oYMAsA3FFUUPmpgXZ57aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1qM5XqUG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343806688cbso1957429a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763075663; x=1763680463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5/UTn8bTtJTVg4Qd62Iha30XVgFf5+QbZgjq/H2S+M=;
        b=1qM5XqUGEr3eIGxJqE9jU3FvQXZjVhETxJUCtbW+VA64VjXkq9xrIY965rHDlBRXvO
         oHx0xV+rvZKfC88/7TWIIfeioHOIgmYyolFIa7jN4MCVT8n3UiERJsPHcqFSEXB44EGC
         aTk7PcjLrKZeJGJEV581EVH5ZdS1pT6CeG0rQbw2bKtkzWO8vicdaH2bq+b8GCcySdr2
         c85/KqCM20WyNSvmsWw1sj3sFPjbGXOBN8E1L6LPkiSXHD4Lza/zuT2eXUmd9cTVpSa8
         eP8YzLf3GJC3cZgf/LQTHslnIvuz8h7gG2dJk4TYghAUfiuTTNXW4dAiysx0wI3EZroj
         AfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763075663; x=1763680463;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5/UTn8bTtJTVg4Qd62Iha30XVgFf5+QbZgjq/H2S+M=;
        b=KYnGdaIRN5R2UtnUC8iWff8T7opxQEa4f1VJuLxlyKI8Ve17qxMM5NX9KK26h6+3IT
         1ad98sODZtplYZ6noBLE2xEWXSi9b46iDh++en2EK/lNYOGwznCsfr8b7iwzaxlH1Mnp
         oB7I2qzlboLJ9ZOgvdXn4XBgUnt1fiPXexWMDLfNJGJTZ/9Alr6A4UNm1nZ+CP+sai00
         5SI6ikea6nn1zYnDpa9Ktec1J2gznDocoxx2uceLoQ9TI8Q6sTc6ae4nSZNsETp5pivr
         3x9vu+OHTnMOIHeIaR8FfxoeuN24gd1teGdWQ2aK8tutRtJyZ/0O/hyADT1VarAwM7pB
         z2gg==
X-Gm-Message-State: AOJu0YzT/YztgVXHnyyN4BXUEmfAz9PtM8LH2LIg+y+uV7/0OWAes72P
	UF2d9J/CYx63QMJjeTK59YXB7qJNGbgEt3p2eG73JtDPWwZfW9QnZSQybpYTZBE4XKRgTEoJ6rS
	f/DU2MQ==
X-Google-Smtp-Source: AGHT+IGNgmeFlzSISc40y3tWMWrs8kvowjPqYMHL4csER25f6Rt+Kd7D0+iRgGX7761r68Kab45/rCMo2Og=
X-Received: from pjrn4.prod.google.com ([2002:a17:90a:b804:b0:340:ad90:c946])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3806:b0:340:5c27:a096
 with SMTP id 98e67ed59e1d1-343f9e92a24mr1035029a91.6.1763075662950; Thu, 13
 Nov 2025 15:14:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:14:15 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113231420.1695919-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: SVM: Fix and clean up OSVW handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix a long-standing bug where KVM could clobber its OS-visible workarounds
handling (not that anyone would notice), and then clean up the code to make
it easier understand and maintain (I didn't even know what "osvw" stood for
until I ran into this code when trying to moving actual SVM pieces of
svm_enable_virtualization_cpu() out of KVM (for TDX purposes)).

Tested by running in a VM and generating unique per-vCPU MSR values in the
host (see below), and verifying KVM ended up with the right values.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9c2aa6f4705..d8b8eff733d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4631,12 +4631,20 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
        case MSR_AMD64_OSVW_ID_LENGTH:
                if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
                        return 1;
+
+               if (vcpu->vcpu_idx == 64)
+                       return 1;
+
                msr_info->data = vcpu->arch.osvw.length;
+               if (vcpu->vcpu_idx < 64)
+                       msr_info->data = max(vcpu->vcpu_idx, 8);
                break;
        case MSR_AMD64_OSVW_STATUS:
                if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
                        return 1;
                msr_info->data = vcpu->arch.osvw.status;
+               if (vcpu->vcpu_idx < 64)
+                       msr_info->data |= BIT_ULL(vcpu->vcpu_idx);
                break;
        case MSR_PLATFORM_INFO:
                if (!msr_info->host_initiated &&

Sean Christopherson (5):
  KVM: SVM: Serialize updates to global OS-Visible Workarounds variables
  KVM: SVM: Skip OSVW MSR reads if KVM is treating all errata as present
  KVM: SVM: Extract OS-visible workarounds setup to helper function
  KVM: SVM: Skip OSVW variable updates if current CPU's errata are a
    subset
  KVM: SVM: Skip OSVW MSR reads if current CPU doesn't support the
    feature

 arch/x86/kvm/svm/svm.c | 72 ++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 28 deletions(-)


base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
-- 
2.52.0.rc1.455.g30608eb744-goog


