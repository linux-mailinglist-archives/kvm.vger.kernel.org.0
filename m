Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0880324607
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 23:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhBXWAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 17:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhBXWAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 17:00:10 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E7BC061574
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 13:59:30 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id d2so2272502pjs.4
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 13:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/CVEf8kH6OkawN7bK/tRH/T7unq1LCdjukFz2ij9PiQ=;
        b=d+0UgUy/b3iC3Mlj9DJa7YkAh7g3jXDKDphlIZ9elfaKoBV6AnK2TDVf1wljEPlsOL
         f3H8i1yxJL/+q/Ms1SHB1k+rQv4gl+h7wyTDzpHz0MNBwPR1dCmnz77KdR4xZ5kAnHKZ
         Y8MoRrhBw9Hgcbu342BzEcV+MMv99xyqwyJ+IDCQd0FaiQ+q3V/0/NGCuBuc2DueT/DO
         JK6ALKWcV6lI5d19XBgnuVoVEk8lTBt5xlHiDFrSJDfZOYohgzrYripV0D3/3BnleFpM
         fJL+qYBRSMUfRcEG8Sk+0ONYg3GXeTjPkMwbkcTGHJ+9NeuX8tKkKO3fZJQW4vPoCi17
         v1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/CVEf8kH6OkawN7bK/tRH/T7unq1LCdjukFz2ij9PiQ=;
        b=cEIA3r1rwGTwkiuPmsHaMfjIEz3AIjhZxJxNT/fWz6FqLIXGXmD0vT2Yr+I30UgcD/
         Wg6YleruGViMu7lSjQ9abMoacACvpNmpI+0PGu2pP8maLnWQNtK9rANjwSrqf39nn9zl
         UEYJs5ZU7sWKTpOiFcMaVlHwAnlzocf+sU+C1tB0wHGbSLaUCdjaHpZf0tUaHWcezgpL
         hAfmOTjBoWYGZblxvN5pg+0wNH29DBdklnaz7h1KvVhvVPdwsaRp6iYg0cPUpJQH5Wj7
         21RTwupl3TmsXDWeGe6b5A+j6BhlK9uSoVQGnfSFxLKCKN24aW7ccZe5MFjTKe+brQyq
         RcIw==
X-Gm-Message-State: AOAM530Xp23gvJyE1TwdADGokwRrpnMexIc8p3WLRQzqvfNTf+Dlpovc
        PodM7l3w7QyZMBRgwd1b4xHGDw==
X-Google-Smtp-Source: ABdhPJwG44FiiM2evw+bPBEUnGZcVMY/rhrbUhY1OLzKfEvnswxmkZpAu6qqNdJj78R6DvI7amvDPg==
X-Received: by 2002:a17:90a:f987:: with SMTP id cq7mr6808461pjb.47.1614203969972;
        Wed, 24 Feb 2021 13:59:29 -0800 (PST)
Received: from google.com ([2620:15c:f:10:385f:4012:d20f:26b5])
        by smtp.gmail.com with ESMTPSA id p23sm3648145pfn.204.2021.02.24.13.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 13:59:29 -0800 (PST)
Date:   Wed, 24 Feb 2021 13:59:23 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/4 v3] KVM: nSVM: Do not advance RIP following VMRUN
 completion if the latter is single-stepped
Message-ID: <YDbMOxqQLw5Q2Iy1@google.com>
References: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
 <20210223191958.24218-2-krish.sadhukhan@oracle.com>
 <YDWE3cYXoQRq+XZ3@google.com>
 <0e553de2-2797-9811-b2a4-8d1467ab64e8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e553de2-2797-9811-b2a4-8d1467ab64e8@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021, Krish Sadhukhan wrote:
> 
> On 2/23/21 2:42 PM, Sean Christopherson wrote:
> > On Tue, Feb 23, 2021, Krish Sadhukhan wrote:
> > > Currently, svm_vcpu_run() advances the RIP following VMRUN completion when
> > > control returns to host. This works fine if there is no trap flag set
> > > on the VMRUN instruction i.e., if VMRUN is not single-stepped. But if
> > > VMRUN is single-stepped, this advancement of the RIP leads to an incorrect
> > > RIP in the #DB handler invoked for the single-step trap. Therefore, check

Whose #DB handler?  L1's?

> > > if the VMRUN instruction is single-stepped and if so, do not advance the RIP
> > > when the #DB intercept #VMEXIT happens.
> > This really needs to clarify which VMRUN, i.e. L0 vs. L1.  AFAICT, you're
> > talking about both at separate times.  Is this an issue with L1 single-stepping
> > its VMRUN, L0 single-stepping its VMRUN, L0 single-stepping L1's VMRUN, ???
> 
> 
> The issue is seen when L1 single-steps its own VMRUN. I will fix the
> wording.

...

> > > @@ -3827,7 +3833,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
> > >   		vcpu->arch.cr2 = svm->vmcb->save.cr2;
> > >   		vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
> > >   		vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
> > > -		vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
> > > +		if (single_step_vmrun && svm->vmcb->control.exit_code ==
> > > +		    SVM_EXIT_EXCP_BASE + DB_VECTOR)
> > > +			single_step_vmrun = false;
> > Even if you fix the global flag issue, this can't possibly work if userspace
> > changes state, if VMRUN fails and leaves a timebomb, and probably any number of
> > other conditions.
> 
> 
>  Are you saying that I need to adjust the RIP in cases where VMRUN fails ?

If VMRUN fails, the #DB exit will never occur and single_step_vmrun will be left
set.  Ditto if a higher priority exit occurs, though I'm not sure that can cause
problems in practice.  Anyways, my point is that setting a flag that must be
consumed on an exact instruction is almost always fragile, there are just too
many corner cases that pop up.

Can you elaborate more on who/what incorrectly advances RIP?  The changelog says
"svm_vcpu_run() advances the RIP", but it's not advancing anything it's just
grabbing RIP from the VMCB, which IIUC is L2's RIP.
