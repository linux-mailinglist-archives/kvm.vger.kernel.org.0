Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F13E718EC2
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjEaWs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjEaWs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:48:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0487311F;
        Wed, 31 May 2023 15:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91811634AD;
        Wed, 31 May 2023 22:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E324C433EF;
        Wed, 31 May 2023 22:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685573304;
        bh=7+T+ESDx7lTbGl9478hJKHlghZjeUr+1ylaQB5WdoCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A4HZtknVVOdPtECvEG05BMFKO+8SJ/FmPZBB2VNpW35jTADntXWLW9mYsjgOBALQb
         8vnXKDsH6Ddnwm3zNTX8ebXtauMHXuyo1IF6lXWA014CJ//cuZfkhIoNxJ343QokCP
         UYYmG12bc3YqwbFRnSR3n3UvYGOwL1fcFBToVX6/TZsuw+yN7wqxClx8RbnfB6P+Y4
         bqpcl5Pf/zcxrp7/gNbVgmCRQWt4u7kCjmXlvyQMg7NDjtzIia9w2K8Hxv4Oyrc1p9
         tr0Ly6ssdaDo5sKICPS3+p0et0TqtvPOcvGTp3DVmTLQL1GQmQYFkYwRElIVYqrm9G
         td03KiCTyg+bg==
Date:   Wed, 31 May 2023 15:48:22 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Waiman Long <longman@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Message-ID: <20230531224822.ceglenvl6w5wfiar@treble>
References: <20230531144128.73814-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230531144128.73814-1-jon@nutanix.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 10:41:28AM -0400, Jon Kohler wrote:
> Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
> eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IBRS)
> and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
> the MSR bitmap. Note: this logic is only for eIBRS, as Intel's guidance
> has long been that eIBRS only needs to be set once, so most guests with
> eIBRS awareness should behave nicely. We would not want to accidentally
> regress misbehaving guests on pre-eIBRS systems, who might be spamming
> IBRS MSR without the hypervisor being able to see it today.
> 
> eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
> once or twice per vCPU on boot, so it is far better to take those
> VM exits on boot than having to read and save this msr on every
> single VM exit forever. This outcome was suggested on Andrea's commit
> 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
> however, since interception is still unilaterally disabled, the rdmsr
> tax is still there even after that commit.
> 
> This is a significant win for eIBRS enabled systems as this rdmsr
> accounts for roughly ~50% of time for vmx_vcpu_run() as observed
> by perf top disassembly, and is in the critical path for all
> VM-Exits, including fastpath exits.
> 
> Opportunistically update comments for both MSR_IA32_SPEC_CTRL and
> MSR_IA32_PRED_CMD to make it clear how L1 vs L2 handling works.
> 
> Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
> Signed-off-by: Jon Kohler <jon@nutanix.com>

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh
