Return-Path: <kvm+bounces-17356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4078C4974
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 00:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE4FD1C21371
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 22:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7988584D25;
	Mon, 13 May 2024 22:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="gdMDMg0N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E9384D05
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 22:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715637730; cv=none; b=gwUkB/tqJ+SOFaM1EnuQVCD7eJROFX4eSgEPNoQFFhAzFgDJYjTEsIY5A7dTCH0cgFA2XdJC7z4d2s6X8ANyYsrCS45wyfB4KVcxtFWKiY9t5+rV3kDVxY9o/ff2/ILI97EA/1BODssSI+ALxaPQoIsYhYq8leUCclxIhevzLI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715637730; c=relaxed/simple;
	bh=5+iQQpOEZdEkzvrHSJ41DjlAjDtbE5SACcQXxQVlFBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LfBTDmAnqrfrc++gti+DSKc6OtGThF0+ldxHpQKqSQD5ActF7+6/Ded5rsrjQGmhfRROSZ4RAgDbz2jBTYYAzaPqF8rWonnL7s4N9+0o5XnF+vPq/IsFlbo356MoLeS2zj9UrZXzoGEyKyjOk0BO3Npazpk4OP+bkIiYb9O0kAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=gdMDMg0N; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1715637730; x=1747173730;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5+iQQpOEZdEkzvrHSJ41DjlAjDtbE5SACcQXxQVlFBs=;
  b=gdMDMg0NHYV3WRAkJcF8/bjHV0cF6CP/mwvwFkDJqPaS+sDvEQv2SCJH
   wU/QWeJli1AxxJrkJ824D4xMHNZE03aVQI99dDDrm+w9h8Br1/kz4jzJo
   QcQyZIWIQNY7WjsNrmbBifyQKO4inKgWEzofo9A5sDf7Y12qOL7JYs+01
   c=;
X-IronPort-AV: E=Sophos;i="6.08,159,1712620800"; 
   d="scan'208";a="726172843"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 22:02:08 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:19998]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.44.254:2525] with esmtp (Farcaster)
 id 166c483a-d211-48eb-b873-34e5ed9da520; Mon, 13 May 2024 22:01:52 +0000 (UTC)
X-Farcaster-Flow-ID: 166c483a-d211-48eb-b873-34e5ed9da520
Received: from EX19D003UWC002.ant.amazon.com (10.13.138.169) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 13 May 2024 22:01:49 +0000
Received: from [192.168.232.44] (10.106.101.48) by
 EX19D003UWC002.ant.amazon.com (10.13.138.169) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 13 May 2024 22:01:48 +0000
Message-ID: <7107a45b-0635-4040-9f4c-288708b13c04@amazon.com>
Date: Mon, 13 May 2024 15:01:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: Sean Christopherson <seanjc@google.com>, James Gowans <jgowans@amazon.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, Nikita Kalyazin <kalyazin@amazon.co.uk>,
	"rppt@kernel.org" <rppt@kernel.org>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>, Patrick Roy <roypat@amazon.co.uk>, "somlo@cmu.edu"
	<somlo@cmu.edu>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, David Woodhouse
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "mst@redhat.com" <mst@redhat.com>,
	Moritz Lipp <mlipp@amazon.at>, Claudio Canella <canellac@amazon.at>
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <ZeudRmZz7M6fWPVM@google.com> <ZexEkGkNe_7UY7w6@kernel.org>
 <58f39f23-0314-4e34-a8c7-30c3a1ae4777@amazon.co.uk>
 <ZkI0SCMARCB9bAfc@google.com>
 <aaf684b5eb3a3fe9cfbb6205c16f0973c6f8bb07.camel@amazon.com>
 <ZkJFIpEHIQvfuzx1@google.com>
 <f880d0187e2d482bc8a8095cf5b7404ea9d6fb03.camel@amazon.com>
 <ZkJ37uwNOPis0EnW@google.com>
Content-Language: en-US
From: "Manwaring, Derek" <derekmn@amazon.com>
In-Reply-To: <ZkJ37uwNOPis0EnW@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D043UWC001.ant.amazon.com (10.13.139.202) To
 EX19D003UWC002.ant.amazon.com (10.13.138.169)

On 2024-05-13 13:36-0700, Sean Christopherson wrote:
> Hmm, a slightly crazy idea (ok, maybe wildly crazy) would be to support mapping
> all of guest_memfd into kernel address space, but as USER=1 mappings.  I.e. don't
> require a carve-out from userspace, but do require CLAC/STAC when access guest
> memory from the kernel.  I think/hope that would provide the speculative execution
> mitigation properties you're looking for?

This is interesting. I'm hesitant to rely on SMAP since it can be
enforced too late by the microarchitecture. But Canella, et al. [1] did
say in 2019 that the kernel->user access route seemed to be free of any
"Meltdown" effects. LASS sounds like it will be even stronger, though
it's not clear to me from Intel's programming reference that speculative
scenarios are in scope [2]. AMD does list SMAP specifically as a
feature that can control speculation [3].

I don't see an equivalent read-access control on ARM. It has PXN for
execute. Read access can probably also be controlled?  But I think for
the non-CoCo case we should favor solutions that are less dependent on
hardware-specific protections.

Derek


[1] https://www.usenix.org/system/files/sec19-canella.pdf
[2] https://cdrdv2.intel.com/v1/dl/getContent/671368
[3] https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/tuning-guides/software-techniques-for-managing-speculation.pdf

