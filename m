Return-Path: <kvm+bounces-67013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4E1CF244C
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 08:50:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CBA65303A1BE
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 07:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FC22D8793;
	Mon,  5 Jan 2026 07:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="CD5nQ3xL"
X-Original-To: kvm@vger.kernel.org
Received: from out28-195.mail.aliyun.com (out28-195.mail.aliyun.com [115.124.28.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA58BA59;
	Mon,  5 Jan 2026 07:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767599312; cv=none; b=MQfekedpOmHp7Het63WHqWA7TcXIdhWiAO9kKfb+S1LaU5ylmqSCAjvc10RpZwttVVEJ+le/+5DNqiXYKcIu9nejjESG3Pm4GpgUNWUrirng4XWQLuL8gMXIYwK18Yr+Ex/ZAnqngk8b6XZh/0setKMK/JArzPi90n030c3FC9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767599312; c=relaxed/simple;
	bh=xxdTQLUipXjsBIBt7dai4U8wy/0oeFSdPPypmm2ve60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tU1Z7liI1j22EEM1NIw8U/WfPn0GHYDTMF0JujGKc526g54OVX17jWnvrPRhrIxoUehhpZsFpbey6RKfNyyhc2gMhQ5hEZrjLMeFjjivNDFwxEHLutrVVz6IrU6HwlWDOMIY3hLPZQhMy324aoT7S7Df4B2YV6ezzR8Gzar1Z1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=CD5nQ3xL; arc=none smtp.client-ip=115.124.28.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1767599296; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=W+7K4RRtGsjInJRd4sOSc25Od1aDGNjLovyLLXZZnAM=;
	b=CD5nQ3xLwAiDzlmwjeRzJCUBKMF5AmAcIooIjW6OsmSS/aaAR5CPTM1miP2RRyaptdvNDpLhNQYYKMXxuJ6wseexck2/cBR2DyZVby+fUlfoyUiR6VakhTZT9jnde4yV38NHeGJ6xbHiFj+odsjuEvKI0YsxChvMJBTM+oWT4Ck=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.g-Bx46a_1767599294 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 05 Jan 2026 15:48:15 +0800
Date: Mon, 5 Jan 2026 15:48:14 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
	Anish Ghulati <aghulati@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	hpa@zytor.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
	peterz@infradead.org, paulmck@kernel.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH 00/14] Support multiple KVM modules on the same host
Message-ID: <20260105074814.GA10215@k08j02272.eu95sqa>
References: <20231107202002.667900-1-aghulati@google.com>
 <CAJhGHyBtis3SkNZP8RSX5nKFcnQ4qvUrfTMD2RPc+w+Rzf30Zw@mail.gmail.com>
 <ZWYtDGH5p4RpGYBw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZWYtDGH5p4RpGYBw@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Nov 28, 2023 at 10:10:20AM -0800, Sean Christopherson wrote:
> On Fri, Nov 17, 2023, Lai Jiangshan wrote:
> > On Wed, Nov 8, 2023 at 4:20 AM Anish Ghulati <aghulati@google.com> wrote:
> > >
> > > This series is a rough, PoC-quality RFC to allow (un)loading and running
> > > multiple KVM modules simultaneously on a single host, e.g. to deploy
> > > fixes, mitigations, and/or new features without having to drain all VMs
> > > from the host. Multi-KVM will also allow running the "same" KVM module
> > > with different params, e.g. to run trusted VMs with different mitigations.
> > >
> > > The goal of this RFC is to get feedback on the idea itself and the
> > > high-level approach.  In particular, we're looking for input on:
> > >
> > >  - Combining kvm_intel.ko and kvm_amd.ko into kvm.ko
> > >  - Exposing multiple /dev/kvmX devices via Kconfig
> > >  - The name and prefix of the new base module
> > >
> > > Feedback on individual patches is also welcome, but please keep in mind
> > > that this is very much a work in-progress
> > 
> > Hello Anish
> > 
> > Scarce effort on multi-KVM can be seen in the mail list albeit many
> > companies enable multi-KVM internally.
> > 
> > I'm glad that you took a big step in upstreaming it.  And I hope it
> > can be materialized soon.
> > 
> > 
> > >
> > >  - Move system-wide virtualization resource management to a new base
> > >    module to avoid collisions between different KVM modules, e.g. VPIDs
> > >    and ASIDs need to be unique per VM, and callbacks from IRQ handlers need
> > >    to be mediated so that things like PMIs get to the right KVM instance.
> > 
> > perf_register_guest_info_callbacks() also accesses to system-wide resources,
> > but I don't see its relating code including kvm_guest_cbs being moved to AVC.
> 
> Yeah, that's on the TODO list.  IIRC, the plan is to have VAC register a single
> callback with perf, and then have VAC deal with invoking the callback(s) for the
> correct KVM instance.
> 
> > >  - Refactor KVM to make all upgradable assets visible only to KVM, i.e.
> > >    make KVM a black box, so that the layout/size of things like "struct
> > >    kvm_vcpu" isn't exposed to the kernel at-large.
> > >
> > >  - Fold kvm_intel.ko and kvm_amd.ko into kvm.ko to avoid complications
> > >    having to generate unique symbols for every symbol exported by kvm.ko.
> > 
> > The sizes of kvm_intel.ko and kvm_amd.ko are big, and there
> > is only 1G in the kernel available for modules. So I don't think folding
> > two vendors' code into kvm.ko is a good idea.
> > 
> > Since the symbols in the new module are invisible outside, I recommend:
> > new kvm_intel.ko = kvm_intel.ko + kvm.ko
> > new kvm_amd.ko = kvm_amd.ko + kvm.ko
> 
> Yeah, Paolo also suggested this at LPC.
> 
> > >  - Add a Kconfig string to allow defining a device and module postfix at
> > >    build time, e.g. to create kvmX.ko and /dev/kvmX.
> > >
> > > The proposed name of the new base module is vac.ko, a.k.a.
> > > Virtualization Acceleration Code (Unupgradable Units Module). Childish
> > > humor aside, "vac" is a unique name in the kernel and hopefully in x86
> > > and hardware terminology, is a unique name in the kernel and hopefully
> > > in x86 and hardware terminology, e.g. `git grep vac_` yields no hits in
> > > the kernel. It also has the same number of characters as "kvm", e.g.
> > > the namespace can be modified without needing whitespace adjustment if
> > > we want to go that route.
> > 
> > How about the name kvm_base.ko?
> > 
> > And the variable/function name in it can still be kvm_foo (other than
> > kvm_base_foo).
> 
> My preference is to have a unique name that allows us to differentitate between
> the "base" module/code and KVM code.  Verbal conversations about all of this get
> quite confusing because it's not always clear whether "base KVM" refers to what
> is currently kvm.ko, or what would become kvm_base.ko/vac.ko.
>
Hi, Sean and Anish.

Sorry for revisiting this topic after a long time. I haven't seen any
new updates regarding this topic/series, and I didn’t find any recent
activity on the GitHub repository. Is the multi-KVM topic still being
considered for upstreaming, or is there anything blocking this?

As Lai pointed out, we also have a similar multi-KVM implementation in
our internal environment, so we are quite interested in this topic.
Recently, when we upgraded our kernel version, we found that maintaining
multi-KVM has become a significant burden. We are willing to move
forward with it if multi-KVM is still accepted for upstream. So I look
forward to feedback from the maintainers.

From what I've seen, the recent patch set that enables VMX/SVM during
booting is a good starting point for multi-KVM as well.

Thanks!

