Return-Path: <kvm+bounces-19526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45A82905EFB
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 01:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6CD6284FC5
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F8E12CD9D;
	Wed, 12 Jun 2024 23:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OFmkN0tD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1409D4315D;
	Wed, 12 Jun 2024 23:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718234011; cv=none; b=VJSscEi3p6qTSZPBeW4w+dCi0+CO9xnwworVxCrorZG/9JoPA6BO3zozUN+/2UbVCL6L1M+GzPgEQPzFZDUfTstb0VbQ52x/rKVjS6XI6FWqGENTIX4UtYcwQC16FJy6X2nVisTKeiQ9DUYuYT4iyxRjU8zEpIqpuoYJ01J6E24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718234011; c=relaxed/simple;
	bh=qnghZq2zQy7pKT1QVvrvOegUoeTABeUySW8sFn8c144=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iUh4pbNxfKTUC3d095XxVTTLUmuztCOPLomH96241y2mq/pqNTjV2ksH++K8pPjv2IyliKtfynSGKJ+F5QTGOWxk1r810Qvi/uXK3Dzr4L6k926zFDc7EA0X+8pTRY24dxKBIUR9KlreKV7wiL7Wn42m7lykm3Tg0F0H7lyFE3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OFmkN0tD; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718234010; x=1749770010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qnghZq2zQy7pKT1QVvrvOegUoeTABeUySW8sFn8c144=;
  b=OFmkN0tDwxEhnc1ih2hZ9y+54SsMaG2mEcxRDxC10RGqX9ufqhztuBcO
   U2IPc4VoGPQfhuzNnV8t5azUw5igAyD8DWknpqfFqFdvUn+8Qj5QTnJeu
   +A6+U6xUFlD5MZzuSemR9Q6TmqlYfVnjcvnGUwuLhorEJ0gkQPHhbsmMU
   27gkaO8riTozVOz1zF2yXEzbkeeEmT4ckk36lpgXYfsncUnrdBMg//iuL
   lfzYqwjhlUsUUHkFvm4wjiE4WzRqo6Tcf+XapC6p8gqNTOuRsnDW/D762
   +nK+26g3BbAzmZDBZ6CMeLtzc4ZohdKs2ez9a3BBhg9MSSHP3fzmAz0/0
   A==;
X-CSE-ConnectionGUID: zBaflUmSTf2m8zK9f8VoIQ==
X-CSE-MsgGUID: ct00syy2RHinkEOKW/9vKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="25663711"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="25663711"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 16:13:29 -0700
X-CSE-ConnectionGUID: 0sx/4wx5QROvGwdjp+SVbA==
X-CSE-MsgGUID: 5gEIKIrVRwWl/ZhIwvzm3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="40004765"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 16:13:29 -0700
Date: Wed, 12 Jun 2024 16:13:29 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH] KVM: interrupt kvm_gmem_populate() on signals
Message-ID: <20240612231329.GA1900928@ls.amr.corp.intel.com>
References: <20240611102243.47904-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240611102243.47904-1-pbonzini@redhat.com>

On Tue, Jun 11, 2024 at 06:22:43AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> kvm_gmem_populate() is a potentially lengthy operation that can involve
> multiple calls to the firmware.  Interrupt it if a signal arrives.

What about cond_resched() in the loop?  kvm_gmem_allocate() has both.

The change itself looks good for TDX because KVM_TDX_INIT_MEMREGION checks the
signal.  I can drop the duplicated check.  Similar to cond_resched().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

