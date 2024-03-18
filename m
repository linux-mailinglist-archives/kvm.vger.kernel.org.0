Return-Path: <kvm+bounces-12055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0164A87F414
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:35:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE3A4B22CE7
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6697A605BF;
	Mon, 18 Mar 2024 23:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKhCwt15"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DD65FB96
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804844; cv=none; b=OAoH4wyTleYggZngPhYUhdfB/YQ/KMfRUyPyq039Cc6mEJvQmNaEAMEE9GcGCttUr14yFaAZYPu4ppNBCqPCZFDXiAp0x95K/gi5YqMnof1jcEC+Txf71IsfoMpwWveRFhKK395AMaAYb+V2CyiUA4Sb9+6V2s7cgdNT9o5/0ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804844; c=relaxed/simple;
	bh=X+wpiCLHt0A0MlEox5pBcvd+CZnKQyhur6Qdq10ypmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c8ytbteU3q5Gmala3dOWaFUNRbKlNML4MaNZfxJsYwWNtJA14oa1j1/Ws5/U144vCgjKCbwWMJXIkKVcHz9SbJEjibR7dm+tpG483/MG7IWaNKreTSLmVbOE7eggrl5hCP4Z9O/Hv0U6DRHOqK4ZlDpNGnuIZnirmIiEhhXx18A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKhCwt15; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/UJD6UkjatoT2sa2f7cYALB+Y8wZfv5tBpC6qWKUlU=;
	b=MKhCwt15Bjd+IJs6E2atJxuXyMIYSKcI06WH8ByRQN/bbdFz8e2vJfMRlUZT6xRrkEkb65
	fhMioylQqyIFvbzx82gnjjpV30woAUKEDYEkiWcxxf3+kG0Ia3LSNnx6bty7G0UJO0BUmH
	Is3Nqtn6zjo5POJbXznVgoFokvCo5o0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-cKMRVEyGNuacM8ctBeGqLw-1; Mon,
 18 Mar 2024 19:33:56 -0400
X-MC-Unique: cKMRVEyGNuacM8ctBeGqLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E65141C05EAD;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C01C81C060CE;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 10/15] KVM: SEV: introduce to_kvm_sev_info
Date: Mon, 18 Mar 2024 19:33:47 -0400
Message-ID: <20240318233352.2728327-11-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/svm/svm.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 800e836a69fb..704cd42b4f1b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -94,7 +94,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 
 static inline bool is_mirroring_enc_context(struct kvm *kvm)
 {
-	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
+	return !!to_kvm_sev_info(kvm)->enc_context_owner;
 }
 
 static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
@@ -679,7 +679,7 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	clflush_cache_range(svm->sev_es.vmsa, PAGE_SIZE);
 
 	vmsa.reserved = 0;
-	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
+	vmsa.handle = to_kvm_sev_info(kvm)->handle;
 	vmsa.address = __sme_pa(svm->sev_es.vmsa);
 	vmsa.len = PAGE_SIZE;
 	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b7707514d042..6313679d464b 100644
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



