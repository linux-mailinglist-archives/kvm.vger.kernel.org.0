Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D327D76D0
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 23:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjJYV2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 17:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjJYV2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 17:28:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C350136;
        Wed, 25 Oct 2023 14:28:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E30C433C8;
        Wed, 25 Oct 2023 21:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698269289;
        bh=z3QQjRLSPMK5zGX/5qNvYvsZV/S9Sq7ccMnJNPKjBYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=imty5sGi4tVZyJnrWC/kRU003stQFsLur3833DsGUz8zBdx2WxOAUSRogSsJsDex6
         aJKftFNE6qCEXVffu660pOoTkeezQXbhda07fIAF3EliRY12wsfRPVwSJvTbNJFb8t
         fe72VrA1GZjPOy4W/Uj1LKet9Ha/MjoCSakkepZo3/QezWh9FFpS8bZZIkS68504s7
         Pdh4QCIQQVdJmmBSBdwpcdbP3FvstW1YFmiIgwg8yIcutsvegJMvG7QwUdgrBxADeH
         MkNVoVc1EVnoqtTfV5ZHP8OozxwCGlT4UeHNEMrsAbpphHbXTQt5jYljEXoaEh4Oyp
         91a2nDZ/2+8aQ==
Date:   Wed, 25 Oct 2023 14:28:06 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH v3 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231025212806.pgykrxzcmbhrhix5@treble>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-1-52663677ee35@linux.intel.com>
 <8b6d857f-cbf6-4969-8285-f90254bdafc0@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b6d857f-cbf6-4969-8285-f90254bdafc0@citrix.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 10:10:41PM +0100, Andrew Cooper wrote:
> On 25/10/2023 9:52 pm, Pawan Gupta wrote:
> > diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
> > index bfb7bcb362bc..f8ba0c0b6e60 100644
> > --- a/arch/x86/entry/entry.S
> > +++ b/arch/x86/entry/entry.S
> > @@ -20,3 +23,16 @@ SYM_FUNC_END(entry_ibpb)
> >  EXPORT_SYMBOL_GPL(entry_ibpb);
> >  
> >  .popsection
> > +
> > +.pushsection .entry.text, "ax"
> > +
> > +.align L1_CACHE_BYTES, 0xcc
> > +SYM_CODE_START_NOALIGN(mds_verw_sel)
> > +	UNWIND_HINT_UNDEFINED
> > +	ANNOTATE_NOENDBR
> > +	.word __KERNEL_DS
> 
> You need another .align here.  Otherwise subsequent code will still
> start in this cacheline and defeat the purpose of trying to keep it
> separate.
> 
> > +SYM_CODE_END(mds_verw_sel);
> 
> Thinking about it, should this really be CODE and not a data entry?
> 
> It lives in .entry.text but it really is data and objtool shouldn't be
> writing ORC data for it at all.
> 
> (Not to mention that if it's marked as STT_OBJECT, objdump -d will do
> the sensible thing and not even try to disassemble it).
> 
> ~Andrew
> 
> P.S. Please CC on the full series.  Far less effort than fishing the
> rest off lore.

+1 to putting it in .rodata or so.

-- 
Josh
