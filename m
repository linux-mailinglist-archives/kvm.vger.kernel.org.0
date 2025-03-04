Return-Path: <kvm+bounces-39978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8570A4D36E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:08:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17A93172353
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4380D1F4CA2;
	Tue,  4 Mar 2025 06:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ARd/5Krq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0BD1F78F2
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068428; cv=none; b=eF0v8EcTh8+QLAbiudghuSkWWZhpWaSyQXsgxq5X1l7DdZWola+4pLmEVTBVcJs/gU8cU0bv3lBGh0p6MQa5Ch6bht86SH46NxXzZ3CRgTHvb+hP/ZgftrIVpzigh3hQ6GFOvBbR0zPZTAsqKvpRF+1ZoaqrCzywCSsRVzIS32w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068428; c=relaxed/simple;
	bh=6SMH+nvsZ9K/pkzEyIYaEKeKuAOROQOzkyq4QpI39/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V8djydXygkITGy8iBbFZ/TzVt0wE0OtNOW1NyPI1m1zDbmla0BxlE4qdbhdobUccm6oDRA6oDb76dskm/hE/WqvohaTl0wnry6NP3FMn7DC6H/zorM4m7XOXPj2yFBJD0/is0NBrg7okJ3iPet1sUc0+G4QNsAyjxKoCvtCUAQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ARd/5Krq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJy41FzUFSGhCGRtfpNprpEPFn03VpR5sk8BsIsJt2c=;
	b=ARd/5KrqH7oF/9NlrJnL0DmtbPPApgsYfREKMyMEmF0Vn4q+kHLYsnsMUzrqnsAIxlZP2b
	F3R/8wL5eE3FZyXEEWiIBHxMxmku7Qvy5fmUPb+5PvRt7rFWpJiyWKDXr8TFooPt80JKY/
	9EDTSYhbFSqX7h34gBSpibjnaByk8hE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-IOSdMb_ZOTiy-c1hLc4Rzg-1; Tue,
 04 Mar 2025 01:06:57 -0500
X-MC-Unique: IOSdMb_ZOTiy-c1hLc4Rzg-1
X-Mimecast-MFC-AGG-ID: IOSdMb_ZOTiy-c1hLc4Rzg_1741068416
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D9491800876;
	Tue,  4 Mar 2025 06:06:56 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E5DA19560A3;
	Tue,  4 Mar 2025 06:06:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	seanjc@google.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 6/6] KVM: TDX: Always honor guest PAT on TDX enabled guests
Date: Tue,  4 Mar 2025 01:06:47 -0500
Message-ID: <20250304060647.2903469-7-pbonzini@redhat.com>
In-Reply-To: <20250304060647.2903469-1-pbonzini@redhat.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Yan Zhao <yan.y.zhao@intel.com>

Always honor guest PAT in KVM-managed EPTs on TDX enabled guests by
making self-snoop feature a hard dependency for TDX and making quirk
KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT not a valid quirk once TDX is enabled.

The quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT only affects memory type of
KVM-managed EPTs. For the TDX-module-managed private EPT, memory type is
always forced to WB now.

Honoring guest PAT in KVM-managed EPTs ensures KVM does not invoke
kvm_zap_gfn_range() when attaching/detaching non-coherent DMA devices,
which would cause mirrored EPTs for TDs to be zapped, leading to the
TDX-module-managed private EPT being incorrectly zapped.

As a new feature, TDX always comes with support for self-snoop, and does
not have to worry about unmodifiable but buggy guests. So, simply ignore
KVM_X86_QUIRK_IGNORE_GUEST_PAT on TDX guests just like kvm-amd.ko already
does.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20250224071039.31511-1-yan.y.zhao@intel.com>
[Only apply to TDX guests. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b6f6f6e2f02e..89a0e90b7aef 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -624,6 +624,7 @@ int tdx_vm_init(struct kvm *kvm)
 
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
+	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
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


