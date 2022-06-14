Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C3B54B4A4
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbiFNP3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356985AbiFNP25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:28:57 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D7001B7AD;
        Tue, 14 Jun 2022 08:28:57 -0700 (PDT)
Received: from anrayabh-desk (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id 73C7020C317B;
        Tue, 14 Jun 2022 08:28:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 73C7020C317B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655220536;
        bh=RS7cjzRsU35AKyG6Qmud17MN3MhX4pjeepmvXkcXxug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eaUX9oDzRz4AXlIoUX2No+UlMdfgH0fK/uyX9G2IvH35fheFVBF0ZppdYKHwvvLAh
         UgRUdQENcVjBzvunILFaoDl1jE1dZTl1ci+bbrdHR6lBteZ1U8tzLd5n3lG/bI3KuZ
         m/W/u8ssheXRLO2pM2l6u1tUe84duzEkOelUC7AU=
Date:   Tue, 14 Jun 2022 20:58:46 +0530
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Message-ID: <YqipLpHI24NdhgJO@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqdsjW4/zsYaJahf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqdsjW4/zsYaJahf@google.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022 at 04:57:49PM +0000, Sean Christopherson wrote:
> On Mon, Jun 13, 2022, Paolo Bonzini wrote:
> > On 6/13/22 18:16, Anirudh Rayabharam wrote:
> > > +	if (!kvm_has_tsc_control)
> > > +		msrs->secondary_ctls_high &= ~SECONDARY_EXEC_TSC_SCALING;
> > > +
> > >   	msrs->secondary_ctls_low = 0;
> > >   	msrs->secondary_ctls_high &=
> > >   		SECONDARY_EXEC_DESC |
> > > @@ -6667,8 +6670,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
> > >   		SECONDARY_EXEC_RDRAND_EXITING |
> > >   		SECONDARY_EXEC_ENABLE_INVPCID |
> > >   		SECONDARY_EXEC_RDSEED_EXITING |
> > > -		SECONDARY_EXEC_XSAVES |
> > > -		SECONDARY_EXEC_TSC_SCALING;
> > > +		SECONDARY_EXEC_XSAVES;
> > >   	/*
> > 
> > This is wrong because it _always_ disables SECONDARY_EXEC_TSC_SCALING,
> > even if kvm_has_tsc_control == true.
> > 
> > That said, I think a better implementation of this patch is to just add
> > a version of evmcs_sanitize_exec_ctrls that takes a struct
> > nested_vmx_msrs *, and call it at the end of nested_vmx_setup_ctl_msrs like
> > 
> > 	evmcs_sanitize_nested_vmx_vsrs(msrs);
> 
> Any reason not to use the already sanitized vmcs_config?  I can't think of any
> reason why the nested path should blindly use the raw MSR values from hardware.

vmcs_config has the sanitized exec controls. But how do we construct MSR
values using them?

Thanks,

	Anirudh.
