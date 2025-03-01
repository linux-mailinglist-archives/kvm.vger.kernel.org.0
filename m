Return-Path: <kvm+bounces-39802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A027A4A983
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 08:35:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78669189A073
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 07:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3711A1D63E1;
	Sat,  1 Mar 2025 07:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S5WfRqTp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E011B1D5CC7
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 07:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740814483; cv=none; b=c2/krOHhwYn43k7i3ZfcXBbwvdG4+X78oFUzdnzKgKnEUULoLnN+5XAvHfJI/hMuTI5I4puRaGDfW/6YABCT93NCquCXUdaeYJBsv62vfm07pg2tsz0gpxNLtoZPNszuhzZwgC9C+irWpMwZgnctzOCNTsMok5HAa66iSFGWhLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740814483; c=relaxed/simple;
	bh=ATIprvoSK3n7ncfoU2aOka1PCDoa4nzg9S9uQdg1nAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iqyJyNHuCtd40OCyDw0De+Z4Nbv2fbzyic3bvudkXPoEMoNsiCRKlDddztIeZBUN2eL6HzeU2tUuB4ltlCxD9XS5W+WZLpQVZNZQjwUDA5gngUGX7UUJITPUgGzqpFW2yItd7UmZAW9JDvFS6oc2lzvD9GMyfZhgEFoW1HZYAqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S5WfRqTp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740814481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XhWqgRM8gKFGfcQVIoLrXG00OiHCfInbynMqLoPxhNw=;
	b=S5WfRqTp6nHifVdiEwN/mm55aMARxbRidwdn/T8p4svecoDvCSh2KqRyFVBQtco3XUN7fx
	ENDOWM35eQCf1OAsdB+N8DaqhN6Ug4PpDRDAADdf2bJ6fU7sn3sgH17UO4afUxDvko7wqy
	05uCs+5RtDa7B5SLJatSoy1Sx1HFwHo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-RZfpdkRUP76OLIdz5etWcg-1; Sat,
 01 Mar 2025 02:34:34 -0500
X-MC-Unique: RZfpdkRUP76OLIdz5etWcg-1
X-Mimecast-MFC-AGG-ID: RZfpdkRUP76OLIdz5etWcg_1740814472
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C7721800871;
	Sat,  1 Mar 2025 07:34:32 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 91A5619560AE;
	Sat,  1 Mar 2025 07:34:31 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	yan.y.zhao@intel.com
Subject: [PATCH 2/4] KVM: x86: Introduce supported_quirks to block disabling quirks
Date: Sat,  1 Mar 2025 02:34:26 -0500
Message-ID: <20250301073428.2435768-3-pbonzini@redhat.com>
In-Reply-To: <20250301073428.2435768-1-pbonzini@redhat.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Yan Zhao <yan.y.zhao@intel.com>

Introduce supported_quirks in kvm_caps to store platform-specific force-enabled
quirks.  Any quirk removed from kvm_caps.supported_quirks will never be
included in kvm->arch.disabled_quirks, and will cause the ioctl to fail if
passed to KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2).

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 7 ++++---
 arch/x86/kvm/x86.h | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd0a44e59314..a97e58916b6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4782,7 +4782,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
 	case KVM_CAP_DISABLE_QUIRKS2:
-		r = KVM_X86_VALID_QUIRKS;
+		r = kvm_caps.supported_quirks;
 		break;
 	case KVM_CAP_X86_NOTIFY_VMEXIT:
 		r = kvm_caps.has_notify_vmexit;
@@ -6521,11 +6521,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	switch (cap->cap) {
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = -EINVAL;
-		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
+		if (cap->args[0] & ~kvm_caps.supported_quirks)
 			break;
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
-		kvm->arch.disabled_quirks = cap->args[0];
+		kvm->arch.disabled_quirks = cap->args[0] & kvm_caps.supported_quirks;
 		r = 0;
 		break;
 	case KVM_CAP_SPLIT_IRQCHIP: {
@@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
 	kvm_caps.inapplicable_quirks = 0;
 
 	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9af199c8e5c8..f2672b14388c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -34,6 +34,8 @@ struct kvm_caps {
 	u64 supported_xcr0;
 	u64 supported_xss;
 	u64 supported_perf_cap;
+
+	u64 supported_quirks;
 	u64 inapplicable_quirks;
 };
 
-- 
2.43.5



