Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E25D7AF0C3
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbjIZQbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 12:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjIZQbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 12:31:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1512911F
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:31:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f2c7a4f24so159434567b3.0
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695745893; x=1696350693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Wn5yFNxr/QwexNXkJRJPUudUF7GWFSc9e/F1NDlPqM=;
        b=Dmtakn5WVRiTCsMCuel7+bwNBmXtnueOiK9nR+UJz8t6c9/SjKdEvg6vUEQVN8WYAc
         5VNjVWJDx70ryjAQ6KkFsKU0t81Ogf+HdtL3MWL5P4H8n7WzIzN9oX/oOsKEwuN6Y3Xh
         Nyd661JLvEBLocSkiFj+4bOjXhY7OqdWID10FA5iUvFOAqOc7XafPgLisEeP7X5IsCvi
         /JgNtfuych9Bc1nKWXOIrDbBHW3q/dQHb2cqLvPfdXjX0g6Wz40sBYEebwl+bHrtva3Z
         DTSLe5Y6dKQI4e5XCsoBNTy2kl0WfzUgiB5jvspiEqsEY1wKDpfrdG1CKsebyChDJmLV
         SMEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695745893; x=1696350693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Wn5yFNxr/QwexNXkJRJPUudUF7GWFSc9e/F1NDlPqM=;
        b=k6k4T7mVkPl7IP5A9IxMbqVeXbSW3xeOJRWFy43Fh1aExPYRLl9VRaHHPuhYZ9kBes
         5q+vRcySB/3HRsRUIxyzZYrSpbrqU2qk/A6FZQntffMVi+Dk9wpKE4ap1ZSBB2M5n/b0
         H4WDlAxjb/QnSx9Wnc/v870Z6kALtxU+h1dJDJCzQjKzi5+KJBG2UxdkyJIHxlG5cKnr
         hbm3le2AtrDHYhydRNWKUrJuP0bJBzjbdJsY7qKujbB/hmNR7uamt3Upuf85u8JxaiwV
         KTRmdqLCDuXubkGoEkkdezpgjmfYCXfVTqDD3x1o9syoE7O3s7MZcBGLusJQEJzytLB9
         j+1Q==
X-Gm-Message-State: AOJu0YzNETQC8uqb1IDx+tE3FqN5hOAxbCnSjid3vkZCFnSK9GU7wOSu
        5Ms2o/bTfGuavk7a9vHFKQ+OI/i/HtY=
X-Google-Smtp-Source: AGHT+IEMtG1bvpmDHaWgoy2YPiL/ktACTEiywvlo11emnKWTOSojCRxl+cDTtN+21WlLssxuTUokcMizTdk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7607:0:b0:59b:ee27:bbe9 with SMTP id
 r7-20020a817607000000b0059bee27bbe9mr133240ywc.9.1695745893302; Tue, 26 Sep
 2023 09:31:33 -0700 (PDT)
Date:   Tue, 26 Sep 2023 09:31:31 -0700
In-Reply-To: <ZRJJtWC4ch0RhY/Y@luigi.stachecki.net>
Mime-Version: 1.0
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com> <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com> <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
 <ZQQKoIEgFki0KzxB@redhat.com> <ZQRNmsWcOM1xbNsZ@luigi.stachecki.net>
 <ZRH7F3SlHZEBf1I2@google.com> <ZRJJtWC4ch0RhY/Y@luigi.stachecki.net>
