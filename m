Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0EC16FAAC
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgBZJYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:24:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32227 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726541AbgBZJYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582709091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dgt6XDpm+t5gbM/A2cymAG6leFPsVhhYY+fVYvpm7sk=;
        b=KT7sG1JtDbok8pt/ag6S/g/KjCqy1azYXP8DzBR8HWtxiieFbfaotFH9qIbLmTefwLIUX1
        eG6+qDgDKQW98AXKNwB2esd+bBl0lUTS3UX9gn18qr/0Ks5tlBC225kF+SRFTeThof4JdQ
        IryM3+wZJlLYkV7NA9XcS4hcMsTp7FE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-vOFOMlWFNl6e-awgUkal7g-1; Wed, 26 Feb 2020 04:24:50 -0500
X-MC-Unique: vOFOMlWFNl6e-awgUkal7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C55C8014DA;
        Wed, 26 Feb 2020 09:24:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54D9D101D482;
        Wed, 26 Feb 2020 09:24:48 +0000 (UTC)
Date:   Wed, 26 Feb 2020 10:24:45 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/7] pci: use uint32_t for unsigned long
 values
Message-ID: <20200226092445.h6opjflmnmdcjf6w@kamzik.brq.redhat.com>
References: <20200226074427.169684-1-morbo@google.com>
 <20200226074427.169684-3-morbo@google.com>
 <20200226075902.3ngaicupvy6ibirr@kamzik.brq.redhat.com>
 <CAGG=3QX3repwwZ2=CNoF2F_RgZgdqKczHsMPPw_4pOXVDJ9CHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QX3repwwZ2=CNoF2F_RgZgdqKczHsMPPw_4pOXVDJ9CHA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 01:02:39AM -0800, Bill Wendling wrote:
> I suspect then that how it's used in the kvm-unit-tests isn't correct.
> Or at least it's not how it's used in the Linux source code. Would it
> be better to cast all uses of these masks to uint32_t?

Yup. If clang is upset about kvm-unit-test's use of these masks, then
we need to change how they're used, as we can't change how they're
defined.

There's only one occurrence of each though, and in the same function,
pci_bar_mask(). I'd probably just change the return type of that
function to uint64_t, rather than add casts.

Thanks,
drew

> 
> -bw
> 
> 
> On Tue, Feb 25, 2020 at 11:59 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Tue, Feb 25, 2020 at 11:44:22PM -0800, morbo@google.com wrote:
> > > From: Bill Wendling <morbo@google.com>
> > >
> > > The "pci_bar_*" functions use 64-bit masks, but the results are assigned
> > > to 32-bit variables. Use 32-bit masks, since we're interested only in
> > > the least significant 4-bits.
> > >
> > > Signed-off-by: Bill Wendling <morbo@google.com>
> > > ---
> > >  lib/linux/pci_regs.h | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
> > > index 1becea8..3bc2b92 100644
> > > --- a/lib/linux/pci_regs.h
> > > +++ b/lib/linux/pci_regs.h
> > > @@ -96,8 +96,8 @@
> > >  #define  PCI_BASE_ADDRESS_MEM_TYPE_1M        0x02    /* Below 1M [obsolete] */
> > >  #define  PCI_BASE_ADDRESS_MEM_TYPE_64        0x04    /* 64 bit address */
> > >  #define  PCI_BASE_ADDRESS_MEM_PREFETCH       0x08    /* prefetchable? */
> > > -#define  PCI_BASE_ADDRESS_MEM_MASK   (~0x0fUL)
> > > -#define  PCI_BASE_ADDRESS_IO_MASK    (~0x03UL)
> > > +#define  PCI_BASE_ADDRESS_MEM_MASK   (~0x0fU)
> > > +#define  PCI_BASE_ADDRESS_IO_MASK    (~0x03U)
> > >  /* bit 1 is reserved if address_space = 1 */
> > >
> > >  /* Header type 0 (normal devices) */
> > > --
> > > 2.25.0.265.gbab2e86ba0-goog
> > >
> >
> > This file comes directly from the Linux source. If it's not changed
> > there, then it shouldn't change here.
> >
> > Thanks,
> > drew
> >
> 

