Return-Path: <kvm+bounces-64533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0FD8C864BF
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B8D63AA5DE
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398A632D0DF;
	Tue, 25 Nov 2025 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GdJcVz3/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F61632C925;
	Tue, 25 Nov 2025 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092751; cv=none; b=jPKsU+ziVXAssbtLzbUTfrj+MsxBejmW0m9vTn5VAYvRF3gcbjODFzZqphPa05piXjZQeBfr4ZzyL25XfZGcLMwfH6m8GEnpQrdcBfKQzaBb9iqfD7l7qBc+85XBoQVzNio4aG1qVQP2CGk3S7rjnsxdeZ/oxiGfTw8A+JpFQhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092751; c=relaxed/simple;
	bh=+k1k+0kNP1/FSg/EwboNrPe6JpRIwqq2uHtKXTABx/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLucYb+1nhZU8OECOpbtHJwy09qTxauUkKXG6vtox54nYmLi22dZFuFZsISE/mJAn0JC5OwXzJ2y9LFUHhKrOmYIIOnI0l18l5o7gexXmFcusTKM8N9ysNmv8x1uzmWyT8wDAlqjq7xSfgFrT/94TsP/LiXrSmYu6dZZXW0zdCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GdJcVz3/; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764092749; x=1795628749;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+k1k+0kNP1/FSg/EwboNrPe6JpRIwqq2uHtKXTABx/w=;
  b=GdJcVz3/synrVPe/rKgDYCg7tWVXH5QLI/5t8VKAJz36rfESPPVq8LVh
   i9rs9XwUPKEdzGG6db0Wkv0RfWkrJtRdTajRUG4zCrIf/YtzP95GQ1M7d
   2OvcD3KekF7CRdyjnIlFjSYk1QXgxMm0AGQbBWJPkaaBod7xjNnYyGZXI
   xNX5/X0kWLZxYqfx8jugJ2bHMl4F6FRSZVZ5iiBVWv4ShTI7/m1lYaef7
   23B1hRSFlrSEDuHcYfP7dlZU9pUBF56qUxX+JUhwSczjdaGNUjjMS8ZRH
   tVMqL74lDSNtG9j7qKMJwk91mgsTvFMAR9tKOfm3ieVd/Zm6b8FS0vhNr
   w==;
X-CSE-ConnectionGUID: pVZVV6nWQeitpzLcR0tY/Q==
X-CSE-MsgGUID: /b18DgZ8RW2K60LfmA1EAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="69980689"
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="69980689"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 09:45:49 -0800
X-CSE-ConnectionGUID: FM2phuGuQ3WOa80aQAE0QA==
X-CSE-MsgGUID: kzShMvR1QLqOhXQIXMvntA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="223665757"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 09:45:47 -0800
Date: Tue, 25 Nov 2025 09:45:41 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v4 06/11] x86/vmscape: Move mitigation selection to a
 switch()
Message-ID: <20251125174541.7lgjdfwws4ios4vg@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-6-1adad4e69ddc@linux.intel.com>
 <c8d197cb-bd8d-42b0-a32b-8d8f77c96567@suse.com>
 <20251124230917.7wxvux5s6j6f5tuz@desk>
 <c1b67fb1-0ef9-4f23-9e09-c5eecc18f595@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1b67fb1-0ef9-4f23-9e09-c5eecc18f595@suse.com>

On Tue, Nov 25, 2025 at 12:19:32PM +0200, Nikolay Borisov wrote:
> > FEATURE_IBPB check is still needed for VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER.
> > I don't think we can drop that.
> 
> But if X86_FEATURE_IBPB is not present then all branches boil down to
> setting the mitigation to NONE. What I was suggesting is to not remove the
> that check at the top.

BHB_CLEAR mitigation is still possible without IBPB, with that IBPB check cannot
be at the top. This patch prepares for adding BHB_CLEAR support.

Sure I can delay moving the IBPB check to later patch, but the intent of
splitting the patches was to keep the patch that move the existing logic
separate from the one that adds a new mitigation.

