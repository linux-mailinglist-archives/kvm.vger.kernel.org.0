Return-Path: <kvm+bounces-11838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFC787C4D0
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22E792821BC
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF98768E7;
	Thu, 14 Mar 2024 21:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Tuf8XY1U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D859F7353C
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 21:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710452747; cv=none; b=PwRugFeBqNFYXIbQ4BH3LyYgCV18Jukwu/2NoPI4esU7vgrIWDubpGn4FiWFYOtzaDbibYkO7BpCSpYJ/mVuceVBOoSLfgn//RVavgSR9rel2S6eK9RLqdEiepmAcSBSyKgt0GuU15V92+YccFLgy2Q7l4AJ4fi+NqlzUhahJd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710452747; c=relaxed/simple;
	bh=vp3hGSwgMbzRk72sOUpHptWRQ85XgRAAacWGIwKWzDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=j0Qm6fk8dxKl/2kG+zQog0jfbqEZ5YFu9899VEoyct8+Z6xCj2cQ6/vky0toEvSu0qhWSc19xmCssisxarIf2DtPq6wd4eAzAKjyjb1zPIHgiujsm9yRNuBjBpNtcdFpLjnp++BSEpqWCyBEVv4btW91x0r4PeEPOfo5lpB8mFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Tuf8XY1U; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1710452746; x=1741988746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vp3hGSwgMbzRk72sOUpHptWRQ85XgRAAacWGIwKWzDg=;
  b=Tuf8XY1UJImoeIpp2nYoC3VB9tJ6uCOPQAbDPuMKToRLWt9cIXfoW/iX
   09JBGG0k78MjrBdT7vnOo0LKWzTkILY1aOcSJtpa6H4UzTkJS6BCjfwqW
   cKUCLDIXOAOqDuCcHcBPucRcyQhWp6mICtR5LGwm0ABhNp9MXuFn4/Yna
   I=;
X-IronPort-AV: E=Sophos;i="6.07,126,1708387200"; 
   d="scan'208";a="332923184"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 21:45:43 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:4706]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.8.10:2525] with esmtp (Farcaster)
 id b3e2a354-b5d8-40da-9532-79da56e6a481; Thu, 14 Mar 2024 21:45:42 +0000 (UTC)
X-Farcaster-Flow-ID: b3e2a354-b5d8-40da-9532-79da56e6a481
Received: from EX19D003UWC002.ant.amazon.com (10.13.138.169) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 14 Mar 2024 21:45:35 +0000
Received: from [10.119.229.181] (10.119.229.181) by
 EX19D003UWC002.ant.amazon.com (10.13.138.169) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 14 Mar 2024 21:45:34 +0000
Message-ID: <404fec0f-430b-44f1-8cdf-13573f0ae522@amazon.com>
Date: Thu, 14 Mar 2024 14:45:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: Sean Christopherson <seanjc@google.com>, James Gowans <jgowans@amazon.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Patrick Roy
	<roypat@amazon.co.uk>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, David Woodhouse
	<dwmw@amazon.co.uk>, Nikita Kalyazin <kalyazin@amazon.co.uk>,
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "mst@redhat.com" <mst@redhat.com>,
	"somlo@cmu.edu" <somlo@cmu.edu>, Alexander Graf <graf@amazon.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, <xmarcalx@amazon.com>, <tabba@google.com>,
	<qperret@google.com>, <kvmarm@lists.linux.dev>
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <ZeudRmZz7M6fWPVM@google.com>
Content-Language: en-US
From: "Manwaring, Derek" <derekmn@amazon.com>
In-Reply-To: <ZeudRmZz7M6fWPVM@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D042UWB002.ant.amazon.com (10.13.139.175) To
 EX19D003UWC002.ant.amazon.com (10.13.138.169)

On Fri, 8 Mar 2024 15:22:50 -0800, Sean Christopherson wrote:
> On Fri, Mar 08, 2024, James Gowans wrote:
> > We are also aware of ongoing work on guest_memfd. The current
> > implementation unmaps guest memory from VMM address space, but leaves it
> > in the kernel’s direct map. We’re not looking at unmapping from VMM
> > userspace yet; we still need guest RAM there for PV drivers like virtio
> > to continue to work. So KVM’s gmem doesn’t seem like the right solution?
>
> We (and by "we", I really mean the pKVM folks) are also working on allowing
> userspace to mmap() guest_memfd[*].  pKVM aside, the long term vision I have for
> guest_memfd is to be able to use it for non-CoCo VMs, precisely for the security
> and robustness benefits it can bring.
>
> What I am hoping to do with guest_memfd is get userspace to only map memory it
> needs, e.g. for emulated/synthetic devices, on-demand.  I.e. to get to a state
> where guest memory is mapped only when it needs to be.

Thank you for the direction, this is super helpful.

We are new to the guest_memfd space, and for simplicity we'd prefer to
leave guest_memfd completely mapped in userspace. Even in the long term,
we actually don't have any use for unmapping from host userspace. The
current form of marking pages shared doesn't quite align with what we're
trying to do either since it also shares the pages with the host kernel.

What are your thoughts on a flag for KVM_CREATE_GUEST_MEMFD that only
removes from the host kernel's direct map, but leaves everything mapped
in userspace?

Derek

