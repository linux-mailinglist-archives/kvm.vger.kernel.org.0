Return-Path: <kvm+bounces-12062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD52D87F42D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DFD5B21A67
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52125FB95;
	Mon, 18 Mar 2024 23:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+757ZKW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE84E5FB81;
	Mon, 18 Mar 2024 23:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710805214; cv=none; b=s0fUsFNRItF3WQ6RaLgaRrnAbUCjq8d0Y7ZDxqcitf2eqFMcrP1Nahwx+bsxqBQhOHTEgEr8fym3EsYDyyq6BnqtvElXipJJ7Ict6QOG9YQejJ2Sh/VGcfUI4WWIdfODOET+IGv3KltOVIJr51aje/Hu8stxn+8iqKxbU26h7L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710805214; c=relaxed/simple;
	bh=oyx2Bz+RIgrwhRz3BjJO59HfmzWRjuo3TkptYTef3tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HILsfOtF/9SH5F94S7Mu+LXFxRz8dyjiQkeBtgfMqDl9pM1fZo84MOSG7XcsIsBQHGg435c4mSyIzK+WCN1gMZBBdeZk+HVf+Q3+2UWjAy4kbEZqZQK6wC9pIOLZPD2UCTSXOByObyUhwm6+nAnVAuprb4Q5v1LQn1hSjK5EmDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+757ZKW; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710805212; x=1742341212;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=oyx2Bz+RIgrwhRz3BjJO59HfmzWRjuo3TkptYTef3tM=;
  b=g+757ZKWW3lPOEh1an26YkdfpIhDsEm0d/jHfHG2QUFZ86kCWiqHIqiR
   be0f1u9LdovmjxtgmS9jbk6kHAxEZ0pVlEU3W2roYjhLw/gdJ4HkoB+WF
   qlLBSKP/PkzL8NToaoRN6OIdsFItE0kFhv1P0TjQbFjtze0HvCO0GreF3
   EELMD0tGKa5u9RkPhoaILdWxrYF1HB1Ro3MVgHdHdmoUFhYzv+J6gj22U
   V1NKPOwCaiQ+6MT2BmYrSKl1CusuWFdITZxZRjC8Y0vd5XVCZc65598Yu
   ghA6BV7NTgDNv/sTyisesItSZsmoupR87UMvEN/+pLJJJwWSs0QPVVzK8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5516812"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="5516812"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 16:40:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="18243367"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 16:40:11 -0700
Date: Mon, 18 Mar 2024 16:40:10 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Message-ID: <20240318234010.GD1645738@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
 <7a24c01a03f68a87b0bbfa82a5d6ccbf3cbd6f4b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a24c01a03f68a87b0bbfa82a5d6ccbf3cbd6f4b.camel@intel.com>

On Mon, Mar 18, 2024 at 09:01:05PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:26 -0800, isaku.yamahata@intel.com wrote:
> > +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> > +{
> > +       struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +
> > +       if (unlikely(!tdx->initialized))
> > +               return -EINVAL;
> > +       if (unlikely(vcpu->kvm->vm_bugged)) {
> > +               tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
> > +               return EXIT_FASTPATH_NONE;
> > +       }
> > +
> 
> Isaku, can you elaborate on why this needs special handling? There is a
> check in vcpu_enter_guest() like:
> 	if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
> 		r = -EIO;
> 		goto out;
> 	}
> 
> Instead it returns a SEAM error code for something actuated by KVM. But
> can it even be reached because of the other check? Not sure if there is
> a problem, just sticks out to me and wondering whats going on.

The original intention is to get out the inner loop.  As Sean pointed it out,
the current code does poor job to check error of
__seamcall_saved_ret(TDH_VP_ENTER).  So it fails to call KVM_BUG_ON() when it
returns unexcepted error.

The right fix is to properly check an error from TDH_VP_ENTER and call
KVM_BUG_ON().  Then the check you pointed out should go away.

  for // out loop
     if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
         for // inner loop
           vcpu_run()
           kvm_vcpu_exit_request(vcpu).

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

