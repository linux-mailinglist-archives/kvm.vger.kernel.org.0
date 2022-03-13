Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17E24D7606
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 16:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiCMPKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 11:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiCMPKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 11:10:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F68A6583D
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 08:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647184161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EojRepfvyi3rRCH2zeHKYhLAqDYUbvYSLd4+Y/Utoyk=;
        b=NR9Lzjo199Z+K+1DH6zMaeY3882q4ILARjf+MytcToLaYnkyGe4pu6DByCXcvCojPCncd4
        p7B+2OR/39tYT5asAzSCawNG2kxbO3SoVedaKMYyguMno0UH6sQ6Cl4FRQma7PszwoN1mY
        WfdNFMMeOeYCAaRpEOAxHXzcVH+pyf8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-JDD0svhcOD6d4ifUxw8Qhw-1; Sun, 13 Mar 2022 11:09:16 -0400
X-MC-Unique: JDD0svhcOD6d4ifUxw8Qhw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DD2685A5A8;
        Sun, 13 Mar 2022 15:09:15 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CF53145830F;
        Sun, 13 Mar 2022 15:09:08 +0000 (UTC)
Message-ID: <fbf929e0793a6b4df59ec9d95a018d1f6737db35.camel@redhat.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Date:   Sun, 13 Mar 2022 17:09:08 +0200
In-Reply-To: <20220313135335.GA18405@gao-cwp>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-7-guang.zeng@intel.com> <Yifg4bea6zYEz1BK@google.com>
         <20220309052013.GA2915@gao-cwp> <YihCtvDps/qJ2TOW@google.com>
         <6dc7cff15812864ed14b5c014769488d80ce7f49.camel@redhat.com>
         <YirPkr5efyylrD0x@google.com>
         <29c76393-4884-94a8-f224-08d313b73f71@intel.com>
         <01586c518de0c72ff3997d32654b8fa6e7df257d.camel@redhat.com>
         <2900660d947a878e583ebedf60e7332e74a1af5f.camel@redhat.com>
         <20220313135335.GA18405@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-03-13 at 21:53 +0800, Chao Gao wrote:
