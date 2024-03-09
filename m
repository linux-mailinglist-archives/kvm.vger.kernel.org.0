Return-Path: <kvm+bounces-11424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBDE876E68
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:11:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 216601F219B2
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5B62374E;
	Sat,  9 Mar 2024 01:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sY2Wr5fp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DE615C3
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709946590; cv=none; b=dhpZlpPSBvzWmQzIrcQFCk6lg023w9OEigSymKYpVz5dz3BSaydE+EAYSQP2d843e+zFyTHgNXL/sUbuWV+c/K+WBZ/Ai4bag3sKRdwCUI4P3pzuI2QZe46OuOPDGXzxmdS20WixqS69yUZMFmJTWpCHiJOC3xyzsqjNxgTABHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709946590; c=relaxed/simple;
	bh=j5KgXER4nINsShPo8aYOrG+wphwo2SK+yLSChO3NEJA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cjpREVL+KyejGSFr1142N8qA3edBlr8Mc9UzW5wHIdk//jfVjAhdypdSLRWBlbo9b8jDl5MJGGGzRsGTREsF5co3oYE2uaDzH9YObhX/KF0Z1/ckXEL01qLyqqFxOk0V7Y+7hwJ42E+bJoXjH5IZDMudTqym3o+yirb71NCLwrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sY2Wr5fp; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e67b55e508so26191b3a.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709946588; x=1710551388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=opv/pkYi5ZzIQaSkE1dFeCV7eMElrF9Hr2aQKt+M0LM=;
        b=sY2Wr5fpg09RPtdj9bLKU8/33TfK9+4kvMkg+yjdPXkBUOAGFSFwROK/zC3s1MaL5z
         DccWlFXW+bv30XCRIJI3T9WwVUNzT/i4gEKDrIn3WiGvPqUx+Q/u0KrgIlFtkHD26/n+
         iBi2U1gxZD19BXWxqQYpCEYxA+CEnsthMty2FBd/yYK/0mWSfQ+AKDHlefDP1W1rEqta
         IL5+m2rzJE8VqEiY41Cuwrtv5CmmUaDeYD7cy3scFSI7cuIuREvtoAw6WNhrwlnNURT1
         jncNtTiLsnVh4uMa9LsptlRB+fePoL32YC2kMAs1yzfVi359kwFgktidNQAdgnr6O+9c
         z+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709946588; x=1710551388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=opv/pkYi5ZzIQaSkE1dFeCV7eMElrF9Hr2aQKt+M0LM=;
        b=s2RdEnB/qBRz7KL9dB43BN4sh09aYHpVGKyMfqpXvN7gCyC8SbHmRYnNE+LXB597+r
         bFWxkIppJlBUb1HEkccHg/iqlGy11ja25VHOw1NX/xbUN9XVat2E+nmq5EORB2TPHPJL
         yd0ft6JS+Tov5NQhfMt1tqV1li+Bi04KazGpuc1T6iuMbC4RqnBj8RhaJBBpHs7lP102
         ADRpUpowERht6ulkAHuu8jSrBeTgzufOaqJDA/pLecC/Vaor8EtOhbFerwoGFGZI774x
         1WpyvN7EV8CzUvywVBxDloIIfxlKwxlxqm1x+cKRv6g0kE4j6vmChO9/ktRAW+Ionp+T
         iRuw==
X-Gm-Message-State: AOJu0Yzhgh7u/TBtHaFwFXgLb8gjbbQ9/vi+2kSKlr+eom6AYwHXf7ry
	yJ/vj8bz2HVLmK8ixkUThCc01jX7P+ZTmJoxks+IgSZQcO8h3awdNAaVLDxVPpp8/dCSIiWFaV0
	w8Q==
X-Google-Smtp-Source: AGHT+IEzPID2lPLBmutN4pY8hBZkktARYVaXQpGLwpt2q43XvRaJrXEizBq0sMzKUMMe8Z6+tvqhpC6gOYM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2291:b0:6e6:4f0a:422 with SMTP id
 f17-20020a056a00229100b006e64f0a0422mr38978pfe.6.1709946588027; Fri, 08 Mar
 2024 17:09:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:09:28 -0800
In-Reply-To: <20240309010929.1403984-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309010929.1403984-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: x86: Ensure a full memory barrier is emitted in the
 VM-Exit path
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Yan Zhao <yan.y.zhao@intel.com>

Ensure a full memory barrier is emitted in the VM-Exit path, as a full
barrier is required on Intel CPUs to evict WC buffers.  This will allow
unconditionally honoring guest PAT on Intel CPUs that support self-snoop.

As srcu_read_lock() is always called in the VM-Exit path and it internally
has a smp_mb(), call smp_mb__after_srcu_read_lock() to avoid adding a
second fence and make sure smp_mb() is called without dependency on
implementation details of srcu_read_lock().

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 276ae56dd888..69e815df1699 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11082,6 +11082,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 
+	/*
+	 * Call this to ensure WC buffers in guest are evicted after each VM
+	 * Exit, so that the evicted WC writes can be snooped across all cpus
+	 */
+	smp_mb__after_srcu_read_lock();
+
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-- 
2.44.0.278.ge034bb2e1d-goog


