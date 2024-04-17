Return-Path: <kvm+bounces-14997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 748BF8A8B0E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AC751F22874
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 18:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AF9174EC2;
	Wed, 17 Apr 2024 18:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KWD0C9J9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CE217109A;
	Wed, 17 Apr 2024 18:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713378545; cv=none; b=JhAWJBFObvZtwAt1QK4ZSEBBt/0dT0OrDwAC3+1EE5bfTOAiAMwKiIqIsqXk722sUZEGrLjKajP8tgPwfAlzhw/kcL01D/gBcYo+bedehmB+DRSPhAf6TlX6J+p3DBGH0alTfcTeHKll4Tc7dnPqYscpNuhvE39SX/2yHadXXVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713378545; c=relaxed/simple;
	bh=7JxodzQRkS4oLXtGyeYNgNUOYAZp5D+/snGgqcQC0YI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jHUZMlWXGfosDAUnAmmFfn1ZvkmnIJrn/Sv0DWvIvqy7AAOlDCc+QESDNoTHAocpdHwHMWNo4W6tA69J1IbxAT1ByAj9W+FDovJhgy7vFAsWXcqLr1b3SlWeL15iTgvykyK7DQlRnzaFoXQur07T0qqRkUKYhAafX5fc/x/SubQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KWD0C9J9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713378544; x=1744914544;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7JxodzQRkS4oLXtGyeYNgNUOYAZp5D+/snGgqcQC0YI=;
  b=KWD0C9J9ZkG1JL45yPDa02z7DRhMK994m0fTOtUEqhdYYt1ypfjC3Y2P
   PFpchHEJgqZKaSbCwg9rK0+vHWDX8Ouz0aYYLkaEtSz2DcGNemEdDqa/1
   xeMAqANjjOOtCu3Sb19d2pDI4J+TFA0GDw/Yvn5REPYPE0Lf6e38UsHG5
   waKdIMhPhLeKMNlwmuHMoyHCOMhrr1ugDzbC73wW8yjYeWh3PHKTfKlCi
   HmqSeciXvSHfadYla9+x8lk0p3zyVMLnsOXR8zQiP7cx3fA7027AF6KF9
   yr4EEMaWuJtRhGQeToUOq0vXfcBRHBTW8cv43ruTuen5IRYxrkaAtgTiR
   g==;
X-CSE-ConnectionGUID: pYwIUtkyTJyW0SJ1X4JTzg==
X-CSE-MsgGUID: Z0PfnnTIQ5ynxffg8bLx5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19494053"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="19494053"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:29:04 -0700
X-CSE-ConnectionGUID: d1axhKYFRM+l2l6LO09SLQ==
X-CSE-MsgGUID: sYo3gvWTTcyX9Sjfi/U3kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="23306516"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:29:03 -0700
Date: Wed, 17 Apr 2024 11:33:37 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
 <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jens
 Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, Kevin Tian
 <kevin.tian@intel.com>, maz@kernel.org, Robin Murphy
 <robin.murphy@arm.com>, jim.harris@samsung.com, a.manzanares@samsung.com,
 Bjorn Helgaas <helgaas@kernel.org>, guang.zeng@intel.com,
 robert.hoo.linux@gmail.com, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 01/13] x86/irq: Move posted interrupt descriptor out
 of vmx code
Message-ID: <20240417113337.4a594901@jacob-builder>
In-Reply-To: <Zh8ZHPUlQk4niS7k@google.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-2-jacob.jun.pan@linux.intel.com>
	<Zh8ZHPUlQk4niS7k@google.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Sean,

On Tue, 16 Apr 2024 17:34:36 -0700, Sean Christopherson <seanjc@google.com>
wrote:

> "KVM" in the scope would be nice.
will change to "KVM: VMX:"

> 
> On Fri, Apr 05, 2024, Jacob Pan wrote:
> > To prepare native usage of posted interrupt, move PID declaration out of
> > VMX code such that they can be shared.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  arch/x86/include/asm/posted_intr.h | 88 ++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/posted_intr.h     | 93 +-----------------------------
> >  arch/x86/kvm/vmx/vmx.c             |  1 +
> >  arch/x86/kvm/vmx/vmx.h             |  2 +-
> >  4 files changed, 91 insertions(+), 93 deletions(-)
> >  create mode 100644 arch/x86/include/asm/posted_intr.h  
> 
> Acked-by: Sean Christopherson <seanjc@google.com>


Thanks,

Jacob

