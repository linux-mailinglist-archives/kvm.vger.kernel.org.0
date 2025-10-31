Return-Path: <kvm+bounces-61667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A12D0C240D9
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 10:13:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CED261B204D0
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB527330B14;
	Fri, 31 Oct 2025 09:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ToT3puQr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4134832ED3C;
	Fri, 31 Oct 2025 09:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901706; cv=none; b=agdVxoPDRSSf1cm9pAjQddi8VZX5YYqMkJw69Bkh+2T7s6NPQUI6dNlAIoZQmCqwdokdhpjlOv399zq4sKlnI1YW5HMy/AU2ju4R1EKkpKqC3H8jcjEsu59RZXqUjZAoEfaplbHTXJjUSoAkSWVCB/zqV2sfbP3koqpooR2Fghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901706; c=relaxed/simple;
	bh=8N9WDGemUWQsRelXH+GyTq3qC+LNB5rRhJXjTRawBT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pyUFYAkc0LWWk3Es+ivLTbslAwDjDcVX4/lwzXRI3kd1sAzZneYJL/2mcrPWaF10eFofjJNHNgu0Q1mrq8Q3M195UTZGGiPCo5SdQOpaWClI7X/bMRLK7ueI/YA+Qbz6Irl4fbzy8l10zDp0GW0eg+wcNGbOE6aDudBvo7HgkZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ToT3puQr; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901705; x=1793437705;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8N9WDGemUWQsRelXH+GyTq3qC+LNB5rRhJXjTRawBT4=;
  b=ToT3puQr95h3ixsM5l1c4mmBdAIOQ56YI9hVdoqC0x616bjmSecem0I/
   z9Zps0tKbaaMELMjDJIQOqkSKxRNaEQDa4tRaXE3vVyqZpW3gCBSJPkGL
   FALBl8AQd9Bq0oog0ob+BJuPDz1wNhEtUitCwU6dy1+KwYQhMpXatn8gD
   5CgM2/Fr9Zogxb1S4bdqHplvWYF+2ISJWPYv+YF/KaeRNt6FdmQ/fKi+Q
   fQf/inB9cL+J3eO50rQZZdkP/9+Yenlvcp5q1FcJJrfuH422+b+Zgrdcz
   9p9SsPBwz4yI03N+3SjJUUaApBwRMHitcYpoC3mkcBVABenCsQ0dbjcSw
   g==;
X-CSE-ConnectionGUID: 6vFw1yiNR9+jh9Ja15ohDw==
X-CSE-MsgGUID: KxHh56Y+R5Oep+S6eSM67w==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="64090328"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="64090328"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:08:24 -0700
X-CSE-ConnectionGUID: GjHDbGLnSWakhDM9/CBrlg==
X-CSE-MsgGUID: Gbbob1bvT8C2WhgnaRVktg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186123013"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:08:16 -0700
Message-ID: <a4dac87e-ff40-4ce1-a969-c8f535b66d74@linux.intel.com>
Date: Fri, 31 Oct 2025 17:08:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 21/28] KVM: TDX: Add macro to retry SEAMCALLs when
 forcing vCPUs out of guest
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-22-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-22-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Add a macro to handle kicking vCPUs out of the guest and retrying
> SEAMCALLs on -EBUSY instead of providing small helpers to be used by each
> SEAMCALL.  Wrapping the SEAMCALLs in a macro makes it a little harder to
> tease out which SEAMCALL is being made, but significantly reduces the
> amount of copy+paste code and makes it all but impossible to leave an
> elevated wait_for_sept_zap.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>



