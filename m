Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DBF722D61
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbjFERLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjFERLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:11:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F5AAF;
        Mon,  5 Jun 2023 10:11:03 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685985062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MFaSLk23THsJ09mzX3dHcAOoOLFZG6DLl0bdQZuaWjM=;
        b=cbgobbL15uiV8Of4zbC7UgLP7wwzytE9qgLppDltFP3VsPHdHnGaaImphaXITw3oKSIDKC
        VW1hZMZV/v0BCR1JCAVLQ8SAw/5qJnHr5436HWO5ZIDAeprgDDGUhzd+iJ51x0ulwd+AYP
        Y7kmSfm6MJxtYF7fTY6L5enyNYY1wM0jOMMb0iv2PlAoJoXotyVHKO8s+0W7uR2sxiDm5U
        tGGiwcBwNU3UJk6z1NIJ+Uwr1JZQyKdj8OgrGIiMDfS2J28NLdeVHs6rrNgAIATo0HAXRi
        5kJ/asDXq0/o1vhX1M2dBN2XCriH+a/dJZCkjRQ+6IRYrbYjOdK1seCWrUZ2Sw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685985062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MFaSLk23THsJ09mzX3dHcAOoOLFZG6DLl0bdQZuaWjM=;
        b=FJTUuVFXU3i3P0nmOcs4QnOCo5wh8rYrr6xQyOmq1BIbddhpsSs/eSKweNEppFTaahPA8g
        JvIxnFbOgGwvxWAw==
To:     "Li, Xin3" <xin3.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>
Subject: RE: [PATCH v8 00/33] x86: enable FRED for x86-64
In-Reply-To: <SA1PR11MB6734AF471CED746AA998A2ACA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <f4967a86-d575-7e82-3e60-183cfd7adf0a@intel.com>
 <SA1PR11MB6734AF471CED746AA998A2ACA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
Date:   Mon, 05 Jun 2023 19:11:01 +0200
Message-ID: <87bkht6di2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 19:16, Li, Xin3 wrote:
>> Oh, and one other nit.  We do have a specific maintainer for the entry code:
>> 
>> > X86 ENTRY CODE
>> > M:      Andy Lutomirski <luto@kernel.org>
>> > L:      linux-kernel@vger.kernel.org
>> > S:      Maintained
>> > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/asm
>> > F:      arch/x86/entry/
>> 
>> Please make sure to cc Andy on FRED going forward.
>> 
>> This is probably also a good cue to go and make sure you didn't miss any other
>> folks that need to see this series.
>
> My bad, and surely will add Andy.

He's on CC indirectly via the x86@kernel.org mail exploder.
