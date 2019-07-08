Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8C361FA9
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 15:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbfGHNl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 09:41:29 -0400
Received: from foss.arm.com ([217.140.110.172]:48252 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbfGHNl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 09:41:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C014B2B;
        Mon,  8 Jul 2019 06:41:28 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 199DA3F738;
        Mon,  8 Jul 2019 06:41:27 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:41:26 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH kvmtool 2/2] Add detach feature
Message-ID: <20190708134125.GF2790@e103592.cambridge.arm.com>
References: <20190705095914.151056-1-andre.przywara@arm.com>
 <20190705095914.151056-3-andre.przywara@arm.com>
 <20190705110438.GC2790@e103592.cambridge.arm.com>
 <20190705152958.251667e6@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705152958.251667e6@donnerap.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 03:29:58PM +0100, Andre Przywara wrote:
> On Fri, 5 Jul 2019 12:04:41 +0100
> Dave Martin <Dave.Martin@arm.com> wrote:

[...]

> > Output to a pty master before the slave is opened just disappears.
> 
> Not always, it seems. When I do:
> $ lkvm run -k Image --tty 0
> then wait for a bit and open the pseudo-terminal, I get the full boot log
> "replayed". Not sure who in the chain is actually buffering this, though?

FYI, after a bit of experimentation, it looks like the tty layer will
buffer some data (maybe 64K, didn't check exactly), after which further
writes silently disappear.  Writing doesn't yield an error in either
case.  When the slave is opened, you get actual backpressure and writes
to the master block if insufficient data has been read from the slave.

So we may lose data, depending on how much dmesg there is, and anyway
screen seems to flush pending input when opening a terminal, so I see
nothing if connecting with screen with a bunch of data already written
to the pty master.

Not sure whether this matters.

Once the slave is connected, communiction seems reliable.  (Tons of
software would likely break if it weren't.)

[...]

Cheers
---Dave
