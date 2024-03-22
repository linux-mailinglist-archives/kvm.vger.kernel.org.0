Return-Path: <kvm+bounces-12531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 530AA88754E
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 23:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F27E28377A
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 22:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C4782C7D;
	Fri, 22 Mar 2024 22:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DidtImfK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E0D82891;
	Fri, 22 Mar 2024 22:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711148259; cv=none; b=i20D8vnpfn9RwiLAZfvQSXB/+LF04Oa7TK7bbyncdovrOr8Gp88sxHRDoqc/Yym+Am4jy3YWjY4+kwAEKq2Y7rgpzRtmLis/oIZVwMYK84eQ9gOijQ4ocoYP4dpYawdpTRpNnOXQToPXGkZ6CY/9uYxt1Bug68r1jzg861Lbats=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711148259; c=relaxed/simple;
	bh=96QHhdKY87Blduh4L8mp6CXq1rB2HO56b84NtbHpKTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmN5Q7td3Cg/yXxRLB+aTC5x4UjfexbUz75sYtClnbkPv0Lyy5Lmh5AtKffyXnXTmoUR/ESE6vjw9wzMeJLKOuUN9Oq5doJdq3KlQ5Qzx61QaYxRzHZX7+bKqQ3rH2TyLjLY2AXNa2duRAh4yhysiGpf6J/nhv2jd3TYE2ftvpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DidtImfK; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711148258; x=1742684258;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=96QHhdKY87Blduh4L8mp6CXq1rB2HO56b84NtbHpKTg=;
  b=DidtImfKk6SE3o7GTC3TQNt/lRaMslL2pJDqquj3aXsczfbgLSkFY/T6
   GioOZPeqjMX6fIm6kPi7jVw8Ac42lo2V1C3KX5rfZNwAH7SOMj5ZrPgbl
   h13KqMuA5QD03KD1KSzM+lpBG9dK12G0MQ/LLnX7573n3l1TbIvW2JiB3
   Ke4HEAI2nrP0KXy8u63Vwfr5vej2xKa0AwhAJnpmewV/8uAvu1uUg1B09
   jf7FnqqtUS8c2TCrDW1Q9UFCE+Y5l7Ujzk9qfVpC+UPv+s6XGRdx9YYYZ
   lU3uhi9G6lM0JUt/qfWRoT6M+ygTaALVGtVe90ii9ZXQrFt55nlVIUZjf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="6048104"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="6048104"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 15:57:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="15470498"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 15:57:38 -0700
Date: Fri, 22 Mar 2024 15:57:36 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Message-ID: <20240322225736.GC1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
 <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>
 <20240315013511.GF1258280@ls.amr.corp.intel.com>
 <fc6278a55deeccf8c67fba818647829a1dddcf0a.camel@intel.com>
 <20240318171218.GA1645738@ls.amr.corp.intel.com>
 <6986b1ddf25f064d3609793979ca315567d7e875.camel@intel.com>
 <20240318231656.GC1645738@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240318231656.GC1645738@ls.amr.corp.intel.com>

On Mon, Mar 18, 2024 at 04:16:56PM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> On Mon, Mar 18, 2024 at 05:43:33PM +0000,
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> 
> > On Mon, 2024-03-18 at 10:12 -0700, Isaku Yamahata wrote:
> > > I categorize as follows. Unless otherwise, I'll update this series.
> > > 
> > > - dirty log check
> > >   As we will drop this ptach, we'll have no call site.
> > > 
> > > - KVM_BUG_ON() in main.c
> > >   We should drop them because their logic isn't complex.
> > What about "KVM: TDX: Add methods to ignore guest instruction
> > emulation"? Is it cleanly blocked somehow?
> 
> KVM fault handler, kvm_mmu_page_fault(), is the caller into the emulation,
> It should skip the emulation.
> 
> As the second guard, x86_emulate_instruction(), calls
> check_emulate_instruction() callback to check if the emulation can/should be
> done.  TDX callback can return it as X86EMUL_UNHANDLEABLE.  Then, the flow goes
> to user space as error.  I'll update the vt_check_emulate_instruction().

Oops. It was wrong. It should be X86EMUL_RETRY_INSTR.  RETRY_INSTR means, let
vcpu execute the intrusion again, UNHANDLEABLE means, emulator can't emulate,
inject exception or give up with KVM_EXIT_INTERNAL_ERROR.

For TDX, we'd like to inject #VE to the guest so that the guest #VE handler
can issue TDG.VP.VMCALL<MMIO>.  The default non-present sept value has
#VE suppress bit set.  As first step, EPT violation occurs. then KVM sets
up mmio_spte with #VE suppress bit cleared. Then X86EMUL_RETRY_INSTR tells
kvm to resume vcpu to inject #VE.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

