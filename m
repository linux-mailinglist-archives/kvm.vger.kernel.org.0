Return-Path: <kvm+bounces-15173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D668AA4B5
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 23:27:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A330C1F21663
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DACE194C9C;
	Thu, 18 Apr 2024 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GC6ggaqT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118C2181BB4;
	Thu, 18 Apr 2024 21:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713475639; cv=none; b=RyJQ/YugKE2VhHvObek3q1KWHRo2n3VQRMZhYGgNYPL0De9eiVv7rrHr6azp3Y3en/WPYv67R5v6GHFoDI85nLdpuzbzm3xK2dXLfU8x6fWcEokYzZ6kN0sjAyKV33uNqhJvKiHxg0FRC/cLIBM2f/vlLLDXURlec8FhJDBQW+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713475639; c=relaxed/simple;
	bh=NBsk+u3d4f/5vtkH6CguOEufAO4VLq8P+Yf06DWuYZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eeBouejsvQ4XUzjyz6ThKzIR7YjevDn8htBGzGTaSffsM4pSMXCnI5mKiJcgqNBIu+q2CDMot8W/9b1KKRvyozPeliNfbyzd+RePCGDfriih8/SrxMJ5vKTx3fRxuLcw5ZR9HpdFMKWJIOLN6ZiGyzUHQL10VVyd2sqTXDW1gZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GC6ggaqT; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713475638; x=1745011638;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NBsk+u3d4f/5vtkH6CguOEufAO4VLq8P+Yf06DWuYZg=;
  b=GC6ggaqTZJVX1F4yxSsWtwpSTNCY/wzVzh1M2KJ/pWCarlTPa8OhcUTj
   dVlrMjdL3gtCiAEKbxqVwmz1GuLm+iejGdfcTOLbFC0eJeNxJYNsJY2OF
   nz3N0PgFZ90BH1hBaYA271yaOa5KW1/8F0HVg1hbXYjkdBoFW32ZWGRck
   wocuUgEmoLyb6iSG3xbON9pwdJTlI6mOWimQJv5jhmJsevb7vlAWffmPn
   VTkniHAuoyrmlozx7RnDukvF72cB1YmgTGD/VHqr1sKysw1gMZuzOCMX3
   BNzd74VMAUjbv+Ll1/3HKGGZYJkUqK6A4mIAzzhpZAwI6C71yQJGVt7J1
   w==;
X-CSE-ConnectionGUID: g3wwaYbJSF6uZEUJb+f51Q==
X-CSE-MsgGUID: VK0Zv7ooT2e6D3FZp0tG3g==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8926278"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="8926278"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 14:27:17 -0700
X-CSE-ConnectionGUID: K2w5zN26Rmy6K+FOP1BVMg==
X-CSE-MsgGUID: UK/BNNSgTYGeix4U7RcxEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="46409793"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 14:27:17 -0700
Date: Thu, 18 Apr 2024 14:27:16 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 111/130] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Message-ID: <20240418212716.GC3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
 <cfbe7d5a-e045-4254-8a8c-c0a8199db4b7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cfbe7d5a-e045-4254-8a8c-c0a8199db4b7@linux.intel.com>

On Thu, Apr 18, 2024 at 09:54:39PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Implements set_msr/get_msr/has_emulated_msr methods for TDX to handle
> > hypercall from guest TD for paravirtualized rdmsr and wrmsr.  The TDX
> > module virtualizes MSRs.  For some MSRs, it injects #VE to the guest TD
> > upon RDMSR or WRMSR.  The exact list of such MSRs are defined in the spec.
> > 
> > Upon #VE, the guest TD may execute hypercalls,
> > TDG.VP.VMCALL<INSTRUCTION.RDMSR> and TDG.VP.VMCALL<INSTRUCTION.WRMSR>,
> > which are defined in GHCI (Guest-Host Communication Interface) so that the
> > host VMM (e.g. KVM) can virtualize the MSRs.
> > 
> > There are three classes of MSRs virtualization.
> > - non-configurable: TDX module directly virtualizes it. VMM can't
> >    configure. the value set by KVM_SET_MSR_INDEX_LIST is ignored.
> 
> There is no KVM_SET_MSR_INDEX_LIST in current kvm code.
> Do you mean KVM_SET_MSRS?

Yes, will fix it. Thank you for catching it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

