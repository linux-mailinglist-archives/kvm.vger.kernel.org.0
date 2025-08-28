Return-Path: <kvm+bounces-56063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2CB4B39887
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:41:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B477C4995
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF60A2F49F6;
	Thu, 28 Aug 2025 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="bcfpHcTb"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829532F0680;
	Thu, 28 Aug 2025 09:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.158.23.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373977; cv=none; b=Mjaub70LsM3odgptEqNRXIPm/3oUALimeyWg2GkxZOqrv4iYTT9ZlYT0C3qzWIvJG7MXoWdBDsqmbslB81Rst+YjqWH8qAXEAzv2xnzsxK8kS3VKWCMLl+G8xffd4Fk24fDZu/tKKFILeaiIhCy98EdEMfqqsYQMb2vgS6u+5uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373977; c=relaxed/simple;
	bh=AQ7ryES0rxz3cGanwiiCgDNyUNIYhiR0LUKgkDqky7Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b+9KW1nJKvyDrwXEa6cK0EMEunRmnv9K6sa0RwE6ISxWA6G4zc5dqtRyTNtL8xqyWYPfyk4lW07yj5SWzQz0SxaGkLg6kyg2weAi1tdSDllF7G/+kz1vImgnWDGe6OJwxhtlW5DYUNuxXhY3ZzAb6xydL81wMFgTQvEL7Vq3t5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=bcfpHcTb; arc=none smtp.client-ip=35.158.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373975; x=1787909975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ojtm9hG3uDHHN9CPzAzA1kwd7CoLxip6b5f2qHGneMU=;
  b=bcfpHcTbH/o7Y55s8ijUDFX9hEjXA/xOaK5TabXeZne1ua2p1hm+162h
   Skd+wKtzO+1IeeaUn9cDa+1oDqfzjEQp0Mx3Oc9cJ6SkHXsQTdnyjKRy4
   kc/Q465ZVynuey6Q/Xg4slorAc7iztxm6onxbfPpjfEz/ywU2MkIH397G
   EEATyb/jgktSg1j4vmtrmzZtkKmHcLvuDL+gBpfaEaXepuPQ0UB+jvelG
   T9HxWA9wN7GYvzTUy7Z0gtflrvGHGOxCr1aU5+873B1y6u5oFPJfLnrqn
   e2+2yPudPf7YUkcLbe6m9PiiWtucc0qImOlTZWqvHJyDwR5n6zMs+Iekh
   Q==;
X-CSE-ConnectionGUID: RbFhNUEdT4GAw4sjaHWgJA==
X-CSE-MsgGUID: rBTTxvnjRyaNUzDadwvW4A==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303847"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:34 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:21352]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.1:2525] with esmtp (Farcaster)
 id 7011dc75-05c8-4dc5-9da1-0763e3fb5b81; Thu, 28 Aug 2025 09:39:33 +0000 (UTC)
X-Farcaster-Flow-ID: 7011dc75-05c8-4dc5-9da1-0763e3fb5b81
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:33 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:32 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:32 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 12/12] KVM: selftests: Test guest execution from direct map
 removed gmem
Thread-Topic: [PATCH v5 12/12] KVM: selftests: Test guest execution from
 direct map removed gmem
Thread-Index: AQHcF/+ov3wHy4Cyx0u9xmPfJ46Qpw==
Date: Thu, 28 Aug 2025 09:39:32 +0000
Message-ID: <20250828093902.2719-13-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Add a selftest that loads itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) and triggers an MMIO exit when executed. This=0A=
exercises x86 MMIO emulation code inside KVM for guest_memfd-backed=0A=
memslots where the guest_memfd folios are direct map removed.=0A=
Particularly, it validates that x86 MMIO emulation code (guest page=0A=
table walks + instruction fetch) correctly accesses gmem through the VMA=0A=
that's been reflected into the memslot's userspace_addr field (instead=0A=
of trying to do direct map accesses).=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../selftests/kvm/set_memory_region_test.c    | 50 +++++++++++++++++--=0A=
 1 file changed, 46 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/t=
esting/selftests/kvm/set_memory_region_test.c=0A=
index ce3ac0fd6dfb..cb3bc642d376 100644=0A=
--- a/tools/testing/selftests/kvm/set_memory_region_test.c=0A=
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c=0A=
@@ -603,6 +603,41 @@ static void test_mmio_during_vectoring(void)=0A=
 =0A=
 	kvm_vm_free(vm);=0A=
 }=0A=
+=0A=
+static void guest_code_trigger_mmio(void)=0A=
+{=0A=
+	/*=0A=
+	 * Read some GPA that is not backed by a memslot. KVM consider this=0A=
+	 * as MMIO and tell userspace to emulate the read.=0A=
+	 */=0A=
+	READ_ONCE(*((uint64_t *)MEM_REGION_GPA));=0A=
+=0A=
+	GUEST_DONE();=0A=
+}=0A=
+=0A=
+static void test_guest_memfd_mmio(void)=0A=
+{=0A=
+	struct kvm_vm *vm;=0A=
+	struct kvm_vcpu *vcpu;=0A=
+	struct vm_shape shape =3D {=0A=
+		.mode =3D VM_MODE_DEFAULT,=0A=
+		.src_type =3D VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,=0A=
+	};=0A=
+	pthread_t vcpu_thread;=0A=
+=0A=
+	pr_info("Testing MMIO emulation for instructions in gmem\n");=0A=
+=0A=
+	vm =3D __vm_create_shape_with_one_vcpu(shape, &vcpu, 0, guest_code_trigge=
r_mmio);=0A=
+=0A=
+	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 1);=0A=
+=0A=
+	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);=0A=
+=0A=
+	/* If the MMIO read was successfully emulated, the vcpu thread will exit =
*/=0A=
+	pthread_join(vcpu_thread, NULL);=0A=
+=0A=
+	kvm_vm_free(vm);=0A=
+}=0A=
 #endif=0A=
 =0A=
 int main(int argc, char *argv[])=0A=
@@ -626,10 +661,17 @@ int main(int argc, char *argv[])=0A=
 	test_add_max_memory_regions();=0A=
 =0A=
 #ifdef __x86_64__=0A=
-	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD) &&=0A=
-	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {=
=0A=
-		test_add_private_memory_region();=0A=
-		test_add_overlapping_private_memory_regions();=0A=
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD)) {=0A=
+		if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM)) {=0A=
+			test_add_private_memory_region();=0A=
+			test_add_overlapping_private_memory_regions();=0A=
+		}=0A=
+=0A=
+		if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP) &&=0A=
+			kvm_has_cap(KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP))=0A=
+			test_guest_memfd_mmio();=0A=
+		else=0A=
+			pr_info("Skipping tests requiring KVM_CAP_GUEST_MEMFD_MMAP | KVM_CAP_GU=
EST_MEMFD_NO_DIRECT_MAP");=0A=
 	} else {=0A=
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");=0A=
 	}=0A=
-- =0A=
2.50.1=0A=
=0A=

