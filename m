Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DFA6145E8
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 09:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiKAIpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 04:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiKAIpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 04:45:23 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F75B14D2C
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 01:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+4shGnTGyyqimiFJUX4nbKaXDHoHppUxzTMRkiuD8ZA=; b=VPKBhXQjcx0hmydYwQEw0pXfxU
        JG0p2xW/N/RW/cNQJoIFGX+nBJb9yHjY19pdBT96IrKH8imbUFZorXn1W4dNpEzfjc9+WkJGxz0pc
        MRneJ4tYoiC8jy9pN/7paEUwgdbyOuwkXbjJ8NluKiGOeoNChKYE4Sm5pAgQFvWV1WjXQBPGkbzBd
        Vwmk2ogjXv3jKd/HlYASdYhfmchbA5ZTIVPX+IRErZLv/DydVUxQ0MLJvShvj+nUdNYeD2/DOF4Xf
        E/LZL08V54slU9ABZCJSZj2ZL6fhaWWtmhMSwGoVN9orxCco6G5BJiraIUQQCkeIjLkzMDPgkK1m0
        N5N0HOwA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1opmtE-0085iW-Ea; Tue, 01 Nov 2022 08:44:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D39E0300282;
        Tue,  1 Nov 2022 09:44:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C5FA2203EE1B4; Tue,  1 Nov 2022 09:44:53 +0100 (CET)
Date:   Tue, 1 Nov 2022 09:44:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: fix undefined behavior in bit shift for
 __feature_bit
Message-ID: <Y2DchcVrZIMfk8Fv@hirez.programming.kicks-ass.net>
References: <20221101022828.565075-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101022828.565075-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022 at 10:28:28AM +0800, Gaosheng Cui wrote:
> Shifting signed 32-bit value by 31 bits is undefined, so we fix it
> with the BIT() macro, at the same time, we change the input to
> unsigned, and replace "/ 32" with ">> 5".
> 
> The UBSAN warning calltrace like below:
> 
> UBSAN: shift-out-of-bounds in arch/x86/kvm/reverse_cpuid.h:101:11
> left shift of 1 by 31 places cannot be represented in type 'int'

Again; please go fix your toolchain and don't quote broken crap like
this to change the code.

I'm fine with the changes, but there is no UB here, don't pretend there
is.
