Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1DD70DAC8
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 12:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbjEWKpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 06:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236611AbjEWKpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 06:45:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A88126
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 03:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2411C625DC
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 10:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E37C433EF;
        Tue, 23 May 2023 10:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684838708;
        bh=1YY7PdT48v9y3sMOjj/bMH3En/m4I7NgMvJCMwKSNfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YtKcs6eNBIFnpZjtXuHsiC5TvZYiSSrjlSlgRd4Si2KvFMz+w9P8ocnhd/5nGILLm
         fPLhXzczluLRahxmHeaK2Lk0pj10hdf9lYHm9OhnBylUO8eL1x6l9a3uw+T1kT5/YQ
         d7SeykBP9Qv8MMzUrMF9KGGR5CWKV5XzfZ5gw3F+8xEpYONZfAHDrEOXG6vrT5gXCs
         2Lbz2ac/Ot/RBcE4zdpca36eaOzkw6leCOP6i+f9mVehh/JzGDMyokTWLANaDabtxK
         NBOly5Fq6rTFfYeUO01KXXhfF495T57nZFjdqMbtMmH+GNMpSwvpsd2IdzB23TpnHG
         N0cX62R1QZf8w==
Date:   Tue, 23 May 2023 11:45:03 +0100
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool v2 2/2] virtio/rng: return at least one byte of
 entropy
Message-ID: <20230523104503.GB7414@willie-the-truck>
References: <20230419170136.1883584-2-andre.przywara@arm.com>
 <20230419170526.1883812-1-andre.przywara@arm.com>
 <20230420134627.GA282884@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420134627.GA282884@myrica>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 02:46:27PM +0100, Jean-Philippe Brucker wrote:
> On Wed, Apr 19, 2023 at 06:05:26PM +0100, Andre Przywara wrote:
> > In contrast to the original v0.9 virtio spec (which was rather vague),
> > the virtio 1.0+ spec demands that a RNG request returns at least one
> > byte:
> > "The device MUST place one or more random bytes into the buffer, but it
> > MAY use less than the entire buffer length."
> > 
> > Our current implementation does not prevent returning zero bytes, which
> > upsets an assert in EDK II. /dev/urandom should always return at least
> > 256 bytes of entropy, unless interrupted by a signal.
> > 
> > Repeat the read if that happens, and give up if that fails as well.
> > This makes sure we return some entropy and become spec compliant.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > Reported-by: Sami Mujawar <sami.mujawar@arm.com>
> > ---
> >  virtio/rng.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virtio/rng.c b/virtio/rng.c
> > index e6e70ced3..d5959d358 100644
> > --- a/virtio/rng.c
> > +++ b/virtio/rng.c
> > @@ -66,8 +66,18 @@ static bool virtio_rng_do_io_request(struct kvm *kvm, struct rng_dev *rdev, stru
> >  
> >  	head	= virt_queue__get_iov(queue, iov, &out, &in, kvm);
> >  	len	= readv(rdev->fd, iov, in);
> > -	if (len < 0 && errno == EAGAIN)
> > -		len = 0;
> > +	if (len < 0 && (errno == EAGAIN || errno == EINTR)) {
> > +		/*
> > +		 * The virtio 1.0 spec demands at least one byte of entropy,
> > +		 * so we cannot just return with 0 if something goes wrong.
> > +		 * The urandom(4) manpage mentions that a read from /dev/urandom
> > +		 * should always return at least 256 bytes of randomness, so
> 
> I guess that's implied, but strictly speaking the manpage only states that
> reads of <=256 bytes succeed. Larger reads may return an error again or
> (if you read the man naively) zero bytes. We could increase the chance of
> this succeeding by setting in = 1 and iov_len = min(iov_len, 256)

Andre -- do you plan to respin with Jean's suggestion above?

Will
