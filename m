Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623DC735ED5
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 23:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjFSVNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 17:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFSVNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 17:13:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D1AE4E;
        Mon, 19 Jun 2023 14:13:08 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1687209187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ivHjZk8fFqTFzRj+cfny70EMr9Go5eZSugY+CzDe+1w=;
        b=HSQKF1I4+fqvWlpnhgM1bP48xgjlOmpPi0VvRBC1AztdA/uX6+T02Ye9Kb6U7UwKJC0Xu+
        VFpOzmZtmFgg6UbzDSmLsRASAuefF8ipuSwRprJJpHBK/4dlJmMdxEl0WApW4xdRCVkuFT
        8KU1YH8wDbwWAoGKgbXwXaijT8UscSB0PQowHtK8ALJFJDVs50Bkp74jMZlaL9NSBYxwQB
        ZorJxz1ZLxQAs2oCMIcPCnxQWDGnr86DIJMqzoM0RftRAec9gNC7BLx2fp0K/Vmph5VwIA
        d0ld5iGu5JN4YU1PSdVMMGlyJck76LS59R311IPIS121lRf7Kp1yMfDQY/RzcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1687209187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ivHjZk8fFqTFzRj+cfny70EMr9Go5eZSugY+CzDe+1w=;
        b=/8Y4h2G0iyKO1NcBDGUvGCzdS4TtKsNfVvPUuEM/6slBzUaemHp2mHaeh02PZk2yC5I1Gi
        gyqQylbBgXo+AyDw==
To:     "Li, Xin3" <xin3.li@intel.com>,
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
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 05/33] x86/traps: add external_interrupt() to
 dispatch external interrupts
In-Reply-To: <SA1PR11MB67340ED76E3707707D1D61A3A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-6-xin3.li@intel.com> <87ttvm6s2v.ffs@tglx>
 <SA1PR11MB67340ED76E3707707D1D61A3A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
Date:   Mon, 19 Jun 2023 23:13:06 +0200
Message-ID: <87pm5rp34t.ffs@tglx>
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

On Mon, Jun 19 2023 at 19:16, Li, Xin3 wrote:
>> > Add external_interrupt() to dispatch external interrupts to their handlers.
>> >
>> > If an external interrupt is a system interrupt, dipatch it through
>> > system_interrupt_handlers table, otherwise to
>> > dispatch_common_interrupt().
>> 
>> This naming convention sucks. external interrupts which can be system
>> interrupts. Come on.
>
> This name dispatch_common_interrupt() comes from arch/x86/kernel/irq.c:

That's not the point. Your changelog says:

  If an external interrupt is a system interrupt...

It's either an external interrupt which goes through common_interrupt()
or it is a system interrupt which goes through it's very own handler,
no?

Thanks,

        tglx





