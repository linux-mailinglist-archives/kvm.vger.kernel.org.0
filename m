Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE016A2415
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBXWMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBXWMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:12:35 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAAD6C1B6;
        Fri, 24 Feb 2023 14:12:34 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D2E061EC0725;
        Fri, 24 Feb 2023 23:12:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677276752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xeYi9hbAisvVgwsIQVhAVyxgasq3BFCJGVZ+4Kn/ojs=;
        b=Jvh4pMI87qGd5TiSfg1fClxmOEgKebumIXZRPDPr7bStf9gF2wrxrLmdw+B/dsbN4pznmW
        KEj5VYecXK9K8A31+EP4s2kUccX21kKYSOYwDRAlvkddXHCM5rbONr7jfQXDQEk4gdpVie
        jareyQFmNamh1InO2NqBWkDJxTnT+0M=
Date:   Fri, 24 Feb 2023 23:12:29 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Message-ID: <Y/k2TWHpq1M8QiSa@zn.tnic>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <20230224213522.nofavod2jzhn22wp@treble>
 <Y/kzGEqafzQkbU4T@zn.tnic>
 <SJ1PR11MB60834960ECAC976C1D328A86FCA89@SJ1PR11MB6083.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB60834960ECAC976C1D328A86FCA89@SJ1PR11MB6083.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 10:03:16PM +0000, Luck, Tony wrote:
> Should also include Pawan as another unfortunate soul sucked
> into keeping that file up to date with the latest wreckage. If not
> as "M", at least as "R":
> 
> R: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

We probably should hear from him before you offer his soul into the
purgatory of hardware speculation.

:-P

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
