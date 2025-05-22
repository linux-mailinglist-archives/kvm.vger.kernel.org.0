Return-Path: <kvm+bounces-47442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C48AC189C
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15729170B63
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04A32E338B;
	Thu, 22 May 2025 23:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gm251MBb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329452DFA49
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957974; cv=none; b=gkphsIfR/Gx23rwVO9FCBwt9OvAbXO9r5Qg+fe3YtecOmB7HEe+enMRUACHZLQeh4lHYgviNbOcnct4XpC6Rs5vAe3YKlJO8ELiGqA0CD3M1Up3MCyV8Mq/btHyO0RQpBgKhtoBs0dQgt5jtopxwNl5cQJ0mdkcJ5EMXiit30Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957974; c=relaxed/simple;
	bh=gmLT2D1WB9vmr8rFdHxMOpHNwXh7MFDJ6xUGtYQhimw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NLtsXv0REG5EK/fxTpLx5fkgkUyu1ZKSM6u/orLJ8/XyuWaM9lvE1vbqRQ9sE+c0vUoCuSAGJPph3nCyro7TBoeud9Ol7C+IPXlavVktsbOaAUwfMDi3lkFGF/D0u9ZZApfFoHP/oMwz55kOCRPcXk9U+nOjZP6K2r1n5MfZLQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gm251MBb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e7f19c8cfso9487693a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957972; x=1748562772; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jjMNjs+bdNtZTb3Wdy6sSLCs56ksmcfEkIHqJR2gBFc=;
        b=Gm251MBbxSTPwRH8ghuckno+ronDdEVl9sRm7VO9nmeiheBfzwBds6nbGRsRwcK7yd
         waCOi+bmfnP5ESrxPGUNt/ILIpm4yL8O/zCKI88eggpbSfA+oP4+ormkJhme3Do7huYt
         w51fnUMn7VRahjSMoyFfxbtlrdSysOJjoqXf4aaAjGu9ZuhkV9ClZw4ax+NqABswOwqX
         FC/W5QndXARcH0lEWopnRD0yHOPHaBneQcYSyuM6VFS04Nw7i9zqLXZVwa7QO2LurjDU
         1d+4C3XWtG+oy3HZFOV0l+GEhj9eyi1UvZUt7mIebsMmWRcqXumfC2Kt6/SF79hAPmrr
         l0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957972; x=1748562772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjMNjs+bdNtZTb3Wdy6sSLCs56ksmcfEkIHqJR2gBFc=;
        b=W591gVIntlOCPrdKe55jJmgvJa7d/Y83G/H+UdOa9VwXI3apRH9HVa1NsOQUufHVKC
         WO1PQRkpK8oj+eN15nnBDXordd4bn4rPItsec9zLNXZpCWGiEvkGBOL4X6JQJ7XxeOTj
         8vcv7rzNarfQw/gKetm92b9bnd5esAtOT0uzsGCDk9Kb3zs1q9/CnqFv4XHNPBQCaPyr
         WnMYKF10YaHxGzaZwjFQnt0KjwNm1vXN8cx1N9TlohQprbQlGiFHlX6DHkDm2jtVmj39
         vvJeXvgXzGm62WsLtxXwe07VNL3hSh8zv78bwemPf5M/CaFdczc9Wcx+1+gCKUenuj2S
         fX6A==
X-Forwarded-Encrypted: i=1; AJvYcCUuxpCJgq3w+2sIU1wc60gyZim95dOtuXbaYd9D85qb+VUe7BcRTjxwzm2WZThQVDk6OIk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkQ2KedFgvlzaNvcyRLxCrRio7E8be+EhnGc6wnpxXt/Vq2Jms
	MD4zRbujZheWjrRKTAlBqp3sIxa4tv43F+TBR+Rbg3zsGXKanqlnU0Cst+7yhPt/9rdNRZ4uUU9
	pvdOQYg==
X-Google-Smtp-Source: AGHT+IH+y/4Vqk1KMF3LjOCFUbppIPh5ZUErAvUoiEDW2SE/2hXGiqyTLKxlZ9Xh8ZuSjxO0WF45GST49oM=
X-Received: from pjbdy5.prod.google.com ([2002:a17:90b:6c5:b0:2fc:1356:bcc3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:510f:b0:2ff:58e1:2bb1
 with SMTP id 98e67ed59e1d1-310e973e510mr1311217a91.32.1747957972660; Thu, 22
 May 2025 16:52:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:21 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-12-seanjc@google.com>
Subject: [PATCH v3 11/13] KVM: selftests: Assert that eventfd() succeeds in
 Xen shinfo test
From: Sean Christopherson <seanjc@google.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Assert that eventfd() succeeds in the Xen shinfo test instead of skipping
the associated testcase.  While eventfd() is outside the scope of KVM, KVM
unconditionally selects EVENTFD, i.e. the syscall should always succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 287829f850f7..34d180cf4eed 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -548,14 +548,11 @@ int main(int argc, char *argv[])
 
 	if (do_eventfd_tests) {
 		irq_fd[0] = eventfd(0, 0);
+		TEST_ASSERT(irq_fd[0] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[0]));
+
 		irq_fd[1] = eventfd(0, 0);
+		TEST_ASSERT(irq_fd[1] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[1]));
 
-		/* Unexpected, but not a KVM failure */
-		if (irq_fd[0] == -1 || irq_fd[1] == -1)
-			do_evtchn_tests = do_eventfd_tests = false;
-	}
-
-	if (do_eventfd_tests) {
 		irq_routes.info.nr = 2;
 
 		irq_routes.entries[0].gsi = 32;
-- 
2.49.0.1151.ga128411c76-goog


