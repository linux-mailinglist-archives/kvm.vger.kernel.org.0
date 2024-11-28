Return-Path: <kvm+bounces-32660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C21EE9DB0D4
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:36:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 853CE281F64
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB1314A0B9;
	Thu, 28 Nov 2024 01:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZFJrUHej"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14BB1482F3
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757690; cv=none; b=S/pw4u9t/3uLlsgujKRLqSKzWJhgF+LPQqo8gxN5j/zPYUxU2jdSYRPxfhP2JDD8Kj1GmUtLranZ36HX5+p5cA3zvYuWfQso8r2cXBEnv8cary2Xvx5yOL9M8QzH/P0WocN7M51SYVhzdjj3iN5f/2c/1nT+Sz8o4yO/oPpKjrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757690; c=relaxed/simple;
	bh=Zi6nLxvCtqg7sRDOs2S1uLN1ASc4dep+KLdJOASySug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XsIByk3TReEeZtgS8g0+tFCr9IxJDO7UYHRBnphKrW2rSD2LH0zsFKh4DvBK4ZSvhXvGaq69LQA7SPcdaMbdnE4M6/e/psdl1QxEzbl5/sTEoPWAwroOoc5l7lTFUwGjYFwmOVawi9uOLL/ufJAMb5SNGd+lGaPywDscRlCYjBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZFJrUHej; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d4dee4dfdcso166395a12.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757688; x=1733362488; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=imzmUI4pwQd0UqeKMzmq2IeaU1wm8Js0tpOStaLC/Qo=;
        b=ZFJrUHejVILf6u/DVmbe5F9msgvE3HIzxoejbPPpD8Y51fg2D1tRYuU5xqjF8vsiMc
         78/DSnhkaUEELbqqtPtDrCo3tA3wSYRNpUJB3oU1Si1sniJ+JxP4jBf4+ewivG37mQcf
         FPeFo8QWbsuPjyiGGesqg+lrWggZONOxCOvo+5mWJ6Qpmhk2VdTMojcfvjKMiiJRm2sm
         E3xZSPYrdwTpzeTLH3oujK4LXw7yPYN8jnZN+4dP15UJLWMsK2qYOg/8sS/ggJuEx9TO
         isvpUNHEz48WZD1am3H7ibYxza0hGRam8DOJU9JppMWUZV7WEpd0yy6Zo/zSwua/eM84
         SLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757688; x=1733362488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=imzmUI4pwQd0UqeKMzmq2IeaU1wm8Js0tpOStaLC/Qo=;
        b=A16FAZg9B1mI6O6KkJH/gPlkkanogCGVaLFADCUY5H7HEeT7/5HESZQ07iFjHSFVc5
         CuExzZNgNHQ8b2+nNxlYX7Q1mW0Io4lp+UCHM8AFY4Ooo8t5GvBK5ZKs/niaFIjK+dH9
         PvflWd+Bo8cdX45QdySmbRrPPzYVa43ksdza2Ak0WXvcUdCSsp0vcBWw39I9y0oo1aSo
         X7951pnkKSzGZnCAm17nPLhdE4FBopb+Pf9nuCLWVPZsRWRoYpXZ1W2r4KTPYZC6HKCw
         pDd5otVk5UNTDk2R9BXJ6SaqPz3JMwGvJOCBVuPGN409MkmRvdqJloArGQPn9Qd6qwKT
         gN0A==
X-Gm-Message-State: AOJu0YxxvqypD7+YaYrr5v6SKSSAcLqIf7BeHhf6858YG2R8RbtGD5au
	sR+qeEUJ7v+QVEOpKa2B+9wQ+FUdcYlXVNqVZyG3cYCMmiKFDwDF8gtXgjxjkOHaxjHrKZgi74N
	N6g==
X-Google-Smtp-Source: AGHT+IHaM60Lr29ZkEqvcH1kdwSyGKEW3crO+fz+1pKWqPQXY9T6XKATriFjHO+n6jho2+7tLHiRqiLxy1A=
X-Received: from pgbfq20.prod.google.com ([2002:a05:6a02:2994:b0:7fc:2823:d6c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3291:b0:1e0:dde9:f383
 with SMTP id adf61e73a8af0-1e0e0ac69eamr10098846637.4.1732757687885; Wed, 27
 Nov 2024 17:34:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:36 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-10-seanjc@google.com>
Subject: [PATCH v3 09/57] KVM: selftests: Verify KVM stuffs runtime CPUID OS
 bits on CR4 writes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Extend x86's set sregs test to verify that KVM sets/clears OSXSAVE and
OSKPKE according to CR4.XSAVE and CR4.PKE respectively.  For performance
reasons, KVM is responsible for emulating the architectural behavior of
the OS CPUID bits tracking CR4.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/set_sregs_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 96fd690d479a..f4095a3d1278 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -85,6 +85,16 @@ static void test_cr_bits(struct kvm_vcpu *vcpu, uint64_t cr4)
 	rc = _vcpu_sregs_set(vcpu, &sregs);
 	TEST_ASSERT(!rc, "Failed to set supported CR4 bits (0x%lx)", cr4);
 
+	TEST_ASSERT(!!(sregs.cr4 & X86_CR4_OSXSAVE) ==
+		    (vcpu->cpuid && vcpu_cpuid_has(vcpu, X86_FEATURE_OSXSAVE)),
+		    "KVM didn't %s OSXSAVE in CPUID as expected",
+		    (sregs.cr4 & X86_CR4_OSXSAVE) ? "set" : "clear");
+
+	TEST_ASSERT(!!(sregs.cr4 & X86_CR4_PKE) ==
+		    (vcpu->cpuid && vcpu_cpuid_has(vcpu, X86_FEATURE_OSPKE)),
+		    "KVM didn't %s OSPKE in CPUID as expected",
+		    (sregs.cr4 & X86_CR4_PKE) ? "set" : "clear");
+
 	vcpu_sregs_get(vcpu, &sregs);
 	TEST_ASSERT(sregs.cr4 == cr4, "sregs.CR4 (0x%llx) != CR4 (0x%lx)",
 		    sregs.cr4, cr4);
-- 
2.47.0.338.g60cca15819-goog


