Return-Path: <kvm+bounces-29867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A93B29B36E9
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:43:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EA211F22196
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEAB1DF253;
	Mon, 28 Oct 2024 16:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3QvXn0E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0681DEFE0
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730133802; cv=none; b=U0xdIaJr0r96uD1R5/YP6+owSnYkpsZ5UZ/rvHxeTFFgKPFa7LYhBJCPPjjpu46gqgGAfYzkCx852SdTzKdUM1OJU8rL3wrNdvz/wgrp7WQw5BjBnSsxsprP1CaRph33BU9coNngJnCR0cTtcbrj98T3yC/v+krvLLMzYTI1kW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730133802; c=relaxed/simple;
	bh=yfqmIms7MfM3JICle95HGeL9mH6XVa55qkpY5FxeOJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZ7ZWwIF9cAb3Ry1azncHaep5/2mjDfWfIBFxgqDn8QC932sYKZPOY6g3tD7GvhX9Qxw9lv5IWpaNawfzddQhd2fTSAe6iPr7sQzv49wvpkdNglHS7D38TxXZOuFafSUeF2N437Lgj1+ozlL98XXcSagk/9dHNVu+pBmHHEes00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3QvXn0E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730133799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=51/Vb7GBfqvT7hRJvby3BGC7jh1OqW8AguMsa1iyHpM=;
	b=e3QvXn0EluovAhpClIkAW4RUnlIQKTUvDd08fI67ndHtbfXUQnh6pWhnT9kBJWlcObEbNG
	5YV+I2NDqdyF0tPtuNUS+8SpvMjTcvCHGk2jqUN6xpVWoIZAjaxmGOr075VrUNuI7MgfUK
	leD6JAyBRTloU+35p9+XE2nkHnlPiJI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-LlFqgUKGPZe2niyUpoNl9w-1; Mon,
 28 Oct 2024 12:43:16 -0400
X-MC-Unique: LlFqgUKGPZe2niyUpoNl9w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B5941955F41;
	Mon, 28 Oct 2024 16:43:14 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BC3B1956086;
	Mon, 28 Oct 2024 16:43:13 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 6B0B340103218; Mon, 28 Oct 2024 13:42:54 -0300 (-03)
Date: Mon, 28 Oct 2024 13:42:54 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
	chao.gao@intel.com, rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
Message-ID: <Zx+/Dl0F73GUrzI2@tpad>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <c4df36dc-9924-e166-ec8b-ee48e4f6833e@amd.com>
 <ZxvGPZDQmqmoT0Sj@tpad>
 <81e6604b-fa84-4b74-b9e6-2a37e8076fd7@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e6604b-fa84-4b74-b9e6-2a37e8076fd7@intel.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Sun, Oct 27, 2024 at 10:06:17PM +0800, Xiaoyao Li wrote:
> On 10/26/2024 12:24 AM, Marcelo Tosatti wrote:
> > On Mon, Oct 14, 2024 at 08:17:19PM +0530, Nikunj A. Dadhania wrote:
> > > Hi Isaku,
> > > 
> > > On 10/12/2024 1:25 PM, Isaku Yamahata wrote:
> > > > This patch series is for the kvm-coco-queue branch.  The change for TDX KVM is
> > > > included at the last.  The test is done by create TDX vCPU and run, get TSC
> > > > offset via vCPU device attributes and compare it with the TDX TSC OFFSET
> > > > metadata.  Because the test requires the TDX KVM and TDX KVM kselftests, don't
> > > > include it in this patch series.
> > > > 
> > > > 
> > > > Background
> > > > ----------
> > > > X86 confidential computing technology defines protected guest TSC so that the
> > > > VMM can't change the TSC offset/multiplier once vCPU is initialized and the
> > > > guest can trust TSC.  The SEV-SNP defines Secure TSC as optional.  TDX mandates
> > > > it.  The TDX module determines the TSC offset/multiplier.  The VMM has to
> > > > retrieve them.
> > > > 
> > > > On the other hand, the x86 KVM common logic tries to guess or adjust the TSC
> > > > offset/multiplier for better guest TSC and TSC interrupt latency at KVM vCPU
> > > > creation (kvm_arch_vcpu_postcreate()), vCPU migration over pCPU
> > > > (kvm_arch_vcpu_load()), vCPU TSC device attributes (kvm_arch_tsc_set_attr()) and
> > > > guest/host writing to TSC or TSC adjust MSR (kvm_set_msr_common()).
> > > > 
> > > > 
> > > > Problem
> > > > -------
> > > > The current x86 KVM implementation conflicts with protected TSC because the
> > > > VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
> > > > logic to change/adjust the TSC offset/multiplier somehow.
> > > > 
> > > > Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
> > > > offset/multiplier, the TSC timer interrupts are injected to the guest at the
> > > > wrong time if the KVM TSC offset is different from what the TDX module
> > > > determined.
> > > > 
> > > > Originally the issue was found by cyclic test of rt-test [1] as the latency in
> > > > TDX case is worse than VMX value + TDX SEAMCALL overhead.  It turned out that
> > > > the KVM TSC offset is different from what the TDX module determines.
> > > 
> > > Can you provide what is the exact command line to reproduce this problem ?
> > 
> > Nikunj,
> > 
> > Run cyclictest, on an isolated CPU, in a VM. For the maximum latency
> > metric, rather than 50us, one gets 500us at times.
> > 
> > > Any links to this reported issue ?
> > 
> > This was not posted publically. But its not hard to reproduce.
> > 
> > > > Solution
> > > > --------
> > > > The solution is to keep the KVM TSC offset/multiplier the same as the value of
> > > > the TDX module somehow.  Possible solutions are as follows.
> > > > - Skip the logic
> > > >    Ignore (or don't call related functions) the request to change the TSC
> > > >    offset/multiplier.
> > > >    Pros
> > > >    - Logically clean.  This is similar to the guest_protected case.
> > > >    Cons
> > > >    - Needs to identify the call sites.
> > > > 
> > > > - Revert the change at the hooks after TSC adjustment
> > > >    x86 KVM defines the vendor hooks when the TSC offset/multiplier are
> > > >    changed.  The callback can revert the change.
> > > >    Pros
> > > >    - We don't need to care about the logic to change the TSC offset/multiplier.
> > > >    Cons:
> > > >    - Hacky to revert the KVM x86 common code logic.
> > > > 
> > > > Choose the first one.  With this patch series, SEV-SNP secure TSC can be
> > > > supported.
> > > 
> > > I am not sure how will this help SNP Secure TSC, as the GUEST_TSC_OFFSET and
> > > GUEST_TSC_SCALE are only available to the guest.
> > 
> > Nikunj,
> > 
> > FYI:
> > 
> > SEV-SNP processors (at least the one below) do not seem affected by this problem.
> 
> Did you apply Secure TSC patches of (guest kernel, KVM and QEMU) manualy?
> because none of them are merged. 

Yes. cyclictest latency, on a system configured with tuned
realtime-virtual-host/realtime-virtual-guest tuned profiles,
goes from 30us to 50us.

> Otherwise, I think SNP guest is still using
> KVM emulated TSC.

Not in the case the test was made.


