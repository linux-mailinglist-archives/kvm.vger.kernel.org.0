Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1697722885
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbjFEONp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbjFEON2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:13:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E33199F;
        Mon,  5 Jun 2023 07:12:41 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685974290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X+4SrU6DsqFWnfII4h+3uCwsRVwxeJlfoNAM29p88Hc=;
        b=cfc1TGFIOq3GkZmxix152Ox9eE2l5LJoLY1uoKd30Ng5Gl8D6tUiuIIodWpcOkxZB9vZi2
        32I6GJSyGicJFzwt9mjcSin9tgsI5GirIc5m1Y2x1/SZTOz7o4R/udgjePYCI5YDawwTLt
        IFyBHO1Tt1VBNpxNGCZLnUDvJCPrKTTzbpXUBorr0b3xixt3PzRwW2wlIgEDVDhfQyeljM
        4JixXPWR1xAf4mNg2VVCHYyQ7GMEAhFo9U7D7S8kX1DKlrn1Zw5l2Lm+3ZStv0wx+x4Jul
        rBugVLBHhK+bxOJy9vGZECO8+g+J+tdTjBuMyi3H8tyx8LBYF2mQ6VrzsdCrCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685974290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X+4SrU6DsqFWnfII4h+3uCwsRVwxeJlfoNAM29p88Hc=;
        b=JpyzuNuozBw3352cB58J1TgX/docpZU3Bc626EFoyKlYiym9df5VgyXdLEfEW6HGAXQJ/Z
        A5kLRRml7Cc7G6Dw==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 30/33] x86/fred: allow dynamic stack frame size
In-Reply-To: <20230410081438.1750-31-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-31-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 16:11:30 +0200
Message-ID: <87wn0i578t.ffs@tglx>
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

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> A FRED stack frame could contain different amount of information for
> different event types, or perhaps even for different instances of the
> same event type. Thus we need to eliminate the need of any advance
> information of the stack frame size to allow dynamic stack frame size.
>
> Implement it through:
>   1) add a new field user_pt_regs to thread_info, and initialize it
>      with a pointer to a virtual pt_regs structure at the top of a
>      thread stack.
>   2) save a pointer to the user-space pt_regs structure created by
>      fred_entrypoint_user() to user_pt_regs in fred_entry_from_user().
>   3) initialize the init_thread_info's user_pt_regs with a pointer to
>      a virtual pt_regs structure at the top of init stack.
>
> This approach also works for IDT, thus we unify the code.

And thereby remove the useful comment and replace it with an
undocumented macro mess.

I'm simply refusing to review this. It's not my job to understand this
undocumented hackery.

Thanks,

        tglx
