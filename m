Return-Path: <kvm+bounces-23119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB86F946414
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 21:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08E271C2153D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554997764E;
	Fri,  2 Aug 2024 19:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RvfoDdEd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB034D8A1
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628287; cv=none; b=eDDqZwRrQK6A9HpvuF6V2vT/7tWROzCNM4NDHPdutmt1CEdxCCg/g/cDCiF1DfT8ZjEy0lukhTUOP79y2HgM4FEh0pxFJEnFVghINZCMBkFBC3wJT+KPYfvehpz8tj85UwEw8PN1Rj3ulR50Nrwo5JrJk44uRkL2GRsyA5GFgxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628287; c=relaxed/simple;
	bh=zql+KU31olSPyMQGIOOmlA41hrQI7991hIRTrHnkF5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uCruVV7DrnwPznyLwk+dbUllvtQeJMyGTc1LIeBnf3rk/f5cPPX45ST5rwt5dgwJxWTMnDSIMOs7YQuxCGjogN35gf5E1etZQEhnwYDYCbrAWc7m3BLPWwQdBS+gERyurATtPjAfUAZoYCzoBbkV7qc9s0/6fsEMhySeINNn2zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RvfoDdEd; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0ba318b1b2so8600275276.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 12:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628284; x=1723233084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j3MDuI39zu1XA4gRdGvyMxqjMSntoDT90qhT0kUFZqs=;
        b=RvfoDdEdubGsBZqZvhW7Mwi2ErJo/qjP2Dc430keGlJ4PbjVJ+396w4eXSD62UNmt2
         WTJGpuLtEZJcKN0qUZF1J2e3l28yUH9j/TvNSDAtA843Z6W59goEPq8Kl60flLVuXCKW
         t1vaFZ6RArUF9ojfUtVUaKggx9Wz8T6gERL1oClnZD3FmuF4GED045x7NBdF3Ni07+Xm
         dUXCF24Jd43HLSqOuX8LS25M1UawDTHoZfSBdDR/Qq5w4et58tv84mPSVfvAzluVBwJx
         l0TGP1hVNtUJ+F9bC0hU2YVJykcivKxtTKQBDNlwynuYMN+Uv2HgCk0i6gOASzRkU+lu
         wbNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628284; x=1723233084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j3MDuI39zu1XA4gRdGvyMxqjMSntoDT90qhT0kUFZqs=;
        b=mEWx1s0F76izPJo/IgOw9DqgNY0p6XgZTKwT1gY2R23CHo6uWp/XY4LK6FA1le0cim
         9Txs4poJw2MV7zHHgD2I22QP/sR9NN3phwXcwt8Too8Lxin1bJStVjYtnTi4sPtIBzTG
         +NFQzjP8/7RxxxkJMAFMfW+wO8eAD/+kYlTh5nrlMBq7294AiOsX75xp7/1CQzilZbk+
         w4gRHaFZ55g+vH3OOEj54Tg0u4pFRzIP7LbYavKHnpC11mpSNWqvmCfJFw39pf3cKHHO
         9SRJwD2MetfpiAowrSirY79m/UR3CGvc5DUnmN7FA1woaPCaLCF3TeN0FY5hqT52PRPy
         U9ew==
X-Gm-Message-State: AOJu0YwyH/bvPhFf6ORn2zJlvz9pXCPOmARO2QeAX6IB4dZ5+LWHKfhz
	bGsj2q9uUtKp/LHXB6jCw2YtK71pEBxHyu/VUOBPyl8ZAf1rPzSdcq4eNp5OddXCcG3mxag+Cce
	Wgw==
X-Google-Smtp-Source: AGHT+IHXmtQ4fn/w4A9o1IxjByT19mNXJlLz8OGSPq2+ASik931Ksxoz9M3ugqUoQtYF2Bf10ojDjPLGf1M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:405:0:b0:e0b:f69b:da30 with SMTP id
 3f1490d57ef6-e0bf69be1bdmr634276.9.1722628284272; Fri, 02 Aug 2024 12:51:24
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 12:51:16 -0700
In-Reply-To: <20240802195120.325560-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802195120.325560-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: x86: Re-enter guest if WRMSR(X2APIC_ICR) fastpath is successful
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Re-enter the guest in the fastpath if WRMSR emulation for x2APIC's ICR is
successful, as no additional work is needed, i.e. there is no code unique
for WRMSR exits between the fastpath and the "!= EXIT_FASTPATH_NONE" check
in __vmx_handle_exit().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..cf397110953f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2173,7 +2173,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 		data = kvm_read_edx_eax(vcpu);
 		if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
 			kvm_skip_emulated_instruction(vcpu);
-			ret = EXIT_FASTPATH_EXIT_HANDLED;
+			ret = EXIT_FASTPATH_REENTER_GUEST;
 		}
 		break;
 	case MSR_IA32_TSC_DEADLINE:
-- 
2.46.0.rc2.264.g509ed76dc8-goog


