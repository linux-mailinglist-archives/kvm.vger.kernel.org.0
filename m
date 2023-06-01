Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88237191CF
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 06:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjFAEYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 00:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjFAEXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 00:23:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F701A7;
        Wed, 31 May 2023 21:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B42D60FB2;
        Thu,  1 Jun 2023 04:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69790C433D2;
        Thu,  1 Jun 2023 04:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685593428;
        bh=Vmpu+tmCB/j9OAOBTooih5ZpKTBAnxG8w5d/DuPgqXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UCFdHtTH5VEzC1+pmZ3T87kKogT0MTYfFt7PRafT1FvG7D63uzz84O4mAi6U9G494
         fY21pcXWnOUWPP6qxc5XGrxUQZDPG9M46HYaIUHYssG11DGwyU+QViWVcnVYeLj9Yl
         MTvlqI/F1DgANamPu783SDAjFtdIJpL6+OT6rvHWRWgGCq0Vb0TkLgkBCXoW0GzTp2
         X7lF18ta1lA16F84YbnT/lxEBLAFN9Hln/rcakNqWjM5eFEgldSEs2HRvS7W4dMQgM
         WnMZfSLsI3giBUkPpSXcQofLILYK3IL1y46cLcWOvvxNoun45SPtG/bNe0k5wTKe57
         qK3BV21uK31OQ==
Date:   Wed, 31 May 2023 21:23:45 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230601042345.52s5337uz62p6aow@treble>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230601012323.36te7hfv366danpf@desk>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 06:24:29PM -0700, Pawan Gupta wrote:

## 2023-05-31
> On Thu, Jun 01, 2023 at 01:50:48AM +0100, Andrew Cooper wrote:
> > On 01/06/2023 1:42 am, Josh Poimboeuf wrote:
> > > So each LFENCE has a distinct purpose.  That said, there are no indirect
> > > branches or unbalanced RETs between them.
> > 
> > How lucky are you feeling?
> > 
> > You're in C at this point, which means the compiler could have emitted a
> > call to mem{cpy,cmp}() in place of a simple assignment/comparison.
> 
> Moving the second LFENCE to the else part of WRMSR should be possible?
> So that the serialization can be achived either by WRMSR or LFENCE. This
> saves an LFENCE when host and guest value of MSR_SPEC_CTRL differ.

Yes.  Though in practice it might not make much of a difference.  With
wrmsr+lfence, the lfence has nothing to do so it might be almost
instantaneous anyway.

-- 
Josh
