Return-Path: <kvm+bounces-10224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C7386AC10
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24FACB2598E
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C40537E5;
	Wed, 28 Feb 2024 10:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P04OEPkq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A67A52F65
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 10:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709115531; cv=none; b=OHx8Gndh29moHW5cJeZboZIukrFqtT/+PUKPMk910fqc4n/QlrhAAF5MHEFUEtueci3LalSEwgB+ERPYQS2p/8SiHiPORmQ2+BIGBXWJA3wv5i2OpGhAUVkc7kle7Gylby0OARteNuHsQnobTH83FKsONTgGK2CBGsVBhs7fbCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709115531; c=relaxed/simple;
	bh=MmAxZeXm6ySHX8QqZPQEg5xdtw2UlmdNm+MH9FdZFl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNDQhmIY4gTLdjnebZE2PAQo1h2ZtkAyAlhIALS3OwHPZdhzH+s5O4l4SpgEY6qHUDQhwjS9ZPyuep2oDieJGIMXffVB3bEKX9yM32PrHsy/XQcF9xQAeyTvFcL82Pe6M6ns+rOjprRUeGmDirkndTFR2vCwE0jVd8Lv3p89RJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P04OEPkq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709115528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15m+OfdU4bOi0nHIjrNzMXNbHQ8G8Ha+jOqgfdqoMVA=;
	b=P04OEPkqrgkHUzvdpnzg4IgsBHs2niCVp/JSy7FzhCxKSDOZ6u7AVSEsmdEroQfgOimfNK
	kbj0dSQsmFs+nTcPjTqJraHWCTYzslWE/9MqT4cDoRZgi7hoyeVcbIywuUoVKVeU25iavl
	OrfggtdV5sKjldxbqrzXU0UVkorTEDs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-UaQ4UnogOLe-SZLVay7y2w-1; Wed,
 28 Feb 2024 05:18:43 -0500
X-MC-Unique: UaQ4UnogOLe-SZLVay7y2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6B6F3C11A14;
	Wed, 28 Feb 2024 10:18:42 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.93])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 015D98177;
	Wed, 28 Feb 2024 10:18:41 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Li RongQing <lirongqing@baidu.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: selftests: Check that KVM_FEATURE_PV_UNHALT is cleared with KVM_X86_DISABLE_EXITS_HLT
Date: Wed, 28 Feb 2024 11:18:37 +0100
Message-ID: <20240228101837.93642-4-vkuznets@redhat.com>
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

KVM_FEATURE_PV_UNHALT is expected to get cleared from KVM PV feature CPUID
data when KVM_X86_DISABLE_EXITS_HLT is enabled. Add the corresponding test
to kvm_pv_test.

Note, the newly added code doesn't actually test KVM_FEATURE_PV_UNHALT and
KVM_X86_DISABLE_EXITS_HLT features.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/kvm_pv_test.c        | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 9e2879af7c20..60399454b45e 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -133,6 +133,46 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void test_pv_unhalt(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct kvm_cpuid_entry2 *ent;
+	u32 kvm_sig_old;
+
+	pr_info("testing KVM_FEATURE_PV_UNHALT\n");
+
+	TEST_REQUIRE(KVM_CAP_X86_DISABLE_EXITS);
+
+	/* KVM_PV_UNHALT test */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
+	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);
+
+	ent = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_FEATURES);
+
+	TEST_ASSERT(ent->eax & (1 << KVM_FEATURE_PV_UNHALT),
+		    "Enabling X86_FEATURE_KVM_PV_UNHALT had no effect");
+
+	/* Make sure KVM clears vcpu->arch.kvm_cpuid */
+	ent = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_SIGNATURE);
+	kvm_sig_old = ent->ebx;
+	ent->ebx = 0xdeadbeef;
+	vcpu_set_cpuid(vcpu);
+
+	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS, KVM_X86_DISABLE_EXITS_HLT);
+	ent = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_SIGNATURE);
+	ent->ebx = kvm_sig_old;
+	vcpu_set_cpuid(vcpu);
+	ent = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_FEATURES);
+
+	TEST_ASSERT(!(ent->eax & (1 << KVM_FEATURE_PV_UNHALT)),
+		    "KVM_FEATURE_PV_UNHALT is set with KVM_CAP_X86_DISABLE_EXITS");
+
+	/* FIXME: actually test KVM_FEATURE_PV_UNHALT feature */
+
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -151,4 +191,6 @@ int main(void)
 
 	enter_guest(vcpu);
 	kvm_vm_free(vm);
+
+	test_pv_unhalt();
 }
-- 
2.43.0


