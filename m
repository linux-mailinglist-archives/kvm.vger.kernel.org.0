Return-Path: <kvm+bounces-6426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A63831DB7
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 17:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7F251F25A73
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 16:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5004B2C688;
	Thu, 18 Jan 2024 16:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HkIoxE7D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D22C194;
	Thu, 18 Jan 2024 16:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705596110; cv=none; b=eKvHW9JQ315kdNS4WjqKNJN0dN/Hd1RlkN8EVp+oceQ4MkEeMhz8Tl+UxeZyERnAkucpgxVAxocTx+X2pnrBGUEq0hJMOQV/eK7YIIDHor5h7viG8d6dp8F3bcqXdXeRrVq1JR6PwoDyybUWwIaEYfFKu2qBaci3sJGIn9DbCIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705596110; c=relaxed/simple;
	bh=8ZoeWyhYJAXsI3uEm8LqP0ONHfsUFdg+kjcwc5JHX1o=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To; b=BzbMUSsO9Kreovj1QBtJC+rwbJeABQJqNDCvDpzYDw5/7S/0HNgoZcEbvQqPGXC8rQjOcQPg/qquYXrbK6ILkhIMtXh7c4Ut3Q5uu27F2gYsZUJKCK2vIdmM99yOvuAIgr39JjKm7ryA3ug3KT30RmbTf+5iksUJQaRlz9CNRmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HkIoxE7D; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705596108; x=1737132108;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8ZoeWyhYJAXsI3uEm8LqP0ONHfsUFdg+kjcwc5JHX1o=;
  b=HkIoxE7DPgJUQqsN5lLnsT3OBRDBUETfzqVHTa4SYWkLTwXJsAq/Ot8P
   7FeQDCEc0XdRPwUXE7vum6wQODM9/+fEwMpjUBat7+ufKuLB8NErVbNkM
   RApnaL9CsyvYl9YCK12qTKh7i1VWlflSL9GTAR8L4Pb7HqE0h6C48cFIF
   GXKzXl2+l8B1BXSmADT7NXOA9QdGz4rEbweGHdOGN5urxG0j78VU9PLyZ
   Lmg7tx1Sp5Ndr79EKu4GmTBSr8T5wJRs7Ncr2d4W3oHtWYatoRqYZMrnc
   5CNrXXaDaVCKO0wM/lG4Vw/7fEjyCBpWNSrzNGOghqiLIqI+bz3eVJ0m2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="399376808"
X-IronPort-AV: E=Sophos;i="6.05,203,1701158400"; 
   d="scan'208";a="399376808"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 08:41:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,203,1701158400"; 
   d="scan'208";a="405234"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 18 Jan 2024 08:41:47 -0800
Date: Fri, 19 Jan 2024 00:38:36 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Message-ID: <ZalUDLVJSVN/rEf2@yilunxu-OptiPlex-7050>
References: <20240110012045.505046-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110012045.505046-1-seanjc@google.com>

On Tue, Jan 09, 2024 at 05:20:45PM -0800, Sean Christopherson wrote:
> Retry page faults without acquiring mmu_lock if the resolved gfn is covered
> by an active invalidation.  Contending for mmu_lock is especially
> problematic on preemptible kernels as the mmu_notifier invalidation task
> will yield mmu_lock (see rwlock_needbreak()), delay the in-progress

Is it possible fault-in task avoids contending mmu_lock by using _trylock()?
Like:

	while (!read_trylock(&vcpu->kvm->mmu_lock))
		cpu_relax();

	if (is_page_fault_stale(vcpu, fault))
		goto out_unlock;
  
	r = kvm_tdp_mmu_map(vcpu, fault);

out_unlock:
	read_unlock(&vcpu->kvm->mmu_lock)

> invalidation, and ultimately increase the latency of resolving the page
> fault.  And in the worst case scenario, yielding will be accompanied by a
> remote TLB flush, e.g. if the invalidation covers a large range of memory
> and vCPUs are accessing addresses that were already zapped.

This case covers all usage of mmu_invalidate_retry_gfn(), is it? Should
we also consider vmx_set_apic_access_page_addr()?

Thanks,
Yilun

