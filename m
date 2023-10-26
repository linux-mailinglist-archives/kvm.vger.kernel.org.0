Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCAC7D8A1E
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 23:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344732AbjJZVPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 17:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjJZVPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 17:15:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4156410E;
        Thu, 26 Oct 2023 14:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698354912; x=1729890912;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9ITEn21ERPZbocLmTIC8sZ/1PpEOBtBDdPjs69y5nx8=;
  b=FVmY8569TykfkKhC6q0SFDXTTIKmpmaX8HIQJRKmijPwcQpIdeYH8dFX
   EGXfR+3TwFM1vcXf6yIvGzc2O05ox9D9WDa8OaUidTzF0snRDwZua0fX1
   pnhGPSRbPTB85isy5zXGshXU46XwL6MFjeVYi+yeRwhrOgRpITCz0cmNj
   7ppnV7z5xQSzP0Y/7S5Z6Jqc5g5Im3V0LolT8axufb91qpRIwXWUkgfZc
   1tHAb8bf/eCnLI0IXU/mjPIDAmzMl4z2fROGOnw9GllVtaJDsmgQTjPWt
   Y9rMuIkvDdE/juYH4MzjI1C8BVqqs7lr4MDDfAiqGjv+kaUmdABvtPxAb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="391527760"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="391527760"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 14:15:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="762986083"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="762986083"
Received: from paseron-mobl4.amr.corp.intel.com (HELO desk) ([10.209.17.113])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 14:15:09 -0700
Date:   Thu, 26 Oct 2023 14:15:08 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Nikolay Borisov <nik.borisov@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH v3 2/6] x86/entry_64: Add VERW just before userspace
 transition
Message-ID: <20231026211508.tmd7hfniesiu53ps@desk>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-2-52663677ee35@linux.intel.com>
 <2cda7e85-aa75-4257-864d-0092b3339e0e@suse.com>
 <20231026192950.ylzc66f3f5naqvjv@desk>
 <ae3d993f-6ce4-42de-b9c4-ef0c7db663c0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae3d993f-6ce4-42de-b9c4-ef0c7db663c0@intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 12:40:49PM -0700, Dave Hansen wrote:
> On 10/26/23 12:29, Pawan Gupta wrote:
> > On Thu, Oct 26, 2023 at 07:25:27PM +0300, Nikolay Borisov wrote:
> >> On 25.10.23 г. 23:52 ч., Pawan Gupta wrote:
> >>> @@ -1520,6 +1530,7 @@ SYM_CODE_START(ignore_sysret)
> >>>   	UNWIND_HINT_END_OF_STACK
> >>>   	ENDBR
> >>>   	mov	$-ENOSYS, %eax
> >>> +	CLEAR_CPU_BUFFERS
> >> nit: Just out of curiosity is it really needed in this case or it's doesn
> >> for the sake of uniformity so that all ring3 transitions are indeed
> >> covered??
> > Interrupts returning to kernel don't clear the CPU buffers. I believe
> > interrupts will be enabled here, and getting an interrupt here could
> > leak the data that interrupt touched.
> 
> Specifically NMIs, right?

Yes, and VERW can omitted for the same reason as NMI returning to
kernel.

> X86_EFLAGS_IF should be clear here.

I see that SYSCALL has a configuration for IF, but I didn't see it for
SYSENTER in the code. But looking at the SDM, it clear IF by default.

syscall_init()
{
...
#else
	wrmsrl_cstar((unsigned long)ignore_sysret);
	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
#endif

	/*
	 * Flags to clear on syscall; clear as much as possible
	 * to minimize user space-kernel interference.
	 */
	wrmsrl(MSR_SYSCALL_MASK,
	       X86_EFLAGS_CF|X86_EFLAGS_PF|X86_EFLAGS_AF|
	       X86_EFLAGS_ZF|X86_EFLAGS_SF|X86_EFLAGS_TF|
	       X86_EFLAGS_IF|X86_EFLAGS_DF|X86_EFLAGS_OF|
	       X86_EFLAGS_IOPL|X86_EFLAGS_NT|X86_EFLAGS_RF|
	       X86_EFLAGS_AC|X86_EFLAGS_ID);
