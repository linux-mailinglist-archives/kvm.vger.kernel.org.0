Return-Path: <kvm+bounces-52789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E08B094F0
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F6D71890FE4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BB02FF469;
	Thu, 17 Jul 2025 19:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T36MY9eM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F12FE396;
	Thu, 17 Jul 2025 19:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752780270; cv=none; b=nNO85C66LgczEgIJ3ZKuGB9SLIAVQPB8PSlaNvpoJYCSSAPf2NGt0rgImZ0boFnWunOC2hpV8Dl1q0kVTmY3SIVt1bTsMTEPF6OI6eJEcMJQqdq1vw45yq1CWP2UK1O0LxKjjGsG0jmCS6OLSgM+6xYDvDD719luX8Ku18skWKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752780270; c=relaxed/simple;
	bh=12KJMOiT2pE3sCQDyrkMno9O396fvTT3Odn6Gh92XqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UykwfSDVapevzuDi1DToZ+DqCAi0T8uQx2UzTvTjQydv+Z0YaTxsDQDoDjYY3jKArrupw3OTTF9rPbQ2kLyHDsx2+dAa6pKCtZe2zTqrPNy013s3ulmE3KLN48qWRf440yHDHwkh+qmVX+cYJyznE8/ARH55jDNYVRbWO5VZtio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T36MY9eM; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-31329098ae8so1249683a91.1;
        Thu, 17 Jul 2025 12:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752780268; x=1753385068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKh8BjVfael4aS3SYq7GYVW6I/aWE1B2K12DvzmRc6I=;
        b=T36MY9eMDlCMb4G9v0/TLS+dmSENDU+vSfJ5L+TI+Bkpli7OM/va/DLdhun6UytjbJ
         u8mYuSBkf0H3arGazXiOlbpM5F6M04ubpOgpoEgQFGfFmX/FVlt2Qk4jEe0QEC8ytUSn
         Hqku7Kc6CcIjL4y1X4CA59m7jjgSmoxDh5vROIpwBaLeZNB1/G2rgrgt59q+yrfSk2PQ
         J4cVA4itQOC/wfxqmhVsx2HoV1A9kfyxT2w6dePC8mspiHwzOjVHwWmQbpofswn9aYQ8
         rdtwVuYmTbKmBZqpbzmPD73QWXMEa7wyMSURZ3m+B9o+BdOlovkJSLTl5iOQ4XRd9FMu
         5H3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752780268; x=1753385068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKh8BjVfael4aS3SYq7GYVW6I/aWE1B2K12DvzmRc6I=;
        b=ayyXlVR39UlqFQud52+aSPb/hqsOey67PFfU5utBUXDiuGOK7lw+utqh7PvslixH42
         M18Lehk0sEQVt/Q6M6noVbhvAtoZeJso0G44c6I0rtWTQLu6Tkij+ddZigBpGDx91L1a
         tNrvDvn1+8DKFkV7KeP1zAkA1uSnvNMH0eDkhH6gSsPRB/sAwq1vTGWoSVOjR7XCRP5L
         t3BEktFeDRbEMWw6MovHd+w+ST6oSMwvx6Zy5IFeY02METKVvvtxVvyBGPcr5zN0rNk7
         O873J7G6AWXvQS1i8tCBSM9ULD4lIbbwvRHhgb5EO2VuXaN/LgBQ/NqCcmZm0v0TaB9S
         w2kA==
X-Forwarded-Encrypted: i=1; AJvYcCWBLUEKjIcVi+1rPh9PJqMHNALtkMIIfPfJAhgBIcePrDXIA6jYHAmh7bWEY92oPvo9EZA=@vger.kernel.org, AJvYcCWXUrBCwfR0VsTgDmCj2sbT3p9oZZWxBZKFp6yYwhx7yFF+9aV+H3GFsv6Y7QWzGvGReUhjxDTyjwX1x59t@vger.kernel.org
X-Gm-Message-State: AOJu0YwPB38kd2EO1g3kwl+KMNz5zwaTGI4deu390DnelqGLNYRq88nV
	my855ER+JVN3NOXDBNjxS5cq9iTgK4S4mK8Rbv5dqKJhTr/ahw/GrGO6
X-Gm-Gg: ASbGncsd5vaYuJavzS3ls8ywaGBEoXZjE+SERa0f1UPDROolnMWph2TSKkuuEqoDd7X
	n86RT0VhRexx6E7HVTRg8pmXJK3uMKBkt6pB5bpPjKkGwCu4m2NfDL1Cw2KKTNnAYbWvlISccuK
	i7ruVQJMfoLIHHBzI2xb8SQidNFy6sD+f5X+nQBRpqmdbZJb6XSzznQGVKEuhAansafo2GTAd34
	b4hVXlm5m+9RXfdHqIhGoh8MNYBiwfCRtvXN3Uqx2NNBl0XWBJQmCjp+TqPcvT4MN1EgZrx24s8
	5GX0Aw+3UMYpr7qOrq2ymHjRS2jqOHxOr7g5wmxA7Y0pjKeW2st1/5rKGHXaFIBvQ0q+TIiCShC
	hfdVBpGTWy9zcIECzMtmeT7rB9jp5ZDw9
X-Google-Smtp-Source: AGHT+IHinmaebm51PcxIHxtDBdMhjNtdJ6a4wizUtf0cK188qHd6Jc6VvjkeiEQ+SbMo/7f0RP2Nmg==
X-Received: by 2002:a17:90b:55c8:b0:311:83d3:fd9c with SMTP id 98e67ed59e1d1-31cc027a0e0mr1510781a91.0.1752780268203;
        Thu, 17 Jul 2025 12:24:28 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31caf7e8984sm1964246a91.23.2025.07.17.12.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 12:24:27 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 1/3] KVM: PPC: simplify kvmppc_core_prepare_to_enter()
Date: Thu, 17 Jul 2025 15:24:14 -0400
Message-ID: <20250717192418.207114-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250717192418.207114-1-yury.norov@gmail.com>
References: <20250717192418.207114-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov (NVIDIA) <yury.norov@gmail.com>

The function opencodes for_each_set_bit() macro.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 arch/powerpc/kvm/book3s.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d79c5d1098c0..dc05ea496aad 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -401,17 +401,12 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.pending_exceptions)
 		printk(KERN_EMERG "KVM: Check pending: %lx\n", vcpu->arch.pending_exceptions);
 #endif
-	priority = __ffs(*pending);
-	while (priority < BOOK3S_IRQPRIO_MAX) {
+	for_each_set_bit(priority, pending, BOOK3S_IRQPRIO_MAX) {
 		if (kvmppc_book3s_irqprio_deliver(vcpu, priority) &&
 		    clear_irqprio(vcpu, priority)) {
 			clear_bit(priority, &vcpu->arch.pending_exceptions);
 			break;
 		}
-
-		priority = find_next_bit(pending,
-					 BITS_PER_BYTE * sizeof(*pending),
-					 priority + 1);
 	}
 
 	/* Tell the guest about our interrupt status */
-- 
2.43.0


