Return-Path: <kvm+bounces-56064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DF3AB3988E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A5F1984BF0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3A32FA0E2;
	Thu, 28 Aug 2025 09:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="keZ7fKGD"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2B62F39A9;
	Thu, 28 Aug 2025 09:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373979; cv=none; b=dZcYnVc/0nhokJV+Vj3dVvNdmEjlv/JdYVjh8V3XYgObB+BveFxkxeXMpwyxrPDX0Qf6yuxyJ9hPLXY2+BM9bRcT/spJp1HeONnBN1drkJc/j08RU/XpLXHjHVUP8zci0l+GUzmlj24aGqL6HDkvtfR1VrsUkAmtdej58jgmhgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373979; c=relaxed/simple;
	bh=nCjWufYKrlNCh8XZjWg4tYbMq5vJ7NVlxR7q20f+tF0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uu/N/cyzw0EslaSIyQyAoqkrRi/4sob4VSuv0cmC67Hd9GyKcT2Dz1DeD9Gl9sqN9nOOAWizKJQXAk/ss+sCzQB07wIZ9msvim0AHwJW5hoRr7hqEGm/w3YnfJtEHCWYx1rocDVp8f60NZcrDL3KiPWtFwo7ksAxE1pb0PGSFvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=keZ7fKGD; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373977; x=1787909977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SyhzIZH3Q6IiBys3GR5p06vlDvFDBIcBe4gJFy0icy8=;
  b=keZ7fKGD1P+ny5gqy4onjEFS0L4Wa9AyCumWZZF7irs50zvufV7pEgSZ
   D2B8GOJoR1C1h64NiDDccudLje700ttnVYsdnHNyatbdd6moaLH3C6+1B
   otiyFqr3ADJhdxlmXP+DS9m4w7VmFiYj5E2ToMIaMN5Qplo+XXNv+4OHg
   U/E8M7rwg/d8j/0ibV1GQ3atZRJotg+b2CXeGozLZxt1+IJwEYccde+lr
   AlrPWHp1DY0QXnYpugA08vajdTiAxlaTBYp83OhPPaBAepSiHjtaDaXyF
   TDyvGo/n52b+PKzCT9pthdnbcGxHP8MuWfbP6bQ/i2+8JNnmK0bNqTqBD
   g==;
X-CSE-ConnectionGUID: XH6vX520Rw+VjO+/Iz6NOg==
X-CSE-MsgGUID: F0Zsr4f7Qnmj4E5zjIaQkQ==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1301818"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:30 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:2694]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.1:2525] with esmtp (Farcaster)
 id 75f51d0c-0b42-4089-8026-da4960a5d2fe; Thu, 28 Aug 2025 09:39:30 +0000 (UTC)
X-Farcaster-Flow-ID: 75f51d0c-0b42-4089-8026-da4960a5d2fe
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:29 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:29 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:29 +0000
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
Subject: [PATCH v5 10/12] KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP
 in mem conversion tests
Thread-Topic: [PATCH v5 10/12] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in mem conversion tests
Thread-Index: AQHcF/+mcpyXe48FIE+SGIUwj8fMnw==
Date: Thu, 28 Aug 2025 09:39:29 +0000
Message-ID: <20250828093902.2719-11-roypat@amazon.co.uk>
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

Cover the scenario that the guest can fault in and write gmem-backed=0A=
guest memory even if its direct map removed.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../selftests/kvm/x86/private_mem_conversions_test.c       | 7 ++++---=0A=
 1 file changed, 4 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=
 b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
index 82a8d88b5338..8427d9fbdb23 100644=0A=
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
@@ -367,7 +367,7 @@ static void *__test_mem_conversions(void *__vcpu)=0A=
 }=0A=
 =0A=
 static void test_mem_conversions(enum vm_mem_backing_src_type src_type, ui=
nt32_t nr_vcpus,=0A=
-				 uint32_t nr_memslots)=0A=
+				 uint32_t nr_memslots, uint64_t gmem_flags)=0A=
 {=0A=
 	/*=0A=
 	 * Allocate enough memory so that each vCPU's chunk of memory can be=0A=
@@ -394,7 +394,7 @@ static void test_mem_conversions(enum vm_mem_backing_sr=
c_type src_type, uint32_t=0A=
 =0A=
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));=
=0A=
 =0A=
-	memfd =3D vm_create_guest_memfd(vm, memfd_size, 0);=0A=
+	memfd =3D vm_create_guest_memfd(vm, memfd_size, gmem_flags);=0A=
 =0A=
 	for (i =3D 0; i < nr_memslots; i++)=0A=
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,=0A=
@@ -477,7 +477,8 @@ int main(int argc, char *argv[])=0A=
 		}=0A=
 	}=0A=
 =0A=
-	test_mem_conversions(src_type, nr_vcpus, nr_memslots);=0A=
+	test_mem_conversions(src_type, nr_vcpus, nr_memslots, 0);=0A=
+	test_mem_conversions(src_type, nr_vcpus, nr_memslots, GUEST_MEMFD_FLAG_NO=
_DIRECT_MAP);=0A=
 =0A=
 	return 0;=0A=
 }=0A=
-- =0A=
2.50.1=0A=
=0A=

