Return-Path: <kvm+bounces-34141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1935A9F79B8
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 11:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FE127A3A8B
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E076223323;
	Thu, 19 Dec 2024 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/43WoyN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2ED221DB2
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 10:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734604727; cv=none; b=LndO5X+YsQdMUPeQlTZRFw8Zz8JCzKzaIeDlbeEs3I2XhqVlYMxrPvXpKPf5dCK0V5jicUgCLl+XfJW5QlYW4iftu6Z7SXKJjdafGslQSwQEVfxR1/WLQIn0qNEJYLu8jNd8TECtUYs2lVPV3GbTVUfiK/xj1gqQVBAsDKQFt+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734604727; c=relaxed/simple;
	bh=DPmWrav8mPAsVCxJgpSudbk0PrfP+mG4vkwDLcZsJrE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t2jasaniEEA0aXnVnD8kS4OSGuewcmz05H9BVXX+QN7OlaT4fRjSYqm9/JiChn4NXgt2+p7YZEkUVastbeRoOv/WTq5RmMmcRKPH1YXJTyUG6MDMR1JgeSAIn0VNpK4rwPGI1PJnF/6Lp1TsARCXj2Zl2F/9Y79JDABUNdPAozg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/43WoyN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734604724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0GjqLR85RKltTkbESZcmcm9ul9rbVN2oBs4OUn61pgc=;
	b=M/43WoyNJzxQXVpGERn/2aJJgnXNNNc/Q+AmMK8k6NQeoZgQkahXtCD2dvtIslTQDNK7EZ
	e7eKoj7Ht+/CkjAfmA4zWtODB7SKcwi8kkQBw+zEEwqD55MJRIZ/u8VD+1Ql0gh8mze00L
	L+AIu76Alek/L1nrmCUz0uurxk6kOjs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-Re7v6zcdNUWt1BLp5OE2Ug-1; Thu,
 19 Dec 2024 05:38:40 -0500
X-MC-Unique: Re7v6zcdNUWt1BLp5OE2Ug-1
X-Mimecast-MFC-AGG-ID: Re7v6zcdNUWt1BLp5OE2Ug
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 893A31955F06;
	Thu, 19 Dec 2024 10:38:39 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD16219560AD;
	Thu, 19 Dec 2024 10:38:38 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	stable@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] KVM: SVM: allow flipping the LFENCE_SERIALIZE bit
Date: Thu, 19 Dec 2024 05:38:37 -0500
Message-ID: <20241219103837.325113-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Allow the guest to both clear and set the LFENCE_SERIALIZE bit as long as
it is set in the host.  It is absolutely okay for the guest to set it if
LFENCE_RDTSC is supported but userspace left it cleared; and it is also
acceptable that the guest clears the bit even if this will actually have
no effect.

This fixes booting Windows in some configuration where it tries to set
the bit, and hangs if it does not succeed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Fixes: 74a0e79df68a ("KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG value")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635655..21dacd312779 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3201,15 +3201,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & ~supported_de_cfg)
 			return 1;
 
-		/*
-		 * Don't let the guest change the host-programmed value.  The
-		 * MSR is very model specific, i.e. contains multiple bits that
-		 * are completely unknown to KVM, and the one bit known to KVM
-		 * is simply a reflection of hardware capabilities.
-		 */
-		if (!msr->host_initiated && data != svm->msr_decfg)
-			return 1;
-
 		svm->msr_decfg = data;
 		break;
 	}
-- 
2.43.5


