Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F345F7D8
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 14:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfGDMSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 08:18:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51150 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbfGDMSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 08:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iwCnKxUBXFC8h9cW6GTrhdkmZ4jfn3ZbtxxcXXsGdUo=; b=dP7BnQ+t0ZJ5p39dTkWd18ccn
        mUFdQzfuS+sKioLqJ6PnC9WtCsfV/GsSnoBAGPL4BeOq8IlMkVhwsF/QI27jlAYC7+f8wZRZc3lo3
        wO7KT6t3A6mgMBodgYPce3ZzxgPBIPxclgFbfD+XBeMK9H1NQYnUPc7UMd6WFzBo+Ril/T2qtLWK9
        zhdoLKSHUC9WgBgoCl5B6xOR5E6IJev3RT3xSzJruPGT6RukhNK/z2ebaNAowhjikmjzQgzHbeHiH
        MVnGf+byJsMmg0PGElMSJsxMfbYNSy/28deNN+t/Uz1uwCgWm6QM3JDnc0voJ2uNS1JYv8tBbBpCg
        pBV2YzvjA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hj0gX-0000wZ-NU; Thu, 04 Jul 2019 12:17:59 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 174DB202167BC; Thu,  4 Jul 2019 14:17:55 +0200 (CEST)
Date:   Thu, 4 Jul 2019 14:17:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: Re: [PATCH 0/2] fix likely hint of sched_info_on()
Message-ID: <20190704121755.GM3402@hirez.programming.kicks-ass.net>
References: <1562240775-16086-1-git-send-email-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562240775-16086-1-git-send-email-wang.yi59@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 04, 2019 at 07:46:13PM +0800, Yi Wang wrote:
> When make defconfig, CONFIG_SCHEDSTATS is set to be y, so
> sched_info_on() is 'likely' to be true. However, some functions
> invoke this function with unlikely hint or use no hint. Let's
> fix this.

How about remove the hint entirely? likely(1) is as rediculous as
unlikely(1), a constant is a constant and no amount of hinting should
make the compiler do anything else.

And if you want to retain the hint for the TASK_DELAY_ACCT nonsense,
stick it there.

Also, fix the lack of { } while you're there.
