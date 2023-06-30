Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F347B744124
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 19:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbjF3RYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 13:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjF3RY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 13:24:28 -0400
Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [IPv6:2001:41d0:203:375::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88ACF1713
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:24:24 -0700 (PDT)
Date:   Fri, 30 Jun 2023 17:24:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688145862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JEgiQFbtqMAhuryJj77jXTyIRFEwAksjrjxqtSP6Jpk=;
        b=PnIumV092qsEvd5Z3GRY627vjHr/QAzlEmygzkJfzxtT+vT/kCNuema38wnD0QczkJBNs9
        GS9RlV8VLRCR/dnEJCkvfJyLgvrUIlVIFA9VMoBbvQbsUA5Yf834XiQR8u8MknJRZtpeR7
        AVqDiG/EagK+xnoAZVRzYivTGYgMAaE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/tsc: Update guest tsc_offset again before vcpu
 first runs
Message-ID: <ZJ8Pw3YMrYbwgcP2@linux.dev>
References: <20230629164838.66847-1-likexu@tencent.com>
 <ZJ29KhiVLyAq/7Sh@google.com>
 <ZJ8PIbHfhc0oYB8/@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ8PIbHfhc0oYB8/@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 05:21:41PM +0000, Oliver Upton wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c30364152fe6..43d40f058a41 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2721,14 +2721,14 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
> >  			 * kvm_clock stable after CPU hotplug
> >  			 */
> >  			synchronizing = true;
> > -		} else {
> > +		} else if (kvm_vcpu_has_run(vcpu)) {
> >  			u64 tsc_exp = kvm->arch.last_tsc_write +
> >  						nsec_to_cycles(vcpu, elapsed);
> >  			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
> >  			/*
> >  			 * Special case: TSC write with a small delta (1 second)
> > -			 * of virtual cycle time against real time is
> > -			 * interpreted as an attempt to synchronize the CPU.
> > +			 * of virtual cycle time against real time on a running
> > +			 * vCPU is interpreted as an attempt to synchronize.
> >  			 */
> >  			synchronizing = data < tsc_exp + tsc_hz &&
> >  					data + tsc_hz > tsc_exp;
> 
> This would break existing save/restore patterns for the TSC. QEMU relies
> on KVM synchronizing the TSCs when restoring a VM, since it cannot
> snapshot the TSC values of all the vCPUs in a single instant. It instead
> tries to save the TSCs at roughly the same time [*], which KVM detects
> on the target and gets everything back in sync. Can't wait to see when
> this heuristic actually breaks :)

Of course, forgot to actually include the link.

[*] https://gitlab.com/qemu-project/qemu/-/blob/408015a97dbe48a9dde8c0d2526c9312691952e7/target/i386/kvm/kvm.c#L249

-- 
Thanks,
Oliver
