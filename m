Return-Path: <kvm+bounces-25671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4B696854D
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 12:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69B7B284162
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9278B1D54D5;
	Mon,  2 Sep 2024 10:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nFSu85Kq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339FE1865F7;
	Mon,  2 Sep 2024 10:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725274225; cv=none; b=uRAozlAe7Mv93/wrd11W86mr/gcp/zmV8mO+rKYcvt/6qOtOJL2mv+33vkvj46emvDCQ+ND3JH294x8AYLO4u/28TmZExBm85J2Wem07dfURO7nDMq086MzyBtyU0YUpELqj3DR14rJzkp4gJRX+pMM3lehgnrM2qUyM4jUQ9Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725274225; c=relaxed/simple;
	bh=AEaIXiu53hxryNpNO8eDMjDqmM+l9TZPumbBomopLk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9tGhgv5CRjEim4JqUq6ZZeTm5HGQt5YOZm+mgfeeNeYhkTPT8x5o8RB3Z2z4/tqXFLgDsTXwwCy1TT03X5CkqkingywfNR82KK20C1Z5K+gaGKqwOfqPcf/tJnXYUBpA1TJSlphYEBqNOwITqhq7zIkm8SsikRcSVOjVx1ZBfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nFSu85Kq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725274224; x=1756810224;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AEaIXiu53hxryNpNO8eDMjDqmM+l9TZPumbBomopLk4=;
  b=nFSu85Kq5b8N2CwmJXDz+Gidhp9A937NMEDjboQH8+G42KCv7YsvB1ni
   2cid50T0SmuGQ/biCAqwYR1Zg/pbXwFaFVS9isR+n5Gm054/6EQxzVvIM
   zRP94xfT1PO9FeHteKG7MmcNzfTq0GiSeHP42TaatMVwU//Jlvh/zFp4f
   n5Z43Np8YrxfjFWa3vI2pkjNpiHBBemFx/z102wVQZO32FsdGZkCSwmO+
   ulM4o7k3OpH2g7tsc0Kic1z9A3OrGa/0ZnV2Ni64Xa3sWaOs8glMGWHZC
   2AOfnGVijl3DhSiZVwYgf5BCfdspzZHXuREmWsT33TXvVsf9qx50SWjL2
   g==;
X-CSE-ConnectionGUID: kGim64ozTLqoTWql9KTyqw==
X-CSE-MsgGUID: ETg3L/PQTvGQ40mbgZCYbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="46362443"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="46362443"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:50:23 -0700
X-CSE-ConnectionGUID: 0l1TgIuRSeKYHB5edMecew==
X-CSE-MsgGUID: dXk8sIACTpeGnuPOVAyt0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="68963077"
Received: from lbogdanm-mobl3.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.223])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:50:19 -0700
Date: Mon, 2 Sep 2024 13:50:14 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 17/25] KVM: TDX: create/free TDX vcpu structure
Message-ID: <ZtWYZo9xWibJWgxU@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-18-rick.p.edgecombe@intel.com>
 <c03df364-4cce-4c7e-b9db-191f7b10ca70@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c03df364-4cce-4c7e-b9db-191f7b10ca70@linux.intel.com>

On Tue, Aug 13, 2024 at 05:15:28PM +0800, Binbin Wu wrote:
> On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > +{
> > +
> > +	/* Ignore INIT silently because TDX doesn't support INIT event. */
> > +	if (init_event)
> > +		return;
> > +
> > +	/* This is stub for now. More logic will come here. */
> > +}
> > +
> For TDX, it actually doesn't do any thing meaningful in vcpu reset.
> Maybe we can drop the helper and move the comments to vt_vcpu_reset()?

Good point, will do a patch to drop tdx_vcpu_reset().

> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -488,6 +488,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >   	kvm_recalculate_apic_map(vcpu->kvm);
> >   	return 0;
> >   }
> > +EXPORT_SYMBOL_GPL(kvm_set_apic_base);
> >   /*
> >    * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> > @@ -12630,6 +12631,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> >   {
> >   	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
> >   }
> > +EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
> >   bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
> >   {
> 
> kvm_set_apic_base() and kvm_vcpu_is_reset_bsp() is not used in
> this patch. The symbol export should move to the next patch, which
> uses them.

Yes that should have been in the following patch.

Regards,

Tony


