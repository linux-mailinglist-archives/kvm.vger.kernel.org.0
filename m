Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03A117377F
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 13:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgB1MrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 07:47:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31624 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725876AbgB1MrF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 07:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582894024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bYfwvVWtwwus79V/0XOxgEz7ltZQJ9gLNNGr2YS6Rx8=;
        b=e7+XOG3zKjggXB1k2W544vvj4E8+z8r1/oxE8u/x1n1B9F8PBv34H0hN0t/OmsFCkqX2WD
        nAfIgH1qPbIR863M0+EIPkXuxtpq2QuWHx4lDSX952bGy//zRcH9a+xh0vV7eHergZxeDN
        oAXE/YhmPWJ+Ij6xzkAfmQrV59N974U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-JLLb7-eCPcav57GXXXRaOw-1; Fri, 28 Feb 2020 07:47:02 -0500
X-MC-Unique: JLLb7-eCPcav57GXXXRaOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2082BDBA9;
        Fri, 28 Feb 2020 12:47:01 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BB0910027BA;
        Fri, 28 Feb 2020 12:46:59 +0000 (UTC)
Date:   Fri, 28 Feb 2020 13:46:57 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        oupton@google.com
Subject: Re: [kvm-unit-tests PATCH 2/7] pci: use uint32_t for unsigned long
 values
Message-ID: <20200228124657.aqgrty74dbki6d4g@kamzik.brq.redhat.com>
References: <20200226074427.169684-1-morbo@google.com>
 <20200226094433.210968-1-morbo@google.com>
 <20200226094433.210968-4-morbo@google.com>
 <91b0fdf5-a948-ef61-8b05-1c5757937521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b0fdf5-a948-ef61-8b05-1c5757937521@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 12:04:38PM +0100, Paolo Bonzini wrote:
> On 26/02/20 10:44, Bill Wendling wrote:
> > The "pci_bar_*" functions use 64-bit masks, but the results are assigned
> > to 32-bit variables. Use 32-bit masks, since we're interested only in
> > the least significant 4-bits.
> > 
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  lib/linux/pci_regs.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
> > index 1becea8..3bc2b92 100644
> > --- a/lib/linux/pci_regs.h
> > +++ b/lib/linux/pci_regs.h
> > @@ -96,8 +96,8 @@
> >  #define  PCI_BASE_ADDRESS_MEM_TYPE_1M	0x02	/* Below 1M [obsolete] */
> >  #define  PCI_BASE_ADDRESS_MEM_TYPE_64	0x04	/* 64 bit address */
> >  #define  PCI_BASE_ADDRESS_MEM_PREFETCH	0x08	/* prefetchable? */
> > -#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fUL)
> > -#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03UL)
> > +#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fU)
> > +#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03U)
> >  /* bit 1 is reserved if address_space = 1 */
> >  
> >  /* Header type 0 (normal devices) */
> > 
> 
> Removing the "U" is even better because it will then sign-extend
> automatically.
>

We don't want this patch at all though. We shouldn't change pci_regs.h
since it comes from linux and someday we may update again and lose
any changes we make. We should change how these masks are used instead.

Thanks,
drew

