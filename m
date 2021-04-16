Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012B13625CF
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbhDPQjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 12:39:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49964 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhDPQja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 12:39:30 -0400
Received: from [192.168.86.23] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7D24820B8001;
        Fri, 16 Apr 2021 09:39:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D24820B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618591145;
        bh=3PViebWvpQki0qxQgRMJwoKxPXwLSMJuODoXwPbGsM8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WvicHTix8W1ANGpRffj46E3m3IqgKhkPxr2GwEn4adYCxo9K3YNGtHbI6Z2lBenVk
         xIod+ow7tRBFzOZpKxsLV8xhn3WbQMrDQ+nAVv7DL03AyDNC7fM7j4JEBt0ADBPyv4
         cnah3hBMkCOMTntTORzoK6XzHPuiqpYwxHY9Buos=
Subject: Re: [PATCH v2 3/7] KVM: x86: hyper-v: Move the remote TLB flush logic
 out of vmx
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        viremana@linux.microsoft.com
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <92207433d0784e123347caaa955c04fbec51eaa7.1618492553.git.viremana@linux.microsoft.com>
 <87y2di7hiz.fsf@vitty.brq.redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <a01a13e4-4c11-962b-83ad-e7fc64cc3be8@linux.microsoft.com>
Date:   Fri, 16 Apr 2021 12:39:00 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <87y2di7hiz.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/16/2021 4:36 AM, Vitaly Kuznetsov wrote:
>
>>   struct kvm_vm_stat {
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 58fa8c029867..614b4448a028 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
> I still think that using arch/x86/kvm/hyperv.[ch] for KVM-on-Hyper-V is
> misleading. Currently, these are dedicated to emulating Hyper-V
> interface to KVM guests and this is orthogonal to nesting KVM on
> Hyper-V. As a solution, I'd suggest you either:
> - Put the stuff in x86.c
> - Create a dedicated set of files, e.g. 'kvmonhyperv.[ch]' (I also
> thought about 'hyperv_host.[ch]' but then I realized it's equally
> misleading as one can read this as 'KVM is acting as Hyper-V host').
>
> Personally, I'd vote for the later. Besides eliminating confusion, the
> benefit of having dedicated files is that we can avoid compiling them
> completely when !IS_ENABLED(CONFIG_HYPERV) (#ifdefs in C are ugly).
Makes sense, creating new set of files looks good to me. The default 
hyperv.c
for hyperv emulation also seems misleading - probably we should rename it
to hyperv_host_emul.[ch] or similar. That way, probably I can use 
hyperv.[ch]
for kvm on hyperv code. If you feel, thats too big of a churn, I shall use
kvm_on_hyperv.[ch] (to avoid reading the file differently). What do you 
think?


>> @@ -10470,7 +10474,6 @@ void kvm_arch_free_vm(struct kvm *kvm)
>>   	vfree(kvm);
>>   }
>>   
>> -
> Stray change?
It was kinda leftover, but I thought I'd keep it as it removes and 
unnecessary line.

Thanks,
Vineeth

