Return-Path: <kvm+bounces-12540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A35988765A
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 02:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C7A71C229F0
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 01:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B9E138A;
	Sat, 23 Mar 2024 01:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fk3HzJj1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C7AA41;
	Sat, 23 Mar 2024 01:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711156947; cv=none; b=aZ19vGmiEGGVMWjv904mNIQwwT65JZJ+0SYVIHe4uiGUIFAcSboT+2qawCtiUeBjV22hcJBCX7si/4I9tHoeFmQHAznStCJqBMMsaO1C+fyrPHCiMhdN7bmScuUPY+MKfdQZjlKLy8SsEwow4ahvXOwVwSMrO+ZXmiRCMpufZ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711156947; c=relaxed/simple;
	bh=xFHg9bMUkkDlShpLt1baft+c1rw1IBRTJLqE+kKG1CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n66oexHWthhWY16wX07YNvS1u62+Qc+fwFShtn/32LUuxiwuMT5SMYgFrAkh2lthRz6bxP+Mxt+gL6eH/6bwvI9t2gfiJrHRPR0sNJU8f26C9lBiTd04IN/iQZpSnv4pZmQt3efj2rbw3ypVhlOLP9gctxQAi1m+BQ9EZKbDd24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fk3HzJj1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711156945; x=1742692945;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xFHg9bMUkkDlShpLt1baft+c1rw1IBRTJLqE+kKG1CY=;
  b=Fk3HzJj19djg4jeO0jf6h9NKN1YjXDO+TxrQkMaovurFKfUOmMEVzMh5
   O/LyhHD9bB/zZGL4tGpSe14MNrJJ5irK65xBv186uKZsTwC1XP/k5TUXx
   HspfJlPVKtChbbCahn39yjl8L5Ges7Zdo+wXIklWQL4arRo7lmCsZfYVO
   nd5rvwgsklDS+/9UUhkESus9+qn6blXh2Ph9+jMG1Rnb+QXIKMz2lwywl
   t2UXAKA2fDS6T4EM1NXfY2x2M6v3LE+Ud+lNjnj2HzIXE+K6QLY/m9et/
   9FNHUT4CfXjtJ4ewqvxItzyXG986Edrl4MJEPm/lHjUSwjOZ0EeqNlFLp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="23714724"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="23714724"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 18:22:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="19763481"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 18:22:24 -0700
Date: Fri, 22 Mar 2024 18:22:24 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20240323012224.GD2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <5f0c798cf242bafe9810556f711b703e9efec304.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5f0c798cf242bafe9810556f711b703e9efec304.camel@intel.com>

On Fri, Mar 22, 2024 at 11:20:01AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > +struct kvm_tdx_init_vm {
> > +	__u64 attributes;
> > +	__u64 mrconfigid[6];	/* sha384 digest */
> > +	__u64 mrowner[6];	/* sha384 digest */
> > +	__u64 mrownerconfig[6];	/* sha384 digest */
> > +	/*
> > +	 * For future extensibility to make sizeof(struct kvm_tdx_init_vm) = 8KB.
> > +	 * This should be enough given sizeof(TD_PARAMS) = 1024.
> > +	 * 8KB was chosen given because
> > +	 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(=256) = 8KB.
> > +	 */
> > +	__u64 reserved[1004];
> 
> This is insane.
> 
> You said you want to reserve 8K for CPUID entries, but how can these 1004 * 8
> bytes be used for CPUID entries since ...

I tried to overestimate it. It's too much, how about to make it
1024, reserved[109]?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

