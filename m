Return-Path: <kvm+bounces-48058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B95E8AC853A
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83C5E17A395
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B3C269AFB;
	Thu, 29 May 2025 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txM9L/Qp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C9E2690D4
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562056; cv=none; b=VocfK6fkyqNpFwfLVHQABG9vVI4+M03tOigPuiByuKcDi1BLzG6cx/8EG9nedpGumkUyf4Ul0dIg6kOUwUgVki219H2IgDuHzRj0Kdz9bbTB1OyCqaGVRxJ33ccTrY2T208XKhtAvoWHd+yIRhOnCDDsDng6cg3wXwgURfX+fPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562056; c=relaxed/simple;
	bh=SoD0Hcit0b3Q2X0664j5BC/XwufKuxL0p4SDIiBBwuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=azgIVQMNrhFARspwdMzZ9ma8suNSDqCDH/vZCpNyYoPZB37TPtNbR0esgyFZgk0NCOHWE8JUhXvGL2vO1i85wtv++aZCJtS1MO2HGfeeGcdF0XDOs0GC6R5mXITH8oym7aHH4OdxgVrhTBYr4JxK0J93SaND/amODJHWldKycoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=txM9L/Qp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311c5d9307eso1639315a91.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562055; x=1749166855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ma79OxOfbFz3TgRT1+ArAbLyQaoHvlTGS7OlgEQow6Q=;
        b=txM9L/QpogytWeQoiYOOveFZq7bV54bAIxcfdQCdwv+MYK8Tc2nojInZ0pS0kdRkp+
         F9mO+j9Xb5aBKtfiI1I+8mRboNnzYq5xUgOZsSSfennflJJ3xwnbTQ0rQaOp3Yxu3OqM
         D99bIx1LE9SFl0KvK6aI5urL1uj4O3xhi+vQkRet8cXhvhBh6oGCpfhXLK98pgX5SHeI
         OWvyRQfvvqwZUiaC7I7UmZkWlG7rIK5HUJ6TvcmXqaMLVs++pqron9vR4/pGjuyTPhtw
         pcTMEG1Ajw0YYau0DQXqcx+m2qzEABF2vSSRblPq36I5NPx0UuanmR3vSTO0n74Ihtul
         zp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562055; x=1749166855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ma79OxOfbFz3TgRT1+ArAbLyQaoHvlTGS7OlgEQow6Q=;
        b=ZdohoXDHe71MHjvtY4BlAGuG+KfJK7cBVMUVcVhcfnnzFZkzcAEvKMXQPnmEYe20u2
         D50kZv7ezqlXmuetSsi/0WT8ZMDIMinWqH4+4Kan4a13MHstD588opkEqNolrD4dsO3J
         Sq+WtY7VBlbq1MRy0T63rLB/3rrTfimqTC5cnCAQuvEcvOMTHgib8kjz17nJfuLBXoUA
         WfNG8tfStbk6gELY1+w/ZBgXpqbFziSxJmLwW9bclN5RaJYIBAAOEkB6rCGD1d3a/cwH
         nzDj8WEsYI0vbE8RLnBZRInQcSK/kNDQ4sreXCN69CBWWmJ30lb7t0RFQ2irKaFQNzWJ
         U7Hw==
X-Gm-Message-State: AOJu0Yz0sOW8r1T9CAZcFRplqgqT4xguEh9Ze+PlT1uWIPTlAABvs+Aw
	9ldZRIzmn/dTI92gTo1tgkOB7Q1QfLt+pd1aKukS2pTzu3WSWuzdEFA74isrye+bqtkitbYzQDt
	8vZmr6g==
X-Google-Smtp-Source: AGHT+IHkbdZTK3P5HLHYM5AwmXLymCJ0QLixXG2jn4Ae152nUnpVjDZhnL8AuCnVXKZgkEkLTE0sz/Z5ACw=
X-Received: from pjbsc15.prod.google.com ([2002:a17:90b:510f:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2701:b0:311:c939:c84a
 with SMTP id 98e67ed59e1d1-312416340bamr2391836a91.15.1748562054868; Thu, 29
 May 2025 16:40:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:07 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-23-seanjc@google.com>
Subject: [PATCH 22/28] KVM: SVM: Drop explicit check on MSRPM offset when
 emulating SEV-ES accesses
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that msr_write_intercepted() defaults to true, i.e. accurately reflects
hardware behavior for out-of-range MSRs, and doesn't WARN (or BUG) on an
out-of-range MSR, drop sev_es_prevent_msr_access()'s svm_msrpm_offset()
check that guarded against calling msr_write_intercepted() with a "bad"
index.

Opportunistically clean up the helper's formatting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2ebac30a337a..9d01776d82d4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2771,12 +2771,11 @@ static int svm_get_feature_msr(u32 msr, u64 *data)
 	return 0;
 }
 
-static bool
-sev_es_prevent_msr_access(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+static bool sev_es_prevent_msr_access(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr_info)
 {
 	return sev_es_guest(vcpu->kvm) &&
 	       vcpu->arch.guest_state_protected &&
-	       svm_msrpm_offset(msr_info->index) != MSR_INVALID &&
 	       !msr_write_intercepted(vcpu, msr_info->index);
 }
 
-- 
2.49.0.1204.g71687c7c1d-goog


