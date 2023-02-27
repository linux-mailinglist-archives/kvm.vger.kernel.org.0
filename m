Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466BB6A463A
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 16:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjB0Pkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 10:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjB0Pkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 10:40:35 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23A118B02;
        Mon, 27 Feb 2023 07:40:34 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8BD0D1EC0513;
        Mon, 27 Feb 2023 16:40:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677512432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UdrfF8W9f5LmbfgjeMlZzOpnxPRWTTrJk+wzvyZ0r2o=;
        b=Ca34fwdL4MmIkFlZsp6hRnt9UrI5me63irUBCouAEeomNEo5YUCXpvSLahB68Vk2Oc8rWY
        hI8qE7uMSSuOVQ2qF00RMv2g0agghp50OWemXGXZR/EEHUaHsj/xljiYHvzdiWeJUEaGur
        oeiMwjGtnL54xnU3BKie1gXb2e4Tsos=
Date:   Mon, 27 Feb 2023 16:40:28 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
Message-ID: <Y/zO7MtvjiVLCiLg@zn.tnic>
References: <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
 <Y/n9XcbnCzWv2Vul@zn.tnic>
 <445daef5-8417-ddbb-abbf-3c5ab38e1c9c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <445daef5-8417-ddbb-abbf-3c5ab38e1c9c@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 07:25:00AM -0800, Dave Hansen wrote:
> It will freak some users out, but it does seem like the kind of thing we
> _want_ a bug report for.

You mean, something like:

	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled) &&
	    cpu_has(c, X86_FEATURE_AUTOIBRS))
		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS));

?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
