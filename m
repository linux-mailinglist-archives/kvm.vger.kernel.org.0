Return-Path: <kvm+bounces-41008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A34BA603BD
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 22:56:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9DB43BE5F8
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2951F866A;
	Thu, 13 Mar 2025 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rrP1j9X1"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D49E1F5853;
	Thu, 13 Mar 2025 21:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741902961; cv=none; b=DTD+7H7Sm/GzGoNuTksSg+NrX3cOY1s5DCdlkNAhkGQhd9L0Yln+AIa8ogp76rH4ZQ7N+/c9DfFanS7+nQusbsYgIaHqPaz+bxo22V6JdSqGU1Uj/6JVbNElmK/XLcTuHhXMyMdajelLsl3NWpCSAlON8iL4uDxL3u6ku8BJ76g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741902961; c=relaxed/simple;
	bh=No3TmjuSSj6PGyLv12E7LcxxDwrTbVsdm4RZvrt8UCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6EMbbxtYkr0YIA6QRbMEuaUkurelGEDL+9sFTlLn/qSpC29dt+pCmNo57YfN83k7T0glRne/Qy1yovt4FJ7ziHZTLkwtvhr1EGO/X372FHjPb47ZUCA59hSDX+XlzOEV28drM8y96XU9gM84UqR1rWsKXKuGg+rJiETXuoeYAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rrP1j9X1; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741902957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5Ik2sNVuHfm2wiyHLmIQg8nbZ4c4zHfdyoYXTXv6FE=;
	b=rrP1j9X1+TyHB0LGEqiDrIgc9mrrffgIiXfBGQcQuWqkQ+XjMEcDfLrrj8KcDVdmi8ykUI
	abZkjmsqk+CGx7ias9U3xezJ9An1elplkUNP7/jn3z0AdvYMynJLQNp/9V2DybWTXiBLye
	3cTS6sQF1QgAq/JqBbPMjGfNb122Rsg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 2/7] KVM: SVM: Use cached local variable in init_vmcb()
Date: Thu, 13 Mar 2025 21:55:35 +0000
Message-ID: <20250313215540.4171762-3-yosry.ahmed@linux.dev>
In-Reply-To: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
References: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

svm->vmcb->control is already cached in the 'control' local variable, so
use that.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329d..28a6d2c0f250f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1367,12 +1367,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		avic_init_vmcb(svm, vmcb);
 
 	if (vnmi)
-		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
+		control->int_ctl |= V_NMI_ENABLE_MASK;
 
 	if (vgif) {
 		svm_clr_intercept(svm, INTERCEPT_STGI);
 		svm_clr_intercept(svm, INTERCEPT_CLGI);
-		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
+		control->int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
 	if (sev_guest(vcpu->kvm))
-- 
2.49.0.rc1.451.g8f38331e32-goog


