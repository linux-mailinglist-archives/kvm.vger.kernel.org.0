Return-Path: <kvm+bounces-56065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 266C5B3988F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEA1E4680CE
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AF82E229E;
	Thu, 28 Aug 2025 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="a2NvVex3"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC29A2F39D1;
	Thu, 28 Aug 2025 09:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.74.81.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373980; cv=none; b=XL7S/88oVUBOWKX3bU1iahfb96TGNIDFCqeGofDUcJaypAPX+x6eTqkKDIyUXlVVgzyJVus7MSIsyOLqU7p9pJD1Wj8U2BBYzPbkpnuH2FuAKdzwijL6IwYxe5lFFJQdUSbBE+3Li/NW2ruT9/FdFlhAkx6n6UVkCjKJhs+RvXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373980; c=relaxed/simple;
	bh=CUnWDWnjSNIMDZbqOI70zf7w+IMSZds6RZHVSneBlbA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=opLgqP1nOf1lUfkVakZJ/50vjVhbuV0jkrFMiwoZc6FCW5CXuzCb7geOMZGMzQ9XtOVwn4QkSv9VJrnbPqM4PlIeS59x8oLjYqCQAF5xTM8gZo7jQyYaFXBYwh5N/nTQVNG3ORaQxCrmr4ERwl05ZhnYHVMcYIVGk+q4x0xj6+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=a2NvVex3; arc=none smtp.client-ip=3.74.81.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373978; x=1787909978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VqGptO2eIB/qYhTXbL0ZOcw76oucCT92viU83AkSH8I=;
  b=a2NvVex3C+powgKt+HNP4aF8mIPGOFYEagZ3QDaQXaw/4XnsSSsKBrkc
   Vyjq8LeNa4nMf5GLa06hj2HblJa2K/gSkaS4to60ru+1ZsrCtTIxmpBp+
   BdOK+F+QzSwasWctJrVkjVvaiJQ1Yvg2iUxl6YbDx4pSJWFOYkZ7DldHT
   aO2nzc77R3ETm/5XviXX9AmE23jgw7L+VZLMyDlYMG95EempucRjY5jHt
   hqLmVN2DfhH+okRuzx40exqkbk0c/9YzHd0IHfPFQNap7XNb8Xs7AmnyP
   B9xlmyG8qjM4XLQEqx/jIV+FcUep0qeoJpszP2nTm+a3fPYmpKc0Bk/Bu
   A==;
X-CSE-ConnectionGUID: XkXzBx06QR6nJzl0Yj+R6Q==
X-CSE-MsgGUID: YW4iRhH6SrWZheQA5BAZZg==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303839"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:32 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:30618]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.219:2525] with esmtp (Farcaster)
 id 30bc251c-cc0a-4eef-b700-3ade75b8cf88; Thu, 28 Aug 2025 09:39:32 +0000 (UTC)
X-Farcaster-Flow-ID: 30bc251c-cc0a-4eef-b700-3ade75b8cf88
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:31 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:30 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:30 +0000
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
Subject: [PATCH v5 11/12] KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP
 in guest_memfd_test.c
Thread-Topic: [PATCH v5 11/12] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in guest_memfd_test.c
Thread-Index: AQHcF/+npK+gu2tkp0adAvgbddQ75w==
Date: Thu, 28 Aug 2025 09:39:30 +0000
Message-ID: <20250828093902.2719-12-roypat@amazon.co.uk>
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
 tools/testing/selftests/kvm/guest_memfd_test.c | 2 ++=0A=
 1 file changed, 2 insertions(+)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c=0A=
index b3ca6737f304..1187438b6831 100644=0A=
--- a/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
@@ -275,6 +275,8 @@ static void test_guest_memfd(unsigned long vm_type)=0A=
 =0A=
 	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))=0A=
 		flags |=3D GUEST_MEMFD_FLAG_MMAP;=0A=
+	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP))=0A=
+		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
 =0A=
 	test_create_guest_memfd_multiple(vm);=0A=
 	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);=0A=
-- =0A=
2.50.1=0A=
=0A=

