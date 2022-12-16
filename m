Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19AA64F15D
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 20:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiLPTER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 14:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiLPTEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 14:04:07 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847696C731
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 11:04:05 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w26so2404198pfj.6
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 11:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aGzwqPNSxCpWhN2cMHee9j6iCzacXsV8AGFFZBbCO34=;
        b=HihVCXHIxqohFeVo6zYSI1IkxtQMPvzFeTSMnqIU6PZ26Clbc6VRgP4j7vx3uL/PBs
         1DuSUj+BM37ylcqezxKeL8znQtKjYRxt00BPowYqF+9frQE97BgNR2qkN+GYOWA2gH9Z
         LGHCLSGCrVWWGpvbT0lNNUmYKcUHvglvNkopJzJ36snp+TZHUtaGeTn7pi/JV8wiCqgT
         gWknt70WNgv/vlJVo8/PTe95DDizk+i0JqwrSUFe5HNwjfPNUNcrq25UkilTQf34oPB7
         FHzuxzNpDVaaMSUivn6mCuNXY0QnzFZmjy+U5ugBWSNqI1JV+mDFBOWTVmgP1fQ7o7WY
         qX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGzwqPNSxCpWhN2cMHee9j6iCzacXsV8AGFFZBbCO34=;
        b=zV1n9nw98RPY9FJ4sH9Jrp+B7V8L577sr/8RwTgSuZP/MYQAyqsxuO8mmnOE4Y2D+p
         +X6/FIvt0jTNYLKb15dSY12P3VuOSHuBQrQLT0iZyncEl25TKHkoWz5iggxeQ3p4wN4b
         5H52G66gbLZPdyHBccEmzy5JkpLs8O/bdSb91BgmHOkTGOzSeapRKfYJAdMkqJ4qmpQj
         gUhdDuazYJKVy2wzFHMgDvNQParXrcd3/qXqtSqjNAmBeDow1la55DN/pcqUD8YYIiMf
         KpYI2o0FW1Bv0RDmhU+TOdqjdgq3poal478RBcpLYB5aix+4zMc6FJSTqXJIH2dPMMBw
         u/1w==
X-Gm-Message-State: AFqh2koO/Dt0w+ep/BsuMbL6Nk1svBavzPlngxoGQLxvtHwOdfS/efR1
        s381FupNztU0nGVg4WqEbpmypA==
X-Google-Smtp-Source: AMrXdXtAUBDJKAahjbRhwrXdcPadt0Lkxuvj5iRurFgRIC/CPbbKp9+5D2rgJ1TJz9r77VFc8ADnig==
X-Received: by 2002:a05:6a00:418f:b0:576:22d7:fd9e with SMTP id ca15-20020a056a00418f00b0057622d7fd9emr672910pfb.0.1671217444858;
        Fri, 16 Dec 2022 11:04:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g15-20020aa79f0f000000b0056b2e70c2f5sm1836646pfr.25.2022.12.16.11.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 11:04:03 -0800 (PST)
Date:   Fri, 16 Dec 2022 19:03:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v4 11/32] KVM: x86: Inhibit APIC memslot if x2APIC and
 AVIC are enabled
Message-ID: <Y5zBH+2VuPJi4yYV@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
 <20221001005915.2041642-12-seanjc@google.com>
 <90d4a2a1733cdb21e7c00843ddafee78ce52bbdc.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90d4a2a1733cdb21e7c00843ddafee78ce52bbdc.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022, Maxim Levitsky wrote:
> On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index d40206b16d6c..062758135c86 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1139,6 +1139,17 @@ enum kvm_apicv_inhibit {
> >  	 * AVIC is disabled because SEV doesn't support it.
> >  	 */
> >  	APICV_INHIBIT_REASON_SEV,
> > +
> > +	/*
> > +	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
> > +	 * deleted if any vCPU has x2APIC enabled as SVM doesn't provide fully
> > +	 * independent controls for AVIC vs. x2AVIC, and also because SVM
> > +	 * supports a "hybrid" AVIC mode for CPUs that support AVIC but not
> > +	 * x2AVIC.  Note, this isn't a "full" inhibit and is tracked separately.
> > +	 * AVIC can still be activated, but KVM must not create SPTEs for the
> > +	 * APIC base.  For simplicity, this is sticky.
> > +	 */
> > +	APICV_INHIBIT_REASON_X2APIC,
> 
> I still don't understand why do you want this to be an inhibit bit.

Because in my mental model, it's an inhibit, but with special properties.  But I
totally get why that's confusing.

> Now this 'inhibit' is not even set/clear.
> 
> I prefer to just have a boolean 'is_avic' or,
> '.needs_x2apic_memslot_inhibition' in the vendor ops, and check it in
> 'kvm_vcpu_update_apicv' with the above comment on top of it.
> 
> need_x2apic_memslot_inhibition can even be set to false when x2avic is
> supported at the initalization time, because then AVIC behaves just like
> APICv (when x2avic bit is enabled, AVIC mmio is no longer decoded).

Oh, so SVM does effectively have independent controls, it's only the "hybrid" mode
that's affected?  In that case, how about this?

	/*
	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
	 * deleted if any vCPU has x2APIC enabled and hardware doesn't support
	 * x2APIC virtualization.  E.g. some AMD CPUs support AVIC but not
	 * x2AVIC.  KVM still allows enabling AVIC in this case so that KVM can
	 * the AVIC doorbell to inject interrupts to running vCPUs, but KVM
	 * mustn't create SPTEs for the APIC base as the vCPU would incorrectly
	 * be able to access the vAPIC page via MMIO despite being in x2APIC
	 * mode.  For simplicity, inhibiting the APIC access page is sticky.
	 */
	if (apic_x2apic_mode(vcpu->arch.apic) &&
	    !kvm_x86_ops.has_hardware_x2apic_virtualization)
		kvm_inhibit_apic_access_page(vcpu)
