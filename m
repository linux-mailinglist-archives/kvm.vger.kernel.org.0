Return-Path: <kvm+bounces-12542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0987A887680
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 02:54:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 210BFB21EF1
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 01:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A695617F3;
	Sat, 23 Mar 2024 01:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lPn4e+vW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB85A31;
	Sat, 23 Mar 2024 01:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711158864; cv=none; b=A3dyZT3Q94jgkkeEXiLf/voJkzENnDJc/52PDWxGeM/7NUNpkCJ3Ia74uJphifFngHnensE82QbJwUn+tn/ZWEYWjdpL2PN7rppDJEz7Z0qrqymuBUwiXvYYcFkjXYjesVG9jvC/mhsCasnGvaGIsgK7F9/j6DgtG9gtcoH732k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711158864; c=relaxed/simple;
	bh=kam8waLr/eysWsw1rWevDwTRepj3zWLidyXhVcMWhek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gXv03AvdEBQ4oyREMnQv0hKgvRx7I95NvzKcTHrZxnMsYnQkBb5vyKkbNoTdi4gnug1eQp9SFuqbKbyFYlgoYIZCFxwTx6arq3WklhB9uTcKVNVEfIAhF37gStzAjIWhHfnTxFEwqAe7RAy82YaiC/vxhW/XtQy9KITIAtjSgJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lPn4e+vW; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711158863; x=1742694863;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kam8waLr/eysWsw1rWevDwTRepj3zWLidyXhVcMWhek=;
  b=lPn4e+vWMCYW4PzW2gUxaR5yYiL7Fod5Z9tQZTri9Y8EgO7OSzHgnmsu
   SE9lXNueQi/LSdXYOgOPrJByfUTNqPNka1HKR1zIIqY/KKzcY4FM0OgUg
   5z48LpXzn+K6PO512qcGIPTAqGHBkaSYBuxwjYnd2x4eeFvGKG45c7apG
   7yilywJK/BXu0AebjqIZSeKxlOA+BOuZdTl/wnMalybLmTOX/wzjSpwW1
   rySzFVlGSRWzx6wEgmmRBLQgvhLQn1nJ/XQfmEu45cLMeq//YRawFQyBx
   PLPe49f9tt0e37X0EDt8K34ljrXLUL+QOOH2MeaAPV5fWEPUIgsGMLeVI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="23716208"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="23716208"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 18:54:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="15529086"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 18:54:22 -0700
Date: Fri, 22 Mar 2024 18:54:20 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Message-ID: <20240323015420.GF2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
 <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>

On Fri, Mar 22, 2024 at 07:10:42AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2024-03-21 at 23:12 +0000, Edgecombe, Rick P wrote:
> > On Mon, 2024-02-26 at 00:27 -0800, isaku.yamahata@intel.com wrote:
> > > Implement a hook of KVM_SET_CPUID2 for additional consistency check.
> > > 
> > > Intel TDX or AMD SEV has a restriction on the value of cpuid.  For
> > > example,
> > > some values must be the same between all vcpus.  Check if the new
> > > values
> > > are consistent with the old values.  The check is light because the
> > > cpuid
> > > consistency is very model specific and complicated.  The user space
> > > VMM
> > > should set cpuid and MSRs consistently.
> > 
> > I see that this was suggested by Sean, but can you explain the problem
> > that this is working around? From the linked thread, it seems like the
> > problem is what to do when userspace also calls SET_CPUID after already
> > configuring CPUID to the TDX module in the special way. The choices
> > discussed included:
> > 1. Reject the call
> > 2. Check the consistency between the first CPUID configuration and the
> > second one.
> > 
> > 1 is a lot simpler, but the reasoning for 2 is because "some KVM code
> > paths rely on guest CPUID configuration" it seems. Is this a
> > hypothetical or real issue? Which code paths are problematic for
> > TDX/SNP?
> 
> There might be use case that TDX guest wants to use some CPUID which
> isn't handled by the TDX module but purely by KVM.  These (PV) CPUIDs need to be
> provided via KVM_SET_CPUID2.
> 
> 
> Btw, Isaku, I don't understand why you tag the last two patches as RFC and put
> them at last.  I think I've expressed this before.  Per the discussion with
> Sean, my understanding is this isn't something optional but the right thing we
> should do?
> 
> https://lore.kernel.org/lkml/ZDiGpCkXOcCm074O@google.com/

Ok, let's remove RFC and reorder this patches.  Do you see any issue of the
cpuid check logic itself?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

