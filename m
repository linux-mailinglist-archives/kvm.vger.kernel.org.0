Return-Path: <kvm+bounces-9091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF6C85A547
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 15:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04362281280
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 14:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975133715E;
	Mon, 19 Feb 2024 14:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JKdrVC//"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F86036B09;
	Mon, 19 Feb 2024 14:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708351384; cv=none; b=Xxs8d3O0oz+HQ+C0Ja+lAe5M/+qkLQ6VaDqKybfrfQI4xAivWGN0btMjteH95kW3MBYzkjXAkWsPlZ29MlnlBgoHCBxYu2IPqcPdFDEvRcX+O/Q5nakpDnUJzx4r+Jyqq5PWgvoQ2QPzijjwY7VAbaticHvcuj5NMqqrZNfe/lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708351384; c=relaxed/simple;
	bh=wHheWqOg2lnrXFJQJwK4hCwjRP1jqy2jGPo/csvfdrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L75m7U5+OT8vGH7SmQcD2cxXoyOmeAIpY8E7zSybXOWCF4wkW0203m7M6eNAfaEGAkGKLKNOCdIJ6fmHLMctOIKKHbcgcvMT3YiaoL4AnPNmRgcIZrA8FmAozIlI5hCHst7i3YJz0M3A5N/krJhgfW63nZhUfFzLBgvS91vw2oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JKdrVC//; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708351383; x=1739887383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wHheWqOg2lnrXFJQJwK4hCwjRP1jqy2jGPo/csvfdrM=;
  b=JKdrVC//GNaIbK1i5uTYZQ4qMuusEE/T/srpkOcRtEzuarH2BAft74Q5
   3i2Fvw6XrD4S/UR5A4uYJIgyrb9B0hTUv6VwydVBli3r1XvGceuA+j+zl
   OzGLJqniqIm+1SNIAm1dPNzO4NpU1Z1xZ+wZ5xOS2pNKvM7XRcpmIQwKU
   DexXAORBnOlw/A13FmZrcRk3pSkEjY9b2jl4aev2aks5Yh3GceXuGB/nI
   PVcUFeE+D2SqT1bgh8eIwfvO6J6EK8zOQj2w2Uxc1LtwnkYHKqOoxuWeo
   t3DVVmwMTJNNrDB8CK1yURIF0W+FSCy6eb3az0RStMC0tbTPQXtuOddcC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2294745"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2294745"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 06:03:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="4407006"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 19 Feb 2024 06:03:00 -0800
Date: Mon, 19 Feb 2024 21:59:08 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
Message-ID: <ZdNerMaewrcrwBlL@yilunxu-OptiPlex-7050>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110011533.503302-2-seanjc@google.com>

>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> @@ -114,7 +132,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  #else
>  		if (cancel_work_sync(&work->work)) {
>  			mmput(work->mm);
> -			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
>  			kmem_cache_free(async_pf_cache, work);
>  		}
>  #endif
> @@ -126,7 +143,18 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  			list_first_entry(&vcpu->async_pf.done,
>  					 typeof(*work), link);
>  		list_del(&work->link);
> -		kmem_cache_free(async_pf_cache, work);
> +
> +		spin_unlock(&vcpu->async_pf.lock);
> +
> +		/*
> +		 * The async #PF is "done", but KVM must wait for the work item
> +		 * itself, i.e. async_pf_execute(), to run to completion.  If
> +		 * KVM is a module, KVM must ensure *no* code owned by the KVM
> +		 * (the module) can be run after the last call to module_put(),
> +		 * i.e. after the last reference to the last vCPU's file is put.
> +		 */
> +		kvm_flush_and_free_async_pf_work(work);

I have a new concern when I re-visit this patchset.

Form kvm_check_async_pf_completion(), I see async_pf.queue is always a
superset of async_pf.done (except wake-all work, which is not within
concern).  And done work would be skipped from sync (cancel_work_sync()) by:

                if (!work->vcpu)
                        continue;

But now with this patch we also sync done works, how about we just sync all
queued work instead.

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index e033c79d528e..2268f16a36c2 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -71,7 +71,6 @@ static void async_pf_execute(struct work_struct *work)
        spin_lock(&vcpu->async_pf.lock);
        first = list_empty(&vcpu->async_pf.done);
        list_add_tail(&apf->link, &vcpu->async_pf.done);
-       apf->vcpu = NULL;
        spin_unlock(&vcpu->async_pf.lock);

        if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC) && first)
@@ -101,13 +100,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
                                         typeof(*work), queue);
                list_del(&work->queue);

-               /*
-                * We know it's present in vcpu->async_pf.done, do
-                * nothing here.
-                */
-               if (!work->vcpu)
-                       continue;
-
                spin_unlock(&vcpu->async_pf.lock);
 #ifdef CONFIG_KVM_ASYNC_PF_SYNC
                flush_work(&work->work);


This way we don't have to sync twice for the same purpose, also we could
avoid reusing work->vcpu as a "done" flag which confused me a bit.

Thanks,
Yilun

> +		spin_lock(&vcpu->async_pf.lock);
>  	}
>  	spin_unlock(&vcpu->async_pf.lock);
>  

