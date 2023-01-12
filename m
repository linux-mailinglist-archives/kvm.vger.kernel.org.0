Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91085667111
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 12:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbjALLiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 06:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjALLgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 06:36:38 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7649D12AE3;
        Thu, 12 Jan 2023 03:28:52 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 125C11EC05F1;
        Thu, 12 Jan 2023 12:28:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673522931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hGCInzxwdz3lL/OXhdLEr9SwPYx1B9No4yYNsqHgk4o=;
        b=imyTnnHVUxepRjSqAJ/+Wyb1aCPf0S3BJ0fBg1IW7QJ7ILZCBnIDXjpNyqRFXkc1pQ/Q4Q
        0J2K0of8Qptdoi+iMDY+FUTvxG8vkhNXiDVUmIUDP+H7sogwWqpK1ll+cx3kOzgHRtB6iA
        JJl4m2Ij2VFujQMJQ4ddyu25WcOpVbU=
Date:   Thu, 12 Jan 2023 12:28:47 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel v2 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Message-ID: <Y7/u76mREet2IrtQ@zn.tnic>
References: <20221209043804.942352-1-aik@amd.com>
 <20221209043804.942352-3-aik@amd.com>
 <Y72nyuKT+VJYiEUi@zn.tnic>
 <f18c83ac-dc9a-6173-7ab3-d5e3718a0047@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f18c83ac-dc9a-6173-7ab3-d5e3718a0047@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 04:45:34PM +1100, Alexey Kardashevskiy wrote:
> Well, SEV-ES KVM (ES == Encrypted State) does not save/restore them for the
> guest (well, as I would expect) as the guest registers are not visible to
> host to save, they are intercepted and the VM does this GHCB dance with
> VMGEXIT(SVM_EXIT_WRITE_DR7).

But they're saved in the VMSA, as Table B-3 says.

> Well, the only place in APM is that "Table B-3. Swap Types and the AMD APM
> volume 2", and it is pretty brief, do I miss something?

I don't understand that question - please elaborate.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
