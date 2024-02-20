Return-Path: <kvm+bounces-9226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0206E85C38C
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 19:20:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1DF72817B4
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 18:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFE277F33;
	Tue, 20 Feb 2024 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="HaHts8d1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA61578B51;
	Tue, 20 Feb 2024 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708453202; cv=none; b=jEDiegGrxRfDjnqJsXleSqVgIHsxAFCrVHUsKAApP0I6istKSdEzVe/RaGbITZ25Tl82oCI4oPF9CwIS7+TOoh2ufDs+JH04GPogxbNXMtoJDX8FW27ehWaSSyCA/44BiizuXjvRnZYQ4Lr2+JAFnxlHNkKRrDQdBowWNbD8Hkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708453202; c=relaxed/simple;
	bh=E8K+6Wm53lwrPr2IqIINIugq49kJsMNCH84DE/g7vVY=;
	h=Subject:MIME-Version:Content-Type:Date:Message-ID:CC:From:To:
	 References:In-Reply-To; b=M+Ypc6nT9A3W/tJQuZ9pWu25O60l4BtOVVbcyt4ZLOM/jVajEfexuxiPLW/RI65sxjLduJS32BJxKe/YXwdkWLaWrr9/lteTk+LesjYHUVWoRmdKGxyxdq6YZ9nhAvwsynnIvV2pkK9G2g2FNhjmQgYja4HXgwS8/dB6SBag0Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.es; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=HaHts8d1; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1708453201; x=1739989201;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=baf//OFtaBmveFrh1T1pIXdXH6SodC8p/NjJvSUchbw=;
  b=HaHts8d1/bqJCwNjlrnR+lDGRzpg7oiVtdU9eWt42BSj05XjCIyYzCEz
   bLM3JxcbOY802jhcZVK9I7FyJ5BA+jG7UxjWMjGJlF17XOQszVYkyXzfl
   5wcmTJgbK6Ccl7y4tshrFrMZbGsDLsXRtUroYsxhsTKk9rRq0L48iYcdc
   s=;
X-IronPort-AV: E=Sophos;i="6.06,174,1705363200"; 
   d="scan'208";a="614314737"
Subject: Re: [RFC] cputime: Introduce option to force full dynticks accounting on
 NOHZ & NOHZ_IDLE CPUs
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 18:19:54 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:20536]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.31.182:2525] with esmtp (Farcaster)
 id c706beb8-aa81-4dca-8c2b-451948cd7111; Tue, 20 Feb 2024 18:19:52 +0000 (UTC)
X-Farcaster-Flow-ID: c706beb8-aa81-4dca-8c2b-451948cd7111
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 20 Feb 2024 18:19:52 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Tue, 20 Feb
 2024 18:19:48 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Feb 2024 18:19:44 +0000
Message-ID: <CZA43Y64EK8R.1M8J5Q6L39LFB@amazon.com>
CC: <frederic@kernel.org>, <paulmck@kernel.org>, <jalliste@amazon.co.uk>,
	<mhiramat@kernel.org>, <akpm@linux-foundation.org>, <pmladek@suse.com>,
	<rdunlap@infradead.org>, <tsi@tuyoix.net>, <nphamcs@gmail.com>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <pbonzini@redhat.com>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: aerc 0.16.0-127-gec0f4a50cf77
References: <20240219175735.33171-1-nsaenz@amazon.com>
 <ZdTQyb23KJEYqbcw@google.com>
In-Reply-To: <ZdTQyb23KJEYqbcw@google.com>
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Hi Sean,

On Tue Feb 20, 2024 at 4:18 PM UTC, Sean Christopherson wrote:
> On Mon, Feb 19, 2024, Nicolas Saenz Julienne wrote:
> > Under certain extreme conditions, the tick-based cputime accounting may
> > produce inaccurate data. For instance, guest CPU usage is sensitive to
> > interrupts firing right before the tick's expiration. This forces the
> > guest into kernel context, and has that time slice wrongly accounted as
> > system time. This issue is exacerbated if the interrupt source is in
> > sync with the tick, significantly skewing usage metrics towards system
> > time.
>
> ...
>
> > NOTE: This wasn't tested in depth, and it's mostly intended to highligh=
t
> > the issue we're trying to solve. Also ccing KVM folks, since it's
> > relevant to guest CPU usage accounting.
>
> How bad is the synchronization issue on upstream kernels?  We tried to ad=
dress
> that in commit 160457140187 ("KVM: x86: Defer vtime accounting 'til after=
 IRQ handling").
>
> I don't expect it to be foolproof, but it'd be good to know if there's a =
blatant
> flaw and/or easily closed hole.

The issue is not really about the interrupts themselves, but their side
effects.

For instance, let's say the guest sets up an Hyper-V stimer that
consistently fires 1 us before the preemption tick. The preemption tick
will expire while the vCPU thread is running with !PF_VCPU (maybe inside
kvm_hv_process_stimers() for ex.). As long as they both keep in sync,
you'll get a 100% system usage. I was able to reproduce this one through
kvm-unit-tests, but the race window is too small to keep the interrupts
in sync for long periods of time, yet still capable of producing random
system usage bursts (which unacceptable for some use-cases).

Other use-cases have bigger race windows and managed to maintain high
system CPU usage over long periods of time. For example, with user-space
HPET emulation, or KVM+Xen (don't know the fine details on these, but
VIRT_CPU_ACCOUNTING_GEN fixes the mis-accounting). It all comes down to
the same situation. Something triggers an exit, and the vCPU thread goes
past 'vtime_account_guest_exit()' just in time for the tick interrupt to
show up.

Note that we're running with 160457140187 ("KVM: x86: Defer vtime
accounting 'til after IRQ handling"), on the kernel that reproduced
these issues. The RFC fix was tested against an upstream kernel by
tracing cputime accounting and making sure the right code-paths were
exercised.

Nicolas

