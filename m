Return-Path: <kvm+bounces-58389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BE0B923E4
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1749E3AD753
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53FE311940;
	Mon, 22 Sep 2025 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="tQDwZCWH"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B6931076D
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758558877; cv=none; b=oq2EBUvDw81qFWopSUsOR5edk2vPaIElQnCxnPt9cPkNDovXXRrvFBhA43nglHW2IIlDsXpclHi9JnLAQpvDm5c6BxBI//wBA0GvKcApGvy9jneSza/ubMsMFt3g7s4hLWQl1mfOiBoYsEDV/vtyB9TYAHVfs5XpxdaKwB54wYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758558877; c=relaxed/simple;
	bh=hjdnJzdKSt8NGbwPqkHmAQsngHX58c3MRvMnp4o9Dk0=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=nR5iXAkBYwOzSFmcxtSL9isgbTMFB96rhgChRoxThLr2BgVyOIEcL6tqEiLRljVR2bGOBTcLMqyCYMWzSG/MBTGTeb5FvnFhGV/kUquPBqxJOCUIy64eD+FBsztBKmgQ9+NCzXS0xjPnY+a76ymH8OdK4VF4LuKS7qg7d7y24aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=tQDwZCWH; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 098098288B69;
	Mon, 22 Sep 2025 11:34:27 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id oD4Q81DzPA_R; Mon, 22 Sep 2025 11:34:26 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 26F418288E8C;
	Mon, 22 Sep 2025 11:34:26 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 26F418288E8C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1758558866; bh=oh6ToL73ZIttgcBjSxTRevOJAHtVa1GDM5kUqX1ToS8=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=tQDwZCWHuxMYtZdafLa6Cu+lqnsEMdqWJImPr32Nj5WgSz8uaQAofsbVosLn4REnv
	 D9gJqy8+mJ7LwRMeQbnNUYw9OfBom9dPdd2PM2/N/mBABRvUu2t2sUjBDcZJNF9INA
	 sIlTTyIXaYgrXQoj9wWPf33dyaL+IiZhvZR8Ce78=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lju9L-zpfO1L; Mon, 22 Sep 2025 11:34:26 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id EFE838288B69;
	Mon, 22 Sep 2025 11:34:25 -0500 (CDT)
Date: Mon, 22 Sep 2025 11:34:23 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Timothy Pearson <tpearson@raptorengineering.com>, kvm <kvm@vger.kernel.org>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <456215532.1742889.1758558863369.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <20250922100143.1397e28b.alex.williamson@redhat.com>
References: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com> <20250919125603.08f600ac.alex.williamson@redhat.com> <1916735949.1739694.1758315074669.JavaMail.zimbra@raptorengineeringinc.com> <20250919162721.7a38d3e2.alex.williamson@redhat.com> <537354829.1740670.1758396303861.JavaMail.zimbra@raptorengineeringinc.com> <20250922100143.1397e28b.alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI
 devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC139 (Linux)/8.5.0_GA_3042)
Thread-Topic: vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices
Thread-Index: vhXA6uJOAuHvEGJHjXX23Z2oDpkEew==



----- Original Message -----
> From: "Alex Williamson" <alex.williamson@redhat.com>
> To: "Timothy Pearson" <tpearson@raptorengineering.com>
> Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> Sent: Monday, September 22, 2025 11:01:43 AM
> Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices

> On Sat, 20 Sep 2025 14:25:03 -0500 (CDT)
> Timothy Pearson <tpearson@raptorengineering.com> wrote:
>> Personally, I'd argue that such old devices were intended to work
>> with much slower host systems, therefore the slowdown probably
>> doesn't matter vs. being more correct in terms of interrupt handling.
>>  In terms of general kernel design, my understanding has always been
>> is that best practice is to always mask, disable, or clear a level
>> interrupt before exiting the associated IRQ handler, and the current
>> design seems to violate that rule.  In that context, I'd personally
>> want to see an argument as to why echewing this traditional IRQ
>> handler design is beneficial enough to justify making the VFIO driver
>> dependent on platform-specific behavior.
> 
> Yep, I kind of agree.  The unlazy flag seems to provide the more
> intended behavior.  It moves the irq chip masking into the fast path,
> whereas it would have been asynchronous on a subsequent interrupt
> previously, but the impact is only to ancient devices operating in INTx
> mode, so as long as we can verify those still work on both ppc and x86,
> I don't think it's worth complicating the code to make setting the
> unlazy flag conditional on anything other than the device support.
> 
> Care to send out a new version documenting the actual sequence fixed by
> this change and updating the code based on this thread?  Note that we
> can test non-pci2.3 mode for any device/driver that supports INTx using
> the nointxmask=1 option for vfio-pci and booting a linux guest with
> pci=nomsi.  Thanks,
> 
> Alex

Sure, I can update the commit message easily enough, but I must have missed something in regard to a needed code update.  The existing patch only sets unlazy for non-PCI 2.3 INTX devices, and as I understand it that's the behavior we have both agreed on at this point?

I've tested this on ppc64el and it works quite well, repairing the broken behavior where the guest would receive exactly one interrupt on the legacy PCI device per boot.  I don't have amd64 systems available to test on, however.

Thanks!

