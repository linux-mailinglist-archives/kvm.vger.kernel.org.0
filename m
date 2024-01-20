Return-Path: <kvm+bounces-6478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0621833542
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 16:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DE6D1F2246D
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 15:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9FF810940;
	Sat, 20 Jan 2024 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pu6jsdCh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B98FBEF;
	Sat, 20 Jan 2024 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705764447; cv=none; b=KrZ/l96b/j2PAtxWkFeUGrlZVc0uPTgFH1YuUxXFduq2itwOr8hREpIjIrVSptgpOiHFH9PtGYBt/fzqQ5xb6+cJxUsbHjgjoPMSyIupmfQ05Z71SwcQ4xcZvWOrQhE5ydOZ7xlfW8cV/LkWhbL8jsaoRvy1b9m3avj0thjcP+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705764447; c=relaxed/simple;
	bh=Ba1yk/kIdw9umf8+nzddJN9Ry40uVoGOLOWeX9s8zzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9Whr9NHFUE0iS+6rnrpPlAYq1K1YqDMeUEmEGYJDFp8y+YJHLdw1X7z4haFmeIgJkBCS7To7jBCeRj2qRsyfTpkfPynsWtedgEhdGGMfSEfXASZEOcWsVONqDYgXlTEym3JPzMugaCQDCRjudpT3k7fo2hBNcaMwLoT4IDh6V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pu6jsdCh; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705764445; x=1737300445;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ba1yk/kIdw9umf8+nzddJN9Ry40uVoGOLOWeX9s8zzs=;
  b=Pu6jsdChHaDcc2uCaFNHuR826hbrOlucsQyOTuVCs2yhWWeATpLKHIvv
   O8jQcD9Rn05IycMMregs8PJdBFF2d01hD6r9JImGAbzC7lWOsTeBqYBlY
   B4lbJay6ZkO8RMWV2tiPDXHJzREthHsX75uJyOECQuE5xw3Ewx1dHkSmu
   yJJeMKcz8kReZxHeeJNqkLGNmCPFL4IQtcIjWOIuG5Gw8EIRY0ZaUQgW9
   Fq4z7vT0QYqqaOuP6mD80Hml6poEsr1YzLk9SNJIYINMbYy6maz+O4swR
   wljulDF3f8ZSTs0lpYQ3ANpq/Dhuuh2N+0FodyXxgy9D8Lo8kE3X1ujqX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10959"; a="820806"
X-IronPort-AV: E=Sophos;i="6.05,208,1701158400"; 
   d="scan'208";a="820806"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2024 07:27:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10959"; a="928631890"
X-IronPort-AV: E=Sophos;i="6.05,208,1701158400"; 
   d="scan'208";a="928631890"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2024 07:27:23 -0800
Date: Sat, 20 Jan 2024 23:24:10 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 2/4] KVM: Put mm immediately after async #PF worker
 completes remote gup()
Message-ID: <ZavlmuHd37j1I2Ys@yilunxu-OptiPlex-7050>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110011533.503302-3-seanjc@google.com>

On Tue, Jan 09, 2024 at 05:15:31PM -0800, Sean Christopherson wrote:
> Put the async #PF worker's reference to the VM's address space as soon as
> the worker is done with the mm.  This will allow deferring getting a
> reference to the worker itself without having to track whether or not
> getting a reference succeeded.
> 
> Note, if the vCPU is still alive, there is no danger of the worker getting
> stuck with tearing down the host page tables, as userspace also holds a
> reference (obviously), i.e. there is no risk of delaying the page-present
> notification due to triggering the slow path in mmput().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xu Yilun <yilun.xu@intel.com>

> ---
>  virt/kvm/async_pf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 876927a558ad..d5dc50318aa6 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -64,6 +64,7 @@ static void async_pf_execute(struct work_struct *work)
>  	get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
>  	if (locked)
>  		mmap_read_unlock(mm);
> +	mmput(mm);
>  
>  	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
>  		kvm_arch_async_page_present(vcpu, apf);
> @@ -85,8 +86,6 @@ static void async_pf_execute(struct work_struct *work)
>  	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
>  
>  	__kvm_vcpu_wake_up(vcpu);
> -
> -	mmput(mm);
>  }
>  
>  static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
> -- 
> 2.43.0.472.g3155946c3a-goog
> 

