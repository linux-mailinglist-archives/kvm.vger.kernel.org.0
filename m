Return-Path: <kvm+bounces-65096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C19C9AE1B
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 10:35:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 24E993471A2
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 09:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D7E30DD1F;
	Tue,  2 Dec 2025 09:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KXnsnVGn"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572D8309F01;
	Tue,  2 Dec 2025 09:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668146; cv=none; b=Wh4vIZYRek5AsLDxjzsUHpXKiXKxRUCBvujzSJy6XFDBRa0k3Kj/Q9Wz+GnwbxysmqnxdVJyASRg3MCeNeNcdOgGJcmDu6VBqpr6rz9buJMwjpL5ykdXkeXzecXIv5ImiVnSmZ/l64moYbycbbHRZvqsAhS5A8jeOdv1CzFGe3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668146; c=relaxed/simple;
	bh=pLXNm4QkTmgw804rKW5u4uJZWA2pKZi2v+NzykhPkok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdtCuA9yqcFVPH3MXnVXuzZcv9gmiRpIDj1iTBIhgX6tmceCyb38Kmx1wKdMq/8D6HiRtevnUjxpxhnICLiyo13sTk01sp8nfBPZQTVmtnDFkkpWTp5N9Eyuo6325g/hlOOJLHEWwK/mNyOLpOxiIpTknH9E4NO4GGtrLg3TAa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KXnsnVGn; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=pLXNm4QkTmgw804rKW5u4uJZWA2pKZi2v+NzykhPkok=; b=KXnsnVGnHq94kuMnOc33s0IGLf
	LtM2utXc44UJ6tYxUq/Yzz/luwe7Qu8bdxyWMpOxVH0Ari7y2mCzLzhnm5vzuB2cYI3MASWyhlkNx
	Nhugh0uLuKsOnIQRMsZ9dGMCdJAfkDFCMewfjiMXyZRjUmxX8uBJF/QRkdTTomOlAcFOCiAaL6VOc
	k5LAjGgV6/D8EVtPaCaBbQZo95XhZO5GZOC7oHA65/9ErBKof6mmdNTUbE0tW/QaoEP+bdy2CfbwR
	b7h+FFlWMeVZKPmJx7EnnENStNUyyZx9xCycZ2TtGOPhrQ7BXYzNYKnNJL6xVJrKxi28l4awqKSox
	jIbEfDfA==;
Received: from 2001-1c00-8d82-9800-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d82:9800:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQLvk-0000000Ha8f-00Wz;
	Tue, 02 Dec 2025 08:40:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1B0E530027B; Tue, 02 Dec 2025 10:35:35 +0100 (CET)
Date: Tue, 2 Dec 2025 10:35:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Woodhouse, David" <dwmw@amazon.co.uk>
Cc: "Sieber, Fernand" <sieberf@amazon.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Saenz Julienne, Nicolas" <nsaenz@amazon.es>,
	"Busse, Anselm" <abusse@amazon.de>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	=?iso-8859-1?Q?Sch=F6nherr=2C_Jan_H=2E?= <jschoenh@amazon.de>,
	"Borghorst, Hendrik" <hborghor@amazon.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>
Subject: Re: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
Message-ID: <20251202093534.GA2458571@noisy.programming.kicks-ass.net>
References: <20251201142359.344741-1-sieberf@amazon.com>
 <0ce1757e3267df037912b303f60c662c45d0a6e6.camel@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <0ce1757e3267df037912b303f60c662c45d0a6e6.camel@amazon.co.uk>

On Mon, Dec 01, 2025 at 02:45:01PM +0000, Woodhouse, David wrote:
> On Mon, 2025-12-01 at 16:23 +0200, Fernand Sieber wrote
> > Perf considers the combination of PERF_COUNT_HW_BRANCH_INSTRUCTIONS with
> > a sample_period of 1 a special case and handles this as a BTS event (see
> > intel_pmu_has_bts_period()) -- a deviation from the usual semantic,
> > where the sample_period represents the amount of branch instructions to
> > encounter before the overflow handler is invoked.
>=20
> That's kind of awful, and seems to be the real underlying cause of the KVM
> issue. Can we kill it with fire? Peter?

Well, IIRC it gives the same information and was actually less expensive
to run, seeing how BTS can buffer the data rather than having to take an
interrupt on every event.

But its been ages since this was done.

Now arguably it should not be done for this kvm stuff, because the
data-store buffers don't virtualize (just like old PEBS).


