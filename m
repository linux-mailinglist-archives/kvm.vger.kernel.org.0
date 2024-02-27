Return-Path: <kvm+bounces-10088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C8486968E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72397B27733
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 14:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367F51419B4;
	Tue, 27 Feb 2024 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxhbJrsI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C5778B61;
	Tue, 27 Feb 2024 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043167; cv=none; b=HeOSKOvmpWjHmZQXe3qYxMVPPXYAfBk2jKXHdLiyz+hRluOMfYr9Ym/oLd0iw4uEKcrrg1k5LxD7wZJ1zn7ORSlZYwq0ehMSrTl/zVG7EH31QgUQb2nLVwUwbtpeVPTGppUc+ocRNx6vvadshvYOul5mGJ+NTXyNPLQc9IGsWtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043167; c=relaxed/simple;
	bh=d+d9k/vVtANqH6M54cOyG+CyAcg/d58jbgDykQpOjFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHSaV4iJMdtXWYA4F2yBmrD42snoCN5cS1cEnG7ZNZ19K8Ucq8PjhH5kTMsGMFcis68scah+5ObR07kT2eevrGaU0taSSIxvnc1oY3nQCMIxe8zFK6eE/Ih1IVDGOR5g1JhdQ4zFyzeMhy3VmOWJ79HrM2V8Af9BP7RKuAiQFZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxhbJrsI; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709043165; x=1740579165;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d+d9k/vVtANqH6M54cOyG+CyAcg/d58jbgDykQpOjFc=;
  b=NxhbJrsIhH/K2sUm8TVtevzRcD48sCUPTNBaNy37oYfv1yhe5MQRNK91
   1MzLdswUyRmau/5lTufKworMmbWCXfYdz9YCZw+cNG3Gxw25wZlUA1FpX
   ntPbOBs59vZO0A1GRyk/Yll+o36msig53dVJMMbCRP/zT1nQkN3AqPo9o
   DBzEeyKY9jOp9oKfLauzUxCOC2bmqLlS3jeKbRaEMsaG0ZhlQRL2N98E8
   gfhr7qTvmTNxT7gTcFtukGqyuHGuKLKcMflVwH+QDL6AqIClYl4PQT3PK
   PDoDWUz3enagAEWi3cHOWXV14gQodgwxYUlSMONArr9Sd+2lRUJ+unBPs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="25848653"
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="25848653"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 06:12:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="11656530"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 06:12:43 -0800
Date: Tue, 27 Feb 2024 06:12:42 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	David Matlack <dmatlack@google.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com, gkirkpatrick@google.com,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v18 064/121] KVM: TDX: Create initial guest memory
Message-ID: <20240227141242.GT177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <97bb1f2996d8a7b828cd9e3309380d1a86ca681b.1705965635.git.isaku.yamahata@intel.com>
 <Zbrj5WKVgMsUFDtb@google.com>
 <CALzav=diVvCJnJpuKQc7-KeogZw3cTFkzuSWu6PLAHCONJBwhg@mail.gmail.com>
 <20240226180712.GF177224@ls.amr.corp.intel.com>
 <Zdzdj6zcDqQJcrNx@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zdzdj6zcDqQJcrNx@google.com>

On Mon, Feb 26, 2024 at 10:50:55AM -0800,
Sean Christopherson <seanjc@google.com> wrote:

> Please post an RFC for _just_ this functionality, and follow-up in existing,
> pre-v19 conversations for anything else that changed between v18 and v19 and might
> need additional input/discussion.

Sure, will post it. My plan is as follow for input/discussion
- Review SEV-SNP patches by Paolo for commonality 
- RFC patch to KVM_MAP_MEMORY or KVM_FAULTIN_MEMORY
- RFC patch for uKVM for confidential VM
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

