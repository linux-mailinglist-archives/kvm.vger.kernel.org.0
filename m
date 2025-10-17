Return-Path: <kvm+bounces-60274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C8BBE66AF
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 07:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 478811A62B60
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 05:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECEF130CDA5;
	Fri, 17 Oct 2025 05:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VNgIL4at"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E2923EABC;
	Fri, 17 Oct 2025 05:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760678968; cv=none; b=mRP/eLDTwqvgSca3MJwsJoHgqTRTkfY6K5YcZOoIJHNhjAFX+M9loaCyyzL94E4657kvIMS+J/4woHvwB0wrRpkUPn7HBti5ZHhvD5ZD4pbgTuX7vRPNGgnijwypEkVznfye92ecDZbdxxzDjJSndU3SIE2UHnn6iG2cnQvSMmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760678968; c=relaxed/simple;
	bh=4FONppQg2BLdwN/d+WJOotcyUnysRLJeHGxkiBtYy3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XRWztYxEDR3RBCnZsd8nrYG2ocPAKWLeefD5eO/4+ZdEMdkhGV0cjijs7Gk1UuywjVSiXWG7BTxxTADUjmQy9pPS+AeMrq4EsHGFQTq945f+a7HGEZ8fZUBGw1bpEbYuLfXHHmS1CsIONXGPBpcddrJsKKWOiUTVG+FXRv+2VKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VNgIL4at; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760678966; x=1792214966;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4FONppQg2BLdwN/d+WJOotcyUnysRLJeHGxkiBtYy3U=;
  b=VNgIL4atGFHg6I+BYuqZBIxa4nbMVnD1E6p5yjMeeLGzvfNkWYiwgnpk
   D/cgh/XZnU+pxgKL71bzG8+ydsS5/rDkgonTIwIhkrO6XxhttSUN605Ur
   CZlq/NeGjEcjDES8cuTPLPZLZ3CwG726pFRMf92pToaC1K72gPqSHGkoH
   F0H0ENMTkwO3PvFnreSEEJPilrvckAAfKqXMe0N8aM+aFHEamU+QzKm0p
   0hCrGE2lWSqhVKezUct7QzANk8cmCkIr8xMGe9b3BlsasRg0xvXKa0xxo
   PPJHaJBP8FRkHwybs9tDO4LuXqvg/CDJ/YcVdRISHaXk6iBFwBqCHbarM
   A==;
X-CSE-ConnectionGUID: KUobU3PJRPSiyTIW98dlcg==
X-CSE-MsgGUID: M1DL7LHeQpGDicA41S/n0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="73556030"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="73556030"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:29:26 -0700
X-CSE-ConnectionGUID: 2V3nfKtXQAa6e5ow4GMspw==
X-CSE-MsgGUID: pWjESwP4SY6tOGwbr2mamg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="183052436"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:29:24 -0700
Message-ID: <4385b47e-391e-460a-8646-a499747d738e@linux.intel.com>
Date: Fri, 17 Oct 2025 13:29:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way
 out to KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
 <20251016182148.69085-3-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251016182148.69085-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/17/2025 2:21 AM, Sean Christopherson wrote:
> WARN if KVM observes a SEAMCALL VM-Exit while running a TD guest, as the
> TDX-Module is supposed to inject a #UD, per the "Unconditionally Blocked
> Instructions" section of the TDX-Module base specification.
>
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>



