Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480BF64B338
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 11:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiLMK1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 05:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbiLMK0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 05:26:44 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AB41CFCB;
        Tue, 13 Dec 2022 02:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670927202; x=1702463202;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MgDJrUXeSavZ9oBZ0ZsWHe76MqY6VNRSfNVI7k18A9w=;
  b=M/GLUAT612Jiq7XryFa/e7CflYDmO7FukANYGzrUUg4HBcKrITyJB0En
   hdZ8jesVDZZLvPuBoeriuvOWnigzT8S3Kme37Y4hBDylGO7rYER25OnEc
   zvdeinNmBdHEbgDU1LmmFC3rPRiOKRgj8zyqkQfXHbFUJokCm1w3CqPnD
   8dsgjhmt7ONRYjj5NF2Tz6rE2LD+ZIoTa8KvkVGuufX9XnX7mQagZ8nFf
   8xhrdIIGMd7ENacAg/rLFnGHyYmSIxi+DLVh+ful62uQZ5Zzi3LesCHEQ
   fNVfV6PwAFv7kSMOj6fkjAR03lK6flwBfbDz2KLrUZrdKY6Aymu/8hptE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="297778157"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="297778157"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 02:26:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="679250447"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="679250447"
Received: from wangl2-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.214.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 02:26:36 -0800
Date:   Tue, 13 Dec 2022 18:26:32 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Lixiao Yang <lixiao.yang@intel.com>
Subject: Re: [PATCH v2 1/4] KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE
 control to L1
Message-ID: <20221213102632.7otsl3lfuylntsho@linux.intel.com>
References: <20221213062306.667649-1-seanjc@google.com>
 <20221213062306.667649-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213062306.667649-2-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 06:23:03AM +0000, Sean Christopherson wrote:
> Set ENABLE_USR_WAIT_PAUSE in KVM's supported VMX MSR configuration if the
> feature is supported in hardware and enabled in KVM's base, non-nested
> configuration, i.e. expose ENABLE_USR_WAIT_PAUSE to L1 if it's supported.
> This fixes a bug where saving/restoring, i.e. migrating, a vCPU will fail
> if WAITPKG (the associated CPUID feature) is enabled for the vCPU, and
> obviously allows L1 to enable the feature for L2.
> 
> KVM already effectively exposes ENABLE_USR_WAIT_PAUSE to L1 by stuffing
> the allowed-1 control ina vCPU's virtual MSR_IA32_VMX_PROCBASED_CTLS2 when
> updating secondary controls in response to KVM_SET_CPUID(2), but (a) that
> depends on flawed code (KVM shouldn't touch VMX MSRs in response to CPUID
> updates) and (b) runs afoul of vmx_restore_control_msr()'s restriction
> that the guest value must be a strict subset of the supported host value.
> 
> Although no past commit explicitly enabled nested support for WAITPKG,
> doing so is safe and functionally correct from an architectural
> perspective as no additional KVM support is needed to virtualize TPAUSE,
> UMONITOR, and UMWAIT for L2 relative to L1, and KVM already forwards
> VM-Exits to L1 as necessary (commit bf653b78f960, "KVM: vmx: Introduce
> handle_unexpected_vmexit and handle WAITPKG vmexit").
> 
> Note, KVM always keeps the hosts MSR_IA32_UMWAIT_CONTROL resident in
> hardware, i.e. always runs both L1 and L2 with the host's power management
> settings for TPAUSE and UMWAIT.  See commit bf09fb6cba4f ("KVM: VMX: Stop
> context switching MSR_IA32_UMWAIT_CONTROL") for more details.
> 
> Fixes: e69e72faa3a0 ("KVM: x86: Add support for user wait instructions")
> Cc: stable@vger.kernel.org
> Reported-by: Aaron Lewis <aaronlewis@google.com>
> Reported-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Could you please help add
"Reported-by: Yang, Lixiao <lixiao.yang@intel.com>"
She identified the failure of vmx_msrs_test in KVM selftest first. Thanks!

B.R.
Yu
