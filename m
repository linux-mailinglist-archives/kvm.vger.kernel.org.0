Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C948E686EFD
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 20:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjBATcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 14:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjBATce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 14:32:34 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C297BBCA
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 11:32:33 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 5so19521044plo.3
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 11:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OSNJYInipZ/N9ZUlMjv2BtkVzR+GxKWJaOF0xjf8sH0=;
        b=n0XHt3yTCHKeaO4XN7poQwSbwm5p0ibDhgBbGgHE1Z51vm2IxOnnotcKpSRhjOBgna
         SBfZdqOrcJ5CosUP+/2g2+I7mKqa5H86hJuB/LqJqvjrfOMseqnP0NqmgSOst/eGp+Qk
         SQYmiahkedKUkTF5sUiQtJIT67vRO9EQYHG8yUTnqK3+bBTfFKa5UtL/OZwHJfz/CHSi
         lK987MpGyEILVvDOc9yQS8r/KkEmcB5uiIMeq0z6Jee9p5FZGX/p9XVixJMp8IACGHmg
         w3cmn7niWpgWWUNh37jjBMp3pATN98WRIEvHr0A6jTjzRKsuyND8SE/8aJvwTt2J9F7l
         K7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OSNJYInipZ/N9ZUlMjv2BtkVzR+GxKWJaOF0xjf8sH0=;
        b=fiMx4pZ+0nLK7onwSLREVfzDCGFem/h4oy2DzCM/gX5MfCOd0SpcbYd47QHET01GKH
         0Uiaz8a5RAaiOXOi1dVUgg6g+ysRu+4yHSDvdMLYgxa/PWSwq3MT7gd51buIo0ObNhrb
         eC32VBW5vn1cyl+beY5X0TcI02CXO8RlFGwaLHXrek/JyUS7I1AHwrgFGoZ6B54GdQIm
         hF2hll9Mjyn1ZnGSAObnhrNxWvwmlsp8UEBpjf+SmXZ3tR+oWP9q33h1hnPEXYr26OwQ
         gP51mKCP4+bVXdF+qajMjWyN6cR31fFdTb3yGkNkzgwqPFCp5EbErFFLtqsOJ/2cTTcT
         MGIg==
X-Gm-Message-State: AO0yUKWT96kPOShsVM5zpxi4+EQf+PC1yFwoXlxj1AcwRMogWzTwy7Ye
        dQhPzO5gVAoh1mgFcAO3qspCYSiGaYEe7dgLQAA=
X-Google-Smtp-Source: AK7set/zucsS9D2hpiVndzXHJgUmEJcgKvG+FCH2SmbUMSy5FQQHyBGezNmvucp1jzbItlqYuTkWjA==
X-Received: by 2002:a17:902:c944:b0:198:af4f:de13 with SMTP id i4-20020a170902c94400b00198af4fde13mr58116pla.19.1675279953012;
        Wed, 01 Feb 2023 11:32:33 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z28-20020a63b91c000000b004785a63b44bsm11008653pge.43.2023.02.01.11.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 11:32:32 -0800 (PST)
Date:   Wed, 1 Feb 2023 19:32:29 +0000
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
Message-ID: <Y9q+TVBYDPJuVxiu@google.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-3-aik@amd.com>
 <Y9lqiXu4yUgP6APS@zn.tnic>
 <Y9nMZNrV+Iz8Ce5l@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9nMZNrV+Iz8Ce5l@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023, Sean Christopherson wrote:
> On Tue, Jan 31, 2023, Borislav Petkov wrote:
> > Hey Sean,
> > 
> > On Fri, Jan 20, 2023 at 02:10:46PM +1100, Alexey Kardashevskiy wrote:
> > > Prior to SEV-ES, KVM stored/loaded host debug registers upon switching
> > > to/from a VM. Changing those registers inside a running SEV VM
> > > triggered #VC exit to KVM.
> > > 
> > > SEV-ES added the encrypted state (ES) which uses an encrypted guest page
> > > for the VM state (VMSA). The hardware saves/restores certain registers on
> > > VMRUN/VMEXIT according to a swap type (A, B, C), see
> > > "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
> > > volume 2.
> > > 
> > > AMD Milan (Fam 19h) introduces support for the debug registers swapping.
> > > DR6 and DR7 are always swapped. DR[0-3] and DR[0-3]_ADDR_MASK are swapped
> > > a type B when SEV_FEATURES[5] ("DebugSwap") is set.
> > > 
> > > Enable DebugSwap in VMSA. But only do so if CPUID Fn80000021_EAX[0]
> > > ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
> > > supported by the SOC as otherwise a malicious SEV-ES guest can set up
> > > data breakpoints on the #VC IDT entry/stack and cause an infinite loop.
> > > 
> > > Eliminate DR7 and #DB intercepts as:
> > > - they are not needed when DebugSwap is supported;
> > > - #VC for these intercepts is most likely not supported anyway and
> > > kills the VM.
> > > Keep DR7 intercepted unless DebugSwap enabled to prevent the infinite #DB
> > > loop DoS.
> > 
> > ...
> > 
> > ok to take this through the tip tree?
> 
> I would prefer to take this through KVM, there's enough subtle complexity in this
> code that it'd be nice to have it close by.
> 
> If you're happy with patch 1, maybe ack that one and take it through KVM, and
> route patch 3 through tip?

Ah, you've already applied 1.  That works too.  I don't think KVM support for
DebugSwap is going to make v6.3 no matter who takes what, so just base on the
next version of this patch on tip/x86/cpu and I'll make a mental note to not try
to grab this until after v6.3-rc1.
