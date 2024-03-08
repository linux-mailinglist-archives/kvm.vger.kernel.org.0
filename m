Return-Path: <kvm+bounces-11343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 563E3875C0C
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 02:36:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B313D28394F
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 01:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1B722EE8;
	Fri,  8 Mar 2024 01:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="molgs+v+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C869210EC;
	Fri,  8 Mar 2024 01:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709861771; cv=none; b=doy5xct7Ki80/dnq65L07y4FcRmvSEiQzwoKT1IeQy+VRxcFu5iv74pIVL4iqnGACjjy4HvE6e0tx58tAgL5qVCPDOUUQet7h0HkFku1I7vSbY6IUWNrF/lMLTf/1MHQMJbf8wnvyZFQpr5yWMi5Hz0mA4yhY4MbiBE8mKxFXNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709861771; c=relaxed/simple;
	bh=xbGto3fk4Wl8w2TSsqYZ5+LuoyoD0/16Q7GhKQ4m+RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnYd6vylMUBNh7YV+ydCLlVw4o+xkcaOBF4t4sl8OgH5JT4GNNHM6jar44XBMfO3i6ERRn0yuqH8J7eHseDkSkHxRBdcrqpLFlLkOGUcQomJYWGrLt5CDLGHy0PBYiQkqjtEqPjL7bgYyDdoKpB4nW3BVJIb2JBpbTRSFGNKadw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=molgs+v+; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709861769; x=1741397769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xbGto3fk4Wl8w2TSsqYZ5+LuoyoD0/16Q7GhKQ4m+RQ=;
  b=molgs+v+eUFK5GpH3C6FKosQ3kNqTINMlNSs6HnHa0BqN5bEQoxWmA2w
   vMIL/9ddK6MzZkaAFq4tmkkNMu8PC4iyFIOp9l1kl3S87uJWUpMBazr5I
   g4XiWgrhktTXOIiIHFQ7Xul2C8cdJfa9lnit508TEdnXhRHUrX7jYz5mN
   nB6BRmh0OCixxOHxVxQDQP1C4YYuAzTLWxsHOFU5U8OWCnBfQVG0HwhD7
   7wj4j5XxdiJy27r5eG8yg6oVncyX5KrjxkdKnK7rzvN37RcFfIW98ev/x
   WZ8lBWG0o69K0bKcJ0Y2GbmBS7J9IHrTIBoo2S/nXfEEeS3v4J3uYmiav
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4449832"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4449832"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 17:36:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="41227121"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 17:36:08 -0800
Date: Thu, 7 Mar 2024 17:36:07 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Vishal Annapurve <vannapurve@google.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@gmail.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v3 3/4] KVM: X86: Add a capability to configure bus
 frequency for APIC timer
Message-ID: <20240308013607.GL368614@ls.amr.corp.intel.com>
References: <cover.1702974319.git.isaku.yamahata@intel.com>
 <f393da364d3389f8e65c7fae3e5d9210ffe7a2db.1702974319.git.isaku.yamahata@intel.com>
 <ZdjzIgS6EAeCsUue@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZdjzIgS6EAeCsUue@google.com>

On Fri, Feb 23, 2024 at 11:33:54AM -0800,
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, Dec 19, 2023, Isaku Yamahata wrote:
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 7025b3751027..cc976df2651e 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7858,6 +7858,20 @@ This capability is aimed to mitigate the threat that malicious VMs can
> >  cause CPU stuck (due to event windows don't open up) and make the CPU
> >  unavailable to host or other VMs.
> >  
> > +7.34 KVM_CAP_X86_BUS_FREQUENCY_CONTROL
> 
> BUS_FREQUENCY_CONTROL is simultaneously too long, yet not descriptive enough.
> Depending on whether people get hung up on nanoseconds not being a "frequency",
> either KVM_CAP_X86_APIC_BUS_FREQUENCY or KVM_CAP_X86_APIC_BUS_CYCLES_NS.
> 
> Also, this series needs to be rebased onto kvm-x86/next.

Thanks for the feedback with the concrete change to the patch.
I agree with those for the next respin.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

