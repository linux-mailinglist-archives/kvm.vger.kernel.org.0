Return-Path: <kvm+bounces-13348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F7D894C37
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 09:09:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACE0A1C21FA0
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 07:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12253A1DD;
	Tue,  2 Apr 2024 07:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GaHxsiTK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC512C6B3;
	Tue,  2 Apr 2024 07:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712041765; cv=none; b=NoRaBb1FzBLmf5pw5ie9OIi/kEbHgUwhJE92qcWdBeA8o6yAeZifpQxOVoK5nYJszbQd0w+DiZtyuMk1HdrUmmPfQpDfa1B++7+Nvfqtxt3hi/bkEOrTClaDzbexkEVx3i3xhDCUPxd4+PwcW2W67EvfGBubjIYUu3U2Rizn+hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712041765; c=relaxed/simple;
	bh=cIv6Tl+nzFjXY1TztO8FqRhEBSuJAbM93JA4OC3kQNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekXwNW+jMHWqoqQjWU0vZKTfTAmFKDT8XOSuHlJSowHtmXXDymepXRiAdWNaaBb77nCszPD651BDaHBk0XDKsNFn+7DllEeR5uXEKbtoY/HL4hH+AqDBh8L68wBHkXfoDqUaCrQG0lpdC+uJ+vlJbXCEBLZUqwb3eD9nSpzsWyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GaHxsiTK; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712041763; x=1743577763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cIv6Tl+nzFjXY1TztO8FqRhEBSuJAbM93JA4OC3kQNg=;
  b=GaHxsiTKll8PSozlewdyvCVNSP0XgL7OyOIyuUPkqviM4dwLt9I++cl1
   Dn3rHI9BwNQldOBtmtKHG5QgrOib+Iz56ox5MDspswqzk0vaKdzcJB7bP
   +QmgKzq773CGGyyJ8BbxsrhCK4jWYaKO7Jiv52kuSuO4yPxQITdUHi2Tx
   vMYqKm4+bjVf/PU70yhT/VZQ94fpXnCKth8bVrhI1xEObWwWTGCKUjUh2
   b0qicwQh2wLlViQGsRxGWtCdi+MGJF3W1eGxen/eDtS60vObzUpVIbxM4
   1ad0rTwdtCP0nq1oi5vbQllAP44CEXLr2rwXws7/ytiD5CKGKVKRNhP1h
   A==;
X-CSE-ConnectionGUID: TTNmxK9nSI26C4yGrC0pfQ==
X-CSE-MsgGUID: XP79r+snSde/fhmXGLPGbQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7061621"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="7061621"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 00:09:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="18059189"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 00:09:22 -0700
Date: Tue, 2 Apr 2024 00:09:21 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 094/130] KVM: TDX: Implement methods to inject NMI
Message-ID: <20240402070921.GZ2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a7ce6023eb8dd824e61023a95475629bd7ae2278.1708933498.git.isaku.yamahata@intel.com>
 <ZgYjOfkH2p/fSXuw@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgYjOfkH2p/fSXuw@chao-email>

On Fri, Mar 29, 2024 at 10:11:05AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> >+{
> >+	if (is_td_vcpu(vcpu))
> >+		return;
> >+
> >+	vmx_set_nmi_mask(vcpu, masked);
> >+}
> >+
> >+static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
> >+{
> >+	/* Refer the comment in vt_get_nmi_mask(). */
> >+	if (is_td_vcpu(vcpu))
> >+		return;
> >+
> >+	vmx_enable_nmi_window(vcpu);
> >+}
> 
> The two actually request something to do done for the TD. But we make them nop
> as TDX module doesn't support VMM to configure nmi mask and nmi window. Do you
> think they are worth a WARN_ON_ONCE()? or adding WARN_ON_ONCE() requires a lot
> of code factoring in KVM's NMI injection logics?

Because user space can reach those hooks with KVM_SET_VCPU_EVENTS, we shouldn't
add WARN_ON_ONCE().  There are two choices.  Ignore the request (the current
choice) or return error for unsupported request.

It's troublesome to allow error for them because we have to fix up the caller
up to the user space.  The user space may abort on such error without fix.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

