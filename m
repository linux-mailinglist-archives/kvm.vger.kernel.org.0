Return-Path: <kvm+bounces-56066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C20B39891
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6AA0D4E45DA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A452FDC5F;
	Thu, 28 Aug 2025 09:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="qhUcZ6gt"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44612F3C3D;
	Thu, 28 Aug 2025 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373981; cv=none; b=SbXJA5ei0SZr2XoJGnJIxNf6oYmBRbZay1VB/bKECfFfnCIjy72aMli6EIYB71BYM1QQ/Wj4lMX3t12847sFyhVpRMgmFgnc5hrpZq9pvZxOjGEDVdODSHAw81SXUPXPZPyJBM+ZQgUES2mnv2Ge5+u6ysbde7i6I1C91PEMghY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373981; c=relaxed/simple;
	bh=kCA7I8O/bIQ5VR41rCrn7q7wuheONqlGizzpnXwizAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mw4ejg8IQMEyX2Ulrx7n+8JudxGf5ByzbQ+488UhTHNljpQ2nnFqAsKJYnhz4+wejTegCyQeSJTRUCaS6vxGtHTsBZ/wxsMBMQdSRHz1Fp8DjooGq4zzjQXwqotK0m69UiU8suU5wTuG8966BMPmglt/q84I5sSTNevqEBRq6VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=qhUcZ6gt; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373979; x=1787909979;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=41cdObRV2/ULxTOTq6Jo3VA2F7BSJFHzuhvS9zYggVk=;
  b=qhUcZ6gtI1w89iLMQWTbQ0FRjuvHvT3jWxvzf50xbIgh7TNNddCeNOfb
   eF83n8YhFOSaGhAckY7QjY5lhM6xZAf5KwPik+fRa9qANL9y+daImxgOB
   8f3eGlcB5hG8vyH4aqgqvcddq1kw+PwQI58WFK+Iia1sQ6hEQcux1IZvm
   3AcleIrE90EUBnzJiV5ljiQkMbK71sRmBx8nrHIY0n/y09T6ShJRTa97S
   cGqiY05GDPOXXkzIUrt3avvrz9HuJ3sMGkCHK1sdhtCx88oQZtrMT6vCM
   sY/z7dNDLDYp7b4/eRtEaBvILcJ0MdYHCHCtok0P7ip5LIzpx1xCAic8p
   g==;
X-CSE-ConnectionGUID: 7NHgI4b7QDW8PKjfOwUOUw==
X-CSE-MsgGUID: 07tME+q3T0KAl4VYV4WBQw==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1301820"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:31 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:11142]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.7.27:2525] with esmtp (Farcaster)
 id d179c768-560e-475d-8e59-3cb241b207a9; Thu, 28 Aug 2025 09:39:30 +0000 (UTC)
X-Farcaster-Flow-ID: d179c768-560e-475d-8e59-3cb241b207a9
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:26 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:26 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:26 +0000
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
Subject: [PATCH v5 08/12] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Topic: [PATCH v5 08/12] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Index: AQHcF/+kC3wc6YsPZk2H57V39QScZw==
Date: Thu, 28 Aug 2025 09:39:26 +0000
Message-ID: <20250828093902.2719-9-roypat@amazon.co.uk>
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

Allow selftests to configure their memslots such that userspace_addr is=0A=
set to a MAP_SHARED mapping of the guest_memfd that's associated with=0A=
the memslot. This setup is the configuration for non-CoCo VMs, where all=0A=
guest memory is backed by a guest_memfd whose folios are all marked=0A=
shared, but KVM is still able to access guest memory to provide=0A=
functionality such as MMIO emulation on x86.=0A=
=0A=
Add backing types for normal guest_memfd, as well as direct map removed=0A=
guest_memfd.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 18 ++++++=0A=
 .../testing/selftests/kvm/include/test_util.h |  7 +++=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    | 63 ++++++++++---------=0A=
 tools/testing/selftests/kvm/lib/test_util.c   |  8 +++=0A=
 4 files changed, 66 insertions(+), 30 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h=0A=
index 23a506d7eca3..5204a0a18a7f 100644=0A=
--- a/tools/testing/selftests/kvm/include/kvm_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/kvm_util.h=0A=
@@ -635,6 +635,24 @@ static inline bool is_smt_on(void)=0A=
 =0A=
 void vm_create_irqchip(struct kvm_vm *vm);=0A=
 =0A=
+static inline uint32_t backing_src_guest_memfd_flags(enum vm_mem_backing_s=
rc_type t)=0A=
+{=0A=
+	uint32_t flags =3D 0;=0A=
+=0A=
+	switch (t) {=0A=
+	case VM_MEM_SRC_GUEST_MEMFD:=0A=
+		flags |=3D GUEST_MEMFD_FLAG_MMAP;=0A=
+		fallthrough;=0A=
+	case VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP:=0A=
+		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
+		break;=0A=
+	default:=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	return flags;=0A=
+}=0A=
+=0A=
 static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size=
,=0A=
 					uint64_t flags)=0A=
 {=0A=
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testin=
g/selftests/kvm/include/test_util.h=0A=
index 0409b7b96c94..a56e53fc7b39 100644=0A=
--- a/tools/testing/selftests/kvm/include/test_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/test_util.h=0A=
@@ -133,6 +133,8 @@ enum vm_mem_backing_src_type {=0A=
 	VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB,=0A=
 	VM_MEM_SRC_SHMEM,=0A=
 	VM_MEM_SRC_SHARED_HUGETLB,=0A=
+	VM_MEM_SRC_GUEST_MEMFD,=0A=
+	VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,=0A=
 	NUM_SRC_TYPES,=0A=
 };=0A=
 =0A=
@@ -165,6 +167,11 @@ static inline bool backing_src_is_shared(enum vm_mem_b=
acking_src_type t)=0A=
 	return vm_mem_backing_src_alias(t)->flag & MAP_SHARED;=0A=
 }=0A=
 =0A=
