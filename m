Return-Path: <kvm+bounces-7638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD35844E81
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:14:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBE9CB2C22C
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A533A1BD;
	Thu,  1 Feb 2024 01:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jDUw+sWu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC874A26;
	Thu,  1 Feb 2024 01:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706749935; cv=none; b=IxRyseWTeEvOXOK2yprsKGwBjqouUUx2jxIkCTnu4UXVQy2X+hntOLZrQPZCds3h4FkxPl/s8nsDq3e2Xsfdvz9J5rMYcM8Wm1ZbZWNz/q3/WJcemZ8PHAeCKIvT2RmOrB5mP446WL+n7y9s1dQv73Bt1rCyishxIHu4YDxC5L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706749935; c=relaxed/simple;
	bh=rRJkOiEWWx+MaAyf5EYSwy92FdMDJ+1rmyiEUoTvRww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9Hl/a++NriKw8JoKt8+viuFSsScB2jGZLAJo99hUUk1DlZiDir5UfaQ+kXILfdj9RWKLeQSXW1k51H/QzZ3YLW4IlpIoi5VoZUZQFSQPmRPp1O79jLiJ1sJaagFNqotDpUgMbzjiiY3VfCCsH/nLAzif9ogKQff/tqfIj+gDNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jDUw+sWu; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706749935; x=1738285935;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rRJkOiEWWx+MaAyf5EYSwy92FdMDJ+1rmyiEUoTvRww=;
  b=jDUw+sWuUGzkQWZ49aXwc93QNylB113iVYHBxqyF3+EGz5cAt3loW3jv
   YSVQhhX72HIOop/Yb2JBg5hgLTQvB4L/x1qmIgCj+neQVGcBd+pd1Q8lG
   FqvRTvqrjzyeP34CRdYRbz9v7IKKbGn91XQqnIZs+1ug6LVw11cWs2IYE
   dtulHhdgE4PW3xVQWSemtkH8bUycYygxGwP0eec4xTg1zpHBRqwc7dic5
   L2RaUFjJLlpGBnYDMnsTMTJ253SJN98bbzSM1HWLbuGhO6ju819NCwl4i
   6eshRT+lv7qk4LWIUFYsMC69N/eHAOjCJCgTtjoOlN0sKBUMQL9oAPHGN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="2714366"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="2714366"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:12:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="961771144"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="961771144"
Received: from hlhunt-860g9.amr.corp.intel.com (HELO desk) ([10.251.15.168])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:12:12 -0800
Date: Wed, 31 Jan 2024 17:12:05 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  v6 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20240201011129.rmuhpl6iwpozpll6@desk>
References: <20240123-delay-verw-v6-0-a8206baca7d3@linux.intel.com>
 <20240123-delay-verw-v6-6-a8206baca7d3@linux.intel.com>
 <ZbQkyr8c12jOqWQ-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbQkyr8c12jOqWQ-@google.com>

On Fri, Jan 26, 2024 at 01:31:54PM -0800, Sean Christopherson wrote:
> On Tue, Jan 23, 2024, Pawan Gupta wrote:
> > During VMentry VERW is executed to mitigate MDS. After VERW, any memory
> > access like register push onto stack may put host data in MDS affected
> > CPU buffers. A guest can then use MDS to sample host data.
> > 
> > Although likelihood of secrets surviving in registers at current VERW
> > callsite is less, but it can't be ruled out. Harden the MDS mitigation
> > by moving the VERW mitigation late in VMentry path.
> > 
> > Note that VERW for MMIO Stale Data mitigation is unchanged because of
> > the complexity of per-guest conditional VERW which is not easy to handle
> > that late in asm with no GPRs available. If the CPU is also affected by
> > MDS, VERW is unconditionally executed late in asm regardless of guest
> > having MMIO access.
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> 
> Acked-by: Sean Christopherson <seanjc@google.com>

Thanks.

