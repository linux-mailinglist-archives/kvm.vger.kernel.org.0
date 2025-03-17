Return-Path: <kvm+bounces-41218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89442A64BC5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CD88188A4DF
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44AB23496F;
	Mon, 17 Mar 2025 11:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Us+87GYm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B55A230BC9
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742209643; cv=none; b=dZXrzevIGXpCysJWae2ZrcWNnTKs0fJrCjQT1KwpkYCMXItek7cot12aZ0ofaNxojq6n8WtQryxxIeMeBy9Tiv8EILmEX0G2Gp1y+6KJbCd8a0B1M69ALC0BTmx0gXylqBAnaV4tXltn39+JQ8dhDNOWBA/lsFj1DDrMNfAVAFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742209643; c=relaxed/simple;
	bh=k5W7aJHoyc9RtxT/s/LlELHVqJxMJ6x+kzqirpBGnKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BzMBFViS+cnHfTm8yQ+PcfRkbCawyar8C7SUUEfkMsBRYVvHfk8MOXM98xKHJnVFuwxq9w7GO3+W5KH05BQlnZkeyk5h3U15T4sO77oW/pedRhS3TeSq1Jy+yEr2dxGoJshEUJKjKfaJj8EAhUUelkLPLgcggPdqdikJVXISblg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Us+87GYm; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742209641; x=1773745641;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k5W7aJHoyc9RtxT/s/LlELHVqJxMJ6x+kzqirpBGnKw=;
  b=Us+87GYmxfVvb1hVdSb4aZXv/3w3mbASo83sF2bDFNDmP/sql9XWflx0
   O73xyjOvsEu+ZWHDa2D2fRoXvjOY3CJvn91XlPySaWqz2rKrkRxYlAWMO
   +C23ECYua/Ud2y/i/aKEasY6aFIunqtBRPgGTyTVF70KEpiJhYnyLmEq/
   FalEd9kcysq707jzy6N3azd4alCyn48W7gMyJ1w1/A1S5xsI7F9HU72/Y
   w/5D3XIQmayjiFkqxtNQTFWBS6GHfSdpj933lzC9geXz8CGzZEZvRbrjx
   2j5lYwe2PbetX7bVNdQaczsVz6nAXHzajzAXQwJOTJ6HnitP0CJ9Y6EQ2
   w==;
X-CSE-ConnectionGUID: dXe8XDLVQ/q7nDldBSxoAg==
X-CSE-MsgGUID: 9zu+U1jrTae8txi1KGpPVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="53506223"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="53506223"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 04:07:21 -0700
X-CSE-ConnectionGUID: Et/mW7WVSZOPEjjd1Rwh2A==
X-CSE-MsgGUID: JJvGKHbUQXq/o17sPaI4Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="121710785"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.8])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 04:07:15 -0700
Date: Mon, 17 Mar 2025 13:07:10 +0200
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
Message-ID: <Z9gCXoWhTxzurXvb@tlindgre-MOBL1>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
 <Z9e-0OcFoKpaG796@tlindgre-MOBL1>
 <b158a3ef-b115-4961-a9c3-6e90b49e3366@intel.com>
 <Z9fvNU4EvnI6ScWv@tlindgre-MOBL1>
 <ebc6f8ed-3525-4bd8-8be0-143b1c7e75ee@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc6f8ed-3525-4bd8-8be0-143b1c7e75ee@intel.com>

On Mon, Mar 17, 2025 at 06:21:13PM +0800, Chenyi Qiang wrote:
> 
> 
> On 3/17/2025 5:45 PM, Tony Lindgren wrote:
> > On Mon, Mar 17, 2025 at 03:32:16PM +0800, Chenyi Qiang wrote:
> >>
> >>
> >> On 3/17/2025 2:18 PM, Tony Lindgren wrote:
> >>> Hi,
> >>>
> >>> On Mon, Mar 10, 2025 at 04:18:34PM +0800, Chenyi Qiang wrote:
> >>>> --- a/system/physmem.c
> >>>> +++ b/system/physmem.c
> >>>> @@ -1885,6 +1886,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
> >>>>              qemu_mutex_unlock_ramlist();
> >>>>              goto out_free;
> >>>>          }
> >>>> +
> >>>> +        new_block->memory_attribute_manager = MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
> >>>> +        if (memory_attribute_manager_realize(new_block->memory_attribute_manager, new_block->mr)) {
> >>>> +            error_setg(errp, "Failed to realize memory attribute manager");
> >>>> +            object_unref(OBJECT(new_block->memory_attribute_manager));
> >>>> +            close(new_block->guest_memfd);
> >>>> +            ram_block_discard_require(false);
> >>>> +            qemu_mutex_unlock_ramlist();
> >>>> +            goto out_free;
> >>>> +        }
> >>>>      }
> >>>>  
> >>>>      ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
> >>>
> >>> Might as well put the above into a separate memory manager init function
> >>> to start with. It keeps the goto out_free error path unified, and makes
> >>> things more future proof if the rest of ram_block_add() ever develops a
> >>> need to check for errors.
> >>
> >> Which part to be defined in a separate function? The init function of
> >> object_new() + realize(), or the error handling operation
> >> (object_unref() + close() + ram_block_discard_require(false))?
> > 
> > I was thinking the whole thing, including freeing :) But maybe there's
> > something more to consider to keep calls paired.
> 
> If putting the whole thing separately, I think the rest part to do error
> handling still needs to add the same operation. Or I misunderstand
> something?

So maybe you suggestion of just a separate clean-up function would work:

new_block->memory_attribute_manager =
    MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
if (memory_attribute_manager_realize(new_block->memory_attribute_manager,
    new_block->mr)) {
    memory_attribute_manager_cleanup(...);
    goto out_free;
}

> >> If need to check for errors in the rest of ram_block_add() in future,
> >> how about adding a new label before out_free and move the error handling
> >> there?
> > 
> > Yeah that would work too.
> 
> I'm not sure if we should add such change directly, or we can wait for
> the real error check introduced in future.

Right, not sure either.

Regards,

Tony

