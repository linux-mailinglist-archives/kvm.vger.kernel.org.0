Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8053A14DF23
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgA3QaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:30:01 -0500
Received: from mga12.intel.com ([192.55.52.136]:18032 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727191AbgA3QaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 11:30:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 08:30:01 -0800
X-IronPort-AV: E=Sophos;i="5.70,382,1574150400"; 
   d="scan'208";a="222842003"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.169]) ([10.249.168.169])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 30 Jan 2020 08:29:58 -0800
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200130121939.22383-3-xiaoyao.li@intel.com>
 <4A8E14B3-1914-4D0C-A43A-234717179408@amacapital.net>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <cf79eeeb-e107-bdff-13a8-c52288d0d123@intel.com>
Date:   Fri, 31 Jan 2020 00:29:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4A8E14B3-1914-4D0C-A43A-234717179408@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/30/2020 11:18 PM, Andy Lutomirski wrote:
> 
> 
>> On Jan 30, 2020, at 4:24 AM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> ﻿There are two types of #AC can be generated in Intel CPUs:
>> 1. legacy alignment check #AC;
>> 2. split lock #AC;
>>
>> Legacy alignment check #AC can be injected to guest if guest has enabled
>> alignemnet check.
>>
>> When host enables split lock detection, i.e., split_lock_detect!=off,
>> guest will receive an unexpected #AC when there is a split_lock happens in
>> guest since KVM doesn't virtualize this feature to guest.
>>
>> Since the old guests lack split_lock #AC handler and may have split lock
>> buges. To make guest survive from split lock, applying the similar policy
>> as host's split lock detect configuration:
>> - host split lock detect is sld_warn:
>>    warning the split lock happened in guest, and disabling split lock
>>    detect around VM-enter;
>> - host split lock detect is sld_fatal:
>>    forwarding #AC to userspace. (Usually userspace dump the #AC
>>    exception and kill the guest).
> 
> A correct userspace implementation should, with a modern guest kernel, forward the exception. Otherwise you’re introducing a DoS into the guest if the guest kernel is fine but guest userspace is buggy.

To prevent DoS in guest, the better solution is virtualizing and 
advertising this feature to guest, so guest can explicitly enable it by 
setting split_lock_detect=fatal, if it's a latest linux guest.

However, it's another topic, I'll send out the patches later.

> What’s the intended behavior here?
> 
It's for old guests. Below I quote what Paolo said in
https://lore.kernel.org/kvm/57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com/

"So for an old guest, as soon as the guest kernel happens to do a split 
lock, it gets an unexpected #AC and crashes and burns.  And then, after 
much googling and gnashing of teeth, people proceed to disable split 
lock detection.

(Old guests are the common case: you're a cloud provider and your
customers run old stuff; it's a workstation and you want to play that
game that requires an old version of Windows; etc.).

To save them the googling and gnashing of teeth, I guess we can do a
pr_warn_ratelimited on the first split lock encountered by a guest.  (It
has to be ratelimited because userspace could create an arbitrary amount
of guests to spam the kernel logs).  But the end result is the same,
split lock detection is disabled by the user."



