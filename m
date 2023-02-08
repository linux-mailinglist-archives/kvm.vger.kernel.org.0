Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399B768F2D0
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 17:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjBHQGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 11:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBHQGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 11:06:21 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EE52B635
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 08:06:17 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k13so19843256plg.0
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 08:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1RtT+tmNqFzYW9HFGM8EiaI8TKYfazSEO+jRCB5fHBM=;
        b=HxRg9Dpekes1pQDkH4qCpvH0JGYHdkE0cK2Ln4fi0Xg66hKQdwXMVWA0ChixwzsopN
         VdQEdaTi13WOEMP7OqMqPyIoBCfm8451w0S3WT1f5mp4GeWkX/2dgJq91ceXRdo3f/7J
         sJHVmswLBla7N36r8/I5jd4y21mZs16uXbbdhfdemYyrzhKzZRmmAaYxChIjSDogHDuF
         U2gKiMWVBYNVh6IUN/Q/1iDLcJsyjv2DWABywNLP0kIYGTkdbJyugKvkZXGd0saQFoGh
         EyKYgXwhXaafZvbYkAO7BgYM7eMAY2otiCkiHF/pQQGWg7zzddlNROwBA3JTQIbJLSgT
         7O5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1RtT+tmNqFzYW9HFGM8EiaI8TKYfazSEO+jRCB5fHBM=;
        b=l/cJbN8GyYrmpQcMjpU4ubk5oijFsStJPf+y16Fed1XqSTPT335oSoLiWdTYHOKvWb
         osOglyqlZUC3zv7zsw3u3gXc67zHasMmA8+j6CULSQH1Ta4Ks4dos/XWPcvcxCBzeB2W
         voOO4craukh1YsoguPLqs1JdQGtN4/VvmV67DfbIqajZr9hpkNtF8wwh/NjjygMNqVdp
         geYx8+eZOGvSmwWzPIVF3Zdt4b5ywIdf9fDp3UdG18rmVB3VvC1pYZTREXcdrWQgN0KN
         ou1GzlaokDjhDrPOtxWlnVyZ9Fuj+Igean+KdGYMAYRWqR7luDdrPSmKvD/4tXaTmlKm
         5lug==
X-Gm-Message-State: AO0yUKWGnYYqekzmAUvm53ZXgjMZ03mKPNtyvSF2tzd2Czm9RDBMakk5
        CKGpg4CF/LkWiesfVa80qTEYtQ==
X-Google-Smtp-Source: AK7set8pMqKg9DFJGTafjS3G2UGl2pR8NOlAITtC9bO6vN7fe7/inI2GQVMA092aFj5i5vHLH+lqKw==
X-Received: by 2002:a17:903:2446:b0:198:af50:e4ea with SMTP id l6-20020a170903244600b00198af50e4eamr266926pls.16.1675872376690;
        Wed, 08 Feb 2023 08:06:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u206-20020a6279d7000000b0059085684b54sm11875051pfc.140.2023.02.08.08.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 08:06:16 -0800 (PST)
Date:   Wed, 8 Feb 2023 16:06:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
Message-ID: <Y+PIdJZtCsGH2Sw3@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com>
 <Y9mWFlGdzoa8ZDW7@google.com>
 <a59505b3-5405-0409-bbf1-34466932c2c1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a59505b3-5405-0409-bbf1-34466932c2c1@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08, 2023, Santosh Shukla wrote:
> On 2/1/2023 3:58 AM, Sean Christopherson wrote:
> > On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> >> @@ -5191,9 +5191,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> >>  
> >>  	vcpu->arch.nmi_injected = events->nmi.injected;
> >>  	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
> >> -		vcpu->arch.nmi_pending = events->nmi.pending;
> >> +		atomic_add(events->nmi.pending, &vcpu->arch.nmi_queued);
> >> +
> >>  	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> >>  
> >> +	process_nmi(vcpu);
> > 
> > Argh, having two process_nmi() calls is ugly (not blaming your code, it's KVM's
> > ABI that's ugly).  E.g. if we collapse this down, it becomes:
> > 
> > 	process_nmi(vcpu);
> > 
> > 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> > 		<blah blah blah>
> > 	}
> > 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> > 
> > 	process_nmi(vcpu);
> > 
> > And the second mess is that V_NMI needs to be cleared.
> > 
> 
> Can you please elaborate on "V_NMI cleared" scenario? Are you mentioning
> about V_NMI_MASK or svm->nmi_masked?

