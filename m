Return-Path: <kvm+bounces-48269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0095ACC14F
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECA93188AEDE
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01681269B12;
	Tue,  3 Jun 2025 07:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jkYWg+5b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0839F269AEE
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 07:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748936515; cv=none; b=mvf3yRm14qe30739pY2DupCwNcPni14N8+YGXAdd3WTlyi+Px0hphrfRzQNXVJPilUuioyt+/Cr1DGb1aTMucmg+aNH508GtwUTFlDG4q7to1ihIowPoIzhyp3vtTwUt+SxdOGLXQx7VMh1fPYZaL3OBrv5DSLbTBZRsfcw4vEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748936515; c=relaxed/simple;
	bh=RdjSYOLIhqYxSDIPjkjRquUPKxKRqn8hTjGyKY7tIjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nXfZRfgTikF+CI2gtekhxL5IHYsZTKm914Uli1sMnDhKVTTM3RUS0cMKg/yjHezF1VAQlhe3WhFRkBpBqAL2KFwtY+sOchdo+d/LG/Vgzf/+Aqbb1+luP4BiRuAB5A+j5032uHsGD6PBbfeHnb4kuPAStVrRQliz4IZ6etmDEP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jkYWg+5b; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748936513; x=1780472513;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RdjSYOLIhqYxSDIPjkjRquUPKxKRqn8hTjGyKY7tIjY=;
  b=jkYWg+5bAhRXlZqnNB6pOdt48y8NYy4Ngo238D8NcS65TZ+NFjE3zbTP
   yaSvSMmHw4p9f5KyRSSwYGc1YPce7s4Kzr55ogM1myUoqZHXYq22i78Iy
   +BrahZRYgUpF2z+8Qyn9PSnALLqf0gK2uThoq5vXgjoKeAI0RYrHDem5y
   ZikqqSdTbwvkahbEzvJgmWrA8fb8fwAaJPCTvkOxJaa755sJTqEkp0pnl
   IwE/8IcjtVezGiqjooIQwXdzWqp2g77pupaSeJwF5gt5cLr+fPsyhgp4m
   +tQJ9nKO2ZvOXkd1ZoJhU4l7W9tbt3s+eWh+CtHOtMCgdMRBOafoDQcRu
   Q==;
X-CSE-ConnectionGUID: 8+bV7uXfRdeRWU/v9xKuxQ==
X-CSE-MsgGUID: +wm+m9eqSaK3D1HVA7311A==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="50828102"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="50828102"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 00:41:53 -0700
X-CSE-ConnectionGUID: j+uJMciYSTKKa1y07eGVnA==
X-CSE-MsgGUID: 9pt0EXLfTPq7FkCCp/byxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="175634245"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 00:41:50 -0700
Message-ID: <4a757796-11c2-47f1-ae0d-335626e818fd@intel.com>
Date: Tue, 3 Jun 2025 15:41:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Prefault memory on page state change
To: Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Michael Roth <michael.roth@amd.com>
References: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/2025 4:30 AM, Tom Lendacky wrote:
> A page state change is typically followed by an access of the page(s) and
> results in another VMEXIT in order to map the page into the nested page
> table. Depending on the size of page state change request, this can
> generate a number of additional VMEXITs. For example, under SNP, when
> Linux is utilizing lazy memory acceptance, memory is typically accepted in
> 4M chunks. A page state change request is submitted to mark the pages as
> private, followed by validation of the memory. Since the guest_memfd
> currently only supports 4K pages, each page validation will result in
> VMEXIT to map the page, resulting in 1024 additional exits.
> 
> When performing a page state change, invoke KVM_PRE_FAULT_MEMORY for the
> size of the page state change in order to pre-map the pages and avoid the
> additional VMEXITs. This helps speed up boot times.

Unfortunately, it breaks TDX guest.

   kvm_hc_map_gpa_range gpa 0x80000000 size 0x200000 attributes 0x0 
flags 0x1

For TDX guest, it uses MAPGPA to maps the range [0x8000 0000, 
+0x0x200000] to shared. The call of KVM_PRE_FAULT_MEMORY on such range 
leads to the TD being marked as bugged

[353467.266761] WARNING: CPU: 109 PID: 295970 at 
arch/x86/kvm/mmu/tdp_mmu.c:674 
tdp_mmu_map_handle_target_level+0x301/0x460 [kvm]

[353472.621399] WARNING: CPU: 109 PID: 295970 at 
arch/x86/kvm/../../../virt/kvm/kvm_main.c:4281 
kvm_vcpu_pre_fault_memory+0x167/0x1a0 [kvm]


It seems the pre map on the non MR back'ed range has issue. But I'm 
still debugging it to understand the root cause.


