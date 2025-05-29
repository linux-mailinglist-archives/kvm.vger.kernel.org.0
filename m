Return-Path: <kvm+bounces-47925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9144AC767F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ABEE3A689A
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 03:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFDA247295;
	Thu, 29 May 2025 03:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PQrC9X+w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDA737160;
	Thu, 29 May 2025 03:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748489776; cv=none; b=ajl0EPbVmjPFKBjVGvGi7iWzeKmlfFiX8GJ/iHMoyeiZy44j0l3O1FPl/boaum5JX6yL+N0Fdx4p2J+hc/8TRlB4Onug5Fy2TB/bVYdzzBt5NCdUgBrw6bQRn5ZCkFbPa1wEVclIND+o3C4P5tmXo/DYK4Od8yhHymS+vFrP4q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748489776; c=relaxed/simple;
	bh=lRqn/UeUDAVuP4Z63wj0d9rZVJKOlvjsWLtn1Fw9j3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j66O+SH1VEOUZ9ykCJTKt/c7m79xPss0amXf/52v7VXs36QELUjHmRBVP6Rv1OoQGGyas+qXqRzLkiE5SuG72Vd0PbW6wIToZyoKPp0BSwH8ChjaaL5JASb+skTxanISdGjeQQzIHzgTmehpXK4ZGHqzHzNCW6JygWZnTfOcUfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PQrC9X+w; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748489774; x=1780025774;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lRqn/UeUDAVuP4Z63wj0d9rZVJKOlvjsWLtn1Fw9j3I=;
  b=PQrC9X+wtEPCNP0XD/NgOppEKG4EFs8rtxCA+xQ2Ni39toQcqIImnIDp
   coNJAYBtelYVcziX92H0tZYSAX/adN88h/H6TFT5J8OAWIeKrXqIgWylB
   bGwRu5cfL//VFYxqqDjseGLdyJ+PIfa5CjdFWvPzNgIwd5SOI0X2WqApX
   i1dOVo4IE9/lxC+JhS2YBIZlwts8e8Gw3+CX89LX55OOws7VCxNf7egsW
   WNMDmlrOQIuqkGBY/JCFltfYpYJJpgoVvMirHY7nf/0ONXkCxPT2zi699
   3JaMWBxc3tu2CJ+rEFRgE0RhTjrkFiiO6lOlXXzIAWe/ANr8f8T7C39UI
   A==;
X-CSE-ConnectionGUID: T6uzHaGTS56KYy+cy+cQmQ==
X-CSE-MsgGUID: eq2KFc62RVGL/RnNl6qslA==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="61590587"
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="61590587"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 20:36:13 -0700
X-CSE-ConnectionGUID: zvZ7gGsSQmyFeT8T4zDykw==
X-CSE-MsgGUID: scmTQcoETPaJwBpOc1tknQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="148476112"
Received: from josephbr-mobl1.amr.corp.intel.com (HELO desk) ([10.125.146.30])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 20:36:14 -0700
Date: Wed, 28 May 2025 20:36:07 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 0/5] KVM: VMX: Fix MMIO Stale Data Mitigation
Message-ID: <20250529033546.dhf3ittxsc3qcysc@desk>
References: <20250523011756.3243624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523011756.3243624-1-seanjc@google.com>

On Thu, May 22, 2025 at 06:17:51PM -0700, Sean Christopherson wrote:
> Fix KVM's mitigation of the MMIO Stale Data bug, as the current approach
> doesn't actually detect whether or not a guest has access to MMIO.  E.g.
> KVM_DEV_VFIO_FILE_ADD is entirely optional, and obviously only covers VFIO

I believe this needs userspace co-operation?

> devices, and so is a terrible heuristic for "can this vCPU access MMIO?"
> 
> To fix the flaw (hopefully), track whether or not a vCPU has access to MMIO
> based on the MMU it will run with.  KVM already detects host MMIO when
> installing PTEs in order to force host MMIO to UC (EPT bypasses MTRRs), so
> feeding that information into the MMU is rather straightforward.
> 
> Note, I haven't actually verified this mitigates the MMIO Stale Data bug, but
> I think it's safe to say no has verified the existing code works either.

Mitigation was verifed for VFIO devices, but ofcourse not for the cases you
mentioned above. Typically, it is the PCI config registers on some faulty
devices (that don't respect byte-enable) are subject to MMIO Stale Data.
But, it is impossible to test and confirm with absolute certainity that all
other cases are not affected. Your patches should rule out those cases as
well.

Regarding validating this, if VERW is executed at VMenter, mitigation was
found to be effective. This is similar to other bugs like MDS. I am not a
virtualization expert, but I will try to validate whatever I can.

> All that said, and despite what the subject says, my real interest in this
> series it to kill off kvm_arch_{start,end}_assignment().  I.e. preciesly
> identifying MMIO is a means to an end.  Because as evidenced by the MMIO mess
> and other bugs (e.g. vDPA device not getting device posted interrupts),
> keying off KVM_DEV_VFIO_FILE_ADD for anything is a bad idea.
> 
> The last two patches of this series depend on the stupidly large device
> posted interrupts rework:
> 
>   https://lore.kernel.org/all/20250523010004.3240643-1-seanjc@google.com
> 
> which in turn depends on a not-tiny prep series:
> 
>   https://lore.kernel.org/all/20250519232808.2745331-1-seanjc@google.com
> 
> Unless you care deeply about those patches, I honestly recommend just ignoring
> them.  I posted them as part of this series, because post two patches that
> depends on *four* series seemed even more ridiculousr :-)
> 
> Side topic: Pawan, I haven't forgotten about your mmio_stale_data_clear =>
> cpu_buf_vm_clear rename, I promise I'll review it soon.

No problem.