+static inline bool backing_src_is_guest_memfd(enum vm_mem_backing_src_type=
 t)=0A=
+{=0A=
+	return t =3D=3D VM_MEM_SRC_GUEST_MEMFD || t =3D=3D VM_MEM_SRC_GUEST_MEMFD=
_NO_DIRECT_MAP;=0A=
+}=0A=
+=0A=
 static inline bool backing_src_can_be_huge(enum vm_mem_backing_src_type t)=
=0A=
 {=0A=
 	return t !=3D VM_MEM_SRC_ANONYMOUS && t !=3D VM_MEM_SRC_SHMEM;=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index cc67dfecbf65..a81089f7c83f 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1060,6 +1060,34 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backi=
ng_src_type src_type,=0A=
 	alignment =3D 1;=0A=
 #endif=0A=
 =0A=
+	if (guest_memfd < 0) {=0A=
+		if ((flags & KVM_MEM_GUEST_MEMFD) || backing_src_is_guest_memfd(src_type=
)) {=0A=
+			uint32_t guest_memfd_flags =3D backing_src_guest_memfd_flags(src_type);=
=0A=
+=0A=
+			TEST_ASSERT(!guest_memfd_offset,=0A=
+				    "Offset must be zero when creating new guest_memfd");=0A=
+			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
+		}=0A=
+	} else {=0A=
+		/*=0A=
+		 * Install a unique fd for each memslot so that the fd=0A=
+		 * can be closed when the region is deleted without=0A=
+		 * needing to track if the fd is owned by the framework=0A=
+		 * or by the caller.=0A=
+		 */=0A=
+		guest_memfd =3D dup(guest_memfd);=0A=
+		TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd=
));=0A=
+	}=0A=
+=0A=
+	if (guest_memfd > 0) {=0A=
+		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
+=0A=
+		region->region.guest_memfd =3D guest_memfd;=0A=
+		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
+	} else {=0A=
+		region->region.guest_memfd =3D -1;=0A=
+	}=0A=
+=0A=
 	/*=0A=
 	 * When using THP mmap is not guaranteed to returned a hugepage aligned=
=0A=
 	 * address so we have to pad the mmap. Padding is not needed for HugeTLB=
=0A=
@@ -1075,10 +1103,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
ing_src_type src_type,=0A=
 	if (alignment > 1)=0A=
 		region->mmap_size +=3D alignment;=0A=
 =0A=
-	region->fd =3D -1;=0A=
-	if (backing_src_is_shared(src_type))=0A=
+	if (backing_src_is_guest_memfd(src_type))=0A=
+		region->fd =3D guest_memfd;=0A=
+	else if (backing_src_is_shared(src_type))=0A=
 		region->fd =3D kvm_memfd_alloc(region->mmap_size,=0A=
 					     src_type =3D=3D VM_MEM_SRC_SHARED_HUGETLB);=0A=
+	else=0A=
+		region->fd =3D -1;=0A=
 =0A=
 	region->mmap_start =3D mmap(NULL, region->mmap_size,=0A=
 				  PROT_READ | PROT_WRITE,=0A=
@@ -1106,34 +1137,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backi=
ng_src_type src_type,=0A=
 	}=0A=
 =0A=
 	region->backing_src_type =3D src_type;=0A=
-=0A=
-	if (guest_memfd < 0) {=0A=
-		if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
-			uint32_t guest_memfd_flags =3D 0;=0A=
-			TEST_ASSERT(!guest_memfd_offset,=0A=
-				    "Offset must be zero when creating new guest_memfd");=0A=
-			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
-		}=0A=
-	} else {=0A=
-		/*=0A=
-		 * Install a unique fd for each memslot so that the fd=0A=
-		 * can be closed when the region is deleted without=0A=
-		 * needing to track if the fd is owned by the framework=0A=
-		 * or by the caller.=0A=
-		 */=0A=
-		guest_memfd =3D dup(guest_memfd);=0A=
-		TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd=
));=0A=
-	}=0A=
-=0A=
-	if (guest_memfd > 0) {=0A=
-		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
-=0A=
-		region->region.guest_memfd =3D guest_memfd;=0A=
-		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-	} else {=0A=
-		region->region.guest_memfd =3D -1;=0A=
-	}=0A=
-=0A=
 	region->unused_phy_pages =3D sparsebit_alloc();=0A=
 	if (vm_arch_has_protected_memory(vm))=0A=
 		region->protected_phy_pages =3D sparsebit_alloc();=0A=
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/se=
lftests/kvm/lib/test_util.c=0A=
index 03eb99af9b8d..b2baee680083 100644=0A=
--- a/tools/testing/selftests/kvm/lib/test_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/test_util.c=0A=
@@ -299,6 +299,14 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_=
src_alias(uint32_t i)=0A=
 			 */=0A=
 			.flag =3D MAP_SHARED,=0A=
 		},=0A=
+		[VM_MEM_SRC_GUEST_MEMFD] =3D {=0A=
+			.name =3D "guest_memfd",=0A=
+			.flag =3D MAP_SHARED,=0A=
+		},=0A=
+		[VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP] =3D {=0A=
+			.name =3D "guest_memfd_no_direct_map",=0A=
+			.flag =3D MAP_SHARED,=0A=
+		}=0A=
 	};=0A=
 	_Static_assert(ARRAY_SIZE(aliases) =3D=3D NUM_SRC_TYPES,=0A=
 		       "Missing new backing src types?");=0A=
-- =0A=
2.50.1=0A=
=0A=

