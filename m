Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532982DC12A
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 14:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgLPNX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 08:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLPNX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 08:23:58 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A7FC061794;
        Wed, 16 Dec 2020 05:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=95msmM877FANGbmUJSbNRwzAbKxmAIM1FYP9XpNYstM=; b=TgQk7p9hXpt+LoAtB8GbMtNlwo
        cmydjNOqaJbuz/GWF578F0yfcSXd8vwuMc2UC7lPL1UvM5NXwdTgkp2DQqVp86UblNvcTWNOn/szf
        gBEtRteEugMx8hDULOWRrDzZco22b3CRQp4j2zrDAwkba7DorIMVeQMZsd1cK2pXg3j0QDXh9AHjt
        8RxWIsxbsppdmtsDRgFq9yJTOGOoM5MXsgiJWa07hwRqtzydz3g4FCgCU874+DIMw/8SPu6K5qltW
        2YK8DrqfSvQdh6UAZchWX/0Qc+QM3AZoYC0Jkk3SJPP/9t30W6AKwdYWEvTfCkWoGjfQ5fEVL2Ltv
        xM6IaCWA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpWlu-0000SP-3v; Wed, 16 Dec 2020 13:23:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C17313059C6;
        Wed, 16 Dec 2020 14:23:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AE0E3201007EB; Wed, 16 Dec 2020 14:23:12 +0100 (CET)
Date:   Wed, 16 Dec 2020 14:23:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: static_branch_enable() does not work from a __init function?
Message-ID: <20201216132312.GA3021@hirez.programming.kicks-ass.net>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216115524.GA13751@linux-8ccs>
 <20201216124708.GZ3021@hirez.programming.kicks-ass.net>
 <20201216131016.GC13751@linux-8ccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216131016.GC13751@linux-8ccs>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 02:10:16PM +0100, Jessica Yu wrote:
> +++ Peter Zijlstra [16/12/20 13:47 +0100]:

> > Only because we're having .init=false, incorrectly. See the other email.
> 
> Ah yeah, you're right. I also misread the intention of the if
> conditional :/ If we're currently running an init function it's fine,
> but after that it will be unsafe.

Exactly, seeing how it'll end up being freed and such ;-)

> Btw, your patch seems to work for me, using the test module provided
> by Dexuan.

Ah, excellent. I couldn't be bothered to figure out how to build a
module ;-)

I'll add your Tested-by and go queue it for /urgent I suppose.
