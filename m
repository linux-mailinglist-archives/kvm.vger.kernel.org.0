Return-Path: <kvm+bounces-1498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D23597E8211
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 19:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 899631F20EE2
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 18:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC21C3AC15;
	Fri, 10 Nov 2023 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="YDneD3u7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DDD3986C;
	Fri, 10 Nov 2023 18:52:30 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EF08877;
	Fri, 10 Nov 2023 10:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699642349; x=1731178349;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=h363nARPyBFZTzGRxE1jTeXcQuiJqJpbtjVgwsF7eS0=;
  b=YDneD3u7QATQT8StAhhFjb6E+K6FA4/3Azv5fcPJxuIImIIfifsrJ1cQ
   uKnHWhggVvQCntnBXFvK9D/NamYpAgxD7cp596XpacApFCEUDPEORS+sa
   SwEP42pEHbe7Ri6Wwx+ELFKvixV9KAOM9LlUe23yu+jnoZ6SkuCgloOp0
   g=;
X-IronPort-AV: E=Sophos;i="6.03,291,1694736000"; 
   d="scan'208";a="42792448"
Subject: Re: [RFC 14/33] KVM: x86: Add VTL to the MMU role
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 18:52:26 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id 27E86340055;
	Fri, 10 Nov 2023 18:52:23 +0000 (UTC)
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:46736]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.247:2525] with esmtp (Farcaster)
 id e1abb6b6-3a61-4aaa-8d85-42d67f3fff23; Fri, 10 Nov 2023 18:52:21 +0000 (UTC)
X-Farcaster-Flow-ID: e1abb6b6-3a61-4aaa-8d85-42d67f3fff23
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Fri, 10 Nov 2023 18:52:21 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Fri, 10 Nov
 2023 18:52:17 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Nov 2023 18:52:13 +0000
Message-ID: <CWVCX8ZD8QQZ.2FVZ6DODV8A6T@amazon.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-15-nsaenz@amazon.com> <ZUvE2clQI-wOzRBd@google.com>
In-Reply-To: <ZUvE2clQI-wOzRBd@google.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D036UWB002.ant.amazon.com (10.13.139.139) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Wed Nov 8, 2023 at 5:26 PM UTC, Sean Christopherson wrote:
> On Wed, Nov 08, 2023, Nicolas Saenz Julienne wrote:
> > With the upcoming introduction of per-VTL memory protections, make MMU
> > roles VTL aware. This will avoid sharing PTEs between vCPUs that belong
> > to different VTLs, and that have distinct memory access restrictions.
> >
> > Four bits are allocated to store the VTL number in the MMU role, since
> > the TLFS states there is a maximum of 16 levels.
>
> How many does KVM actually allow/support?  Multiplying the number of poss=
ible
> roots by 16x is a *major* change.

AFAIK in practice only VTL0/1 are used. Don't know if Microsoft will
come up with more in the future. We could introduce a CAP that expses
the number of supported VTLs to user-space, and leave it as a compile
option.

