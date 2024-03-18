Return-Path: <kvm+bounces-12044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA46087F3E5
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 068561C213CB
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501435E06B;
	Mon, 18 Mar 2024 23:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BKF5sbXy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4C85DF2F;
	Mon, 18 Mar 2024 23:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710803819; cv=none; b=PHJevaEgRvB2tHBTIJPcOPZ+kLXrTUtNNzc/lLrciu3e6a/MoEbcSLAYHvpS7ilyYF/pF3WZfwRcmJUfMsfw4w+9/xH7jNxCCQFzNcYCfiPiAB9DQkc7ScaM4vBUfBeLbQv+2qd3WO8fk99phC6JKjIRbh2LHOFNcxzLc05VPmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710803819; c=relaxed/simple;
	bh=F7/g5UOqRnAxP7ocolUUcKO59EIsH4cDnxzVx+ErLjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjSOJTH3anZO1PPyytzTQlmzac1HX9h9IW9ov3CGvZTBTCy9u6q2ALkAWd4/GQZjv5+66Pirez8eodV8++lnEW2S+ZEBBSRv5Ly/t6Wk1Cr2T21gviDINbtPU/1ot2aqBDS1a5NPPky2oG4mQJMyGLNTQoUgqcy+imVTJLlqtXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BKF5sbXy; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710803818; x=1742339818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=F7/g5UOqRnAxP7ocolUUcKO59EIsH4cDnxzVx+ErLjw=;
  b=BKF5sbXy/27aPe9Bwm/sIkMTt5j2zu5kqrOhryI1WG1SmqTn8ivh6V4W
   nEiXVRTJ5xuEU4Y26OmDdXXVtuw1huz3Dzq1jRasj7QibDUL9H30bTeVA
   upuqO806QCXeOmfhSokkkXDWYCnSnReCBAnC7r0TMuHlbkbKt7rpZbroQ
   xcqgIKNV9FWOA+5D97Ire8r7IhlpplZ+Jt6a2P2LMgZr8cBtMIbmdpWjv
   RQNZnpvo4ISRymw4g4XuqVRQIVJVkAkt3f2CEanSnOGGSphzIv8xJ8qcL
   cf0lkvDaYOCoT7VTxgOE1KHVOwaMK5tgGwOOn5bjaniIRcInRpINw15cJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5577929"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="5577929"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 16:16:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="44684981"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 16:16:57 -0700
Date: Mon, 18 Mar 2024 16:16:56 -0700
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
Message-ID: <20240318231656.GC1645738@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
 <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>
 <20240315013511.GF1258280@ls.amr.corp.intel.com>
 <fc6278a55deeccf8c67fba818647829a1dddcf0a.camel@intel.com>
 <20240318171218.GA1645738@ls.amr.corp.intel.com>
 <6986b1ddf25f064d3609793979ca315567d7e875.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6986b1ddf25f064d3609793979ca315567d7e875.camel@intel.com>

On Mon, Mar 18, 2024 at 05:43:33PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-03-18 at 10:12 -0700, Isaku Yamahata wrote:
> > I categorize as follows. Unless otherwise, I'll update this series.
> > 
> > - dirty log check
> >   As we will drop this ptach, we'll have no call site.
> > 
> > - KVM_BUG_ON() in main.c
> >   We should drop them because their logic isn't complex.
> What about "KVM: TDX: Add methods to ignore guest instruction
> emulation"? Is it cleanly blocked somehow?

KVM fault handler, kvm_mmu_page_fault(), is the caller into the emulation,
It should skip the emulation.

As the second guard, x86_emulate_instruction(), calls
check_emulate_instruction() callback to check if the emulation can/should be
done.  TDX callback can return it as X86EMUL_UNHANDLEABLE.  Then, the flow goes
to user space as error.  I'll update the vt_check_emulate_instruction().



> > - KVM_BUG_ON() in tdx.c
> >   - The error check of the return value from SEAMCALL
> >     We should keep it as it's unexpected error from TDX module. When
> > we hit
> >     this, we should mark the guest bugged and prevent further
> > operation.  It's
> >     hard to deduce the reason.  TDX mdoule might be broken.
> Yes. Makes sense.
> 
> > 
> >   - Other check
> >     We should drop them.
> 
> Offhand, I'm not sure what is in this category.

- Checking error code on TD enter/exit
  I'll revise how to check error from TD enter/exit.  We'll have new code.  I
  will update wrapper function to take struct kvm_tdx or struct tdx_vcpu, and
  revise to remove random check.  Cleanups related to kvm_rebooting,
  TDX_SW_ERROR, kvm_spurious_fault()

- Remaining random check for debug.
  The examples are as follows.  They were added for debug.


@@ -797,18 +788,14 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
         * list_{del,add}() on associated_tdvcpus list later.
         */
        tdx_disassociate_vp_on_cpu(vcpu);
-       WARN_ON_ONCE(vcpu->cpu != -1);
 
        /*
         * This methods can be called when vcpu allocation/initialization
         * failed. So it's possible that hkid, tdvpx and tdvpr are not assigned
         * yet.
         */
-       if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm))) {
-               WARN_ON_ONCE(tdx->tdvpx_pa);
-               WARN_ON_ONCE(tdx->tdvpr_pa);
+       if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
                return;
-       }
 
        if (tdx->tdvpx_pa) {
                for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
@@ -831,9 +818,9 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 
        /* vcpu_deliver_init method silently discards INIT event. */
-       if (KVM_BUG_ON(init_event, vcpu->kvm))
+       if (init_event)
                return;
-       if (KVM_BUG_ON(is_td_vcpu_created(to_tdx(vcpu)), vcpu->kvm))
+       if (is_td_vcpu_created(to_tdx(vcpu)))
                return;
 
        /*
@@ -831,9 +818,9 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 
        /* vcpu_deliver_init method silently discards INIT event. */
-       if (KVM_BUG_ON(init_event, vcpu->kvm))
+       if (init_event)
                return;
-       if (KVM_BUG_ON(is_td_vcpu_created(to_tdx(vcpu)), vcpu->kvm))
+       if (is_td_vcpu_created(to_tdx(vcpu)))
                return;
 
        /*
@@ -831,9 +818,9 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 
        /* vcpu_deliver_init method silently discards INIT event. */
-       if (KVM_BUG_ON(init_event, vcpu->kvm))
+       if (init_event)
                return;
-       if (KVM_BUG_ON(is_td_vcpu_created(to_tdx(vcpu)), vcpu->kvm))
+       if (is_td_vcpu_created(to_tdx(vcpu)))
                return;
 
        /*

  
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

