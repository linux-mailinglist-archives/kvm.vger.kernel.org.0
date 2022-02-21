Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA034BD5DD
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 07:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344944AbiBUGMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 01:12:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344937AbiBUGL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 01:11:59 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545BA1122;
        Sun, 20 Feb 2022 22:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645423895; x=1676959895;
  h=message-id:date:mime-version:from:subject:to:references:
   in-reply-to:content-transfer-encoding;
  bh=F8baa429eehJgQyJGQk2vKsI/8Qtc/44EsxzSei+kjQ=;
  b=YjDJoUJODloi0igEbqHJ1kdmHPWYXOsFj9X3JBOCeqAYY73k4YqaaTYD
   1hytIppVGHnBoxhBnsVfqGv0ssxksCwEuV1eKfg40XONgrdND1W9awSIH
   U5JT/fR/blIuZ3CBfyLdJyBIyu5z9FpuwL+UgzjD9wuJdqUP2FDgKUYYz
   ckUA5PbJFN4S3io0t6jAD7ACj3Qk9Oty7GVBAp80Du3tZllGU441WDSWS
   URSrIaCAO6S5wKzaw6BQZQ00d3tRYyT4VM62HA4q8vVbxuF5ts8wYh70d
   3SqYQQyOYkOWj9XBE1fvZ8pcuRJ0gDuAAI7S/vzdc+F6VfoGNl5CIQOdO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251196005"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="251196005"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 22:11:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="507517119"
Received: from unknown (HELO [10.238.2.150]) ([10.238.2.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 22:11:31 -0800
Message-ID: <74034c15-aefc-e4af-2800-90e4fe96706f@intel.com>
Date:   Mon, 21 Feb 2022 14:11:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
Subject: Re: [PATCH v9 00/17] Introduce Architectural LBR for vPMU
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220215212544.51666-1-weijiang.yang@intel.com>
Content-Language: en-US
In-Reply-To: <20220215212544.51666-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping...

Hi, Paolo and other maintainers,

Arch LBR is the enhancement and replacement of Legacy LBR, this 
patch-set is

the necessity for guest Arch LBR usage on new Intel platforms starting from

Sapphire Rapids.

We're appreciated for your review and comments on these patches, thanks 
a lot!


On 2/16/2022 5:25 AM, Yang Weijiang wrote:
> The Architectural Last Branch Records (LBRs) is published in release
> Intel Architecture Instruction Set Extensions and Future Features
> Programming Reference[0].
>
> The main advantages of Arch LBR are [1]:
> - Faster context switching due to XSAVES support and faster reset of
>    LBR MSRs via the new DEPTH MSR
> - Faster LBR read for a non-PEBS event due to XSAVES support, which
>    lowers the overhead of the NMI handler.
> - Linux kernel can support the LBR features without knowing the model
>    number of the current CPU.
>
>  From end user's point of view, the usage of Arch LBR is the same as
> the Legacy LBR that has been merged in the mainline.
>
> Note, In this KVM series, we impose one restriction for guest Arch LBR:
> Guest can only set the same LBR record depth as host, this is due to
> the special behavior of MSR_ARCH_LBR_DEPTH: 1) On write to the MSR,
> it'll reset all Arch LBR recording MSRs to 0s. 2) XRSTORS resets all
> record MSRs to 0s if the saved depth mismatches MSR_ARCH_LBR_DEPTH.
>
> But this restriction won't impact guest perf tool usage.
>
> [0]https://software.intel.com/sites/default/files/managed/c5/15/architecture-instruction-set-extensions-programming-reference.pdf
> [1]https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/
>
> Qemu patch:
> https://patchwork.ozlabs.org/project/qemu-devel/cover/20220215195258.29149-1-weijiang.yang@intel.com/
>
> Previous version:
> v8:https://lkml.kernel.org/kvm/1629791777-16430-1-git-send-email-weijiang.yang@intel.com/
>
> Changes in v9:
> 1. Added Arch LBR MSR access interface for userspace.
> 2. Refactored XSS related dependent patches so that xsaves/xrstors can work for guest.
> 3. Refactored Arch LBR CTL and DEPTH MSR handling in KVM.
> 4. Rebased and tested on kernel base-commit: c5d9ae265b10
>
> Like Xu (6):
>    perf/x86/intel: Fix the comment about guest LBR support on KVM
>    perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
>    KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
>    KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
>    KVM: x86: Refine the matching and clearing logic for supported_xss
>    KVM: x86: Add XSAVE Support for Architectural LBR
>
> Sean Christopherson (2):
>    KVM: x86: Report XSS as an MSR to be saved if there are supported
>      features
>    KVM: x86: Load guest fpu state when accessing MSRs managed by XSAVES
>
> Yang Weijiang (9):
>    KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
>    KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
>    KVM: x86/pmu: Refactor code to support guest Arch LBR
>    KVM: x86/vmx: Check Arch LBR config when return perf capabilities
>    KVM: nVMX: Add necessary Arch LBR settings for nested VM
>    KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
>    KVM: x86/vmx: Flip Arch LBREn bit on guest state change
>    KVM: x86: Add Arch LBR MSR access interface
>    KVM: x86/cpuid: Advertise Arch LBR feature in CPUID
>
>   arch/x86/events/intel/core.c     |   3 +-
>   arch/x86/events/intel/lbr.c      |   6 +-
>   arch/x86/include/asm/kvm_host.h  |   7 ++
>   arch/x86/include/asm/msr-index.h |   1 +
>   arch/x86/include/asm/vmx.h       |   4 +
>   arch/x86/kvm/cpuid.c             |  54 ++++++++++-
>   arch/x86/kvm/vmx/capabilities.h  |   8 ++
>   arch/x86/kvm/vmx/nested.c        |   7 +-
>   arch/x86/kvm/vmx/pmu_intel.c     | 155 ++++++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/vmcs12.c        |   1 +
>   arch/x86/kvm/vmx/vmcs12.h        |   3 +-
>   arch/x86/kvm/vmx/vmx.c           |  65 ++++++++++++-
>   arch/x86/kvm/x86.c               |  78 +++++++++++++++-
>   13 files changed, 356 insertions(+), 36 deletions(-)
>
