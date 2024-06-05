Return-Path: <kvm+bounces-18962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E85B8FDA48
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57D39B213F0
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDA816C865;
	Wed,  5 Jun 2024 23:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="phFCmQi0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90A716938D
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629570; cv=none; b=eIupASkCIeTShwyXnC6kwUEIt+D6J1ablSu3/CPg8ytZnbKgw7PfNNp+QBf6JrpMwjtHh9Wz1x9ldGoCUG26b31c+5MSQNr1qTeHPsqxojr5rz3ymSFXayTXcRMMyTbdtYlDu6H2mwnTRG8/6CT/3spLlx6v0LVLAiSqOJTOTX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629570; c=relaxed/simple;
	bh=vtWhHR8rCipCyVzNAFOmF7RFYT1AytVFYLp9pofdaVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xx3PKUliKCFB4ZQh1f+5GrKL1je+YAZm+/dIECCrgPi9AncbdPLtEEJSLDl54BvHTKpZole9yu7N4iu+OuAQtDptKkIhbjeKH72MUQ9ANo32cL4fKIJHiQgxR7hk+0yFnYXi3NsrMVEefXqgSSyQyW89TJ48k80wD9NYrT3cP5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=phFCmQi0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62c823393a4so3790227b3.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629568; x=1718234368; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JbnJv6vDpUrRyVZhMkImU0pEXY4NZDKxZhfl/r6eM3A=;
        b=phFCmQi0I2fG8dYIxhSk0AHuYzfInmJ7fL0WE6PpVzInR8vPnRggesC1fbk2YnOEKx
         yGDorjR4+5LZn54eeXMqwTTzazXMCj55T1RScmcGSG+cJVFPHL+5eLMoOJMs7WgoLAV6
         P+Uqp2ejQpu6yIzuQJcOgQH0ilj61FiNBSIkyw3zBJ1HSfVF9HU7fFesVjFjSwOOFOzV
         EbXv3okpj3yuct4C+fiQRIkDfYkwiuDi8NFl6y6dWghVnHK5d2aRSoUiX8fBaNICp2IN
         JnQq3fABiLI882wlWACKY3tOvC6GIQ7h+aI344P5a02nTLY7jzGAvAHkch6HuYgrX4kW
         5GZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629568; x=1718234368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JbnJv6vDpUrRyVZhMkImU0pEXY4NZDKxZhfl/r6eM3A=;
        b=ANLBUfAwlxJ0MzxTJ3vTT1InO5nWblk3B2HJEnA+hsEpnYs5OGoDGRt2ACD2cBtav1
         Iz87t4h0JkCvseGf5c4h+dKL/PyubvsfO8rnAghj1myvAFAbYZBZ8CLZY4H/CQXu6YA4
         dU+GJkJSfdIgm0ncol4vAH2zC6MVBu/xzecnD8rqfARHMFcBKFh92IS8wSVvQFL/1Hak
         GuL2lxjLVhbgGwpS2BSlZtOmKlZmE63ZrETTgvLjWR7CxP1eXti9jly1s4Qhs20kjpHl
         Sd0dg9Rjjhkcp6IF8yCKFkuwiLm6jwAKmZ6IfrFeWa/7AwZ6/w5rjUUkIb7fmGxTMJvb
         OfcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqA/01a3kkAimGt4eiR7MVCGZv4UkUHUrHU6yOpISugZRsARSKkaPonISJzGarXafUPpk86POtlKAX7GeBPuyCdYKK
X-Gm-Message-State: AOJu0YyTCKgkjR/jLwnDuTL7oMcJTr3aLcPcq9Sh1ZMP50Sagis1nC/0
	cq4bjGqwGj2opkTTieu33ItH3z9ONAcKqgyj+Z+et3ygiQEAcWEPdec6ryCh/cj0BmCdAbHcsPn
	qPA==
X-Google-Smtp-Source: AGHT+IGT3X5M7VkVP46RRq6pl4m8P42cLEg9GfqDkINN+MTO1zovJ38lv62i90wYIsCXK1EryfZOAVoe7p4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:10:b0:627:a671:8805 with SMTP id
 00721157ae682-62cbb4d8986mr12338967b3.3.1717629567792; Wed, 05 Jun 2024
 16:19:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Jun 2024 16:19:11 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240605231918.2915961-4-seanjc@google.com>
Subject: [PATCH v8 03/10] KVM: x86: Stuff vCPU's PAT with default value at
 RESET, not creation
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the stuffing of the vCPU's PAT to the architectural "default" value
from kvm_arch_vcpu_create() to kvm_vcpu_reset(), guarded by !init_event,
to better capture that the default value is the value "Following Power-up
or Reset".  E.g. setting PAT only during creation would break if KVM were
to expose a RESET ioctl() to userspace (which is unlikely, but that's not
a good reason to have unintuitive code).

No functional change.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4157602c964e..887d29db0e05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12226,8 +12226,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
-	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
-
 	kvm_async_pf_hash_reset(vcpu);
 
 	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
@@ -12393,6 +12391,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!init_event) {
 		vcpu->arch.smbase = 0x30000;
 
+		vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
+
 		vcpu->arch.msr_misc_features_enables = 0;
 		vcpu->arch.ia32_misc_enable_msr = MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |
 						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
-- 
2.45.1.467.gbab1589fc0-goog


