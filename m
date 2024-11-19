Return-Path: <kvm+bounces-32081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1563B9D2AAF
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 17:20:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 264D5283DCD
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 16:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C309D1D0E25;
	Tue, 19 Nov 2024 16:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="GbEenRCu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEE71D0967;
	Tue, 19 Nov 2024 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732033204; cv=none; b=eGCOwACNg5uyjRUAdrhxKMGm0YyJlWzitVYV2z7YWy/5Nc7qQzNIg5ArLCVH1l+Z97tvwIbfYtz0FVfGhB9cZJ2jXkZ2v6GR4IgCd8Xy8JQXkKo4uXio8F5KQDkzkXqPOGgcMHGMjdrxzpi9TXSryPr+2NthcnctbonFr/6lP7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732033204; c=relaxed/simple;
	bh=1ip0Amki48ZUc+FTWHVwEq2OzWoXBKQ0f1kyhG4JNmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uOlsHjw3RISayPA4txLu8wR8f05/M5xN0cOxzYwwkXFjHS+DdxDAz3DycQQ4kR1RrKpgu6hSFeP4Y2qJO04CUnjD0oWJKljaOwZ91unoR2TUxoTNRHjSXcl5jWs7ulI0jow26EmM21Wo6VArtspu+ayZgVmjm2bj1I7o5yYxYuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=GbEenRCu; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732033203; x=1763569203;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=7owaQx9KVUDC/9VUYWCxSJ3gDhP5jQwK7SSWCjNNDGo=;
  b=GbEenRCufXTIlOyODuGCyJTGqBYiROkAhtwkmsSah1+KOlXNUwJWjO3m
   p5/ZSqOdf3TBAUEjFajWtN80SdZMAOxSxlFnl6b4yhaAUvMC6eHd2KJYU
   t29m04E4depTVQGLu9kxWSFYUFCjk6tASkwPUjwv0lM0QKjJEUvN8Y3b/
   8=;
X-IronPort-AV: E=Sophos;i="6.12,166,1728950400"; 
   d="scan'208";a="450253566"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 16:19:59 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:1239]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.34.163:2525] with esmtp (Farcaster)
 id b1ae407d-191f-4a89-b1d6-ae5ac8895921; Tue, 19 Nov 2024 16:19:58 +0000 (UTC)
X-Farcaster-Flow-ID: b1ae407d-191f-4a89-b1d6-ae5ac8895921
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 19 Nov 2024 16:19:57 +0000
Received: from [192.168.2.250] (10.106.83.27) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Tue, 19 Nov 2024
 16:19:56 +0000
Message-ID: <159265fb-d2fb-4d93-b41a-59c25e2db0da@amazon.com>
Date: Tue, 19 Nov 2024 16:19:47 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/6] KVM: x86: async PF user
To: James Houghton <jthoughton@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <corbet@lwn.net>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<david@redhat.com>, <peterx@redhat.com>, <oleg@redhat.com>,
	<vkuznets@redhat.com>, <gshan@redhat.com>, <graf@amazon.de>,
	<jgowans@amazon.com>, <roypat@amazon.co.uk>, <derekmn@amazon.com>,
	<nsaenz@amazon.es>, <xmarcalx@amazon.com>
References: <20241118123948.4796-1-kalyazin@amazon.com>
 <CADrL8HXikDsda6CmG8E2KpNekp8xaQyd8wgZoskkR=p2LvkPQg@mail.gmail.com>
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
In-Reply-To: <CADrL8HXikDsda6CmG8E2KpNekp8xaQyd8wgZoskkR=p2LvkPQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D011EUB001.ant.amazon.com (10.252.51.7) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)



On 19/11/2024 01:26, James Houghton wrote:
>> Please note that this series is applied on top of the VM-exit-based
>> stage-2 fault handling RFC [2].
> 
> Thanks, Nikita! I'll post a new version of [2] very soon. The new
> version contains the simplifications we talked about at LPC but is
> conceptually the same (so this async PF series is motivated the same
> way), and it shouldn't have many/any conflicts with the main bits of
> this series.

Great news, looking forward to seeing it!

> 
>> [2] https://lore.kernel.org/kvm/CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com/T/


