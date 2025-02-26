Return-Path: <kvm+bounces-39374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1923A46B8F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:59:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80C7916D453
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E36B266B4C;
	Wed, 26 Feb 2025 19:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UhiYODqF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2B7266B75
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599755; cv=none; b=BY3lPCrOUIy8s9+hlP39sSILwUlZlLk4NRPhMQObXUJ8lRV6tej9n8pZB+q2i2LZNrsjxb+MdJC0gUGO8VI/MAhuHeNSVDQtL0sZd49wj6DmnquHCvcShr5yIHZ2sjeLdSkk/JRfDSl9VHOVyBT3vLi5blFla8/AThuHPxrmR9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599755; c=relaxed/simple;
	bh=nxYqlQ4Q76H8m98xHIkGeyvGt6qfnFwkDe9z2ChTqwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QLZIms+amXM0kd81zZU50m9RssJhRsBeeGT4cLn//hdx6AOFJCwlJUBjfLMiVMIXMYf8hrz27JU5crBuAD15XuyHtPcCY6vNfPi+5D7nHIxRnrWpeTaLEtlHpt4+a1rSBYnjNEFmJWTz1n4P1s3qzb7MHJI/00dezMFo4GRpnjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UhiYODqF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2O8ZjLwnVFyUzLWe+2dEyoNSVpwq+lxZUDZDqtjC68w=;
	b=UhiYODqFFtq8hTSotub/eVXQTriZqR0imppSTEyPHxegAj365saOnblNMqMb9yjeB5E3nl
	PGL9+6rztietY++Nd5GXejXakrpSdBp2wolmhmsekChlu8u74cR//aM8R9ILjzW3qry2gP
	GiyWXcYKQvAK+P52mSYLUc0g+tef3u8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-Lzx8YSyyPg-lPQHpNtGVPg-1; Wed,
 26 Feb 2025 14:55:51 -0500
X-MC-Unique: Lzx8YSyyPg-lPQHpNtGVPg-1
X-Mimecast-MFC-AGG-ID: Lzx8YSyyPg-lPQHpNtGVPg_1740599749
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8988A1800876;
	Wed, 26 Feb 2025 19:55:49 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 96770300018D;
	Wed, 26 Feb 2025 19:55:48 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 13/29] KVM: TDX: Set gfn_direct_bits to shared bit
Date: Wed, 26 Feb 2025 14:55:13 -0500
Message-ID: <20250226195529.2314580-14-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make the direct root handle memslot GFNs at an alias with the TDX shared
bit set.

For TDX shared memory, the memslot GFNs need to be mapped at an alias with
the shared bit set. These shared mappings will be mapped on the KVM MMU's
"direct" root. The direct root has it's mappings shifted by applying
"gfn_direct_bits" as a mask. The concept of "GPAW" (guest physical address
width) determines the location of the shared bit. So set gfn_direct_bits
based on this, to map shared memory at the proper GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20241112073613.22100-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ec86c97ada80..09c4d314e6f5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1045,6 +1045,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	kvm_tdx->attributes = td_params->attributes;
 	kvm_tdx->xfam = td_params->xfam;
 
+	if (td_params->config_flags & TDX_CONFIG_FLAGS_MAX_GPAW)
+		kvm->arch.gfn_direct_bits = TDX_SHARED_BIT_PWL_5;
+	else
+		kvm->arch.gfn_direct_bits = TDX_SHARED_BIT_PWL_4;
+
 	kvm_tdx->state = TD_STATE_INITIALIZED;
 out:
 	/* kfree() accepts NULL. */
-- 
2.43.5



