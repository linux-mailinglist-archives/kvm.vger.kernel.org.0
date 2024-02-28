Return-Path: <kvm+bounces-10221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D7686AC07
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8563F1C2186D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815424F20A;
	Wed, 28 Feb 2024 10:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BwyB4Wvd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462B048792
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 10:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709115526; cv=none; b=oICZfCiwOTXZ7FveTdoJTOvLNSNZFd6CsisOIiYOCICkJBTsNdL7hMcsg3FF2VppVxMXI8+n0XqT8RKIc0bm1/QBAiQikGbSZ4b0yJvzy29qoL0QafSRjLtvRAkenv6JJY5E9NboG++p79hq84HVOstSLV7gfLQiHUPMVyHtjB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709115526; c=relaxed/simple;
	bh=9GX/XMY+qWHH5f0/ts7l5PYv9fa6tTvpHvjq3I6ksOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FYOKxCFBN3HGdKyaDZLh+cGMGsApXd4GFswbldIr43Ncs4ds2pjTOQ3aUj6xoc+HimFZmNV0OOv31YsUuP6LulgGsQDiKzfH62wvjt0fhLN7POQsDj6cUS6TxoFRR9vi0GJ2JXEB6u2/PT8cj1NHHY7795Q05a9qt4OqACRRMEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BwyB4Wvd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709115524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tru+vVOx4RxykInR0Cy5aul0KMpFDZJO5JqglFuDZAM=;
	b=BwyB4WvdtdzfJ3fgcbGkhXeyaSMs2evtNnkaQSnqPhGdge2VYkbTH6fIx5oU/juyByT+HU
	OYPjpjt0lCt+2/V6hi5uR4XYMqa5ZnmjsP4aHUpAzptdpM9LzGawKu9YZfEUMrFgKnOvz1
	fg+1cdFqgi3mv46kl2nSOJ+4rwBAxX0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-0bEoAZwaNEu0p7SajveeqA-1; Wed,
 28 Feb 2024 05:18:40 -0500
X-MC-Unique: 0bEoAZwaNEu0p7SajveeqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A77F28AC1D3;
	Wed, 28 Feb 2024 10:18:40 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.93])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 999AD8177;
	Wed, 28 Feb 2024 10:18:39 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Li RongQing <lirongqing@baidu.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Introduce __kvm_get_hypervisor_cpuid() helper
Date: Wed, 28 Feb 2024 11:18:35 +0100
Message-ID: <20240228101837.93642-2-vkuznets@redhat.com>
In-Reply-To: <20240228101837.93642-1-vkuznets@redhat.com>
References: <20240228101837.93642-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Similar to kvm_find_kvm_cpuid_features()/__kvm_find_kvm_cpuid_features(),
introduce a helper to search for the specific hypervisor signature in any
struct kvm_cpuid_entry2 array, not only in vcpu->arch.cpuid_entries.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..0e1e3e5df6dd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -189,15 +189,15 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	return 0;
 }
 
-static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
-							    const char *sig)
+static struct kvm_hypervisor_cpuid __kvm_get_hypervisor_cpuid(struct kvm_cpuid_entry2 *entries,
+							      int nent, const char *sig)
 {
 	struct kvm_hypervisor_cpuid cpuid = {};
 	struct kvm_cpuid_entry2 *entry;
 	u32 base;
 
 	for_each_possible_hypervisor_cpuid_base(base) {
-		entry = kvm_find_cpuid_entry(vcpu, base);
+		entry = cpuid_entry2_find(entries, nent, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 
 		if (entry) {
 			u32 signature[3];
@@ -217,6 +217,13 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
 	return cpuid;
 }
 
+static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
+							    const char *sig)
+{
+	return __kvm_get_hypervisor_cpuid(vcpu->arch.cpuid_entries,
+					  vcpu->arch.cpuid_nent, sig);
+}
+
 static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu,
 					      struct kvm_cpuid_entry2 *entries, int nent)
 {
-- 
2.43.0


