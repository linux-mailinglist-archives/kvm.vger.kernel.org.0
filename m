Return-Path: <kvm+bounces-57690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6E5B58F51
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D299E3A5A40
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936232E9ECE;
	Tue, 16 Sep 2025 07:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bOPTnE6K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAD3DDC3;
	Tue, 16 Sep 2025 07:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758008302; cv=none; b=XKprv4gAYYneC05YUViDMiWGO5zZ/x3lTQlzQZ8DID/gXY8pUygw8+3aB3LTVc3o2Wc+ZZ92DnMiQ/mPYCXkS2c29kdgiz7iirYE/7AmLX+yRazw7X+tdESjzXuV7BJjehVf42tyBjUxZAPLMrqCvtIdDXqYrq2ri6l0wSU8DmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758008302; c=relaxed/simple;
	bh=ntW9cv/diewtJoXEs+ayKjjq8OIScxKxcqsED+U4jF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jx6bebd2h9KLcwVmI7z0yedzW2+wyEwP/uplp5NArNlH+91rXuOs7OealyAEUd4h6vWtyMlyDZPAStd0vKgCQshlWi+olIRdb4enp06tbQRZPHG2iEldMMfKtZaDxrF6Jj+vU+q7ggRm/ITpRhs4CD1isAE+6Dp92cburP3qqks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bOPTnE6K; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758008301; x=1789544301;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ntW9cv/diewtJoXEs+ayKjjq8OIScxKxcqsED+U4jF8=;
  b=bOPTnE6KNJ5CF0GSuSj/5c5ypz7qD+BMy4TlMZnbdKveEVlhwyUWhXd7
   sZ1ZWF3FnNmvDbLxBgVa5WuB9eYr3/j9SNC/z8x+3ewwt9147jF9f+JEu
   LEoHegaN5N9U6azkfgj144qPoDGjLlGFBRDO0qTIOu3TYMRD03P/1hZyF
   lXcu++bOaS2ExQARKrBKXNJVzySte2skR7OmDdE8ECeXcChWgD/CF6ypf
   Jbq4QHx4n/pgen/cnCpEH/KCacepQ7eJs9bhJIVC/uvH1N4Bn2bK3tJzx
   NQub66USestdlYEzMTlHI4WyRfV6Vy/77eo2gmL5xKMb1LwBraIzjYWlx
   Q==;
X-CSE-ConnectionGUID: dYvD9fxMS6qQ/jXyjDkMwg==
X-CSE-MsgGUID: LVZam2qSSJe2w8R80hCDlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="85715357"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="85715357"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:37:49 -0700
X-CSE-ConnectionGUID: ffj9HxvcSGmkUdbzltIiXQ==
X-CSE-MsgGUID: peUc4/7TT4aw1Ib2clPOFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="175653312"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:37:46 -0700
Message-ID: <455f690d-6720-406f-a83f-dc98ce3b7ab3@intel.com>
Date: Tue, 16 Sep 2025 15:37:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 15/41] KVM: x86: Save and reload SSP to/from SMRAM
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-16-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
> behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
> at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
> one of such registers on 64-bit Arch, and add the support for SSP.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