> On Sun, Mar 13, 2022 at 12:59:36PM +0200, Maxim Levitsky wrote:
> > On Sun, 2022-03-13 at 11:19 +0200, Maxim Levitsky wrote:
> > > On Fri, 2022-03-11 at 21:28 +0800, Zeng Guang wrote:
> > > > On 3/11/2022 12:26 PM, Sean Christopherson wrote:
> > > > > On Wed, Mar 09, 2022, Maxim Levitsky wrote:
> > > > > > On Wed, 2022-03-09 at 06:01 +0000, Sean Christopherson wrote:
> > > > > > > > Could you share the links?
> > > > > > > 
> > > > > > > Doh, sorry (they're both in this one).
> > > > > > > 
> > > > > > > https://lore.kernel.org/all/20220301135526.136554-5-mlevitsk@redhat.com
> > > > > > > 
> > > > > > > 
> > > > > > 
> > > > > > My opinion on this subject is very simple: we need to draw the line somewhere.
> > > > > 
> > > > > ...
> > > > > 
> > > > > 
> > > > > Since the goal is to simplify KVM, can we try the inhibit route and see what the
> > > > > code looks like before making a decision?  I think it might actually yield a less
> > > > > awful KVM than the readonly approach, especially if the inhibit is "sticky", i.e.
> > > > > we don't try to remove the inhibit on subsequent changes.
> > > > > 
> > > > > Killing the VM, as proposed, is very user unfriendly as the user will have no idea
> > > > > why the VM was killed.  WARN is out of the question because this is user triggerable.
> > > > > Returning an emulation error would be ideal, but getting that result up through
> > > > > apic_mmio_write() could be annoying and end up being more complex.
> > > > > 
> > > > > The touchpoints will all be the same, unless I'm missing something the difference
> > > > > should only be a call to set an inhibit instead killing the VM.
> > > > 
> > > > Introduce an inhibition - APICV_INHIBIT_REASON_APICID_CHG to deactivate
> > > > APICv once KVM guest would try to change APIC ID in xapic mode, and same
> > > > sanity check in KVM_{SET,GET}_LAPIC for live migration. KVM will keep
> > > > alive but obviously lose benefit from hardware acceleration in this way.
> > > > 
> > > > So how do you think the proposal like this ?
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 6dcccb304775..30d825c069be 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1046,6 +1046,7 @@ struct kvm_x86_msr_filter {
> > > >  #define APICV_INHIBIT_REASON_X2APIC    5
> > > >  #define APICV_INHIBIT_REASON_BLOCKIRQ  6
> > > >  #define APICV_INHIBIT_REASON_ABSENT    7
> > > > +#define APICV_INHIBIT_REASON_APICID_CHG 8
> > > > 
> > > >  struct kvm_arch {
> > > >         unsigned long n_used_mmu_pages;
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 22929b5b3f9b..66cd54fa4515 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -2044,10 +2044,19 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> > > > 
> > > >         switch (reg) {
> > > >         case APIC_ID:           /* Local APIC ID */
> > > > -               if (!apic_x2apic_mode(apic))
> > > > -                       kvm_apic_set_xapic_id(apic, val >> 24);
> > > > -               else
> > > > +               if (apic_x2apic_mode(apic)) {
> > > >                         ret = 1;
> > > > +                       break;
> > > > +               }
> > > > +               /*
> > > > +                * If changing APIC ID with any APIC acceleration enabled,
> > > > +                * deactivate APICv to avoid unexpected issues.
> > > > +                */
> > > > +               if (enable_apicv && (val >> 24) != apic->vcpu->vcpu_id)
> > > > +                       kvm_request_apicv_update(apic->vcpu->kvm,
> > > > +                               false, APICV_INHIBIT_REASON_APICID_CHG);
> > > > +
> > > > +               kvm_apic_set_xapic_id(apic, val >> 24);
> > > >                 break;
> > > > 
> > > >         case APIC_TASKPRI:
> > > > @@ -2628,11 +2637,19 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
> > > >  static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
> > > >                 struct kvm_lapic_state *s, bool set)
> > > >  {
> > > > -       if (apic_x2apic_mode(vcpu->arch.apic)) {
> > > > -               u32 *id = (u32 *)(s->regs + APIC_ID);
> > > > -               u32 *ldr = (u32 *)(s->regs + APIC_LDR);
> > > > -               u64 icr;
> > > > +       u32 *id = (u32 *)(s->regs + APIC_ID);
> > > > +       u32 *ldr = (u32 *)(s->regs + APIC_LDR);
> > > > +       u64 icr;
> > > > +       if (!apic_x2apic_mode(vcpu->arch.apic)) {
> > > > +               /*
> > > > +                * If APIC ID changed with any APIC acceleration enabled,
> > > > +                * deactivate APICv to avoid unexpected issues.
> > > > +                */
> > > > +               if (enable_apicv && (*id >> 24) != vcpu->vcpu_id)
> > > > +                       kvm_request_apicv_update(vcpu->kvm,
> > > > +                               false, APICV_INHIBIT_REASON_APICID_CHG);
> > > > +       } else {
> > > >                 if (vcpu->kvm->arch.x2apic_format) {
> > > >                         if (*id != vcpu->vcpu_id)
> > > >                                 return -EINVAL;
> > > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > > index 82d56f8055de..f78754bdc1d0 100644
> > > > --- a/arch/x86/kvm/svm/avic.c
> > > > +++ b/arch/x86/kvm/svm/avic.c
> > > > @@ -931,7 +931,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
> > > >                           BIT(APICV_INHIBIT_REASON_IRQWIN) |
> > > >                           BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> > > >                           BIT(APICV_INHIBIT_REASON_X2APIC) |
> > > > -                         BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
> > > > +                         BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
> > > > +                         BIT(APICV_INHIBIT_REASON_APICID_CHG);
> > > > 
> > > >         return supported & BIT(bit);
> > > >  }
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index 7beba7a9f247..91265f0784bd 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -7751,7 +7751,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
> > > >         ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> > > >                           BIT(APICV_INHIBIT_REASON_ABSENT) |
> > > >                           BIT(APICV_INHIBIT_REASON_HYPERV) |
> > > > -                         BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
> > > > +                         BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
> > > > +                         BIT(APICV_INHIBIT_REASON_APICID_CHG);
> > > > 
> > > >         return supported & BIT(bit);
> > > >  }
> > > > 
> > > > 
> > > > 
> > > 
> > > This won't work with nested AVIC - we can't just inhibit a nested guest using its own AVIC,
> > > because migration happens.
> > 
> > I mean because host decided to change its apic id, which it can in theory do any time,
> > even after the nested guest has started. Seriously, the only reason guest has to change apic id,
> > is to try to exploit some security hole.
> 
> Hi
> 
> Thanks for the information.  
> 
> IIUC, you mean KVM applies APICv inhibition only to L1 VM, leaving APICv
> enabled for L2 VM. Shouldn't KVM disable APICv for L2 VM in this case?
> It looks like a generic issue in dynamically toggling APICv scheme,
> e.g., qemu can set KVM_GUESTDBG_BLOCKIRQ after nested guest has started.
> 

That is the problem - you can't disable it for L2, unless you are willing to emulate it in software.
Or in other words, when nested guest uses a hardware feature, you can't at some point say to it:
sorry buddy - hardware feature disappeared.

It is *currently* not a problem for APICv because it doesn't do IPI virtualization,
and even with these patches, it doesn't do this for nesting.
It does become when you allow nested guest to use this which I did in the nested AVIC code.


and writable apic ids do pose a large problem, since nested AVIC, will target L1's apic ids,
and when they can change under you without any notice, and even worse be duplicate,
it is just nightmare.

About KVM_GUESTDBG_BLOCKIRQ - yes, but that is a best effort hack anyway, 
which not supposed to 100% work - running gdbstub with nested is broken in many ways anyway.

Best regards,
	Maxim Levitsky


