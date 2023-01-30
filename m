Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88277681831
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbjA3SE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 13:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237237AbjA3SE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 13:04:57 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAE538034;
        Mon, 30 Jan 2023 10:04:56 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 02B8B1EC0644;
        Mon, 30 Jan 2023 19:04:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1675101895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=BJH1lxsIjaQizQcg4IdFb2pbApmuFex/Qvs3UEW5dsE=;
        b=CFIt/M8/DzmOPsX/YttqNpbo8MNQK7zO67XIyxWXhewthChNnJH6Ee7lua4dLOp1AkLY0a
        VYpVLgKWsrj5l8Xekc7JEqJw5DQ9dMnyEVPV/WctfONawPjEgFg3sfoVvsepMfVV9uGln0
        49AhRvEsAO13mq6gTfJMH+VRJPtBE/c=
Date:   Mon, 30 Jan 2023 19:04:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Alexey Kardashevskiy <aik@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9gGwtS2tm5BKvmv@zn.tnic>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org>
 <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
 <Y9QI9JwCVvRmtbr+@8bytes.org>
 <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
 <38C572D7-E637-48C2-A57A-E62D44FF19BB@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <38C572D7-E637-48C2-A57A-E62D44FF19BB@zytor.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 09:30:38AM -0800, H. Peter Anvin wrote:
> It's somewhat odd to me that reading %dr7 is volatile, but %dr6 is
> not... %dr6 is the status register!

Yeah, as a precaution I think we should make all those volatile. Just in
case.
 
> I believe they should all be volatile (the compiler semantics is that
> volatile operations are always executed exactly once, in strict
> program order with respect to any other volatile operations); the real
> question is if there should also be memory clobbers on %dr6 reads and
> any %dr write.

Yes, I think so too. From gcc docs:


"6.47.2.1 Volatile
.................

...

Note that the compiler can move even 'volatile asm' instructions
relative to other code, including across jump instructions."

We already have __FORCE_ORDER for exactly things like that.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
