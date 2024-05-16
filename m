Return-Path: <kvm+bounces-17533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0B598C7831
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 16:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D3BC285F36
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 14:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E0214B961;
	Thu, 16 May 2024 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="k+OJX8QB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609C114A4D7;
	Thu, 16 May 2024 14:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715868155; cv=none; b=myLHs5mYp6MgpDzAe8VH6zQngntsWttLAgAmp6HuH6JrE6xkzIdtZqzWjhd7J4IflSf5m3Swp65UNCBvQ3knF8WtwVsFlsSQnHAjnRJmcMQvu8GpCFfbpUUbs3aMATNA77CeLVBFSCGPAPgIzFP3OO0xcxAoPdu8HCerulpyqQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715868155; c=relaxed/simple;
	bh=PII+OyY3HRsFOpjW5l++XBk5W4fZ/zADl3BCmJlUORM=;
	h=Subject:MIME-Version:Content-Type:Date:Message-ID:CC:From:To:
	 References:In-Reply-To; b=VOtslJur2zmnM700pOzHZn1PZXRU5uA3i3yp/+ipWYQicF1BGlVkJRv8Oqfqjtn8jwW0CTbHt1wTPHOfPou7A3M08NkaEKXKvSGF7qNNUer8hzTZ5SE5AY/lfNN5OgjJ9x7dKbMHf5fzxYDYP9mmtx1UDdwFg0lFkkzykvPke24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.es; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=k+OJX8QB; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1715868154; x=1747404154;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=PII+OyY3HRsFOpjW5l++XBk5W4fZ/zADl3BCmJlUORM=;
  b=k+OJX8QBKhlhXLL+yP7jzjxSe2kwEGUIlf1RVVo8QLlDuet++05n1dC7
   dwhyvpEbW+sLKcnNuXJDwX9Dp1D1vS6zEXehHOJDcwbUoiDoTf/1MKlFU
   esPMfQq5KW/aAQJWLPNk5j+/JXm0kvAxHpvRtIW0QAvZOHvajT8m1wCpz
   k=;
X-IronPort-AV: E=Sophos;i="6.08,164,1712620800"; 
   d="scan'208";a="419475431"
Subject: Re: [RFC PATCH v3 3/5] KVM: x86: Add notifications for Heki policy
 configuration and violation
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 14:02:24 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:61258]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.38.98:2525] with esmtp (Farcaster)
 id 669cf238-0252-433a-b5ae-10131f992275; Thu, 16 May 2024 14:02:23 +0000 (UTC)
X-Farcaster-Flow-ID: 669cf238-0252-433a-b5ae-10131f992275
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 16 May 2024 14:02:23 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Thu, 16 May
 2024 14:02:12 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 May 2024 14:02:09 +0000
Message-ID: <D1B4HKJAJG21.2DH9F3E1Q6J9L@amazon.com>
CC: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Vitaly
 Kuznetsov" <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, "Rick P
 Edgecombe" <rick.p.edgecombe@intel.com>, Alexander Graf <graf@amazon.com>,
	Angelina Vu <angelinavu@linux.microsoft.com>, Anna Trikalinou
	<atrikalinou@microsoft.com>, Chao Peng <chao.p.peng@linux.intel.com>,
	"Forrest Yuan Yu" <yuanyu@google.com>, James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>, John Andersen
	<john.s.andersen@intel.com>, "Madhavan T . Venkataraman"
	<madvenka@linux.microsoft.com>, Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?utf-8?q?Mihai_Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?utf-8?q?Nicu=C8=99or_C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>, Thara
 Gopinath <tgopinath@microsoft.com>, "Trilok Soni" <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>, Will Deacon <will@kernel.org>, Yu Zhang
	<yu.c.zhang@linux.intel.com>, =?utf-8?q?=C8=98tefan_=C8=98icleru?=
	<ssicleru@bitdefender.com>, <dev@lists.cloudhypervisor.org>,
	<kvm@vger.kernel.org>, <linux-hardening@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <qemu-devel@nongnu.org>,
	<virtualization@lists.linux-foundation.org>, <x86@kernel.org>,
	<xen-devel@lists.xenproject.org>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
X-Mailer: aerc 0.17.0-129-gd582ac682cdf-dirty
References: <20240503131910.307630-1-mic@digikod.net>
 <20240503131910.307630-4-mic@digikod.net> <ZjTuqV-AxQQRWwUW@google.com>
 <20240506.ohwe7eewu0oB@digikod.net> <ZjmFPZd5q_hEBdBz@google.com>
 <20240507.ieghomae0UoC@digikod.net> <ZjpTxt-Bxia3bRwB@google.com>
 <D15VQ97L5M8J.1TDNQE6KLW6JO@amazon.com> <20240514.mai3Ahdoo2qu@digikod.net>
In-Reply-To: <20240514.mai3Ahdoo2qu@digikod.net>
X-ClientProxiedBy: EX19D046UWA001.ant.amazon.com (10.13.139.112) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Tue May 14, 2024 at 12:23 PM UTC, Micka=C3=ABl Sala=C3=BCn wrote:
> > Development happens
> > https://github.com/vianpl/{linux,qemu,kvm-unit-tests} and the vsm-next
> > branch, but I'd advice against looking into it until we add some order
> > to the rework. Regardless, feel free to get in touch.
>
> Thanks for the update.
>
> Could we schedule a PUCK meeting to synchronize and help each other?
> What about June 12?

Sounds great! June 12th works for me.

Nicolas

