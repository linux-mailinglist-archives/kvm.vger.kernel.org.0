Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512896953F6
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 23:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjBMWjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 17:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBMWjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 17:39:16 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEAA2005B;
        Mon, 13 Feb 2023 14:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676327955; x=1707863955;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EvXRq4WvvrIfSOly7lAH+tO1e/+pSngrKTNrFWJ8/SE=;
  b=N5+L4ISbIiF59N8CtNGTTbq7FVqkb0zJfUGpEw+mBT6GB6Vyd7+GVQwe
   R20B4fA8vaQ6VBhd0laS8CENWEAYsDWZe9HX35S0yMkfriJeG9WfTeQ55
   STy1jqj+qvQB5mIqBdu75UCeXy+QruzG3YonVHXPsH4HiaIP4W9m2UKkx
   Kirkb5ep6voio0o/O4y1if0yWWluKRaUCkXdQT4upyKWol0cGR2ItUMIh
   rAlzz4pKLNyXsYS2OX64pQpqc2VdeHIZGKWGRpvbFy3bKJysf6EdN85Bb
   srzv+rFISjyorCcFseSIbOI+2zavYqPTrwUkVd71n+Jgenj+Nhf0IgFUR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="417235623"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="417235623"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 14:39:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="732651966"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="732651966"
Received: from mlswanso-mobl.amr.corp.intel.com (HELO [10.251.26.232]) ([10.251.26.232])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 14:39:12 -0800
Message-ID: <37d5736e-93b1-aed1-c21c-07fe1044f2d0@intel.com>
Date:   Mon, 13 Feb 2023 14:39:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1676286526.git.kai.huang@intel.com>
 <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 03:59, Kai Huang wrote:
> SEAMCALL instruction causes #GP when TDX isn't BIOS enabled, and #UD
> when CPU is not in VMX operation.  The current TDX_MODULE_CALL macro
> doesn't handle any of them.  There's no way to check whether the CPU is
> in VMX operation or not.

Really?  ... *REALLY*?

Like, there's no possible way for the kernel to record whether it has
executed VMXON or not?

I think what you're saying here is that there's no architecturally
visible flag that tells you whether in spot #1 or #2 in the following code:

static int kvm_cpu_vmxon(u64 vmxon_pointer)
{
        u64 msr;

        cr4_set_bits(X86_CR4_VMXE);
// spot #1
        asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
                          _ASM_EXTABLE(1b, %l[fault])
                          : : [vmxon_pointer] "m"(vmxon_pointer)
                          : : fault);
// spot #2

That's _maybe_ technically correct (I don't know enough about VMX
enabling to tell you).  But, what I *DO* know is that it's nonsense to
say that it's impossible in the *kernel* to tell whether we're on a CPU
that's successfully executed VMXON or not.

kvm_cpu_vmxon() has two paths through it:

  1. Successfully executes VMXON and leaves with X86_CR4_VMXE=1
  2. Fails VMXON and leaves with X86_CR4_VMXE=0

Guess what?  CR4 is rather architecturally visible.  From what I can
tell, it's *ENTIRELY* plausible to assume that X86_CR4_VMXE==1 means
that VMXON has been done.  Even if that's wrong, it's only a cpumask and
a cpumask_set() away from becoming plausible.  Like so:

static int kvm_cpu_vmxon(u64 vmxon_pointer)
{
        u64 msr;

        cr4_set_bits(X86_CR4_VMXE);

        asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
                          _ASM_EXTABLE(1b, %l[fault])
                          : : [vmxon_pointer] "m"(vmxon_pointer)
                          : : fault);
	// set cpumask bit here
        return 0;

fault:
	// clear cpu bit here
        cr4_clear_bits(X86_CR4_VMXE);

        return -EFAULT;
}

How many design decisions down the line in this series were predicated
on the idea that:

	There's no way to check whether the CPU is
	in VMX operation or not.

?
