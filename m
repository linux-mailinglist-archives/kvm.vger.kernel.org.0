Return-Path: <kvm+bounces-13775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D5E189A7AB
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D20A51C214CA
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D32524D9;
	Fri,  5 Apr 2024 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YjM4qu6B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013914D9F3
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 23:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712361377; cv=none; b=FjxQWiepTo6ogpPYiBwLtW+OJ0Jz/B8Ala0qIXNt9V0pWcy78DHhhBAjNHAwTs8TeEXofxyW35jJCx/JRMMwgTMi3m34/cfnq7Rbk9P1G9L2CRoR/kZfmF/flaKxvf6oxJYuAVrVQoqlM90qSoCPQC++AsaJ1UHu+XHd699U3Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712361377; c=relaxed/simple;
	bh=torl8B7uqungrFtG8/K2MGtZpZ3nwc8GBWa8Ngm8w58=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ESvN+zYtKER276kVYph6vxOkW39M9uKfXqZ+XP+M+xk9bC071TQEtgkW778PQnD7C6I+4oYSi3xr6WTrkn3cBVi9RQXTLbCLZJLefzf1qIZSEx3cTxziVVwdtt1jeOXobouJFx3fm/KzeCw2nFnd7KY8hrQxSB/hf7u+HpA7ESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YjM4qu6B; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1864239a12.0
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 16:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712361375; x=1712966175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=33EqBa4idiXBlKLk1bB/GrgkrHxm1+OWlCnF+mCuARU=;
        b=YjM4qu6B/aBJINhFpoKfYsuPWqCMVqcrTH5fx8t4TMv9AdtFh+/Ypx0qNqXS+M5PtQ
         5UGZxAmDheyelzx0x77277dHpSgHxQEIeVAkmuvRv2XRsSovDySxorN1UYqbcGhjruXx
         SNsyPz5GES0JqsBq7dThm+1PO+OS8Ud5Bw5Hjr8dEAtv1t5BdMO2Z4Anu4vymuwbMO3J
         GVZC2RqEdOuBbcH6yf0scaajChowARibphLngvTRO3es93MtS4KkL6Nm63hHoX7P94KC
         QwyHr3rY9hRrR+naFKU6FKaEtZ1uJEW2BaBsFnAdxFd9Z/2P0JvpVJN+4BGrUwH6H8rY
         FiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712361375; x=1712966175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=33EqBa4idiXBlKLk1bB/GrgkrHxm1+OWlCnF+mCuARU=;
        b=On7lhG1X6MRUVKbZVumXGxz3oC2Oh+U7ZLMW5v5CH8fv6/nnVYj4BDxiv9PZ4qutfR
         Te6Axjh7xP6pih4p6S/IXeyzhl/laeZLds9dJGxvjQ69MEUHqt3ytzRc3dE0deWTuvd2
         d43IvHvqyBbP+6YKXRwYSHPCmv+izvpL13/WY/KePNOvnsoY69F2AEXcK+hgIuUDCEjw
         HzOgmp3rlJx1MCNM6ozU9+6ZfH2WEK2uqoS50PWLNs2jH3kM64rgRNE+LC+Cnondbmlx
         aTHva+8EF0DRWEj961qNho8Z3LmFlg+P1FhtfCc5VLnXEhOOpBgcLmwnrna3I+rUzKew
         6JfA==
X-Gm-Message-State: AOJu0YxWG5MYsdg/xbrW5IfOqpCJbiFqC9vADI4d9v3xPQv++4D6fVZz
	acpZhvq+HRXTsimvp30gLs8ruHbcwYWfepbgHrC5BimVRtcFPyMr/SVEmLxYU/Nhs3oNcVatR0A
	MGg==
X-Google-Smtp-Source: AGHT+IF/gFn9ejmWPWLzczLWx54pSx+kzM32Cqmgdh9HBzRcO6XJurThB4YInPhTEun/QvpjJo/Q33QHoJ8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6a50:0:b0:5e4:2b26:960a with SMTP id
 o16-20020a656a50000000b005e42b26960amr12959pgu.4.1712361375228; Fri, 05 Apr
 2024 16:56:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Apr 2024 16:55:57 -0700
In-Reply-To: <20240405235603.1173076-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405235603.1173076-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405235603.1173076-5-seanjc@google.com>
Subject: [PATCH 04/10] KVM: x86: Apply Intel's TSC_AUX reserved-bit behavior
 to Intel compat vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Extend Intel's check on MSR_TSC_AUX[63:32] to all vCPU models that are
Intel compatible, i.e. aren't AMD or Hygon in KVM's world, as the behavior
is architectural, i.e. applies to any CPU that is compatible with Intel's
architecture.  Applying the behavior strictly to Intel wasn't intentional,
KVM simply didn't have a concept of "Intel compatible" as of commit
61a05d444d2c ("KVM: x86: Tie Intel and AMD behavior for MSR_TSC_AUX to
guest CPU model").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ebcc12d1e1de..d9719141502a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1883,11 +1883,11 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * incomplete and conflicting architectural behavior.  Current
 		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
 		 * reserved and always read as zeros.  Enforce Intel's reserved
-		 * bits check if and only if the guest CPU is Intel, and clear
-		 * the bits in all other cases.  This ensures cross-vendor
-		 * migration will provide consistent behavior for the guest.
+		 * bits check if the guest CPU is Intel compatible, otherwise
+		 * clear the bits.  This ensures cross-vendor migration will
+		 * provide consistent behavior for the guest.
 		 */
-		if (guest_cpuid_is_intel(vcpu) && (data >> 32) != 0)
+		if (guest_cpuid_is_intel_compatible(vcpu) && (data >> 32) != 0)
 			return 1;
 
 		data = (u32)data;
-- 
2.44.0.478.gd926399ef9-goog


