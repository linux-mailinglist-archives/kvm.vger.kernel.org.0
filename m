Return-Path: <kvm+bounces-29946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0244A9B4BF4
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:18:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC21528298F
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2435B206E9E;
	Tue, 29 Oct 2024 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npqMchlO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F33E1E507;
	Tue, 29 Oct 2024 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730211489; cv=none; b=pZrU4JCZ1TgoKsvWmPFVEeWs1k+k8jAs7hTEi5LbvUSsWhZR0BQvQVaElz9evgN3hQpSZFM5/BhgfHzyYv4VWM1G/jg6fiWSZ9S+dBM/2qKR+bSn9pCPojkIUI+trp+2nwxus2QlpwOubenpCCH9E8QrMbJS3zdm5AtOKW7CFg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730211489; c=relaxed/simple;
	bh=McEZtfOP6VjUEou6D0sp3RbKj3XY5E+ZTox3plQDDlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGBMhmMKgmKNpmce4r3Qn0vryJYO3jRVAL4yDhOHFC9pJLFMURCHjErZmtOsQWtnWd6bMcX4UJhSR7L6+5rLZbgCwB6+ikDMzLz4yhbs6HPhBWxbWrhtereRmtidkl4XVTn5DESPc35UidQRwkxaSEgGr+2bgmnpG1EcdtbigfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npqMchlO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39ACFC4CECD;
	Tue, 29 Oct 2024 14:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730211488;
	bh=McEZtfOP6VjUEou6D0sp3RbKj3XY5E+ZTox3plQDDlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=npqMchlOZfIXy9KzRwaSUcGb/ms2aTIHWUQ4JfHeUuGZMvAglstLEEUurwzfuei2d
	 1qSdZTkt34eaSjcHboitlPT3HA4EpYuPb+yZ7oEUUiixJKpSyoIwhnaGEx14iDaKuz
	 XU0tPuFMVt406sGyhOVypLWhJNs7BE5PvJnd3N65XOWOxmZbbjNiyeoYR3yBj6KNgk
	 X24A+WyU1Gv6tTCepVkJ4vRlvjJsTjoJFG/pk+Md1+uk308yBlMoUnKjO15tzpqOoT
	 e+NJBXDJ/gXF5PcovPlHo1iKoLkuoSuBE5NgM0v9//i4APxMRfEC7K8hnGzL47qSR8
	 WE+eN6fUpNGMQ==
Date: Tue, 29 Oct 2024 14:18:03 +0000
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 0/6] KVM: Fix bugs in vCPUs xarray usage
Message-ID: <20241029141802.GA4691@willie-the-truck>
References: <20241009150455.1057573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009150455.1057573-1-seanjc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Oct 09, 2024 at 08:04:49AM -0700, Sean Christopherson wrote:
> This series stems from Will's observation[*] that kvm_vm_ioctl_create_vcpu()'s
> handling of xa_store() failure when inserting into vcpu_array is technically
> broken, although in practice it's impossible for xa_store() to fail.
> 
> After much back and forth and staring, I realized that commit afb2acb2e3a3
> ("KVM: Fix vcpu_array[0] races") papered over underlying bugs in
> kvm_get_vcpu() and kvm_for_each_vcpu().  The core problem is that KVM
> allowed other tasks to see vCPU0 while online_vcpus==0, and thus trying
> to gracefully error out of vCPU creation led to use-after-free failures.
> 
> So, rather than trying to solve the unsolvable problem for an error path
> that should be impossible to hit, fix the underlying issue and ensure that
> vcpu_array[0] is accessed if and only if online_vcpus is non-zero.
> 
> Patch 3 fixes a race Michal identified when we were trying to figure out
> how to handle the xa_store() mess.
> 
> Patch 4 reverts afb2acb2e3a3.
> 
> Patches 5 and 6 are tangentially related cleanups.

Thanks, Sean. For the series:

Acked-by: Will Deacon <will@kernel.org>

I sympathise a little with Paolo on patch 4, but at the end of the day
it's a revert and I think that the code is better for it, even if the
whole scenario is messy.

Will

