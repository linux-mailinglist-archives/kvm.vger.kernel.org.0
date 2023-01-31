Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134FC683669
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 20:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjAaTXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 14:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjAaTXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 14:23:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E88915C87;
        Tue, 31 Jan 2023 11:22:55 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 11C6B1EC0662;
        Tue, 31 Jan 2023 20:22:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1675192974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMIhTkSoD/aOTCFfdIQOUQyCfk9POXyRE/QomVJgFEI=;
        b=AW+Et34sN/zpVuONqz49/rlWU6aFwOPWj+a1i5gzxWJZBIMG9Ltk6tB0KWn60Ab8wpBcs4
        qiCb9VLgEwVaF4hK0dWPij0+SCNBTTTrMPR8w1YX0uYUcBD2iwWUoXfu5Y8372daX1NB6X
        U06q5MfLK0dmQFW0rHSSW6LtqTgXrhQ=
Date:   Tue, 31 Jan 2023 20:22:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel v3 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Message-ID: <Y9lqiXu4yUgP6APS@zn.tnic>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-3-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230120031047.628097-3-aik@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Sean,

On Fri, Jan 20, 2023 at 02:10:46PM +1100, Alexey Kardashevskiy wrote:
> Prior to SEV-ES, KVM stored/loaded host debug registers upon switching
> to/from a VM. Changing those registers inside a running SEV VM
> triggered #VC exit to KVM.
> 
> SEV-ES added the encrypted state (ES) which uses an encrypted guest page
> for the VM state (VMSA). The hardware saves/restores certain registers on
> VMRUN/VMEXIT according to a swap type (A, B, C), see
> "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
> volume 2.
> 
> AMD Milan (Fam 19h) introduces support for the debug registers swapping.
> DR6 and DR7 are always swapped. DR[0-3] and DR[0-3]_ADDR_MASK are swapped
> a type B when SEV_FEATURES[5] ("DebugSwap") is set.
> 
> Enable DebugSwap in VMSA. But only do so if CPUID Fn80000021_EAX[0]
> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
> supported by the SOC as otherwise a malicious SEV-ES guest can set up
> data breakpoints on the #VC IDT entry/stack and cause an infinite loop.
> 
> Eliminate DR7 and #DB intercepts as:
> - they are not needed when DebugSwap is supported;
> - #VC for these intercepts is most likely not supported anyway and
> kills the VM.
> Keep DR7 intercepted unless DebugSwap enabled to prevent the infinite #DB
> loop DoS.

...

ok to take this through the tip tree?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
