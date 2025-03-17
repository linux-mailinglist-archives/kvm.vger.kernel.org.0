Return-Path: <kvm+bounces-41166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF99A6412C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 07:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4DE73A8361
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 06:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA532192EE;
	Mon, 17 Mar 2025 06:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y+a8xTuA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2491E1DFF
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 06:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742192348; cv=none; b=IayyDlkOYBxqJ17033rApXWU9XyPT9lIVjI7SmWMnMUZdJ0NH7edfxStwwQPSINRPrFJR+jE8d67F3RiYHLaNwD0Q+cyYxP3uNXKzf63nkbmIcKotFAGJ27HUhuOKmYJpZIblbyf1qIywuhjXKlqgrKjruk34ZHpAkrOuYfrm1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742192348; c=relaxed/simple;
	bh=h0BsSohuwjOJjBU5oHdhP3ZYhu82D4a41VuNYAddxVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ukw+JovGGMkL6FTgZFdFyGlEAcw4LApkameP+8A10IjU9bJdTth10J0fLPzECF8VDj57YPmPvY7ENKQ5Lovw6qTmSnK5GOyJUpgkqB6/waraCpYHJjag1BVMkOBG9NE0O6gX/ytI6d21WTxfJrqUa8DroYAFQDqm2wqRvZW3MRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y+a8xTuA; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742192347; x=1773728347;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h0BsSohuwjOJjBU5oHdhP3ZYhu82D4a41VuNYAddxVI=;
  b=Y+a8xTuAMmLzGTb/0TM67BAr3hkLKrZ0nbDB2oqqdyyQoUtzNy2sLnjd
   uT0E+YKURFRNEZ+NyovnmSR8JwPW84bQVdw55pAHOkse6/RH204wia6MH
   xhYOp4dnwyj8TzbSF9M4LoNOhXHsJ81+dJhpIxviCuv09qOEb9NwTefcP
   IN16MC4xp1G0XKw5qjbgNyxtmCNhqsAIULp4Qp72PAkB9xQjsCoHGuG8P
   XzAkIDw/3Gdt1ihivGte7R0uIbG5/sBNmdQlf2aaGr4cl2xaEWRBo6GX+
   mngRkaHg4gK0K5MMZWsH2+rdI6zXHMRm08Z5hWgqIZXwJ0d8PF3G1rtT/
   Q==;
X-CSE-ConnectionGUID: 6VLBoK1xTgCaeSoJNlgRuA==
X-CSE-MsgGUID: 5iCqc/5jR0SxgCNnkyUnew==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="60664465"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="60664465"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2025 23:19:07 -0700
X-CSE-ConnectionGUID: k0gWf8DHS9GhD4uHidG+4w==
X-CSE-MsgGUID: N//J7haCQVeK8ULxe6wvBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="122590083"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.8])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2025 23:19:01 -0700
Date: Mon, 17 Mar 2025 08:18:56 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	"Maloor, Kishen" <kishen.maloor@intel.com>
Subject: Re: [PATCH v3 6/7] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
Message-ID: <Z9e-0OcFoKpaG796@tlindgre-MOBL1>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310081837.13123-7-chenyi.qiang@intel.com>

Hi,

On Mon, Mar 10, 2025 at 04:18:34PM +0800, Chenyi Qiang wrote:
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1885,6 +1886,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>              qemu_mutex_unlock_ramlist();
>              goto out_free;
>          }
> +
> +        new_block->memory_attribute_manager = MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
> +        if (memory_attribute_manager_realize(new_block->memory_attribute_manager, new_block->mr)) {
> +            error_setg(errp, "Failed to realize memory attribute manager");
> +            object_unref(OBJECT(new_block->memory_attribute_manager));
> +            close(new_block->guest_memfd);
> +            ram_block_discard_require(false);
> +            qemu_mutex_unlock_ramlist();
> +            goto out_free;
> +        }
>      }
>  
>      ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;

Might as well put the above into a separate memory manager init function
to start with. It keeps the goto out_free error path unified, and makes
things more future proof if the rest of ram_block_add() ever develops a
need to check for errors.

Regards,

Tony

