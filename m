Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52C6641EF9
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 19:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiLDSnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 13:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiLDSns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 13:43:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CCF65CE
        for <kvm@vger.kernel.org>; Sun,  4 Dec 2022 10:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670179371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJM7gWWE8oaqNQCZTj0dpP5SKnEO8umjmhxbd+TV4fU=;
        b=JWbCZLdZ4F08yyV21be/08shhcL+MCHQhQfKVBYVa3tMVat9InNGcoxTWNN4et0r8/totF
        LTxfEH57mQfQhOu8wdrbtsbm2/t9GoRoBuUNQqrbJ71q05gyObWujO6msQoGorvpZB+/J3
        ArQYagQSApEBrh3xmmrj3L2aPJNlWis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-To-hb9q5M768IYHmluoJpg-1; Sun, 04 Dec 2022 13:42:47 -0500
X-MC-Unique: To-hb9q5M768IYHmluoJpg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53722811E67;
        Sun,  4 Dec 2022 18:42:46 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 874F91121331;
        Sun,  4 Dec 2022 18:42:42 +0000 (UTC)
Message-ID: <5bde88433d6962e38a4c2ddad778395cea98d13b.camel@redhat.com>
Subject: Re: [PATCH 07/13] KVM: SVM: Add VNMI support in get/set_nmi_mask
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Date:   Sun, 04 Dec 2022 20:42:41 +0200
In-Reply-To: <Y3aDTvglaSfhG8Tg@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
         <20221117143242.102721-8-mlevitsk@redhat.com> <Y3aDTvglaSfhG8Tg@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-17 at 18:54 +0000, Sean Christopherson wrote:
