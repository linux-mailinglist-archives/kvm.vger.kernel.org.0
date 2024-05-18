Return-Path: <kvm+bounces-17719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B797C8C8EBD
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 02:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 431181F2240A
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D86ED502;
	Sat, 18 May 2024 00:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="102onJoX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BC96AA7
	for <kvm@vger.kernel.org>; Sat, 18 May 2024 00:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715990681; cv=none; b=DTQJ7yY43xzHAsjw5QCI/BxXEuQtDdJGrTr304RO9t7hw4EtO09N13luqRqjzx7RlwNcvM2SuXUiZUBVHbMRONlKaATY9Sc71fXwiCXkHdhPWtQshJl/qSdCB+BKTWU8LgJOV2I5AJnENSSGZ9irDN2P+QGJa2AsDOgkjsLCSSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715990681; c=relaxed/simple;
	bh=ZZiN6+e15dQN6MMssxaWW8K/IugjsD8kYnxv2JER8Sw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=en18kTSYJL/8kyimLB/HXRPP1UG8ibnRciUc7W2Lxz82QDCfHDwy2o8tg9mfOEMB4IB6cMbGYRPoMqWnWETjVjIFDbuTb6BZGq7zuRsB5BXjY+mi3UZPEhy7s/gncdc5VoI0tQABCbX/AxkQFTILObCsrI1/HFFQG3qtRZQISmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=102onJoX; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61c9e368833so185864897b3.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715990679; x=1716595479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=55Fpx2MIulH1TJ9s55duhi3yhB4vtlMWdhuL3vC3xBQ=;
        b=102onJoXcHKtnZIhIvcFD1NxbGYQaWUDYwUBOb5zjT1Twet3+CU98Ozq1ygilfSclm
         jQDpux1E4rmrG/gGDfrDilnBq5eKZIDze3qjoEl+DhEWMVCMcDAr10IIwIyF8GF9qnym
         kNZ282emV3bX/dsjxsY8mg0QcuSBfpl+gYKVMa9igy1P6WiOCqfeiL5UoDcZ8JGvLnk5
         2grc237SlimHtbE4VJtygDVbWF72+4G3rx83003OVjI5XVwe1xPBIZ27hgTNwacnWW+p
         j9fGSgJBc9fXyvQb+6Sd7T2q3LHl7CaxlJKCXjDEtshat1K96p1gHRb5j34y0zSGYE8c
         juJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715990679; x=1716595479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55Fpx2MIulH1TJ9s55duhi3yhB4vtlMWdhuL3vC3xBQ=;
        b=FihH6R5mfE3btHkYyywSeMByqKpAVUfoLBqF7Uqo1QrzSxOCKSva6P/U6+2djKwXkt
         sC0HLBrLYTFB5ZY2dKok7X/jL3rmgHA/giI30FXO5MpGCRKvEH2i4KouWCS86sWhCgR/
         S7tepS96lGb4S89uIfwOY6Kyew7IQ4iOuAGqenwTKRpbKy5u30hjPji72Kwwkoh2tKr7
         UxEahq3jTILddlW5i7w1+DMhqri1Zm8OYwkOweLsLJ5YP3SUQJczeBQhYCVE7sGdUXb0
         2/UxfXruJlIDbnaigSSWSb3JgRTXPA19qkBLg13A0LfHLT3Pgup2BiGZU8l8tSbY6xT0
         snqg==
X-Gm-Message-State: AOJu0Yx0VQpObSHl68r0DE8T2KK37ey6LAGiGJMAgI0/2DE7q94Y87o8
	LwgmeQ/hUuQgjTKnKi7kiC/O4gP1kjK1gjQiC2VUQ8GAeIZZprZAPE/PynjmdVcgbuAQWzukz3q
	yYA==
X-Google-Smtp-Source: AGHT+IFiVlGymQzpow3h8j4sNOJKTfw4H5KxXwAelQPEmYeQwtXrj3JO1q9+VPmJJ7oNI5OfSrZMzmiPyrA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:338c:b0:61b:ea08:111f with SMTP id
 00721157ae682-622aff9d4cdmr58113437b3.6.1715990679473; Fri, 17 May 2024
 17:04:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 17:04:23 -0700
In-Reply-To: <20240518000430.1118488-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240518000430.1118488-3-seanjc@google.com>
Subject: [PATCH 2/9] KVM: nVMX: Initialize #VE info page for vmcs02 when
 proving #VE support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Point vmcs02.VE_INFORMATION_ADDRESS at the vCPU's #VE info page when
initializing vmcs02, otherwise KVM will run L2 with EPT Violation #VE
enabled and a VE info address pointing at pfn 0.

Fixes: 8131cf5b4fd8 ("KVM: VMX: Introduce test mode related to EPT violation VE")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d5b832126e34..6798fadaa335 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2242,6 +2242,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 		vmcs_write64(EPT_POINTER,
 			     construct_eptp(&vmx->vcpu, 0, PT64_ROOT_4LEVEL));
 
+	if (vmx->ve_info)
+		vmcs_write64(VE_INFORMATION_ADDRESS, __pa(vmx->ve_info));
+
 	/* All VMFUNCs are currently emulated through L0 vmexits.  */
 	if (cpu_has_vmx_vmfunc())
 		vmcs_write64(VM_FUNCTION_CONTROL, 0);
-- 
2.45.0.215.g3402c0e53f-goog


