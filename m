Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527136E7E50
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 17:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjDSPbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 11:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbjDSPbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 11:31:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59C6BAF
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:31:32 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A68D16F8;
        Wed, 19 Apr 2023 08:32:15 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 138C63F5A1;
        Wed, 19 Apr 2023 08:31:30 -0700 (PDT)
Date:   Wed, 19 Apr 2023 16:31:28 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: Re: [PATCH kvmtool 0/2] Fix virtio/rng handling in low entropy
 situations
Message-ID: <20230419163128.49adc0ae@donnerap.cambridge.arm.com>
In-Reply-To: <20230419151013.GC94027@myrica>
References: <20230413165757.1728800-1-andre.przywara@arm.com>
        <20230419135832.GB94027@myrica>
        <20230419151013.GC94027@myrica>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Apr 2023 16:10:13 +0100
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

Hi Jean-Philippe,

thanks for having a look!

> On Wed, Apr 19, 2023 at 02:58:32PM +0100, Jean-Philippe Brucker wrote:
> > On Thu, Apr 13, 2023 at 05:57:55PM +0100, Andre Przywara wrote:  
> > > I am not sure we now really need patch 2 anymore (originally I had this
> > > one before I switched to /dev/urandom). I *think* even a read from
> > > /dev/urandom can return early (because of a signal, for instance), so
> > > a return with 0 bytes read seems possible.  
> > 
> > Given that this should be very rare, maybe a simple loop would be better
> > than switching the blocking mode?  It's certainly a good idea to apply the
> > "MUST" requirements from virtio.  

So originally I had this patch 2/2 on its own, still using /dev/random.
And there a read() on the O_NONBLOCKed fd would return -EAGAIN immediately
for the next 30 seconds straight, so doing this in a loop sounds very
wrong. After all blocking fd's are there to solve exactly that problem.

But indeed with /dev/urandom being much nicer to us already, and with the
below mentioned special behaviour, just a simple second try (no loop) is
sufficient.

> Digging a bit more, the manpage [1] is helpful:
> 
> 	The O_NONBLOCK flag has no effect when opening /dev/urandom.
> 	When calling read(2) for the device /dev/urandom, reads of up to
> 	256 bytes will return as many bytes as are requested and will not
> 	be interrupted by a signal handler. Reads with a buffer over
> 	this limit may return less than the requested number of bytes or
> 	fail with the error EINTR, if interrupted by a signal handler.

Right, I saw references to that behaviour on the Internet(TM), but missed
the manpage stanza. It still feels a bit awkward since this seems to rely
on some Linux implementation detail, but that's certainly fine for kvmtool
(being Linux only anyway).

> So I guess you can also drop the O_NONBLOCK flag in patch 1. And for the
> second one, maybe we could fallback to a 256 bytes read if the first one
> fails

Yes, that's certainly better and simplifies that patch.

Thanks for digging this out!

Cheers,
Andre

> 
> [1] https://man7.org/linux/man-pages/man4/urandom.4.html
> 

