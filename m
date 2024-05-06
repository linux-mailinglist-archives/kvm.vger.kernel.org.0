Return-Path: <kvm+bounces-16765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 487228BD51B
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 21:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD33C1F229E2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 19:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12D0158DC4;
	Mon,  6 May 2024 19:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a/1N7Xso"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A3B1591FE;
	Mon,  6 May 2024 19:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715022171; cv=none; b=ri2k3IfmYtMC86JWf+YdPzvibqPMrN91AMPPO0t0kZ8wvONtUg0HIuErUhgHzkJl+aSszs6HYasB5QHdZ4n+sFs+Fk7Ga3a5osxJv1TDylZoTxgLtzgKoJrGJmeEnUn1wG16ajsTFXsJGoNbpV5gRBI1hs98SEmXb1CzxDOCYv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715022171; c=relaxed/simple;
	bh=BEbmvb6aYA7DzRxFBtCtSj4M79Xuejibzf5RCRPECbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgCPhr8Rt8sDrr+SXM7f24wBisluhuOlNcfS0xCwRW6m0EM0IJ5OjgJEgTFE9l58FlLhqiccdwtbQ0w+hdy0WQUPpOTYwe3Cw0tZzmrRCi+RXefXk0+cJsY/HRIqsimuS7aWVxs30qnU0HkaYrQmg2nwctUdExmCTKI6YyfHKzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a/1N7Xso; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715022170; x=1746558170;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BEbmvb6aYA7DzRxFBtCtSj4M79Xuejibzf5RCRPECbo=;
  b=a/1N7XsokAYgq4tEWr1wNvt4j8hTUor6a/17PT/MjHl5sV7RYJDK0zt2
   845oYTmt34vNEyNfzuNXBc6wqCptuovxtrC2cbO1y7rj7pLdya1jIFWaL
   4NCT+yTOLygPQGVQm4IomkkilBvH5wDNT4q7ByKGOr7zH0w4G9+HKmLkU
   OsyXpnH/TJTGNVuKLiA9iM1OedTVtAom4rMtJTpa3ccs8pE4GuMFpVuDO
   xIucVXExJkyLMWHzFY/JG1j9QidP9hkZlqGLIaugz/j2DAg76hCDyDgtm
   TazwxYLZMOCkVTPOmmdm/J0ryNvAGrK7VKlj8o8qWgSNrCxkWkpswzIso
   w==;
X-CSE-ConnectionGUID: c1Nl7ObhS5iHHz5H0Dumxw==
X-CSE-MsgGUID: 1tL9cu9LT1SKXs6kH1dVDg==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10617356"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="10617356"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 12:02:49 -0700
X-CSE-ConnectionGUID: HsaFZqblTyGi7e+9BeTlOg==
X-CSE-MsgGUID: WEIRVyPaQjG11mTTRTRuMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="32731407"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 12:02:48 -0700
Date: Mon, 6 May 2024 12:02:48 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical
 processor
Message-ID: <20240506190248.GD13783@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
 <01988152-c87b-4814-adc5-618e31fc035e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <01988152-c87b-4814-adc5-618e31fc035e@linux.intel.com>

On Tue, Apr 23, 2024 at 08:13:25PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> On 4/13/2024 12:15 AM, Reinette Chatre wrote:
> > Hi Isaku,
> > 
> > On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > ...
> > 
> > > @@ -218,6 +257,87 @@ static void tdx_reclaim_control_page(unsigned long td_page_pa)
> > >   	free_page((unsigned long)__va(td_page_pa));
> > >   }
> > > +struct tdx_flush_vp_arg {
> > > +	struct kvm_vcpu *vcpu;
> > > +	u64 err;
> > > +};
> > > +
> > > +static void tdx_flush_vp(void *arg_)
> > > +{
> > > +	struct tdx_flush_vp_arg *arg = arg_;
> > > +	struct kvm_vcpu *vcpu = arg->vcpu;
> > > +	u64 err;
> > > +
> > > +	arg->err = 0;
> > > +	lockdep_assert_irqs_disabled();
> > > +
> > > +	/* Task migration can race with CPU offlining. */
> > > +	if (unlikely(vcpu->cpu != raw_smp_processor_id()))
> > > +		return;
> > > +
> > > +	/*
> > > +	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
> > > +	 * list tracking still needs to be updated so that it's correct if/when
> > > +	 * the vCPU does get initialized.
> > > +	 */
> > > +	if (is_td_vcpu_created(to_tdx(vcpu))) {
> > > +		/*
> > > +		 * No need to retry.  TDX Resources needed for TDH.VP.FLUSH are,
> > > +		 * TDVPR as exclusive, TDR as shared, and TDCS as shared.  This
> > > +		 * vp flush function is called when destructing vcpu/TD or vcpu
> > > +		 * migration.  No other thread uses TDVPR in those cases.
> > > +		 */
> Is it possible that other thread uses TDR or TDCS as exclusive?

Exclusive lock is taken only when the guest creation or destruction.
TDH.MNG.{ADDCX, CREATE, INIT, KEY.CONFIG, KEY.FREEID, FLUSHDONE}()
TDH.MR.{EXTEND, FINALIZE}()
TDH.MEM.PAGE.ADD()
TDH.VP.{CREATE, INIT, ADDCX, FLUSH}()

During run time (while vcpu can run), they are locked as shared.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

