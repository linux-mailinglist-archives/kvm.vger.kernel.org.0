Return-Path: <kvm+bounces-39800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E49A4A980
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 08:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A064C3B6842
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 07:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43BC01D54FA;
	Sat,  1 Mar 2025 07:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dP6OTjYm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5631CAA6E
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 07:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740814480; cv=none; b=U1KeDFWQlT/KLcZd47EMdooI5SOnipyGdpEhyY5+K7ssf5gV+rDfABrXV5Jca5AlBLWWmLQdDlPAHv+m9ALSq0QRSECfGbpGuurVtWiBoPYFQGsaIAjF8rh15lG1AWlvTxrJsYVmgg6l4xBtkYRt0cgf9I5Tl9U49kvJhAAQHTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740814480; c=relaxed/simple;
	bh=ZhEYDudAwtNu6wyUKSDvWNQiU78WezOh8CbVFYjQCr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AGJlnOyvyUH7Y4UCxwc4QnjX9UXiWP1AKUcyxCUScRC4rhw2BVDHDG2CvhLHLZqiL54yUO5ZvlhQgNO7rpaalCXCnl4Xn1grp2EsHZoCm4n1y5wHro5O+4WFfYKCfqbohQcM5YIQ7zt6WBuF1zTSagXZSKkpp+rVRZcEdrpkug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dP6OTjYm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740814477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1lv09K7+u/963LMF8vKcIAXQsg8E39PLDPVoO5qmMfA=;
	b=dP6OTjYmCQ6DsSOycBCxMB2OA6AIyIVEF+OBZ4RwpC/gv+vylILAEtjXtobLKQp6bKihwP
	9Vb4r/Z+YE2fnZLqyFRaa9GREghu+mQHR7QGHLfmBovfvLQj94VAQm9Wz65Sn/MpWBnAR2
	50XuM6VwTc/sIL4ramdS2l1eUrR22FA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-mJaHT4ZFOfylJutYQDiZ6A-1; Sat,
 01 Mar 2025 02:34:35 -0500
X-MC-Unique: mJaHT4ZFOfylJutYQDiZ6A-1
X-Mimecast-MFC-AGG-ID: mJaHT4ZFOfylJutYQDiZ6A_1740814474
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A529019540EE;
	Sat,  1 Mar 2025 07:34:34 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E439119560B9;
	Sat,  1 Mar 2025 07:34:33 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	yan.y.zhao@intel.com
Subject: [PATCH 4/4] KVM: TDX: Always honor guest PAT on TDX enabled platforms
Date: Sat,  1 Mar 2025 02:34:28 -0500
Message-ID: <20250301073428.2435768-5-pbonzini@redhat.com>
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

Always honor guest PAT in KVM-managed EPTs on TDX enabled platforms by
making self-snoop feature a hard dependency for TDX and making quirk
KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT not a valid quirk once TDX is enabled.

The quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT only affects memory type of
KVM-managed EPTs. For the TDX-module-managed private EPT, memory type is
always forced to WB now.

Honoring guest PAT in KVM-managed EPTs ensures KVM does not invoke
kvm_zap_gfn_range() when attaching/detaching non-coherent DMA devices;
this would cause mirrored EPTs for TDs to be zapped, as well as incorrect
zapping of the private EPT that is managed by the TDX module.

As a new platform, TDX always comes with self-snoop feature supported and has
no worry to break old not-well-written yet unmodifiable guests. So, simply
force-disable the KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT quirk for TDX VMs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20250224071039.31511-1-yan.y.zhao@intel.com>
[Use disabled_quirks instead of supported_quirks. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b6f6f6e2f02e..4450fd99cb4c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -624,6 +624,7 @@ int tdx_vm_init(struct kvm *kvm)
 
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
+	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
 
 	/*
 	 * Because guest TD is protected, VMM can't parse the instruction in TD.
@@ -3470,6 +3471,11 @@ int __init tdx_bringup(void)
 		goto success_disable_tdx;
 	}
 
+	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
+		pr_err("Self-snoop is required for TDX\n");
+		goto success_disable_tdx;
+	}
+
 	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
 		pr_err("tdx: no TDX private KeyIDs available\n");
 		goto success_disable_tdx;
-- 
2.43.5


