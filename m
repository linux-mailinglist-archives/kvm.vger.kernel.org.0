Return-Path: <kvm+bounces-65762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 611CACB5D5A
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 13:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C67C3021F99
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 12:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021E6314A84;
	Thu, 11 Dec 2025 12:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bYU8sAeJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10C5314A67
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 12:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765455930; cv=none; b=Wz12oyL9LBM61Y8/pYYAtcmknjTck4ox6Pl2m4LKXHUD+V6EnTKaUoOc23xsrM3z+GexQQjqNHGh/6HlsaKpoL0iTMS2Ro9XcZ0nWBaJXCL+0tx7FxXzz1Ao7N9X/kRaTzCgtR1xZ7kZO/tXoQkilxfZBLZmnehArniprd+8Vj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765455930; c=relaxed/simple;
	bh=aOtuXnTfqOMAngbaaz25nPyALHmVxaoeNEeieMFWJz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8RxZ1JcuVS8bteYFaD2lGuA+HWKD60nZ0VtyjdfSoF+6v0whLQeHR0huUaqj4f5vslOzKadaTzO6b5pl3SPEqH0aQoMVrbn2IN6PqLklSam/1pWcvOogdqkDblDy3mO4KwtSm7bElfcW7vELMfzl0K8WWl/nt+T7INRDPDjhmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bYU8sAeJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765455927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h/io9ePCWvclwNV6MNExqM/JG4bMpOq3UaR/Q+cLvog=;
	b=bYU8sAeJn5E66wKvs56LG61uCcLE1NDweQoD1GMFG7cVgCP7GUDjA1ZX1ULnc4ARAZyCA0
	1h09yUzICqGg6lNReQ1HYNjwsPuTc3sGnovYQfGf1qjiAHmyMSh8nOHRvHBch9hSFetqWg
	kLzYbjUkBvCt+QYk4J/ZTJ3LL69Y330=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-C4fm7-9aPQ2PuW5EiOLX1g-1; Thu,
 11 Dec 2025 07:25:24 -0500
X-MC-Unique: C4fm7-9aPQ2PuW5EiOLX1g-1
X-Mimecast-MFC-AGG-ID: C4fm7-9aPQ2PuW5EiOLX1g_1765455923
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 445A41956050;
	Thu, 11 Dec 2025 12:25:23 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.32.156])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91DB81956056;
	Thu, 11 Dec 2025 12:25:22 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 5BAFE1800608; Thu, 11 Dec 2025 13:25:20 +0100 (CET)
Date: Thu, 11 Dec 2025 13:25:20 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: Luigi Leonardi <leonardi@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v2 3/3] igvm: Fill MADT IGVM parameter field
Message-ID: <42cieknma6qfpezpu22jlwlw7yugsyxezkgo6d47fdntpfmmtg@km3ns7xdv4qj>
References: <20251211103136.1578463-1-osteffen@redhat.com>
 <20251211103136.1578463-4-osteffen@redhat.com>
 <h4256m67shwdq4aouxpqadb2zozhq2f5dfeo74c5jnet5f26kz@a3av5xjfyfow>
 <wcqcwrshe6nmz3lb5bz2ucdydwgsfxlxbua5jfaly677zsgy4h@dy3nypkedwhi>
 <CA+bRGFo=bxbKPCkG6cWY9RH501F8NF4yxZk_hu6Vqi6NkFLK_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+bRGFo=bxbKPCkG6cWY9RH501F8NF4yxZk_hu6Vqi6NkFLK_Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  Hi,

> > >  (b) pass MachineState instead of ConfidentialGuestSupport, so
> > >      we can use the MachineState here to generate the madt.
> > >
> > >Luigi, any opinion?  I think device tree support will need access to
> > >MachineState too, and I think both madt and dt should take the same
> > >approach here.
> >
> > I have a slight preference over MachineState as it's more generic and we
> > don't need to add more fields in IgvmCfg for new features.
> >
> Passing in MachineState would be easy, but do we really want to add machine
> related logic (building of ACPI tables, and later maybe device trees)
> into the igvm backend?

Good point.  That clearly speaks for (b).  There already is
MachineState->fdt, filled in by machine code.  We can let machine code
store the madt in MachineState too, and the have the igvm code simply
pick it up from there.

take care,
  Gerd


