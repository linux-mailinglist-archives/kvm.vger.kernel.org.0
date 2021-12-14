Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBEC473D5A
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 07:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhLNGxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 01:53:45 -0500
Received: from mga07.intel.com ([134.134.136.100]:20072 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhLNGxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 01:53:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="302292926"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="302292926"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 22:52:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="681939271"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.249.172.13]) ([10.249.172.13])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 22:52:22 -0800
Message-ID: <12b5a1e8-89ae-1c56-9568-d774a5016548@linux.intel.com>
Date:   Tue, 14 Dec 2021 14:52:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [patch 0/6] x86/fpu: Preparatory changes for guest AMX support
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <20211214022825.563892248@linutronix.de>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
In-Reply-To: <20211214022825.563892248@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 12/14/2021 10:50 AM, Thomas Gleixner wrote:
> Folks,
>
> this is a follow up to the initial sketch of patches which got picked up by
> Jing and have been posted in combination with the KVM parts:
>
>     https://lore.kernel.org/r/20211208000359.2853257-1-yang.zhong@intel.com
>
> This update is only touching the x86/fpu code and not changing anything on
> the KVM side.
>
>      BIG FAT WARNING: This is compile tested only!
>
> In course of the dicsussion of the above patchset it turned out that there
> are a few conceptual issues vs. hardware and software state and also
> vs. guest restore.
>
> This series addresses this with the following changes vs. the original
> approach:
>
>    1) fpstate reallocation is now independent of fpu_swap_kvm_fpstate()
>
>       It is triggered directly via XSETBV and XFD MSR write emulation which
>       are used both for runtime and restore purposes.
>
>       For this it provides two wrappers around a common update function, one
>       for XCR0 and one for XFD.
>
>       Both check the validity of the arguments and the correct sizing of the
>       guest FPU fpstate. If the size is not sufficient, fpstate is
>       reallocated.
>
>       The functions can fail.
>
>    2) XFD synchronization
>
>       KVM must neither touch the XFD MSR nor the fpstate->xfd software state
>       in order to guarantee state consistency.
>
>       In the MSR write emulation case the XFD specific update handler has to
>       be invoked. See #1
>
>       If MSR write emulation is disabled because the buffer size is
>       sufficient for all use cases, i.e.:
>
>       		guest_fpu::xfeatures == guest_fpu::perm
>
The buffer size can be sufficient once one of the features is requested 
since
kernel fpu realloc full size (permitted). And I think we don't want to 
disable
interception until all the features are detected e.g., one by one.

Thus it can be guest_fpu::xfeatures != guest_fpu::perm.


Thanks,
Jing

