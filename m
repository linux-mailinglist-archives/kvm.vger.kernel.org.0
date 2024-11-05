Return-Path: <kvm+bounces-30766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9319BD48F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFBC3283DCA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F951E8822;
	Tue,  5 Nov 2024 18:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="U/Ku9Mrx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FB616631C;
	Tue,  5 Nov 2024 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831478; cv=none; b=tGe7NDD3LfpGB777beXfhPErRlfLl2FnoqwXXdn6uknklag56XTK5YpwZaJg0B4FB02B06eakosqzyIiQprqRfPKueOpAqdV2rP59y8Xv4ZJzPuRl2TS2TWl5tIV8REV2XIRDkT6rLdMgGlGH88aNRV7eft5XPUWWXnCWtgXQC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831478; c=relaxed/simple;
	bh=PyKcGEXb1boVL67P/iqRrnkjibAaY0whRvJpd8Laamw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mMhQhE+kQI60PK4qv5QOEZjJjWWQtWGjIfLAtFWyeY+pqMu0Pc47PuBa/FI98Daxquoworryx4YqFKvFvXdFmSNwMCMGTdxICFjlPq45P55O5q0SH+W5F8RSMfOMYsZXME1TPD35UcRL5f/Zm+bYXUfHqn1wXdib822SWo7nZc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=U/Ku9Mrx; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730831477; x=1762367477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PyKcGEXb1boVL67P/iqRrnkjibAaY0whRvJpd8Laamw=;
  b=U/Ku9MrxEVI8G8WlBgdcSeKYey5kEhIrygThLlgFib1MhEWbQ96D48OL
   PcccGRVuf6+FV1jkmAsAT8ojjSRwoSdQ4QcmFqN8OFWUMXbt2jF9MOkuy
   AFicb5c4kWAf/Jl3SlczgQ8t8joUOiVNgiCHalJikKXgRM7E0h+kCFF/L
   c=;
X-IronPort-AV: E=Sophos;i="6.11,260,1725321600"; 
   d="scan'208";a="382672584"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:31:16 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.38.20:19380]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.16:2525] with esmtp (Farcaster)
 id 88fb91fb-2fb9-4573-83ff-78e8c1de0dfe; Tue, 5 Nov 2024 18:31:15 +0000 (UTC)
X-Farcaster-Flow-ID: 88fb91fb-2fb9-4573-83ff-78e8c1de0dfe
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 5 Nov 2024 18:31:15 +0000
Received: from u34cccd802f2d52.amazon.com (10.106.239.17) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 5 Nov 2024 18:31:09 +0000
From: Haris Okanovic <harisokn@amazon.com>
To: <ankur.a.arora@oracle.com>, <catalin.marinas@arm.com>
CC: <linux-pm@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<will@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<pbonzini@redhat.com>, <wanpengli@tencent.com>, <vkuznets@redhat.com>,
	<rafael@kernel.org>, <daniel.lezcano@linaro.org>, <peterz@infradead.org>,
	<arnd@arndb.de>, <lenb@kernel.org>, <mark.rutland@arm.com>,
	<harisokn@amazon.com>, <mtosatti@redhat.com>, <sudeep.holla@arm.com>,
	<cl@gentwo.org>, <misono.tomohiro@fujitsu.com>, <maobibo@loongson.cn>,
	<joao.m.martins@oracle.com>, <boris.ostrovsky@oracle.com>,
	<konrad.wilk@oracle.com>
Subject: Re: [PATCH v8 00/11] Enable haltpoll on arm64
Date: Tue, 5 Nov 2024 12:30:36 -0600
Message-ID: <20241105183041.1531976-1-harisokn@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA003.ant.amazon.com (10.13.138.211)

Hi Ankur, Catalin,

How about the following series based on a refactor of arm64's delay()?
Does it address your earlier concerns?

delay() already implements wfet() and falls back to wfe() w/ evstream
or a cpu_relax loop. I refactored it to poll an address, and wrapped in
a new platform-agnostic smp_vcond_load_relaxed() macro. More details in
the following commit log.

Regards,
Haris Okanovic
AWS Graviton Software


