Return-Path: <kvm+bounces-61669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3955FC2427E
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 10:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07DC4561D65
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC9133033B;
	Fri, 31 Oct 2025 09:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+Nqw+rY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF11330301;
	Fri, 31 Oct 2025 09:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761902120; cv=none; b=QyMNmID3oQIYoLdD6Wt6rRpkrKXtTa06BBS9ulnBz5mPAb8kyfXE8xIS4g1twNsH/CS0DfJ9FkYkSfjwwXPP0IBV4xP11OOaWkH56DiNhdbDcsSe3YCe8h7iXNZcF6eQ51IrConTWt6FTThrIqobVy955TNxnKnK8zaYx7OS5tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761902120; c=relaxed/simple;
	bh=PEZyjCEAirGsnd1ualshLT165jeP3bC2ATQpTmkSqys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c9C1UDxoEHwUyQmv1D+LQAUUnt2PTQUYWt0bbtGmEgr482vO+gZULXLC8jfq+sZyID6vA6eiqjiTJlMBfySojJdsJ1NtYf92NQ33UJly4aFkflDG4plhnc8vVyly/VBTZmqXI20UlnO1GNmEsDzY3KQF4fW3HX3RMBLDfYLoi2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+Nqw+rY; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761902117; x=1793438117;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PEZyjCEAirGsnd1ualshLT165jeP3bC2ATQpTmkSqys=;
  b=D+Nqw+rY0wa4bOpWPLtgf4xEKdtWcpLUQmgzTJdTFY5FWFJnmdkwfPJk
   d808mKpNrfpmwlAqX2BrUP24bSByBnS2nzGsmPnnstY61c2jRGqR/weiE
   LqbhB5Fn+s/TJrwsuQ9IcM+fVFKwz4wMAyeCSkiNNRZ+qRRzUYPjVN/6T
   bKywHE9JNSf0UbkBy4oDxNDnoOyCKWwXUU5BvmVx5QWEObVMXZTBXbEG+
   6M3Petvu7Spefstw111fXahEqG1VWihgbSvAZgT2bFqn2J12ZueDUMbgq
   eOi+zt90wqdRJt9FSEY2JngnMh/5E2pwjDUe2sV4S0wPyze5sHvZT0OB7
   w==;
X-CSE-ConnectionGUID: UUmjQFmNT5Gas30EyYrpqA==
X-CSE-MsgGUID: KJ8NPh4YQ4O9M9SbSwJ3gQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="81471336"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="81471336"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:15:17 -0700
X-CSE-ConnectionGUID: /aUTuTUZR1CXvXYAACxkEg==
X-CSE-MsgGUID: 8/kgW76KTTCO7UxJ6gCbbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186125404"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:15:09 -0700
Message-ID: <fd65c501-296a-4f77-86fc-7de61a7c5eeb@linux.intel.com>
Date: Fri, 31 Oct 2025 17:15:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 23/28] KVM: TDX: Convert INIT_MEM_REGION and INIT_VCPU
 to "unlocked" vCPU ioctl
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
 <20251030200951.3402865-24-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-24-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Handle the KVM_TDX_INIT_MEM_REGION and KVM_TDX_INIT_VCPU vCPU sub-ioctls
> in the unlocked variant, i.e. outside of vcpu->mutex, in anticipation of
> taking kvm->lock along with all other vCPU mutexes, at which point the
> sub-ioctls _must_ start without vcpu->mutex held.
>
> No functional change intended.
>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


