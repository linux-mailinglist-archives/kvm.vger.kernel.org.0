Return-Path: <kvm+bounces-16002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5898B2DA6
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 199B71C2189A
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5244156F39;
	Thu, 25 Apr 2024 23:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vGqvj1g2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97EF156647
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 23:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088398; cv=none; b=oQCtivBD8qCxfedMRBGpQx6XKY3+sndTo6GCsHachOvwNGw69vWvJpXcP+SmMhyb20U4ronJqzD05aH/IdlwXgNFHw7sdC8o+NQA3UYddVTEe9CUjSQW2coQU1WEXC7qot6po+E4EowYtEG6lYfDV6o1vl4I+WUBocIHlyVmvaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088398; c=relaxed/simple;
	bh=he1+vvXlMfNlWLI6LWMQzLKYVZpZflwhW5mVPorCCEc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iueGBs+vhvc/gQIYbKukrcMXEUd/aeKqb38NCAGqaHbdyT2ti2rDyeTq3KJ5ZpUJQ6CJgHxATZTGk0UEh8eTph8YEgSl2pVVqcri4cVuB4rt9ZNKqnyzShbFSl3q0C/WWz63DFAxE4YqVBwvuc3GSah2igtqCBWOVPIj4hDe2IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vGqvj1g2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a473ba0632so1923774a91.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714088396; x=1714693196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7egpFUZiACQcekVxaNpuXSMxIq5MtX0L1qRkEu6b+Fk=;
        b=vGqvj1g28r0yi8omBoWVDZSYadn4NwBO94etafOSxsNDHlikzBhtPH8oUwDl/Dymf/
         XlvV42jJdOpPfty+I0JTAWGMqQIfA4XdVt0NWsU+JT+cgbTWmQhiEkMFPbej3fHtqgat
         c6PQ6260cFlVDClHcxABDkNnIp11T6YcJAXVlz3lwIXkNZsEFtJWQd5hI35dfxlu2F3D
         mkhu0WtYquPSP3NbMOqU9H34TbD4PY3nDqizNNIezywfNfP8pkjJ2zkdlon+3VeaBui/
         yo537PRpBPfMiISELMEir2l29g0BWX0/khppyEa7ajf2CDwn9iVC4PDZQQ5YGMANB2fn
         naqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714088396; x=1714693196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7egpFUZiACQcekVxaNpuXSMxIq5MtX0L1qRkEu6b+Fk=;
        b=tprUcMOuvgZOc/hCSR9opT9LuogiNirOcmo2vLAMgUym1QercdqVRMsAhwvkDgApbc
         KWXt6Y2iAUl3BRAQn9O4uZnz/WYT9JZDVbNN+lcekKS14ptotIgqy0hBC3YZb14hIIky
         BQaSP5dbCoKgujYdnbN5IVID71CshuDBRb5EEto4TukPEVMOC1J5jwVPczCa+sn/U5AB
         v2D5f7s42uXfV8XbCkAof2yWQCxy0En/UwXd9fIDQnUUuXpwx0XjzdS1xzdl3lkD91eL
         tgkrpaqVgd5d3JbRWZPIyByAiW1AHBJKWJ1AaorQ0XGPMxJieyBcBjkjy9YoPa7C6ePF
         wgHg==
X-Gm-Message-State: AOJu0YxAOsWiznZC0kVlTNImKmICVQAK5vrxbmtPLOz3P2mVUN8KHM5C
	Utajc+QZA+gM9ZMlbcnEIMrLXUORjrcWyUz9XXyrPu3N5cCEv6zBhqw9areCikbwAgngZhTeFHK
	1Zw==
X-Google-Smtp-Source: AGHT+IFpNydi+RGS1Jthdz8Ql+lk2sE6LKmNRcPrMcbtOYRSnA4O+O1tBGwgspj5RQ3J5mqE4DImMHqS6hQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:89:b0:2b0:25b6:6d44 with SMTP id
 bb9-20020a17090b008900b002b025b66d44mr52334pjb.4.1714088396018; Thu, 25 Apr
 2024 16:39:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 16:39:48 -0700
In-Reply-To: <20240425233951.3344485-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425233951.3344485-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425233951.3344485-2-seanjc@google.com>
Subject: [PATCH 1/4] x86/reboot: Unconditionally define cpu_emergency_virt_cb typedef
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Define cpu_emergency_virt_cb even if the kernel is being built without KVM
support so that KVM can reference the typedef in asm/kvm_host.h without
needing yet more #ifdefs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 6536873f8fc0..d0ef2a678d66 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,8 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 typedef void (cpu_emergency_virt_cb)(void);
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
-- 
2.44.0.769.g3c40516874-goog


