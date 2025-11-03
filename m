Return-Path: <kvm+bounces-61899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A44C2D83F
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 371D1423547
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 17:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8250C31B131;
	Mon,  3 Nov 2025 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HGe5wLU5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5405C31A815;
	Mon,  3 Nov 2025 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191666; cv=none; b=ueYuCiD3aOcXxv3Bal5vpzkiGxalvNgVSw1IM4fLUJt/gDe8Gv15K5MRo9jjedG20PvlGq1WHcl4kRwK9rwT7jwOaTsJXgAUZK0YO1Pa4QEhJ2LWi0GeIfE/Fl5unIaPYil1hCNtm/06xAF93O8Kvp5pT5gLRrip3B8DUQw+7SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191666; c=relaxed/simple;
	bh=blIcHAMRAe5V33UqQcWdFv858LTncTJy6mR9QrwJqE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWYG+/B/fZQa/O1UMJhWnZfBkwldpWPcXq53JyWLNfzmsam7wTV/kL/qJMfEQ/8n2KajeuICE+lSrcIwP4ZBKenv2WwqsFzLKblkMpW9nU6Mqgc0R5+tsfpFzaWJ/qg095om4RWqkDnz+zQG3u6/0Oq/OUbAiF3yWywOUUgLoeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HGe5wLU5; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762191663; x=1793727663;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=blIcHAMRAe5V33UqQcWdFv858LTncTJy6mR9QrwJqE8=;
  b=HGe5wLU5IrNQqvkpsJ2a5UTttXMOTE7t6wc3kPqeVFLi6EVOC8YSavJE
   7XHqZzjjvkDqM40IRXzsI4tkRJ5yor6fSfEufLMdqpPaIiQK2awNcYuJA
   dhQoMVpUG+Td3yI84mem4SphjALXVuY3bB1iYa80Bh+SUyYlfOyBfRNj5
   ivkmPyoyMDGlHsgeeoKipU4+hXCDXN63gzOIyEFfXEaljC5QVVVkyzlXy
   WR+fQlDyd9+jzHuTeJQTkI6NeSmv053PLYbcIaB9DG8LT0ZJa4s4YkB3/
   Y3KPKn2sUSRBtmfRDXh7NCxEbs1/Vf5S8pEvAOWy7GzdNUiPzYWlLGjxi
   w==;
X-CSE-ConnectionGUID: 1mpYLa7QQRW7NaNFFiYwuA==
X-CSE-MsgGUID: 5nFm06YcQSyY/NVi5LG/6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="67929170"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="67929170"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 09:41:03 -0800
X-CSE-ConnectionGUID: ehrOoC5cQXe9ONWPZA14oQ==
X-CSE-MsgGUID: hGNQs13GQgqBj7kTRLrcUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="186876832"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.244])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 09:41:02 -0800
Date: Mon, 3 Nov 2025 09:40:57 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 2/8] x86/bugs: Decouple ALTERNATIVE usage from VERW
 macro definition
Message-ID: <20251103174057.lovxpwpznkpl6bcv@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-3-seanjc@google.com>
 <20251101041324.k2crtjvwqaxhkasr@desk>
 <aQjfwARMXlb1GGLJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQjfwARMXlb1GGLJ@google.com>

On Mon, Nov 03, 2025 at 09:00:48AM -0800, Sean Christopherson wrote:
> On Fri, Oct 31, 2025, Pawan Gupta wrote:
> > On Thu, Oct 30, 2025 at 05:30:34PM -0700, Sean Christopherson wrote:
> > > Decouple the use of ALTERNATIVE from the encoding of VERW to clear CPU
> > > buffers so that KVM can use ALTERNATIVE_2 to handle "always clear buffers"
> > > and "clear if guest can access host MMIO" in a single statement.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

