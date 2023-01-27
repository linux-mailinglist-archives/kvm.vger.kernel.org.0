Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4832967EC5E
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 18:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbjA0RZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 12:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbjA0RZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 12:25:18 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 464637B423;
        Fri, 27 Jan 2023 09:25:11 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 72C3626302C;
        Fri, 27 Jan 2023 18:25:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1674840309;
        bh=m4psZ1O0An3xTl3QooT7Oe58TqGhBHCLxfn9vXOdlU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zrE2ynIYizjvRY8GpViEkVQam9rf4AdVqeMQjZlOmuakma/M8tuotEHTMcEci3wCK
         BylnB1ApstdAnimK5NW/O9Sr0SSdiaW1hT/CSUaZSWaq5RXixOpXlZ55co8JR5vb5l
         +DDW4X+bcwblMYtXa7mJ2jNiZmG/ULbJ1AwfJxjnss3IINTTfet8hnsYgCKpNhXzMs
         P5HDtynjqYC6jmcLUJt7XzJHjJpuZWEEz0jAgjvRUcpI/QLQ519AS4fYkArCoSLOAx
         69Vuz0STiSCcxM9+TudUNOhEc1eoNlOtcO/N+kL/FeOV0w9ws/XwwS+9IHfyPUij1B
         CQH0AGrE9Oh3A==
Date:   Fri, 27 Jan 2023 18:25:08 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9QI9JwCVvRmtbr+@8bytes.org>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org>
 <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 10:56:26PM +1100, Alexey Kardashevskiy wrote:
> https://github.com/aik/linux/commit/d0d6bbb58fcd927ddd1f8e9d42ab121920c7eafc

Okay, I reproduced the problem here and the root cause turned out to be
that the compiler moved the DR7 read instruction before the 5-byte NOP
which becomes the call to sev_es_ist_enter() in SEV-ES guests. This is
guaranteed to cause #VC exception stack recursion if the NMI was
triggered on the #VC stack, and that leads to all kinds of undefined
behavior.

Regards,

	Joerg
