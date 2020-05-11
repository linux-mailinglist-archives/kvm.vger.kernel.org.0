Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED40E1CE787
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 23:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgEKVfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 17:35:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:60365 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgEKVfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 17:35:39 -0400
IronPort-SDR: wriaR/azF9TKgKu3FcwI13hKY7RRv0rUEwMIfxDHFA+joqjRdQQHd3jOB1tmolIbmOrQTEfvs0
 978PInEqeX6w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 14:35:38 -0700
IronPort-SDR: MhjHBKd/Mq3CgJY1K/3o4/wCo4CUifFrparfxvFTKpcSWrrZQYytKnYNbEkAE4uWmptzxlH7oC
 bkVZaCLq3MmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="297817392"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2020 14:35:37 -0700
Date:   Mon, 11 May 2020 14:35:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@lists.01.org,
        xudong.hao@intel.com
Subject: Re: [KVM] 6b6a864bd7: kernel-selftests.kvm.vmx_tsc_adjust_test.fail
Message-ID: <20200511213537.GG24052@linux.intel.com>
References: <20200428173217.5430-1-sean.j.christopherson@intel.com>
 <20200511010926.GV5770@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511010926.GV5770@shao2-debian>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 09:09:26AM +0800, kernel test robot wrote:
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: 6b6a864bd7d7eb12a82ec6da1c2dd97a43f79449 ("[PATCH v2] KVM: nVMX: Tweak handling of failure code for nested VM-Enter failure")
> url: https://github.com/0day-ci/linux/commits/Sean-Christopherson/KVM-nVMX-Tweak-handling-of-failure-code-for-nested-VM-Enter-failure/20200429-052911
> base: https://git.kernel.org/cgit/virt/kvm/kvm.git linux-next
> 
> in testcase: kernel-selftests
> with following parameters:
> 
> 	group: kselftests-kvm
> 	ucode: 0x500002c
> 
> test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
> test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
> 
> 
> on test machine: 192 threads Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz with 192G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> 
> 
> 
> # selftests: kvm: vmx_tsc_adjust_test
> # ==== Test Assertion Failure ====
> #   x86_64/vmx_tsc_adjust_test.c:153: false
> #   pid=12157 tid=12157 - Interrupted system call
> #      1	0x000000000040116a: main at vmx_tsc_adjust_test.c:153
> #      2	0x00007fafd54bce0a: ?? ??:0
> #      3	0x00000000004011e9: _start at ??:?
> #   Failed guest assert: (vmreadz(VM_EXIT_REASON) == (0x80000000 | 33))
> # IA32_TSC_ADJUST is -4294972240 (-1 * TSC_ADJUST_VALUE + -4944).
> not ok 14 selftests: kvm: vmx_tsc_adjust_test # exit=254

Ugh, missed the prepare_vmcs02() path.  v3 incoming.
