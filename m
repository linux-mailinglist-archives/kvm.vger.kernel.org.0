Return-Path: <kvm+bounces-11802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4857787C10C
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 17:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD85DB22D2A
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 16:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE087745E2;
	Thu, 14 Mar 2024 16:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lDOc7R17"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B1E73522;
	Thu, 14 Mar 2024 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710432800; cv=none; b=Zwt0G4fLHXMstMLjsQ0bYtbvPcj1GnBZMUmpHpQaHQSxoVNzEHS8g/e0sT+rO0XaGyU0aLse02XJCJalHisShKRkcg9BHQPMpUHMdluZFPfeT7v3w8YwUtFMzC7YmWXa5LJ5JfPaCy40lrsM/aav8UrIrXGOpywm7stRsmaGbOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710432800; c=relaxed/simple;
	bh=FbRU08K/6LuBlZvA1/pbpzTww+NMF1+gxxXYtSCDBds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLzkndiQapiyrhsmHsWuAiUFLmYh+UGZDenbaT3yvEccqY00ZHve5SDMyZbgeh9uu0wAkxh5pFRJVPpYOiuO8SGNv8TDqG6iNO5bYtxz6Oq3OmKY6Lm1mZBymGsLjRJN04vTE7teVn75xZeF8T0F0hn0lLF830+rXO7D9JiH6S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lDOc7R17; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710432799; x=1741968799;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FbRU08K/6LuBlZvA1/pbpzTww+NMF1+gxxXYtSCDBds=;
  b=lDOc7R173+2ab93Sp+uHFFeMN0bGeDqESEAb1sqMRg6YJmyoEgvK+kPb
   A1lvaa+AavUf63/4ME5VMwsZTfT+j4Np3AwPVUbdnklyKPirN8GJ8srjp
   88ADlscMAO6vtq64pzlL84bKYbNRjMThaH8emerl7+crBQjrpJ8QrONos
   e2Px5xJpZqmxZ5kVTRpzmKNaOkdBqC4rzjY7OQEHfZNZeK+7OHv4Vgbyn
   sSqx1tjBGZgKBy7qlVkUA/Vgubb+J3G9Am18suhOb/YGUf3RpUG7mdwVT
   NHmEFcwLMUh3oD3I82m6u9LWY70xjmHs0AiXbqeDo92p9Z1/QCQa8RmQ2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5864936"
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="5864936"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:13:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="16941066"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:13:17 -0700
Date: Thu, 14 Mar 2024 09:13:17 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 019/130] KVM: x86: Add is_vm_type_supported callback
Message-ID: <20240314161317.GN935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <6712a8a18abb033b1c32b9b6579ac297e3b00ab6.1708933498.git.isaku.yamahata@intel.com>
 <ZfK2FCApVeB0xbAk@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfK2FCApVeB0xbAk@chao-email>

On Thu, Mar 14, 2024 at 04:32:20PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >-static bool kvm_is_vm_type_supported(unsigned long type)
> >+bool __kvm_is_vm_type_supported(unsigned long type)
> > {
> > 	return type == KVM_X86_DEFAULT_VM ||
> > 	       (type == KVM_X86_SW_PROTECTED_VM &&
> > 		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled);
> 
> maybe just do:
> 	switch (type) {
> 	case KVM_X86_DEFAULT_VM:
> 		return true;
> 	case KVM_X86_SW_PROTECTED_VM:
> 		return IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled;
> 	default:
> 		return static_call(kvm_x86_is_vm_type_supported)(type);
> 	}
> 
> There are two benefits
> 1) switch/case improves readability a little.
> 2) no need to expose __kvm_is_vm_type_supported()

The following[1] patch will supersede this patch. Will drop this patch.

[1] https://lore.kernel.org/kvm/20240226190344.787149-12-pbonzini@redhat.com/
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

