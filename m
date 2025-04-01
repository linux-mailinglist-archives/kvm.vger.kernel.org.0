Return-Path: <kvm+bounces-42413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3DEA78392
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A44E3B1B03
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF07221DA1;
	Tue,  1 Apr 2025 20:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="paOOIBBK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B050A221719
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540427; cv=none; b=AUYVLoibYAQasEKi+2MvNH9gx9hHOXxpIzoKiQWcJ4LqoHd92DHMSfF9vSKF9OB/HFOOy/CZtUmC86GBiQgw04COjR1pIEX8BLZG57tNIXZk7Yb64xBwHvAZ61IGFNBE8yiINXD0N/Fwe1y7LRNTemRivgKBTaRKDkbw9ZjpsiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540427; c=relaxed/simple;
	bh=vPE6Zg+Is0XKaMNp6fIjGpoFx3l5te14lZBJu/kZl5I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NpEQ7cgmUxt57LvNhjDpBFMnmhVK5gbyNcxbbOipLR8Gsb0+qAMgYSGv4v8FugALmPcQmVrZafOQtrTckRONCvrPuHf07EPANjoRbxlFjUBfN+g2F+SCM/DpPAhW5CiogEb4akOYxNRF9qDMMm28L09ihQvVa/hwEw7BX7WTvYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=paOOIBBK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-225107fbdc7so107465315ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540425; x=1744145225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5qKsANY9N47hjadaMZNM56aBAj0f8nczwxZTz9+A9lg=;
        b=paOOIBBK+RA1uOJo8IFcU8v+ZUWemxv+67ogV8RX7modDidTLSKMZbEpw2AHrY1DtQ
         SqZafaoxumHrkF+UGKTGzaHqN81q/qomuQ9XOqEKF61xmoSGW4hz7+bS8R6tqBHDOPdi
         d3ODiiVP3Oiki94gdmvNbaij1fhyon6HSusTY+ei/lvwNwFHTCWCkIIko/Puyihq/yfD
         ZRPlf8jZPK8Slnp4Ei6SB7RXTwu1BzAcDt1R3G/1hzvH1kt9YDxDb2PBGgipG+OPPYia
         Co0kQLSKZEphhtGEADvIglHCU3ZYpVI843naz+Rg284vqyQ3sav9gxcHj3j1b+YSSEpb
         WLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540425; x=1744145225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5qKsANY9N47hjadaMZNM56aBAj0f8nczwxZTz9+A9lg=;
        b=bMbUKx/70UlrtETkTRraFTZwylk1lXIDpjl1+wo4HFKMks3kfrdVjaZ3IBkNi7v8VR
         1J7I3mxZo1dAi9WoGsJ2ABu+RWY0IM2YN5iUgkceTG+wRca2Pqe9xYWXWsSremaUieGY
         jBr5H2+M9l4X24FzmugoByhh6hrT9UTzxoPTwoRvUh9CTjZ7vH748qMfPy6toYBvrEdx
         VVwltAkpW7KcAi8UBszWzWUo2TtvWswS1n4E53MkZqK2IDh05XNu+ghso4v7/m+rqoIm
         4u3sNSNoTY15xhkSjLSnh8Vfc0I55j0UupX3CfqfNV7P17a68o/ux2IHSnXcNKTAXm5V
         Xg0g==
X-Gm-Message-State: AOJu0YzwSjgC9DPZyQeznTrIJVYvcW653Mwoq8947xoAKKBeeVrVLz2O
	TKpdPMkoZvhuROkkKWjnZ8nfx+RJFLW73zKl7iT87j82kvdJxk/55RSspUxcEuxU1tlL1JVjX2M
	BbA==
X-Google-Smtp-Source: AGHT+IFGVv11dt7rUK+obI9Bx4C62kJ/MvcG+5bk3TDAhhA7vlmUxcL80d04RZFegq2L9eKJhwQmELWuf+4=
X-Received: from pfnz20.prod.google.com ([2002:aa7:85d4:0:b0:730:9951:c9ea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:84b:b0:736:6279:ca25
 with SMTP id d2e1a72fcca58-73980463170mr23448772b3a.24.1743540425095; Tue, 01
 Apr 2025 13:47:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:22 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-11-seanjc@google.com>
Subject: [PATCH 10/12] KVM: selftests: Assert that eventfd() succeeds in Xen
 shinfo test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
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
2.49.0.504.g3bcea36a83-goog


