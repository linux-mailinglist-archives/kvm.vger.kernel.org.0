Return-Path: <kvm+bounces-12427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFBC8886000
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 18:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75A921F22164
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 17:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5384E84A28;
	Thu, 21 Mar 2024 17:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TW6T4b4M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C412012CD8A;
	Thu, 21 Mar 2024 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711043195; cv=none; b=ukqrFm3jTx9260y9k3sEpqyWWeLwutPve2Vam8vgQLne2QDBYiN2QDIcdRmwPufvq+iJjROsMPOdM+ZT2VoWlYB6Apnq71VhtxAWMbWPynKKkURNBW43BD3H9jSpbxwKIbSx+/vd/zS6Kl83iaLS69ajzbHlH+Tx7YbOo+Ogv7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711043195; c=relaxed/simple;
	bh=IHxP3sB8iCV2zZ3+AjpVxUeAnWuqZDXVivAsG8utYjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cA0gF90QWijx5yUn+eSG36hIQ5kzc7QoM9TGs4AyZvccpWvNOoBnaZpXcX1CI3TSp4f7gabubNvE5Ip9XE85vq2IOEyiyNHiO6+c8h4e3sGXf19Ve/LBgGwgSa/oKMIRwb1k7qY4UXk2qbreC2H15PddgYP2eAx3r0VdpmmrnCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TW6T4b4M; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711043193; x=1742579193;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IHxP3sB8iCV2zZ3+AjpVxUeAnWuqZDXVivAsG8utYjo=;
  b=TW6T4b4M2bMRIeG1s3FpBQraj4ilSXnGQqieA/tHL3/WcksI3w65cmb6
   nmInAcx45qvC2UIGRYc82ReDbywxTWJ9L0129on4KUEt8lQqoOjFyOK+X
   bIbp8eR5NUSqOMlAQYgu2GybT+aVSlNftHyIUIP1MwQcNlYuL2OCcF85z
   sFWWKvAVJEu2JzrXp8/kQ/rHBr+DCkGbjhLJ/+mEswgoYNQ7M92a03YCU
   92FGaLzV8pm3OLRrvAOUS+wbYmAdR84Hjn0QZlORql8PXGIqWlvC0kCbv
   G5mfqhUXjTBXz+wCyho5FPF3k4QGrIZnP1AHZxzKVZtTBKvnrXpNQI0+0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6264287"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="6264287"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 10:46:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="45707260"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 10:46:32 -0700
Date: Thu, 21 Mar 2024 10:46:31 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 040/130] KVM: TDX: Make pmu_intel.c ignore guest TD
 case
Message-ID: <20240321174631.GN1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <2eb2e7205d23ec858e6d800fee7da2306216e8f0.1708933498.git.isaku.yamahata@intel.com>
 <ZfqJ3LkYrwR/qpsX@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfqJ3LkYrwR/qpsX@chao-email>

On Wed, Mar 20, 2024 at 03:01:48PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:25:42AM -0800, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
> >support as another patch series) and pmu_intel.c touches vmx specific
> >structure in vcpu initialization, as workaround add dummy structure to
> >struct vcpu_tdx and pmu_intel.c can ignore TDX case.
> 
> Can we instead factor pmu_intel.c to avoid corrupting memory? how hard would it
> be?

Do you mean sprinkling "if (tdx) return"? It's easy. Just add it to all hooks
in kvm_pmu_ops.

I chose this approach because we'll soon support vPMU support. For simplicity,
will switch to sprinkle "if (tdx) return".

> >+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
> >+{
> >+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
> >+
> >+	if (is_td_vcpu(vcpu))
> >+		return false;
> >+
> >+	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
> 
> The check about vcpu's perf capabilities is new. is it necessary?

No. Will delete it. It crept in during rebase.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

