Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22F754B449
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356310AbiFNPNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347938AbiFNPNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:13:21 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A0CB36694;
        Tue, 14 Jun 2022 08:13:20 -0700 (PDT)
Received: from anrayabh-desk (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7A4F320C317B;
        Tue, 14 Jun 2022 08:13:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7A4F320C317B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655219599;
        bh=FkQMQGX0LVO9I/XM4yvyBKhBtSij68FznSIyshwEEEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J7txp6N9pbLDFHwrrSMl9uqBj9P36cwVuqE3pVCV57bdHryoRJ14mUHSaUMQInKkq
         7hmIjgSnPkrVNpk/S0yF7HhOodfrjuv7kFWHMbGwkp+KvZKh0+I27xwc2iKvBat8/C
         3Znfzfj/22YfjpXiOMHD8zT1jLCO/9bU472AJJoQ=
Date:   Tue, 14 Jun 2022 20:43:08 +0530
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
Message-ID: <YqilhAnxLMoQu1Ou@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqgU2KfFCqawbTkW@anrayabh-desk>
 <75bdc7ee-bac5-ae05-dffb-cb749c9005e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75bdc7ee-bac5-ae05-dffb-cb749c9005e1@redhat.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 02:16:00PM +0200, Paolo Bonzini wrote:
> On 6/14/22 06:55, Anirudh Rayabharam wrote:
> > > That said, I think a better implementation of this patch is to just add
> > > a version of evmcs_sanitize_exec_ctrls that takes a struct
> > > nested_vmx_msrs *, and call it at the end of nested_vmx_setup_ctl_msrs like
> > > 
> > > 	evmcs_sanitize_nested_vmx_vsrs(msrs);
> > Sanitize at the end might not work because I see some cases in
> > nested_vmx_setup_ctls_msrs() where we want to expose some things to L1
> > even though the hardware doesn't support it.
> > 
> 
> Yes, but these will never include eVMCS-unsupported features.

How are you so sure?

For example, SECONDARY_EXEC_SHADOW_VMCS is unsupported in eVMCS but in
nested_vmx_setup_ctls_msrs() we do:

6675         /*
6676          * We can emulate "VMCS shadowing," even if the hardware
6677          * doesn't support it.
6678          */
6679         msrs->secondary_ctls_high |=
6680                 SECONDARY_EXEC_SHADOW_VMCS;

If we sanitize this out it might cause some regression right?

Thanks!

	Anirudh.
> 
> Paolo
