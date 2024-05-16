Return-Path: <kvm+bounces-17500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8239B8C6FDE
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 200A01F215EB
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C86AF139F;
	Thu, 16 May 2024 01:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PgkCs4KQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CEF7E1;
	Thu, 16 May 2024 01:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715821948; cv=none; b=gfwShVYc/GjBfRR+rzVgk4xboAfLe/5LaJ+as+LwKlRShVBvcT44Zv4+0RAr+hLsEUSMoUaVTA3Mwc0YvtV4R0nCAbFRyrhAwNk5TkFpaFl4OK0enpVirkUmehUmFaKes8sVncq072cO/GiPF38CFkN0re+0FRlYPDwGmoFQw68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715821948; c=relaxed/simple;
	bh=hgapo4FsbqGvmKdLHfpqrQEAqxOcAvFCD+B4n56xWyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ao282gBhBjennHZLTq8EI+b3QkrDsm+NvLKdaQ6S+fQJZLBb+mIes/ykK8BLeDw16xXwBT1RCCxWWKIPsb/dktyv5Y6ljNnnu1P/GI50e7M+GSfccWvbgUQtm6+QPMBgY3A2VpcKKrkE3DPHHH4Pkz7KeP4gHx/uT9dhep7SaK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PgkCs4KQ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715821946; x=1747357946;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hgapo4FsbqGvmKdLHfpqrQEAqxOcAvFCD+B4n56xWyQ=;
  b=PgkCs4KQckySQjToPHvPeP/BOd7MjWHPUuo+UMpKOp6jHp8OUkt7iVQP
   GlroBk05XUnx5VUc6lXxrHPDYPMc/2dYiisy/z0fZCykf7ZSftvWwni7I
   zN+3qFcMtVFnAciW8b7HtCAUTC3IgpR7VOVws64TafuSmQbPUW3quOW0s
   XR0QMK3y3Y+PCfzF2lTnbufVm3vmvBAYHT0nBvGB+kqk5ot/QJVhW4+YG
   L9R0qB20fNdM0gVqZCm3S4qVtt+4yQjv8TdFLh9Q+RPmgXBVGxmS0L+62
   jUur/H6mkcMBp3/zT9bf0Cmuibte9jKq9B6Dj4Bz1OEW9npSTuys4su5e
   A==;
X-CSE-ConnectionGUID: Wzq7ADk8TqO1u9uHY9ZFsw==
X-CSE-MsgGUID: hIyRL+RMS2aIwkilH2KaZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="14857454"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="14857454"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:12:25 -0700
X-CSE-ConnectionGUID: LeeXAIr5TTOUX4x7szUQJQ==
X-CSE-MsgGUID: m0mWKw0fTwWQeZqUIDiNhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31077160"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:12:21 -0700
Message-ID: <638acb8f-3cc1-4915-927d-a6e90ce8ecb7@intel.com>
Date: Thu, 16 May 2024 09:12:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "sagis@google.com" <sagis@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yan Y Zhao <yan.y.zhao@intel.com>, Erdem Aktas <erdemaktas@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
 <ZkUIMKxhhYbrvS8I@google.com>
 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com>
 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com>
 <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
 <ZkVDIkgj3lWKymfR@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZkVDIkgj3lWKymfR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/2024 7:20 AM, Sean Christopherson wrote:
>> But again, I think it's just too overkill for TDX.  We can just set the
>> ZAP_LEAF_ONLY flag for the slot when it is created in KVM.
> Ya, I'm convinced that adding uAPI is overkill at this point.

+1.

Making it configurable by userspace needs justification common enough.

If it's just for TDX specific and mandatory for TDX, just make it KVM 
internal thing for TDX.

