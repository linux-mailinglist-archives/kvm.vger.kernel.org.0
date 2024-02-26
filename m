Return-Path: <kvm+bounces-9989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D26B18680E8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:25:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87D061F27654
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1083130ACD;
	Mon, 26 Feb 2024 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="THe8MFa/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1859412FF9C;
	Mon, 26 Feb 2024 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975482; cv=none; b=Il/1JbW3pQsjBV1APGvq5fGVcpQaJ1l3vrJ/AOoxnHB692VcY2dpLSesKNmqezYZSGA7GPBO5QDe+XpQ0F/bYSnjavlBIKUDtcPiZr2jtl68BAaGZ/O94GYJzDryjTVdG6ujpWx1dlo+LoXQbJNw1uQVNj53Xxy1+rmu9lYi1CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975482; c=relaxed/simple;
	bh=F+4pOhLAnZ9k3/aMMqmEmpPKb8aYtX5vG0b6hRqOXac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNoyzLNWc++rAEYOmGZ4jFDGknvxrA1zRLVzw6pJO75PR0omDG0heL+MUwiiH4FOU7aCyUg41iRxg7+SBphmHprpE5b2MEkwUlCKT0emOAWjGgQpksY/K+9iv+kWgVW17ri/vWu0gdMigumw+1oSGHHYNwb88ggl9FSe1wT9sOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=THe8MFa/; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708975481; x=1740511481;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F+4pOhLAnZ9k3/aMMqmEmpPKb8aYtX5vG0b6hRqOXac=;
  b=THe8MFa/n3CkN2TG52UyKs3ZM7fRsQou6ZozdMwzCzI3y0JglHGXQlyI
   JpYy+s+J11MG1GJgZkAnyK7x/ETF0gJd+nvPAJ4FlZyUEfyleaApJf40i
   tjbJwSFCbIMYeiCRXu9Jy5gkjwU8DE3unVVdzehz9xMFgDy6XSF4Rr8MF
   Aqt9MSWPoXb6C+INpQ74BapC1OkuFlmVLMSo8wPzafCOXFX+raR6ZMzQo
   VzKu92ZWJGKgwF6H1XRh0YuCBix/LGUNlPuVeu7oAbRyBZgsb/KuBWYMx
   bDMb7XqQ9uMwKQylUCcSagw2YT4A7ZFL4Vc5trh8q5GVe9wXyUyW4HGyQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3131478"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3131478"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:24:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="11399075"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:24:40 -0800
Date: Mon, 26 Feb 2024 11:24:39 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 071/121] KVM: TDX: restore user ret MSRs
Message-ID: <20240226192439.GR177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <65e96a61c497c78b41fa670e20fbeb3593f56bfe.1705965635.git.isaku.yamahata@intel.com>
 <3ac7bcfc-ea22-43b5-b8ba-d87830637d4d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3ac7bcfc-ea22-43b5-b8ba-d87830637d4d@linux.intel.com>

On Tue, Feb 20, 2024 at 05:14:02PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > @@ -1936,6 +1959,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> >   		return -EINVAL;
> >   	}
> > +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> > +		/*
> > +		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
> > +		 * before returning to user space.
> > +		 *
> > +		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
> > +		 * because the registration is done at vcpu runtime by
> > +		 * kvm_set_user_return_msr().
> 
> For tdx, it's done by kvm_user_return_update_cache(), right?

Right, fixed the comment.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

