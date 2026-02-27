Return-Path: <kvm+bounces-72140-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mMCuAid4oWnJtQQAu9opvQ
	(envelope-from <kvm+bounces-72140-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 11:55:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5AE71B6416
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 11:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E22B13050677
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 10:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16E13ED11B;
	Fri, 27 Feb 2026 10:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WOnaCmCP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300373B5303;
	Fri, 27 Feb 2026 10:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772189727; cv=none; b=VWVsJVPiOo0uzPuaNVWRk2STsX8xjaAc8Pm6UONyONEbslPBoQtblLjJMHbktTzkA++JEI48nMW+0oE8FnNNDabtT0yrXrotoALVgznd7VPdPUcsgTccoO0ybDm7A5GsvQ7loszeo5PR1Osqa13tIhqPyHLzJVFIjBcVF/R7j/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772189727; c=relaxed/simple;
	bh=ZUDEZcsRtwBEe88gHbz69DrIqh0LDqpYEV/7C1CV9h0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrNz9VVAMVazNVu9qZ9cBEL1zSYtQPWE1xq8m7UMFhiWOTtP87Ae36nQ7kklnUKi5XslchFSD4vmluHqLe5RYFHcq9//V/iPyGXHudYq+edQkm1NR9FgIcOuvp7x7scKEYHaFHyf/8z7SCQvxnDauKrt9Ei+kRfG7HHyzKamPRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WOnaCmCP; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772189726; x=1803725726;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZUDEZcsRtwBEe88gHbz69DrIqh0LDqpYEV/7C1CV9h0=;
  b=WOnaCmCPST+4NM4mMqOwfStShcbjOqY/F8F/14bOPS/gi/m7Z1PdX9CC
   bMr19O8RiSfE1EC5tbRD44HT0/5Cy5Tx6hQuzLJb9miKzHH8hCba3n3mC
   ZmQEks8RFmaxdDLnTwIPqJ2TsF4r4aWLpIvQA6fF7G/MRn2mm7ChYg9XQ
   6tp3YvdBYEh0ZvM3VsTd9Cgjg4dHhZM6VccWJGILDoJv21Gy7POZfH2Nd
   eUYrjD6Q2p0B8ita+D+X3U2G6M6Vvv0BsJzU+/WonY3xiln693fUVXEuZ
   C5SaVphuZPzkgg6rZa6FIknihLVT9z4JNqnWDQJDlxlkaL/63sMvwBLH+
   g==;
X-CSE-ConnectionGUID: M9T1WSa7S3eRnYITx4f/ig==
X-CSE-MsgGUID: TjwOv7yTRSS00dtew/PNSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="90672793"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="90672793"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 02:55:25 -0800
X-CSE-ConnectionGUID: fCi2m3PSQBqFpkykLqg9jQ==
X-CSE-MsgGUID: QIvwpn3YQW67BxTY5O5a1g==
X-ExtLoop1: 1
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 27 Feb 2026 02:55:20 -0800
Date: Fri, 27 Feb 2026 18:35:44 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Fuad Tabba <tabba@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	michael.roth@amd.com, vannapurve@google.com
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
Message-ID: <aaFzgGTpZI0eZWdD@yilunxu-OptiPlex-7050>
References: <20260225075211.3353194-1-aik@amd.com>
 <aZ7-tTpobKiCFT5L@google.com>
 <CAEvNRgEiod74cRoVQVC5LUbWDZf6Wwz1ssjQN0fveN=RBAjsTw@mail.gmail.com>
 <20260226190757.GA44359@ziepe.ca>
 <aaDL8tYrVCWlQg79@google.com>
 <20260227002105.GC44359@ziepe.ca>
 <aaDlRdnhIqRXEbPZ@google.com>
 <20260227010902.GE44359@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227010902.GE44359@ziepe.ca>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72140-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:dkim]
X-Rspamd-Queue-Id: E5AE71B6416
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 09:09:02PM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 26, 2026 at 04:28:53PM -0800, Sean Christopherson wrote:
> > > I'm confused though - I thought in-place conversion ment that
> > > private<->shared re-used the existing memory allocation? Why does it
> > > "remove" memory?
> > > 
> > > Or perhaps more broadly, where is the shared memory kept/accessed in
> > > these guest memfd systems?
> > 
> > Oh, the physical memory doesn't change, but the IOMMU might care that memory is
> > being converted from private<=>shared.  AMD IOMMU probably doesn't?  But unless
> > Intel IOMMU reuses S-EPT from the VM itself, the IOMMU page tables will need to

Intel secure IOMMU does reuse S-EPT, but that doesn't mean IOMMU mapping
stay still, at least IOTLB needs flush.

> > be updated.
> 
> Okay, so then it is probably OK for AMD and ARM to just let
> shared/private happen and whatever userspace does or doesn't do is not
> important. The IOPTE will point at guaranteed allocated memory and any
> faults caused by imporerly putting private in a shared slot will be
> contained.
> 
> I have no idea what happens to Intel if the shared IOMMU points to a
> private page? The machine catches fire and daemons spawn from a
> fissure?

Will cause host machine check and host restart, same as host CPU
accessing encrypted memory. Intel TDX has no lower level privilege
protection table so the wrong accessing will actually impact the
memory encryption engine.

> 
> Or maybe we are lucky and it generates a nice contained fault like the
> other two so we don't need to build something elaborate and special to
> make up for horrible hardware? Pretty please?
> 
> Jason

