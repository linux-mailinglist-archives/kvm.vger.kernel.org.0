Return-Path: <kvm+bounces-56062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 173C5B39889
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 543201C8023C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423D02F3C13;
	Thu, 28 Aug 2025 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Gw8pxPFf"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3676D2EFD81;
	Thu, 28 Aug 2025 09:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373977; cv=none; b=rE3JmeLyzG5UZBLpr1reU4Yikk44cOY+N+K48JgZ3/PdRrdxSVE1we1zjzs8MOLLIHA5NgA1BDwxGMn7pnbTzqjdSiGHQBdisakzMWCXqwfUCeXlfLZrSTl2A6g4dNSAKhlnTPt209ji7HHqb94NFtuNulmWs3CTFcDy31C3AUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373977; c=relaxed/simple;
	bh=HMW/vZT2G4FuHVHkNCjDR1S45FU78WaIL5C/o9ZEOnk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eJh1grGBIRrYtKHy/X3L3DOP8/zVAgCCdGnFLWNtPbRVLjejX22UbjDNXF3tXrabUZlLESfk6yIgWMyxJSmwI0nT5TAW12wPjkrdB/pljJZzfE9p8pHDyfGI1eX9qGA9prASILlBZw4ZJZXBoIAW3kjrgGispST9ro52QrlxMJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Gw8pxPFf; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373974; x=1787909974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0IDH9n28kEwYt0ECrfeYfhTLW/JDV2HhZTsdNRyHePU=;
  b=Gw8pxPFfZxvfhzQRd+HaclTJXnJickkHN/+N3lIOXCH4sBWg8Xybj0DE
   IjBx8NVEg1TuUH3PNbTRLIMMlQDCGVhJSK8IdD5LMTZtO9AEqW4VB87FJ
   L5L0ajPCT4Q82W9rlFaP6fez9yypNZVZjCBLsCGsCXsCZTwZxkpYAVIfu
   A4Zy2+ytOX6UDVDJFdNZoMweEjnbnC0rAMCI/hLSZIDu2UFyxQvImSaXK
   DwxZplLo4QqleIFwslGyaG/6I1oMoegPm01Uo2QN9pfVLnTxp+erktMwG
   5hd/W9LiFm6WaCX3JllwZDFzlBy9FCSFIeORaWxd1WkLUF4unf3i9igvY
   A==;
X-CSE-ConnectionGUID: StAVDOr1TDqzrpf/UacFbA==
X-CSE-MsgGUID: 62wxrjsZSS6115niAVDpqQ==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1301811"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:24 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:10411]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.194:2525] with esmtp (Farcaster)
 id cf079725-5cad-40a9-99e7-2d92fc48a8df; Thu, 28 Aug 2025 09:39:23 +0000 (UTC)
X-Farcaster-Flow-ID: cf079725-5cad-40a9-99e7-2d92fc48a8df
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:23 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:23 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:23 +0000
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
Subject: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
Thread-Index: AQHcF/+iTh4+SyN+qUqFXrn8N9N71g==
Date: Thu, 28 Aug 2025 09:39:22 +0000
Message-ID: <20250828093902.2719-6-roypat@amazon.co.uk>
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

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 Documentation/virt/kvm/api.rst | 5 +++++=0A=
 1 file changed, 5 insertions(+)=0A=
=0A=
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t=0A=
index c17a87a0a5ac..b52c14d58798 100644=0A=
--- a/Documentation/virt/kvm/api.rst=0A=
+++ b/Documentation/virt/kvm/api.rst=0A=
@@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is supp=
orted, the 'flags' field=0A=
 supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation=
=0A=
 enables mmap() and faulting of guest_memfd memory to host userspace.=0A=
 =0A=
+When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags' f=
ield=0A=
+supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the guest=
_memfd=0A=
+instance behave similarly to memfd_secret, and unmaps the memory backing i=
t from=0A=
+the kernel's address space after allocation.=0A=
+=0A=
 When the KVM MMU performs a PFN lookup to service a guest fault and the ba=
cking=0A=
 guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always =
be=0A=
 consumed from guest_memfd, regardless of whether it is a shared or a priva=
te=0A=
-- =0A=
2.50.1=0A=
=0A=

