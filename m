Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE26554BCF
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 15:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357590AbiFVNwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 09:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355448AbiFVNwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 09:52:39 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 258BE31399;
        Wed, 22 Jun 2022 06:52:39 -0700 (PDT)
Received: from anrayabh-desk (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id C93A520C636D;
        Wed, 22 Jun 2022 06:52:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C93A520C636D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655905958;
        bh=R+k2UqPHYooOFQata2pqrjRqfej0d1iORozna9weBHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A/fNNmtqq21x7GLW2Gn8Q/rUSPbR1oMyWuHOZmOQAHqJfxY4f9rKgdUSQLAXgljsq
         T+uWtW2WTkNFcO8duxNUE83SDeV9SvzmQYkuOQOrpEmyVAyjNf1s5lQa3KEyS+CdpZ
         wl+NakEOe8id2wkrs5Jm0FmMRYOuDghpVWPN67aw=
Date:   Wed, 22 Jun 2022 19:22:28 +0530
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Message-ID: <YrMenI1mTbqA9MaR@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqdsjW4/zsYaJahf@google.com>
 <YqipLpHI24NdhgJO@anrayabh-desk>
 <YqiwoOP4HX2LniI4@google.com>
 <87zgi5xh42.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgi5xh42.fsf@redhat.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 10:00:29AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Jun 14, 2022, Anirudh Rayabharam wrote:
> >> On Mon, Jun 13, 2022 at 04:57:49PM +0000, Sean Christopherson wrote:
> 
> ...
> 
> >> > 
> >> > Any reason not to use the already sanitized vmcs_config?  I can't think of any
> >> > reason why the nested path should blindly use the raw MSR values from hardware.
> >> 
> >> vmcs_config has the sanitized exec controls. But how do we construct MSR
> >> values using them?
> >
> > I was thinking we could use the sanitized controls for the allowed-1 bits, and then
> > take the required-1 bits from the CPU.  And then if we wanted to avoid the redundant
> > RDMSRs in a follow-up patch we could add required-1 fields to vmcs_config.
> >
> > Hastily constructed and compile-tested only, proceed with caution :-)
> 
> Independently from "[PATCH 00/11] KVM: VMX: Support TscScaling and
> EnclsExitingBitmap whith eVMCS" which is supposed to fix the particular
> TSC scaling issue, I like the idea to make nested_vmx_setup_ctls_msrs()
> use both allowed-1 and required-1 bits from vmcs_config. I'll pick up
> the suggested patch and try to construct something for required-1 bits.

I tried this patch today but it causes some regression which causes
/dev/kvm to be unavailable in L1. I didn't get a chance to look into it
closely but I am guessing it has something to do with the fact that
vmcs_config reflects the config that L0 chose to use rather than what is
available to use. So constructing allowed-1 MSR bits based on what bits
are set in exec controls maybe isn't correct.


Thanks!

	- Anirudh.
