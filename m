Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F826683AEF
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 01:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjBAAG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 19:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBAAG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 19:06:58 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071183C22
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 16:06:54 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so304116pjb.3
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 16:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uwMyx62RgZ8ZzNd2t+9VROGTOFE4BqQ6xyWwz4l1Y6c=;
        b=QIziTP4CBKhKc5X7y5k9og2JiA6HVgl8WqenlHZGB8s0obMIChC7YeVpDyr20hzCWI
         Alcp6LWCxbVzbEGraaFFnHSfZUWLAUohwAbzs00DQbUmCVJ+RATEEg2PAbbOiEHZXJRW
         o2VgBx826Hs4MVPaHqfoQFwnG2khe9i4W+G3c1qy2NeeJAggXnYL1nolny0nl579lYCD
         9QiFaGgbFTOoMY+RLnjMbdkc9ZdZIT46kh2s3IIDMTKsou73dtf4Cp0fs/6eTz+8uAM6
         PkiugVblqg9OD/BbXruewKZ/rcDnvB1FAkEqlO6a1+anLQ13BEj7w1pMJVjqlp3OZRwl
         9V+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwMyx62RgZ8ZzNd2t+9VROGTOFE4BqQ6xyWwz4l1Y6c=;
        b=cMBY+3uf+T3w3qn9ZnjRPKO/lV+8oCPNSqT8TTtMfdqoGVWHY1lpD4c95mPRRNgxvB
         K1A/YzOMfGBQlfufpXV/mJ9ASIIAfqWpz4P6kT2zOitxzZWpif/l+wD33JwO8lsRPYMn
         outnU1ATK3WSI1A9O6DcoJ7lZu4e6ALfXcaA+UQWLzw70/oQ9Ti8zzcSMpWDI1GS3RMP
         RQlPH+TODXyZPxdNa/JznJewuP78BSAK+TLNvjVaGDM/q2aE+6tcoBwLdbuAw0KVGoxc
         DxEaUByof7o2DwIZuo5YLLaXbEtamEqg3l2uvFXwSmVGj6+1zvsbxDBCEcRW+S8gIF9A
         f5MA==
X-Gm-Message-State: AO0yUKWE4qxCRaZqdrEbso3ZPevw/ED54UWlhpgPeydE76fh1Pbaboe0
        bTgjQ7C3gMklXCiCF+SimpMKgA==
X-Google-Smtp-Source: AK7set/FHTCTa3LBnspvtun6D420F+akWB08oS4ObuaxwC5SqKaa0c6mHqFYx79vm8O9c2Hk9OFEJw==
X-Received: by 2002:a17:902:d34c:b0:194:d5ff:3ae3 with SMTP id l12-20020a170902d34c00b00194d5ff3ae3mr184325plk.2.1675210013323;
        Tue, 31 Jan 2023 16:06:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902820300b0019600b78487sm10329852pln.33.2023.01.31.16.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:06:52 -0800 (PST)
Date:   Wed, 1 Feb 2023 00:06:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
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
Message-ID: <Y9mtGV+q0P2U9+M1@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com>
 <Y9mWFlGdzoa8ZDW7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9mWFlGdzoa8ZDW7@google.com>
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

On Tue, Jan 31, 2023, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> > @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
> >  	 * Otherwise, allow two (and we'll inject the first one immediately).
> >  	 */
> >  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
> > -		limit = 1;
> > +		limit--;
> > +
> > +	/* Also if there is already a NMI hardware queued to be injected,
> > +	 * decrease the limit again
> > +	 */
> > +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
> > +		limit--;
> 
> I don't think this is correct.  If a vNMI is pending and NMIs are blocked, then
> limit will end up '0' and KVM will fail to pend the additional NMI in software.

Scratch that, dropping the second NMI in this case is correct.  The "running" part
of the existing "x86 is limited to one NMI running, and one NMI pending after it"
confused me.  The "running" thing is really just a variant on NMIs being blocked.

I'd also like to avoid the double decrement logic.  Accounting the virtual NMI is
a very different thing than dealing with concurrent NMIs, I'd prefer to reflect
that in the code.

Any objection to folding in the below to end up with:

	unsigned limit;

	/*
	 * x86 is limited to one NMI pending, but because KVM can't react to
	 * incoming NMIs as quickly as bare metal, e.g. if the vCPU is
	 * scheduled out, KVM needs to play nice with two queued NMIs showing
	 * up at the same time.  To handle this scenario, allow two NMIs to be
	 * (temporarily) pending so long as NMIs are not blocked and KVM is not
	 * waiting for a previous NMI injection to complete (which effectively
	 * blocks NMIs).  KVM will immediately inject one of the two NMIs, and
	 * will request an NMI window to handle the second NMI.
	 */
	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
		limit = 1;
	else
		limit = 2;

	/*
	 * Adjust the limit to account for pending virtual NMIs, which aren't
	 * tracked in in vcpu->arch.nmi_pending.
	 */
	if (static_call(kvm_x86_is_vnmi_pending)(vcpu))
		limit--;

	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);

	if (vcpu->arch.nmi_pending)
		kvm_make_request(KVM_REQ_EVENT, vcpu);

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 31 Jan 2023 16:02:21 -0800
Subject: [PATCH] KVM: x86: Tweak the code and comment related to handling
 concurrent NMIs

Tweak the code and comment that deals with concurrent NMIs to explicitly
call out that x86 allows exactly one pending NMI, but that KVM needs to
temporarily allow two pending NMIs in order to workaround the fact that
the target vCPU cannot immediately recognize an incoming NMI, unlike bare
metal.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 030136b6ebbd..fda09ba48b6b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10122,15 +10122,22 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 
 static void process_nmi(struct kvm_vcpu *vcpu)
 {
-	unsigned limit = 2;
+	unsigned limit;
 
 	/*
-	 * x86 is limited to one NMI running, and one NMI pending after it.
-	 * If an NMI is already in progress, limit further NMIs to just one.
-	 * Otherwise, allow two (and we'll inject the first one immediately).
+	 * x86 is limited to one NMI pending, but because KVM can't react to
+	 * incoming NMIs as quickly as bare metal, e.g. if the vCPU is
+	 * scheduled out, KVM needs to play nice with two queued NMIs showing
+	 * up at the same time.  To handle this scenario, allow two NMIs to be
+	 * (temporarily) pending so long as NMIs are not blocked and KVM is not
+	 * waiting for a previous NMI injection to complete (which effectively
+	 * blocks NMIs).  KVM will immediately inject one of the two NMIs, and
+	 * will request an NMI window to handle the second NMI.
 	 */
 	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
 		limit = 1;
+	else
+		limit = 2;
 
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);

base-commit: 07222b33fd1af78dca77c7c66db31477f1b87f0f
-- 

