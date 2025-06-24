Return-Path: <kvm+bounces-50535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A050EAE6F06
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20FB51BC53B2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3B92E8DF7;
	Tue, 24 Jun 2025 18:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="c827gbcI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FA32E763C
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 18:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750791509; cv=none; b=Lf4I564gWFz1kR+J93pYpNua5s+3UedksFhumaXo8IRWL8squD2bqh7vYx9xU6RyCYtncOFdJTy1L1v41aOvM0WpN2FDw1Bc+xmwP9hoMjrvMlh+jc2b4fLoXFrAJwNTEgZpToNLVOrJvEIJ/wh75tS7kibxwggv14rA5Ka5tn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750791509; c=relaxed/simple;
	bh=1euhTr1m2G8OQzQdrKy8My4UoIQ7gLuT2G550ln9JUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwP13G9eepFOmZTxL0Vv5Bi/YYQlOkzNKHh0/vY7JEdIXnwH4rqJOXbX4oLstsVYd4Iwg4u1xrY6FyRNLT24ZGxD+yMw56W5nn0VU4Qzdv3vXpP/0OWitbKkpdaUcarxzvIUwtcSVKJluwvF+5vpTfw7+YRc9DwuH8VPq6e2tGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=c827gbcI; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6fae04a3795so9965496d6.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 11:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750791506; x=1751396306; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/dPp8G4B6NbKyt49W8JBKu/RwFw1JJYSMb2wc/ipDrg=;
        b=c827gbcI/fKUBgrBkKz1q1ByPM5kuZTugw44g/ZayhjByUzo/dVeYWx0RzYS9Xbvsv
         mRrob7+RXy4y9I+ed6JojPN3otwuZXRoN5DZzKm9OjxB/uc9yLSM13K+KbDuinaIhdbQ
         Ejzst+nWYiGgDlR/Rhx6lvqNA1NpaxPTzYmF5pZEcYzANpZr3pe65aY/IhC/wMEysgmf
         aepe/kFxIGxVE/puJ6psLWcqSP6yF1c7lND1ddsHE5gsHzneUVj8zKkv4dY2/LH0PAQg
         N6UiAJ8IVoTT2UvoRiqi2ra9SLJjNHyY25CvwR7W+VGuS55ePhdHU4Ybk8VFo3UCIaA/
         LzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750791506; x=1751396306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dPp8G4B6NbKyt49W8JBKu/RwFw1JJYSMb2wc/ipDrg=;
        b=pEfuTh8kMntyHB8U5JLKvnKRHZY11x37o4ccM2mUAU+MUmbHlwlV+JR8ddZXzi3/qo
         dkeMZwUZ9By6YDyM54IW1DtfLQuiK2OOgTnJbfRF0OfyRL+ZVeHIONhTx+kooYuh5IIC
         tmjgJK1HfCSLmHewKstleVnKuZAhn34A6o8+Z04m8Okxv1tMQ3l+W+m1CtzUBEseNBdr
         bTEs8LDARMltJbN7W7HK1ztN8GGpRDHtY9sw+cusP4slKeyQ9Gn68r65C0NEt2+3nGB7
         JPZ0AkR6Y+91KBhxeovxdNVUfOoEw7X2smv8ZeFuZcYdrBRd80H/+FpFstn10c980HEg
         SxeA==
X-Forwarded-Encrypted: i=1; AJvYcCXYSyHvSBBuB0ekGZWM0OQ5jbyuMMPAo9Kqnbpbbo4esrHujOUQ9sais8MLLNaUmg4AePw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD5TLUipxS59/9K2r/l1uFAxH/BjYsOyE3LA6OrMfBd3BD4Yki
	J2zGqaQRg6afd4iJ6oZRKduuz7YYgp1xWKUJAXOre0r1KqcLcgwAbOR14Fu4dNiSzFk=
X-Gm-Gg: ASbGncu9soS783G2i1Q0hOKvazSaJx41aRurja/jqwG8Az+JeF60VbezRpSHJT1EiuZ
	TKpl8yZ7ax6yN2/6sw6CULdwUJRTeqgu2bzJFzphXtN3r2rm3UoFgiCm+SA8b45onuJ0FDEOgdL
	a2uaMMBva3SuA/l3Sw4D/LI3PLSKVm7lbMeXPbLaFOI7vHzy8QHQk0+xuddQ8LVt8ICw9Ah5yYW
	oMXgsFGCwhnODtkV1nWst/54VbGvlrfJkcgxci/QuJCYhehaIQ0Qj97KZ6szrVV+certq1gS9Bt
	JCFAm/I+e/QPuQmt7Q0hnQ2FyD6vAtJZKIPsePlPSdY3FyaNzCsu1q4LZqR7FAfQlVsoFOxZ9H9
	kOTxhEfNrs2/qQbn4T0mtlR0CVfV5KTzQetqc1w==
X-Google-Smtp-Source: AGHT+IFz3e1ntqjNO1Li+kLYqmbgAsr0uEr0UDFV5QwNps+7VApXi86JZ/fZAMhsoeN1Ap5x/7nhoQ==
X-Received: by 2002:a05:6214:4283:b0:6e8:f433:20a8 with SMTP id 6a1803df08f44-6fd5ef29729mr1069556d6.9.1750791506488;
        Tue, 24 Jun 2025 11:58:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd095ca02bsm59491686d6.125.2025.06.24.11.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 11:58:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uU8qf-00000000tXN-2UjT;
	Tue, 24 Jun 2025 15:58:25 -0300
Date: Tue, 24 Jun 2025 15:58:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, peterx@redhat.com,
	kbusch@kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: print vfio-device name to fdinfo
Message-ID: <20250624185825.GA213144@ziepe.ca>
References: <20250624181616.GE72557@ziepe.ca>
 <20250624185327.1250843-1-amastro@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624185327.1250843-1-amastro@fb.com>

On Tue, Jun 24, 2025 at 11:53:25AM -0700, Alex Mastro wrote:
> On Tue, 24 Jun 2025 15:16:16 -0300 Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > There will be a symlink under /sys/class/vfio-xx/XX pointing to the
> > <pci sysfs path>/vfio-dev/X directory
> > 
> > And another symlink under /sys/dev/char/XX:XX doing the same.
> 
> Got it, thanks. The issue does seem solved for the vfio cdev case, then.

I wonder if we could arrange things so that if the cdev path is turned
on then the device FD created by the ioctl would report the same
/dev/vfio/X information? I've never looked at how this works, but
maybe it is easy?

Even if userspace is not using the cdev it does exist and is still
logically affiliated with the ioctl FD.

Then we'd have a nice consistent user experience.

Jason