Message-ID: <ZRMHY83W/VPjYyhy@google.com>
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
From:   Sean Christopherson <seanjc@google.com>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, dgilbert@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023, Tyler Stachecki wrote:
> On Mon, Sep 25, 2023 at 02:26:47PM -0700, Sean Christopherson wrote:
> > On Fri, Sep 15, 2023, Tyler Stachecki wrote:
> > > OK - if there's no interest in the below, I will not push for including this
> > > patch in the kernel tree any longer. I do think the specific case below is what
> > > a vast majority of KVM users will struggle with in the near future, though:
> > >
> > > I have a test environment with Broadwell-based (have only AVX-256) guests
> > > running under Skylake (PKRU, AVX512, ...) hypervisors.
> > 
> > I definitely don't want to take the proposed patch.  As Leo pointed out, silently
> > dropping features that userspace explicitly requests is a recipe for disaster.
> > 
> > However, I do agree with Tyler that is an egregious kernel/KVM bug, as essentially
> > requiring KVM_SET_XSAVE to be a subset of guest supported XCR0, i.e. guest CPUID,
> > is a clearcut breakage of userspace.  KVM_SET_XSAVE worked on kernel X and failed
> > on kernel X+1, there's really no wiggle room there.
> > 
> > Luckily, I'm pretty sure there's no need to take features away from the guest in
> > order to fix the bug Tyler is experiencing.  Prior to commit ad856280ddea, KVM's
> > ABI was that KVM_SET_SAVE just needs a subset of the *host* features, i.e. this
> > chunk from the changelog simply needs to be undone:
> > 
> >     As a bonus, it will also fail if userspace tries to set fpu features
> >     (with the KVM_SET_XSAVE ioctl) that are not compatible to the guest
> >     configuration.  Such features will never be returned by KVM_GET_XSAVE
> >     or KVM_GET_XSAVE2.
> > 
> > That can be done by applying guest_supported_xcr0 to *only* the KVM_GET_XSAVE{2}
> > path.  It's not ideal since it means that KVM_GET_XSAVE{2} won't be consistent
> > with the guest model if userspace does KVM_GET_XSAVE{2} before KVM_SET_CPUID, but
> > practically speaking I don't think there's a real world userspace VMM that does
> > that.
> > 
> > Compile tested only, and it needs a changelog, but I think this will do the trick:

...

> > @@ -1059,7 +1060,8 @@ static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
> >   * It supports partial copy but @to.pos always starts from zero.
> >   */
> >  void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
> > -			       u32 pkru_val, enum xstate_copy_mode copy_mode)
> > +			       u64 xfeatures, u32 pkru_val,
> > +			       enum xstate_copy_mode copy_mode)
> >  {
> >  	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
> >  	struct xregs_state *xinit = &init_fpstate.regs.xsave;
> > @@ -1083,7 +1085,7 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
> >  		break;
> >  
> >  	case XSTATE_COPY_XSAVE:
> > -		header.xfeatures &= fpstate->user_xfeatures;
> > +		header.xfeatures &= fpstate->user_xfeatures & xfeatures;
> >  		break;
> 
> This changes the consideration of the xfeatures copied *into* the uabi buffer
> with respect to the guest xfeatures IIUC (approx guest XCR0, less FP/SSE only).
> 
> IOW: we are still trimming guest xfeatures, just at the source...?

KVM *must* "trim" features when servicing KVM_GET_SAVE{2}, because that's been KVM's
ABI for a very long time, and userspace absolutely relies on that functionality
to ensure that a VM can be migrated within a pool of heterogenous systems so long
as the features that are *exposed* to the guest are supported on all platforms.

Before the big FPU rework, KVM manually filled xregs_state and directly "trimmed"
based on the guest supported XCR0 (see fill_xsave() below).

The major difference between my proposed patch and the current code is that KVM
trims *only* at KVM_GET_XSAVE{2}, which in addition to being KVM's historical ABI,
(see load_xsave() below), ensures that the *destination* can load state irrespective
of the possibly-not-yet-defined guest CPUID model.

Masking fpstate->user_xfeatures is buggy for another reason: it's destructive if
userspace calls KVM_SET_CPUID multiple times.  No real world userspace actually
calls KVM_SET_CPUID to "expand" features, but it's technically possible and KVM
is supposed to allow it.

static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
{
        struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
        u64 xstate_bv = xsave->header.xfeatures;
        u64 valid;

        /*
         * Copy legacy XSAVE area, to avoid complications with CPUID
         * leaves 0 and 1 in the loop below.
         */
        memcpy(dest, xsave, XSAVE_HDR_OFFSET);

        /* Set XSTATE_BV */
        xstate_bv &= vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FPSSE;  <= here lies the trimming
        *(u64 *)(dest + XSAVE_HDR_OFFSET) = xstate_bv;

        /*
         * Copy each region from the possibly compacted offset to the
         * non-compacted offset.
         */
        valid = xstate_bv & ~XFEATURE_MASK_FPSSE;
        while (valid) {
                u64 feature = valid & -valid;
                int index = fls64(feature) - 1;
                void *src = get_xsave_addr(xsave, feature);

                if (src) {
                        u32 size, offset, ecx, edx;
                        cpuid_count(XSTATE_CPUID, index,
                                    &size, &offset, &ecx, &edx);
                        if (feature == XFEATURE_MASK_PKRU)
                                memcpy(dest + offset, &vcpu->arch.pkru,
                                       sizeof(vcpu->arch.pkru));
                        else
                                memcpy(dest + offset, src, size);

                }

                valid -= feature;
        }
}

static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
{
        struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
        u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
        u64 valid;

        /*
         * Copy legacy XSAVE area, to avoid complications with CPUID
         * leaves 0 and 1 in the loop below.
         */
        memcpy(xsave, src, XSAVE_HDR_OFFSET);

        /* Set XSTATE_BV and possibly XCOMP_BV.  */
        xsave->header.xfeatures = xstate_bv;                <= features NOT limited to guest support
        if (boot_cpu_has(X86_FEATURE_XSAVES))
                xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;

        /*
         * Copy each region from the non-compacted offset to the
         * possibly compacted offset.
         */
        valid = xstate_bv & ~XFEATURE_MASK_FPSSE;
        while (valid) {
                u64 feature = valid & -valid;
                int index = fls64(feature) - 1;
                void *dest = get_xsave_addr(xsave, feature);

                if (dest) {
                        u32 size, offset, ecx, edx;
                        cpuid_count(XSTATE_CPUID, index,
                                    &size, &offset, &ecx, &edx);
                        if (feature == XFEATURE_MASK_PKRU)
                                memcpy(&vcpu->arch.pkru, src + offset,
                                       sizeof(vcpu->arch.pkru));
                        else
                                memcpy(dest, src + offset, size);
                }

                valid -= feature;
        }
}

static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
                                        struct kvm_xsave *guest_xsave)
{
        u64 xstate_bv =
                *(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
        u32 mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];

