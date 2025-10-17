Return-Path: <kvm+bounces-60273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ECD1BE6698
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 07:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E5BE74E8007
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 05:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1721730C63B;
	Fri, 17 Oct 2025 05:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iwkCXZEk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6D63346A4;
	Fri, 17 Oct 2025 05:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760678873; cv=none; b=qCKsm+Zofv6XA7HwRqvbelqQZwyGajbCQrb5urbwyOETypPDw9LRgfxN92uimJCLz6WEJI6M+pUxZlUSfS98QElJVeASc2h+nGgDFznkGmJUjJaYQIs8CkNUky1VddBDSyw3xkcbMtlJ0O7VRT4DKlYxFD31+vAF98bYY52HQsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760678873; c=relaxed/simple;
	bh=kXEcd7BB0LiGzh0pl5p+8OlsgmcISQUu+oAokj/iKZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZU26ObyIbKItbUq5kpcQUDySlpXAQMCu9dahSvHZArM+pBOmbWbeQGErI2AbEGzF+DAcN5ACB3QvljIynprXb76Qwa0NAOBhflpikIkr3H1DeoR6XZnGSHMo0bIzMWPsxTzLWjQ40URvpX/c4ZDyYf60SVh7XBo5eQltLMNMgKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iwkCXZEk; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760678871; x=1792214871;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kXEcd7BB0LiGzh0pl5p+8OlsgmcISQUu+oAokj/iKZ0=;
  b=iwkCXZEkjkJGV3uLXSU1iQJADQCIxHnUskXAwmY64wvJbAgdgdttV2mk
   H/DFChgTXmWObCTNDKntQTansN1F+W6sgZmvRyb+BrnKiMz1vEHZM9vcQ
   ktYNwGDXkVRm1I6YFBGFmd1su7/BeZcItakdWDOKd6QgDEZnSecZ1A/Vo
   AU5sJRImCsLFRSs/EoefkRJvXWq7uFkWbcFRf4MxPtTBp4aXdrg1J/ZTI
   2HdAN5kqxZkiKWgF5uKpKujMa/altZCg03Qgz/8GRUeXwy2tNowkkCjqU
   6PaF0R1GmyZnpHRxFktRTtDpHa5n5PI0cX+EjSbP9UuMm7Vld8CLvPJgt
   g==;
X-CSE-ConnectionGUID: aHFMRwlsSDqWM2UxN1TeUA==
X-CSE-MsgGUID: aqp/PIvNR++5d6lBtgMYVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="73555927"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="73555927"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:27:50 -0700
X-CSE-ConnectionGUID: JmDfiZWQTsWfFgT1uo7P0g==
X-CSE-MsgGUID: N5K0suq3S7qTNDHFJ1nU5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="183052233"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:27:49 -0700
Message-ID: <5f7c00ee-b680-4b4f-aac9-1f2ab63b2348@linux.intel.com>
Date: Fri, 17 Oct 2025 13:27:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
 <20251016182148.69085-2-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251016182148.69085-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/17/2025 2:21 AM, Sean Christopherson wrote:
> Add VMX exit handlers for SEAMCALL and TDCALL to inject a #UD if a non-TD
> guest attempts to execute SEAMCALL or TDCALL.  Neither SEAMCALL nor TDCALL
> is gated by any software enablement other than VMXON, and so will generate
> a VM-Exit instead of e.g. a native #UD when executed from the guest kernel.
>
> Note!  No unprivileged DoS of the L1 kernel is possible as TDCALL and
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
> Note #3!  The aforementioned Trust Domain spec uses confusing pseudocode
> that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
> specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long-
> form description explicitly states that SEAMCALL generates an exit when
> executed in "SEAM VMX non-root operation".  But that's a moot point as the
> TDX-Module injects #UD if the guest attempts to execute SEAMCALL, as
> documented in the "Unconditionally Blocked Instructions" section of the
> TDX-Module base specification.
>
> Cc: stable@vger.kernel.org
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

