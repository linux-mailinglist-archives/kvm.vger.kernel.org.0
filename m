Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C85119F99
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 00:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfLJXho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 18:37:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:28187 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfLJXho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 18:37:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 15:37:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="210586609"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 10 Dec 2019 15:37:43 -0800
Date:   Tue, 10 Dec 2019 15:37:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com,
        kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, jannh@google.com, arei.gonglei@huawei.com,
        jmattson@google.com
Subject: Re: [PATCH v8 12/14] KVM/x86/lbr: lbr emulation
Message-ID: <20191210233742.GB23765@linux.intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
 <1565075774-26671-13-git-send-email-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565075774-26671-13-git-send-email-wei.w.wang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 06, 2019 at 03:16:12PM +0800, Wei Wang wrote:
> +static bool intel_pmu_set_lbr_msr(struct kvm_vcpu *vcpu,
> +				  struct msr_data *msr_info)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	u32 index = msr_info->index;
> +	u64 data = msr_info->data;
> +	bool ret = false;
> +
> +	/* The lbr event should have been allocated when reaching here. */
> +	if (WARN_ON(!pmu->lbr_event))
> +		return ret;
> +
> +	/*
> +	 * Host perf could reclaim the lbr feature via ipi calls, and this can
> +	 * be detected via lbr_event->oncpu being set to -1. To ensure the
> +	 * writes to the lbr msrs don't happen after the lbr feature has been
> +	 * reclaimed by the host, the interrupt is disabled before performing
> +	 * the writes.
> +	 */
> +	local_irq_disable();
> +	if (pmu->lbr_event->oncpu == -1)
> +		goto out;
> +
> +	switch (index) {
> +	case MSR_IA32_DEBUGCTLMSR:
> +		ret = true;
> +		/*
> +		 * Currently, only FREEZE_LBRS_ON_PMI and DEBUGCTLMSR_LBR are
> +		 * supported.
> +		 */
> +		data &= (DEBUGCTLMSR_FREEZE_LBRS_ON_PMI | DEBUGCTLMSR_LBR);
> +		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> +		break;
> +	default:
> +		if (is_lbr_msr(vcpu, index)) {
> +			ret = true;
> +			wrmsrl(index, data);

@data needs to be run through is_noncanonical_address() when writing the
MSRs that take an address.  In general, it looks like there's a lack of
checking on the validity of @data.

> +		}
> +	}
> +
> +out:
> +	local_irq_enable();
> +	return ret;
> +}
> +
