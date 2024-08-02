Return-Path: <kvm+bounces-23110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E598A946370
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 887CA1F23067
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2069166F2A;
	Fri,  2 Aug 2024 18:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xjWyUzkZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EC3166F03
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722624925; cv=none; b=Ras0nVOn6smrQQj8C1sHck4Sn0xi5vJBuWsfTd/zSCZPPU/1rXqbdjrK5Wx3QVnLSCOkHlvKfQ/YuvWhxKFOtMWJG33b33jKKV3bdWl4m4sV9er519qewHilakz9j4BKmxcXr8YgmlPdiJTxsgLj3qMUtYacwvq0j2uSgxC6i/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722624925; c=relaxed/simple;
	bh=kjmltdsCXgKPMkW3IMsblXwYB48Jaerc0S/NQl7JwnA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HcYeFs6nNEbK+JL9NTEG7gSF0tB084BGHT5/73oMNW6TQYF2OC1puopJWwBGMmeD0wk7WQcQvs6meT2OMQf99fT4JdxbHjLGb6ZApPkOS86mEu3seQT3auLk6vSJcgjLptSz7XcuwcqFZru2VUwFIgkTZDpKHo16VPit7HvYhgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xjWyUzkZ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d1c8d98baso7685969b3a.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722624924; x=1723229724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=we0IZnPi8qUdBH21Q34g43aYFvRsaJnFKoOJjzQh/Cc=;
        b=xjWyUzkZNKxNtn+r2nW2p9Bsf/fIsdIwzcjl37OTGwZJcnW8v4FNXoaK7g4GJXFktK
         w81tDg29tOA0sS3NnLeqcL8HfJ23vTiwvZRdjyTYgM1/N6PkT7Eu/0wL49VvvozmJuIy
         igE25Y8h4D3eIcePUzjekGlUeHoH5SA1eB2sKyGKC88qOxkHSai0TzW+Lj+qxNNcQtIY
         Rw/iQQPaTPkTqdxvSTQ4oTv7acxrAOdT7QsOCKKhQWbHoLmIfT1gX65TnuAFYwsuE5wP
         P2fbEwvXuFPj1+cKpYaPuNzbt9eKxYkiSEvv1vjf95RgTutYcQhrg0UIsv+CourmxOpi
         R9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722624924; x=1723229724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=we0IZnPi8qUdBH21Q34g43aYFvRsaJnFKoOJjzQh/Cc=;
        b=uxbR7bJMGhBqKJjdlUqRFkwWpomeNgMUNjyVucVDifXj8OUx15sawB05VaR+M4IFKW
         JvuJT+oqc+yTI+5kgB3hZMshZD2cQbjOBccilV1h3ds1q/8xWqWWFNtgntDZ407oFVMB
         WMnbFX6EKcs7qnkK6rFkIKZKjEobX42F5y9TOwO2en2zs8/BNrJeWCwv1X2JieLoudK1
         9ycAacUPoMwgc/CFJBhQCsrJDCslACxV33oFkz10HU6FECghIcWR4ENNjsDI82RbnoZr
         4CafJvWdda69vdpjQJ+JoSYup1QNUbUsp5YZWIGYEyTJ5uRU/uy9jR76TU803QNHN4Ut
         P1Aw==
X-Gm-Message-State: AOJu0YyP1FXo770lM4HquhOfTa7qOSgtk67d53D/1TmFxscYSq61ioJD
	mIvZ+/owLLGJcV4uQqhq9IPj2XdACI4Ug/TXWQg9KvAZZdT2HsSUEAWMr2sp3RNnK5rAU4r1KIV
	3Ig==
X-Google-Smtp-Source: AGHT+IEiVUyg3cRTenUl1DMYkpNViP+8/KEgruSIT0O6BErR/eJJeNw48joChrB8Tb77n+YwJBdtgeqOjr8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f0e:b0:710:4d08:e41f with SMTP id
 d2e1a72fcca58-7106d08296emr34497b3a.4.1722624923625; Fri, 02 Aug 2024
 11:55:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:55:06 -0700
In-Reply-To: <20240802185511.305849-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802185511.305849-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802185511.305849-5-seanjc@google.com>
Subject: [PATCH 4/9] KVM: x86: Reject userspace attempts to access
 PERF_CAPABILITIES w/o PDCM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reject userspace accesses to PERF_CAPABILITIES if PDCM isn't set in guest
CPUID, i.e. if the vCPU doesn't actually have PERF_CAPABILITIES.  But!  Do
so via KVM_MSR_RET_UNSUPPORTED, so that reads get '0' and writes of '0'
are ignored if KVM advertised support PERF_CAPABILITIES.

KVM's ABI is that userspace must set guest CPUID prior to setting MSRs,
and that setting MSRs that aren't supposed exist is disallowed (modulo the
'0' exemption).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b52d8f3304f..dbb5e06ef264 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3803,8 +3803,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.arch_capabilities = data;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
-		if (!msr_info->host_initiated)
-			return 1;
+		if (!msr_info->host_initiated ||
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+			return KVM_MSR_RET_UNSUPPORTED;
+
 		if (data & ~kvm_caps.supported_perf_cap)
 			return 1;
 
@@ -4263,9 +4265,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.arch_capabilities;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
-			return 1;
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+			return KVM_MSR_RET_UNSUPPORTED;
 		msr_info->data = vcpu->arch.perf_capabilities;
 		break;
 	case MSR_IA32_POWER_CTL:
-- 
2.46.0.rc2.264.g509ed76dc8-goog


