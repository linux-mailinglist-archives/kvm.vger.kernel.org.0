Return-Path: <kvm+bounces-19306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 458BB9038C0
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C93581F22185
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 10:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D2114F9F0;
	Tue, 11 Jun 2024 10:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bIE1y91t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2F854750
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 10:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718101371; cv=none; b=tsImVLLDLiuotLymZ3DSi9ftzU3URBlQ4hg2zyk8XqwaKoKGyv54/12C2meoD9dcjQp7H0YFzi+Ml73XGwG0h3oQH//Oem7yS2dBA04mEBCmJuxVROFC4MuDDwYY60vwW6Zwj8fniETvIuIP9fWKjxROs/WCKi/tWeFruz9mlGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718101371; c=relaxed/simple;
	bh=WT0gl6k9k3gVajA2mjXf9a2LUHhg6bhqE2LOXdj1SIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t4LRv028OvG1RtsblHqGtmvk8x167i0oMvauAWkNiP1iPazLR6dVJ2prfY565Ieyvs1MKSEWvCpkv6wxPkKgz/XeBnvTts8W64JsvH+xoGA4znxZY/M+6B7BgTF9M0PkkaabzlcVKg+eNdCWVN79mUeoGCKbaBG+Iqc2XKrhCuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bIE1y91t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718101368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1R7i0rHLd6UEBvReX1fikUv9t87pEq723UjlWQdzxfI=;
	b=bIE1y91tp9loI6qNuk8dbFoeQHGiXZjGvC6493z44P+B0JJkLAnsrA0DQ7lsNnoEK5gk34
	B1k7g/FX9/pFVraXRJB7baXnKD83vHzMJqQYtWSAWsrocyIgrj8+NIxwYPAqia+O3CzQY2
	ejou16zKgZzEXzrVVs1ys19ScM9dfSE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-T9BpuxgnPUqeRheswzeS9w-1; Tue,
 11 Jun 2024 06:22:46 -0400
X-MC-Unique: T9BpuxgnPUqeRheswzeS9w-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42D9719560AF;
	Tue, 11 Jun 2024 10:22:45 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 42FA230000C4;
	Tue, 11 Jun 2024 10:22:44 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [PATCH] KVM: interrupt kvm_gmem_populate() on signals
Date: Tue, 11 Jun 2024 06:22:43 -0400
Message-ID: <20240611102243.47904-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

kvm_gmem_populate() is a potentially lengthy operation that can involve
multiple calls to the firmware.  Interrupt it if a signal arrives.

Fixes: 1f6c06b177513 ("KVM: guest_memfd: Add interface for populating gmem pages with user data")
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9714add38852..3bfe1824ec2d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -629,6 +629,11 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		gfn_t gfn = start_gfn + i;
 		kvm_pfn_t pfn;
 
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
 		ret = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order, false);
 		if (ret)
 			break;
-- 
2.43.0


