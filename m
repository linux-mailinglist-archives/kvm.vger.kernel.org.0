Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FFE4E8859
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbiC0POI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 11:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbiC0POG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 11:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC2564A3F0
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 08:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648393945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YCL6IsIMi94/rlOo8//4dCgwLl8WJTfZBB8TqFxQ5+s=;
        b=hf5PVqum5JLWCpLc+PWQ0vgNy2fQQvZ7nwNBu0e7w4Ajd4ixyFHPQyfWeZQFAk1AHQXS3n
        NrxM0Vj2qN3jWHajidfVleKS26jaIb0zb1OmMwTdFcPc+2fnd84PviSOU3bkZEErW8ntuo
        RrdJMXYmdY7I0E6FdEOq7ORVkBGbjMA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-aU32lWI4PlihlOV_bXbI3Q-1; Sun, 27 Mar 2022 11:12:22 -0400
X-MC-Unique: aU32lWI4PlihlOV_bXbI3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7F8C85A5A8;
        Sun, 27 Mar 2022 15:12:21 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E5BA1402642;
        Sun, 27 Mar 2022 15:12:18 +0000 (UTC)
Message-ID: <612b6524258b949e381efec12d85b4e82be53308.camel@redhat.com>
Subject: Re: [PATCH v4 2/6] KVM: x86: nSVM: implement nested LBR
 virtualization
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Sun, 27 Mar 2022 18:12:17 +0300
In-Reply-To: <fca4a420-bdb4-0b46-c346-bee5500be43a@redhat.com>
References: <20220322174050.241850-1-mlevitsk@redhat.com>
         <20220322174050.241850-3-mlevitsk@redhat.com>
         <fca4a420-bdb4-0b46-c346-bee5500be43a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-24 at 19:21 +0100, Paolo Bonzini wrote:
> On 3/22/22 18:40, Maxim Levitsky wrote:
> > +		/* Copy LBR related registers from vmcb12,
> > +		 * but make sure that we only pick LBR enable bit from the guest.
> > +		 */
> > +		svm_copy_lbrs(vmcb02, vmcb12);
> > +		vmcb02->save.dbgctl &= LBR_CTL_ENABLE_MASK;
> 
> I still do not understand why it is not copying all bits outside
> DEBUGCTL_RESERVED_BITS.  That is:

Honestly, you are right, I'll do this.
 
Note however about few issues that we have around MSR_IA32_DEBUGCTLMSR
which needs to be eventually fixed (and if I get to it first, I'll do this):
 

On SVM:
 
- without LBR virtualization supported (!lbrv) 
any attempt to set that msr is ignored and logged with pr_err_ratelimited.
 
Note that on AMD, MSR_IA32_DEBUGCTLMSR consists of:
 
bit 0 - 
     AMD's LBR bit
 
bit 1 - 
     BTF - when set, EFLAGS.TF flag causes debug exception
     only on control flow instructions, allowing you to do more efficient
     debugger controlled run of code under debug.
 
bit 2-5:
    exposes perf counters on external CPU pins. Very likely NOP
    on anything remotely modern.
 
- with LBR virtualization supported, the guest can set this msr to any value
as long as it doesn't set reserved bits and then read back the written value, 
but it is not used by the CPU, unless LBR bit is set in MSR_IA32_DEBUGCTLMSR, 
because only then LBR virtualization is enabled, which makes the CPU 
load the guest value on VM entry.
 
This means that MSR_IA32_DEBUGCTLMSR.BTF will magically start working when
MSR_IA32_DEBUGCTLMSR.LBR is set as well, and will not work otherwise.
 
On VMX, we also have something a bit related (but I didn't do any homework
on this):
 
If both LBR and BTF are set, they are both cleared and 
we also get vcpu_unimpl ratelimited message.

otherwise the value is written to GUEST_IA32_DEBUGCTL which I 
think isn't tied to LBR virtualization like on AMD 

(also intel's LBR implementation is much more useful, 
since it has multiple records).


So since the only bit in question is BTF, I was thinking, 
lets just pick the LBR bit.

But I have absolutely no issue to be bug-consistent with non 
nested treatment of MSR_IA32_DEBUGCTLMSR and passthrough all 
non reserved bits.

Or I might at least document this in the errata document you added
recently to KVM (which is a great idea).

Best regards,
	Maxim Levitsky

> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c1baa3a68ce6..f1332d802ec8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -589,11 +589,12 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>   	}
>   
>   	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
> -		/* Copy LBR related registers from vmcb12,
> -		 * but make sure that we only pick LBR enable bit from the guest.
> +		/*
> +		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
> +		 * svm_set_msr's definition of reserved bits.
>   		 */
>   		svm_copy_lbrs(vmcb02, vmcb12);
> -		vmcb02->save.dbgctl &= LBR_CTL_ENABLE_MASK;
> +		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
>   		svm_update_lbrv(&svm->vcpu);
>   
>   	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 54fa048069b2..a6282be4e419 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -62,8 +62,6 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
>   #define SEG_TYPE_LDT 2
>   #define SEG_TYPE_BUSY_TSS16 3
>   
> -#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
> -
>   static bool erratum_383_found __read_mostly;
>   
>   u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index cade032520cb..b687393e86ad 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -487,6 +487,8 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>   /* svm.c */
>   #define MSR_INVALID				0xffffffffU
>   
> +#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
> +
>   extern bool dump_invalid_vmcb;
>   
>   u32 svm_msrpm_offset(u32 msr);
> 
> 
> > +		svm_update_lbrv(&svm->vcpu);
> > +
> > +	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
> >   		svm_copy_lbrs(vmcb02, vmcb01);


