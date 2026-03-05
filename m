Return-Path: <kvm+bounces-72785-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKyLNX4HqWlW0QAAu9opvQ
	(envelope-from <kvm+bounces-72785-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:33:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D21220AD4B
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DD7733024EE7
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503BA27510B;
	Thu,  5 Mar 2026 04:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U6rX7/Ky"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CAD1F936;
	Thu,  5 Mar 2026 04:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772685179; cv=none; b=qBVKtGh6qBF7wOM0iFF52dWlELXdViFytGJssbbWuY+PP2J+gGMeHdvnYmCYHH7K+3dJFIjlqBNjnLYfF/dBKx1jZZ8OwuL45JQpvbq940gzSoaTP+TUVjT2ArWw9JkM4x9/VCuRTDh1m/XhBQ6YTPOFkEE/OFdbXwlU4ix7HVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772685179; c=relaxed/simple;
	bh=sey/vW6tzCKlEWT523imCveqwybENurz2eDJ3w2DBcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cOJ+gWWDe/rGZWFYJ8uW7WbvB+6esOvMIm5zmaIK4/FtCNZmHJOYAHvq+bQsEFSBvhDIMUkUeWPIR8gnh4y9xqEg6WBC/oWzTZ2QyZpPnZYE4NCvafRWNrMHAakiu9G5RhPoTWkCXBiLJbB6HggC5dHdtXl3GaD/8FBlD5212Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U6rX7/Ky; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772685178; x=1804221178;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sey/vW6tzCKlEWT523imCveqwybENurz2eDJ3w2DBcQ=;
  b=U6rX7/Ky1emIZSO//BoMja8Y1WapPBQ6Q1TTp3sUoe4BUIko8MSWhttx
   gnly+CAjtEwrzEuMaPOtb4t/vcMHql9M2TozalxQHsMje0vd3/vlWxH6O
   KuahRTd5LJaNDexn+BunddrU6URkmeUjRKZePfK8pk2uOEdhOgfGAveaU
   Ex6RQUZUxINXgj3chOvAO5TmHNa2ou3Xvg7TcfDAHoihy9dGa9u2UYrIc
   /aNz+rHpKB2e8eRxXTs2C7xfToU2z50EIZ0HPSXrZ9lFEf1t/DfGGmCsH
   ZN47w8tURn6bRuhV7XrSJDQjoNmxZFWXfFHv7uUY/WzMkgQh+rWq+OJ18
   w==;
X-CSE-ConnectionGUID: QAN7ya9WQGOISaBlVFikCA==
X-CSE-MsgGUID: Fsr/U4b9RhaWf3eY/2NDcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="77605104"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="77605104"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 20:32:58 -0800
X-CSE-ConnectionGUID: j+azb6n0RPug0EgTYoxo+Q==
X-CSE-MsgGUID: U/HE2gaLTLabzSpb8WaTwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="223048221"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 04 Mar 2026 20:32:52 -0800
Date: Thu, 5 Mar 2026 12:12:59 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	binbin.wu@linux.intel.com, tony.lindgren@linux.intel.com,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 10/24] x86/virt/seamldr: Allocate and populate a
 module update request
Message-ID: <aakCyyYsZa1sqyNP@yilunxu-OptiPlex-7050>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-11-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212143606.534586-11-chao.gao@intel.com>
X-Rspamd-Queue-Id: 7D21220AD4B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72785-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 06:35:13AM -0800, Chao Gao wrote:
> P-SEAMLDR uses the SEAMLDR_PARAMS structure to describe TDX Module
> update requests. This structure contains physical addresses pointing to
> the module binary and its signature file (or sigstruct), along with an
> update scenario field.
> 
> TDX Modules are distributed in the tdx_blob format defined at [1]. A
> tdx_blob contains a header, sigstruct, and module binary. This is also
> the format supplied by the userspace to the kernel.
> 
> Parse the tdx_blob format and populate a SEAMLDR_PARAMS structure
> accordingly. This structure will be passed to P-SEAMLDR to initiate the
> update.
> 
> Note that the sigstruct_pa field in SEAMLDR_PARAMS has been extended to
> a 4-element array. The updated "SEAM Loader (SEAMLDR) Interface
> Specification" will be published separately. The kernel does not
> validate P-SEAMLDR compatibility (for example, whether it supports 4KB
> or 16KB sigstruct); userspace must ensure the P-SEAMLDR version is
> compatible with the selected TDX Module by checking the minimum
> P-SEAMLDR version requirements at [2].
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

