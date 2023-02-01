Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA56685D4B
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 03:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjBACU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 21:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjBACU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 21:20:26 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D010F4212
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:20:24 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so2342453pjq.1
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1MMwx9ODtw2il+L0S/Yx7Xt3qG0rGIJ1WWhiqIjHGQs=;
        b=DNvC96wzyC/Z43UGfNP1xHRIq38cJ1lEBlAXqjtPxL+N8of47Au7OUr/WazqFlfqNX
         CYvz8+XQnUJs1AfiQZHCd9DHUhVekZW4IZfLYf+vgk+ps1S56WUInZfQryxbRRT0DA9Z
         PTI7K97ASmWTbEvVU88rwUN4P2O8aqT27Wg3/0TKi0+8GRHp/MQ1NZa9S9o0NQloKlit
         jFu0Sx2Q5jU7+rnkvZ+4jkgzi1In+gwzWkneDzd3ol3SkAxba7BIu6nHKhBFe0VvxxRx
         VphTGgOafY4Qg10T+Dx50CLg+fyl4AZ8l7ppCTMLod+pUImfMn2iufsSZoSns5X1x6bY
         Ol0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1MMwx9ODtw2il+L0S/Yx7Xt3qG0rGIJ1WWhiqIjHGQs=;
        b=Pet+WWsNmQKgbycIW9kL4Y/0YW/yAlV+dsgPawkbgVOoBv8W1BEKppxloYX1XolFO4
         4DFddt/gPL6bPPkhciQn8VvsrWaZXh04uQae5KR+Uk+I9lhXsrJd4afQX/ovnG0jAvF6
         Rg3EHKS8ZCApBAS9y/BUhEEywfuAXu9R2Fr3FkHTDxscqo53SA+yEtR8wtEOmkItV1a6
         xgfPlZYrX7ogdWfFCjyKGYSSdg9MRGYm8sorRlh5VKScFZ6Jvsp53GCDIeXuEQswCKmC
         x1MVk+1pOLh3UXsOmFRKDPfcslRPS44Zl7LZlzXE6A9+Imx5Obx4+8c7VlT/Su6bqv92
         NEZA==
X-Gm-Message-State: AO0yUKUAzFt+yfy54h+avrfEpN/cBtxRidVk51khH+CTsBrN6VDB9rtJ
        XxOZAQDlWnZn2y3Rzsfjz/qj1Q==
X-Google-Smtp-Source: AK7set88QhzZb35gToP7v0qzuGf0SvHK0+IDWM+2Xhk1CWrk9VgpNTkMG7HXWUt4bQBjYW9q+LNAbA==
X-Received: by 2002:a17:902:d091:b0:198:af4f:de09 with SMTP id v17-20020a170902d09100b00198af4fde09mr19584plv.9.1675218023779;
        Tue, 31 Jan 2023 18:20:23 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902f7cb00b001926392adf9sm10439243plw.271.2023.01.31.18.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 18:20:23 -0800 (PST)
Date:   Wed, 1 Feb 2023 02:20:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
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
Message-ID: <Y9nMZNrV+Iz8Ce5l@google.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-3-aik@amd.com>
 <Y9lqiXu4yUgP6APS@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9lqiXu4yUgP6APS@zn.tnic>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023, Borislav Petkov wrote:
> Hey Sean,
> 
> On Fri, Jan 20, 2023 at 02:10:46PM +1100, Alexey Kardashevskiy wrote:
> > Prior to SEV-ES, KVM stored/loaded host debug registers upon switching
> > to/from a VM. Changing those registers inside a running SEV VM
> > triggered #VC exit to KVM.
> > 
> > SEV-ES added the encrypted state (ES) which uses an encrypted guest page
> > for the VM state (VMSA). The hardware saves/restores certain registers on
> > VMRUN/VMEXIT according to a swap type (A, B, C), see
> > "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
> > volume 2.
> > 
> > AMD Milan (Fam 19h) introduces support for the debug registers swapping.
> > DR6 and DR7 are always swapped. DR[0-3] and DR[0-3]_ADDR_MASK are swapped
> > a type B when SEV_FEATURES[5] ("DebugSwap") is set.
> > 
> > Enable DebugSwap in VMSA. But only do so if CPUID Fn80000021_EAX[0]
> > ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
> > supported by the SOC as otherwise a malicious SEV-ES guest can set up
> > data breakpoints on the #VC IDT entry/stack and cause an infinite loop.
> > 
> > Eliminate DR7 and #DB intercepts as:
> > - they are not needed when DebugSwap is supported;
> > - #VC for these intercepts is most likely not supported anyway and
> > kills the VM.
> > Keep DR7 intercepted unless DebugSwap enabled to prevent the infinite #DB
> > loop DoS.
> 
> ...
> 
> ok to take this through the tip tree?

I would prefer to take this through KVM, there's enough subtle complexity in this
code that it'd be nice to have it close by.

If you're happy with patch 1, maybe ack that one and take it through KVM, and
route patch 3 through tip?
