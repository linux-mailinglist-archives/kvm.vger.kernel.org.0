Return-Path: <kvm+bounces-13595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 755AE898DE1
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04454B21B73
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE36130A65;
	Thu,  4 Apr 2024 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="iZc2nGn/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42a9.mail.infomaniak.ch (smtp-42a9.mail.infomaniak.ch [84.16.66.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA38130A4B
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712255195; cv=none; b=gEwXZ6MwAf9qr5wqx/uXUeFfL0n301uqn+4sv3q98Tu+fTr0GSxDVlMPPTVRSFyLi523fy15Rst75ixvW23s5FQSSEGg+gmpE+b1qGs/n7SxarCD8cGFCKvRQGbFUQjt26V01F6YzHUyKrIfGJeZDatLeJyW1aog9s/lhwjjfig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712255195; c=relaxed/simple;
	bh=hS68QXp66ScUhpRGV4EtkMDc4jnXGdF9EVAx/s/x/dk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M35jD6ANsbChL7ndY0gzgGRi8I2UI1ELBty51iqyCgrIvDdH3msHBfawStxuYemIq4qtY5AW2eTIFD+BzJ8N6InlCrI0s/6TN1jC4wiCcMNvnxFTSiV/eaeY9NubQLj9RhCM6o3ERDOuaEEYtjA82zXt3ZY79+dmxp2NdxfnDGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=iZc2nGn/; arc=none smtp.client-ip=84.16.66.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4V9VSG0trlz3PR;
	Thu,  4 Apr 2024 20:26:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1712255181;
	bh=hS68QXp66ScUhpRGV4EtkMDc4jnXGdF9EVAx/s/x/dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iZc2nGn/NHkQuuqgdrOe8ybA44XbAplsyVwtH72nDZBbD6YYFi5igOIIk3f+oXxTf
	 re6Tz8+Jff2kgO94CSJgbu+kav6LO5w274kOHac1TSiWZf5lfW1IfrUCHXH9dM0wXb
	 FisZqNefk21HRC0k97wQ2sGIPjl7wJjqQ3wlWEb0=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4V9VSB5NfFzlxv;
	Thu,  4 Apr 2024 20:26:18 +0200 (CEST)
Date: Thu, 4 Apr 2024 20:26:18 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, David Stevens <stevensd@chromium.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, Jim Mattson <jmattson@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, Edgecombe@google.com, 
	Rick P <rick.p.edgecombe@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wei Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Kirill Shutemov <kirill.shutemov@linux.intel.com>, Lai Jiangshan <jiangshan.ljs@antgroup.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Jinrong Liang <ljr.kernel@gmail.com>, Like Xu <like.xu.linux@gmail.com>, 
	Mingwei Zhang <mizhang@google.com>, Dapeng Mi <dapeng1.mi@intel.com>, 
	James Morris <jamorris@linux.microsoft.com>, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>, 
	Thara Gopinath <tgopinath@microsoft.com>
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2024
Message-ID: <20240404.Chie9boy2eef@digikod.net>
References: <20240402190652.310373-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240402190652.310373-1-seanjc@google.com>
X-Infomaniak-Routing: alpha

On Tue, Apr 02, 2024 at 12:06:52PM -0700, Sean Christopherson wrote:
> We are planning on submitting a CFP to host a second annual KVM Microconference
> at Linux Plumbers Conference 2024 (https://lpc.events/event/18).  To help make
> our submission as strong as possible, please respond if you will likely attend,
> and/or have a potential topic that you would like to include in the proposal.
> The tentative submission is below.
> 
> Note!  This is extremely time sensitive, as the deadline for submitting is
> April 4th (yeah, we completely missed the initial announcement).
> 
> Sorry for the super short notice. :-(
> 
> P.S. The Cc list is very ad hoc, please forward at will.
> 
> ===================
> KVM Microconference
> ===================
> 
> KVM (Kernel-based Virtual Machine) enables the use of hardware features to
> improve the efficiency, performance, and security of virtual machines (VMs)
> created and managed by userspace.  KVM was originally developed to accelerate
> VMs running a traditional kernel and operating system, in a world where the
> host kernel and userspace are part of the VM's trusted computing base (TCB).
> 
> KVM has long since expanded to cover a wide (and growing) array of use cases,
> e.g. sandboxing untrusted workloads, deprivileging third party code, reducing
> the TCB of security sensitive workloads, etc.  The expectations placed on KVM
> have also matured accordingly, e.g. functionality that once was "good enough"
> no longer meets the needs and demands of KVM users.
> 
> The KVM Microconference will focus on how to evolve KVM and adjacent subsystems
> in order to satisfy new and upcoming requirements.  Of particular interest is
> extending and enhancing guest_memfd, a guest-first memory API that was heavily
> discussed at the 2023 KVM Microconference, and merged in v6.8.
> 
> Potential Topics:
>    - Removing guest memory from the host kernel's direct map[1]
>    - Mapping guest_memfd into host userspace[2]
>    - Hugepage support for guest_memfd[3]
>    - Eliminating "struct page" for guest_memfd
>    - Passthrough/mediated PMU virtualization[4]
>    - Pagetable-based Virtual Machine (PVM)[5]
>    - Optimizing/hardening KVM usage of GUP[6][7]
>    - Defining KVM requirements for hardware vendors
>    - Utilizing "fault" injection to increase test coverage of edge cases

We are still working on Heki to improve CR-pinning, memory protection,
related interfaces and tests.  We'll send a new patch series shortly on
CR-pinning (only), and follow-ups later.  By September, we'll like to
share some updates and this microconference would be a good opportunity,
with the right format this time. ;)

> 
> [1] https://lore.kernel.org/all/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
> [2] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
> [3] https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com
> [4] https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
> [5] https://lore.kernel.org/all/20240226143630.33643-1-jiangshanlai@gmail.com
> [6] https://lore.kernel.org/all/CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvRTUk2TPYycg@mail.gmail.com
> [7] https://lore.kernel.org/all/20240320005024.3216282-1-seanjc@google.com
> 

