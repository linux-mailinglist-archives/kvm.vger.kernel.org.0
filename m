Return-Path: <kvm+bounces-15298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DA78AB046
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48D2A1C232A8
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94A712EBF1;
	Fri, 19 Apr 2024 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EwmB4/k6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97328565D;
	Fri, 19 Apr 2024 14:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535483; cv=none; b=Si/usyfdqHDlEduA8Wizt9v41EuBUrtQFOTnzDIFRQgs9ygbBeYl95NDTRTQU7R0HNsyiGSUmoGpSpMUyUofPUj5YJ5svcLPtnvJX5h8vl4QHKSbVhpTdwYm3brg5kQButWrzzLx2uoHc41cvV+Vy1SPqR16Om/nafcb8WKqgzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535483; c=relaxed/simple;
	bh=SgZXbn4MwMQF10lT0Yvq+oGrrq1rWIvdfQSZtc0tjqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CSrV6u4noFlCqvCHXFyYUF8nzi3XRj2nKyJ2MiPWCtwTutjPLUWGJ+7OF6X51GNPqSzzbNuom6hSdq2pKLCQLhlXkkcVR5umLFjjk7RH3kpOBosSLSdkIQD1DEzPySskaIzV31BMpdpY5YJMiTW0U/+zj8vkffuwSGYbBzkqMXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EwmB4/k6; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713535478; x=1745071478;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SgZXbn4MwMQF10lT0Yvq+oGrrq1rWIvdfQSZtc0tjqI=;
  b=EwmB4/k6nf9jfLquvd/U4CTBz8peCxQdaLiq71ZGMAXKOrQ8Zpr8oOYK
   YnyjASo/nLYfQbkI2PoNhx2Z4eMYdQnTpYTiOt5TpWtJtMvjIY7zRcn9+
   SeZ9LWJi67Z15/4D2FzypKGP5Y29asqE3lZH3HKyLdXJ8TONxxWIuzKo4
   qBAVEDLJ1Hl/ZzngH1CaTMPtcugD6ExhQE34onEsCsbAU/slU2DNVbobi
   v9SdS1WVtKt7ltv6lvya790391kpqQULKuN7qoNh/6yaOXuzCH/DWnUuh
   JMogof9HRUWq6OMfOAZHaVpryPTjA49kT/g1VPb8+7EIsev0T+gWU2Pwh
   g==;
X-CSE-ConnectionGUID: v61bHeqrRmqWZZ1w65UuhA==
X-CSE-MsgGUID: VlCWa3s/QZ65VQQU/qNvOg==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="9309769"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="9309769"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 07:04:32 -0700
X-CSE-ConnectionGUID: 3BLZNZlZRG6JmQTmmH5cxA==
X-CSE-MsgGUID: UT30vGDRTwS095dbaZMiMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54258746"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 19 Apr 2024 07:04:26 -0700
Date: Fri, 19 Apr 2024 21:59:11 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 2/7] KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate
 guest memory
Message-ID: <ZiJ4r70tsphVk45Q@yilunxu-OptiPlex-7050>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
 <20240417153450.3608097-3-pbonzini@redhat.com>
 <20240417193625.GJ3039520@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417193625.GJ3039520@ls.amr.corp.intel.com>

> > +#ifdef CONFIG_KVM_GENERIC_MAP_MEMORY
> > +	case KVM_CAP_MAP_MEMORY:
> > +		if (!kvm)
> > +			return 1;
> > +		/* Leave per-VM implementation to kvm_vm_ioctl_check_extension().  */
> 
> nitpick:
>                 fallthough;

A little tricky. 'break;' should be more straightforward.  

Thanks,
Yilun

> 
> >  #endif
> >  	default:
> >  		break;
> > -- 
> > 2.43.0
> > 
> > 
> > 
> 
> -- 
> Isaku Yamahata <isaku.yamahata@intel.com>
> 

