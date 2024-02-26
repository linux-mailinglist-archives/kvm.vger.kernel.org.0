Return-Path: <kvm+bounces-9976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5010868065
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B6631F27F93
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED0F13175D;
	Mon, 26 Feb 2024 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RCjfq8Da"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4002C12FF9E
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974236; cv=none; b=VXNlsTR/72wazKNdNxqzGky0iVTcTfT3vkjiYO2KizWCW2EoKsxy5LVVox1bqpFAjHTxbGIjo1FkhsIB2WkgFtNAkhUNgcSDnwAKGECZeA73kfgaQbR6mASVj44Y1YMDSLAMOx9VSqau0d7pwtuqMxns94P0epXQsEIpUvUYPN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974236; c=relaxed/simple;
	bh=8VFZJ7mBeFkFJM3OtDw+ZbNYCfcWygjdv2FVwNhWvGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iV9bVvcuFhM1K5vrB5cPl7Srle5bCQ2Yw5hLfKAldVH07SFqsvkW6Y/M028387y5xzzMxPf1+EUo7Z1LguRmDdF9jHvKliC0Rz8C/B+5IWpHJ/8Lxitc+K0GxMLfCvF8UzRvMxcxMUvxBEyT6IP18ZYInHeqOMvxdS4nRIooxME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RCjfq8Da; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7fRP/l4ehwN5ICk87a5/9ybtOo+Pl5c8O/deIJ0OHBM=;
	b=RCjfq8DaWdprkXGxg+JaA5EDpVqY6U3LALF/nTDy6vyMg+3AirVJmEKynAgHdRDt01QJOR
	JeEDb89I9/B3NLjwcToycuExZIRqUmmNWu6aXx26DoDoWjkbR9ZVz90SMcsujxgDJOe2fg
	GNczDqbFsKH5AoB5lYdWbH8QSj6KYnM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-ykJPlzMQMTqbCiRyKDkhYA-1; Mon, 26 Feb 2024 14:03:48 -0500
X-MC-Unique: ykJPlzMQMTqbCiRyKDkhYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AF7A8F7769;
	Mon, 26 Feb 2024 19:03:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 057F9400D784;
	Mon, 26 Feb 2024 19:03:48 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 12/15] KVM: SEV: introduce to_kvm_sev_info
Date: Mon, 26 Feb 2024 14:03:41 -0500
Message-Id: <20240226190344.787149-13-pbonzini@redhat.com>
In-Reply-To: <20240226190344.787149-1-pbonzini@redhat.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/svm/svm.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2db0b2b36120..2549a539a686 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -93,7 +93,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 
 static inline bool is_mirroring_enc_context(struct kvm *kvm)
 {
-	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
+	return !!to_kvm_sev_info(kvm)->enc_context_owner;
 }
 
 static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
@@ -644,7 +644,7 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	clflush_cache_range(svm->sev_es.vmsa, PAGE_SIZE);
 
 	vmsa.reserved = 0;
-	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
+	vmsa.handle = to_kvm_sev_info(kvm)->handle;
 	vmsa.address = __sme_pa(svm->sev_es.vmsa);
 	vmsa.len = PAGE_SIZE;
 	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d6147ad18571..ebf2160bf0c6 100644
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
2.39.1



