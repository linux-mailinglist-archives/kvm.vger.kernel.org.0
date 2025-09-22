Return-Path: <kvm+bounces-58393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C5FEB924B0
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2812919056B6
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDC63112DC;
	Mon, 22 Sep 2025 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQyqN8Pu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71011F5838
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758559629; cv=none; b=VbPIJcEcC8WwGRcKrT0xVpWUFzPEXg5Dis+B6xZXcSkwwtcFo7bHOuWYM2yyhq+DDgRIyrUMWQq9tWqFVfocP+fc5aRAR/UWo6qte3f/supM7v1oLhvXimNSwjQQh7IoVIxgUncIZAlB029F9ljNc0+zpMGPyRfB6uSA94QO4iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758559629; c=relaxed/simple;
	bh=x8lJJ4dWPxSAQeyR5eYQziX7CtVYqXNpoJSz6KwAtMw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/5gzJUnbxHCy4vAxqDU4C1CBhh7GJDCa25TP6rBPZn+1B1B01sVTUcVqLbUoTS+KbZ/CfLFJc1MGTC7Ka7tRrHoPhuDHydvlnqk9jDPgJ/0j2Tu4cRW+ytxuda7rQGgDnHQEH3KJGsZDUD6b6dat3B2Pbv4wpIH5mY8jzZAJGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WQyqN8Pu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758559626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fRdA7nsQf+ROdRRV/X8F80rPVzMRc7WYaZxeLJaoIjA=;
	b=WQyqN8Pu8wwVGF+Br9m/jPVBT0EuVuxXw56L7AFItOeGtNQaKfrIyd6n3QdC5aZPZ8EsUB
	CjBZusBNhsi85c9tLh8Gew6Jk3XE3uBfMIXxRhDy6pMr8U0RkcOaC96D1L6tqGA+JPeP09
	Gb8L7VDg7K5l7ONkK3tb1oT+6ZS/ZAE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-XjdSvOvwNPORtBOyIdMEQg-1; Mon, 22 Sep 2025 12:47:03 -0400
X-MC-Unique: XjdSvOvwNPORtBOyIdMEQg-1
X-Mimecast-MFC-AGG-ID: XjdSvOvwNPORtBOyIdMEQg_1758559623
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8935214d60bso106419939f.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758559622; x=1759164422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRdA7nsQf+ROdRRV/X8F80rPVzMRc7WYaZxeLJaoIjA=;
        b=Fjx5U889jNFEcvZlfMGtrYA0bo6M8Mo/OiR3lOwzmZSNfw+9agMOwvpCaEPZpDYyxJ
         /gyxrPtIRY6Uwphuo4LxcUKzFQ+m51aObKacG2l+3Hr6GrSMjT7H6NbKzFewbOft5fAk
         +K+6q2DHrngxDsTpVGSVZRErIKnGtzxV/dPU33dg3WDYYx/Gx8Bi5ItGTh2zUrT+LFwr
         Fsy5umgyQecRl8cV14cvKBofUrwbQHSqI9aT8tsHHhT4C4HnAGhmZmxZ61c1e/HDXHKy
         BY4CfsT0SMnPXvPRjGM7/e+mBV2bDvNyTjdiwe7yFBoQID4P1voVAQNG0t1b0l02/2Rn
         3/hg==
X-Gm-Message-State: AOJu0YwYbWkZiId4F6dTkY08mTMthucM9S3Uz/zej+cMZtDSLzke9mDL
	S6ABUK1YoIWPJLSCWDLzSvvDvkaqC4LAWci0Lbtr316aUlJFodmxZJYuVkTRYiagrrN4B0DxJrs
	vR4D/XCcZPtlF3BhT1QmUQoROXCZ4inmEoBHgZXQeVYEb0wlYTshgbZ30+yY7Nw==
X-Gm-Gg: ASbGnctd1GPLYlhzYUSNZ2x+dB+unCKXtdIhGdA+u+Sc8jymCsH+7ElshjloNDVc+jk
	q/ePiMAu1tS9t4seH+IOjgTgfdTk9h2DGDYFNirOduqIxkJ35wD7oLif96Hctr64Ahw33Qn8Xea
	hI52uCk9l2o4BzAKkNFssKaQiperGV9lX9GJ1gaqkPUTuIiwqCsAehB2z42zlnLGDSi2kORxkV0
	25rc+5dNvlTSGW2+ZoSndDiExUSt82x9peb74dNgbCOePHxu0v7KQ6W9wwdU6gGkIQlZdiu9AQm
	mEJtuRM0CpOcZw8RFb9COISXQgCQM4KZQtzLiN4+dWw=
