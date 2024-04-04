Return-Path: <kvm+bounces-13571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C4A789899D
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC6201C29439
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF3712BEAC;
	Thu,  4 Apr 2024 14:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9LcFEzE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C92812AADB;
	Thu,  4 Apr 2024 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712239729; cv=none; b=H8s0mkoogHoMPiyjivfmaKHpUXMc5Th478A7kDVOapxXTgHViZqwd46YwMVL4BU7ona2JPp7/wqRrmu3ADLOxYIpQs54o8x+cOmLsj3V9BiyPKMWw12o5BhREzfMLqx33RIDTlqvY4pq2GW5rV/WOeJEkMs0jiBZJXeAWLpyD6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712239729; c=relaxed/simple;
	bh=Q5TomExR4q7N42k/kGEiT4EFIaCXwmnC4kGd5qGtxFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qmehk52zHV3icXsaUssZgGCGpRMeCWL4WpcDxqnQlkormLTJR/jKFQF+Gxs/LlPT/043Y25v6BobWwBZDzoPEWN6cH1eIqGgUpthDx66nWMkGxKF/Q00ycKH9g6erYm7A8zIT9NXXqViAsTqfqR8hL937sH+F+FvoWxpjww44B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9LcFEzE; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712239729; x=1743775729;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q5TomExR4q7N42k/kGEiT4EFIaCXwmnC4kGd5qGtxFo=;
  b=f9LcFEzENae1yKSGwvzRWe6EpnXH44R1Ar0tB5vNDH44aECpNhXJyFR8
   XT5rIs2c5Hm76KneukHNBgBxDr+SGd5oIz8nyX0AWY5vDTrdCGycsP/5Q
   HSTqxayC5NmypoinbGVqZc4yG3qOGojp/Uhf+XJ2k68PQY7+SfqaqgYPi
   ZpZ5fWAm/sWnSzVrJRNbso2cw74pMBAl2TwoRIvE0ugMVJYz6LwU5zI0u
   BsGtkaLQG3mZKdaiqouzbHNaJzLFKytJacVo3/rV3hkp2IWtCIWyzyCLW
   NoIaT48zfFyd8E+Ue9AJ5AZeUOOAhl34Oo/K09xqU/mYTQuhtfyjZ7kA8
   g==;
X-CSE-ConnectionGUID: ibPwKLg8SGqRDyhiJRHfZA==
X-CSE-MsgGUID: BeMRogxrSzadVLR6DPasAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="7686470"
X-IronPort-AV: E=Sophos;i="6.07,179,1708416000"; 
   d="scan'208";a="7686470"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 07:08:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="937086590"
X-IronPort-AV: E=Sophos;i="6.07,179,1708416000"; 
   d="scan'208";a="937086590"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 04 Apr 2024 07:08:44 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 1AB858B3; Thu,  4 Apr 2024 17:08:43 +0300 (EEST)
Date: Thu, 4 Apr 2024 17:08:43 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, 
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v19 002/130] x86/virt/tdx: Move TDMR metadata fields map
 table to local variable
Message-ID: <tlq2fqaxnwwcx2qbqb2rvspc4be6zxr7j5o6ezs7a4dvryu5fr@famk4qza3ewc>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <44d9530187b4b0b1c05e150fa73fe22ab54fc911.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44d9530187b4b0b1c05e150fa73fe22ab54fc911.1708933498.git.isaku.yamahata@intel.com>

On Mon, Feb 26, 2024 at 12:25:04AM -0800, isaku.yamahata@intel.com wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> The kernel reads all TDMR related global metadata fields based on a
> table which maps the metadata fields to the corresponding members of
> 'struct tdx_tdmr_sysinfo'.  Currently this table is a static variable.
> 
> But this table is only used by the function which reads these metadata
> fields and becomes useless after reading is done.  Change the table
> to function local variable.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

