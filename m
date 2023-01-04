Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6AF65E09D
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 00:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjADWzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 17:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjADWzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 17:55:23 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CBD4437D;
        Wed,  4 Jan 2023 14:55:18 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B3ED81EC02FE;
        Wed,  4 Jan 2023 23:55:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672872916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RzLTjPoAXSnlIC2nWds3sucVQ3Z2l5YDMALMam//efE=;
        b=Q2d5Ul7scaMaeHpc45SVYFYyJwIgiOxbScUB8qq+IhUthAi4Xee56GnX9R1WNsmYMyrmy6
        cytP5K5plMDExgePmQAT16rSrdEcXQva8hXASFL1RI5OyBgcixM2RUZxPN4ooTqshx8X9j
        tOWjVavQwfyauLpH7C5n1fVXiWocOp4=
Date:   Wed, 4 Jan 2023 23:55:11 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/cpu: Process all CPUID dependencies after
 identifying CPU info
Message-ID: <Y7YDz/8lsVigmeXF@zn.tnic>
References: <20221203003745.1475584-1-seanjc@google.com>
 <20221203003745.1475584-2-seanjc@google.com>
 <Y5INU3o+SFReGkLz@zn.tnic>
 <Y5IQNY/fZw2JFA0B@google.com>
 <Y5IUsB83PzHCJ+EY@zn.tnic>
 <Y7XpTAFV6BLT8KgB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y7XpTAFV6BLT8KgB@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 09:02:04PM +0000, Sean Christopherson wrote:
> And there's a non-zero chance we'd end up with a kernel param to allow booting
> unknown CPUs, e.g. for people doing weird things with VMs or running old, esoteric
> hardware.  At that point we'd end up with a more complex implementation than
> processing dependencies on synthetic flags, especially if there's ever a more
> legitimate need to process such dependencies.

I'm sorry but I'm still unclear on what actual use care are we even fixing here?

If it is about people who'd like to tinker with old hw or doing weird VM things,
they can just as well adjust their kernel .configs and rebuild.

Peeking around your patchset, if all this is about dropping the
X86_FEATURE_MSR_IA32_FEAT_CTL check and checking only X86_FEATURE_VMX and in
order to do that, you want to cover those obscure cases where
init_ia32_feat_ctl() won't get run, then sure, I guess - changes look simple
enough. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
