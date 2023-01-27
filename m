Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B56467E5EA
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbjA0M7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjA0M7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:59:17 -0500
X-Greylist: delayed 8488 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 Jan 2023 04:59:08 PST
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 995F73A85;
        Fri, 27 Jan 2023 04:59:08 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 0974B262E0D;
        Fri, 27 Jan 2023 13:59:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1674824347;
        bh=uHv9ZPYlUCjrdF+RMjyMKqz8Vatp35kws0kAlQI8574=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jW8MtxhqF+/LwVwwJfgkojrRf5NSA2wj6YUkigZSiWTcI5CTSnRF+y70vmY8Hh0Gp
         qZd9h66eygUcS5vI70Az0aUkXpcMz8O/9QywyB75xTbICGgQhzf0m3et1Y6OCoEGJ+
         C4aT7MH0U7MizV8DxJtkBieXWqjgrGI5GNfgEKNhJQv9Hezs+A6GsfOd0ylMKfe85u
         No+U+4e5cRrG2Z73aIJqlJg5M+/r1dQOt5fP2o8HAiBjETK9e+J5ERQfnIOLKP270M
         8725fVyQ3V5iSwfXJCeI6e2CmqFm9XsLvJss3shCOSusNsxIDlTceKqiLWHu9GuWUJ
         kBKAeChW23hjw==
Date:   Fri, 27 Jan 2023 13:59:05 +0100
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
Message-ID: <Y9PKmZZPEaRDp0FC@8bytes.org>
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
> Here is the complete output of that VM (200k so not in the email):
> 
> https://github.com/aik/linux/commit/d0d6bbb58fcd927ddd1f8e9d42ab121920c7eafc

Thanks. So looking at the code in the traces:

Code starting with the faulting instruction
===========================================
   0:	65 48 8b 04 25 c0 db 	mov    %gs:0x2dbc0,%rax
   7:	02 00
   9:	48 8b 80 a8 08 00 00 	mov    0x8a8(%rax),%rax
  10:	0f 0d 48 70          	prefetchw 0x70(%rax)
  14:	e8                   	.byte 0xe8
  15:	82                   	.byte 0x82

I think the fault in the page-fault handler happens here:

DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
{
        unsigned long address = read_cr2();
        irqentry_state_t state;

        prefetchw(&current->mm->mmap_lock); <--- Here

To be precise, it faults while dereferencing current. That means that
GS_BASE is likely broken, need to find out why...

This at least explains why it page-faults in a loop until the stack
overflows and the guard page is hit.

Regards,

	Joerg

