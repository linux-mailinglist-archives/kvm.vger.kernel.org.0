Return-Path: <kvm+bounces-14931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BEFA8A7C84
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 08:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F00DAB22B67
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 06:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E206A337;
	Wed, 17 Apr 2024 06:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8+Opz2a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44BE2AF0A;
	Wed, 17 Apr 2024 06:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713336429; cv=none; b=eRjHIlrRsRurVx63yrTTZO70pNCK94WjzAURpKxDI4XvPuvT7rdC4vn/zZNf9ZYauidar9Azg6zJbqhxn5Ou1RikMslMC2hlISFcBQRYruEtqU7ciTgVY0Tw3BgKFSnqWIjJvcLWoTxBZ+BxwYF91rcv7ia1u3z/Yb2SdhZoJIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713336429; c=relaxed/simple;
	bh=iN8fjmMLo89h+vHLb9rYvsnDFPIxSlHHgs1h/iLpzvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+uoN1uCcbfJvew2QvX7hIJiFQKw7fGkBGJ0LnGVQtdD/XeHOO3SXCwis0lzqGSsIF9JFlTPeB3zd0bLRK2VbnIkrRqduB9RvI/j7FJ+KEQPL72YPz4A39IPBsEGzKuD3WmndHgbItXlMeECVRcV8evfsUe/Q3it/uP1XCgbc/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8+Opz2a; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713336428; x=1744872428;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iN8fjmMLo89h+vHLb9rYvsnDFPIxSlHHgs1h/iLpzvo=;
  b=W8+Opz2aCVnlv//VgpPTgwPOeBr90UsHId499SWRSOdGoAGfVw3sAQtq
   cIhG0s+7xy0o+vTIHH9/ttTqxAZqJfqcTieg481xnAAQbTPo6KSeVz2ms
   nGiijYdiFCRx2THb/qKV9dfICQmnJ2uNwBySoqRB5t4OYlm8vSpgqc6pC
   qrZRxf02gW9OWfokvWf1Z2OrS9o8Tu7Vda45cJCN6iv/8UBIjKZ6FtTBf
   TbeShJhcvN4NLfZu04tzyH0bLDcMN1W+VIGrnB3oMxlzgqmT/8AlSNIaH
   xorBjNUPWmX13RK5H1e6hC4EWx7qCZipu6i79Fa3NVxWyHGapI5dolYgE
   A==;
X-CSE-ConnectionGUID: O2cNej9mQzKVdPbJ9/Jx5g==
X-CSE-MsgGUID: 7xoJl23MQUW+MZM2PqZh8g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9032028"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="9032028"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 23:47:07 -0700
X-CSE-ConnectionGUID: 5fTzK/apTdeu9vd5aJkFJg==
X-CSE-MsgGUID: gy4L9eKJQRCas0HRd0J3MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22584918"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 23:47:06 -0700
Date: Tue, 16 Apr 2024 23:47:06 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240417064706.GD3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
 <Zh8yHEiOKyvZO+QR@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zh8yHEiOKyvZO+QR@chao-email>

On Wed, Apr 17, 2024 at 10:21:16AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:26:01AM -0800, isaku.yamahata@intel.com wrote:
> >@@ -779,6 +780,10 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> > 
> > 	lockdep_assert_held_write(&kvm->mmu_lock);
> > 
> >+	WARN_ON_ONCE(zap_private && !is_private_sp(root));
> >+	if (!zap_private && is_private_sp(root))
> >+		return false;
> 
> Should be "return flush;".
> 
> Fengwei and I spent one week chasing a bug where virtio-net in the TD guest may
> stop working at some point after bootup if the host enables numad. We finally
> found that the bug was introduced by the 'return false' statement, which left
> some stale EPT entries unflushed.

Thank you for chasing it down.


> I am wondering if we can refactor related functions slightly to make it harder
> to make such mistakes and make it easier to identify them. e.g., we could make
> "@flush" an in/out parameter of tdp_mmu_zap_leafs(), kvm_tdp_mmu_zap_leafs()
> and kvm_tdp_mmu_unmap_gfn_range(). It looks more apparent that "*flush = false"
> below could be problematic if the changes were something like:
> 
> 	if (!zap_private && is_private_sp(root)) {
> 		*flush = false;
> 		return;
> 	}

Yes, let me look into it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