> On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> > From: Santosh Shukla <santosh.shukla@amd.com>
> > 
> > VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
> > NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK
> > as read-only in the hypervisor except for the SMM case where hypervisor
> > before entring and after leaving SMM mode requires to set and unset
> > V_NMI_MASK.
> > 
> > Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
> > L2.
> > 
> > Maxim:
> >    - made set_vnmi_mask/clear_vnmi_mask/is_vnmi_mask warn if called
> >      without vNMI enabled
> >    - clear IRET intercept in svm_set_nmi_mask even with vNMI
> > 
> > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 18 ++++++++++++++-
> >  arch/x86/kvm/svm/svm.h | 52 ++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 69 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 08a7b2a0a29f3a..c16f68f6c4f7d7 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3618,13 +3618,29 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> >  
> >  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> >  {
> > -	return !!(vcpu->arch.hflags & HF_NMI_MASK);
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +
> > +	if (is_vnmi_enabled(svm))
> > +		return is_vnmi_mask_set(svm);
> > +	else
> > +		return !!(vcpu->arch.hflags & HF_NMI_MASK);
> >  }
> >  
> >  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> >  {
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > +	if (is_vnmi_enabled(svm)) {
> > +		if (masked)
> > +			set_vnmi_mask(svm);
> 
> I believe not setting INTERCEPT_IRET is correct, but only because the existing
> code is unnecessary.  And this all very subtly relies on KVM_REQ_EVENT being set
> and/or KVM already being in kvm_check_and_inject_events().

Actually after thinking about this again, I am almost sure that you are wrong about this:

KVM sets INTERCEPT_IRET not only because of detection of NMI window but to know
when the NMI handler execution ended.

Even if no additional NMI arrives, if you don't intercept IRET, KVM will think that
NMI are never unmasked, and in particular when another NMI arrives, KVM will
try to open an NMI window while it is already open.

Now the svm_set_nmi_mask masks NMI either when it is called by SMM entry point,
or on migaration.

On SMM entry point, most of the time the NMIs will be unmasked by RSM, but
unsoliced IRET is also an (official) way to unmask NMI, which we will miss
if we don't intercept IRET.

On migartion, also, if it happened during NMI, we also have to intercept IRET once loading the
migration stream so that we can know when NMI ended in the same way.

All of this is of course only true for !vNMI case.

For vNMI case it turns out that we don't need to intercept IRET at all after all:

Turns out that when vNMI is pending, you can still EVENTINJ another NMI, and the pending
vNMI will be kept pending, vNMI will became masked due to EVENTINJ, and on IRET the pending vNMI
will be serviced as well, so in total both NMIs will be serviced.

I confirmed this with Santosh Shukla, and in my patch series I take an advantage of
this by failing the delayed NMI injection, and making KVM fail back to EVENTINJ.

If NMIs are blocked (VNMI_MASKED bit set) on the other hand, and a vNMI is pending, 
then we can't use EVENTINJ to inject the second NMI, but in this case KVM drops
the second NMI anyway.

It all seems to add up very nicely, please take a look at the patch series
([PATCH v2 00/11] SVM: vNMI (with my fixes))


Best regards,
	Maxim Levitsky 

> 
> When NMIs become unblocked, INTERCEPT_IRET can be cleared, but KVM should also
> pending KVM_REQ_EVENT.  AFAICT, that doesn't happen when this is called via the
> emulator.  Ah, because em_iret() only handles RM for Intel's restricted guest
> crap.  I.e. it "works" only because it never happens.  All other flows set
> KVM_REQ_EVENT when toggling NMI blocking, e.g. the RSM path of kvm_smm_changed().
> 
> And when NMIs become blocked, there's no need to force INTERCEPT_IRET in this
> code because kvm_check_and_inject_events() will request an NMI window and set the
> intercept if necessary, and all paths that set NMI blocking are guaranteed to
> reach kvm_check_and_inject_events() before entering the guest.
> 
>   1. RSM => kvm_smm_changed() sets KVM_REQ_EVENT
>   2. enter_smm() is only called from within kvm_check_and_inject_events(),
>      before pending NMIs are processed (yay priority)
>   3. emulator_set_nmi_mask() never blocks NMIs, only does the half-baked IRET emulation
>   4. kvm_vcpu_ioctl_x86_set_vcpu_event() sets KVM_REQ_EVENT
> 
> So, can you add a prep patch to drop the forced INTERCEPT_IRET?  That way the
> logic for vNMI and !vNMI is the same.
> 
> > +		else {
> > +			clear_vnmi_mask(svm);
> 
> This is the only code that sets/clears the vNMI mask, so rather than have set/clear
> helpers, what about a single helper to do the dirty work? 
> 
> > +			if (!sev_es_guest(vcpu->kvm))
> > +				svm_clr_intercept(svm, INTERCEPT_IRET);
> > +		}
> > +		return;
> > +	}
> > +
> >  	if (masked) {
> >  		vcpu->arch.hflags |= HF_NMI_MASK;
> >  		if (!sev_es_guest(vcpu->kvm))
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index f5383104d00580..bf7f4851dee204 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> >  extern bool npt_enabled;
> >  extern int vgif;
> >  extern bool intercept_smi;
> > +extern bool vnmi;
> >  
> >  enum avic_modes {
> >  	AVIC_MODE_NONE = 0,
> > @@ -531,6 +532,57 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
> >  	       (msr < (APIC_BASE_MSR + 0x100));
> >  }
> >  
> > +static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
> > +{
> > +	if (!vnmi)
> > +		return NULL;
> > +
> > +	if (is_guest_mode(&svm->vcpu))
> > +		return svm->nested.vmcb02.ptr;
> > +	else
> > +		return svm->vmcb01.ptr;
> > +}
> > +
> > +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> > +{
> > +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > +
> > +	if (vmcb)
> > +		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
> > +	else
> > +		return false;
> 
> Maybe just this?
> 
> 	return vmcb && (vmcb->control.int_ctl & V_NMI_ENABLE);
> 
> Or if an inner helper is added:
> 
> 	return vmcb && __is_vnmi_enabled(vmcb);
> 
> > +}
> > +
> > +static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
> > +{
> > +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > +
> > +	if (!WARN_ON_ONCE(!vmcb))
> 
> Rather than WARN, add an inner __is_vnmi_enabled() that takes the vnmi_vmcb.
> Actually, if you do that, the test/set/clear helpers can go away entirely.
> 
> > +		return false;
> > +
> > +	return !!(vmcb->control.int_ctl & V_NMI_MASK);
> > +}
> > +
> > +static inline void set_vnmi_mask(struct vcpu_svm *svm)
> > +{
> > +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > +
> > +	if (!WARN_ON_ONCE(!vmcb))
> > +		return;
> > +
> > +	vmcb->control.int_ctl |= V_NMI_MASK;
> > +}
> > +
> > +static inline void clear_vnmi_mask(struct vcpu_svm *svm)
> > +{
> > +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > +
> > +	if (!WARN_ON_ONCE(!vmcb))
> > +		return;
> > +
> > +	vmcb->control.int_ctl &= ~V_NMI_MASK;
> > +}
> 
> These helpers can all go in svm.  There are no users oustide of svm.c, and
> unless I'm misunderstanding how nested works, there should never be oustide users.
> 
> E.g. with HF_NMI_MASK => svm->nmi_masked, the end result can be something like:
> 
> static bool __is_vnmi_enabled(struct *vmcb)
> {
> 	return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
> }
> 
> static bool is_vnmi_enabled(struct vcpu_svm *svm)
> {
> 	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> 
> 	return vmcb && __is_vnmi_enabled(vmcb);
> }
> 
> static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> 
> 	if (vmcb && __is_vnmi_enabled(vmcb))
> 		return !!(vmcb->control.int_ctl & V_NMI_MASK);
> 	else
> 		return !!(vcpu->arch.hflags & HF_NMI_MASK);
> }
> 
> static void svm_set_or_clear_vnmi_mask(struct vmcb *vmcb, bool set)
> {
> 	if (set)
> 		vmcb->control.int_ctl |= V_NMI_MASK;
> 	else
> 		vmcb->control.int_ctl &= ~V_NMI_MASK;
> }
> 
> static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> 
> 	if (vmcb && __is_vnmi_enabled(vmcb)) {
> 		if (masked)
> 			vmcb->control.int_ctl |= V_NMI_MASK;
> 		else
> 			vmcb->control.int_ctl &= ~V_NMI_MASK;
> 	} else {
> 		svm->nmi_masked = masked;
> 	}
> 
> 	if (!masked)
> 		svm_disable_iret_interception(svm);
> }
> 


