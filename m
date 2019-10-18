Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E5FDBC33
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 06:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407377AbfJRE6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 00:58:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:47341 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730688AbfJRE6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 00:58:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 19:36:47 -0700
X-IronPort-AV: E=Sophos;i="5.67,310,1566889200"; 
   d="scan'208";a="371328089"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 17 Oct 2019 19:36:43 -0700
Subject: Re: [RFD] x86/split_lock: Request to Intel
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
 <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
 <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
 <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
 <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <5da90713-9a0d-6466-64f7-db435ba07dbe@intel.com>
Date:   Fri, 18 Oct 2019 10:36:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/2019 8:29 PM, Thomas Gleixner wrote:
> The more I look at this trainwreck, the less interested I am in merging any
> of this at all.
> 
> The fact that it took Intel more than a year to figure out that the MSR is
> per core and not per thread is yet another proof that this industry just
> works by pure chance.
> 

Whether it's per-core or per-thread doesn't affect much how we implement 
for host/native.

And also, no matter it's per-core or per-thread, we always can do 
something in VIRT.

Maybe what matters is below.

> Seriously, this makes only sense when it's by default enabled and not
> rendered useless by VIRT. Otherwise we never get any reports and none of
> the issues are going to be fixed.
>

For VIRT, it doesn't want old guest to be killed due to #AC. But for 
native, it doesn't want VIRT to disable the #AC detection

I think it's just about the default behavior that whether to disable the 
host's #AC detection or kill the guest (SIGBUS or something else) once 
there is an split-lock #AC in guest.

So we can provide CONFIG option to set the default behavior and module 
parameter to let KVM set/change the default behavior.