V_NMI_MASK.  KVM needs to purge any pending virtual NMIs when userspace sets
vCPU event state and KVM_VCPUEVENT_VALID_NMI_PENDING is set.

> > The first process_nmi() effectively exists to (a) purge nmi_queued and (b) keep
> > nmi_pending if KVM_VCPUEVENT_VALID_NMI_PENDING is not set.  I think we can just
> > replace that with an set of nmi_queued, i.e.
> > 
> > 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> > 		vcpu->arch-nmi_pending = 0;	
> > 		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
> > 		process_nmi();
> > 
> You mean replace above process_nmi() with kvm_make_request(KVM_REQ_NMI, vcpu), right?
> I'll try with above proposal.

Yep, if that works.  Actually, that might be a requirement.  There's a

  static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);

lurking below this.  Invoking process_nmi() before NMI blocking is updated could
result in KVM incorrectly dropping/keeping NMIs.  I don't think it would be a
problem in practice since KVM save only one NMI, but userspace could stuff NMIs.

Huh.  The the existing code is buggy.  events->nmi.pending is a u8, and
arch.nmi_pending is an unsigned int.  KVM doesn't cap the incoming value, so
userspace could set up to 255 pending NMIs.  The extra weird part is that the extra
NMIs will get dropped the next time KVM stumbles through process_nmi().

Amusingly, KVM only saves one pending NMI, i.e. in a true migration scenario KVM
may drop an NMI.

  events->nmi.pending = vcpu->arch.nmi_pending != 0;

The really amusing part is that that code was added by 7460fb4a3400 ("KVM: Fix
simultaneous NMIs").  The only thing I can figure is that KVM_GET_VCPU_EVENTS was
somewhat blindly updated without much thought about what should actually happen.

So, can you slide the below in early in the series?  Then in this series, convert
to the above suggested flow (zero nmi_pending, stuff nmi_queued) in another patch?

From: Sean Christopherson <seanjc@google.com>
Date: Wed, 8 Feb 2023 07:44:16 -0800
Subject: [PATCH] KVM: x86: Save/restore all NMIs when multiple NMIs are
 pending

Save all pending NMIs in KVM_GET_VCPU_EVENTS, and queue KVM_REQ_NMI if one
or more NMIs are pending after KVM_SET_VCPU_EVENTS in order to re-evaluate
pending NMIs with respect to NMI blocking.

KVM allows multiple NMIs to be pending in order to faithfully emulate bare
metal handling of simultaneous NMIs (on bare metal, truly simultaneous
NMIs are impossible, i.e. one will always arrive first and be consumed).
Support for simultaneous NMIs botched the save/restore though.  KVM only
saves one pending NMI, but allows userspace to restore 255 pending NMIs
as kvm_vcpu_events.nmi.pending is a u8, and KVM's internal state is stored
in an unsigned int.

7460fb4a3400 ("KVM: Fix simultaneous NMIs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..e9339acbf82a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5115,7 +5115,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
-	events->nmi.pending = vcpu->arch.nmi_pending != 0;
+	events->nmi.pending = vcpu->arch.nmi_pending;
 	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
 
 	/* events->sipi_vector is never valid when reporting to user space */
@@ -5202,8 +5202,11 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 						events->interrupt.shadow);
 
 	vcpu->arch.nmi_injected = events->nmi.injected;
-	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
+	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
 		vcpu->arch.nmi_pending = events->nmi.pending;
+		if (vcpu->arch.nmi_pending)
+			kvm_make_request(KVM_REQ_NMI, vcpu);
+	}
 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&

base-commit: 6c77ae716d546d71b21f0c9ee7d405314a3f3f9e
-- 

