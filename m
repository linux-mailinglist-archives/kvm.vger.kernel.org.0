Return-Path: <kvm+bounces-39382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB46A46BA9
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 429C316D2CA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41B627425A;
	Wed, 26 Feb 2025 19:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZEAc/Q6a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10423271826
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599767; cv=none; b=XDjDdVSxAio1TeHXL2lUdk8KV0VebP51RNqmb9VWjJKSgceRZhqrZ5kt8f7g9DSinHDwU5YVKDP4Fad5LJcRX7ti9pFNyBQORgwz5GzOUVgEsbklelY3jthgqlZMuPzm0gLt5ExOorDZORaUU3EogOHdtFwf07rRXN5g+TceeYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599767; c=relaxed/simple;
	bh=x9+CRJONKRTnB7NtIzMLFEu/CRw2C1cGKXE2qZ2iymw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uw+BCUfNTQM204yWLEiqeaiV7FQjQmGfyfJT35bgBwsO4QEHQnZjnm0Ky6W1TYkeNvyyDHO3nUr1F5R1JVgbkkbIOe5mhcxrO/ggk6PBrFEUUS0HlDS2Wq5ZDiRLaDm14HiYKGhPo6H+ZdcYvTcuV4GPS3jPJKsPnFBHBaCIBlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZEAc/Q6a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=69N2ySQEB9r7pxaQeeuPr6qhpNtr/uJzO4TGLmLzoMI=;
	b=ZEAc/Q6aJu2uFwm8tL9NG8X3+UB6Ia0RkZdfhd26Zy3EHn71ZnSWuaC63vEIhqR2//iaMP
	Ni1HARsisPtrEOUa9MWWH1W3CiB4uSTB3crs55NwU5iCaWp/Id+XutUlAucKGYK1xxUwEb
	ooRKw87RGel+4aeHZrIaNjG2TduoLpw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-207-19nAfOdjOc6rRNoWfyNh1A-1; Wed,
 26 Feb 2025 14:56:00 -0500
X-MC-Unique: 19nAfOdjOc6rRNoWfyNh1A-1
X-Mimecast-MFC-AGG-ID: 19nAfOdjOc6rRNoWfyNh1A_1740599759
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 666021800874;
	Wed, 26 Feb 2025 19:55:59 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7FAE419560AE;
	Wed, 26 Feb 2025 19:55:58 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 21/29] KVM: x86/mmu: Export kvm_tdp_map_page()
Date: Wed, 26 Feb 2025 14:55:21 -0500
Message-ID: <20250226195529.2314580-22-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

In future changes coco specific code will need to call kvm_tdp_map_page()
from within their respective gmem_post_populate() callbacks. Export it
so this can be done from vendor specific code. Since kvm_mmu_reload()
will be needed for this operation, export its callee kvm_mmu_load() as
well.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073827.22270-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4e18b33a21a..443c4836bc62 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4728,6 +4728,7 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		return -EIO;
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
 
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range)
@@ -5751,6 +5752,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
-- 
2.43.5



