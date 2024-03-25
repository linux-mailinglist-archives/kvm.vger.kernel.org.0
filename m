Return-Path: <kvm+bounces-12637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E63788B5B2
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 00:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F02F1C3509E
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CF28663A;
	Mon, 25 Mar 2024 23:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DZGH87cD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2D339BF;
	Mon, 25 Mar 2024 23:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711411161; cv=none; b=jFjB7cvY7MH45xdRjY2f0ejdiTNqFuw2BJ7sZkyV2ccRHW482SjbUAA6vbmPPuxrkp6aMiFpEL9j+d5YFhcZIqWqA2yVF/JqbQSHNxUow70fRAWKHstEhZkDs0hOR3nCKh5GMuN7P+GKwqnb41I7XIAJE+wVznJKIChYsT7Ogz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711411161; c=relaxed/simple;
	bh=weMSH2HY5gtyciUxIFxfYnwP9q0mVKBCRDJIjHcLgeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaOrlEg96dlGilwzcqlEC3RKVZoZ7HQQ/4RC664teNUW25XOE2Ti9vPJYF968GwT8FiyCS/NsQLcROi9zfBu8mtEoYsszgshrJnoKzmZUUWCng2zhsPNrrWQYIRR67HUIl51xXLILbABr7TPaJq+Y9k9tVF/gUr03T9YKvkgnhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DZGH87cD; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711411159; x=1742947159;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=weMSH2HY5gtyciUxIFxfYnwP9q0mVKBCRDJIjHcLgeE=;
  b=DZGH87cD1zkE+Xotd1TyPxAiL2lgkjFaGGP0wkJF8kQtHcJcqyM2QCmB
   zI6ZwhBrwXKc7RilBBgXJp9rEUSB9LG1R9wVPoWQoOZPYFteMWILwJLYb
   UD6FgY843NWPdebNtQW8nHPV6lNYayk10rPkCwUL8iW5UjAte2bb+7ILx
   Gw52LmLA09V8MEnEqcr36KAisTYgnp82gPIQdPDpm6EBsrAV/1N/QQoQH
   hqWXW/R8Baf/L/Rsl8W1wkzb7/Os3j3J1ne1liOtQUp1qnLYmC2mQ/vW1
   2pdZQWs95qoZjtw2unIfNciEwFu/HYP614ebNUov2zxkkDwFXnzzVqg4E
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="31880425"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="31880425"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:59:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="46938419"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:59:18 -0700
Date: Mon, 25 Mar 2024 16:59:18 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com,
	isaku.yamahata@intel.com, seanjc@google.com,
	isaku.yamahata@linux.intel.com, rick.p.edgecombe@intel.com,
	xiaoyao.li@intel.com, kai.huang@intel.com
Subject: Re: [PATCH v4 05/15] KVM: SEV: publish supported VMSA features
Message-ID: <20240325235918.GR2357401@ls.amr.corp.intel.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
 <20240318233352.2728327-6-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240318233352.2728327-6-pbonzini@redhat.com>

On Mon, Mar 18, 2024 at 07:33:42PM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Compute the set of features to be stored in the VMSA when KVM is
> initialized; move it from there into kvm_sev_info when SEV is initialized,
> and then into the initial VMSA.
> 
> The new variable can then be used to return the set of supported features
> to userspace, via the KVM_GET_DEVICE_ATTR ioctl.

Hi. The current TDX KVM introduces KVM_TDX_CAPABILITIES and struct
kvm_tdx_capabilities for feature enumeration.  I'm wondering if TDX should also
use/switch to KVM_GET_DEVICE_ATTR with its own group.  What do you think?
Something like

#define KVM_DEVICE_ATTR_GROUP_SEV       1
#define KVM_X86_SEV_VMSA_FEATURES       1
#define KVM_X86_SEV_xxx                 ...

#define KVM_DEVICE_ATTR_GROUP_TDX       2
#define KVM_X86_TDX_xxx                 ...

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

