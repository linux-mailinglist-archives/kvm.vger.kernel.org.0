Return-Path: <kvm+bounces-50024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4E7AE148E
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F32B33AB54D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 07:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0BF226CE1;
	Fri, 20 Jun 2025 07:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BVy9Mncs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF790A923;
	Fri, 20 Jun 2025 07:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750403354; cv=none; b=PzLC5qgslV6QarNnslIM2k9OzpXQVisBjNuP4ytNDiy9Osg+KPubIQR7kRlvfxTiIX5sWwrPLDEl9CoT/F3xOWzHOax31T+GiRg/zs06NeXEfsqdpJxY8P413JdJCOruI2btlN4j7dj/YR0OLsPDkrUrufkwTIAlKtpFRbCVtQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750403354; c=relaxed/simple;
	bh=M0OVidBb/1rU2itOG2o5tpQdcSqZhBs/xPlRD1ZyRcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dkIrb9xSr3zxiMIKxY+2HSNZBJwfQLjPKgvjLjn9Qgr+iTZYyZ4eYMQt4u+W9COuLTdNxQ3emEatGOOaDLOmDsUqr47Ztr08x6wNjpC9mDLVvTIuEUCOBSPYKH18ITDyJ6ZckCadYFLKATKowUsqjHU7rn7JPGkeG4q/ZTS4a0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BVy9Mncs; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750403353; x=1781939353;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M0OVidBb/1rU2itOG2o5tpQdcSqZhBs/xPlRD1ZyRcs=;
  b=BVy9MncsDkWkeB012EfKw5M6gTqxe9hY+fZ+p083K/KJ6swnZXULnsbn
   MNOC3WNNo8/U4O9b8+7RRYzoPQ6JY6B+Tn5T+SndKJJ+kL7cPl4appm5n
   s9IdIBxUkBL61N/DeTpwWGbGwVqYL8qHTVaWA8rclJ1gEKC+lwbjhnIKE
   F8McMrRZeuog8u4eZWk3IJnKnAdHJCBHgexDCZAnp+vuLivwFJCnzsNL+
   siiQgmvCvXs3YTp+/awh8NV1vNu82/GF/p15ygc9N/7SG69q6T8uPBhlS
   PDs7IaXFxWH/sed+NOWXZlO6nCHD2Itd8M1DX06uYiftz/YaTDvTDDbOo
   w==;
X-CSE-ConnectionGUID: ko7iqLL6QbS2+Oio1pTFPw==
X-CSE-MsgGUID: LP6AtqlhRkmNEblqAsgKUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="51769330"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="51769330"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 00:09:12 -0700
X-CSE-ConnectionGUID: Gr7O5rRBSOWwJ6j1j3sv5A==
X-CSE-MsgGUID: e2PD9KtqR6mbu6ctuZd/jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="150324857"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 00:09:08 -0700
Message-ID: <12894e27-7e80-4b48-97cf-5b1b98b51059@linux.intel.com>
Date: Fri, 20 Jun 2025 15:09:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] TDX attestation support and GHCI fixup
To: Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, kirill.shutemov@intel.com, jiewen.yao@intel.com
References: <20250619180159.187358-1-pbonzini@redhat.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250619180159.187358-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/20/2025 2:01 AM, Paolo Bonzini wrote:
> This is a refresh of Binbin's patches with a change to the userspace
> API.  I am consolidating everything into a single KVM_EXIT_TDX and
> adding to the contract that userspace is free to ignore it *except*
> for having to reenter the guest with KVM_RUN.
>
> If in the future this does not work, it should be possible to introduce
> an opt-in interface.  Hopefully that will not be necessary.
>
> Paolo
>
> Binbin Wu (3):
>    KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
>    KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
>    KVM: TDX: Exit to userspace for GetTdVmCallInfo
>
>   Documentation/virt/kvm/api.rst    | 62 ++++++++++++++++++++++++-
>   arch/x86/include/asm/shared/tdx.h |  1 +
>   arch/x86/kvm/vmx/tdx.c            | 77 ++++++++++++++++++++++++++++---
>   include/uapi/linux/kvm.h          | 22 +++++++++
>   4 files changed, 154 insertions(+), 8 deletions(-)
>
Tested the patch set with the TDX kvm-unit-tests, TDX enhanced KVM selftests,
booting a Linux TD, and TDX related test cases defined in the LKVS test suite
as described in:
https://github.com/intel/lkvs/blob/main/KVM/docs/lkvs_on_avocado.md

Xiaoyao has tested the flow for GetQuote and had some comments for small issues
on qemu patch:
https://mail.gnu.org/archive/html/qemu-devel/2025-06/msg03154.html



