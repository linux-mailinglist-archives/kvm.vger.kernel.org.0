Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF28421306
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 17:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbhJDPul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 11:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbhJDPuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 11:50:39 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DA1C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 08:48:50 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id u7so14830805pfg.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 08:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2+QVME3jGaX4i+4s06oICt3IEB5F1SLw8aq76ldkx6M=;
        b=UMra/6DAPUEGVAl64opwRUJGSDSURdpDW8J1XYpxrQHqkqPa79+2Epym9qE4NswufM
         iSJYfb1NZ7WrTHW16xrNcj/koM+2VFUNKlA4pGoUjxAE3Dom2sZbGjj2tDSNvtrXlwgd
         2pYWIGYVjHmgK7y22qCZkA9rWxjTopKCCH223DH8UYnJ+GH+1xdmVFvJfflKYl682hXu
         DGgxVrODnzoPicd7sAsTOt+1qsbhCrUEP2FMEW27hRe1q65hHS13+/1fmc2gWftcdpFb
         rrBSz7PtQV83LINwFcG/4+uRzrbT/CyVTlqbsCuwtx3czddxnrl3Ua0bsl0vufCNiH0q
         rUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2+QVME3jGaX4i+4s06oICt3IEB5F1SLw8aq76ldkx6M=;
        b=yBOW+KA4z+t7YHhBRe0Eaq98cbL0UTD7prk2F3uUQvWZeUgu53AZUF3vuXgVgi9J0u
         fyHgLpcDxzulbTE1XNbNNwVCYTWrsH5IPhvbTXqAg6wALpPgPZIepurmNBBckmpn9HkD
         jbvBiZ+JXKmTKwwwOU6A8cXrKZq8Kzn0VIrJw6BIU9U/PwCI+NaOO2244x875elf1GuV
         x+Dxb0VQRiEJOf6CGQoLegcb9r5TtDEEArcpMtXbiIYS1Quqz69CWCpU+71PiBZM2GOe
         /VUyjL4PcwFoZ5MSjwQowWDWVakmm8iLjtgsh3LHTv02nz9L+TGuPF/0ooDI3REjUWhH
         8C0A==
X-Gm-Message-State: AOAM533md3SJCl5R9by1x97tUjgzLoyd5HYr11jOafsKwGKcF6OfM4dU
        qBE9daIRXA4Ttv/g1J/X1/AWmQ==
X-Google-Smtp-Source: ABdhPJxJsWjoIvrmIZg9ung+Ty/mnWFZBl04uc7InBbcLjywVlqeNBL2YDyrTzIOAh/1YDgsXq/ovA==
X-Received: by 2002:a05:6a00:c8c:b0:447:bddb:c83 with SMTP id a12-20020a056a000c8c00b00447bddb0c83mr26862283pfv.1.1633362529436;
        Mon, 04 Oct 2021 08:48:49 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h4sm4880532pjm.14.2021.10.04.08.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 08:48:48 -0700 (PDT)
Date:   Mon, 4 Oct 2021 08:48:45 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
        shuah@kernel.org, jingzhangos@google.com, pshier@google.com,
        rananta@google.com, reijiw@google.com
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
Message-ID: <YVsiXYFKSG/C4dGD@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
 <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
 <YVTX1L8u8NMxHAyE@google.com>
 <1613b54f-2c4b-a57a-d4ba-92e866c5ff1f@redhat.com>
 <YVYp1E7bqIFttXF+@google.com>
 <87k0iwsxce.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0iwsxce.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01, 2021 at 02:12:17PM +0100, Marc Zyngier wrote:
> On Thu, 30 Sep 2021 22:19:16 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Thu, Sep 30, 2021 at 09:02:12AM +0200, Eric Auger wrote:
> > > Hi,
> > > 
> > > On 9/29/21 11:17 PM, Ricardo Koller wrote:
> > > > On Wed, Sep 29, 2021 at 06:29:21PM +0200, Eric Auger wrote:
> > > >> Hi Ricardo,
> > > >>
> > > >> On 9/28/21 8:47 PM, Ricardo Koller wrote:
> > > >>> Add the new vgic_check_iorange helper that checks that an iorange is
> > > >>> sane: the start address and size have valid alignments, the range is
> > > >>> within the addressable PA range, start+size doesn't overflow, and the
> > > >>> start wasn't already defined.
> > > >>>
> > > >>> No functional change.
> > > >>>
> > > >>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > >>> ---
> > > >>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
> > > >>>  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
> > > >>>  2 files changed, 26 insertions(+)
> > > >>>
> > > >>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > >>> index 7740995de982..f714aded67b2 100644
> > > >>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > >>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > >>> @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> > > >>>  	return 0;
> > > >>>  }
> > > >>>  
> > > >>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> > > >>> +		       phys_addr_t addr, phys_addr_t alignment,
> > > >>> +		       phys_addr_t size)
> > > >>> +{
> > > >>> +	int ret;
> > > >>> +
> > > >>> +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
> > > >> nit: not related to this patch but I am just wondering why we are
> > > >> passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to
> > > >>
> > > >> vgic_check_iorange()? This must be a leftover of some old code?
> > > >>
> > > > It's used to check that the base of a region is not already set.
> > > > kvm_vgic_addr() uses it to make that check;
> > > > vgic_v3_alloc_redist_region() does not:
> > > >
> > > >   rdreg->base = VGIC_ADDR_UNDEF; // so the "not already defined" check passes
> > > >   ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> > > Yes but I meant why a pointer?
> > 
> > I can't think of any good reason. It must be some leftover as you said.
> 
> It definitely is. Please have a patch to fix that. Also, it doesn't
> look like vgic_check_ioaddr() has any other user at the end of the
> series. Worth getting rid of.

ACK fixing that and getting rid of vgic_check_ioaddr().

Thanks,
Ricardo

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
