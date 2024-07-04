Return-Path: <kvm+bounces-20947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD738927223
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:53:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8849428993E
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2631A4F24;
	Thu,  4 Jul 2024 08:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lpa8J0z8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA4E18FC7F
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 08:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720083211; cv=none; b=kTFlluJrMk8yFQCCeuZyRT4Eal1UWhFqcubC/Rrd3xSU9W7RJNLAnNYIjPY43tsOT7iei9uwAlB9t2dAdKNyf89/KQFa0ZSSKDdW2uC/AJMkyQ2vxcee4Uuf/mYVl+jnNAmy4vJvy071OewbsZE1W/13DSZmS6mS/atV2kI3d+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720083211; c=relaxed/simple;
	bh=+lF34JGBkAdyt9HCQOqpXFiCvpqwRAf+cHBgPF+ZnVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofVgW64xO87immDTmHQz/mfYBodeLQhaKU3b9CvTIAZ4kL1c2h2BzV7InX3U9lBqFwoRHLlFlRhgznCzRfMc/dN+pW0atNacilFjsNbC6yBh17XWLqgQq2ZPhyu7gsHshH+/tkq0ErmvRWWxkSOcO0llnFM+GfaM9Deo+Sy15OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lpa8J0z8; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720083210; x=1751619210;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+lF34JGBkAdyt9HCQOqpXFiCvpqwRAf+cHBgPF+ZnVU=;
  b=lpa8J0z81QB0EoiYxXNFC4o2ytTmLmxDI7OfSna7nf80xex94RQbp+CD
   AAVTwZhCVm8rySh4ZwiiKLCx5TeTa0hX3E1iXJj+O3sWOWTIRTSwMt1Jf
   kLKqVlj4CCnXCs3Yv7Y0w6hYPan2majx1fHO/NlnIsTsZlqA1czO5iMBr
   WCxk9spVTg9dfddJxq9IB7dQxMh9T90mdBOmMgH9pAOV93g0RQuuEzO8L
   NtUVMutxr2lzgDROpN7qtEPAUZLmAhNxN4+HsGF4t85ECeXAtPOl9HCSD
   kzWl41zMz8qGd4Q18LszdVaAW+OPmurFPFHHu4wmIaIOJz8pZS67/tHbp
   Q==;
X-CSE-ConnectionGUID: /Fb8QFtUQGeVUeNNU4yRSA==
X-CSE-MsgGUID: oYyVJQjvTC2vS+jkzHH3rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="12390394"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="12390394"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 01:53:29 -0700
X-CSE-ConnectionGUID: /KZ/JQjzTZymZwam7D3/NQ==
X-CSE-MsgGUID: 1IoHEw6XTUS8aKcV3xujdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="46486287"
Received: from chungegx-mobl1.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 01:53:26 -0700
Message-ID: <d25cc62c-0f56-4be2-968a-63c8b1d63b5a@linux.intel.com>
Date: Thu, 4 Jul 2024 16:53:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 30/31] i386/kvm: Add KVM_EXIT_HYPERCALL handling for
 KVM_HC_MAP_GPA_RANGE
To: Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org
Cc: brijesh.singh@amd.com, dovmurik@linux.ibm.com, armbru@redhat.com,
 michael.roth@amd.com, xiaoyao.li@intel.com, pbonzini@redhat.com,
 thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com,
 kvm@vger.kernel.org, anisinha@redhat.com
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-31-pankaj.gupta@amd.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240530111643.1091816-31-pankaj.gupta@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/30/2024 7:16 PM, Pankaj Gupta wrote:

[...]
> +/*
> + * Currently the handling here only supports use of KVM_HC_MAP_GPA_RANGE
> + * to service guest-initiated memory attribute update requests so that
> + * KVM_SET_MEMORY_ATTRIBUTES can update whether or not a page should be
> + * backed by the private memory pool provided by guest_memfd, and as such
> + * is only applicable to guest_memfd-backed guests (e.g. SNP/TDX).
> + *
> + * Other other use-cases for KVM_HC_MAP_GPA_RANGE, such as for SEV live
            ^
            extra "other"?
> + * migration, are not implemented here currently.
> + *
> + * For the guest_memfd use-case, these exits will generally be synthesized
> + * by KVM based on platform-specific hypercalls, like GHCB requests in the
> + * case of SEV-SNP, and not issued directly within the guest though the
> + * KVM_HC_MAP_GPA_RANGE hypercall. So in this case, KVM_HC_MAP_GPA_RANGE is
> + * not actually advertised to guests via the KVM CPUID feature bit, as
> + * opposed to SEV live migration where it would be. Since it is unlikely the
> + * SEV live migration use-case would be useful for guest-memfd backed guests,
> + * because private/shared page tracking is already provided through other
> + * means, these 2 use-cases should be treated as being mutually-exclusive.
> + */
> +static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
> +{
> +    uint64_t gpa, size, attributes;
> +
> +    if (!machine_require_guest_memfd(current_machine))
> +        return -EINVAL;
> +
> +    gpa = run->hypercall.args[0];
> +    size = run->hypercall.args[1] * TARGET_PAGE_SIZE;
> +    attributes = run->hypercall.args[2];
> +
> +    trace_kvm_hc_map_gpa_range(gpa, size, attributes, run->hypercall.flags);
> +
> +    return kvm_convert_memory(gpa, size, attributes & KVM_MAP_GPA_RANGE_ENCRYPTED);

run->hypercall.ret should be updated accordingly.
At least for successful case.
For failure case, QEMU will shutdown the VM, is it the expected behavior?


> +}
> +
> +static int kvm_handle_hypercall(struct kvm_run *run)
> +{
> +    if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
> +        return kvm_handle_hc_map_gpa_range(run);
> +
> +    return -EINVAL;
> +}
> +
>
[...]

