Return-Path: <kvm+bounces-2993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B41077FF8FE
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F97A281835
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687BA59143;
	Thu, 30 Nov 2023 18:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pbnp6Xui"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D371D103;
	Thu, 30 Nov 2023 10:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701367318; x=1732903318;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=54gTn1gRLLouIJlaQjeLN+mpwCM7NSqeeWXZaSfmCkI=;
  b=Pbnp6Xui6iOEZqHhAfc75E8BI4oPE2oVtIjEkeTe6mdaUOkzhz75GEkv
   96YjddWgKqQoFkjrwbi0Y0DWWQwfW3MXCVOOvPX4wJOu5dvOXLGtGBZ1m
   LGAPWOPhnkSUX8vyCbAf53g9DPTu/D0p9ptSMADRCj0n6XHPUWik9hQGj
   NPs2FU6tGBzNTjLJKrxHhKDc+YsjKGPo0gZCguQ9hxquYKJF6dmV5fpTc
   riXqoQVix+BYIL7N8a3tXH1cQeGJbdEda96u+Bw20r8Rw4di6LT1Ont2D
   WeU7Q0wyC6ky389PGr2j1pUwHzXFdu6Vh63+YPCR4j7YE2WmvP33nf/6q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479568783"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479568783"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 10:01:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="762811323"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="762811323"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 10:01:46 -0800
Date: Thu, 30 Nov 2023 10:01:45 -0800
From: Tony Luck <tony.luck@intel.com>
To: Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
	peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
	mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
	dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
	isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
	bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Message-ID: <ZWjOCWRuW9QBchql@agluck-desk3>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>

On Fri, Nov 10, 2023 at 12:55:59AM +1300, Kai Huang wrote:
> Instead of modifying above error log, improve the error log by printing
> additional TDX related message to make the log like:
> 
>   ...
>  [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>  [...] mce: [Hardware Error]: Machine Check: TDX private memory error. Possible kernel bug.

This seems a reasonable addition.

>  arch/x86/kernel/cpu/mce/core.c |  33 +++++++++++

Reviewed-by: Tony Luck <tony.luck@intel.com>

[I only reviewed the hooks into mce/core.c I don't feel qualified
to dig through the TDX bits that determine this is a TD private page]

-Tony

