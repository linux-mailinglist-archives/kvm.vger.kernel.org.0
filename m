Return-Path: <kvm+bounces-15003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8718A8C4A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 21:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01DA71F227DA
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 19:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7565B36AEC;
	Wed, 17 Apr 2024 19:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AHddctoQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2132125DB;
	Wed, 17 Apr 2024 19:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713383258; cv=none; b=Y7HV04JGvCYtv7tfXfdGbqNL6NJiqZ6JEOZDQi44qB0eTPwJ2+U5ZUe2WgdFTXfYeJhTzV/GDQ0k8Y/0yTkoYVJNuaN3PQRmHuhrETSSVrDLhOSn6gtT0BmuOTzHHiMOZXhXwAnXu7Umr2RptIaFgwjlCX/Sem+HNPOYShOf53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713383258; c=relaxed/simple;
	bh=5S9T1vSyP5f6m8bVV/tCZ8JbQ50WIdqZLeu6EBiVXHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJErSxdiA3lNho34y2u1Fm6PaPB5hdhrDZ4GHw38OZn0SjL5rvw/alU9jHgg+OlUr/nMjwWnbX9tSaGrxD4ZMF8clmm0Y0Oru64+9IGSytq6T74gmozLqNEr6gFemw2nz7owGssM7pNrM5Mc2QXAGsD1Ey6gjRLObfvdedwdZp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AHddctoQ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713383257; x=1744919257;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5S9T1vSyP5f6m8bVV/tCZ8JbQ50WIdqZLeu6EBiVXHM=;
  b=AHddctoQkUZuKkWOTb/1aV9LjEWEru3/Ldwo5P/KxyndRb6SnI0sEhdw
   QDqGQvzO7Ky6lu6jBTDAg0cT8F1ICi56dWHqnXDAI1WbMgxALaFhGnCu+
   Qw9TGWZPxA/QGGJprZ1jKIhycjaAqTKZ2BVxyVlQDYgo02IxvxQxSwF1t
   8eWNxV7ifVKAEuyLPnwcPpFvrMFmQ2ASqhx84rgAFzgoM5SgZHkDF642M
   lYkLc/tVPjb3Ja85giAvj5VrKsVSoh5P1cjS1jw+qp9ugA2tR9s8KiFhW
   QBe0E1KZn0anO8s5mRhEgELyv3SXwwLbL6+M4O9YKvsQIWjhHeH85J21D
   g==;
X-CSE-ConnectionGUID: fhQDtB3ERTOBrpn0i9BH2A==
X-CSE-MsgGUID: qz7RhaahQCuwXxoUOOLv8g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9446619"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="9446619"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 12:47:35 -0700
X-CSE-ConnectionGUID: aKl8f0I+QV2R2t1TF0dARA==
X-CSE-MsgGUID: 0+Zg474uTLuqXYpAu97ZqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="22795796"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 12:47:34 -0700
Date: Wed, 17 Apr 2024 12:47:34 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 3/7] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
Message-ID: <20240417194734.GK3039520@ls.amr.corp.intel.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
 <20240417153450.3608097-4-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240417153450.3608097-4-pbonzini@redhat.com>

On Wed, Apr 17, 2024 at 11:34:46AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Extract out __kvm_mmu_do_page_fault() from kvm_mmu_do_page_fault().  The
> inner function is to initialize struct kvm_page_fault and to call the fault
> handler, and the outer function handles updating stats and converting
> return code.  KVM_MAP_MEMORY will call the KVM page fault handler.

To clarify to no update vcpu.stat, let me update the last sentence.
  
  KVM_MAP_MEMORY will call the KVM page fault handler without vcpu stat that
  doesn't make sense for pre-population because pre-population (outside TDX) has
  the purpose of avoiding page faults


> This patch makes the emulation_type always set irrelevant to the return
> code.  kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault(),
> and references the value only when PF_RET_EMULATE is returned.  Therefore,
> this adjustment doesn't affect functionality.

For the technical correctness, let me mention about NULL emulation_type.
I added "," and "with non-NULL emulation_type" to the second sentence.
  https://lore.kernel.org/all/621c260399a05338ba6d034e275e19714ad3665c.camel@intel.com/

  This patch makes the emulation_type always set, irrelevant to the return
  code. kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault() with
  non-NULL emulation_type and references the value only when PF_RET_EMULATE is
  returned. Therefore, this adjustment doesn't affect functionality.

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

