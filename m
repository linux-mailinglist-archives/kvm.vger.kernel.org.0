Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF82358EBA5
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiHJMGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiHJMGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:06:47 -0400
X-Greylist: delayed 376 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Aug 2022 05:06:44 PDT
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D508D13D59;
        Wed, 10 Aug 2022 05:06:44 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 19E5A43DAD;
        Wed, 10 Aug 2022 14:00:26 +0200 (CEST)
Message-ID: <96e0749a-6036-c728-d224-b812caadcd1b@proxmox.com>
Date:   Wed, 10 Aug 2022 14:00:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [PATCH v3 00/13] SMM emulation and interrupt shadow fixes
Content-Language: en-GB
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
In-Reply-To: <20220803155011.43721-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/2022 17:49, Maxim Levitsky wrote:
> This patch series is a result of long debug work to find out why
> sometimes guests with win11 secure boot
> were failing during boot.
> 
> During writing a unit test I found another bug, turns out
> that on rsm emulation, if the rsm instruction was done in real
> or 32 bit mode, KVM would truncate the restored RIP to 32 bit.
> 
> I also refactored the way we write SMRAM so it is easier
> now to understand what is going on.
> 
> The main bug in this series which I fixed is that we
> allowed #SMI to happen during the STI interrupt shadow,
> and we did nothing to both reset it on #SMI handler
> entry and restore it on RSM.
> 
> V3: addressed most of the review feedback from Sean (thanks!)
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (13):
>   bug: introduce ASSERT_STRUCT_OFFSET
>   KVM: x86: emulator: em_sysexit should update ctxt->mode
>   KVM: x86: emulator: introduce emulator_recalc_and_set_mode
>   KVM: x86: emulator: update the emulation mode after rsm
>   KVM: x86: emulator: update the emulation mode after CR0 write
>   KVM: x86: emulator/smm: number of GPRs in the SMRAM image depends on
>     the image format
>   KVM: x86: emulator/smm: add structs for KVM's smram layout
>   KVM: x86: emulator/smm: use smram structs in the common code
>   KVM: x86: emulator/smm: use smram struct for 32 bit smram load/restore
>   KVM: x86: emulator/smm: use smram struct for 64 bit smram load/restore
>   KVM: x86: SVM: use smram structs
>   KVM: x86: SVM: don't save SVM state to SMRAM when VM is not long mode
>     capable
>   KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM
> 
>  arch/x86/include/asm/kvm_host.h |  11 +-
>  arch/x86/kvm/emulate.c          | 305 +++++++++++++++++---------------
>  arch/x86/kvm/kvm_emulate.h      | 223 ++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c          |  30 ++--
>  arch/x86/kvm/vmx/vmcs12.h       |   5 +-
>  arch/x86/kvm/vmx/vmx.c          |   4 +-
>  arch/x86/kvm/x86.c              | 175 +++++++++---------
>  include/linux/build_bug.h       |   9 +
>  8 files changed, 497 insertions(+), 265 deletions(-)
> 

FWIW, we tested the v2 on 5.19 and backported it to 5.15 with minimal adaption
required (mostly unrelated context change) and now also updated that backport
to the v3 of this patch series.

Our reproducer got fixed with either, but v3 now also avoids triggering logs like:

 Jul 29 04:59:18 mits4 QEMU[2775]: kvm: Could not update PFLASH: Stale file handle
 Jul 29 04:59:18 mits4 QEMU[2775]: kvm: Could not update PFLASH: Stale file handle
 Jul 29 07:15:46 mits4 kernel: kvm: vcpu 1: requested 191999 ns lapic timer period limited to 200000 ns
 Jul 29 11:06:31 mits4 kernel: kvm: vcpu 1: requested 105786 ns lapic timer period limited to 200000 ns

which happened earlier (not sure how deep that correlates with the v2 vs. v3, but
it stuck out, so mentioning for sake of completeness).

For the backport to 5.15 we skipped "KVM: x86: emulator/smm: number of GPRs in
the SMRAM image depends on the image format", as that constant was there yet and
the actual values stayed the same for our case FWICT and adapted to slight context
changes for the others.

So, the approach seems to fix our issue and we are already rolling out a kernel
to users for testing and got positive feedback there too.

With above in mind:

Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>

It would be also great to see this backported to still supported upstream stable kernels
from 5.15 onwards, as there the TDP MMU got by default enabled, and that is at least
increasing the chance of our reproducer to trigger dramatically.

thx & cheers
Thomas

