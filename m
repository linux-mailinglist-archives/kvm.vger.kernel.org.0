Return-Path: <kvm+bounces-36593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA225A1C0E3
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 05:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1B731886CF2
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 04:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B29206F02;
	Sat, 25 Jan 2025 04:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3anGjTZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04313148316;
	Sat, 25 Jan 2025 04:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737777948; cv=none; b=s7weCp62/dw0T8J94Slaoo1hlzskxZlY3Lbc99mEZKw34xAnRuNF/Zx4bvgyGb3uYae/5+UJg64l3mnUyolXlu93BQHODUEIxiRUlmyb4mHQnTXtnCZF1nH0z7DUnMDpRFko36gzNb095zdZ3xpg8QgywbLprefXHMmo6t+4I3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737777948; c=relaxed/simple;
	bh=ACa61NzkUUavq1Te1B/3kPVDOffuCZpKxogAMHFYAcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bo5qDrj4TyHMuhTm/uG1fh9lo+TSKh3i2LdLA06TKm1eL3c43OqjNA/BvB+bAtc4Ke8uhIH9eb+RetMn+0Q/y/tz1ZB6J+igjVaI7pYI7/oXwNwqpiHb9ETQHVE8Niqp/8fWxZK3RdsZf3QWzyz/EhejBqt1IHiNA50u+/874q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3anGjTZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C6CC4CED6;
	Sat, 25 Jan 2025 04:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737777947;
	bh=ACa61NzkUUavq1Te1B/3kPVDOffuCZpKxogAMHFYAcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l3anGjTZ4oPxdrT8juwwzrEomg8nrdfLl0zZtRdrsQCIDaT5ywolyJth+xNRsxBZ1
	 sMYDOrUtLlPxGqimFcf/yymboIGiTmKEiTz6zXMnUj4MzmEj+fQTn2u09Ligd8xdEx
	 nzQfKqMQhs/VT0so8wYAmZAm2kknsyLHRBhmnU95oFlO0iZi8ymWwCNUJkXu2H6n6l
	 lRuNzS44BmxSs6jVVYCncLRZ4YTV0BT54L4BET71+cXAgl42qf1dB2gXyyVYyj572Q
	 w/HlJHdKoM4NNhhvaSM4bhyxJs0ID/0AzfcwxjmXq8Sp3JGnfeq2BHi6KcXpic+8QS
	 jLtxuClbm0png==
Date: Fri, 24 Jan 2025 21:05:44 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Vlad Poenaru <thevlad@meta.com>,
	tj@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Alyssa Ross <hi@alyssa.is>
Subject: Re: [PATCH] kvm: defer huge page recovery vhost task to later
Message-ID: <Z5RjGOmalDcS-L39@kbusch-mbp>
References: <20250123153543.2769928-1-kbusch@meta.com>
 <Z5Py_JYc8nYHNgZS@google.com>
 <Z5P97NyK9Rb_cU1z@kbusch-mbp>
 <Z5QsBXJ7rkJFDtmK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5QsBXJ7rkJFDtmK@google.com>

On Fri, Jan 24, 2025 at 04:10:45PM -0800, Sean Christopherson wrote:
> On Fri, Jan 24, 2025, Keith Busch wrote:
> > On Fri, Jan 24, 2025 at 12:07:24PM -0800, Sean Christopherson wrote:
> > > This is broken.  If the module param is toggled before the first KVM_RUN, KVM
> > > will hit a NULL pointer deref due to trying to start a non-existent vhost task:
> > > 
> > >   BUG: kernel NULL pointer dereference, address: 0000000000000040
> > >   #PF: supervisor read access in kernel mode
> > >   #PF: error_code(0x0000) - not-present page
> > >   PGD 0 P4D 0 
> > >   Oops: Oops: 0000 [#1] SMP
> > >   CPU: 16 UID: 0 PID: 1190 Comm: bash Not tainted 6.13.0-rc3-9bb02e874121-x86/xen_msr_fixes-vm #2382
> > >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> > >   RIP: 0010:vhost_task_wake+0x5/0x10
> > >   Call Trace:
> > >    <TASK>
> > >    set_nx_huge_pages+0xcc/0x1e0 [kvm]
> > 
> > Thanks for pointing out this gap. It looks like we'd have to hold the
> > kvm_lock in kvm_mmu_post_init_vm(), and add NULL checks in
> > set_nx_huge_pages() and set_nx_huge_pages_recovery_param() to prevent
> > the NULL deref. Is that okay?
> 
> I don't _think_ we need to take kvm_lock.  And I don't want to take kvm_lock,
> because we're also trying to eliminate a (very theoretical) deadlock[1] due to
> taking kvm_lock in the params helpers.
> 
> There is a race that can happen with my proposed fix[2], but I'm not sure we care
> enough to address it.  If kvm_nx_huge_page_recovery_worker() runs before the params
> are set, and the param setter processes the VM before nx_huge_page_recovery_thread
> is set, then the worker could sleep for too long, relative to what userspace expects.
> 
> I suppose if we care then we could fix that by taking kvm->arch.nx_once.mutex
> when waking the task?

I think we actually can do this without any additional locks. The only
thing we need to ensure is that the vhost task sees the updated
variable, and I think we can achieve that with appropriate memory
barriers on the reads and writes.

