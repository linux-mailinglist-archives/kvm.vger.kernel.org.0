Return-Path: <kvm+bounces-31310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C91E9C22C7
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 18:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 039941F234B0
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C374E1CC15E;
	Fri,  8 Nov 2024 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="flYQqY0q"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F2315B0F7
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731086302; cv=none; b=vCGG19RDDPXoV7ncgxCzEfWRl0d9h26qIh5uDBvVq/k5L4yjgXzDLUffw9ACS6KixMyt/N5VO0O9RPIL1F9CFTzVOv4DxL5/sObAUzYuKfWMkGKYAZ2hSNyZBOzLmGThjOeDq9tXhtTw37pbjBWsV3lqMVSC6iv+wYcMnIaiQxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731086302; c=relaxed/simple;
	bh=51c6AUdTIFf56BqtHB0JWrCBxrdDN7buxgLIiQDM1gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/TKMp7eo24hv8N2S0Mmjc81N50Bf5j1pjm4rvEwyPLq0xd7cT1i7YEfKQq/sXKmCj+ZvNZBA1UzNG05OElNeqFkHXXbKd9AhgiNRzZ9sLt/OK0Z+u58DInFWdikTTq5UKFQK2svA/QEJAYga+IQThEejJyrVprRMHEp5OIwjaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=flYQqY0q; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 8 Nov 2024 09:18:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731086297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yFw+EzmpVyeQ5U1o2xc4KheiZlEJJUBP/WqH28ePy8o=;
	b=flYQqY0qL7nvE9kvwBkll9R71gCyzc+UFZ9QPSgKwY9k1b7f/B0XRU8cjcXHh6ugxsFvV+
	/UkCD0rpPZAN8sqe7CIcB0ef1bIVxunhh0TCe0CvM7Dcl3JVHqF67hdoAHn7775nO9tnTL
	QuLw9a80/CZuB8Ancp0uijeK79SVBSg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Eric Auger <eric.auger@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, eric.auger.pro@gmail.com,
	broonie@kernel.org, maz@kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, joey.gouly@arm.com, shuah@kernel.org,
	pbonzini@redhat.com
Subject: Re: [PATCH 2/3] KVM: selftests: Introduce kvm_vm_dead_free
Message-ID: <Zy5HyfJRaciaICSN@linux.dev>
References: <20241107094000.70705-1-eric.auger@redhat.com>
 <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com>
 <Zy0QFhFsICeNt8kF@linux.dev>
 <Zy0bcM0m-N18gAZz@google.com>
 <Zy0fPgwymCdBwLd_@linux.dev>
 <77cc68a6-2d7a-4ef3-bf4d-93fc9987f466@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77cc68a6-2d7a-4ef3-bf4d-93fc9987f466@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 08, 2024 at 10:00:06AM +0100, Eric Auger wrote:
> Hi Oliver,
> 
> On 11/7/24 21:12, Oliver Upton wrote:
> > On Thu, Nov 07, 2024 at 11:56:32AM -0800, Sean Christopherson wrote:
> >> On Thu, Nov 07, 2024, Oliver Upton wrote:
> >>> On Thu, Nov 07, 2024 at 09:55:52AM -0800, Sean Christopherson wrote:
> >>>> On Thu, Nov 07, 2024, Eric Auger wrote:
> >>>>> In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
> >>>>> KVM ioctls will fail and cause test failure. This now happens
> >>>>> with an aarch64 vgic test where the kvm_vm_free() fails. Let's
> >>>>> add a new kvm_vm_dead_free() helper that does all the deallocation
> >>>>> besides the KVM_SET_USER_MEMORY_REGION2 ioctl.
> >>>> Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
> >>>> The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
> >>>> a more helpful error message, it is most definitely not intended to be an "official"
> >>>> way to detect and react to the VM being dead.
> >>>>
> >>>> IMO, tests that intentionally result in a dead VM should assert that subsequent
> >>>> VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
> >>>> resources adds complexity and pollutes the core selftests APIs, with very little
> >>>> benefit.
> >>> Encouraging tests to explicitly leak resources to fudge around assertions
> >>> in the selftests library seems off to me.
> >> I don't disagree, but I really, really don't want to add vm_dead().
> > It'd still be valuable to test that the VM is properly dead and
> > subsequent ioctls also return EIO, but I understand the hesitation.
> 
> Currently the vgic_test does not check that the VM is dead, it just
> checks the first expected errno according to the uapi documentation.
> Besides AFAIK this latter has not been updated according to the new VM
> dead implementation.

Ah yep, of course. We'll only return EIO for subsequent ioctls. It'd be
nice to assert that is the case, but it isn't _that_ big of a deal.

-- 
Thanks,
Oliver

