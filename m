Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441C722A04B
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 21:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732557AbgGVTsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 15:48:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:36992 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgGVTsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 15:48:52 -0400
IronPort-SDR: /Ql/DWqO4cc7/GJjictpTBwnWVZIDEc/ee8fA8aIDZF7un+xNHW06uAQ5ACuDKo9YFf5FB/kqr
 j1haVqE8M8KQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="129975929"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="129975929"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 12:48:52 -0700
IronPort-SDR: wvqOUWN7ePWMY35wp8A3MZ+1fd6IImJ8hi2QoUYL5oAiVimoIJ1RPF0ydeIMDJZVFPT8E2S+DK
 EWSwLL8+7Gqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="310753345"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jul 2020 12:48:52 -0700
Date:   Wed, 22 Jul 2020 12:48:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 02/11] KVM: VMX: Introduce CET VMCS fields and flags
Message-ID: <20200722194851.GC9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-3-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:18AM +0800, Yang Weijiang wrote:
> CET(Control-flow Enforcement Technology) is a CPU feature used to prevent
> Return/Jump-Oriented Programming(ROP/JOP) attacks. It provides the following
> sub-features to defend against ROP/JOP style control-flow subversion attacks:
> 
> Shadow Stack (SHSTK):
>   A second stack for program which is used exclusively for control transfer
>   operations.
> 
> Indirect Branch Tracking (IBT):
>   Code branching protection to defend against jump/call oriented programming.
> 
> Several new CET MSRs are defined in kernel to support CET:
>   MSR_IA32_{U,S}_CET: Controls the CET settings for user mode and kernel mode
>   respectively.
> 
>   MSR_IA32_PL{0,1,2,3}_SSP: Stores shadow stack pointers for CPL-0,1,2,3
>   protection respectively.
> 
>   MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack pointer table.
> 
> Two XSAVES state bits are introduced for CET:
>   IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
>   IA32_XSS:[bit 12]: Control saving/restoring kernel mode CET states.
> 
> Six VMCS fields are introduced for CET:
>   {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
>   {HOST,GUEST}_SSP: Stores shadow stack pointer of current task/thread.
>   {HOST,GUEST}_INTR_SSP_TABLE: Stores base address of shadow stack pointer
>   table.
> 
> If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored from below
> VMCS fields at VM-Exit:
>   HOST_S_CET
>   HOST_SSP
>   HOST_INTR_SSP_TABLE
> 
> If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded from below
> VMCS fields at VM-Entry:
>   GUEST_S_CET
>   GUEST_SSP
>   GUEST_INTR_SSP_TABLE

No changes to the patch itself, but I tweaked the formatting of the changelog
a bit and expanded the introduction for SHSTK and IBT to provide a bit more
background.
