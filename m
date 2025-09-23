Return-Path: <kvm+bounces-58549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA8DB9678F
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FE9E3B0441
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B79F244685;
	Tue, 23 Sep 2025 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="htNc2LUV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDAD18E20;
	Tue, 23 Sep 2025 14:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639471; cv=none; b=Gq+vAvon+JIFOBV1el65rSevuNxZ6GKKnHJoedQRB7Qn+RfU8TVlN0NaT66Qy9QbZZPPulye9Tb/6ADVTOhUoonBsRa+tcy57iDhkcOb54I8flCq7inDn1jIn+PaEwypAyIjv+mf8Svv3iOYx5oxGt+Rjq2un7FOroN3WQxACH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639471; c=relaxed/simple;
	bh=vTCKBOU6gu1HJhYhBB8NUvymzBQoq30uzkOtkt6iYE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h/1J9Aw2kjN3XQntZHJtbHQiXjmfOeMEKkkr+ggDOalX4GBXqsHuwYa1xTB7LlbkQ54mNAfmySlWCVfJlHbMNu4TkYOOnCTvIMZV5htqt8iILVWyFWixy0vD2k1cLRQh4mJx8JQAxvXbcRSlhCYPGM4asxoXj5TNPjHUVvO8YL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=htNc2LUV; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758639470; x=1790175470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vTCKBOU6gu1HJhYhBB8NUvymzBQoq30uzkOtkt6iYE8=;
  b=htNc2LUV5MMsonJ1CSa2NTGzgUGEHGB3INbPDSXaZlamrAgpMu57jkUr
   PCLOd14b+tLNFd8uP1PstcTnv3TYrrHbrU58ipaBOApOjDpzq9G27bCRq
   Vp6gumU3lq/M6Tc37qMKvkQQKoVmOugmgouh0XJkOvGwkNBXTBk5lzVnE
   hqCmEGwUmigXo6q9osKIS+bj3Ov2k9n+Dxi1sHKCGjs01pNZEiimG+xCg
   YGEnMcxCokAih8N/xkgt8Zhmb9km+7Hstfc9mOUk4n+ns5rktG00beG+0
   qZzQanTxNTWWystLYSR3D2RH8yU8n0w9pEtU34AgdUMFa9IjYQtJ/LSzz
   A==;
X-CSE-ConnectionGUID: pHX7SOgHRbe69iD9VkIz0A==
X-CSE-MsgGUID: +/Dim/H3Rx6db8sQwlpksA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71542157"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="71542157"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:57:49 -0700
X-CSE-ConnectionGUID: 2N8S3d5oQGSCK8wI4ENGUw==
X-CSE-MsgGUID: XPpvwklDTryEhJtOg03a/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="213927921"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:57:45 -0700
Message-ID: <5717b2dd-8a95-4200-a547-b724f46abaef@intel.com>
Date: Tue, 23 Sep 2025 22:57:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 28/51] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-29-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919223258.1604852-29-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Add support for the LOAD_CET_STATE VM-Enter and VM-Exit controls, the
> CET XFEATURE bits in XSS, and  advertise support for IBT and SHSTK to
> userspace.  Explicitly clear IBT and SHSTK onn SVM, as additional work is
> needed to enable CET on SVM, e.g. to context switch S_CET and other state.
> 
> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> KVM does not support emulating CET, as running without Unrestricted Guest
> can result in KVM emulating large swaths of guest code.  While it's highly
> unlikely any guest will trigger emulation while also utilizing IBT or
> SHSTK, there's zero reason to allow CET without Unrestricted Guest as that
> combination should only be possible when explicitly disabling
> unrestricted_guest for testing purposes.
> 
> Disable CET if VMX_BASIC[bit56] == 0, i.e. if hardware strictly enforces
> the presence of an Error Code based on exception vector, as attempting to
> inject a #CP with an Error Code (#CP architecturally has an Error Code)
> will fail due to the #CP vector historically not having an Error Code.
> 
> Clear S_CET and SSP-related VMCS on "reset" to emulate the architectural
> of CET MSRs and SSP being reset to 0 after RESET, power-up and INIT.  Note,
> KVM already clears guest CET state that is managed via XSTATE in
> kvm_xstate_reset().
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: move some bits to separate patches, massage changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

