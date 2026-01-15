Return-Path: <kvm+bounces-68261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 26657D28FC9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9D82830146D3
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 22:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF74325497;
	Thu, 15 Jan 2026 22:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nv2D1spn"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43322FFDFC
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 22:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768515670; cv=none; b=Fu3ctdF5GeBcOSMJovquqSJ0CFK7Nc8IzdcrKUC+YUtpc3vF3oFmV6VYO13NifOEF96p5xanIpPUoQVV7vSXcDIfJ4JlBK2PGmQ4N9YIlytt1cujdTZz3WSckPsN8iquoE8m17UQwtyFnMauE3xxbIG+FfApjbu7cmy/dhj7ldc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768515670; c=relaxed/simple;
	bh=OW3TcPeVB5ZYLJLZPzaY8L9qpGQNXSeXIyuWss/pgxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHBSoaYjD+vwr0lV07sHAkXsPfvmagvhuj53yxukR571G/OugLbcx1NGMiy2E9nD6Oi9Z5UDPtAZD2qDCWmboozt1yWGd7Oq1DnhB8i5ct/4hKTUBzTxhdpyxQ6NyCED4I1sBhhddpr/YVeGYwbDRNga+IW/5RJ5oDzA3PvEZ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nv2D1spn; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 22:21:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768515666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zc+QHZR9yFxmZa70fEDw4VOYtPawQDDl6jcvS2GVUFg=;
	b=nv2D1spnx/duoQ05VxqKvf20P9z4HLUxKkwF7vkgm3ez9/yHk/pjS5jqWTcZyzpSnUSBGk
	60x8LCOzLxcgb3duvXjf3Z1lG42xhuhQ9+KIeYZi3m0vDOQ+aGwyELaeIK+GQgMP6gGp2a
	MZt6nwUzLFZ7F8zzJtvTwS1iTFIOn90=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
Message-ID: <2kgs2paktjfb33sdr46zhlernx2xgokh5ac4og45obrvvlm34d@2df2kb2u44cy>
References: <20260115172154.709024-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115172154.709024-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 15, 2026 at 09:21:54AM -0800, Sean Christopherson wrote:
> Update the nested dirty log test to validate KVM's handling of READ faults
> when dirty logging is enabled.  Specifically, set the Dirty bit in the
> guest PTEs used to map L2 GPAs, so that KVM will create writable SPTEs
> when handling L2 read faults.  When handling read faults in the shadow MMU,
> KVM opportunistically creates a writable SPTE if the mapping can be
> writable *and* the gPTE is dirty (or doesn't support the Dirty bit), i.e.
> if KVM doesn't need to intercept writes in order to emulate Dirty-bit
> updates.
> 
> To actually test the L2 READ=>WRITE sequence, e.g. without masking a false
> pass by other test activity, route the READ=>WRITE and WRITE=>WRITE
> sequences to separate L1 pages, and differentiate between "marked dirty
> due to a WRITE access/fault" and "marked dirty due to creating a writable
> SPTE for a READ access/fault".  The updated sequence exposes the bug fixed
> by KVM commit 1f4e5fc83a42 ("KVM: x86: fix nested guest live migration
> with PML") when the guest performs a READ=>WRITE sequence with dirty guest
> PTEs.
> 
> Opportunistically tweak and rename the address macros, and add comments,
> to make it more obvious what the test is doing.  E.g. NESTED_TEST_MEM1
> vs. GUEST_TEST_MEM doesn't make it all that obvious that the test is
> creating aliases in both the L2 GPA and GVA address spaces, but only when
> L1 is using TDP to run L2.
> 
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM with one nit/question below:

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

[..]
> +static void l2_guest_code(vm_vaddr_t base)
>  {
> -	READ_ONCE(*a);
> -	WRITE_ONCE(*a, 1);
> -	GUEST_SYNC(true);
> -	GUEST_SYNC(false);
> +	vm_vaddr_t page0 = TEST_GUEST_ADDR(base, 0);
> +	vm_vaddr_t page1 = TEST_GUEST_ADDR(base, 1);
>  
> -	WRITE_ONCE(*b, 1);
> -	GUEST_SYNC(true);
> -	WRITE_ONCE(*b, 1);
> -	GUEST_SYNC(true);
> -	GUEST_SYNC(false);
> +	READ_ONCE(*(u64 *)page0);
> +	GUEST_SYNC(page0 | TEST_SYNC_READ_FAULT);
> +	WRITE_ONCE(*(u64 *)page0, 1);
> +	GUEST_SYNC(page0 | TEST_SYNC_WRITE_FAULT);
> +	READ_ONCE(*(u64 *)page0);
> +	GUEST_SYNC(page0 | TEST_SYNC_NO_FAULT);
> +
> +	WRITE_ONCE(*(u64 *)page1, 1);
> +	GUEST_SYNC(page1 | TEST_SYNC_WRITE_FAULT);
> +	WRITE_ONCE(*(u64 *)page1, 1);
> +	GUEST_SYNC(page1 | TEST_SYNC_WRITE_FAULT);
> +	READ_ONCE(*(u64 *)page1);
> +	GUEST_SYNC(page1 | TEST_SYNC_NO_FAULT);
> +	GUEST_SYNC(page1 | TEST_SYNC_NO_FAULT);

Extra GUEST_SYNC()?

>  
>  	/* Exit to L1 and never come back.  */
>  	vmcall();