X-Received: by 2002:a05:6602:1492:b0:886:b1ad:5926 with SMTP id ca18e2360f4ac-8ade85dce23mr773714439f.4.1758559622326;
        Mon, 22 Sep 2025 09:47:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkFiz0OlFYWl2yJOU/iZB/JsOzK1cROcUGrsewO7Eh+2ZzvoGxAdaxPxrlYTqdudrZ2m5WLA==
X-Received: by 2002:a05:6602:1492:b0:886:b1ad:5926 with SMTP id ca18e2360f4ac-8ade85dce23mr773711839f.4.1758559621755;
        Mon, 22 Sep 2025 09:47:01 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8a483230f4dsm467144739f.25.2025.09.22.09.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 09:47:01 -0700 (PDT)
Date: Mon, 22 Sep 2025 10:46:58 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Timothy Pearson <tpearson@raptorengineering.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI
 devices
Message-ID: <20250922104658.7c2b775e.alex.williamson@redhat.com>
In-Reply-To: <456215532.1742889.1758558863369.JavaMail.zimbra@raptorengineeringinc.com>
References: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com>
	<20250919125603.08f600ac.alex.williamson@redhat.com>
	<1916735949.1739694.1758315074669.JavaMail.zimbra@raptorengineeringinc.com>
	<20250919162721.7a38d3e2.alex.williamson@redhat.com>
	<537354829.1740670.1758396303861.JavaMail.zimbra@raptorengineeringinc.com>
	<20250922100143.1397e28b.alex.williamson@redhat.com>
	<456215532.1742889.1758558863369.JavaMail.zimbra@raptorengineeringinc.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 11:34:23 -0500 (CDT)
Timothy Pearson <tpearson@raptorengineering.com> wrote:

> ----- Original Message -----
> > From: "Alex Williamson" <alex.williamson@redhat.com>
> > To: "Timothy Pearson" <tpearson@raptorengineering.com>
> > Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> > Sent: Monday, September 22, 2025 11:01:43 AM
> > Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices  
> 
> > On Sat, 20 Sep 2025 14:25:03 -0500 (CDT)
> > Timothy Pearson <tpearson@raptorengineering.com> wrote:  
> >> Personally, I'd argue that such old devices were intended to work
> >> with much slower host systems, therefore the slowdown probably
> >> doesn't matter vs. being more correct in terms of interrupt handling.
> >>  In terms of general kernel design, my understanding has always been
> >> is that best practice is to always mask, disable, or clear a level
> >> interrupt before exiting the associated IRQ handler, and the current
> >> design seems to violate that rule.  In that context, I'd personally
> >> want to see an argument as to why echewing this traditional IRQ
> >> handler design is beneficial enough to justify making the VFIO driver
> >> dependent on platform-specific behavior.  
> > 
> > Yep, I kind of agree.  The unlazy flag seems to provide the more
> > intended behavior.  It moves the irq chip masking into the fast path,
> > whereas it would have been asynchronous on a subsequent interrupt
> > previously, but the impact is only to ancient devices operating in INTx
> > mode, so as long as we can verify those still work on both ppc and x86,
> > I don't think it's worth complicating the code to make setting the
> > unlazy flag conditional on anything other than the device support.
> > 
> > Care to send out a new version documenting the actual sequence fixed by
> > this change and updating the code based on this thread?  Note that we
> > can test non-pci2.3 mode for any device/driver that supports INTx using
> > the nointxmask=1 option for vfio-pci and booting a linux guest with
> > pci=nomsi.  Thanks,
> > 
> > Alex  
> 
> Sure, I can update the commit message easily enough, but I must have
> missed something in regard to a needed code update.  The existing
> patch only sets unlazy for non-PCI 2.3 INTX devices, and as I
> understand it that's the behavior we have both agreed on at this
> point?

I had commented[1] that testing the interrupt type immediately after
setting the interrupt type is redundant.  Also, looking again, if we
set the flag before request_irq, it seems logical that we'd clear the
flag after free_irq.  I think there are also some unaccounted error
paths where we can set the flag without clearing it that need to be
considered.

> I've tested this on ppc64el and it works quite well, repairing the
> broken behavior where the guest would receive exactly one interrupt
> on the legacy PCI device per boot.  I don't have amd64 systems
> available to test on, however.

Noted, I'll incorporate some targeted testing here.  Thanks,

Alex

[1]https://lore.kernel.org/all/20250919125603.08f600ac.alex.williamson@redhat.com/


