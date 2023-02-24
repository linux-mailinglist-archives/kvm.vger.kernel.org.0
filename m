Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7DA6A21D4
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBXSxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 13:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBXSxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 13:53:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B608C11678;
        Fri, 24 Feb 2023 10:53:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F144B81D01;
        Fri, 24 Feb 2023 18:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8FDC433EF;
        Fri, 24 Feb 2023 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677264779;
        bh=A7n0ZKEV3cT4ofTZftMjL2isGjA2th4kIutljiN1v3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VAQmaoo+pliGlOcJZDWF7wr0OHnK8MBoL7p6yl9g0lcyTSXoLnww4OQpGkl/N6aCx
         YMR28JD4cYki84qFyRu2lgMs9TwP284t+xbrvosCtKvSx4ngPewRlPPqFWfAKzQRxb
         3Ox1TMPjoJ0r5xIcTCZqSN1tgrS3RkXW7BG1GXIn/ayPx31gNMzPIePr/VGOMKPyfx
         z+FJzeLSWtqvvhyYOCzVnM36ODD/98+wA8wfRifBx/nySiYW73Ko889COJTRc57/As
         dgeFa3PCi0hnqcl47WRpH/BdjXSgFc3adh9WlMeqYxTsb5e/2h+vY4qSgmS8Q5zRwz
         Uprw6OvKEtiQA==
Date:   Fri, 24 Feb 2023 10:52:57 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
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
Subject: Re: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Message-ID: <20230224185257.o3mcmloei5zqu7wa@treble>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230124163319.2277355-8-kim.phillips@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 10:33:18AM -0600, Kim Phillips wrote:
> @@ -1495,8 +1495,12 @@ static void __init spectre_v2_select_mitigation(void)
>  		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
>  
>  	if (spectre_v2_in_ibrs_mode(mode)) {
> -		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
> -		update_spec_ctrl(x86_spec_ctrl_base);
> +		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
> +			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);

Doesn't this only enable it on the boot CPU?

-- 
Josh
