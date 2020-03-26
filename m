Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235791946CB
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 19:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgCZSvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 14:51:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51490 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgCZSva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 14:51:30 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jHXb3-000058-2K; Thu, 26 Mar 2020 19:51:17 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 57C9410069D; Thu, 26 Mar 2020 19:51:16 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v6 8/8] kvm: vmx: virtualize split lock detection
In-Reply-To: <e58484ac-e355-299d-131c-6e8c12b0b1d0@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com> <20200324151859.31068-9-xiaoyao.li@intel.com> <87eethz2p6.fsf@nanos.tec.linutronix.de> <88b01989-25cd-90af-bfe8-c236bd5d1dbf@intel.com> <87d08zxtgl.fsf@nanos.tec.linutronix.de> <1d98bddd-a6a4-2fcc-476b-c9b19f65c6b6@intel.com> <87a743xj0n.fsf@nanos.tec.linutronix.de> <e58484ac-e355-299d-131c-6e8c12b0b1d0@intel.com>
Date:   Thu, 26 Mar 2020 19:51:16 +0100
Message-ID: <877dz7x84b.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:
> On 3/26/2020 10:55 PM, Thomas Gleixner wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>> On 3/26/2020 7:10 PM, Thomas Gleixner wrote:
>>> If the host has it disabled, !split_lock_detect_on() is true, it skips
>>> following check due to ||
>>>
>>> if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK)) {
>>> 	inject #AC back to guest
> and 	return 1;
>
>> 
>> That'd be a regular #AC, right?
>
> Yes.
>
>>> } else {
>>> 	if (guest_alignment_check_enabled() || guest_sld_on())
>>> 		inject #AC back to guest
> and 		return 1;
>
>> Here is clearly an else path missing.
>
> the else path is fall through.
>
> i.e. calling handle_user_split_lock().
>
> If cannot handle, it falls through to report #AC to user space (QEMU)
>
>>> }
>> 
>
> If there is no problem with the above. So what's the problem of the 
> original?

Probably my inability to decipher the convoluted condition.

Thanks,

        tglx
