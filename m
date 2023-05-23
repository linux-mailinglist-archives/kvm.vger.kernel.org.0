Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64A70E0C0
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 17:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbjEWPlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 11:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbjEWPlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 11:41:04 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70E8412B
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 08:41:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33158139F;
        Tue, 23 May 2023 08:41:46 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C6E83F840;
        Tue, 23 May 2023 08:41:00 -0700 (PDT)
Date:   Tue, 23 May 2023 16:40:52 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool v2 2/2] virtio/rng: return at least one byte of
 entropy
Message-ID: <20230523164052.7b9c435b@donnerap.cambridge.arm.com>
In-Reply-To: <20230523104503.GB7414@willie-the-truck>
References: <20230419170136.1883584-2-andre.przywara@arm.com>
        <20230419170526.1883812-1-andre.przywara@arm.com>
        <20230420134627.GA282884@myrica>
        <20230523104503.GB7414@willie-the-truck>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 May 2023 11:45:03 +0100
Will Deacon <will@kernel.org> wrote:

Hi Will,

> On Thu, Apr 20, 2023 at 02:46:27PM +0100, Jean-Philippe Brucker wrote:
> > On Wed, Apr 19, 2023 at 06:05:26PM +0100, Andre Przywara wrote:  
> > > In contrast to the original v0.9 virtio spec (which was rather vague),
> > > the virtio 1.0+ spec demands that a RNG request returns at least one
> > > byte:
> > > "The device MUST place one or more random bytes into the buffer, but it
> > > MAY use less than the entire buffer length."
> > > 
> > > Our current implementation does not prevent returning zero bytes, which
> > > upsets an assert in EDK II. /dev/urandom should always return at least
> > > 256 bytes of entropy, unless interrupted by a signal.
> > > 
> > > Repeat the read if that happens, and give up if that fails as well.
> > > This makes sure we return some entropy and become spec compliant.
> > > 
> > > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > > Reported-by: Sami Mujawar <sami.mujawar@arm.com>
> > > ---
> > >  virtio/rng.c | 14 ++++++++++++--
> > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/virtio/rng.c b/virtio/rng.c
> > > index e6e70ced3..d5959d358 100644
> > > --- a/virtio/rng.c
> > > +++ b/virtio/rng.c
> > > @@ -66,8 +66,18 @@ static bool virtio_rng_do_io_request(struct kvm *kvm, struct rng_dev *rdev, stru
> > >  
> > >  	head	= virt_queue__get_iov(queue, iov, &out, &in, kvm);
> > >  	len	= readv(rdev->fd, iov, in);
> > > -	if (len < 0 && errno == EAGAIN)
> > > -		len = 0;
> > > +	if (len < 0 && (errno == EAGAIN || errno == EINTR)) {
> > > +		/*
> > > +		 * The virtio 1.0 spec demands at least one byte of entropy,
> > > +		 * so we cannot just return with 0 if something goes wrong.
> > > +		 * The urandom(4) manpage mentions that a read from /dev/urandom
> > > +		 * should always return at least 256 bytes of randomness, so  
> > 
> > I guess that's implied, but strictly speaking the manpage only states that
> > reads of <=256 bytes succeed. Larger reads may return an error again or
> > (if you read the man naively) zero bytes. We could increase the chance of
> > this succeeding by setting in = 1 and iov_len = min(iov_len, 256)  
> 
> Andre -- do you plan to respin with Jean's suggestion above?

Yes, sorry, I read too much into the suggestion at first, so it got pushed
off the table.
But reading that again now and looking at the code I realise that it's
indeed easy to implement. I will post something shortly.

Thanks,
Andre.

