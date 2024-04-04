Return-Path: <kvm+bounces-13555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7474E8986F7
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92EF11C265CE
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CEE12AAE0;
	Thu,  4 Apr 2024 12:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zy7U+MTz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5501D128374
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232819; cv=none; b=qn8YSuUY63Eg+Y1VZcnetNxojkdDypHydo0L+M25aU6Vo68JI5BTZj4VM0Ua+2YHDP4Q6Yv7MCxBDLedrim7U/ivQ5W1wxQ1iEyzcrz8DLw1H5EUWPylZm7xUTHpxnmR2d7fv5NVB4aT8OGT04QiLwH1K7Ijxvd5g6M3w8RHUSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232819; c=relaxed/simple;
	bh=iT2DHc7Dnu0MTBmeRCWyp1MWpS1AxUiy7h9zkRn424s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kzuMj0YfkOE6HVtraS2R6r7Q/gJYR6qxNSbQdAgD04ALo7pevnmW0rS3EYoWfeLJPSpzuK2ZZSREN+yROn4IdDuYkD3Ulo1Pcz4sf7bKaRpcgkQhO3jq6H7IXYmzL5MNowYCayHPaDno01froi8KIng5X3TrBDYisTCwBziLGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zy7U+MTz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XRbIYN6vbA/rR0Hrs1hklUBQZ2CzNDSzd9UTop8sGd0=;
	b=Zy7U+MTzmjULRAwME21jL2I7OakK0gHx1bZpEf7/VsLj/kUVXkxpnJwJ2V/hNmIRrbt9+Q
	KyOzq7eCDyIxY+09zO8OJxttcxpUbnsPq5/99XjEeiEesRF6+7Wn26zNa8+amjRWAWUfV2
	Rj/D791EEUo1Oq4uDONd1sZrPYHvIOk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-DkEirBe8MVqeQITMlD3BxA-1; Thu,
 04 Apr 2024 08:13:30 -0400
X-MC-Unique: DkEirBe8MVqeQITMlD3BxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CAA63C0ED58;
	Thu,  4 Apr 2024 12:13:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA6082024517;
	Thu,  4 Apr 2024 12:13:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v5 09/17] KVM: SEV: introduce to_kvm_sev_info
Date: Thu,  4 Apr 2024 08:13:19 -0400
Message-ID: <20240404121327.3107131-10-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-1-pbonzini@redhat.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/svm/svm.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e24f7d243a0a..f98448dc8be8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -96,7 +96,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 
 static inline bool is_mirroring_enc_context(struct kvm *kvm)
 {
-	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
+	return !!to_kvm_sev_info(kvm)->enc_context_owner;
 }
 
 static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
@@ -653,7 +653,7 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	clflush_cache_range(svm->sev_es.vmsa, PAGE_SIZE);
 
 	vmsa.reserved = 0;
-	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
+	vmsa.handle = to_kvm_sev_info(kvm)->handle;
 	vmsa.address = __sme_pa(svm->sev_es.vmsa);
 	vmsa.len = PAGE_SIZE;
 	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4a1623cacbae..5d5b8ed43db8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -319,6 +319,11 @@ static __always_inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
 	return container_of(kvm, struct kvm_svm, kvm);
 }
 
+static __always_inline struct kvm_sev_info *to_kvm_sev_info(struct kvm *kvm)
+{
+	return &to_kvm_svm(kvm)->sev_info;
+}
+
 static __always_inline bool sev_guest(struct kvm *kvm)
 {
 #ifdef CONFIG_KVM_AMD_SEV
-- 
2.43.0



