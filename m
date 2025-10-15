Return-Path: <kvm+bounces-60074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72EA8BDEC77
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 15:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCC4E19A7B5E
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 13:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513C322ACEF;
	Wed, 15 Oct 2025 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ctl3KAdp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A5E1991CB;
	Wed, 15 Oct 2025 13:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760535512; cv=none; b=E4UTxersJA+EbyVwjIrOJQ6JlrLvvGkbiKQBgjQCxr8fHCDzxog/sOvGZkNzNrLRmwIANBe7oRxnicr6N3s1NNdJZvLHKoBEnUdbE/IGSvZTb2G0GWWEDtPnxLmUsXJdD90bCoYoZyZBlA8M+WxLNljKHfSz+YE4eV18oEzW84o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760535512; c=relaxed/simple;
	bh=6PdMurltLnCFBHRlFouE6RvKBNvD10DlsNLSaFacxSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RH9syfBqRHlpxXwZdJPbkUINQbaH6rVm8MPhObNCtSkD65zZNZfRlQG1ahZznyVdkYa44pKsP3xU9DevnAAqajfXphHvKkpd3ToafVGEp4HY12gQ39GUgAJDd1WzUiiYNjHrhDjF4KYyTpejTp8F2TKYOC6ElWeefycVtRmy+Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ctl3KAdp; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760535511; x=1792071511;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6PdMurltLnCFBHRlFouE6RvKBNvD10DlsNLSaFacxSE=;
  b=ctl3KAdp0EjWeHX2+yEt2xlRDSUOW3SlQCvpYJSJTK4rFnRHb0+tszRj
   2wQWd36TAuKwWzUiPf87qqFBOr+T7Dtu5k8pTO/nj83l174YjNTq0p7Zk
   p+e7iOJDoFEWPhcRBpr7ehuyk5NzAoII5Vqump4+HRycXlAQ5BIwYEGqp
   X04TcPAoOjTWsuuHjwD//2SKaVEvQv2g/4uj9AGU8lLNrhkGXkyAO7T1a
   MSbt6dMi5oaXCoeHQ+ZdtLzWAYHTQElwevxDFm4X8E7YrfMXo2f6tk249
   CafBSY9X5qbXyDeLm1yZMQQC9rlg75CbfiGZL5oLP1mmdhKrpnJL4213F
   g==;
X-CSE-ConnectionGUID: etwwCZenSbGoMzteXY9e2A==
X-CSE-MsgGUID: W4RJUJ+eSQGJHB2xctSYXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="73820324"
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="73820324"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 06:38:30 -0700
X-CSE-ConnectionGUID: GRcElT4RS2yxGb9imXemcw==
X-CSE-MsgGUID: mk2S/X5pQEG3Q9pZM3mf7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="186600248"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.235.70]) ([10.124.235.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 06:38:27 -0700
Message-ID: <e628bc34-43e4-4019-991c-330b946638d3@linux.intel.com>
Date: Wed, 15 Oct 2025 21:38:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20251014231042.1399849-1-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251014231042.1399849-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/15/2025 7:10 AM, Sean Christopherson wrote:
> Add VMX exit handlers for SEAMCALL and TDCALL, and a SEAMCALL handler for
> TDX, to inject a #UD if a non-TD guest attempts to execute SEAMCALL or
> TDCALL, or if a TD guest attempst to execute SEAMCALL.  Neither SEAMCALL

attempst -> attempts

But I guess this will be re-phrased as a native #UD is expected when a TD guest
attempts to execute SEAMCALL.

> nor TDCALL is gated by any software enablement other than VMXON, and so
> will generate a VM-Exit instead of e.g. a native #UD when executed from
> the guest kernel.
>
> Note!  No unprivilege DoS of the L1 kernel is possible as TDCALL and

unprivilege -> unprivileged

> SEAMCALL #GP at CPL > 0, and the CPL check is performed prior to the VMX
> non-root (VM-Exit) check, i.e. userspace can't crash the VM. And for a
> nested guest, KVM forwards unknown exits to L1, i.e. an L2 kernel can
> crash itself, but not L1.
>
> Note #2!  The Intel® Trust Domain CPU Architectural Extensions spec's
> pseudocode shows the CPL > 0 check for SEAMCALL coming _after_ the VM-Exit,
> but that appears to be a documentation bug (likely because the CPL > 0
> check was incorrectly bundled with other lower-priority #GP checks).
> Testing on SPR and EMR shows that the CPL > 0 check is performed before
> the VMX non-root check, i.e. SEAMCALL #GPs when executed in usermode.
>
> Note #3!  The aforementioned Trust Domain spec uses confusing pseudocde

pseudocde -> pseudocode

But I guess this note will be dropped as explained by Dan?

> that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
> specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long-
> form description explicitly states that SEAMCALL generates an exit when
> executed in "SEAM VMX non-root operation".
>

...

