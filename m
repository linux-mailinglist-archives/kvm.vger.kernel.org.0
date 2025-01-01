Return-Path: <kvm+bounces-34428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD7D9FF328
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E3E83A2E1F
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 06:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208132745E;
	Wed,  1 Jan 2025 06:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzOE1rRp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3142119
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 06:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735714177; cv=none; b=Lspn+eyLCQF2gexFQbxE36x6d4a/oOUi3Ijh8p3Y4902XHqi2tRySTC7Q/upOaeCzkn/1XmCrgmNWlMVvrV+q6JETD1PmSo23kPHRlnXPwCRbjHLwfXth0H5Uoi5BjPU9lJjMJuQwhF8Kc+ok8n3Jihi308SDTp1xrWGGRSEAW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735714177; c=relaxed/simple;
	bh=k04Mmt26oKB9EiMp1UIMTNMPa56NZCmIvsr7qlrb55A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SKzLCxTsjyKk3tIx3024oZtEdV2Ykj+B5qPH7mSbCKg5h4qNGvCeMSKHNGxcT6RZEGmfkJZYMpjHh4ymqP/oMisxHIOdi51ViUDPkGlndY1jmunO/zA3h5IqDiFk0i45dRDPsYlm43Mx2VMaatuHyfvjttcRkHvClIh4IaGCwuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GzOE1rRp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735714174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YRIIgCXg3JsYIvS3NMssQ9//coF9ig5NRKK0Y4BlSBg=;
	b=GzOE1rRpVuOpjRaj2EIpD7lQ4e6LIFY5pJexbz4bAyebrGGQhHNGIAru8KO+zSv2i8y/47
	GmGHjsBQAm49BeUFqAgX70mDT0rU2S0NMT9v8PN1fNOTWwysfcd8C7z7Kxa5tYARaje6Dt
	X51RHMo9wW8nBnFPmWKLgiVqvcA8kpk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-hpPfv1w2NzOgUfkeFTMczg-1; Wed,
 01 Jan 2025 01:49:32 -0500
X-MC-Unique: hpPfv1w2NzOgUfkeFTMczg-1
X-Mimecast-MFC-AGG-ID: hpPfv1w2NzOgUfkeFTMczg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B92019560A3;
	Wed,  1 Jan 2025 06:49:31 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 426C6195394B;
	Wed,  1 Jan 2025 06:49:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Christian Zigotzky <chzigotzky@xenosoft.de>,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev
Subject: [PATCH] KVM: allow NULL writable argument to __kvm_faultin_pfn
Date: Wed,  1 Jan 2025 01:49:28 -0500
Message-ID: <20250101064928.389504-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

kvm_follow_pfn() is able to work with NULL in the .map_writable field
of the homonymous struct.  But __kvm_faultin_pfn() rejects the combo
despite KVM for e500 trying to use it.  Indeed .map_writable is not
particularly useful if the flags include FOLL_WRITE and readonly
guest memory is not supported, so add support to __kvm_faultin_pfn()
for this case.

Fixes: 1c7b627e9306 ("KVM: Add kvm_faultin_pfn() to specifically service guest page faults")
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: regressions@lists.linux.dev
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..5177e56fdbd5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2975,10 +2975,11 @@ kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
 		.refcounted_page = refcounted_page,
 	};
 
-	if (WARN_ON_ONCE(!writable || !refcounted_page))
+	if (WARN_ON_ONCE(!refcounted_page))
 		return KVM_PFN_ERR_FAULT;
 
-	*writable = false;
+	if (writable)
+		*writable = false;
 	*refcounted_page = NULL;
 
 	return kvm_follow_pfn(&kfp);
-- 
2.43.5


