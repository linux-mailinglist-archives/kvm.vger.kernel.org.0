Return-Path: <kvm+bounces-16948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B61208BF365
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 02:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 567661F25519
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 00:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1EB633;
	Wed,  8 May 2024 00:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0JMSi3P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7637364;
	Wed,  8 May 2024 00:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715127305; cv=none; b=URA7E7BQ2iAqvmEy/ZHOmYbTU8WLhGuFADb2UB9zrb8zHyvgACIlucr8+uY/G1fmO7zCooi+eqz8QIuSpXdcqx87cfmITBAICxvaHMmBZFcLnm8vNG4YAknBnYURT1P39Ql2EuJ1I8COs+KEEj6AMsQRSxzqyFgbiKmudPaGdW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715127305; c=relaxed/simple;
	bh=dU0EnPIyoY9OArUalQB8q4YvnLqWmcWeqsqCof/wl0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sap86RYe6oB+lFL0q85FoNj9d3jYK8zxJdzYfqMb5CLQH+nGvLpoSTN3zo1S9LdAT2Pj4JDgorgYdIJuCZxCTln5EY8SzqWcb/YphLoAhR1xqtJr0mcvaQeUhAKoRjUOFg8Rw6ArIkFgprgAv1HzZDq2aLdBKszYkpLBhob4Nio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0JMSi3P; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715127304; x=1746663304;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dU0EnPIyoY9OArUalQB8q4YvnLqWmcWeqsqCof/wl0k=;
  b=B0JMSi3P77qR16dQ9i7/M+pByavcmHU7we2UA1j1BMbKcdXPh1kacxZr
   +LiAH6e4piYpEHIx7O3uDrPiVRgD/RxjA7w1ptUfQQiaqFRTwRozZmLxi
   hr1fyibG42Jj9NSFtP3ESMGIs4CuBIbxE8SWo3VM2VfF7TMoGvM7HeM5C
   yDYcQiXP9cr/DDTJbh49CkiVvlbZwq74pz9kGftmkAL91s179ytNqMVtF
   0nfzGzcrJ5kwRV+G2azMoUXABz16uSE8NkCmo+C+kZLJZuj3qDMabrkiM
   IvKZgIVYQK69RH9UVI1XRnazbCGUCKfQf1ugHP7LmEDbbbUqy8mvua3Xq
   A==;
X-CSE-ConnectionGUID: LjbR2nMoQjKWWVwsnGV8tg==
X-CSE-MsgGUID: BeEDDQ1yQVSRC3qNl9pq4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="14767571"
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="14767571"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 17:15:03 -0700
X-CSE-ConnectionGUID: LHyTQtNDSgaw+pO3l1gl2A==
X-CSE-MsgGUID: 5DxqnavBS4SnbKxZIDNW4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="29109553"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 17:15:03 -0700
Date: Tue, 7 May 2024 17:15:02 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, vbabka@suse.cz,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, michael.roth@amd.com,
	yilun.xu@intel.com
Subject: Re: [PATCH v2 0/9] KVM: guest_memfd: New hooks and functionality for
 SEV-SNP and TDX
Message-ID: <20240508001502.GG13783@ls.amr.corp.intel.com>
References: <20240507180729.3975856-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240507180729.3975856-1-pbonzini@redhat.com>

On Tue, May 07, 2024 at 02:07:20PM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> This is the hopefully final version of the gmem common API patches,
> adding target-independent functionality and hooks that are
> needed by SEV-SNP and TDX.
> 
> Changes from https://patchew.org/linux/20240404185034.3184582-1-pbonzini@redhat.com/:

I tried those patches and confirmed that now kvm_gmem_populate() and
private_max_mapping_level() hook work for TDX KVM without further change.

Thank you for updating them.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

