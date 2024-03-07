Return-Path: <kvm+bounces-11288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2802874ADF
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 10:31:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 026131C2139D
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA5783A0B;
	Thu,  7 Mar 2024 09:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OmIJAvsW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38E883A01
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 09:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709803874; cv=none; b=upf+Om0gMPjDNcX2RzIaSoszqn5olbgVsElD/ezwncwEi/wZBHf98IfOllu0Fp//yQm7yPV7+w9lVFkBhNvqJ7vDTPqG3pXIIepLbMU8w/2d89RXVez9DPKuJFTW6+5BYe8URg45SmIj4iz0ARXSDwBGBo1GkLCiK9IsQyqBI5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709803874; c=relaxed/simple;
	bh=G7mf2EccVRhIrbdqpNw0ZIyZ4KS6othuKb4ikkEmgUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blChVfamSmUnRdFj1wjyO3rFTYep0tDxQWWdWs2pXINNoIMzxDvaOZhQhrJ/pw7151PSnjPZWa1uFSYMI2ot8WAA58H1ToNEA+4i5HDeErxFDlEzDSaq+u5GA1LhJcB/bNZ3B2GfgG+PGEgwbNOmsOUj5dAujwCHQmZLyf7R24M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OmIJAvsW; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709803873; x=1741339873;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G7mf2EccVRhIrbdqpNw0ZIyZ4KS6othuKb4ikkEmgUY=;
  b=OmIJAvsWBg0FBDiepdbXg6t9UE5rrL4/qefNWL4aIxn6Q8L+QMQ2Wxxa
   XwSFpsPgSSfwmMFkiZPS8gLQ9K6p0OMCdRxQ4lxUWCcZ9w90ZeZhTpbwF
   z4E08kUMxYo/e6Unu2S7YrcgqoMRlMfc/275vLark5LMq5W6Ee2wt8LTV
   B6K2ifET+TkYm1YPhPrgCpkhEEI47LT0QN7FedvjN78UB3lyMMIPLK0T0
   mhYg8Rt6JAUEEWCvwfh/gSAW9pDKmODDUtduJ94xVmqwFdM/vdejdND7R
   o2Lv1jVQLUyfE7Mnwz0X3e2vzDE9iAcc+XukXC275wsLDZt5Jw1cVMV57
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="5046444"
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="5046444"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:31:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="9951054"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:31:10 -0800
Message-ID: <af3d790b-60d5-4375-a948-caaf16631fd9@linux.intel.com>
Date: Thu, 7 Mar 2024 17:31:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 4/4] x86/pmu: Add a PEBS test to verify the
 host LBRs aren't leaked to the guest
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>,
 Mingwei Zhang <mizhang@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240306230153.786365-1-seanjc@google.com>
 <20240306230153.786365-5-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240306230153.786365-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/7/2024 7:01 AM, Sean Christopherson wrote:
> When using adaptive PEBS with LBR entries, verify that the LBR entries are
> all '0'.  If KVM fails to context switch LBRs, e.g. when the guest isn't
> using LBRs, as is the case in the pmu_pebs test, then adaptive PEBS can be
> used to read the *host* LBRs as the CPU doesn't enforce the VMX MSR bitmaps
> when generating PEBS records, i.e. ignores KVM's interception of reads to
> LBR MSRs.
>
> This testcase is best exercised by simultaneously utilizing LBRs in the
> host, e.g. by running "perf record -b -e instructions", so that there is
> non-zero data in the LBR MSRs.
>
> Cc: Like Xu <like.xu.linux@gmail.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhang Xiong <xiong.y.zhang@intel.com>
> Cc: Lv Zhiyuan <zhiyuan.lv@intel.com>
> Cc: Dapeng Mi <dapeng1.mi@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   x86/pmu_pebs.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
> index 0e8d60c3..df8e736f 100644
> --- a/x86/pmu_pebs.c
> +++ b/x86/pmu_pebs.c
> @@ -299,6 +299,19 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
>   		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
>   		report(expected,
>   		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
> +		if (use_adaptive && (pebs_data_cfg & PEBS_DATACFG_LBRS)) {
> +			unsigned int lbrs_offset = get_pebs_record_size(pebs_data_cfg & ~PEBS_DATACFG_LBRS, true);
> +			struct lbr_entry *pebs_lbrs = cur_record + lbrs_offset;
> +			int i;
> +
> +			for (i = 0; i < MAX_NUM_LBR_ENTRY; i++) {
> +				if (!pebs_lbrs[i].from && !pebs_lbrs[i].to)
> +					continue;
> +
> +				report_fail("PEBS LBR record %u isn't empty, got from = '%lx', to = '%lx', info = '%lx'",
> +					    i, pebs_lbrs[i].from, pebs_lbrs[i].to, pebs_lbrs[i].info);
> +			}
> +		}
>   		cur_record = cur_record + pebs_record_size;
>   		count++;
>   	} while (expected && (void *)cur_record < (void *)ds->pebs_index);
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

