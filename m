Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFAF4AB213
	for <lists+kvm@lfdr.de>; Sun,  6 Feb 2022 21:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245047AbiBFU3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Feb 2022 15:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiBFU3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Feb 2022 15:29:02 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3416C06173B;
        Sun,  6 Feb 2022 12:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7i3Z46f5V98hV+7wSTAkWTsI05L/w170G6IYhhzBpJA=; b=LTZUCqL9Z3AVQpPhC89N2wQE/C
        YdGgOE1ts3Gu9PU8GOjbz4eCamBzlB/KgHkxoDvcBviMgkTQhkBe9WHUehrTo/WvD10IIuNK+Ff7k
        3IQH1lm5ymPtJtvqFFK3yULXa8hD5OViN/myVM7rlPRRzc4UccEswil6Fm69OyxKdV8xWEjCYhl+S
        WQ/MFu0/O8jyETbb6MqCdHb/i84MyngV/2XAr6K28PxPENXi/kM9GqjIUfsiapg7SkXIP+XGXdCtU
        xyrbvaM3yTboYVCL0+OvEir4eQ2qIraGZYDAnt5coom3Iuh5Y2VVy78vZCKfeZpM3IU89MSE98rt/
        NetFg+qg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nGo9W-007XVO-KM; Sun, 06 Feb 2022 20:28:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4A9503001C7;
        Sun,  6 Feb 2022 21:28:52 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 321F621378EDF; Sun,  6 Feb 2022 21:28:52 +0100 (CET)
Date:   Sun, 6 Feb 2022 21:28:52 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YgAvhG4wvnslbTqP@hirez.programming.kicks-ass.net>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
 <202202061011.A255DE55B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202202061011.A255DE55B@keescook>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 06, 2022 at 10:45:15AM -0800, Kees Cook wrote:

> I'm digging through the macros to sort this out, but IIUC, an example of
> the problem is:
> 

> so the caller is expecting "unsigned int (*)(void)" but the prototype
> of __static_call_return0 is "long (*)(void)":
> 
> long __static_call_return0(void);
> 
> Could we simply declare a type-matched ret0 trampoline too?

That'll work for this case, but the next case the function will have
arguments we'll need even more nonsense...

And as stated in that other email, there's tb_stub_func() having the
exact same problem as well.

The x86_64 CFI patches had a work-around for this, that could trivially
be lifted I suppose.
