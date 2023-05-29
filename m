Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3454714EAE
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 18:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjE2QsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 12:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjE2QsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 12:48:12 -0400
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [IPv6:2001:1600:3:17::190d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAA5B5
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 09:48:10 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QVM0S0h90zMqS8N;
        Mon, 29 May 2023 18:48:08 +0200 (CEST)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QVM0N4qpgzMpvXY;
        Mon, 29 May 2023 18:48:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1685378887;
        bh=L+AoM15vKXrvn30NczrqA+aX9dwRdpATxmicKsa0b54=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NIV0lHsv0wTD7BCC4ZXt7w9oowUL9SV7UxKoOT7S1KqEP+2aSUrieQxP9LJP59+mO
         ZNd3IkCScExVnFAtc3C902qJRT2LHk41z0nJeTFW/IpjysBJPb3bghczvpI3mYK0CS
         5fhux6+oZzWtW4Q9BILMrxW1qJ1honAjKd3plkns=
Message-ID: <901ff104-215c-8e81-fbae-5ecd8fa94449@digikod.net>
Date:   Mon, 29 May 2023 18:48:03 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v1 5/9] KVM: x86: Add new hypercall to lock control
 registers
Content-Language: en-US
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?Q?=c8=98tefan_=c8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
References: <20230505152046.6575-1-mic@digikod.net>
 <20230505152046.6575-6-mic@digikod.net>
 <ZFlllHjntehpthma@liuwe-devbox-debian-v2>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <ZFlllHjntehpthma@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 08/05/2023 23:11, Wei Liu wrote:
> On Fri, May 05, 2023 at 05:20:42PM +0200, Mickaël Salaün wrote:
>> This enables guests to lock their CR0 and CR4 registers with a subset of
>> X86_CR0_WP, X86_CR4_SMEP, X86_CR4_SMAP, X86_CR4_UMIP, X86_CR4_FSGSBASE
>> and X86_CR4_CET flags.
>>
>> The new KVM_HC_LOCK_CR_UPDATE hypercall takes two arguments.  The first
>> is to identify the control register, and the second is a bit mask to
>> pin (i.e. mark as read-only).
>>
>> These register flags should already be pinned by Linux guests, but once
>> compromised, this self-protection mechanism could be disabled, which is
>> not the case with this dedicated hypercall.
>>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: Wanpeng Li <wanpengli@tencent.com>
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> Link: https://lore.kernel.org/r/20230505152046.6575-6-mic@digikod.net
> [...]
>>   	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
>>   	if (is_unrestricted_guest(vcpu))
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ffab64d08de3..a529455359ac 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -7927,11 +7927,77 @@ static unsigned long emulator_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
>>   	return value;
>>   }
>>   
>> +#ifdef CONFIG_HEKI
>> +
>> +extern unsigned long cr4_pinned_mask;
>> +
> 
> Can this be moved to a header file?

Yep, but I'm not sure which one. Any preference Kees?


> 
>> +static int heki_lock_cr(struct kvm *const kvm, const unsigned long cr,
>> +			unsigned long pin)
>> +{
>> +	if (!pin)
>> +		return -KVM_EINVAL;
>> +
>> +	switch (cr) {
>> +	case 0:
>> +		/* Cf. arch/x86/kernel/cpu/common.c */
>> +		if (!(pin & X86_CR0_WP))
>> +			return -KVM_EINVAL;
>> +
>> +		if ((read_cr0() & pin) != pin)
>> +			return -KVM_EINVAL;
>> +
>> +		atomic_long_or(pin, &kvm->heki_pinned_cr0);
>> +		return 0;
>> +	case 4:
>> +		/* Checks for irrelevant bits. */
>> +		if ((pin & cr4_pinned_mask) != pin)
>> +			return -KVM_EINVAL;
>> +
> 
> It is enforcing the host mask on the guest, right? If the guest's set is a
> super set of the host's then it will get rejected.
> 
> 
>> +		/* Ignores bits not present in host. */
>> +		pin &= __read_cr4();
>> +		atomic_long_or(pin, &kvm->heki_pinned_cr4);

We assume that the host's mask is a superset of the guest's mask. I 
guess we should check the absolute supported bits instead, even if it 
would be weird for the host to not support these bits.


>> +		return 0;
>> +	}
>> +	return -KVM_EINVAL;
>> +}
>> +
>> +int heki_check_cr(const struct kvm *const kvm, const unsigned long cr,
>> +		  const unsigned long val)
>> +{
>> +	unsigned long pinned;
>> +
>> +	switch (cr) {
>> +	case 0:
>> +		pinned = atomic_long_read(&kvm->heki_pinned_cr0);
>> +		if ((val & pinned) != pinned) {
>> +			pr_warn_ratelimited(
>> +				"heki-kvm: Blocked CR0 update: 0x%lx\n", val);
> 
> I think if the message contains the VM and VCPU identifier it will
> become more useful.

Indeed, and this should be the case for all log messages, but I'd left 
that for future work. ;) I'll update the logs for the next series with a 
new kvm_warn_ratelimited() helper using VCPU's PID.
