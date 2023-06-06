Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A12C7235FC
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 06:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjFFEAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 00:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjFFD75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 23:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DAC12B;
        Mon,  5 Jun 2023 20:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C47661B07;
        Tue,  6 Jun 2023 03:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596DFC433EF;
        Tue,  6 Jun 2023 03:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686023995;
        bh=4v9Hl20weE7nC2/iU8oUb/lX3uVDkp+nEUVQFcnotdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SfT0MQEV2bRNh1BET2wefpRfLKV9rfymlMzZlS46qmu2j90VIwguR51wXBCXvZ0T/
         CtRZmAJ36hSnVSi45ap6tk/n130KFrAPabz5XevRkAXVbOyAdhgRi/qXjun5ELPqQr
         vIsakfnM/Vl3QqvMTNdeiZRZNfDPNZ5W9X2nUGgYYaCqGeRNt3B+YO8IQrrfv0rSZf
         2xqHg2CT0Iznr63U0yFi4nMEGVObwR+2G0eFwQU1XdaEUXGji1DB07QAxC0N+pH8vl
         aLzbCYvkLNqigbUYdLdFeoIgz1ppICYwLmraqy67Y+0ZLYJCRnFRXr1Vcw5zMlfwu5
         X9x5sMhq676ZQ==
Date:   Mon, 5 Jun 2023 20:59:53 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Jon Kohler <jon@nutanix.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230606035953.fssnnwkk2nd2jmqm@treble>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
 <20230601042345.52s5337uz62p6aow@treble>
 <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
 <20230605163552.hi5kvh5wijegmus6@treble>
 <790725a7-cde8-addb-c2e4-91827f70215e@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <790725a7-cde8-addb-c2e4-91827f70215e@citrix.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 01:20:52AM +0100, Andrew Cooper wrote:

<clip very useful summary which belongs in git somewhere>

> But, the safety of vmx_spec_ctrl_restore_host() in the first place
> depends on the early return never ever becoming a conditional,

Good point.  And that would be easier to overlook in C.

> and the compiler never emitting a call to memcpy()/memset()/whatever
> behind your back - something which is not prohibited by noinstr.

Au contraire, objtool has checking for that:

	if (state->noinstr && state->instr <= 0 &&
	    !noinstr_call_dest(file, insn, insn_call_dest(insn))) {
		WARN_INSN(insn, "call to %s() leaves .noinstr.text section", call_dest_name(insn));
		return 1;
	}

Regardless, despite being the person who wrote this thing in C to begin
with, I believe asm really is a better fit due to the delicate and
precise nature of the mitigations.

-- 
Josh
