Return-Path: <kvm+bounces-11439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F16B876ED5
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 03:46:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D573C2828FC
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA552D638;
	Sat,  9 Mar 2024 02:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="UOZxGP+S"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0412C6AA
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 02:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709952366; cv=none; b=LEQb9yvJnJK7p7QozGIAeY68GE7/zoy45MeojXtwOmGsiBtoAgDiszok0brt3Vid1YQuL35TOxISuxl/iWAJRyWu0eGAJjZAqvu5tWPYkgAyUjCBMg528/CjBIjijVqEXRlCTIdRR0b0hhrbgn/NBTabMGke6NJ4WiazUXuxCgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709952366; c=relaxed/simple;
	bh=FaGxOMw8hAeHVyQkCVZb0DCHhnDYyHKuxNIwAvfWDWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=R4GP+5m4sL7LmFKZZwbsB72EZF9rhNk0mAYfLmfCTZV130yeeuCjVW/0yK+XyXRyGlTrkVdMEjIhhblKpPZ+X84NhgvI/AehXE/e1ivFCGCvu8ziA+U9YTW9eX5L3lL6iL+xY1k1JrnaV1Ig1ja7MOsLDGneKUZ46+EaLi/YeBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=UOZxGP+S; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1709952365; x=1741488365;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FaGxOMw8hAeHVyQkCVZb0DCHhnDYyHKuxNIwAvfWDWA=;
  b=UOZxGP+SQ074FfySbKC37cep1lgEsuXLpRPWE4A/IO9giYAY3iVVc/L2
   zStTNjtDS2DXgRh2mKu5bpMKScz22RWyCAsNfXLOzlygLoMBPGW/y6MUT
   uGCOfzcsLAlnKCU8mCGygW16qYA+HJF4hv4o673ROn/+WCJIZ4ujbPlSS
   4=;
X-IronPort-AV: E=Sophos;i="6.07,111,1708387200"; 
   d="scan'208";a="643486831"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2024 02:46:02 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:58391]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.222:2525] with esmtp (Farcaster)
 id 8be3daf9-db1b-4473-aca9-d0c64320ade8; Sat, 9 Mar 2024 02:46:01 +0000 (UTC)
X-Farcaster-Flow-ID: 8be3daf9-db1b-4473-aca9-d0c64320ade8
Received: from EX19D003UWC002.ant.amazon.com (10.13.138.169) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Sat, 9 Mar 2024 02:46:01 +0000
Received: from [192.168.12.128] (10.106.101.5) by
 EX19D003UWC002.ant.amazon.com (10.13.138.169) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Sat, 9 Mar 2024 02:45:59 +0000
Message-ID: <8e3c2b45-356d-4ca9-bebc-012505235142@amazon.com>
Date: Fri, 8 Mar 2024 19:45:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
Content-Language: en-US
To: David Matlack <dmatlack@google.com>, Brendan Jackman <jackmanb@google.com>
CC: "Gowans, James" <jgowans@amazon.com>, "seanjc@google.com"
	<seanjc@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Roy, Patrick" <roypat@amazon.co.uk>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Woodhouse, David"
	<dwmw@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "mst@redhat.com" <mst@redhat.com>,
	"somlo@cmu.edu" <somlo@cmu.edu>, "Graf (AWS), Alexander" <graf@amazon.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, <kvmarm@lists.linux.dev>, <tabba@google.com>,
	<qperret@google.com>, <jason.cj.chen@intel.com>
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <CA+i-1C34VT5oFQL7en1n+MdRrO7AXaAMdNVvjFPxOaTDGXu9Dw@mail.gmail.com>
 <CALzav=fO2hpaErSRHGCJCKTrJKD7b9F5oEg7Ljhb0u1gB=VKwg@mail.gmail.com>
From: "Manwaring, Derek" <derekmn@amazon.com>
In-Reply-To: <CALzav=fO2hpaErSRHGCJCKTrJKD7b9F5oEg7Ljhb0u1gB=VKwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D003UWC002.ant.amazon.com (10.13.138.169)

On 2024-03-08 10:36-0700, David Matlack wrote:
> On Fri, Mar 8, 2024 at 8:25 AM Brendan Jackman <jackmanb@google.com> wrote:
> > On Fri, 8 Mar 2024 at 16:50, Gowans, James <jgowans@amazon> wrote:
> > > Our goal is to more completely address the class of issues whose leak
> > > origin is categorized as "Mapped memory" [1].
> >
> > Did you forget a link below? I'm interested in hearing about that
> > categorisation.

The paper from Hertogh, et al. is https://download.vusec.net/papers/quarantine_raid23.pdf
specifically Table 1.

> > It's perhaps a bigger hammer than you are looking for, but the
> > solution we're working on at Google is "Address Space Isolation" (ASI)
> > - the latest posting about that is [2].
>
> I think what James is looking for (and what we are also interested
> in), is _eliminating_ the ability to access guest memory from the
> direct map entirely.

Actually, just preventing speculation of guest memory through the
direct map is sufficient for our current focus.

Brendan,
I will look into the general ASI approach, thank you. Did you consider
memfd_secret or a guest_memfd-based approach for Userspace-ASI? Based on
Sean's earlier reply to James it sounds like the vision of guest_memfd
aligns with ASI's goals.

Derek

