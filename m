Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C5F7429BC
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjF2PeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 11:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjF2PeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 11:34:00 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E57A10EC
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 08:33:59 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-561eb6c66f6so6512167b3.0
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 08:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688052838; x=1690644838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3kyk0rokFAbkrgtc01xjyd4YqyaphcRK63ModOvOwcg=;
        b=5X+7dWLqWA+c5c/xZHCNYho35yEbDsgnfFTOb677nP9Eqd3EiyuJWdUXUIndMJZd6g
         1ACBc9Qax2zAZUORZHVKSFoMLEBZc5IErMyHXbmqQ7dlZbY9iGhOCkWWh2a0qTTWdEN4
         dCdbQ7mI8sYEds1L1nKER5UzFeOAsM2mm998PYc08qZZjva8xvFQ3Pq+wTgrEnYENB0x
         /+4atDdsU9iIIYUlOEc60GU0kWzVD8c6YdF1S7SE5IGScPMez0aBihHPX0BaEnpL0esK
         Qy+awD0S4Nh8jOeRtmVJDmTAGbj+GEP6+XfXgdd54Zb34y8abGXuvai3oxm5MAocPkFP
         vJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688052838; x=1690644838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3kyk0rokFAbkrgtc01xjyd4YqyaphcRK63ModOvOwcg=;
        b=P0KUsx78vroMSYKtLWZt792kHoGVJEPjXmGaNBbk6bRig/1Xp31eg4eECS75KaT6bh
         GptOzWlgNcW2WTycqv4wH3cCBcStRJ+/6jutJBATvP+CXlIqXTB9WBgTChRwAtnkPKDo
         +rUPsfhBHoGwOP0uo4CYb/zQ1kqYJ9txGmgX4+vy2bt/X5qTEhj+y0VCjHQd/Q6ospH2
         8sTR9Trb6Uidosg/NnD73rozbSWd4tJ2m6G84dvXDLnfdmx88qfFsecspPaQ+5gy2i+8
         gbXTOpntzfBM6bvKbl7NcjHUy5Fqm+SqrIMSsV1EHYxffAfuyEaxLq6wRgqNhYcTQ4Ke
         joGw==
X-Gm-Message-State: AC+VfDztxeGPbS7TU6FbL6H80XpxdYE+xllhhTGaOMo4M1GjipzeUWqm
        aXa71TH4/47ErKr/eXC7NYyn/9SXYO0=
X-Google-Smtp-Source: ACHHUZ5T23XUwgoQYNVKR3GhWx0nZKBunI4K2GoWz7QSBczf+rRDc1r13BPCUxWnXlsXJ96ewp+xOHgkx/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4046:0:b0:55d:d5b1:c2bd with SMTP id
 m6-20020a814046000000b0055dd5b1c2bdmr10931805ywn.8.1688052838293; Thu, 29 Jun
 2023 08:33:58 -0700 (PDT)
Date:   Thu, 29 Jun 2023 08:33:56 -0700
In-Reply-To: <5a9e57e3-0361-77f8-834f-edb8600483e1@linux.intel.com>
Mime-Version: 1.0
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-5-binbin.wu@linux.intel.com> <ZJt7vud/2FJtcGjV@google.com>
 <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com> <ZJ0rcVpSjbZInnIq@chao-email>
 <5a9e57e3-0361-77f8-834f-edb8600483e1@linux.intel.com>
Message-ID: <ZJ2kZL6mJB+bDQxi@google.com>
Subject: Re: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        kai.huang@intel.com, David.Laight@aculab.com,
        robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023, Binbin Wu wrote:
> On 6/29/2023 2:57 PM, Chao Gao wrote:
> > On Thu, Jun 29, 2023 at 02:12:27PM +0800, Binbin Wu wrote:
> > > > > +	/*
> > > > > +	 * Check LAM_U48 in cr3_ctrl_bits to avoid guest_cpuid_has().
> > > > > +	 * If not set, vCPU doesn't supports LAM.
> > > > > +	 */
> > > > > +	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
> > > > This is unnecessary, KVM should never allow the LAM bits in CR3 to be set if LAM
> > > > isn't supported.
> > A corner case is:
> > 
> > If EPT is enabled, CR3 writes are not trapped. then guests can set the
> > LAM bits in CR3 if hardware supports LAM regardless whether or not guest
> > enumerates LAM.

Argh, that's a really obnoxious virtualization hole.

> I recalled the main reason why I added the check.
> It's used to avoid the following checking on CR3 & CR4, which may cause an
> additional VMREAD.

FWIW, that will (and should) be handled by kvm_get_active_lam_bits().  Hmm, though
since CR4.LAM_SUP is a separate thing, that should probably be
kvm_get_active_cr3_lam_bits().

> Also, about the virtualization hole, if guest can enable LAM bits in CR3 in
> non-root mode without cause any problem, that means the hardware supports
> LAM, should KVM continue to untag the address following CR3 setting?

Hrm, no, KVM should honor the architecture.  The virtualization hole is bad enough
as it is, I don't want to KVM to actively make it worse.

> Because skip untag the address probably will cause guest failure, and of
> cause, this is the guest itself to blame.

Yeah, guest's fault.  The fact that it the guest won't get all the #GPs it should
is unfortunate, but intercepting all writes to CR3 just to close the hole is sadly
a really bad tradeoff.

> But untag the address seems do no harm?

In an of itself, not really.  But I don't want to set the precedent in KVM that
user LAM is supported regardless of guest CPUID.

Another problem with the virtualization hole is that the guest will be able
to induce VM-Fail when KVM is running on L1, because L0 will likely enforce the
CR3 checks on VM-Enter but not intercept MOV CR3.  I.e. the guest can get an
illegal value into vmcs.GUEST_CR3.  We could add code to explicitly detect that
case to help triage such failures, but I don't know that it's worth the code, e.g.

	if (exit_reason.failed_vmentry) {
		if (boot_cpu_has(X86_FEATURE_LAM) &&
		    !guest_can_use(X86_FEATURE_LAM) &&
		    (kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
		    	pr_warn_ratelimited("Guest abused LAM virtualization hole\n");
		else
			dump_vmcs(vcpu);
		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
		vcpu->run->fail_entry.hardware_entry_failure_reason
			= exit_reason.full;
		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
		return 0;
	}
