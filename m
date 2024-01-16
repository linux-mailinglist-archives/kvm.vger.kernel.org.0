Return-Path: <kvm+bounces-6354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 140B682F450
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 19:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F16A1C21774
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 18:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600E51CFBB;
	Tue, 16 Jan 2024 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eV3BeAJC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F9B1CFAB
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705429999; cv=none; b=urYEYAwgFQm974+IdSxb+u/jA5fwYR2OAzO8i+AQS/l4ROhj7wXpgWySv6nHf/ix9PxYCvzcYffKCnMtWAsrr6/gAalUcliJ3Lyh2dxfh5vIVil1cnqn6rLFywgJcCR+DjCW71OuKsqQzLu2Yh/p/xb3oVDIcCZCjuno4Bugh1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705429999; c=relaxed/simple;
	bh=JwNvuHi5CpdeD9Q7CbYVbQzkcZ5+AVv/Usz1r2vNrkw=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Received:
	 X-Google-Smtp-Source:X-Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding; b=f4NKM/FiNJzIqjHwnF7jTUoLZ/FEuEcxMpaLvKdP3VwFerV3qmhUviaY4e6ksmPvL5BR4SUTr1re6rK5Cz3a5vFKwM2/L8HtbW2wqw4sydobk/Pvm3jREClJTwVdkxcH66uAwLB8Wj3kbacBrF6+bxm7vfj7V/TJ7A7Xe310QzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eV3BeAJC; arc=none smtp.client-ip=170.10.129.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705429997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FISaMlvGT4jM9D2WMtxVsmws03Og0Eq0GceC6awRLlY=;
	b=eV3BeAJChmeh0fy45XyFfXqFCBrzEXV/WFuMTT+IFixlQg6EvBwLaCCHZfvePlU9nqwZNL
	cRZSXIGqIzvg3y3I6bJWn5OmDD7f5YH7OLH8xyDsZPH+eO0ToCtQ7p2I3EY+r4A2do3o0I
	HBsKWQajkhhJV5liewytYyHWk3wY5MQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-AANZa9soNgiqy6Y5cVvflA-1; Tue, 16 Jan 2024 13:33:10 -0500
X-MC-Unique: AANZa9soNgiqy6Y5cVvflA-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bf4c4559daso164289239f.2
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 10:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705429990; x=1706034790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FISaMlvGT4jM9D2WMtxVsmws03Og0Eq0GceC6awRLlY=;
        b=E2tW52ympnjgzFwUy8OXmrmpLtIbZOwfRt9aYIrxqWu9IwUx6uMieVynCaF/FWbrl1
         7Pn9J8CBcdKFqngxGH70HwTxf7Rp67l94AI2GsfsOBltMCB4yuuj9rFYSdCM1/8lxHgE
         Oxy363gTWsPfnR1TWWgIoZrlaCchLk3s6gk2v3mkZnxpf31CnvX9e/UybAizoPRxSSEc
         UQxkGG12Di+CQvQ9h54Oca3UWa0iDZsQyAP+ANlGf8hcBrfMNfK35NpzJO45A15ic4fh
         dwDw85rstfB9952AoEHTmydEcOaGBPJU8lpTHGYrvj0K+Yk6LBxcX0VBnPWX1zkEZm8x
         w7WA==
X-Gm-Message-State: AOJu0YyecMS6jTRRpPcjWA9PI+Pl0xw/JnZC4GS1IKK4tNghS6+bX/aw
	yy7ZlTQL3GGTuSlTJHTOeS0at7mzJr3y9dztYMZcVKcpHKU7QqK5RQlVyS5ULkXwLUq8K+VVBL7
	gyLxqW8AW23wWyNS2lonB
X-Received: by 2002:a5d:8c9a:0:b0:7bf:4694:6c36 with SMTP id g26-20020a5d8c9a000000b007bf46946c36mr4546969ion.9.1705429990000;
        Tue, 16 Jan 2024 10:33:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErDazX7NWGFXtbf/P4jQZuCg4zJCLsr6AAXK6x7UHmTrzfxIKGZgBT8q7U2HRZ1DI6P7MRHA==
X-Received: by 2002:a5d:8c9a:0:b0:7bf:4694:6c36 with SMTP id g26-20020a5d8c9a000000b007bf46946c36mr4546960ion.9.1705429989777;
        Tue, 16 Jan 2024 10:33:09 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id bm7-20020a05663842c700b0046e41dace9csm3020396jab.30.2024.01.16.10.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 10:33:09 -0800 (PST)
Date: Tue, 16 Jan 2024 11:33:08 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: vfio/platform: Use common error handling code in
 vfio_set_trigger()
Message-ID: <20240116113308.78935e11.alex.williamson@redhat.com>
In-Reply-To: <ab6bcd8b-f53c-47d1-8c55-c374a36d6ee4@web.de>
References: <f1977c1c-1c55-4194-9f72-f77120b2e4e5@web.de>
	<20240115133756.674ae019.alex.williamson@redhat.com>
	<ab6bcd8b-f53c-47d1-8c55-c374a36d6ee4@web.de>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 Jan 2024 12:32:23 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> > TBH, this doesn't seem like a worthwhile exit point consolidation.  A
> > change like this might be justified if there were some common unlock
> > code that could be shared, but for a simple free and return errno by
> > jumping to a different exception block, rather than even a common exit
> > block, I don't see the value.  
> 
> Can it be helpful to store the shown kfree() call only once
> in this function implementation?

I don't believe it's worthwhile, it's a simple function with simple
exit paths and consolidating those exit paths for a trivial kfree() is
unnecessarily complex.  Thanks,

Alex


