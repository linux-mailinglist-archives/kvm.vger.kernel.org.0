Return-Path: <kvm+bounces-8499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6197F84FFB8
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92C111C212BE
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCCE3D0C1;
	Fri,  9 Feb 2024 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GLAyxBTW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D863BB30
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517031; cv=none; b=ezZLHTNklCsx4g4uCuG/L/OKX0/QB9DU+Il36oD+c6/Yf5f2jVv+9gMqGEXhCn6llXm5igoAXganN+JdDlO4PNMHYW9zwaggSJQcohbYfV01OLrgukl/qVYZnmmiqLGTk+Trim+0Gy8fIMRcfWbAC9DDW0tc/ZrkuVlhjjOe2kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517031; c=relaxed/simple;
	bh=5ROcmTVvSgXvIbGuiN/CZtA5rWbe5pIknCwUED8ic5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vCdEF5RxzvS7gnFtFUaDSFak9s203S36V+m1xoOBKh9dn+x9VXqUikaCFn3t7Ufm2P3Z5OwDw/JKzvjOgVR5NDL5jH3021dEr5h5hg6WMf2aAGAwNU/008cj4ZC5oNuaXTlZRAxu0u6iuGCB/hwSqMLK4Kd+Q6i2FPw90Rxr9eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GLAyxBTW; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-604a1a44b56so22449537b3.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517028; x=1708121828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xriXj5ETw+SM6HIrjBhtRYR+FpAUxlK2qVu7eV3/IuU=;
        b=GLAyxBTWGWdBIiHRzZZ2cDdHVFRWzPWB0gVp6BnC9IrZBal8Uom1oqFhpI+RXcY6cX
         I+iz04yAbfy9jFA7RMYaSJMP1h1uw1jE+d3N/zVMVfFoh2yV0WL5zJw+vBIhc9XANZvb
         zT1igYLPYy1oqbKNCf9NNkTNTyRBJRtVONL7AVmLMNS4UGi1Pxhq77N9UEzHsyeey99s
         5oIuiN2nilmffCHvWblbG2yfFPopqqu7XgCaYn8QcjEdnQqwuj1Jf62Fg20DMP2iW9tN
         ZK5gNr+mZbtg9/HAKOuiCBkd6qR0G0gTT02qUbRcfV1IQRIocC0UfDTJJt9GPN2pbzeJ
         3Mhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517028; x=1708121828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xriXj5ETw+SM6HIrjBhtRYR+FpAUxlK2qVu7eV3/IuU=;
        b=xATNLTwv5i2KBnecxf76DyKhyWNx3Foz1yZaO+pjdrexfV5Dxbl5HRtF8oLnp1ymiB
         uxHoxfb2eLoSRN66Ar1jlC8pVkU8i/P9yS5W77JVaZXdCBz7umV9PeYtrwbi2fTrNgXc
         +pSoUFIJ1Km5Fwp08qXZm3QaCUNYBS9RQrYoANFuxIQFQM/wdgJIRNRUE5vAzXY1C0Ff
         bc4PLJjcjtfOXWDdHlr/4tfOyNFCM/l17bOseGd3OSpwyxa5TjQ7CwzpZlhO5mWL4VcN
         bjW2R1uW+fP7fO4ZCKov0NoiG/q/1cKt7IsQb12B82DU7oNPv2725ra2XALnF2yCmOs9
         KKqQ==
X-Gm-Message-State: AOJu0Yzv3WJKwhuI+iC4dGAc9DOzEDbZfu95Vtaw+LJHULhJVodGgBQK
	CzWpOSQj87Gjri7WovrOYpnNFbnoGaltRO+UQ2xqh/4ox2Cogkgi9Ap7tElYQzAeFnsmHMFT8GE
	GVw==
X-Google-Smtp-Source: AGHT+IFBb4C7Le8Uy1i1H/KekvmVJQcT8a1e7ObuqcVXCQx3MQ2cKGmrti4S38CyLF4p9XbPUBMPk0eKB5o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d82:b0:604:ac3b:75d5 with SMTP id
 da2-20020a05690c0d8200b00604ac3b75d5mr123597ywb.7.1707517028741; Fri, 09 Feb
 2024 14:17:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:17:00 -0800
In-Reply-To: <20240209221700.393189-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209221700.393189-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209221700.393189-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: nVMX: Add a sanity check that nested PML Full stems
 from EPT Violations
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a WARN_ON_ONCE() sanity check to verify that a nested PML Full VM-Exit
is only synthesized when the original VM-Exit from L2 was an EPT Violation.
While KVM can fallthrough to kvm_mmu_do_page_fault() if an EPT Misconfig
occurs on a stale MMIO SPTE, KVM should not treat the access as a write
(there isn't enough information to know *what* the access was), i.e. KVM
should never try to insert a PML entry in that case.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4d0561136e70..29df186dac84 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -416,6 +416,16 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		vm_exit_reason = EXIT_REASON_PML_FULL;
 		vmx->nested.pml_full = false;
 
+		/*
+		 * It should be impossible to trigger a nested PML Full VM-Exit
+		 * for anything other than an EPT Violation from L2.  KVM *can*
+		 * trigger nEPT page fault injection in response to an EPT
+		 * Misconfig, e.g. if the MMIO SPTE was stale and L1's EPT
+		 * tables also changed, but KVM should not treat EPT Misconfig
+		 * VM-Exits as writes.
+		 */
+		WARN_ON_ONCE(vmx->exit_reason.basic != EXIT_REASON_EPT_VIOLATION);
+
 		/*
 		 * PML Full and EPT Violation VM-Exits both use bit 12 to report
 		 * "NMI unblocking due to IRET", i.e. the bit can be propagated
-- 
2.43.0.687.g38aa6559b0-goog


