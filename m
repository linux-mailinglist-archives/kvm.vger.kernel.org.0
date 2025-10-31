Return-Path: <kvm+bounces-61663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7983FC23F6D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 694DF4F03E7
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C231732B9B3;
	Fri, 31 Oct 2025 08:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fACj2G1h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22066329C53;
	Fri, 31 Oct 2025 08:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901152; cv=none; b=ftcksk2WpUgBwCSWbXITop4SwINI6pAE7635CaRPJQXdOGuwQ2kaj3cKym0VzmF2HGXXvcJyv4F+pVH08VlOmlkLiVcMtPH8p7nNSPGGAgO9SGjX4jVyB0FO9Jqz9zABLGCSorPlbQTEkRTPo5FSRfnQJ/UIez5E46Jekdk9Mpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901152; c=relaxed/simple;
	bh=14teRbdSNDZoo6LY1BdIEFiTD+Kt/E9bpeaMX41fhsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLdPu2uhNpgrJAw8s9RHB9+1oZSvj84oq0JWyfb0mEno5OrrD3xDau/IK3zqw0eE2udHILS7nu/UUQTJyEuXRDPoGVGalgVhdKQbqqBNxbnpBYhZve6wchKP4EoePOQAd7GsEnCnrSXxGqsG+HLMwtey4xntLsiwwLvRQjn0bZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fACj2G1h; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901152; x=1793437152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=14teRbdSNDZoo6LY1BdIEFiTD+Kt/E9bpeaMX41fhsM=;
  b=fACj2G1huC3BjSANlqRNVV6cQ6XESOtH1ut6OKV/gj0KHYJpqwNwYfHz
   J/bDKESFqWHxfwMAmxvjNp9CdZepgyXsYflyfacK+TP4Fo4BO7TLTBvBC
   vWhtPQF/IYTY4qr2/GNkJKD2IUlGTx24kwKl2czh7TgjvTxrSK1TerG/N
   l4btOrpy3Bnpha/S3avLt1RgyBWxw5dXvlD2I0UosoERogJj2iQ9X9Trx
   Tkc89Wo7tzGGcUy3WAHfbAMynoD6NVFJ7yYmoYsVOBxH5frpPY1bAhhRQ
   f+tUPHtzwLthsWOA7TsmU0pgdTcT2btPizSs2P9502+UiSPfGMRwZTTMi
   g==;
X-CSE-ConnectionGUID: OVjCLDqlSFW2pGDTY1MIlg==
X-CSE-MsgGUID: xCnUw1JrRL2IW6jfHxJ6Tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67892975"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67892975"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:59:11 -0700
X-CSE-ConnectionGUID: Qkn6DZO5Rceyyp8KD2OnrQ==
X-CSE-MsgGUID: hAjIabqjQHemJifWFRIz7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186119255"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:59:02 -0700
Message-ID: <5eaab97d-30c3-46a5-8be2-2ea1ef28e71e@linux.intel.com>
Date: Fri, 31 Oct 2025 16:58:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/28] KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error()
 into TDX_BUG_ON()
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
 <20251030200951.3402865-19-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-19-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Add TDX_BUG_ON() macros (with varying numbers of arguments) to deduplicate
> the myriad flows that do KVM_BUG_ON()/WARN_ON_ONCE() followed by a call to
> pr_tdx_error().  In addition to reducing boilerplate copy+paste code, this
> also helps ensure that KVM provides consistent handling of SEAMCALL errors.
>
> Opportunistically convert a handful of bare WARN_ON_ONCE() paths to the
> equivalent of KVM_BUG_ON(), i.e. have them terminate the VM.  If a SEAMCALL
> error is fatal enough to WARN on, it's fatal enough to terminate the TD.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

