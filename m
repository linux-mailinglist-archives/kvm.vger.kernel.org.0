Return-Path: <kvm+bounces-35194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34AFDA0A006
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4216616A993
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B535614EC7E;
	Sat, 11 Jan 2025 01:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VCDYG6LN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5311713CFA6
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558700; cv=none; b=E5g/r3e1w8SzteO95ydg8oDGC9gbb9xzBFGmlXQ8WEm9HBqkCrP9eX8w85mCd77rC/wgfcgt+ewEVO/LTxzh6LOfV/pCMBGndj/NNEYeVzrcBOOZBcEMSK5f+TxMcbVJNL3LBLFyPlJbRELh70zc9KQq74+4oJ8yOstIDiinsbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558700; c=relaxed/simple;
	bh=WblEmOXy4lG1OvHRKBFgBmQz8+4EVU20P3KzKjYyjd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=olIfWpRBP78z8IJ46aQylH/JeaQvTwrqcv3X8AWyElguTCGWmtAwtbUFcVurd0MIU9eUrF4KVRvYOPx4onsDPZkepeTvn7a3EwEsW+rG5L0RPKx1r3Ik7tCzKeWlUaKgMc7cNdXh6Mctu36QRRN2N2arnk8X3ymNLDe9tdRau6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VCDYG6LN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2eeeb5b7022so4818734a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558699; x=1737163499; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3UIVRx5jS5uHOad/ZRxuC+ZyfJfWx7WVNf7AHGunc9Q=;
        b=VCDYG6LNr+3c01fMKg11JxsGKRmxugUOGOjj7nMvy8L7BZ+0HTrcyVZtOLlUvyUnwu
         /znmrwIsPrFVNX2O5nuIw9y7TCPzogm4TgrXCVg8gb6KYR2Q5EXZ/s9Dyiqu+zJXpoaB
         43TWidptFBXRNGrWLHavvieBprLpZb6bISubzC+8fCYiqndF7fsm04yvTcS2yCUi2e79
         XWigkUdONYgM8qrJ2ruaAO9GaQIBLAmfGo2zIz3imfmFiZsGLuvhnsaHMzhtqKD4nES8
         OLZqi/j/BE7+vGphw5rPf5d0RS1GS5M3zscD+zWECFFOyca1rhwW7eOzD0KEC73unjb1
         4rMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558699; x=1737163499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3UIVRx5jS5uHOad/ZRxuC+ZyfJfWx7WVNf7AHGunc9Q=;
        b=OHUD2yfwFu5PDB2igwBEc6rXlnE6WhxUGZObZCeIcKGVDW3zxv//Wf4zwOdLf4b4wv
         HhKmiO8wPLXM3lgRN/jj9tny/fkhQysEeP9N5ffSTY+1gIcSkp5MUtFSlUQb/TKqJ5Ab
         o2Lba7Zvd9ZD4QQ6JZeHBc/CRm1LC6qhEQIwWiOi5pUbKYDD2w1YzcBsFO18Qtf2cRch
         Xuf50H9luzprPHxNYWITOBg8xCYdCmRKTfb4w8ZNSGVEQ0jKZvtI9Qbrw9sF8dinVNq/
         JcwIYdL1babIUoiGkvnjP6PXIUzVq3tm3GjzfdZ27xe+HTuHYiondbKnvJ/AARl0a51/
         xzgQ==
X-Gm-Message-State: AOJu0YzrXQJm3wpWvl4dYp4GUapIKtG7ZXA6n2c3IaOKx6BgkcLQ7lLz
	c6rNmdTvrW4Va4Ol+3VVBCDr4vKKQ7lmzjj1VcKRTkwhUCmq4YzaXukjt/Doh6OW9PilAoFb/pA
	7HQ==
X-Google-Smtp-Source: AGHT+IHf025t1EVvlV+j91gbU3uZgm+9mZiPk2JrEEttgvDlmrVpnhWnRwbzCB96nhWXuJS4v4uP1KYHMJk=
X-Received: from pjbnw13.prod.google.com ([2002:a17:90b:254d:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5188:b0:2ee:df57:b194
 with SMTP id 98e67ed59e1d1-2f548eceb00mr17022072a91.21.1736558698928; Fri, 10
 Jan 2025 17:24:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:24:49 -0800
In-Reply-To: <20250111012450.1262638-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111012450.1262638-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Provide separate helper for KVM_RUN with immediate_exit
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Turn vcpu_run_complete_io() into a wrapper for a dedicated helper for
doing KVM_RUN with immediate_exit = true, so that a future patch can do
userspace exit completion if and only if it's actually necessary,
whereas x86's nested exceptions test wants to unconditionally do KVM_RUN
with an immediate exit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h           | 9 ++++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c               | 2 +-
 tools/testing/selftests/kvm/x86/nested_exceptions_test.c | 3 +--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 4c4e5a847f67..78fd597c1b60 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -631,7 +631,14 @@ static inline int __vcpu_run(struct kvm_vcpu *vcpu)
 	return __vcpu_ioctl(vcpu, KVM_RUN, NULL);
 }
 
-void vcpu_run_complete_io(struct kvm_vcpu *vcpu);
+
+void vcpu_run_immediate_exit(struct kvm_vcpu *vcpu);
+
+static inline void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
+{
+	vcpu_run_immediate_exit(vcpu);
+}
+
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
 
 static inline void vcpu_enable_cap(struct kvm_vcpu *vcpu, uint32_t cap,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 33fefeb3ca44..c9a33766f673 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1665,7 +1665,7 @@ void vcpu_run(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_RUN, ret));
 }
 
-void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
+void vcpu_run_immediate_exit(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
diff --git a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
index 3eb0313ffa39..4f144576a6da 100644
--- a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
@@ -238,8 +238,7 @@ int main(int argc, char *argv[])
 
 	/* Pend #SS and request immediate exit.  #SS should still be pending. */
 	queue_ss_exception(vcpu, false);
-	vcpu->run->immediate_exit = true;
-	vcpu_run_complete_io(vcpu);
+	vcpu_run_immediate_exit(vcpu);
 
 	/* Verify the pending events comes back out the same as it went in. */
 	vcpu_events_get(vcpu, &events);
-- 
2.47.1.613.gc27f4b7a9f-goog


