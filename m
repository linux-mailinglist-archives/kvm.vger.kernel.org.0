Return-Path: <kvm+bounces-56068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7420EB39896
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:42:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F164A985ADE
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627C42FFDDA;
	Thu, 28 Aug 2025 09:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="cXadmTPl"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A752FA0F2;
	Thu, 28 Aug 2025 09:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.197.217.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373983; cv=none; b=fPpe5JF7r9L1z1/IkWBjtWUDic0HrIgC1XRs00fPc52bP5n/nBMtSWVc4gWVJU0wpkHXI+fr47FUiCPNrOQnfXCoGP2TB2WQzP9u57886Alf8rW/P2kFPiID1u30uqSvci93iHqEfKTnua5STN7xQo4ROs5XbjAIw5N26R3xrEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373983; c=relaxed/simple;
	bh=NYcAcx7X0okYkIT+tSpJ7AuViKn0GgrGcPA9WT5D0kQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u3VXnQDgbGfY26CQwU65SAVH+D4/yYPuvmU3LowXPLJhM+xmMcHysYBpnmDcvZkA63DINc8gBwJhoMQaUvWmvVSjjpeKa/zxZvsKRsOrQMsTxmpTK8htb9g6rm0kL1mqkigFaOEpgqniuCa169gATDpHg3ZzrQIQ56dMdFhF5Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=cXadmTPl; arc=none smtp.client-ip=18.197.217.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373981; x=1787909981;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dhEedpfYEt1PcCJtARYDpqAPZgRl3DEDExfgwDPiBsk=;
  b=cXadmTPlmLsfzO0V41lZmS7buh1uY6hnAWWwqkLjxs962bOOBxQ7zww9
   kFBFSzQNlSIisN0F/veCWiGGo1MGyRrKZ78FN1ZTQ6Yf655cmznXQy/S2
   tP4RCdnCTLkqClNQP1WdUqgIHg3uGwPle5Hj3CVVawUsYQhUtb5IhinEP
   cSvhnk4aWr1pgC/6LDgyG3J8VBlnM/Hk2NdoAAVaE/wWyfUC3j00G1O6r
   NDdmkrYLrMpUw1PeqQUHfOuAqGKJC9MQUAnofsS5yO97zhHbKpf2ILQLq
   2FYejpkAMctVQh7CfhbMmlvqWbtIc/IPixgKDub8/tYBThgTrLEnxsBun
   w==;
X-CSE-ConnectionGUID: 94cnJsPZSVCixxOlDSzfKw==
X-CSE-MsgGUID: 1aQWO5cOQ+KHlvOc/xQGIg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1302930"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:30 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:20645]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.1:2525] with esmtp (Farcaster)
 id 2dd33327-f6b5-4325-83df-38702bedd8bd; Thu, 28 Aug 2025 09:39:29 +0000 (UTC)
X-Farcaster-Flow-ID: 2dd33327-f6b5-4325-83df-38702bedd8bd
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:25 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:25 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:25 +0000
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
Subject: [PATCH v5 07/12] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v5 07/12] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHcF/+kFWmAB7yvMUW8ahTYWv+Nrg==
Date: Thu, 28 Aug 2025 09:39:25 +0000
Message-ID: <20250828093902.2719-8-roypat@amazon.co.uk>
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

Have vm_mem_add() always set KVM_MEM_GUEST_MEMFD in the memslot flags if=0A=
a guest_memfd is passed in as an argument. This eliminates the=0A=
possibility where a guest_memfd instance is passed to vm_mem_add(), but=0A=
it ends up being ignored because the flags argument does not specify=0A=
KVM_MEM_GUEST_MEMFD at the same time.=0A=
=0A=
This makes it easy to support more scenarios in which no vm_mem_add() is=0A=
not passed a guest_memfd instance, but is expected to allocate one.=0A=
Currently, this only happens if guest_memfd =3D=3D -1 but flags &=0A=
KVM_MEM_GUEST_MEMFD !=3D 0, but later vm_mem_add() will gain support for=0A=
loading the test code itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) if requested via a special=0A=
vm_mem_backing_src_type, at which point having to make sure the src_type=0A=
and flags are in-sync becomes cumbersome.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c | 26 +++++++++++++---------=0A=
 1 file changed, 15 insertions(+), 11 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index c3f5142b0a54..cc67dfecbf65 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1107,22 +1107,26 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
ing_src_type src_type,=0A=
 =0A=
 	region->backing_src_type =3D src_type;=0A=
 =0A=
-	if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
-		if (guest_memfd < 0) {=0A=
+	if (guest_memfd < 0) {=0A=
+		if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
 			uint32_t guest_memfd_flags =3D 0;=0A=
 			TEST_ASSERT(!guest_memfd_offset,=0A=
 				    "Offset must be zero when creating new guest_memfd");=0A=
 			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
-		} else {=0A=
-			/*=0A=
-			 * Install a unique fd for each memslot so that the fd=0A=
-			 * can be closed when the region is deleted without=0A=
-			 * needing to track if the fd is owned by the framework=0A=
-			 * or by the caller.=0A=
-			 */=0A=
-			guest_memfd =3D dup(guest_memfd);=0A=
-			TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memf=
d));=0A=
 		}=0A=
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
 =0A=
 		region->region.guest_memfd =3D guest_memfd;=0A=
 		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-- =0A=
2.50.1=0A=
=0A=

