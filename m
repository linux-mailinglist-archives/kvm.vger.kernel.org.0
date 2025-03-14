Return-Path: <kvm+bounces-41111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3BA8A6197E
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 19:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8ABC19C2431
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A35A204F62;
	Fri, 14 Mar 2025 18:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RMZH+UPU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19265202C39
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 18:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741977271; cv=none; b=jwenqxPODvPGUgumhQdwywXynHkDdJs59VdbsbCs9ustT7BhTDgNDUCOr/yM0Ap4hGjJry/V7EI1LrfsQtFyyQlXbuipGMOMGYkgkUY0oFwrH4hEqme2Hl91CWoIFhn7SLchL79dOvNxeyJ8Y3Cp793isKCsCbNkuEZpOdzRR5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741977271; c=relaxed/simple;
	bh=Yyru1lxuPxEqpTx3c2grjWb5HFoOXgSzJKknvchVzTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NT9034mUAsX/hwU82EWOb8wHJNTrLtERtalYTatPnsCWN/2o7zQY6SERsfqhO1Mw1tQxvInXjT3BQqhvHWYdF/dWRfq58OjlQllsVHAjq+Axlt1lesUTzB9F49K6gCdiNRsf6usuJkg/DzZ7mcpXYCBZHYWh2upt5wTV0XxUntY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RMZH+UPU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741977269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8XvgvV35Wr19Ks3UpDBxJ+rAUNSoT5OEs8FRVluDVsY=;
	b=RMZH+UPUpiEOy+LvlGiQduFr/2Zy14/7Ngv9yq6KA47+qG8SNzMj8SHtzywTNkIsNNkV8n
	a+7d85fp6bsq918knMkxToCZNUNX/RAAIwlMaQvRgNB8WJl3nAB9Ta2YaQAN98SqSczB59
	uBAbIwnjHrU+Ylco8gfjY4BN7tAOs1Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-TyvuKO5OPzGvul78Pru9Yw-1; Fri,
 14 Mar 2025 14:34:26 -0400
X-MC-Unique: TyvuKO5OPzGvul78Pru9Yw-1
X-Mimecast-MFC-AGG-ID: TyvuKO5OPzGvul78Pru9Yw_1741977265
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23E521800262;
	Fri, 14 Mar 2025 18:34:25 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 678531801747;
	Fri, 14 Mar 2025 18:34:24 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	nikunj@amd.com
Subject: [PATCH v2 1/2] KVM: x86: Push down setting vcpu.arch.user_set_tsc
Date: Fri, 14 Mar 2025 14:34:21 -0400
Message-ID: <20250314183422.2990277-2-pbonzini@redhat.com>
In-Reply-To: <20250314183422.2990277-1-pbonzini@redhat.com>
References: <20250314183422.2990277-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Isaku Yamahata <isaku.yamahata@intel.com>

Push down setting vcpu.arch.user_set_tsc to true from kvm_synchronize_tsc()
to __kvm_synchronize_tsc() so that the two callers don't have to modify
user_set_tsc directly as preparation.

Later, prohibit changing TSC synchronization for TDX guests to modify
__kvm_synchornize_tsc() change.  We don't want to touch caller sites not to
change user_set_tsc.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <62b1a7a35d6961844786b6e47e8ecb774af7a228.1728719037.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bd2b71d4e64f..2da75bbf7f94 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2626,12 +2626,15 @@ static inline bool kvm_check_tsc_unstable(void)
  * participates in.
  */
 static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
-				  u64 ns, bool matched)
+				  u64 ns, bool matched, bool user_set_tsc)
 {
 	struct kvm *kvm = vcpu->kvm;
 
 	lockdep_assert_held(&kvm->arch.tsc_write_lock);
 
+	if (user_set_tsc)
+		vcpu->kvm->arch.user_set_tsc = true;
+
 	/*
 	 * We also track th most recent recorded KHZ, write and time to
 	 * allow the matching interval to be extended at each write.
@@ -2717,8 +2720,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 		}
 	}
 
-	if (user_value)
-		kvm->arch.user_set_tsc = true;
 
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
@@ -2738,7 +2739,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 		matched = true;
 	}
 
-	__kvm_synchronize_tsc(vcpu, offset, data, ns, matched);
+	__kvm_synchronize_tsc(vcpu, offset, data, ns, matched, !!user_value);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
 
@@ -5725,8 +5726,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
 		ns = get_kvmclock_base_ns();
 
-		kvm->arch.user_set_tsc = true;
-		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
+		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched, true);
 		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 		r = 0;
-- 
2.43.5