        if (boot_cpu_has(X86_FEATURE_XSAVE)) {
                /*
                 * Here we allow setting states that are not present in
                 * CPUID leaf 0xD, index 0, EDX:EAX.  This is for compatibility
                 * with old userspace.
                 */
                if (xstate_bv & ~kvm_supported_xcr0() ||  <= loading more than KVM supports is disallowed
                        mxcsr & ~mxcsr_feature_mask)
                        return -EINVAL;
                load_xsave(vcpu, (u8 *)guest_xsave->region);
        } else {
                if (xstate_bv & ~XFEATURE_MASK_FPSSE ||
                        mxcsr & ~mxcsr_feature_mask)
                        return -EINVAL;
                memcpy(&vcpu->arch.guest_fpu->state.fxsave,
                        guest_xsave->region, sizeof(struct fxregs_state));
        }
        return 0;
}


> That being said: the patch that I gave siliently allows unacceptable things to
> be accepted at the destination, whereas this maintains status-quo and signals
> an error when the destination cannot wholly process the uabi buffer (i.e.,
> asked to restore more state than the destination processor has present).
> 
> The downside of my approach is above -- the flip side, though is that this
> approach requires a patch to be applied on the source. However, we cannot
> apply a patch at the source until it is evacuated of VMs -- chicken and egg
> problem...
> 
> Unless I am grossly misunderstanding things here -- forgive me... :-)

I suspect you're overlooking the impact on the destination.  Trimming features
only when saving XSAVE state into the userspace buffer means that the destination
will play nice with the "bad" snapshot.  It won't help setups where a VM is being
migrated from a host with more XSAVE features to a host with fewer XSAVE features,
but I don't see a sane way to retroactively fix that situation.  And IIUC, that's
not the situation you're in (unless the Skylake host vs. Broadwell guests is only
the test environment).

Silently dropping features would break KVM's ABI (see kvm_vcpu_ioctl_x86_set_xsave()
above).  Giving userspace a flag to opt-in is pointless because that requires a
userspace update, and if userspace needs to be modified then it's simpler to just
have userspace sanitize the xfeatures field.
