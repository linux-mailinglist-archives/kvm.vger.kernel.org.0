Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415731BA9C6
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 18:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgD0QGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 12:06:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:8556 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgD0QGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 12:06:23 -0400
IronPort-SDR: z02/zrHjM/G6rUnKQoMtXt7HhW1CMfB5TQtKNfYYVFcCCzlZmv2c2Mjm+/uFfRC/vWojyvc/v1
 lTXCJElIDurg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 09:06:22 -0700
IronPort-SDR: b01dvZ9KFoBL+qpbsGAzdTYnopKrQZ8+lhXmHHjPNgel+wtCMg/Bin2YPgQbRw4AGbXxJm9p/b
 QvKU9QwaQRWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,324,1583222400"; 
   d="scan'208";a="293579355"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.92]) ([10.249.174.92])
  by orsmga008.jf.intel.com with ESMTP; 27 Apr 2020 09:06:20 -0700
Subject: Re: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to
 KVM_DEBUGREG_NEED_RELOAD
To:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-2-xiaoyao.li@intel.com>
 <20200423190941.GN17824@linux.intel.com> <20200424202103.GA48376@xz-x1>
 <f1c0ba71-1c5b-a5b7-3123-7ab36a5c5c74@redhat.com>
 <20200427143732.GD48376@xz-x1>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <3cc6471b-13da-832f-18d8-6db840b5ac47@intel.com>
Date:   Tue, 28 Apr 2020 00:06:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427143732.GD48376@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/2020 10:37 PM, Peter Xu wrote:
> On Sat, Apr 25, 2020 at 09:48:17AM +0200, Paolo Bonzini wrote:
>> On 24/04/20 22:21, Peter Xu wrote:
>>> But then shouldn't DIRTY be set as long as KVM_DEBUGREG_BP_ENABLED is set every
>>> time before vmenter?  Then it'll somehow go back to switch_db_regs, iiuc...
>>>
>>> IIUC RELOAD actually wants to say "reload only for this iteration", that's why
>>> it's cleared after each reload.  So maybe...  RELOAD_ONCE?
>>>
>>> (Btw, do we have debug regs tests somewhere no matter inside guest or with
>>>   KVM_SET_GUEST_DEBUG?)
>>
>> What about KVM_DEBUGREG_EFF_DB_DIRTY?
> 
> The problem is iiuc we always reload eff_db[] no matter which bit in
> switch_db_regs is set, so this may still not clearly identify this bit from the
> rest of the two bits...
> 
> Actually I think eff_db[] is a bit confusing here in that it can be either the
> host specified dbreg values or the guest specified depends on the dynamic value
> of KVM_GUESTDBG_USE_HW_BP.
> 
> I am thinking maybe it's clearer to have host_db[] and guest_db[], then only
> until vmenter do we load either of them by:

host_db[] is somewhat misleading, how about user_db[] (just like user_fpu)

>    if (KVM_GUESTDBG_USE_HW_BP)
>      load(host_db[]);
>    else
>      load(gueet_db[]);
> 
> Then each db[] will be very clear on what's the data is about.  And we don't
> need to check KVM_GUESTDBG_USE_HW_BP every time when accessing eff_db[].
> 

