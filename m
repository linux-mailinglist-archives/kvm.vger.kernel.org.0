Return-Path: <kvm+bounces-3750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D41807821
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC5F3B20FA8
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEAA47793;
	Wed,  6 Dec 2023 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B5DPzN5J"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17F311F;
	Wed,  6 Dec 2023 10:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TgX+PmuAr5QRkCmSx0BsqqI+xnwWnFusCDa4CHApM4Y=; b=B5DPzN5JWKoYuSlpoDnvFq5zOY
	dzy+/0VlFQNrT2wh4LgPvSRluDKGcHlGhouKPTNRY/3vVEEFJ+IKrhPccE1kFE7jLARo3gHWsRE+m
	hyfobf0yCSUyHM9U1jb0+6DpKrPKsPx7L/YNpn8cKZHkYmiUO8SIvkZZWuqobDpGSal/sOYVBv7Vm
	XT8/adblz9WvVW6ebYI03bIYngMaLuIkVlBSScKOXh19/Mb231q3/GTdydkZEPlwte5TTgs3iRX+0
	AJ5UeGPpggFN+1gIc3zDpXpuIDmBzRjbLYup40yo3omwimvD2/V3tK6zybuhECjs7PtpcykiFidbn
	db/iU80A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rAwzg-003AJI-8e; Wed, 06 Dec 2023 18:51:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E0501300451; Wed,  6 Dec 2023 19:51:34 +0100 (CET)
Date: Wed, 6 Dec 2023 19:51:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
	=?utf-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>, Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?utf-8?Q?=C8=98tefan_=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
	x86@kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [RFC PATCH v2 17/19] heki: x86: Update permissions counters
 during text patching
Message-ID: <20231206185134.GA9899@noisy.programming.kicks-ass.net>
References: <20231113022326.24388-1-mic@digikod.net>
 <20231113022326.24388-18-mic@digikod.net>
 <20231113081929.GA16138@noisy.programming.kicks-ass.net>
 <a52d8885-43cc-4a4e-bb47-9a800070779e@linux.microsoft.com>
 <20231127200841.GZ3818@noisy.programming.kicks-ass.net>
 <ea63ae4e-e8ea-4fbf-9383-499e14de2f5e@linux.microsoft.com>
 <20231130113315.GE20191@noisy.programming.kicks-ass.net>
 <624a310b-c0d2-406c-a4a7-d851b3cc68f5@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <624a310b-c0d2-406c-a4a7-d851b3cc68f5@linux.microsoft.com>

On Wed, Dec 06, 2023 at 10:37:33AM -0600, Madhavan T. Venkataraman wrote:
> 
> 
> On 11/30/23 05:33, Peter Zijlstra wrote:
> > On Wed, Nov 29, 2023 at 03:07:15PM -0600, Madhavan T. Venkataraman wrote:
> > 
> >> Kernel Lockdown
> >> ---------------
> >>
> >> But, we must provide at least some security in V2. Otherwise, it is useless.
> >>
> >> So, we have implemented what we call a kernel lockdown. At the end of kernel
> >> boot, Heki establishes permissions in the extended page table as mentioned
> >> before. Also, it adds an immutable attribute for kernel text and kernel RO data.
> >> Beyond that point, guest requests that attempt to modify permissions on any of
> >> the immutable pages will be denied.
> >>
> >> This means that features like FTrace and KProbes will not work on kernel text
> >> in V2. This is a temporary limitation. Once authentication is in place, the
> >> limitation will go away.
> > 
> > So either you're saying your patch 17 / text_poke is broken (so why
> > include it ?!?) or your statement above is incorrect. Pick one.
> > 
> 
> It has been included so that people can be aware of the changes.
> 
> I will remove the text_poke() changes from the patchset and send it later when
> I have some authentication in place. It will make sense then.

If you know its broken then fucking say so in the Changelog instead of
wasting everybody's time.. OMG.

