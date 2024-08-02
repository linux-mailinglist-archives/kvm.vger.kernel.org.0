Return-Path: <kvm+bounces-23051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA59946019
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 17:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3070A2859D5
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 15:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEF6163240;
	Fri,  2 Aug 2024 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ahbf889C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B33DABE3
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722611790; cv=none; b=E9ZerHHNvrHrkDvGBOvS9icVJG5S/3y+XXhjaK76+vrD/Lt1kU1mgKKVsWKXVVjINKPTbXaLO5pNFek/LufrUY7C6GiyC+lEXGosqiKfSaEDq4PCFqcwDMErIdJmYx8P0mQhYytlTSjgZQJO+AR4wpST4j+FIh6Q+WWl2ACnlGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722611790; c=relaxed/simple;
	bh=Er46L1hp81+g7ncccocxo1kW4uaMS9G+kd29B0+gGLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FTXMUkEVVeqh0tK143Zjsq9TtG2uUc3jqQwxSOeLNntXoFR5q/gNpCVCMn9NI/aWJeSWQU+lMs6a1xdaSsmLFzF8JMkEbVzgjEMecvhfgCxaH3aBurfu8esJiqzeKnoCCKvVgATUrq5on/BmYIoE45jF4N+HJ82E7+h4nZJGne8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ahbf889C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722611788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TbSpH0vyde4k53/5J0gdQAsE/z1IiL2N27dmroNOMqk=;
	b=Ahbf889C28Q1s6YPGv7ybtni2thbKg8pslUhmPPdpHe/AWQEnqTEiZJOUs18ysaC84O0nY
	FPNeAv9d6lay79z5p0tC1sdJ7dnJP6QggHUzJKO/doNk/xiNh9hpzBqxP6M+SqQwmPZe7i
	ex4wLyeMSr7j7b++epKIQgdAcOxqgM8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246-Tt5guUWeOfOm2mobmd6YEA-1; Fri,
 02 Aug 2024 11:16:26 -0400
X-MC-Unique: Tt5guUWeOfOm2mobmd6YEA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84A6A1955EAA;
	Fri,  2 Aug 2024 15:16:23 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.47.238.37])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 722C01955E80;
	Fri,  2 Aug 2024 15:16:19 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/2] KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_GS_BASE
Date: Fri,  2 Aug 2024 18:16:08 +0300
Message-Id: <20240802151608.72896-3-mlevitsk@redhat.com>
In-Reply-To: <20240802151608.72896-1-mlevitsk@redhat.com>
References: <20240802151608.72896-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

If these msrs are read by the emulator (e.g due to 'force emulation' prefix),
SVM code currently fails to extract the corresponding segment bases,
and return them to the emulator.

Fix that.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c58da281f14f..3fc01ba2bd4a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2875,6 +2875,12 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CSTAR:
 		msr_info->data = svm->vmcb01.ptr->save.cstar;
 		break;
+	case MSR_GS_BASE:
+		msr_info->data = svm->vmcb01.ptr->save.gs.base;
+		break;
+	case MSR_FS_BASE:
+		msr_info->data = svm->vmcb01.ptr->save.fs.base;
+		break;
 	case MSR_KERNEL_GS_BASE:
 		msr_info->data = svm->vmcb01.ptr->save.kernel_gs_base;
 		break;
@@ -3100,6 +3106,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_CSTAR:
 		svm->vmcb01.ptr->save.cstar = data;
 		break;
+	case MSR_GS_BASE:
+		svm->vmcb01.ptr->save.gs.base = data;
+		break;
+	case MSR_FS_BASE:
+		svm->vmcb01.ptr->save.fs.base = data;
+		break;
 	case MSR_KERNEL_GS_BASE:
 		svm->vmcb01.ptr->save.kernel_gs_base = data;
 		break;
-- 
2.40.1


