Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDE165E8B2
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 11:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjAEKPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 05:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjAEKPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 05:15:39 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B4132E8E;
        Thu,  5 Jan 2023 02:15:35 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 08C171EC04F0;
        Thu,  5 Jan 2023 11:15:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672913734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hsFbjnWU7gSgmZikUMj3Qj307XI8pq932qOb3VP/kuE=;
        b=Msnef0lMvfpYPJHB0eh+gDn+93V7BugbrN4tBCXxZplXlOOmtimPhRFSkoVHj0Fz7RGhOA
        SBCUin9LWs64klKGk6hrL8yz1q6A2GSh7JYgfFEpSiL20wEnBw/Ks1SlMmn5a+PAbh/L4a
        V/unMosR5lhxs0HH+wVAO5nxxqEcTXU=
Date:   Thu, 5 Jan 2023 11:15:29 +0100
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
Message-ID: <Y7ajQY8w+qpOSI4p@zn.tnic>
References: <20221203003745.1475584-1-seanjc@google.com>
 <20221203003745.1475584-2-seanjc@google.com>
 <Y5INU3o+SFReGkLz@zn.tnic>
 <Y5IQNY/fZw2JFA0B@google.com>
 <Y5IUsB83PzHCJ+EY@zn.tnic>
 <Y7XpTAFV6BLT8KgB@google.com>
 <Y7YDz/8lsVigmeXF@zn.tnic>
 <Y7YJRwlWVqt3uY9/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y7YJRwlWVqt3uY9/@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 11:18:31PM +0000, Sean Christopherson wrote:
> Yes, this is purely to drop the explicit X86_FEATURE_MSR_IA32_FEAT_CTL checks.

Yeah, we can do that as it is simple enough.

Btw, we already resolve deps - or forced features but whatever, it is similar -
in apply_forced_caps(). And we call it right before we "sync" the feature bit
arrays with boot_cpu_data's in identify_cpu().

So I'm thinking this all, including your change, should be carved out in a
separate function and all the CPU flags massaging should be concentrated there.

And that should happen last in identify_cpu() - that ppin_init() thing sets and
clears cpu caps too. ;-\

But I can do that ontop, so how do you wanna merge this?

I take it or I review it and you take it or... ?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
