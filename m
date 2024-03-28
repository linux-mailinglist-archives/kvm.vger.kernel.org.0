Return-Path: <kvm+bounces-13037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6D2890C2B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 22:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9832291BA8
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 21:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209F313AA23;
	Thu, 28 Mar 2024 21:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SuEDEiXY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746DD2C6B1;
	Thu, 28 Mar 2024 21:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711659825; cv=none; b=R7X7a147nRAAwf3UXHNtdHh7X+3gUWsrz4LGC44YCsqghijXCd+DTao4AoiU4gp/M2xoamBx8HkkMRi7MwdBXxR9RpM0NpNzMDpRYePrnuoObD98wdGw+3WNPJP7Otp4L/ahW2ABK42d0FI3/KknaAJClvafauhm66MOnEFD/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711659825; c=relaxed/simple;
	bh=qDO/Lsc7ctYZ55C9yGW6FnXjoaC1dk7OvyZr6dxE3pE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WU0/u/A02wMTX1pLhb8IhHtQ3eYtxqiWweU9xGq4WHsxohxsucseutqMwsh7em31xLlLJ63OChA1+HYLkdRzhhB8J/3fYben/jUSjSLy/YufDIFwxTID1RB03dk6eiX4+FBsqOjN3I3PHcUQ6fgP9wIaVocDhu7/VdRb62R/C3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SuEDEiXY; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711659823; x=1743195823;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qDO/Lsc7ctYZ55C9yGW6FnXjoaC1dk7OvyZr6dxE3pE=;
  b=SuEDEiXYimNwEpm6gO+1dKWcVmmfFlB/x7D+ULQBt+JLJqoZRh8V3tx/
   n2WIW+9nShvdBxsFnI9gIvmh3JyMvSNnBYYl/tDP6KvKnrYvgLMi5E6VO
   0QXqywr5heo51fjkyi/lDaQny+hgX8Nwp6w0b7eqDvG0IGhu6YVhgyGfa
   9FQ9z2rc+2bUDSXZ4cjV//8O97xnTonODUi3OUMCNzVlwPGbrnWla+DOL
   tRXWh4b8Wx3iAaN5pGoEZ5lw4On1YtXZwPqyc0Ik7aeMozpjbBLG6VH/a
   AZzT5W3p2OABV8weyb3VS6N0PE7KEG9uxPpj/tUSVQNxlf5TE2q1EGs2c
   w==;
X-CSE-ConnectionGUID: F2lfdrbCRWO0Rttqxy0xlA==
X-CSE-MsgGUID: /nwJawbqRoKRlsgb+U+szw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6955395"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6955395"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 14:03:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="21281747"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 14:03:42 -0700
Date: Thu, 28 Mar 2024 14:03:42 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 069/130] KVM: TDX: Require TDP MMU and mmio caching
 for TDX
Message-ID: <20240328210342.GR2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f6a80dd212e8c3fd14b40049eed33187008cf35a.1708933498.git.isaku.yamahata@intel.com>
 <94fb2094-d8ee-4bcc-a65d-489dc777b024@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <94fb2094-d8ee-4bcc-a65d-489dc777b024@linux.intel.com>

On Thu, Mar 28, 2024 at 01:24:27PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
> > support for TDX isn't implemented.  TDX requires KVM mmio caching.
> 
> Can you add some description about why TDX requires mmio caching in the
> changelog?

Sure, will update the commit log.

As the TDX guest is protected, the guest has to issue TDG.VP.VMCALL<MMIO> on
VE.  The VMM has to setup Shared-EPT entry to inject VE by setting the entry
value with VE suppress bit cleared.

KVM mmio caching is a feature to set the EPT entry to special value for MMIO GFN
instead of the default value with suppress VE bit set.  So TDX KVM wants to
utilize it.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

