Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DC84BA667
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243435AbiBQQui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:50:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243430AbiBQQuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:50:37 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 051AF2B356E
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:50:21 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C63E3113E;
        Thu, 17 Feb 2022 08:50:20 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 681DD3F70D;
        Thu, 17 Feb 2022 08:50:19 -0800 (PST)
Date:   Thu, 17 Feb 2022 16:50:42 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sebastian Ene <sebastianene@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, will@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH kvmtool v2] aarch64: Add stolen time support
Message-ID: <Yg584hgsmmrigkck@monolith.localdoman>
References: <Yg5lBZKsSoPNmVkT@google.com>
 <Yg5tE3TqgwWRFypB@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg5tE3TqgwWRFypB@monolith.localdoman>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Feb 17, 2022 at 03:43:15PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> Some general comments while I familiarize myself with the stolen time spec.
> 
> On Thu, Feb 17, 2022 at 03:08:53PM +0000, Sebastian Ene wrote:
[..]
> >  
> > +	/* Populate the vcpu structure. */
> > +	vcpu->kvm		= kvm;
> > +	vcpu->cpu_id		= cpu_id;
> > +	vcpu->cpu_type		= vcpu_init.target;
> > +	vcpu->cpu_compatible	= target->compatible;
> > +	vcpu->is_running	= true;
> > +
> >  	if (err || target->init(vcpu))
> >  		die("Unable to initialise vcpu");
> >  
> > @@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >  		vcpu->ring = (void *)vcpu->kvm_run +
> >  			     (coalesced_offset * PAGE_SIZE);
> >  
> > -	/* Populate the vcpu structure. */
> > -	vcpu->kvm		= kvm;
> > -	vcpu->cpu_id		= cpu_id;
> > -	vcpu->cpu_type		= vcpu_init.target;
> > -	vcpu->cpu_compatible	= target->compatible;
> > -	vcpu->is_running	= true;
> > -
> 
> Why this change?

Got it know, it's needed for target->init, which is actually arm_cpu__vcpu_init.
Weird that it wasn't that way in the first place, but that's because of the
awkwardness of generating the fdt nodes for the gic/timer/pmu.

Thanks,
Alex

> 
> Thanks,
> Alex
> 
> >  	if (kvm_cpu__configure_features(vcpu))
> >  		die("Unable to configure requested vcpu features");
> >  
> > -- 
> > 2.35.1.265.g69c8d7142f-goog
> > 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
