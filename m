Return-Path: <kvm+bounces-21860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1DD93511C
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 19:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D00C1C20BD7
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 17:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7731C145355;
	Thu, 18 Jul 2024 17:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DfuLPcYF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA813144300;
	Thu, 18 Jul 2024 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721322638; cv=none; b=FOBmBVDqKl5QO1Wf3euiNbI06Mn5tCg/t2rzEetPzRlDVuPe1lf6J3uFDcSTSdHQ1aLJKJjLTXSDD2/81Dxbr99vK0wP/sO6UMKf8rUkeYAPIh6s2QnlaBIiIu3leO/DgpcmRS2vVzG/UIeEbPbKL7Um0NOaEmJpXc48z+azRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721322638; c=relaxed/simple;
	bh=QZdYH3ME+OcwsRif5oGewFKnxSlxjBLMi5OPf+7dbZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptYz7Fy/QDoG0ikJbj473PzMLVbLdPVUNzn6fayg9FjHjpl+XUsycZFrvmV/v7ulIinmOQkeXiG6X2a3F6L49seZW2PPHpcLlAdIjLNdSd8FNVvO5qEwF9B9WHvQvHwFE/X8gUfTh7qxKj94ZmD99YqFwBDfaLdRgfWTX7o340I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DfuLPcYF; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721322637; x=1752858637;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=QZdYH3ME+OcwsRif5oGewFKnxSlxjBLMi5OPf+7dbZ0=;
  b=DfuLPcYFApPpJWGHVkJtAlg+1m6/7khZlI5WORWx0xMUpO2WftE82Bc/
   BPoq3wOV/Sb54H5R/HpGfJvktnGUh5UV0VZVDVSTghF2ZimL8aR+NG6BO
   qXt7jKWncIAgLQh/Apk2ZsYQo00kCkdZvjZfI6jJ1s2etp63G/TdFNRwy
   1QhVoq9H2spHECViYXuNu+/BXuWKHsXvOQYML61ykpbGVGYduzf3RuKwU
   M9CP9t8NMNr2b09BnconKDCM5C8kgJbNntilCekwvefOLYfxS4BjX1a+5
   U0fqn9Xy8H/LRWbcM9osa7eFCNU5IqlSpOKa0YTcfvZ7qA6kehVZ8XhqX
   A==;
X-CSE-ConnectionGUID: J+jyjTSAQtKg0TplgeCpfQ==
X-CSE-MsgGUID: iDpYZ/c8RbeOGSpirGa+Aw==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="36343124"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="36343124"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 10:10:36 -0700
X-CSE-ConnectionGUID: z752KpM7QYOCFh4CH+MaZg==
X-CSE-MsgGUID: V5Y9TFBUSuWf68gy+6wUsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="50871249"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 10:10:36 -0700
Date: Thu, 18 Jul 2024 10:10:35 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
Message-ID: <20240718171035.GH1900928@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
 <20240716222514.GD1900928@ls.amr.corp.intel.com>
 <457184ed-dcda-4363-a0c9-95b43b80a6a4@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <457184ed-dcda-4363-a0c9-95b43b80a6a4@linux.intel.com>

On Thu, Jul 18, 2024 at 03:33:25PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > > > +
> > > > +		memcpy(&val, vcpu->run->mmio.data, size);
> > > > +		tdvmcall_set_return_val(vcpu, val);
> > > > +		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> > > > +	}
> > > Tracepoint for KVM_TRACE_MMIO_WRITE is missing when it is handled in
> > > userspace.
> > tdx_mmio_write() has it before existing to the user space.  It matches with
> > how write_mmio() behaves in x86.c.
> > 
> > Hmm, to match with other code, we should remove
> > trace_kvm_mmio(KVM_TRACE_MMIO_READ) and keep KVM_TRACE_MMIO_READ_UNSATISFIED
> > in tdx_emulate_mmio().  That's how read_prepare() and read_exit_mmio() behaves.
> > 
> > For MMIO read
> > - When kernel can handle the MMIO, KVM_TRACE_MMIO_READ with data.
> > - When exiting to the user space, KVM_TRACE_MMIO_READ_UNSATISFIED before
> >    the exit.  No trace after the user space handled the MMIO.
> 
> For MMIO read, in the emulator, there is still a trace after the userspace
> handled the MMIO.
> In complete_emulated_mmio(), if all fragments have been handled, it will
> set vcpu->mmio_read_completed to 1 and call complete_emulated_io().
> complete_emulated_io
>     kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE)
>         x86_emulate_instruction
>             x86_emulate_insn
>                 emulator_read_write
>                     read_prepare
>                         At this point, vcpu->mmio_read_completed is 1,
>                         it traces KVM_TRACE_MMIO_READ with data
>                         and then clear vcpu->mmio_read_completed
> 
> So to align with emulator, we should keep the trace for KVM_TRACE_MMIO_READ.

Oops, you're right. Agreed to keep it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

