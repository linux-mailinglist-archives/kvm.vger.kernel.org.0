Return-Path: <kvm+bounces-24249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B897952E59
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:35:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 443091F22766
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 12:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB7E19F49D;
	Thu, 15 Aug 2024 12:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dTv2b0MX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFD219E811
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 12:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723725271; cv=none; b=CSCt716hA85mulaQeWAcXhNHqTPo2XNqxoBS8TmR0YIHqUXwP+hJBK4XvG9HBP7V4lWSru8p36JIZNA8sNeQ53wOAVJ7WdSGfBSsHc4ilIz2YM6+O6V+eE8TvX0SFOo0dPCbnLUJMg1i+ftpJ8QuPaCnblSU8la/FPxEwri4N+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723725271; c=relaxed/simple;
	bh=L38KGcXOZCqzPnVmWq/RPsXYJhQOqQHT3IpQY6HAono=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WlT0p0YIsJe8II28KLO/7YIkgdPV8YvD1cw1lVN3oOKxdo/F7id3Z75BmfyJ4ywoEFlxoKRlv/KwJBiDwPAO7MUKqDRVbGgOEntvL5N+wKrDNqMFviiO16ocLMLkrVUlj5O29/KPJlgHbCmkRBe3PjuriKhUlvJToXP5Z64r68o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dTv2b0MX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723725269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+bN7ZCwzjk9Oq6TRygQGi4kAzwB1IuXFDbclXlvZiww=;
	b=dTv2b0MXEiLJccXUZxgjZ+fBloGIymRpaxjGaBRBfDnqgS2T0v1QKmiAx5bEid9RKElOCm
	VwtN03h5PIBkblwxzQZ72xJnPjNhxizmhNwJq+jkPBx0eqra3AQ7CNACHvM7ObNntT1X0j
	L5tdlcDR5eAPQESsCcsFfx9V84M4nt0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-DWoiEdSUO5uNOwOCiyPTZA-1; Thu,
 15 Aug 2024 08:34:25 -0400
X-MC-Unique: DWoiEdSUO5uNOwOCiyPTZA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 663D51955D48;
	Thu, 15 Aug 2024 12:34:24 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.47.238.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 578DF300019C;
	Thu, 15 Aug 2024 12:34:20 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 4/4] KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_GS_BASE
Date: Thu, 15 Aug 2024 15:33:49 +0300
Message-Id: <20240815123349.729017-5-mlevitsk@redhat.com>
In-Reply-To: <20240815123349.729017-1-mlevitsk@redhat.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

If these msrs are read by the emulator (e.g due to 'force emulation'
prefix), SVM code currently fails to extract the corresponding segment
bases, and return them to the emulator.

Fix that.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a04f6627b237..be3fc54700e3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2876,6 +2876,12 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3101,6 +3107,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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


