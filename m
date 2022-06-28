Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA14E55C7EA
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344801AbiF1KaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244644AbiF1KaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:30:20 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5577B2E6BE;
        Tue, 28 Jun 2022 03:30:19 -0700 (PDT)
Received: from anrayabh-desk (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id EB4C120CD15E;
        Tue, 28 Jun 2022 03:30:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EB4C120CD15E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656412218;
        bh=JQm/F3y5KpRHHQKfnCN47o1gbSsO/+OUxUcmzwEpM+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U5cscUJSP6D+FZWBOAujwe5QW9HXONS5YfZQv+keY574JNdWOdz9WTKXOc2IroxHi
         1pA4kqI+mV0Wm8JO9OCPD+LfnoA3Oe/QQ0Lyzs7jw1vYbTC++NTzuq/DgFSA+SXiXv
         HuYytuoFMQtCdcZaAYs43D8be1sZJv0PLEyAQeE8=
Date:   Tue, 28 Jun 2022 16:00:08 +0530
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
Message-ID: <YrrYMHbiO0UuLZYN@anrayabh-desk>
References: <YqdsjW4/zsYaJahf@google.com>
 <YqipLpHI24NdhgJO@anrayabh-desk>
 <YqiwoOP4HX2LniI4@google.com>
 <87zgi5xh42.fsf@redhat.com>
 <YrMenI1mTbqA9MaR@anrayabh-desk>
 <87r13gyde8.fsf@redhat.com>
 <YrNBHFLzAgcsw19O@anrayabh-desk>
 <87k098y77x.fsf@redhat.com>
 <YrQ9rt61a8tPWWGO@anrayabh-desk>
 <87bkujy4z9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkujy4z9.fsf@redhat.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 01:49:30PM +0200, Vitaly Kuznetsov wrote:
> Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:
> 
> > On Wed, Jun 22, 2022 at 06:48:50PM +0200, Vitaly Kuznetsov wrote:
> >> Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:
> >> 
> >> > On Wed, Jun 22, 2022 at 04:35:27PM +0200, Vitaly Kuznetsov wrote:
> >> 
> >> ...
> >> 
> >> >> 
> >> >> I've tried to pick it up but it's actually much harder than I think. The
> >> >> patch has some minor issues ('&vmcs_config.nested' needs to be switched
> >> >> to '&vmcs_conf->nested' in nested_vmx_setup_ctls_msrs()), but the main
> >> >> problem is that the set of controls nested_vmx_setup_ctls_msrs() needs
> >> >> is NOT a subset of vmcs_config (setup_vmcs_config()). I was able to
> >> >> identify at least:
> >> 
> >> ...
> >> 
> >> I've jsut sent "[PATCH RFC v1 00/10] KVM: nVMX: Use vmcs_config for
> >> setting up nested VMX MSRs" which implements Sean's suggestion. Hope
> >> this is the way to go for mainline.
> >> 
> >> >
> >> > How about we do something simple like the patch below to start with?
> >> > This will easily apply to stable and we can continue improving upon
> >> > it with follow up patches on mainline.
> >> >
> >> 
> >> Personally, I'm not against this for @stable. Alternatively, in case the
> >
> > I think it's a good intermediate fix for mainline too. It is easier to land
> > it in stable if it already exists in mainline. It can stay in mainline
> > until your series lands and replaces it with the vmcs_config approach.
> >
> > What do you think?
> >
> 
> Paolo's call but personally I think both series can make 5.20 so there's
> no need for an intermediate solution.

Only reason I see for this intermediate solution is to automatically
land the fix in stable without bothering to write a special backport.

I will send it as a proper patch and see if there is any interest in
taking it.

	- Anirudh.
