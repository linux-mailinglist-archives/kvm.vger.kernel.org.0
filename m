Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A64F6471
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbiDFPxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbiDFPw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:52:28 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88B139B2A4;
        Wed,  6 Apr 2022 06:14:32 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nc5Ti-0001n7-Cl; Wed, 06 Apr 2022 15:13:42 +0200
Message-ID: <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
Date:   Wed, 6 Apr 2022 15:13:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
 <YkzxXw1Aznv4zX0a@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying the
 instruction
In-Reply-To: <YkzxXw1Aznv4zX0a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6.04.2022 03:48, Sean Christopherson wrote:
> On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
(..)
>> Also, I'm not sure that even the proposed updated code above will
>> actually restore the L1-requested next_rip correctly on L1 -> L2
>> re-injection (will review once the full version is available).
> 
> Spoiler alert, it doesn't.  Save yourself the review time.  :-)
> 
> The missing piece is stashing away the injected event on nested VMRUN.  Those
> events don't get routed through the normal interrupt/exception injection code and
> so the next_rip info is lost on the subsequent #NPF.
> 
> Treating soft interrupts/exceptions like they were injected by KVM (which they
> are, technically) works and doesn't seem too gross.  E.g. when prepping vmcb02
> 
> 	if (svm->nrips_enabled)
> 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> 		vmcb02->control.next_rip    = vmcb12_rip;
> 
> 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
> 		svm->soft_int_injected = true;
> 		svm->soft_int_csbase = svm->vmcb->save.cs.base;
> 		svm->soft_int_old_rip = vmcb12_rip;
> 		if (svm->nrips_enabled)
> 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
> 		else
> 			svm->soft_int_next_rip = vmcb12_rip;
> 	}
> 
> And then the VMRUN error path just needs to clear soft_int_injected.

I am also a fan of parsing EVENTINJ from VMCB12 into relevant KVM
injection structures (much like EXITINTINFO is parsed), as I said to
Maxim two days ago [1].
Not only for software {interrupts,exceptions} but for all incoming
events (again, just like EXITINTINFO).

However, there is another issue related to L1 -> L2 event re-injection
using standard KVM event injection mechanism: it mixes the L1 injection
state with the L2 one.

Specifically for SVM:
* When re-injecting a NMI into L2 NMI-blocking is enabled in
vcpu->arch.hflags (shared between L1 and L2) and IRET intercept is
enabled.

This is incorrect, since it is L1 that is responsible for enforcing NMI
blocking for NMIs that it injects into its L2.
Also, *L2* being the target of such injection definitely should not block
further NMIs for *L1*.

* When re-injecting a *hardware* IRQ into L2 GIF is checked (previously
even on the BUG_ON() level), while L1 should be able to inject even when
L2 GIF is off,

With the code in my previous patch set I planned to use
exit_during_event_injection() to detect such case, but if we implement
VMCB12 EVENTINJ parsing we can simply add a flag that the relevant event
comes from L1, so its normal injection side-effects should be skipped.

By the way, the relevant VMX code also looks rather suspicious,
especially for the !enable_vnmi case.

Thanks,
Maciej

[1]: https://lore.kernel.org/kvm/7d67bc6f-00ac-7c07-f6c2-c41b2f0d35a1@maciej.szmigiero.name/
