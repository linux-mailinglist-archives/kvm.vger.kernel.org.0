Return-Path: <kvm+bounces-56416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D59D0B3DACA
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 09:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A3C73B39C1
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198C6261B8F;
	Mon,  1 Sep 2025 07:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AFJre2SB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2212135CE;
	Mon,  1 Sep 2025 07:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756710478; cv=none; b=KDQV3YQmnjWrurKCW67QcLS7VIgvIxFKC5aItDq6xFyPyd213DSIZo2Bi+5qpaBLHRXtKmKwnvJ8rsGLncBlnvOALD14QhP82dSqs5Rz1wz7uDI/E3cIzTWcyJh83szE/tsfAHeORHjWMgonBSCN0gtdENcd0d1kL2aw9DRRch0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756710478; c=relaxed/simple;
	bh=lWE2uNAxmuMbTuzNnv0x0FIPI+3SSxSg/s6KZBB5Yeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mB+WDNUQlrTU3MojByYs9nevLZNdaG0mZHAIuvmk/h0Wngvf4Ef1TIYWP73GgKQ+hHc7dKwVht06Ztx4kic2fbmffCtrdfnLcmpdEWspAkLFNUyOpyoO/FjpeFUjgARF6kkemrTnuV0+JLV7lmIJWd/OgMKV/cisK9Jp52AEF0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AFJre2SB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756710476; x=1788246476;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lWE2uNAxmuMbTuzNnv0x0FIPI+3SSxSg/s6KZBB5Yeg=;
  b=AFJre2SB7SYXOPHlg4qYa0XZFUXUkKF9+efyLr8kXXN1WgD7dA7EUYeU
   9Pwqsxmomz1GFLhV04rwu1+rQVHFjq5JPsm8AJTeXYfi+59tPXqovfUHO
   0ACoJ7Ddl3U8slDnwrv8+u0tIlT0n90lTgY2H8NTMutqP8Wxx+5JTTqOo
   GNJfuLz/DKzjwjH5T4O8TIrudsVxHS8TIMQ1viVIIGqxHiwiv3XR+uNyK
   3uMy3LYYEJR+vroBgl9MCFHtA/SxWYi6FdOix9VR3wRe8dVFeUr7iNbzd
   rIFAgGX7N0an1AyS80uegsB0GfnJcEUUN+M39i3iGexMPC/+KBhs7aWqm
   A==;
X-CSE-ConnectionGUID: ChesgO8ER6ajWiMYGkttZA==
X-CSE-MsgGUID: ywQ6aREcT/KUGItnBf1FEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="84313522"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="84313522"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 00:07:55 -0700
X-CSE-ConnectionGUID: VTOOgbQRS2ubljo/GTJiKQ==
X-CSE-MsgGUID: VOzrSK26S5OrTeBqFfamzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="171077993"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 00:07:51 -0700
Message-ID: <5a19db9d-3c76-4712-a308-d88c9ac23f71@intel.com>
Date: Mon, 1 Sep 2025 15:07:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/24] KVM: x86: Rename kvm_{g,s}et_msr()* to show
 that they emulate guest accesses
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com, rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
 xin@zytor.com, Sean Christopherson <seanjc@google.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-2-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250812025606.74625-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/2025 10:55 AM, Chao Gao wrote:

...

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..86e4d0b8469b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2149,11 +2149,11 @@ void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
>   
>   void kvm_enable_efer_bits(u64);
>   bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> -int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> -int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data);
> +int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> +int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
...
> -int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> -int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
> +int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> +int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);

I dislike the rename, it loses the information of filter.

can we keep the filer information and make them as below?

   kvm_get_msr_with_filter() -> kvm_emulate_msr_read_with_filter()
   kvm_get_msr() -> kvm_emulate_msr_read()
   kvm_set_msr_with_filter() -> kvm_emulate_msr_write_with_filter()
   kvm_set_msr() -> kvm_emulate_msr_write()


