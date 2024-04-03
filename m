Return-Path: <kvm+bounces-13492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8941F897866
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 20:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2B101C267A0
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E65C155313;
	Wed,  3 Apr 2024 18:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vh/U0a5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492115443D;
	Wed,  3 Apr 2024 18:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712169741; cv=none; b=c4A8R5mPv3JitAnzFi4Dys5GGuYSBi04e3nG6SJhDwWaPEjJFh3sxdEUwNYiUkl+vbVDB7W0zxTSVS2S3jnG3HwdD+FVuHRzKGMHtWxtauTNOOBl/6UnjSF7DxV3AIsljj6bJet7vtAOcWzHk3Cd2wU+iLOWoQPBIEWl1qHUc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712169741; c=relaxed/simple;
	bh=4JVyEyoYbipbxSWd/wP8gsZCAW+Sod7HLMF2MXV2s08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9Ee9VryYAdx70Yd7PpK4grBeAePdyvZQ9YzOGTupvcl8QTtVD6+zQu3j+ux9We9KJcxSlOqNAyxUDepfHEDG4Kp4s6yHwHyoTItIccZEv++uaC54nEpoQi/NEcvJ3QbRwcmkkBVr9A147MN2CNklxCx1rKpocD6g63++LNkNg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vh/U0a5Y; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712169739; x=1743705739;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4JVyEyoYbipbxSWd/wP8gsZCAW+Sod7HLMF2MXV2s08=;
  b=Vh/U0a5Y7z1TdUveeS0ErOhih+IxpONd31HNqWBluuK8CogBHUIPghau
   ElVW2yoTK2pA3L/WD8DeIn63D7UJKNPK5jey28RV/g+AcI78hhgY+nJZg
   n0E0ffcpnFk7W8ugRQtohvDzXFLUoLtZJJ8pAXQQNXRzpKBDjrRCXmn7L
   tW0FIslPAIGd/rY9fbM4ONbxpBUXmSImaAtIHQP7ui/ys06MHwQOUaOWh
   grYCUQjzI9FwpIVAWHHwFHHyur57iZq61xqymmB6z1m79sMLNLXIZP7MT
   yL1jDwT7D8ipjBKeOP5JJ8DtLHtlFOfhlMWmawfSYsqHVWeuW+0MwAc30
   g==;
X-CSE-ConnectionGUID: b6ktroVYQL20TO2HH2WXlA==
X-CSE-MsgGUID: d2UC0cZOQnW3vlGK/ywosg==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7611409"
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="7611409"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 11:42:18 -0700
X-CSE-ConnectionGUID: 5Ic5RadQQLWb1NA4KICpQA==
X-CSE-MsgGUID: xXvb5k7RSHmzu85oVxvBgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="18375601"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 11:42:18 -0700
Date: Wed, 3 Apr 2024 11:42:16 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
Message-ID: <20240403184216.GJ2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
 <Zgoz0sizgEZhnQ98@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zgoz0sizgEZhnQ98@chao-email>

On Mon, Apr 01, 2024 at 12:10:58PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >+{
> >+	unsigned long exit_qual;
> >+
> >+	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
> >+		/*
> >+		 * Always treat SEPT violations as write faults.  Ignore the
> >+		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
> >+		 * TD private pages are always RWX in the SEPT tables,
> >+		 * i.e. they're always mapped writable.  Just as importantly,
> >+		 * treating SEPT violations as write faults is necessary to
> >+		 * avoid COW allocations, which will cause TDAUGPAGE failures
> >+		 * due to aliasing a single HPA to multiple GPAs.
> >+		 */
> >+#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
> >+		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
> >+	} else {
> >+		exit_qual = tdexit_exit_qual(vcpu);
> >+		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
> 
> Unless the CPU has a bug, instruction fetch in TD from shared memory causes a
> #PF. I think you can add a comment for this.

Yes.


> Maybe KVM_BUG_ON() is more appropriate as it signifies a potential bug.

Bug of what component? CPU. If so, I think KVM_EXIT_INTERNAL_ERROR +
KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON is more appropriate.


> >+			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
> >+				tdexit_gpa(vcpu), kvm_rip_read(vcpu));
> >+			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
> >+			vcpu->run->ex.exception = PF_VECTOR;
> >+			vcpu->run->ex.error_code = exit_qual;
> >+			return 0;
> >+		}
> >+	}
> >+
> >+	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
> >+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
> >+}
> >+
> >+static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
> >+{
> >+	WARN_ON_ONCE(1);
> >+
> >+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> >+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> >+	vcpu->run->internal.ndata = 2;
> >+	vcpu->run->internal.data[0] = EXIT_REASON_EPT_MISCONFIG;
> >+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> >+
> >+	return 0;
> >+}
> >+
> > int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> > {
> > 	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
> >@@ -1345,6 +1390,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> > 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
> > 
> > 	switch (exit_reason.basic) {
> >+	case EXIT_REASON_EPT_VIOLATION:
> >+		return tdx_handle_ept_violation(vcpu);
> >+	case EXIT_REASON_EPT_MISCONFIG:
> >+		return tdx_handle_ept_misconfig(vcpu);
> 
> Handling EPT misconfiguration can be dropped because the "default" case handles
> all unexpected exits in the same way

Ah, right. Will update it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

