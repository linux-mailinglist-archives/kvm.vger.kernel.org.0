Return-Path: <kvm+bounces-20952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F3F9273AF
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 12:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0DD31C232FC
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B001AB904;
	Thu,  4 Jul 2024 10:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="F7i/F97B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8411AAE30
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 10:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720087815; cv=none; b=fuC7sdtblehL4WtNoa8/xGRH6jYuB49q9YKy7NRSJQrO9e6PrnL1cbtM1LLxBmzpch1bXnTKURzLBOhJ3D3TA06em3qcMcEGVW/6/ed8/1yAfr2X9s4TPHOCBK0x6HSYdxX7RtUmqjYZSu0Lf/dayywYzsJBtrCdw6edmkaJx+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720087815; c=relaxed/simple;
	bh=2Ov9R8ADNy995u/zd9Y+2wDwr9zyJEno3BPPgDwB5Tk=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tp2UWrjcW72J29+Y2fvMnHYlYelQVFGH1B05tHbQY8WWD4zczN+jTLNG7epjHcmewBH87jhs3kICy9Xzb4fObOvpV/F3KhgoLoP/CJnLrndDDrXwPOdJ/ifBRr+zOvt+KR1EP/r4gQsBU7GGmxi7/9C++S8fqM52QEPcIaGvhZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=F7i/F97B; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720087814; x=1751623814;
  h=message-id:date:mime-version:reply-to:to:cc:references:
   from:in-reply-to:content-transfer-encoding:subject;
  bh=2Ov9R8ADNy995u/zd9Y+2wDwr9zyJEno3BPPgDwB5Tk=;
  b=F7i/F97BEnat1HcvDfzJzWm9OKYZXLCy4l6ROhA/b1oOYmTew0H6tMKN
   t0NCzoOvIPYGAAkj0zLAZisqpeAelOThWcpzBpW9pg8rQcyWQTr8FCn1O
   KO9Z6IW2lKFPKmifwmbKP47EgBUAIWm3S8rthcAdo02UL5u7Hfm3ZrdJf
   Y=;
X-IronPort-AV: E=Sophos;i="6.09,183,1716249600"; 
   d="scan'208";a="738588944"
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an exit on
 missing hva mappings
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 10:10:07 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:35295]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.5.92:2525] with esmtp (Farcaster)
 id 204173d2-436c-4dcf-9d96-fd74ba6bc15f; Thu, 4 Jul 2024 10:10:05 +0000 (UTC)
X-Farcaster-Flow-ID: 204173d2-436c-4dcf-9d96-fd74ba6bc15f
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 4 Jul 2024 10:10:05 +0000
Received: from [192.168.6.66] (10.106.82.27) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Thu, 4 Jul 2024
 10:10:04 +0000
Message-ID: <5b6902bb-37c2-4558-87d0-7a2012b0c172@amazon.com>
Date: Thu, 4 Jul 2024 11:10:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
To: David Matlack <dmatlack@google.com>
CC: Sean Christopherson <seanjc@google.com>, Anish Moorthy
	<amoorthy@google.com>, <maz@kernel.org>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <robert.hoo.linux@gmail.com>,
	<jthoughton@google.com>, <axelrasmussen@google.com>, <peterx@redhat.com>,
	<nadav.amit@gmail.com>, <isaku.yamahata@gmail.com>,
	<kconsul@linux.vnet.ibm.com>, Oliver Upton <oliver.upton@linux.dev>,
	<roypat@amazon.co.uk>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-7-amoorthy@google.com> <ZeuMEdQTFADDSFkX@google.com>
 <ZeuxaHlZzI4qnnFq@google.com> <Ze6Md/RF8Lbg38Rf@thinky-boi>
 <CALzav=cMrt8jhCKZSJL+76L=PUZLBH7D=Uo-5Cd1vBOoEja0Nw@mail.gmail.com>
 <923126dd-5f23-4f99-8327-9e8738540efb@amazon.com>
 <CALzav=ePCJiYABpWG70ddPj2Yt57UAxynd64ZWzSVDHUVA3X3w@mail.gmail.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJj5ki9BQkDwmcAAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOR1wD/UTcn4GbLC39QIwJuWXW0DeLoikxFBYkbhYyZ5CbtrtAA/2/rnR/zKZmyXqJ6
 ULlSE8eWA3ywAIOH8jIETF2fCaUCzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmPmSL0FCQPCZwACGwwACgkQr5LKIKmaZPNCxAEAxwnrmyqSC63nf6hoCFCfJYQapghC
 abLV0+PWemntlwEA/RYx8qCWD6zOEn4eYhQAucEwtg6h1PBbeGK94khVMooF
In-Reply-To: <CALzav=ePCJiYABpWG70ddPj2Yt57UAxynd64ZWzSVDHUVA3X3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D002EUC001.ant.amazon.com (10.252.51.219) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

On 03/07/2024 21:11, David Matlack wrote:
> Yes, James Houghton at Google has been working on this. We decided to
> build a more complete RFC (with x86 and ARM) support, so that
> reviewers can get an idea of the full scope of the feature, so it has
> taken a bit longer than originally planned. But the RFC is code
> complete now. I think James is planning to send the patches next week.

Great to hear, looking forward to seeing it!

