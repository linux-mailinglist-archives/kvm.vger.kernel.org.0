Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EB454010E
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 16:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243646AbiFGOS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 10:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244279AbiFGOSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 10:18:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18773663D1
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 07:18:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E080143D;
        Tue,  7 Jun 2022 07:18:16 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02D5B3F66F;
        Tue,  7 Jun 2022 07:18:15 -0700 (PDT)
Date:   Tue, 7 Jun 2022 15:18:13 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 2/4] virtio/mmio: access header members normally
Message-ID: <20220607151813.3ea2febb@donnerap.cambridge.arm.com>
In-Reply-To: <20220607103658.GA32508@willie-the-truck>
References: <20220601165138.3135246-1-andre.przywara@arm.com>
        <20220601165138.3135246-3-andre.przywara@arm.com>
        <20220607103658.GA32508@willie-the-truck>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jun 2022 11:36:58 +0100
Will Deacon <will@kernel.org> wrote:

Hi Will,

> On Wed, Jun 01, 2022 at 05:51:36PM +0100, Andre Przywara wrote:
> > The handlers for accessing the virtio-mmio header tried to be very
> > clever, by modelling the internal data structure to look exactly like
> > the protocol header, so that address offsets can "reused".
> > 
> > This requires using a packed structure, which creates other problems,
> > and seems to be totally unnecessary in this case.
> > 
> > Replace the offset-based access hacks to the structure with proper
> > compiler visible accesses, to avoid unaligned accesses and make the code
> > more robust.
> > 
> > This fixes UBSAN complaints about unaligned accesses.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  include/kvm/virtio-mmio.h |  2 +-
> >  virtio/mmio.c             | 19 +++++++++++++++----
> >  2 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
> > index 13dcccb6..aa4cab3c 100644
> > --- a/include/kvm/virtio-mmio.h
> > +++ b/include/kvm/virtio-mmio.h
> > @@ -39,7 +39,7 @@ struct virtio_mmio_hdr {
> >  	u32	interrupt_ack;
> >  	u32	reserved_5[2];
> >  	u32	status;
> > -} __attribute__((packed));
> > +};  
> 
> Does this mean that the previous patch is no longer required?

To some degree patch 1/4 is the quick fix. But I think ordering
struct members in an efficient way is never a bad idea, so that patch
still has some use.

> >  struct virtio_mmio {
> >  	u32			addr;
> > diff --git a/virtio/mmio.c b/virtio/mmio.c
> > index 3782d55a..c9ad8ee7 100644
> > --- a/virtio/mmio.c
> > +++ b/virtio/mmio.c
> > @@ -135,12 +135,22 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
> >  
> >  	switch (addr) {
> >  	case VIRTIO_MMIO_MAGIC_VALUE:
> > +		memcpy(data, &vmmio->hdr.magic, sizeof(vmmio->hdr.magic));  
> 
> Hmm, this is a semantic change as we used to treat the magic as a u32 by
> passing it to ioport__write32(), which would in turn do the swab for
> big-endian machines.

Ah, it's big endian testing time again (is it already that time of the
year?)

> 
> I don't think we should be using raw memcpy() here.

I will check, thanks for having a look!

Cheers,
Andre
