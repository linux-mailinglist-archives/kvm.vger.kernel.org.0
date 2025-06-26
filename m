Return-Path: <kvm+bounces-50842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0E1AEA253
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:21:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C0E1168E55
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F662EBB8B;
	Thu, 26 Jun 2025 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kPpnDvKy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD372EB5C0;
	Thu, 26 Jun 2025 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750950983; cv=none; b=gCXjbyFib2ViJIy1KsyaU8EEuj/JU11m/+dcBKUsAauZcQ7kY8+3zsQe4N0WP5c7QmRrtBlGRJ/rJ8B/V/H3HM9rbFulX6RTw7GuBoAKlqXNd57wTVYLHSiEPOX+A7CIkdonvBG2y7sy2r0u5ibGz/32VEBtoNesorov1gWMyqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750950983; c=relaxed/simple;
	bh=lqI8pD0+c/MWdmXxoqGaSXV4hXF1azOl9AOSOyUxWwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvbDxY3PNtABnV3gTDtIxz5HSJ2rwdFLI7n9NLn5krtXSHS0Je/Zkc5qkogr7TT/+snMbALPktKON6rHNV0lMTKlYudFThEFQeYRofCGJOAnlJeKUfhko2tIVTG0lilUPBchPD8drvl7RZwOO55GOWquWfcwB5a8zVNJGrW1DSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kPpnDvKy; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750950982; x=1782486982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lqI8pD0+c/MWdmXxoqGaSXV4hXF1azOl9AOSOyUxWwg=;
  b=kPpnDvKyO9H6K4RShJo0OPc0AeLSJ5vH92ADSn+58ieNRFHggD1ylvw3
   dO27ZvfMhGg2t+8kV/1TGiDTCz2Wl9u9RMdN1eg+6+BQanXusqcKblaCZ
   CvReZcFpVDHJc6knkRAuoIvGNQZYv1xrTFFBw43WfTdOHyhOHLxlT+ffz
   GEfIWAyLXhb/Ruwsw5uMrouqq9UJBIAHgY8LH7Edgx5pifrO23CV5z207
   YgGbW2H7tK9YjvReQt0WZDzxo4WXRk1QKd2eN/xhXUxsKrvinR/0CNxEn
   Y5w58fcFdfJYgyujpUNA+eK8pyT++EiIUI6R3eLsb0IU+WFQ2v9Y6HAKo
   w==;
X-CSE-ConnectionGUID: QowX8NwpQkCmJ9w3gz371w==
X-CSE-MsgGUID: LGkTOnJbTWq0lnZWI1pAIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="63941012"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="63941012"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 08:16:21 -0700
X-CSE-ConnectionGUID: SCa4oxn5S2S4n7Q6JQlhBw==
X-CSE-MsgGUID: KJHAXsf4QcObKmd0B9hfMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152299473"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa009.jf.intel.com with ESMTP; 26 Jun 2025 08:16:15 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 3D25C2E2; Thu, 26 Jun 2025 18:16:14 +0300 (EEST)
Date: Thu, 26 Jun 2025 18:16:14 +0300
From: "Shutemov, Kirill" <kirill.shutemov@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"Miao, Jun" <jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
References: <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>

On Thu, Jun 26, 2025 at 02:19:36AM +0300, Edgecombe, Rick P wrote:
> On Wed, 2025-06-25 at 16:09 -0700, Ackerley Tng wrote:
> > > I do think that these threads have gone on far too long. It's probably about
> > > time to move forward with something even if it's just to have something to
> > > discuss that doesn't require footnoting so many lore links. So how about we
> > > move
> > > forward with option e as a next step. Does that sound good Yan?
> > > 
> > 
> > Please see my reply to Yan, I'm hoping y'all will agree to something
> > between option f/g instead.
> 
> I'm not sure about the HWPoison approach, but I'm not totally against it. My
> bias is that all the MM concepts are tightly interlinked. If may fit perfectly,
> but every new use needs to be checked for how fits in with the other MM users of
> it. Every time I've decided a page flag was the perfect solution to my problem,
> I got informed otherwise. Let me try to flag Kirill to this discussion. He might
> have some insights.

We chatted with Rick about this.

If I understand correctly, we are discussing the situation where the TDX
module failed to return a page to the kernel.

I think it is reasonable to use HWPoison for this case. We cannot
guarantee that we will read back whatever we write to the page. TDX module
has creative ways to corrupt it. 

The memory is no longer functioning as memory. It matches the definition
of HWPoison quite closely.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

