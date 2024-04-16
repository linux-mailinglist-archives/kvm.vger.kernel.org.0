Return-Path: <kvm+bounces-14796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 054738A7192
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:40:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BF901F22955
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CBB86255;
	Tue, 16 Apr 2024 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YxGhi2SS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0114310A22;
	Tue, 16 Apr 2024 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713285644; cv=none; b=eeH/xr7rJkY0zhCGGbuGIPoYWbhC/pNOOTDLXqzhFfVNEJxQISjsy1TCfqmiOwiwORLsuOrIufgC7eWC9uceIzPBlaKELds69XP4gawIa58UmrFrJAHY7tRzRt3rsP7U33CmEdzN0Ri9MmE+LQjgBZHNL5t6F5zH3O63EsJX0uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713285644; c=relaxed/simple;
	bh=c9rv2ENZUtW89CuH5U8B/1vQYk4rvmSwwB56Zf73aj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVYh8icJwtxDvfDZ1/B6LLHm5rg7CML4uH2WP1sRDvzjC9r+eYL3UTv98oWU/SW8Dva8+WHmMxeCeTGdngp6oO9AVbxTKNfaNyAQMwNt9r6AElcsoME23XuxfeFR2LIFjqgKEwrDWupW0XMF5Dfn1zpPMyGKaB1sJQeTTM2ZWn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YxGhi2SS; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713285643; x=1744821643;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c9rv2ENZUtW89CuH5U8B/1vQYk4rvmSwwB56Zf73aj0=;
  b=YxGhi2SSRj8Tt4Q+I5ydNmpLNV51AWKHDX1hcvvR5yDXYe5yqzpR7z+4
   DnJx0zkMIZXqn0S/YC9gkwQAwXu5sX28ku3gKEgyf/lOLB2XKukW37+sk
   EhGFjzZ8+BjfJJz9g0o66NM7ZABAVPmwvUGrL5UkXRgnmzxGHRTYSI6GM
   ghtPALwQsdGPGcwxCR7oh+SLPTLCKAt8uEyDZ3w7nykoPzt6I+hm7MIcb
   qUVGwpXYk2qBNI4KyxJ3+mLTM3W6TKM11Qt24L4FEOHFFTYTMroBD1H+5
   dYpjhvJBe2qYeccWqtAyMKCd/7n/gT5NpYEmZNNZsDTLkrgRZBPpPO8C3
   w==;
X-CSE-ConnectionGUID: RIuodRcSRUuVh0Vo1RHK3Q==
X-CSE-MsgGUID: JWeJHHA8QeiHeMrOxwEsIA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9289188"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="9289188"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 09:40:42 -0700
X-CSE-ConnectionGUID: /u9bDAVcSWqs0tXiTvD9MQ==
X-CSE-MsgGUID: IrKk4m3VQW+WflQgAuFKEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22371840"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 09:40:42 -0700
Date: Tue, 16 Apr 2024 09:40:41 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240416164041.GY3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <8aad3a39-dc7a-471e-a5f0-b3b1d5a51a00@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8aad3a39-dc7a-471e-a5f0-b3b1d5a51a00@intel.com>

On Mon, Apr 15, 2024 at 04:17:35PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> 
> ...
> 
> > +
> > +	kvm_tdx->tdcs_pa = tdcs_pa;
> > +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > +		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> > +		if (err == TDX_RND_NO_ENTROPY) {
> > +			/* Here it's hard to allow userspace to retry. */
> > +			ret = -EBUSY;
> 
> So userspace is expected to stop creating TD and quit on this?
> 
> If so, it exposes an DOS attack surface that malicious users in another can
> drain the entropy with busy-loop on RDSEED.
> 
> Can you clarify why it's hard to allow userspace to retry? To me, it's OK to
> retry that "teardown" cleans everything up, and userspace and issue the
> KVM_TDX_INIT_VM again.

The current patch has complicated error recovery path.  After simplifying
the code, it would be possible to return -EAGAIN in this patch.

For the retry case, we need to avoid TDH.MNG.CREATE() and TDH.MNG.KEY.CONFIG().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

